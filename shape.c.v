// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_shape.h
//

pub const (
	nonshapeable_window    = C.SDL_NONSHAPEABLE_WINDOW // -1
	invalid_shape_argument = C.SDL_INVALID_SHAPE_ARGUMENT // -2
	window_lacks_shape     = C.SDL_WINDOW_LACKS_SHAPE // -3
)

fn C.SDL_CreateShapedWindow(title &char, x u32, y u32, w u32, h u32, flags u32) &C.SDL_Window

// create_shaped_window creates a window that can be shaped with the specified position, dimensions, and flags.
//
// `title` The title of the window, in UTF-8 encoding.
// `x`     The x position of the window, ::SDL_WINDOWPOS_CENTERED, or
//               ::SDL_WINDOWPOS_UNDEFINED.
// `y`     The y position of the window, ::SDL_WINDOWPOS_CENTERED, or
//               ::SDL_WINDOWPOS_UNDEFINED.
// `w`     The width of the window.
// `h`     The height of the window.
// `flags` The flags for the window, a mask of SDL_WINDOW_BORDERLESS with any of the following:
//               ::SDL_WINDOW_OPENGL,     ::SDL_WINDOW_INPUT_GRABBED,
//               ::SDL_WINDOW_HIDDEN,     ::SDL_WINDOW_RESIZABLE,
//               ::SDL_WINDOW_MAXIMIZED,  ::SDL_WINDOW_MINIMIZED,
//      ::SDL_WINDOW_BORDERLESS is always set, and ::SDL_WINDOW_FULLSCREEN is always unset.
//
// returns The window created, or NULL if window creation failed.
//
// See also: SDL_DestroyWindow()
pub fn create_shaped_window(title &char, x u32, y u32, w u32, h u32, flags u32) &Window {
	return C.SDL_CreateShapedWindow(title, x, y, w, h, flags)
}

fn C.SDL_IsShapedWindow(window &C.SDL_Window) bool

// is_shaped_window returns whether the given window is a shaped window.
//
// `window` The window to query for being shaped.
//
// returns SDL_TRUE if the window is a window that can be shaped, SDL_FALSE if the window is unshaped or NULL.
//
// See also: SDL_CreateShapedWindow
pub fn is_shaped_window(window &Window) bool {
	return C.SDL_IsShapedWindow(window)
}

// WindowShapeMode is an enum denoting the specific type of contents present in an SDL_WindowShapeParams union.
// WindowShapeMode is C.WindowShapeMode
pub enum WindowShapeModeFlag {
	default = C.ShapeModeDefault // The default mode, a binarized alpha cutoff of 1.
	binarize_alpha = C.ShapeModeBinarizeAlpha // A binarized alpha cutoff with a given integer value.
	reverse_binarize_alpha = C.ShapeModeReverseBinarizeAlpha // A binarized alpha cutoff with a given integer value, but with the opposite comparison.
	color_key = C.ShapeModeColorKey // A color key is applied.
}

fn C.SDL_SHAPEMODEALPHA(mode WindowShapeModeFlag) bool
pub fn shapemodealpha(mode WindowShapeModeFlag) bool {
	return C.SDL_SHAPEMODEALPHA(mode)
}

// WindowShapeParams is a union containing parameters for shaped windows.
// WindowShapeParams is C.SDL_WindowShapeParams
[typedef]
union C.SDL_WindowShapeParams {
pub:
	binarizationCutoff byte // A cutoff alpha value for binarization of the window shape's alpha channel.
	colorKey           Color
}

pub type WindowShapeParams = C.SDL_WindowShapeParams

// WindowShapeMode is a struct that tags the SDL_WindowShapeParams union with
// an enum describing the type of its contents.
// WindowShapeMode is C.SDL_WindowShapeMode
[typedef]
struct C.SDL_WindowShapeMode {
pub:
	mode       WindowShapeModeFlag // The mode of these window-shape parameters.
	parameters WindowShapeParams   // Window-shape parameters.
}

pub type WindowShapeMode = C.SDL_WindowShapeMode

fn C.SDL_SetWindowShape(window &C.SDL_Window, shape &C.SDL_Surface, shape_mode &C.SDL_WindowShapeMode) int

// set_window_shape sets the shape and parameters of a shaped window.
//
// `window` The shaped window whose parameters should be set.
// `shape` A surface encoding the desired shape for the window.
// `shape_mode` The parameters to set for the shaped window.
//
// returns 0 on success, SDL_INVALID_SHAPE_ARGUMENT on an invalid shape argument, or SDL_NONSHAPEABLE_WINDOW
//           if the SDL_Window given does not reference a valid shaped window.
//
// See also: SDL_WindowShapeMode
// See also: SDL_GetShapedWindowMode.
pub fn set_window_shape(window &Window, shape &Surface, shape_mode &WindowShapeMode) int {
	return C.SDL_SetWindowShape(window, shape, shape_mode)
}

fn C.SDL_GetShapedWindowMode(window &C.SDL_Window, shape_mode &C.SDL_WindowShapeMode) int

// get_shaped_window_mode gets the shape parameters of a shaped window.
//
// `window` The shaped window whose parameters should be retrieved.
// `shape_mode` An empty shape-mode structure to fill, or NULL to check whether the window has a shape.
//
// returns 0 if the window has a shape and, provided shape_mode was not NULL, shape_mode has been filled with the mode
//           data, SDL_NONSHAPEABLE_WINDOW if the SDL_Window given is not a shaped window, or SDL_WINDOW_LACKS_SHAPE if
//           the SDL_Window given is a shapeable window currently lacking a shape.
//
// See also: SDL_WindowShapeMode
// See also: SDL_SetWindowShape
pub fn get_shaped_window_mode(window &Window, shape_mode &WindowShapeMode) int {
	return C.SDL_GetShapedWindowMode(window, shape_mode)
}
