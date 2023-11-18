// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_hidapi.h
//

@[typedef]
pub struct C.SDL_hid_device {
}

// HidDevice is a handle representing an open HID device
// HidDevice is C.SDL_hid_device
pub type HidDevice = C.SDL_hid_device

@[typedef]
pub struct C.SDL_hid_device_info {
	// Platform-specific device path
	path &char
	// Device Vendor ID
	vendor_id u16
	// Device Product ID
	product_id u16
	// Serial Number
	serial_number &u16 // NOTE wchar_t* in C
	// Device Release Number in binary-coded decimal,
	// also known as Device Version Number
	release_number u16
	// Manufacturer String
	manufacturer_string &u16 // NOTE wchar_t* in C
	// Product string
	product_string &u16 // NOTE wchar_t* in C
	// Usage Page for this Device/Interface
	// (Windows/Mac only).
	usage_page u16
	// Usage for this Device/Interface
	// (Windows/Mac only).
	usage u16
	// The USB interface which this logical device
	// represents.
	//
	// * Valid on both Linux implementations in all cases.
	// * Valid on the Windows implementation only if the device
	//   contains more than one interface.
	interface_number int
	// Additional information about the USB interface.
	// Valid on libusb and Android implementations.
	interface_class    int
	interface_subclass int
	interface_protocol int
	// Pointer to the next device
	next &HidDeviceInfo
}

// HidDeviceInfo carries information about a connected HID device
// HidDeviceInfo is C.SDL_hid_device_info
pub type HidDeviceInfo = C.SDL_hid_device_info

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
// returns 0 on success and -1 on error.
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_hid_exit
pub fn hid_init() int {
	return C.SDL_hid_init()
}

fn C.SDL_hid_exit() int

// hid_exit finalizes the HIDAPI library.
//
// This function frees all of the static data associated with HIDAPI. It
// should be called at the end of execution to avoid memory leaks.
//
// returns 0 on success and -1 on error.
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_hid_init
pub fn hid_exit() int {
	return C.SDL_hid_exit()
}

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
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_hid_enumerate
pub fn hid_device_change_count() u32 {
	return C.SDL_hid_device_change_count()
}

fn C.SDL_hid_enumerate(vendor_id u16, product_id u16) &C.SDL_hid_device_info

// hid_enumerate enumerates the HID Devices.
//
// This function returns a linked list of all the HID devices attached to the
// system which match vendor_id and product_id. If `vendor_id` is set to 0
// then any vendor matches. If `product_id` is set to 0 then any product
// matches. If `vendor_id` and `product_id` are both set to 0, then all HID
// devices will be returned.
//
// `vendor_id` The Vendor ID (VID) of the types of device to open.
// `product_id` The Product ID (PID) of the types of device to open.
// returns a pointer to a linked list of type SDL_hid_device_info, containing
//          information about the HID devices attached to the system, or NULL
//          in the case of failure. Free this linked list by calling
//          SDL_hid_free_enumeration().
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_hid_device_change_count
pub fn hid_enumerate(vendor_id u16, product_id u16) &HidDeviceInfo {
	return C.SDL_hid_enumerate(vendor_id, product_id)
}

fn C.SDL_hid_free_enumeration(devs &C.SDL_hid_device_info)

// hid_free_enumeration frees an enumeration Linked List
//
// This function frees a linked list created by SDL_hid_enumerate().
//
// `devs` Pointer to a list of struct_device returned from
//             SDL_hid_enumerate().
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_free_enumeration(devs &HidDeviceInfo) {
	C.SDL_hid_free_enumeration(devs)
}

fn C.SDL_hid_open(vendor_id u16, product_id u16, const_serial_number &C.wchar_t) &C.SDL_hid_device

// hid_open opens a HID device using a Vendor ID (VID), Product ID (PID) and optionally
// a serial number.
//
// If `serial_number` is NULL, the first device with the specified VID and PID
// is opened.
//
// `vendor_id` The Vendor ID (VID) of the device to open.
// `product_id` The Product ID (PID) of the device to open.
// `serial_number` The Serial Number of the device to open (Optionally
//                      NULL).
// returns a pointer to a SDL_hid_device object on success or NULL on
//          failure.
//
// NOTE This function is available since SDL 2.0.18.
//
// NOTE const_serial_number is &C.wchar_t in C
// Use 'V string'.to_wide() to pass a V string as the `const_serial_number` argument
pub fn hid_open(vendor_id u16, product_id u16, const_serial_number &u16) &HidDevice {
	return C.SDL_hid_open(vendor_id, product_id, &C.wchar_t(voidptr(const_serial_number)))
}

