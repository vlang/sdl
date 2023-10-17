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
// C.SDL_MetalView
pub type MetalView = voidptr

// Metal support functions
fn C.SDL_Metal_CreateView(window &C.SDL_Window) MetalView

// metal_create_view creates a CAMetalLayer-backed NSView/UIView and attach it to the
// specified window.
//
// On macOS, this does *not* associate a MTLDevice with the CAMetalLayer on its
// own. It is up to user code to do that.
//
// The returned handle can be casted directly to a NSView or UIView.
// To access the backing CAMetalLayer, call SDL_Metal_GetLayer().
//
// NOTE a window must be created with the SDL_WINDOW_METAL flag.
//
// See also: SDL_Metal_DestroyView
// See also: SDL_Metal_GetLayer
pub fn metal_create_view(window &Window) MetalView {
	return MetalView(voidptr(C.SDL_Metal_CreateView(window)))
}

fn C.SDL_Metal_DestroyView(view C.SDL_MetalView)

// metal_destroy_view destroys an existing SDL_MetalView object.
//
//  This should be called before SDL_DestroyWindow, if SDL_Metal_CreateView was
//  called after SDL_CreateWindow.
//
//  See also: SDL_Metal_CreateView
pub fn metal_destroy_view(view MetalView) {
	C.SDL_Metal_DestroyView(voidptr(view))
}

fn C.SDL_Metal_GetLayer(view C.SDL_MetalView) voidptr

// metal_get_layer gets a pointer to the backing CAMetalLayer for the given view.
//
// See also: SDL_MetalCreateView
pub fn metal_get_layer(view MetalView) voidptr {
	return C.SDL_Metal_GetLayer(voidptr(view))
}

fn C.SDL_Metal_GetDrawableSize(window &C.SDL_Window, w &int, h &int)

// metal_get_drawable_size gets the size of a window's underlying drawable in pixels (for use
// with setting viewport, scissor & etc).
//
// `window`   SDL_Window from which the drawable size should be queried
// `w`        Pointer to variable for storing the width in pixels,
//            may be NULL
// `h`        Pointer to variable for storing the height in pixels,
//            may be NULL
//
// This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
// drawable, i.e. the window was created with SDL_WINDOW_ALLOW_HIGHDPI on a
// platform with high-DPI support (Apple calls this "Retina"), and not disabled
// by the `SDL_HINT_VIDEO_HIGHDPI_DISABLED` hint.
//
// NOTE On macOS high-DPI support must be enabled for an application by
//      setting NSHighResolutionCapable to true in its Info.plist.
//
// See also: SDL_GetWindowSize()
// See also: SDL_CreateWindow()
pub fn metal_get_drawable_size(window &Window, w &int, h &int) {
	C.SDL_Metal_GetDrawableSize(window, w, h)
}
