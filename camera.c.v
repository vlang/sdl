// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_camera.h
//

// Video capture for the SDL library.
//
// This API lets apps read input from video sources, like webcams. Camera
// devices can be enumerated, queried, and opened. Once opened, it will
// provide SDL_Surface objects as new frames of video come in. These surfaces
// can be uploaded to an SDL_Texture or processed as pixels in memory.
//
// Several platforms will alert the user if an app tries to access a camera,
// and some will present a UI asking the user if your application should be
// allowed to obtain images at all, which they can deny. A successfully opened
// camera will not provide images until permission is granted. Applications,
// after opening a camera device, can see if they were granted access by
// either polling with the SDL_GetCameraPermissionState() function, or waiting
// for an SDL_EVENT_CAMERA_DEVICE_APPROVED or SDL_EVENT_CAMERA_DEVICE_DENIED
// event. Platforms that don't have any user approval process will report
// approval immediately.
//
// Note that SDL cameras only provide video as individual frames; they will
// not provide full-motion video encoded in a movie file format, although an
// app is free to encode the acquired frames into any format it likes. It also
// does not provide audio from the camera hardware through this API; not only
// do many webcams not have microphones at all, many people--from streamers to
// people on Zoom calls--will want to use a separate microphone regardless of
// the camera. In any case, recorded audio will be available through SDL's
// audio API no matter what hardware provides the microphone.
//
// ## Camera gotchas
//
// Consumer-level camera hardware tends to take a little while to warm up,
// once the device has been opened. Generally most camera apps have some sort
// of UI to take a picture (a button to snap a pic while a preview is showing,
// some sort of multi-second countdown for the user to pose, like a photo
// booth), which puts control in the users' hands, or they are intended to
// stay on for long times (Pokemon Go, etc).
//
// It's not uncommon that a newly-opened camera will provide a couple of
// completely black frames, maybe followed by some under-exposed images. If
// taking a single frame automatically, or recording video from a camera's
// input without the user initiating it from a preview, it could be wise to
// drop the first several frames (if not the first several _seconds_ worth of
// frames!) before using images from a camera.

// This is a unique ID for a camera device for the time it is connected to the
// system, and is never reused for the lifetime of the application.
//
// If the device is disconnected and reconnected, it will get a new ID.
//
// The value 0 is an invalid ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: get_cameras (SDL_GetCameras)
pub type CameraID = u32

@[noinit; typedef]
pub struct C.SDL_Camera {
	// NOTE: Opaque type
}

pub type Camera = C.SDL_Camera

@[typedef]
pub struct C.SDL_CameraSpec {
pub mut:
	format                PixelFormat // Frame format
	colorspace            Colorspace  // Frame colorspace
	width                 int         // Frame width
	height                int         // Frame height
	framerate_numerator   int         // Frame rate numerator ((num / denom) == FPS, (denom / num) == duration in seconds)
	framerate_denominator int         // Frame rate demoninator ((num / denom) == FPS, (denom / num) == duration in seconds)
}

pub type CameraSpec = C.SDL_CameraSpec

// CameraPosition is C.SDL_CameraPosition
pub enum CameraPosition {
	unknown      = C.SDL_CAMERA_POSITION_UNKNOWN
	front_facing = C.SDL_CAMERA_POSITION_FRONT_FACING
	back_facing  = C.SDL_CAMERA_POSITION_BACK_FACING
}

// C.SDL_GetNumCameraDrivers [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumCameraDrivers)
fn C.SDL_GetNumCameraDrivers() int

// get_num_camera_drivers uses this function to get the number of built-in camera drivers.
//
// This function returns a hardcoded number. This never returns a negative
// value; if there are no drivers compiled into this build of SDL, this
// function returns zero. The presence of a driver in this list does not mean
// it will function, it just means SDL is capable of interacting with that
// interface. For example, a build of SDL might have v4l2 support, but if
// there's no kernel support available, SDL's v4l2 driver would fail if used.
//
// By default, SDL tries all drivers, in its preferred order, until one is
// found to be usable.
//
// returns the number of built-in camera drivers.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_camera_driver (SDL_GetCameraDriver)
pub fn get_num_camera_drivers() int {
	return C.SDL_GetNumCameraDrivers()
}

// C.SDL_GetCameraDriver [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCameraDriver)
fn C.SDL_GetCameraDriver(index int) &char

