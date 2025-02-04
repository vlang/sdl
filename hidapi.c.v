// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_hidapi.h
//

// Header file for SDL HIDAPI functions.
//
// This is an adaptation of the original HIDAPI interface by Alan Ott, and
// includes source code licensed under the following license:
//
// ```
// HIDAPI - Multi-Platform library for
// communication with HID devices.
//
// Copyright 2009, Alan Ott, Signal 11 Software.
// All Rights Reserved.
//
// This software may be used by anyone for any reason so
// long as the copyright notice in the source files
// remains intact.
// ```
//
// (Note that this license is the same as item three of SDL's zlib license, so
// it adds no new requirements on the user.)
//
// If you would like a version of SDL without this code, you can build SDL
// with SDL_HIDAPI_DISABLED defined to 1. You might want to do this for
// example on iOS or tvOS to avoid a dependency on the CoreBluetooth
// framework.

@[noinit; typedef]
pub struct C.SDL_hid_device {
	// NOTE: Opaque type
}

pub type HidDevice = C.SDL_hid_device

// HidBusType is C.SDL_hid_bus_type
pub enum HidBusType {
	// 0x00, * Unknown bus type
	unknown = C.SDL_HID_API_BUS_UNKNOWN
	// 0x01, * USB bus
	// Specifications:
	// https://usb.org/hid
	usb = C.SDL_HID_API_BUS_USB
	// 0x02, * Bluetooth or Bluetooth LE bus
	// Specifications:
	// https://www.bluetooth.com/specifications/specs/human-interface-device-profile-1-1-1/
	// https://www.bluetooth.com/specifications/specs/hid-service-1-0/
	// https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-1-0/
	bluetooth = C.SDL_HID_API_BUS_BLUETOOTH
	// 0x03, * I2C bus
	// Specifications:
	// https://docs.microsoft.com/previous-versions/windows/hardware/design/dn642101(v=vs.85)
	i2c = C.SDL_HID_API_BUS_I2C
	// 0x04, * SPI bus
	// Specifications:
	// https://www.microsoft.com/download/details.aspx?id=103325
	spi = C.SDL_HID_API_BUS_SPI
}

@[typedef]
pub struct C.SDL_hid_device_info {
pub mut:
	path                &char = unsafe { nil } // * Platform-specific device path
	vendor_id           u16 // Device Vendor ID
	product_id          u16 // Device Product ID
	serial_number       &WCharT = unsafe { nil } // Serial Number
	release_number      u16 // Device Release Number in binary-coded decimal, also known as Device Version Number
	manufacturer_string &WCharT = unsafe { nil } // Manufacturer String
	product_string      &WCharT = unsafe { nil } // Product string
	usage_page          u16 // Usage Page for this Device/Interface (Windows/Mac/hidraw only)
	usage               u16 // Usage for this Device/Interface (Windows/Mac/hidraw only)
	// The USB interface which this logical device
	// represents.
	//
	// Valid only if the device is a USB HID device.
	// Set to -1 in all other cases.
	interface_number int
	// Additional information about the USB interface. Valid on libusb and Android implementations.
	interface_class    int
	interface_subclass int
	interface_protocol int
	bus_type           HidBusType // * Underlying bus type
	next               &HidDeviceInfo = unsafe { nil } // Pointer to the next device
}

pub type HidDeviceInfo = C.SDL_hid_device_info

// C.SDL_hid_init [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_init)
fn C.SDL_hid_init() int

// hid_init initializes the HIDAPI library.
//
// This function initializes the HIDAPI library. Calling it is not strictly
// necessary, as it will be called automatically by SDL_hid_enumerate() and
// any of the SDL_hid_open_*() functions if it is needed. This function should
// be called at the beginning of execution however, if there is a chance of
// HIDAPI handles being opened by different threads simultaneously.
//
// Each call to this function should have a matching call to SDL_hid_exit()
//
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: hid_exit (SDL_hid_exit)
pub fn hid_init() int {
	return C.SDL_hid_init()
}

// C.SDL_hid_exit [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_exit)
fn C.SDL_hid_exit() int

