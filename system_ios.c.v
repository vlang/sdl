// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

// Platform specific functions for iOS

type iOSAnimationCallback = fn (params voidptr)

fn C.SDL_iOSSetAnimationCallback(window &C.SDL_Window, interval int, callback iOSAnimationCallback, callbackParam voidptr) int
pub fn iphone_set_animation_callback(window &Window, interval int, callback iOSAnimationCallback, callback_param voidptr) int {
	return C.SDL_iOSSetAnimationCallback(window, interval, callback, callback_param)
}

fn C.SDL_iPhoneSetAnimationCallback(window &C.SDL_Window, interval int, callback iOSAnimationCallback, callback_param voidptr) int
pub fn iphone_set_animation_callback(window &Window, interval int, callback iOSAnimationCallback, callback_param voidptr) int {
	return C.SDL_iPhoneSetAnimationCallback(window, interval, callback, callback_param)
}

fn C.SDL_iOSSetEventPump(enabled)
pub fn ios_set_event_pump(enabled bool) {
	C.SDL_iOSSetEventPump(enabled)
}

fn C.SDL_iPhoneSetEventPump(enabled bool)
pub fn iphone_set_event_pump(enabled bool) {
	C.SDL_iPhoneSetEventPump(enabled)
}