// get_camera_driver uses this function to get the name of a built in camera driver.
//
// The list of camera drivers is given in the order that they are normally
// initialized by default; the drivers that seem more reasonable to choose
// first (as far as the SDL developers believe) are earlier in the list.
//
// The names of drivers are all simple, low-ASCII identifiers, like "v4l2",
// "coremedia" or "android". These never have Unicode characters, and are not
// meant to be proper names.
//
// `index` index the index of the camera driver; the value ranges from 0 to
//              SDL_GetNumCameraDrivers() - 1.
// returns the name of the camera driver at the requested index, or NULL if
//          an invalid index was specified.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_camera_drivers (SDL_GetNumCameraDrivers)
pub fn get_camera_driver(index int) &char {
	return C.SDL_GetCameraDriver(index)
}

// C.SDL_GetCurrentCameraDriver [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCurrentCameraDriver)
fn C.SDL_GetCurrentCameraDriver() &char

// get_current_camera_driver gets the name of the current camera driver.
//
// The names of drivers are all simple, low-ASCII identifiers, like "v4l2",
// "coremedia" or "android". These never have Unicode characters, and are not
// meant to be proper names.
//
// returns the name of the current camera driver or NULL if no driver has
//          been initialized.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_current_camera_driver() &char {
	return C.SDL_GetCurrentCameraDriver()
}

// C.SDL_GetCameras [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCameras)
fn C.SDL_GetCameras(count &int) CameraID

// get_cameras gets a list of currently connected camera devices.
//
// `count` count a pointer filled in with the number of cameras returned, may
//              be NULL.
// returns a 0 terminated array of camera instance IDs or NULL on failure;
//          call SDL_GetError() for more information. This should be freed
//          with SDL_free() when it is no longer needed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_camera (SDL_OpenCamera)
pub fn get_cameras(count &int) CameraID {
	return C.SDL_GetCameras(count)
}

// C.SDL_GetCameraSupportedFormats [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCameraSupportedFormats)
fn C.SDL_GetCameraSupportedFormats(devid CameraID, count &int) &&C.SDL_CameraSpec

// get_camera_supported_formats gets the list of native formats/sizes a camera supports.
//
// This returns a list of all formats and frame sizes that a specific camera
// can offer. This is useful if your app can accept a variety of image formats
// and sizes and so want to find the optimal spec that doesn't require
// conversion.
//
// This function isn't strictly required; if you call SDL_OpenCamera with a
// NULL spec, SDL will choose a native format for you, and if you instead
// specify a desired format, it will transparently convert to the requested
// format on your behalf.
//
// If `count` is not NULL, it will be filled with the number of elements in
// the returned array.
//
// Note that it's legal for a camera to supply an empty list. This is what
// will happen on Emscripten builds, since that platform won't tell _anything_
// about available cameras until you've opened one, and won't even tell if
// there _is_ a camera until the user has given you permission to check
// through a scary warning popup.
//
// `devid` devid the camera device instance ID to query.
// `count` count a pointer filled in with the number of elements in the list,
//              may be NULL.
// returns a NULL terminated array of pointers to SDL_CameraSpec or NULL on
//          failure; call SDL_GetError() for more information. This is a
//          single allocation that should be freed with SDL_free() when it is
//          no longer needed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_cameras (SDL_GetCameras)
// See also: open_camera (SDL_OpenCamera)
pub fn get_camera_supported_formats(devid CameraID, count &int) &&C.SDL_CameraSpec {
	return C.SDL_GetCameraSupportedFormats(devid, count)
}

// C.SDL_GetCameraName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCameraName)
fn C.SDL_GetCameraName(instance_id CameraID) &char

// get_camera_name gets the human-readable device name for a camera.
//
// `instance_id` instance_id the camera device instance ID.
// returns a human-readable device name or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_cameras (SDL_GetCameras)
pub fn get_camera_name(instance_id CameraID) &char {
	return C.SDL_GetCameraName(instance_id)
}

// C.SDL_GetCameraPosition [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCameraPosition)
fn C.SDL_GetCameraPosition(instance_id CameraID) CameraPosition

// get_camera_position gets the position of the camera in relation to the system.
//
// Most platforms will report UNKNOWN, but mobile devices, like phones, can
// often make a distinction between cameras on the front of the device (that
// points towards the user, for taking "selfies") and cameras on the back (for
// filming in the direction the user is facing).
//
// `instance_id` instance_id the camera device instance ID.
// returns the position of the camera on the system hardware.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_cameras (SDL_GetCameras)
pub fn get_camera_position(instance_id CameraID) CameraPosition {
	return C.SDL_GetCameraPosition(instance_id)
}

