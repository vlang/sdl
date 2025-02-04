// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

// IOSAnimationCallback thes prototype for an Apple iOS animation callback.
//
// This datatype is only useful on Apple iOS.
//
// After passing a function pointer of this type to
// SDL_SetiOSAnimationCallback, the system will call that function pointer at
// a regular interval.
//
// `userdata` userdata what was passed as `callbackParam` to
//                 SDL_SetiOSAnimationCallback as `callbackParam`.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: seti_os_animation_callback (SDL_SetiOSAnimationCallback)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_IOSAnimationCallback)
pub type IOSAnimationCallback = fn (userdata voidptr)

// C.SDL_SetiOSAnimationCallback [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetiOSAnimationCallback)
fn C.SDL_SetiOSAnimationCallback(window &Window, interval int, callback IOSAnimationCallback, callback_param voidptr) bool

// set_ios_animation_callbackos_animation_callback uses this function to set the animation callback on Apple iOS.
//
// The function prototype for `callback` is:
//
// ```c
// void callback(void *callbackParam);
// ```
//
// Where its parameter, `callbackParam`, is what was passed as `callbackParam`
// to SDL_SetiOSAnimationCallback().
//
// This function is only available on Apple iOS.
//
// For more information see:
//
// https://wiki.libsdl.org/SDL3/README/ios
//
// Note that if you use the "main callbacks" instead of a standard C `main`
// function, you don't have to use this API, as SDL will manage this for you.
//
// Details on main callbacks are here:
//
// https://wiki.libsdl.org/SDL3/README/main-functions
//
// `window` window the window for which the animation callback should be set.
// `interval` interval the number of frames after which **callback** will be
//                 called.
// `callback` callback the function to call for every frame.
// `callback_param` callbackParam a pointer that is passed to `callback`.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: seti_os_event_pump (SDL_SetiOSEventPump)
pub fn set_ios_animation_callback(window &Window, interval int, callback IOSAnimationCallback, callback_param voidptr) bool {
	return C.SDL_SetiOSAnimationCallback(window, interval, callback, callback_param)
}

// C.SDL_SetiOSEventPump [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetiOSEventPump)
fn C.SDL_SetiOSEventPump(enabled bool)

// set_ios_event_pump uses this function to enable or disable the SDL event pump on Apple iOS.
//
// This function is only available on Apple iOS.
//
// `enabled` enabled true to enable the event pump, false to disable it.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: seti_os_animation_callback (SDL_SetiOSAnimationCallback)
pub fn set_ios_event_pump(enabled bool) {
	C.SDL_SetiOSEventPump(enabled)
}
