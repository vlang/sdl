// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

@[typedef]
pub struct C.tagMSG {}

pub type TagMSG = C.tagMSG

@[typedef]
pub struct C.MSG {}

pub type MSG = C.MSG

// WindowsMessageHook as callback to be used with SDL_SetWindowsMessageHook.
//
// This callback may modify the message, and should return true if the message
// should continue to be processed, or false to prevent further processing.
//
// As this is processing a message directly from the Windows event loop, this
// callback should do the minimum required work and return quickly.
//
// `userdata` userdata the app-defined pointer provided to
//                 SDL_SetWindowsMessageHook.
// `msg` msg a pointer to a Win32 event structure to process.
// returns true to let event continue on, false to drop it.
//
// NOTE: (thread safety) This may only be called (by SDL) from the thread handling the
//               Windows event loop.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: set_windows_message_hook (SDL_SetWindowsMessageHook)
// See also: hintwindowsenablemessageloop (SDL_HINT_WINDOWS_ENABLE_MESSAGELOOP)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_WindowsMessageHook)
pub type WindowsMessageHook = fn (userdata voidptr, msg &MSG) bool

// C.SDL_SetWindowsMessageHook [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowsMessageHook)
fn C.SDL_SetWindowsMessageHook(callback WindowsMessageHook, userdata voidptr)

// set_windows_message_hook sets a callback for every Windows message, run before TranslateMessage().
//
// The callback may modify the message, and should return true if the message
// should continue to be processed, or false to prevent further processing.
//
// `callback` callback the SDL_WindowsMessageHook function to call.
// `userdata` userdata a pointer to pass to every iteration of `callback`.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: windows_message_hook (SDL_WindowsMessageHook)
// See also: hintwindowsenablemessageloop (SDL_HINT_WINDOWS_ENABLE_MESSAGELOOP)
pub fn set_windows_message_hook(callback WindowsMessageHook, userdata voidptr) {
	C.SDL_SetWindowsMessageHook(callback, userdata)
}

// C.SDL_GetDirect3D9AdapterIndex [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDirect3D9AdapterIndex)
fn C.SDL_GetDirect3D9AdapterIndex(display_id DisplayID) int

// get_direct3_d9_adapter_index gets the D3D9 adapter index that matches the specified display.
//
// The returned adapter index can be passed to `IDirect3D9::CreateDevice` and
// controls on which monitor a full screen application will appear.
//
// `display_id` displayID the instance of the display to query.
// returns the D3D9 adapter index on success or -1 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_direct3_d9_adapter_index(display_id DisplayID) int {
	return C.SDL_GetDirect3D9AdapterIndex(display_id)
}

// C.SDL_GetDXGIOutputInfo [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDXGIOutputInfo)
fn C.SDL_GetDXGIOutputInfo(display_id DisplayID, adapter_index &int, output_index &int) bool

// get_dxgi_output_info gets the DXGI Adapter and Output indices for the specified display.
//
// The DXGI Adapter and Output indices can be passed to `EnumAdapters` and
// `EnumOutputs` respectively to get the objects required to create a DX10 or
// DX11 device and swap chain.
//
// `display_id` displayID the instance of the display to query.
// `adapter_index` adapterIndex a pointer to be filled in with the adapter index.
// `output_index` outputIndex a pointer to be filled in with the output index.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_dxgi_output_info(display_id DisplayID, adapter_index &int, output_index &int) bool {
	return C.SDL_GetDXGIOutputInfo(display_id, adapter_index, output_index)
}

@[typedef]
pub struct C.XTaskQueueHandle {}

pub type XTaskQueueHandle = C.XTaskQueueHandle

@[typedef]
pub struct C.XUserHandle {}

pub type XUserHandle = C.XUserHandle

@[typedef]
pub struct C.XTaskQueueObject {}

pub type XTaskQueueObject = C.XTaskQueueObject

@[typedef]
pub struct C.XUser {}

pub type XUser = C.XUser

// C.SDL_GetGDKTaskQueue [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGDKTaskQueue)
fn C.SDL_GetGDKTaskQueue(out_task_queue &XTaskQueueHandle) bool

// get_gdk_task_queue gets a reference to the global async task queue handle for GDK,
// initializing if needed.
//
// Once you are done with the task queue, you should call
// XTaskQueueCloseHandle to reduce the reference count to avoid a resource
// leak.
//
// `out_task_queue` outTaskQueue a pointer to be filled in with task queue handle.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gdk_task_queue(out_task_queue &XTaskQueueHandle) bool {
	return C.SDL_GetGDKTaskQueue(out_task_queue)
}

// C.SDL_GetGDKDefaultUser [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGDKDefaultUser)
fn C.SDL_GetGDKDefaultUser(out_user_handle &XUserHandle) bool

// get_gdk_default_user gets a reference to the default user handle for GDK.
//
// This is effectively a synchronous version of XUserAddAsync, which always
// prefers the default user and allows a sign-in UI.
//
// `out_user_handle` outUserHandle a pointer to be filled in with the default user
//                      handle.
// returns true if success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gdk_default_user(out_user_handle &XUserHandle) bool {
	return C.SDL_GetGDKDefaultUser(out_user_handle)
}
