// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_metal.h
//

// Functions to creating Metal layers and views on SDL windows.
//
// This provides some platform-specific glue for Apple platforms. Most macOS
// and iOS apps can use SDL without these functions, but this API they can be
// useful for specific OS-level integration tasks.

// A handle to a CAMetalLayer-backed NSView (macOS) or UIView (iOS/tvOS).
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type MetalView = voidptr

// C.SDL_Metal_CreateView [official documentation](https://wiki.libsdl.org/SDL3/SDL_Metal_CreateView)
fn C.SDL_Metal_CreateView(window &Window) MetalView

// metal_create_view creates a CAMetalLayer-backed NSView/UIView and attach it to the specified
// window.
//
// On macOS, this does *not* associate a MTLDevice with the CAMetalLayer on
// its own. It is up to user code to do that.
//
// The returned handle can be casted directly to a NSView or UIView. To access
// the backing CAMetalLayer, call SDL_Metal_GetLayer().
//
// `window` window the window.
// returns handle NSView or UIView.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: metal_destroy_view (SDL_Metal_DestroyView)
// See also: metal_get_layer (SDL_Metal_GetLayer)
pub fn metal_create_view(window &Window) MetalView {
	return C.SDL_Metal_CreateView(window)
}

// C.SDL_Metal_DestroyView [official documentation](https://wiki.libsdl.org/SDL3/SDL_Metal_DestroyView)
fn C.SDL_Metal_DestroyView(view MetalView)

// metal_destroy_view destroys an existing SDL_MetalView object.
//
// This should be called before SDL_DestroyWindow, if SDL_Metal_CreateView was
// called after SDL_CreateWindow.
//
// `view` view the SDL_MetalView object.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: metal_create_view (SDL_Metal_CreateView)
pub fn metal_destroy_view(view MetalView) {
	C.SDL_Metal_DestroyView(view)
}

// C.SDL_Metal_GetLayer [official documentation](https://wiki.libsdl.org/SDL3/SDL_Metal_GetLayer)
fn C.SDL_Metal_GetLayer(view MetalView) voidptr

// metal_get_layer gets a pointer to the backing CAMetalLayer for the given view.
//
// `view` view the SDL_MetalView object.
// returns a pointer.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn metal_get_layer(view MetalView) voidptr {
	return C.SDL_Metal_GetLayer(view)
}