// hid_exit finalizes the HIDAPI library.
//
// This function frees all of the static data associated with HIDAPI. It
// should be called at the end of execution to avoid memory leaks.
//
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: hid_init (SDL_hid_init)
pub fn hid_exit() int {
	return C.SDL_hid_exit()
}

// C.SDL_hid_device_change_count [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_device_change_count)
fn C.SDL_hid_device_change_count() u32

// hid_device_change_count checks to see if devices may have been added or removed.
//
// Enumerating the HID devices is an expensive operation, so you can call this
// to see if there have been any system device changes since the last call to
// this function. A change in the counter returned doesn't necessarily mean
// that anything has changed, but you can call SDL_hid_enumerate() to get an
// updated device list.
//
// Calling this function for the first time may cause a thread or other system
// resource to be allocated to track device change notifications.
//
// returns a change counter that is incremented with each potential device
//          change, or 0 if device change detection isn't available.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: hid_enumerate (SDL_hid_enumerate)
pub fn hid_device_change_count() u32 {
	return C.SDL_hid_device_change_count()
}

// C.SDL_hid_enumerate [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_enumerate)
fn C.SDL_hid_enumerate(vendor_id u16, product_id u16) &HidDeviceInfo

// hid_enumerate enumerates the HID Devices.
//
// This function returns a linked list of all the HID devices attached to the
// system which match vendor_id and product_id. If `vendor_id` is set to 0
// then any vendor matches. If `product_id` is set to 0 then any product
// matches. If `vendor_id` and `product_id` are both set to 0, then all HID
// devices will be returned.
//
// By default SDL will only enumerate controllers, to reduce risk of hanging
// or crashing on bad drivers, but SDL_HINT_HIDAPI_ENUMERATE_ONLY_CONTROLLERS
// can be set to "0" to enumerate all HID devices.
//
// `vendor_id` vendor_id the Vendor ID (VID) of the types of device to open, or 0
//                  to match any vendor.
// `product_id` product_id the Product ID (PID) of the types of device to open, or 0
//                   to match any product.
// returns a pointer to a linked list of type SDL_hid_device_info, containing
//          information about the HID devices attached to the system, or NULL
//          in the case of failure. Free this linked list by calling
//          SDL_hid_free_enumeration().
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: hid_device_change_count (SDL_hid_device_change_count)
pub fn hid_enumerate(vendor_id u16, product_id u16) &HidDeviceInfo {
	return C.SDL_hid_enumerate(vendor_id, product_id)
}

// C.SDL_hid_free_enumeration [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_free_enumeration)
fn C.SDL_hid_free_enumeration(devs &HidDeviceInfo)

// hid_free_enumeration frees an enumeration linked list.
//
// This function frees a linked list created by SDL_hid_enumerate().
//
// `devs` devs pointer to a list of struct_device returned from
//             SDL_hid_enumerate().
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_free_enumeration(devs &HidDeviceInfo) {
	C.SDL_hid_free_enumeration(devs)
}

// C.SDL_hid_open [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_open)
fn C.SDL_hid_open(vendor_id u16, product_id u16, const_serial_number &WCharT) &HidDevice

// hid_open opens a HID device using a Vendor ID (VID), Product ID (PID) and optionally
// a serial number.
//
// If `serial_number` is NULL, the first device with the specified VID and PID
// is opened.
//
// `vendor_id` vendor_id the Vendor ID (VID) of the device to open.
// `product_id` product_id the Product ID (PID) of the device to open.
// `serial_number` serial_number the Serial Number of the device to open (Optionally
//                      NULL).
// returns a pointer to a SDL_hid_device object on success or NULL on
//          failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_open(vendor_id u16, product_id u16, const_serial_number &WCharT) &HidDevice {
	return C.SDL_hid_open(vendor_id, product_id, const_serial_number)
}

// C.SDL_hid_open_path [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_open_path)
fn C.SDL_hid_open_path(const_path &char) &HidDevice

