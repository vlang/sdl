// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_metal.h
//

// A handle to a CAMetalLayer-backed NSView (macOS) or UIView (iOS/tvOS).
//
// NOTE This can be cast directly to an NSView or UIView.
//
// `typedef void *SDL_MetalView;`
pub type MetalView = voidptr // C.SDL_MetalView

// Metal support functions
fn C.SDL_Metal_CreateView(window &C.SDL_Window) C.SDL_MetalView

// metal_create_view creates a CAMetalLayer-backed NSView/UIView and attach it to the specified
// window.
//
// On macOS, this does *not* associate a MTLDevice with the CAMetalLayer on
// its own. It is up to user code to do that.
//
// The returned handle can be casted directly to a NSView or UIView. To access
// the backing CAMetalLayer, call SDL_Metal_GetLayer().
//
// NOTE This function is available since SDL 2.0.12.
//
// See also: SDL_Metal_DestroyView
// See also: SDL_Metal_GetLayer
pub fn metal_create_view(window &Window) MetalView {
	return MetalView(voidptr(C.SDL_Metal_CreateView(window)))
}

fn C.SDL_Metal_DestroyView(view C.SDL_MetalView)

// metal_destroy_view destroys an existing SDL_MetalView object.
//
// This should be called before SDL_DestroyWindow, if SDL_Metal_CreateView was
// called after SDL_CreateWindow.
//
// NOTE This function is available since SDL 2.0.12.
//
// See also: SDL_Metal_CreateView
pub fn metal_destroy_view(view MetalView) {
	C.SDL_Metal_DestroyView(voidptr(view))
}

fn C.SDL_Metal_GetLayer(view C.SDL_MetalView) voidptr

// metal_get_layer gets a pointer to the backing CAMetalLayer for the given view.
//
// NOTE This function is available since SDL 2.0.14.
//
// See also: SDL_MetalCreateView
pub fn metal_get_layer(view MetalView) voidptr {
	return C.SDL_Metal_GetLayer(voidptr(view))
}

fn C.SDL_Metal_GetDrawableSize(window &C.SDL_Window, w &int, h &int)

// metal_get_drawable_size gets the size of a window's underlying drawable in pixels (for use with
// setting viewport, scissor & etc).
//
// `window` SDL_Window from which the drawable size should be queried
// `w` Pointer to variable for storing the width in pixels, may be NULL
//
// NOTE This function is available since SDL 2.0.14.
//
// See also: SDL_GetWindowSize
// See also: SDL_CreateWindow
pub fn metal_get_drawable_size(window &Window, w &int, h &int) {
	C.SDL_Metal_GetDrawableSize(window, w, h)
}
