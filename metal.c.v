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

// metal_create_view creates a CAMetalLayer-backed NSView/UIView and attach it to the
// specified window.
//
// On macOS, this does *not* associate a MTLDevice with the CAMetalLayer on its
// own. It is up to user code to do that.
//
// The returned handle can be casted directly to a NSView or UIView, and the
// CAMetalLayer can be accessed from the view's 'layer' property.
//
/*
```
    SDL_MetalView metalview = SDL_Metal_CreateView(window);
    UIView *uiview = (__bridge UIView *)metalview;
    CAMetalLayer *metallayer = (CAMetalLayer *)uiview.layer;
    // [...]
    SDL_Metal_DestroyView(metalview);
```
*/
// See also: SDL_Metal_DestroyView
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