// hid_open_path opens a HID device by its path name.
//
// The path name be determined by calling SDL_hid_enumerate(), or a
// platform-specific path name can be used (eg: /dev/hidraw0 on Linux).
//
// `path` path the path name of the device to open.
// returns a pointer to a SDL_hid_device object on success or NULL on
//          failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_open_path(const_path &char) &HidDevice {
	return C.SDL_hid_open_path(const_path)
}

// C.SDL_hid_write [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_write)
fn C.SDL_hid_write(dev &HidDevice, const_data &u8, length usize) int

// hid_write writes an Output report to a HID device.
//
// The first byte of `data` must contain the Report ID. For devices which only
// support a single report, this must be set to 0x0. The remaining bytes
// contain the report data. Since the Report ID is mandatory, calls to
// SDL_hid_write() will always contain one more byte than the report contains.
// For example, if a hid report is 16 bytes long, 17 bytes must be passed to
// SDL_hid_write(), the Report ID (or 0x0, for devices with a single report),
// followed by the report data (16 bytes). In this example, the length passed
// in would be 17.
//
// SDL_hid_write() will send the data on the first OUT endpoint, if one
// exists. If it does not, it will send the data through the Control Endpoint
// (Endpoint 0).
//
// `dev` dev a device handle returned from SDL_hid_open().
// `data` data the data to send, including the report number as the first
//             byte.
// `length` length the length in bytes of the data to send.
// returns the actual number of bytes written and -1 on on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_write(dev &HidDevice, const_data &u8, length usize) int {
	return C.SDL_hid_write(dev, const_data, length)
}

// C.SDL_hid_read_timeout [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_read_timeout)
fn C.SDL_hid_read_timeout(dev &HidDevice, data &u8, length usize, milliseconds int) int

// hid_read_timeout reads an Input report from a HID device with timeout.
//
// Input reports are returned to the host through the INTERRUPT IN endpoint.
// The first byte will contain the Report number if the device uses numbered
// reports.
//
// `dev` dev a device handle returned from SDL_hid_open().
// `data` data a buffer to put the read data into.
// `length` length the number of bytes to read. For devices with multiple
//               reports, make sure to read an extra byte for the report
//               number.
// `milliseconds` milliseconds timeout in milliseconds or -1 for blocking wait.
// returns the actual number of bytes read and -1 on on failure; call
//          SDL_GetError() for more information. If no packet was available to
//          be read within the timeout period, this function returns 0.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_read_timeout(dev &HidDevice, data &u8, length usize, milliseconds int) int {
	return C.SDL_hid_read_timeout(dev, data, length, milliseconds)
}

// C.SDL_hid_read [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_read)
fn C.SDL_hid_read(dev &HidDevice, data &u8, length usize) int

// hid_read reads an Input report from a HID device.
//
// Input reports are returned to the host through the INTERRUPT IN endpoint.
// The first byte will contain the Report number if the device uses numbered
// reports.
//
// `dev` dev a device handle returned from SDL_hid_open().
// `data` data a buffer to put the read data into.
// `length` length the number of bytes to read. For devices with multiple
//               reports, make sure to read an extra byte for the report
//               number.
// returns the actual number of bytes read and -1 on failure; call
//          SDL_GetError() for more information. If no packet was available to
//          be read and the handle is in non-blocking mode, this function
//          returns 0.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_read(dev &HidDevice, data &u8, length usize) int {
	return C.SDL_hid_read(dev, data, length)
}

// C.SDL_hid_set_nonblocking [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_set_nonblocking)
fn C.SDL_hid_set_nonblocking(dev &HidDevice, nonblock int) int

// hid_set_nonblocking sets the device handle to be non-blocking.
//
// In non-blocking mode calls to SDL_hid_read() will return immediately with a
// value of 0 if there is no data to be read. In blocking mode, SDL_hid_read()
// will wait (block) until there is data to read before returning.
//
// Nonblocking can be turned on and off at any time.
//
// `dev` dev a device handle returned from SDL_hid_open().
// `nonblock` nonblock enable or not the nonblocking reads - 1 to enable
//                 nonblocking - 0 to disable nonblocking.
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_set_nonblocking(dev &HidDevice, nonblock int) int {
	return C.SDL_hid_set_nonblocking(dev, nonblock)
}

