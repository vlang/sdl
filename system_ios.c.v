// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

// Platform specific functions for iOS

pub type IOSAnimationCallback = fn (params voidptr)

fn C.SDL_iOSSetAnimationCallback(window &C.SDL_Window, interval int, callback IOSAnimationCallback, callbackParam voidptr) int
pub fn ios_set_animation_callback(window &Window, interval int, callback IOSAnimationCallback, callback_param voidptr) int {
	return C.SDL_iOSSetAnimationCallback(window, interval, callback, callback_param)
}

fn C.SDL_iPhoneSetAnimationCallback(window &C.SDL_Window, interval int, callback IOSAnimationCallback, callback_param voidptr) int

// iphone_set_animation_callback sets the animation callback on Apple iOS.
//
// The function prototype for `callback` is:
//
// ```c
// void callback(void* callbackParam);
// ```
//
// Where its parameter, `callbackParam`, is what was passed as `callbackParam`
// to SDL_iPhoneSetAnimationCallback().
//
// This function is only available on Apple iOS.
//
// For more information see:
// [README-ios.md](https://hg.libsdl.org/SDL/file/default/docs/README-ios.md)
//
// This functions is also accessible using the macro
// SDL_iOSSetAnimationCallback() since SDL 2.0.4.
//
// `window` the window for which the animation callback should be set
// `interval` the number of frames after which **callback** will be
//                 called
// `callback` the function to call for every frame.
// `callbackParam` a pointer that is passed to `callback`.
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_iPhoneSetEventPump
pub fn iphone_set_animation_callback(window &Window, interval int, callback IOSAnimationCallback, callback_param voidptr) int {
	return C.SDL_iPhoneSetAnimationCallback(window, interval, callback, callback_param)
}

fn C.SDL_iOSSetEventPump(enabled)
pub fn ios_set_event_pump(enabled bool) {
	C.SDL_iOSSetEventPump(enabled)
}

fn C.SDL_iPhoneSetEventPump(enabled bool)

// iphone_set_event_pump uses this function to enable or disable the SDL event pump on Apple iOS.
//
// This function is only available on Apple iOS.
//
// This functions is also accessible using the macro SDL_iOSSetEventPump()
// since SDL 2.0.4.
//
// `enabled` SDL_TRUE to enable the event pump, SDL_FALSE to disable it
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_iPhoneSetAnimationCallback
pub fn iphone_set_event_pump(enabled bool) {
	C.SDL_iPhoneSetEventPump(enabled)
}

fn C.SDL_OnApplicationDidChangeStatusBarOrientation()
pub fn on_application_did_change_status_bar_orientation() {
	C.SDL_OnApplicationDidChangeStatusBarOrientation()
}