fn C.SDL_hid_open_path(const_path &char, b_exclusive int) &C.SDL_hid_device

// Open a HID device by its path name.
//
// The path name be determined by calling SDL_hid_enumerate(), or a
// platform-specific path name can be used (eg: /dev/hidraw0 on Linux).
//
// `path` The path name of the device to open
// returns a pointer to a SDL_hid_device object on success or NULL on
//          failure.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_open_path(const_path &char, b_exclusive int) &HidDevice {
	return C.SDL_hid_open_path(const_path, b_exclusive)
}

fn C.SDL_hid_write(dev &C.SDL_hid_device, const_data &u8, length usize) int

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
// `dev` A device handle returned from SDL_hid_open().
// `data` The data to send, including the report number as the first
//             byte.
// `length` The length in bytes of the data to send.
// returns the actual number of bytes written and -1 on error.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_write(dev &HidDevice, const_data &u8, length usize) int {
	return C.SDL_hid_write(dev, const_data, length)
}

fn C.SDL_hid_read_timeout(dev &C.SDL_hid_device, data &u8, length usize, milliseconds int) int

// hid_read_timeout reads an Input report from a HID device with timeout.
//
// Input reports are returned to the host through the INTERRUPT IN endpoint.
// The first byte will contain the Report number if the device uses numbered
// reports.
//
// `dev` A device handle returned from SDL_hid_open().
// `data` A buffer to put the read data into.
// `length` The number of bytes to read. For devices with multiple
//               reports, make sure to read an extra byte for the report
//               number.
// `milliseconds` timeout in milliseconds or -1 for blocking wait.
// returns the actual number of bytes read and -1 on error. If no packet was
//          available to be read within the timeout period, this function
//          returns 0.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_read_timeout(dev &HidDevice, data &u8, length usize, milliseconds int) int {
	return C.SDL_hid_read_timeout(dev, data, length, milliseconds)
}

fn C.SDL_hid_read(dev &C.SDL_hid_device, data &u8, length usize) int

// hid_read reads an Input report from a HID device.
//
// Input reports are returned to the host through the INTERRUPT IN endpoint.
// The first byte will contain the Report number if the device uses numbered
// reports.
//
// `dev` A device handle returned from SDL_hid_open().
// `data` A buffer to put the read data into.
// `length` The number of bytes to read. For devices with multiple
//               reports, make sure to read an extra byte for the report
//               number.
// returns the actual number of bytes read and -1 on error. If no packet was
//          available to be read and the handle is in non-blocking mode, this
//          function returns 0.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_read(dev &HidDevice, data &u8, length usize) int {
	return C.SDL_hid_read(dev, data, length)
}

fn C.SDL_hid_set_nonblocking(dev &C.SDL_hid_device, nonblock int) int

// hid_set_nonblocking sets the device handle to be non-blocking.
//
// In non-blocking mode calls to SDL_hid_read() will return immediately with a
// value of 0 if there is no data to be read. In blocking mode, SDL_hid_read()
// will wait (block) until there is data to read before returning.
//
// Nonblocking can be turned on and off at any time.
//
// `dev` A device handle returned from SDL_hid_open().
// `nonblock` enable or not the nonblocking reads - 1 to enable
//                 nonblocking - 0 to disable nonblocking.
// returns 0 on success and -1 on error.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_set_nonblocking(dev &HidDevice, nonblock int) int {
	return C.SDL_hid_set_nonblocking(dev, nonblock)
}

fn C.SDL_hid_send_feature_report(dev &C.SDL_hid_device, const_data &u8, length usize) int

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
// `dev` A device handle returned from SDL_hid_open().
// `data` The data to send, including the report number as the first
//             byte.
// `length` The length in bytes of the data to send, including the report
//               number.
// returns the actual number of bytes written and -1 on error.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_send_feature_report(dev &HidDevice, const_data &u8, length usize) int {
	return C.SDL_hid_send_feature_report(dev, const_data, length)
}