// C.SDL_OpenCamera [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenCamera)
fn C.SDL_OpenCamera(instance_id CameraID, const_spec &CameraSpec) &Camera

// open_camera opens a video recording device (a "camera").
//
// You can open the device with any reasonable spec, and if the hardware can't
// directly support it, it will convert data seamlessly to the requested
// format. This might incur overhead, including scaling of image data.
//
// If you would rather accept whatever format the device offers, you can pass
// a NULL spec here and it will choose one for you (and you can use
// SDL_Surface's conversion/scaling functions directly if necessary).
//
// You can call SDL_GetCameraFormat() to get the actual data format if passing
// a NULL spec here. You can see the exact specs a device can support without
// conversion with SDL_GetCameraSupportedFormats().
//
// SDL will not attempt to emulate framerate; it will try to set the hardware
// to the rate closest to the requested speed, but it won't attempt to limit
// or duplicate frames artificially; call SDL_GetCameraFormat() to see the
// actual framerate of the opened the device, and check your timestamps if
// this is crucial to your app!
//
// Note that the camera is not usable until the user approves its use! On some
// platforms, the operating system will prompt the user to permit access to
// the camera, and they can choose Yes or No at that point. Until they do, the
// camera will not be usable. The app should either wait for an
// SDL_EVENT_CAMERA_DEVICE_APPROVED (or SDL_EVENT_CAMERA_DEVICE_DENIED) event,
// or poll SDL_GetCameraPermissionState() occasionally until it returns
// non-zero. On platforms that don't require explicit user approval (and
// perhaps in places where the user previously permitted access), the approval
// event might come immediately, but it might come seconds, minutes, or hours
// later!
//
// `instance_id` instance_id the camera device instance ID.
// `spec` spec the desired format for data the device will provide. Can be
//             NULL.
// returns an SDL_Camera object or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_cameras (SDL_GetCameras)
// See also: get_camera_format (SDL_GetCameraFormat)
pub fn open_camera(instance_id CameraID, const_spec &CameraSpec) &Camera {
	return C.SDL_OpenCamera(instance_id, const_spec)
}

// C.SDL_GetCameraPermissionState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCameraPermissionState)
fn C.SDL_GetCameraPermissionState(camera &Camera) int

// get_camera_permission_state querys if camera access has been approved by the user.
//
// Cameras will not function between when the device is opened by the app and
// when the user permits access to the hardware. On some platforms, this
// presents as a popup dialog where the user has to explicitly approve access;
// on others the approval might be implicit and not alert the user at all.
//
// This function can be used to check the status of that approval. It will
// return 0 if still waiting for user response, 1 if the camera is approved
// for use, and -1 if the user denied access.
//
// Instead of polling with this function, you can wait for a
// SDL_EVENT_CAMERA_DEVICE_APPROVED (or SDL_EVENT_CAMERA_DEVICE_DENIED) event
// in the standard SDL event loop, which is guaranteed to be sent once when
// permission to use the camera is decided.
//
// If a camera is declined, there's nothing to be done but call
// SDL_CloseCamera() to dispose of it.
//
// `camera` camera the opened camera device to query.
// returns -1 if user denied access to the camera, 1 if user approved access,
//          0 if no decision has been made yet.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_camera (SDL_OpenCamera)
// See also: close_camera (SDL_CloseCamera)
pub fn get_camera_permission_state(camera &Camera) int {
	return C.SDL_GetCameraPermissionState(camera)
}

// C.SDL_GetCameraID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCameraID)
fn C.SDL_GetCameraID(camera &Camera) CameraID

// get_camera_id gets the instance ID of an opened camera.
//
// `camera` camera an SDL_Camera to query.
// returns the instance ID of the specified camera on success or 0 on
//          failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_camera (SDL_OpenCamera)
pub fn get_camera_id(camera &Camera) CameraID {
	return C.SDL_GetCameraID(camera)
}

// C.SDL_GetCameraProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCameraProperties)
fn C.SDL_GetCameraProperties(camera &Camera) PropertiesID

// get_camera_properties gets the properties associated with an opened camera.
//
// `camera` camera the SDL_Camera obtained from SDL_OpenCamera().
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_camera_properties(camera &Camera) PropertiesID {
	return C.SDL_GetCameraProperties(camera)
}

// C.SDL_GetCameraFormat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCameraFormat)
fn C.SDL_GetCameraFormat(camera &Camera, spec &CameraSpec) bool

