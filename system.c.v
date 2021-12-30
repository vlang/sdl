// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

// TODO WinRT support?
/*
pub enum C.SDL_WinRT_Path {
}


pub enum C.SDL_WinRT_DeviceFamily {
}


// extern DECLSPEC const wchar_t * SDLCALL SDL_WinRTGetFSPathUNICODE(SDL_WinRT_Path pathType)
fn C.SDL_WinRTGetFSPathUNICODE(path_type C.SDL_WinRT_Path) &C.wchar_t
pub fn win_r_t_get_f_s_path_u_n_i_c_o_d_e(path_type C.SDL_WinRT_Path) &C.wchar_t{
	return C.SDL_WinRTGetFSPathUNICODE(path_type)
}

// extern DECLSPEC const char * SDLCALL SDL_WinRTGetFSPathUTF8(SDL_WinRT_Path pathType)
fn C.SDL_WinRTGetFSPathUTF8(path_type C.SDL_WinRT_Path) &char
pub fn win_r_t_get_f_s_path_u_t_f8(path_type C.SDL_WinRT_Path) &char{
	return C.SDL_WinRTGetFSPathUTF8(path_type)
}

// extern DECLSPEC SDL_WinRT_DeviceFamily SDLCALL SDL_WinRTGetDeviceFamily()
fn C.SDL_WinRTGetDeviceFamily() C.SDL_WinRT_DeviceFamily
pub fn win_r_t_get_device_family() C.SDL_WinRT_DeviceFamily{
	return C.SDL_WinRTGetDeviceFamily()
}
*/

fn C.SDL_IsTablet() bool

// is_tablet returns true if the current device is a tablet.
pub fn is_tablet() bool {
	return C.SDL_IsTablet()
}

// Functions used by iOS application delegates to notify SDL about state changes

fn C.SDL_OnApplicationWillTerminate()
pub fn on_application_will_terminate() {
	C.SDL_OnApplicationWillTerminate()
}

fn C.SDL_OnApplicationDidReceiveMemoryWarning()
pub fn on_application_did_receive_memory_warning() {
	C.SDL_OnApplicationDidReceiveMemoryWarning()
}

fn C.SDL_OnApplicationWillResignActive()
pub fn on_application_will_resign_active() {
	C.SDL_OnApplicationWillResignActive()
}

fn C.SDL_OnApplicationDidEnterBackground()
pub fn on_application_did_enter_background() {
	C.SDL_OnApplicationDidEnterBackground()
}

fn C.SDL_OnApplicationWillEnterForeground()
pub fn on_application_will_enter_foreground() {
	C.SDL_OnApplicationWillEnterForeground()
}

fn C.SDL_OnApplicationDidBecomeActive()
pub fn on_application_did_become_active() {
	C.SDL_OnApplicationDidBecomeActive()
}