// C.SDL_hid_send_feature_report [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_send_feature_report)
fn C.SDL_hid_send_feature_report(dev &HidDevice, const_data &u8, length usize) int

// hid_send_feature_report sends a Feature report to the device.
//
// Feature reports are sent over the Control endpoint as a Set_Report
// transfer. The first byte of `data` must contain the Report ID. For devices
// which only support a single report, this must be set to 0x0. The remaining
// bytes contain the report data. Since the Report ID is mandatory, calls to
// SDL_hid_send_feature_report() will always contain one more byte than the
// report contains. For example, if a hid report is 16 bytes long, 17 bytes
// must be passed to SDL_hid_send_feature_report(): the Report ID (or 0x0, for
// devices which do not use numbered reports), followed by the report data (16
// bytes). In this example, the length passed in would be 17.
//
// `dev` dev a device handle returned from SDL_hid_open().
// `data` data the data to send, including the report number as the first
//             byte.
// `length` length the length in bytes of the data to send, including the report
//               number.
// returns the actual number of bytes written and -1 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_send_feature_report(dev &HidDevice, const_data &u8, length usize) int {
	return C.SDL_hid_send_feature_report(dev, const_data, length)
}

// C.SDL_hid_get_feature_report [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_get_feature_report)
fn C.SDL_hid_get_feature_report(dev &HidDevice, data &u8, length usize) int

// hid_get_feature_report gets a feature report from a HID device.
//
// Set the first byte of `data` to the Report ID of the report to be read.
// Make sure to allow space for this extra byte in `data`. Upon return, the
// first byte will still contain the Report ID, and the report data will start
// in data[1].
//
// `dev` dev a device handle returned from SDL_hid_open().
// `data` data a buffer to put the read data into, including the Report ID.
//             Set the first byte of `data` to the Report ID of the report to
//             be read, or set it to zero if your device does not use numbered
//             reports.
// `length` length the number of bytes to read, including an extra byte for the
//               report ID. The buffer can be longer than the actual report.
// returns the number of bytes read plus one for the report ID (which is
//          still in the first byte), or -1 on on failure; call SDL_GetError()
//          for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_get_feature_report(dev &HidDevice, data &u8, length usize) int {
	return C.SDL_hid_get_feature_report(dev, data, length)
}

// C.SDL_hid_get_input_report [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_get_input_report)
fn C.SDL_hid_get_input_report(dev &HidDevice, data &u8, length usize) int

// hid_get_input_report gets an input report from a HID device.
//
// Set the first byte of `data` to the Report ID of the report to be read.
// Make sure to allow space for this extra byte in `data`. Upon return, the
// first byte will still contain the Report ID, and the report data will start
// in data[1].
//
// `dev` dev a device handle returned from SDL_hid_open().
// `data` data a buffer to put the read data into, including the Report ID.
//             Set the first byte of `data` to the Report ID of the report to
//             be read, or set it to zero if your device does not use numbered
//             reports.
// `length` length the number of bytes to read, including an extra byte for the
//               report ID. The buffer can be longer than the actual report.
// returns the number of bytes read plus one for the report ID (which is
//          still in the first byte), or -1 on on failure; call SDL_GetError()
//          for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_get_input_report(dev &HidDevice, data &u8, length usize) int {
	return C.SDL_hid_get_input_report(dev, data, length)
}

// C.SDL_hid_close [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_close)
fn C.SDL_hid_close(dev &HidDevice) int

// hid_close closes a HID device.
//
// `dev` dev a device handle returned from SDL_hid_open().
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_close(dev &HidDevice) int {
	return C.SDL_hid_close(dev)
}

// C.SDL_hid_get_manufacturer_string [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_get_manufacturer_string)
fn C.SDL_hid_get_manufacturer_string(dev &HidDevice, str &WCharT, maxlen usize) int