// get_camera_format gets the spec that a camera is using when generating images.
//
// Note that this might not be the native format of the hardware, as SDL might
// be converting to this format behind the scenes.
//
// If the system is waiting for the user to approve access to the camera, as
// some platforms require, this will return false, but this isn't necessarily
// a fatal error; you should either wait for an
// SDL_EVENT_CAMERA_DEVICE_APPROVED (or SDL_EVENT_CAMERA_DEVICE_DENIED) event,
// or poll SDL_GetCameraPermissionState() occasionally until it returns
// non-zero.
//
// `camera` camera opened camera device.
// `spec` spec the SDL_CameraSpec to be initialized by this function.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_camera (SDL_OpenCamera)
pub fn get_camera_format(camera &Camera, spec &CameraSpec) bool {
	return C.SDL_GetCameraFormat(camera, spec)
}

// C.SDL_AcquireCameraFrame [official documentation](https://wiki.libsdl.org/SDL3/SDL_AcquireCameraFrame)
fn C.SDL_AcquireCameraFrame(camera &Camera, timestamp_ns &u64) &Surface

// acquire_camera_frame acquires a frame.
//
// The frame is a memory pointer to the image data, whose size and format are
// given by the spec requested when opening the device.
//
// This is a non blocking API. If there is a frame available, a non-NULL
// surface is returned, and timestampNS will be filled with a non-zero value.
//
// Note that an error case can also return NULL, but a NULL by itself is
// normal and just signifies that a new frame is not yet available. Note that
// even if a camera device fails outright (a USB camera is unplugged while in
// use, etc), SDL will send an event separately to notify the app, but
// continue to provide blank frames at ongoing intervals until
// SDL_CloseCamera() is called, so real failure here is almost always an out
// of memory condition.
//
// After use, the frame should be released with SDL_ReleaseCameraFrame(). If
// you don't do this, the system may stop providing more video!
//
// Do not call SDL_DestroySurface() on the returned surface! It must be given
// back to the camera subsystem with SDL_ReleaseCameraFrame!
//
// If the system is waiting for the user to approve access to the camera, as
// some platforms require, this will return NULL (no frames available); you
// should either wait for an SDL_EVENT_CAMERA_DEVICE_APPROVED (or
// SDL_EVENT_CAMERA_DEVICE_DENIED) event, or poll
// SDL_GetCameraPermissionState() occasionally until it returns non-zero.
//
// `camera` camera opened camera device.
// `timestamp_ns` timestampNS a pointer filled in with the frame's timestamp, or 0 on
//                    error. Can be NULL.
// returns a new frame of video on success, NULL if none is currently
//          available.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: release_camera_frame (SDL_ReleaseCameraFrame)
pub fn acquire_camera_frame(camera &Camera, timestamp_ns &u64) &Surface {
	return C.SDL_AcquireCameraFrame(camera, timestamp_ns)
}

// C.SDL_ReleaseCameraFrame [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReleaseCameraFrame)
fn C.SDL_ReleaseCameraFrame(camera &Camera, frame &Surface)

// release_camera_frame releases a frame of video acquired from a camera.
//
// Let the back-end re-use the internal buffer for camera.
//
// This function _must_ be called only on surface objects returned by
// SDL_AcquireCameraFrame(). This function should be called as quickly as
// possible after acquisition, as SDL keeps a small FIFO queue of surfaces for
// video frames; if surfaces aren't released in a timely manner, SDL may drop
// upcoming video frames from the camera.
//
// If the app needs to keep the surface for a significant time, they should
// make a copy of it and release the original.
//
// The app should not use the surface again after calling this function;
// assume the surface is freed and the pointer is invalid.
//
// `camera` camera opened camera device.
// `frame` frame the video frame surface to release.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: acquire_camera_frame (SDL_AcquireCameraFrame)
pub fn release_camera_frame(camera &Camera, frame &Surface) {
	C.SDL_ReleaseCameraFrame(camera, frame)
}

// C.SDL_CloseCamera [official documentation](https://wiki.libsdl.org/SDL3/SDL_CloseCamera)
fn C.SDL_CloseCamera(camera &Camera)

// close_camera uses this function to shut down camera processing and close the camera
// device.
//
// `camera` camera opened camera device.
//
// NOTE: (thread safety) It is safe to call this function from any thread, but no
//               thread may reference `device` once this function is called.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_camera (SDL_OpenCamera)
pub fn close_camera(camera &Camera) {
	C.SDL_CloseCamera(camera)
}
