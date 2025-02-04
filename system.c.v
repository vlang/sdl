// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

// Platform-specific SDL API functions. These are functions that deal with
// needs of specific operating systems, that didn't make sense to offer as
// platform-independent, generic APIs.
//
// Most apps can make do without these functions, but they can be useful for
// integrating with other parts of a specific system, adding platform-specific
// polish to an app, or solving problems that only affect one target.

// C.SDL_IsTablet [official documentation](https://wiki.libsdl.org/SDL3/SDL_IsTablet)
fn C.SDL_IsTablet() bool

// is_tablet querys if the current device is a tablet.
//
// If SDL can't determine this, it will return false.
//
// returns true if the device is a tablet, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn is_tablet() bool {
	return C.SDL_IsTablet()
}

// C.SDL_IsTV [official documentation](https://wiki.libsdl.org/SDL3/SDL_IsTV)
fn C.SDL_IsTV() bool

// is_tv querys if the current device is a TV.
//
// If SDL can't determine this, it will return false.
//
// returns true if the device is a TV, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn is_tv() bool {
	return C.SDL_IsTV()
}

// Sandbox is C.SDL_Sandbox
pub enum Sandbox {
	@none             = C.SDL_SANDBOX_NONE // 0,
	unknown_container = C.SDL_SANDBOX_UNKNOWN_CONTAINER
	flatpak           = C.SDL_SANDBOX_FLATPAK
	snap              = C.SDL_SANDBOX_SNAP
	macos             = C.SDL_SANDBOX_MACOS
}

// C.SDL_GetSandbox [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSandbox)
fn C.SDL_GetSandbox() Sandbox

// get_sandbox gets the application sandbox environment, if any.
//
// returns the application sandbox environment or SDL_SANDBOX_NONE if the
//          application is not running in a sandbox environment.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sandbox() Sandbox {
	return C.SDL_GetSandbox()
}

// C.SDL_OnApplicationWillTerminate [official documentation](https://wiki.libsdl.org/SDL3/SDL_OnApplicationWillTerminate)
fn C.SDL_OnApplicationWillTerminate()

// on_application_will_terminate lets iOS apps with external event handling report
// onApplicationWillTerminate.
//
// This functions allows iOS apps that have their own event handling to hook
// into SDL to generate SDL events. This maps directly to an iOS-specific
// event, but since it doesn't do anything iOS-specific internally, it is
// available on all platforms, in case it might be useful for some specific
// paradigm. Most apps do not need to use this directly; SDL's internal event
// code will handle all this for windows created by SDL_CreateWindow!
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn on_application_will_terminate() {
	C.SDL_OnApplicationWillTerminate()
}

// C.SDL_OnApplicationDidReceiveMemoryWarning [official documentation](https://wiki.libsdl.org/SDL3/SDL_OnApplicationDidReceiveMemoryWarning)
fn C.SDL_OnApplicationDidReceiveMemoryWarning()

// on_application_did_receive_memory_warning lets iOS apps with external event handling report
// onApplicationDidReceiveMemoryWarning.
//
// This functions allows iOS apps that have their own event handling to hook
// into SDL to generate SDL events. This maps directly to an iOS-specific
// event, but since it doesn't do anything iOS-specific internally, it is
// available on all platforms, in case it might be useful for some specific
// paradigm. Most apps do not need to use this directly; SDL's internal event
// code will handle all this for windows created by SDL_CreateWindow!
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn on_application_did_receive_memory_warning() {
	C.SDL_OnApplicationDidReceiveMemoryWarning()
}

// C.SDL_OnApplicationWillEnterBackground [official documentation](https://wiki.libsdl.org/SDL3/SDL_OnApplicationWillEnterBackground)
fn C.SDL_OnApplicationWillEnterBackground()

// on_application_will_enter_background lets iOS apps with external event handling report
// onApplicationWillResignActive.
//
// This functions allows iOS apps that have their own event handling to hook
// into SDL to generate SDL events. This maps directly to an iOS-specific
// event, but since it doesn't do anything iOS-specific internally, it is
// available on all platforms, in case it might be useful for some specific
// paradigm. Most apps do not need to use this directly; SDL's internal event
// code will handle all this for windows created by SDL_CreateWindow!
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn on_application_will_enter_background() {
	C.SDL_OnApplicationWillEnterBackground()
}

// C.SDL_OnApplicationDidEnterBackground [official documentation](https://wiki.libsdl.org/SDL3/SDL_OnApplicationDidEnterBackground)
fn C.SDL_OnApplicationDidEnterBackground()

// on_application_did_enter_background lets iOS apps with external event handling report
// onApplicationDidEnterBackground.
//
// This functions allows iOS apps that have their own event handling to hook
// into SDL to generate SDL events. This maps directly to an iOS-specific
// event, but since it doesn't do anything iOS-specific internally, it is
// available on all platforms, in case it might be useful for some specific
// paradigm. Most apps do not need to use this directly; SDL's internal event
// code will handle all this for windows created by SDL_CreateWindow!
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn on_application_did_enter_background() {
	C.SDL_OnApplicationDidEnterBackground()
}

// C.SDL_OnApplicationWillEnterForeground [official documentation](https://wiki.libsdl.org/SDL3/SDL_OnApplicationWillEnterForeground)
fn C.SDL_OnApplicationWillEnterForeground()

// on_application_will_enter_foreground lets iOS apps with external event handling report
// onApplicationWillEnterForeground.
//
// This functions allows iOS apps that have their own event handling to hook
// into SDL to generate SDL events. This maps directly to an iOS-specific
// event, but since it doesn't do anything iOS-specific internally, it is
// available on all platforms, in case it might be useful for some specific
// paradigm. Most apps do not need to use this directly; SDL's internal event
// code will handle all this for windows created by SDL_CreateWindow!
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn on_application_will_enter_foreground() {
	C.SDL_OnApplicationWillEnterForeground()
}

// C.SDL_OnApplicationDidEnterForeground [official documentation](https://wiki.libsdl.org/SDL3/SDL_OnApplicationDidEnterForeground)
fn C.SDL_OnApplicationDidEnterForeground()

// on_application_did_enter_foreground lets iOS apps with external event handling report
// onApplicationDidBecomeActive.
//
// This functions allows iOS apps that have their own event handling to hook
// into SDL to generate SDL events. This maps directly to an iOS-specific
// event, but since it doesn't do anything iOS-specific internally, it is
// available on all platforms, in case it might be useful for some specific
// paradigm. Most apps do not need to use this directly; SDL's internal event
// code will handle all this for windows created by SDL_CreateWindow!
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn on_application_did_enter_foreground() {
	C.SDL_OnApplicationDidEnterForeground()
}

// C.SDL_OnApplicationDidChangeStatusBarOrientation [official documentation](https://wiki.libsdl.org/SDL3/SDL_OnApplicationDidChangeStatusBarOrientation)
fn C.SDL_OnApplicationDidChangeStatusBarOrientation()

// on_application_did_change_status_bar_orientation lets iOS apps with external event handling report
// onApplicationDidChangeStatusBarOrientation.
//
// This functions allows iOS apps that have their own event handling to hook
// into SDL to generate SDL events. This maps directly to an iOS-specific
// event, but since it doesn't do anything iOS-specific internally, it is
// available on all platforms, in case it might be useful for some specific
// paradigm. Most apps do not need to use this directly; SDL's internal event
// code will handle all this for windows created by SDL_CreateWindow!
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn on_application_did_change_status_bar_orientation() {
	C.SDL_OnApplicationDidChangeStatusBarOrientation()
}
