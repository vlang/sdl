// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

// Platform specific functions for Windows

fn C.SDL_SetWindowsMessageHook(callback C.SDL_WindowsMessageHook, userdata voidptr)

// set_windows_message_hook sets a callback for every Windows message, run before TranslateMessage().
//
// `callback` The SDL_WindowsMessageHook function to call.
// `userdata` a pointer to pass to every iteration of `callback`
pub fn set_windows_message_hook(callback C.SDL_WindowsMessageHook, userdata voidptr) {
	C.SDL_SetWindowsMessageHook(callback, userdata)
}

fn C.SDL_Direct3D9GetAdapterIndex(display_index int) int

// direct_3d9_get_adapter_index gets the D3D9 adapter index that matches the specified display index.
//
// The returned adapter index can be passed to `IDirect3D9::CreateDevice` and
// controls on which monitor a full screen application will appear.
//
// `displayIndex` the display index for which to get the D3D9 adapter
//                     index
// returns the D3D9 adapter index on success or a negative error code on
//          failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.1.
pub fn direct_3d9_get_adapter_index(display_index int) int {
	return C.SDL_Direct3D9GetAdapterIndex(display_index)
}

@[typedef]
pub struct C.IDirect3DDevice9 {
}

pub type IDirect3DDevice9 = C.IDirect3DDevice9

fn C.SDL_RenderGetD3D9Device(renderer &C.SDL_Renderer) &C.IDirect3DDevice9

// render_get_d3d9_device gets the D3D9 device associated with a renderer.
//
// Once you are done using the device, you should release it to avoid a
// resource leak.
//
// `renderer` the renderer from which to get the associated D3D device
// returns the D3D9 device associated with given renderer or NULL if it is
//          not a D3D9 renderer; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.1.
pub fn render_get_d3d9_device(renderer &Renderer) &IDirect3DDevice9 {
	return C.SDL_RenderGetD3D9Device(renderer)
}

@[typedef]
pub struct C.ID3D11Device {
}

pub type ID3D11Device = C.ID3D11Device

fn C.SDL_RenderGetD3D11Device(renderer &C.SDL_Renderer) &C.ID3D11Device

// render_get_d3_d11_device gets the D3D11 device associated with a renderer.
//
// Once you are done using the device, you should release it to avoid a
// resource leak.
//
// `renderer` the renderer from which to get the associated D3D11 device
// returns the D3D11 device associated with given renderer or NULL if it is
//          not a D3D11 renderer; call SDL_GetError() for more information.
pub fn render_get_d3_d11_device(renderer &Renderer) &ID3D11Device {
	return C.SDL_RenderGetD3D11Device(renderer)
}

fn C.SDL_DXGIGetOutputInfo(display_index int, adapter_index &int, output_index &int) bool

// dxgi_get_output_info gets the DXGI Adapter and Output indices for the specified display index.
//
// The DXGI Adapter and Output indices can be passed to `EnumAdapters` and
// `EnumOutputs` respectively to get the objects required to create a DX10 or
// DX11 device and swap chain.
//
// Before SDL 2.0.4 this function did not return a value. Since SDL 2.0.4 it
// returns an SDL_bool.
//
// `displayIndex` the display index for which to get both indices
// `adapterIndex` a pointer to be filled in with the adapter index
// `outputIndex` a pointer to be filled in with the output index
// returns SDL_TRUE on success or SDL_FALSE on failure; call SDL_GetError()
//          for more information.
//
// NOTE This function is available since SDL 2.0.2.
pub fn dxgi_get_output_info(display_index int, adapter_index &int, output_index &int) bool {
	return C.SDL_DXGIGetOutputInfo(display_index, adapter_index, output_index)
}
