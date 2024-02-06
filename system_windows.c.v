// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

// Platform specific functions for Windows

// WindowsMessageHook is `typedef void (SDLCALL * SDL_WindowsMessageHook)(void *userdata, void *hWnd, unsigned int message, Uint64 wParam, Sint64 lParam)`
pub type WindowsMessageHook = fn (userdata voidptr, h_wnd voidptr, message u32, w_param u64, l_param i64)

fn C.SDL_SetWindowsMessageHook(callback WindowsMessageHook, userdata voidptr)

// set_windows_message_hook sets a function that is called for every windows message, before TranslateMessage()
pub fn set_windows_message_hook(callback WindowsMessageHook, userdata voidptr) {
	C.SDL_SetWindowsMessageHook(callback, userdata)
}

fn C.SDL_Direct3D9GetAdapterIndex(display_index int) int

// direct_3d9_get_adapter_index returns the D3D9 adapter index that matches the specified display index.
//
// This adapter index can be passed to IDirect3D9::CreateDevice and controls
// on which monitor a full screen application will appear.
pub fn direct_3d9_get_adapter_index(display_index int) int {
	return C.SDL_Direct3D9GetAdapterIndex(display_index)
}

@[typedef]
pub struct C.IDirect3DDevice9 {
}

pub type IDirect3DDevice9 = C.IDirect3DDevice9

fn C.SDL_RenderGetD3D9Device(renderer &C.SDL_Renderer) &C.IDirect3DDevice9

// render_get_d3d9_device returns the D3D device associated with a renderer, or NULL if it's not a D3D renderer.
//
// Once you are done using the device, you should release it to avoid a resource leak.
pub fn render_get_d3d9_device(renderer &Renderer) &IDirect3DDevice9 {
	return C.SDL_RenderGetD3D9Device(renderer)
}

fn C.SDL_DXGIGetOutputInfo(display_index int, adapter_index &int, output_index &int) bool

// dxgi_get_output_info returns the DXGI Adapter and Output indices for the specified display index.
//
// These can be passed to EnumAdapters and EnumOutputs respectively to get the objects
// required to create a DX10 or DX11 device and swap chain.
pub fn dxgi_get_output_info(display_index int, adapter_index &int, output_index &int) bool {
	return C.SDL_DXGIGetOutputInfo(display_index, adapter_index, output_index)
}
