// Copyright(C) 2026 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module ttf

//
// SDL_ttf.h (SDL3)
//
import sdl

pub const major_version = C.SDL_TTF_MAJOR_VERSION
pub const minor_version = C.SDL_TTF_MINOR_VERSION
pub const micro_version = C.SDL_TTF_MICRO_VERSION

// compiledversion is the version number macro for the current SDL_ttf version.
pub fn compiledversion() int {
	return C.SDL_VERSIONNUM(major_version, minor_version, micro_version)
}

fn C.SDL_TTF_VERSION_ATLEAST(x int, y int, z int) bool

// ttf_version_atleast evaluates to true if compiled with SDL_ttf at least X.Y.Z.
pub fn ttf_version_atleast(x int, y int, z int) bool {
	return C.SDL_TTF_VERSION_ATLEAST(x, y, z)
}

fn C.TTF_Version() int

// version gets the version of the dynamically linked SDL_ttf library.
pub fn version() int {
	return C.TTF_Version()
}

@[typedef]
pub struct C.TTF_Font {}

pub type Font = C.TTF_Font

fn C.TTF_Init() bool

// init initializes the TTF engine.
pub fn init() bool {
	return C.TTF_Init()
}

// init_ttf is kept for compatibility with older code.
pub fn init_ttf() bool {
	return C.TTF_Init()
}

fn C.TTF_OpenFont(file &char, ptsize f32) &C.TTF_Font

// open_font opens a font file and creates a font of the specified point size.
pub fn open_font(file &char, ptsize f32) &Font {
	return C.TTF_OpenFont(file, ptsize)
}

fn C.TTF_OpenFontIO(src &C.SDL_IOStream, closeio bool, ptsize f32) &C.TTF_Font

// open_font_io opens a font from an SDL_IOStream.
pub fn open_font_io(src &sdl.IOStream, closeio bool, ptsize f32) &Font {
	return C.TTF_OpenFontIO(src, closeio, ptsize)
}

fn C.TTF_RenderText_Solid(font &C.TTF_Font, text &char, length usize, fg C.SDL_Color) &C.SDL_Surface

// render_text_solid creates a surface and renders the given UTF-8 text.
pub fn render_text_solid(font &Font, text string, fg sdl.Color) &sdl.Surface {
	return C.TTF_RenderText_Solid(font, text.str, usize(text.len), fg)
}

fn C.TTF_CloseFont(font &C.TTF_Font)

// close_font closes an opened font file.
pub fn close_font(font &Font) {
	C.TTF_CloseFont(font)
}

fn C.TTF_Quit()

// quit de-initializes the TTF engine.
pub fn quit() {
	C.TTF_Quit()
}