fn C.SDL_hid_get_feature_report(dev &C.SDL_hid_device, data &u8, length usize) int

// hid_get_feature_report gets a feature report from a HID device.
//
// Set the first byte of `data` to the Report ID of the report to be read.
// Make sure to allow space for this extra byte in `data`. Upon return, the
// first byte will still contain the Report ID, and the report data will start
// in data[1].
//
// `dev` A device handle returned from SDL_hid_open().
// `data` A buffer to put the read data into, including the Report ID.
//             Set the first byte of `data` to the Report ID of the report to
//             be read, or set it to zero if your device does not use numbered
//             reports.
// `length` The number of bytes to read, including an extra byte for the
//               report ID. The buffer can be longer than the actual report.
// returns the number of bytes read plus one for the report ID (which is
//          still in the first byte), or -1 on error.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_get_feature_report(dev &HidDevice, data &u8, length usize) int {
	return C.SDL_hid_get_feature_report(dev, data, length)
}

fn C.SDL_hid_close(dev &C.SDL_hid_device)

// hid_close closes a HID device.
//
// `dev` A device handle returned from SDL_hid_open().
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_close(dev &HidDevice) {
	C.SDL_hid_close(dev)
}

fn C.SDL_hid_get_manufacturer_string(dev &C.SDL_hid_device, string_ &C.wchar_t, maxlen usize) int

// hid_get_manufacturer_string gets The Manufacturer String from a HID device.
//
// `dev` A device handle returned from SDL_hid_open().
// `string` A wide string buffer to put the data into.
// `maxlen` The length of the buffer in multiples of wchar_t.
// returns 0 on success and -1 on error.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_get_manufacturer_string(dev &HidDevice, string_ &u16, maxlen usize) int {
	return C.SDL_hid_get_manufacturer_string(dev, &C.wchar_t(voidptr(string_)), maxlen)
}

fn C.SDL_hid_get_product_string(dev &C.SDL_hid_device, string_ &C.wchar_t, maxlen usize) int

// hid_get_product_string gets The Product String from a HID device.
//
// `dev` A device handle returned from SDL_hid_open().
// `string` A wide string buffer to put the data into.
// `maxlen` The length of the buffer in multiples of wchar_t.
// returns 0 on success and -1 on error.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_get_product_string(dev &HidDevice, string_ &u16, maxlen usize) int {
	return C.SDL_hid_get_product_string(dev, &C.wchar_t(voidptr(string_)), maxlen)
}

fn C.SDL_hid_get_serial_number_string(dev &C.SDL_hid_device, string_ &C.wchar_t, maxlen usize) int

// hid_get_serial_number_string gets The Serial Number String from a HID device.
//
// `dev` A device handle returned from SDL_hid_open().
// `string` A wide string buffer to put the data into.
// `maxlen` The length of the buffer in multiples of wchar_t.
// returns 0 on success and -1 on error.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_get_serial_number_string(dev &HidDevice, string_ &u16, maxlen usize) int {
	return C.SDL_hid_get_serial_number_string(dev, &C.wchar_t(voidptr(string_)), maxlen)
}

fn C.SDL_hid_get_indexed_string(dev &C.SDL_hid_device, string_index int, string_ &C.wchar_t, maxlen usize) int

// hid_get_indexed_string gets a string from a HID device, based on its string index.
//
// `dev` A device handle returned from SDL_hid_open().
// `string_index` The index of the string to get.
// `string` A wide string buffer to put the data into.
// `maxlen` The length of the buffer in multiples of wchar_t.
// returns 0 on success and -1 on error.
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_get_indexed_string(dev &C.SDL_hid_device, string_index int, string_ &u16, maxlen usize) int {
	return C.SDL_hid_get_indexed_string(dev, string_index, &C.wchar_t(voidptr(string_)),
		maxlen)
}

fn C.SDL_hid_ble_scan(active bool)

// hid_ble_scan starts or stop a BLE scan on iOS and tvOS to pair Steam Controllers
//
// `active` SDL_TRUE to start the scan, SDL_FALSE to stop the scan
//
// NOTE This function is available since SDL 2.0.18.
pub fn hid_ble_scan(active bool) {
	C.SDL_hid_ble_scan(active)
}