// hid_get_manufacturer_string gets The Manufacturer String from a HID device.
//
// `dev` dev a device handle returned from SDL_hid_open().
// `string` string a wide string buffer to put the data into.
// `maxlen` maxlen the length of the buffer in multiples of wchar_t.
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_get_manufacturer_string(dev &HidDevice, str &WCharT, maxlen usize) int {
	return C.SDL_hid_get_manufacturer_string(dev, str, maxlen)
}

// C.SDL_hid_get_product_string [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_get_product_string)
fn C.SDL_hid_get_product_string(dev &HidDevice, str &WCharT, maxlen usize) int

// hid_get_product_string gets The Product String from a HID device.
//
// `dev` dev a device handle returned from SDL_hid_open().
// `string` string a wide string buffer to put the data into.
// `maxlen` maxlen the length of the buffer in multiples of wchar_t.
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_get_product_string(dev &HidDevice, str &WCharT, maxlen usize) int {
	return C.SDL_hid_get_product_string(dev, str, maxlen)
}

// C.SDL_hid_get_serial_number_string [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_get_serial_number_string)
fn C.SDL_hid_get_serial_number_string(dev &HidDevice, str &WCharT, maxlen usize) int

// hid_get_serial_number_string gets The Serial Number String from a HID device.
//
// `dev` dev a device handle returned from SDL_hid_open().
// `string` string a wide string buffer to put the data into.
// `maxlen` maxlen the length of the buffer in multiples of wchar_t.
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_get_serial_number_string(dev &HidDevice, str &WCharT, maxlen usize) int {
	return C.SDL_hid_get_serial_number_string(dev, str, maxlen)
}

// C.SDL_hid_get_indexed_string [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_get_indexed_string)
fn C.SDL_hid_get_indexed_string(dev &HidDevice, string_index int, str &WCharT, maxlen usize) int

// hid_get_indexed_string gets a string from a HID device, based on its string index.
//
// `dev` dev a device handle returned from SDL_hid_open().
// `string_index` string_index the index of the string to get.
// `string` string a wide string buffer to put the data into.
// `maxlen` maxlen the length of the buffer in multiples of wchar_t.
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_get_indexed_string(dev &HidDevice, string_index int, str &WCharT, maxlen usize) int {
	return C.SDL_hid_get_indexed_string(dev, string_index, str, maxlen)
}

// C.SDL_hid_get_device_info [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_get_device_info)
fn C.SDL_hid_get_device_info(dev &HidDevice) &HidDeviceInfo

// hid_get_device_info gets the device info from a HID device.
//
// `dev` dev a device handle returned from SDL_hid_open().
// returns a pointer to the SDL_hid_device_info for this hid_device or NULL
//          on failure; call SDL_GetError() for more information. This struct
//          is valid until the device is closed with SDL_hid_close().
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_get_device_info(dev &HidDevice) &HidDeviceInfo {
	return C.SDL_hid_get_device_info(dev)
}

// C.SDL_hid_get_report_descriptor [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_get_report_descriptor)
fn C.SDL_hid_get_report_descriptor(dev &HidDevice, buf &u8, buf_size usize) int

// hid_get_report_descriptor gets a report descriptor from a HID device.
//
// User has to provide a preallocated buffer where descriptor will be copied
// to. The recommended size for a preallocated buffer is 4096 bytes.
//
// `dev` dev a device handle returned from SDL_hid_open().
// `buf` buf the buffer to copy descriptor into.
// `buf_size` buf_size the size of the buffer in bytes.
// returns the number of bytes actually copied or -1 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_get_report_descriptor(dev &HidDevice, buf &u8, buf_size usize) int {
	return C.SDL_hid_get_report_descriptor(dev, buf, buf_size)
}

// C.SDL_hid_ble_scan [official documentation](https://wiki.libsdl.org/SDL3/SDL_hid_ble_scan)
fn C.SDL_hid_ble_scan(active bool)

// hid_ble_scan starts or stop a BLE scan on iOS and tvOS to pair Steam Controllers.
//
// `active` active true to start the scan, false to stop the scan.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn hid_ble_scan(active bool) {
	C.SDL_hid_ble_scan(active)
}
