// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module ttf

#flag windows -I @VMODROOT/thirdparty/SDL2_ttf/include
#flag windows -L @VMODROOT/thirdparty/SDL2_ttf/lib/x64
#flag windows -lSDL2_ttf

#include <SDL_ttf.h>

/*
[typedef]
struct C.TTF_Font {}

fn C.TTF_Init() int
fn C.TTF_Quit()

fn C.TTF_OpenFont(file &byte, ptsize int) &C.TTF_Font
fn C.TTF_OpenFontIndex(file &byte, ptsize int, index i64) &C.TTF_Font
fn C.TTF_OpenFontRW(src &SDL_RWops, freesrc int, ptsize int) &C.TTF_Font
fn C.TTF_OpenFontIndexRW(src &SDL_RWops, freesrc int, ptsize int, index i64) &C.TTF_Font

// Set and retrieve the font style
const (
	ttf_style_normal = C.TTF_STYLE_NORMAL
	ttf_style_bold = C.TTF_STYLE_BOLD
	ttf_style_italic = C.TTF_STYLE_ITALIC
	ttf_style_underline = C.TTF_STYLE_UNDERLINE
	ttf_style_strikethrough = C.TTF_STYLE_STRIKETHROUGH
)
fn C.TTF_GetFontStyle(font &C.TTF_Font) int
fn C.TTF_SetFontStyle(font &C.TTF_Font, style int)
fn C.TTF_GetFontOutline(font &C.TTF_Font) int
fn C.TTF_SetFontOutline(font &C.TTF_Font, outline int)

// Set and retrieve FreeType hinter settings
const (
	ttf_hinting_normal = C.TTF_HINTING_NORMAL
	ttf_hinting_light  = C.TTF_HINTING_LIGHT
	ttf_hinting_mono   = C.TTF_HINTING_MONO
	ttf_hinting_none   = C.TTF_HINTING_NONE
)

fn C.TTF_GetFontHinting(font &C.TTF_Font) int
fn C.TTF_SetFontHinting(font &C.TTF_Font, hinting int)

// Get the total height of the font - usually equal to point size
fn C.TTF_FontHeight(font &C.TTF_Font) int


// Get the offset from the baseline to the top of the font This is a positive value, relative to the baseline.
fn C.TTF_FontAscent(font &C.TTF_Font) int

// Get the offset from the baseline to the bottom of the font This is a negative value, relative to the baseline.
fn C.TTF_FontDescent(font &C.TTF_Font) int

// Get the recommended spacing between lines of text for this font
fn C.TTF_FontLineSkip(font &C.TTF_Font) int

// Get/Set whether or not kerning is allowed for this font
fn C.TTF_GetFontKerning(font &C.TTF_Font) int
fn C.TTF_SetFontKerning(font &C.TTF_Font, allowed int)

// Get the kerning size of two glyphs
fn C.TTF_GetFontKerningSizeGlyphs(font &C.TTF_Font, previous_ch u16, ch u16) int

// Get the number of faces of the font
fn C.TTF_FontFaces(font &C.TTF_Font) i64

// Get the font face attributes, if any
fn C.TTF_FontFaceIsFixedWidth(font &C.TTF_Font) int
fn C.TTF_FontFaceFamilyName(font &C.TTF_Font) &byte
fn C.TTF_FontFaceStyleName(font &C.TTF_Font) &byte

// Check wether a glyph is provided by the font or not
fn C.TTF_GlyphIsProvided(font &C.TTF_Font, ch u16) int


//Get the metrics (dimensions) of a glyph To understand what these metrics mean, here is a useful link:
//    http://freetype.sourceforge.net/freetype2/docs/tutorial/step2.html
fn C.TTF_GlyphMetrics(font &C.TTF_Font, ch u16, minx &int, maxx &int, miny &int, maxy &int, advance &int) int

// Get the dimensions of a rendered string of text
fn C.TTF_SizeText(font &C.TTF_Font, text &byte, w &int, h &int) int
fn C.TTF_SizeUTF8(font &C.TTF_Font, text &byte, w &int, h &int) int
fn C.TTF_SizeUNICODE(font &C.TTF_Font, text &u16, w &int, h &int) int


// Create an 8-bit palettized surface and render the given text at fast quality with the given font and color.  The 0 pixel is the
//   colorkey, giving a transparent background, and the 1 pixel is set to the text color.
//   This function returns the new surface, or NULL if there was an error.
fn C.TTF_RenderText_Solid(font &C.TTF_Font, text &byte, fg C.SDL_Color) &C.SDL_Surface
fn C.TTF_RenderUTF8_Solid(font &C.TTF_Font, text &byte, fg C.SDL_Color) &C.SDL_Surface
fn C.TTF_RenderUNICODE_Solid(font &C.TTF_Font, text &u16, fg C.SDL_Color) &C.SDL_Surface

// Create an 8-bit palettized surface and render the given glyph at fast quality with the given font and color.  The 0 pixel is the
//   colorkey, giving a transparent background, and the 1 pixel is set to the text color.  The glyph is rendered without any padding or
//   centering in the X direction, and aligned normally in the Y direction. This function returns the new surface, or NULL if there was an error.
fn C.TTF_RenderGlyph_Solid(font &C.TTF_Font, ch u16, fg C.SDL_Color) &C.SDL_Surface

// Create an 8-bit palettized surface and render the given text at high quality with the given font and colors.  The 0 pixel is background,
//   while other pixels have varying degrees of the foreground color. This function returns the new surface, or NULL if there was an error.
fn C.TTF_RenderText_Shaded(font &C.TTF_Font, text &byte, fg C.SDL_Color, bg C.SDL_Color) &C.SDL_Surface
fn C.TTF_RenderUTF8_Shaded(font &C.TTF_Font, text &byte, fg C.SDL_Color, bg C.SDL_Color) &C.SDL_Surface
fn C.TTF_RenderUNICODE_Shaded(font &C.TTF_Font, text &u16, fg C.SDL_Color, bg C.SDL_Color) &C.SDL_Surface


// Create an 8-bit palettized surface and render the given glyph at high quality with the given font and colors.  The 0 pixel is background,
// while other pixels have varying degrees of the foreground color. The glyph is rendered without any padding or centering in the X
// direction, and aligned normally in the Y direction. This function returns the new surface, or NULL if there was an error.
fn C.TTF_RenderGlyph_Shaded(font &C.TTF_Font, ch u16, fg C.SDL_Color) &C.SDL_Surface


// Create a 32-bit ARGB surface and render the given text at high quality, using alpha blending to dither the font with the given color.
//   This function returns the new surface, or NULL if there was an error.
fn C.TTF_RenderText_Blended(font &C.TTF_Font, text &byte, fg C.SDL_Color, bg C.SDL_Color) &C.SDL_Surface
fn C.TTF_RenderUTF8_Blended(font &C.TTF_Font, text &byte, fg C.SDL_Color, bg C.SDL_Color) &C.SDL_Surface
fn C.TTF_RenderUNICODE_Blended(font &C.TTF_Font, text &u16, fg C.SDL_Color, bg C.SDL_Color) &C.SDL_Surface


// Create a 32-bit ARGB surface and render the given text at high quality, using alpha blending to dither the font with the given color.
// Text is wrapped to multiple lines on line endings and on word boundaries if it extends beyond wrapLength in pixels.
// This function returns the new surface, or NULL if there was an error.
fn C.TTF_RenderText_Blended_Wrapped(font &C.TTF_Font, text &byte, fg C.SDL_Color, wrap_length u32) &C.SDL_Surface
fn C.TTF_RenderUTF8_Blended_Wrapped(font &C.TTF_Font, text &byte, fg C.SDL_Color, wrap_length u32) &C.SDL_Surface
fn C.TTF_RenderUNICODE_Blended_Wrapped(font &C.TTF_Font, text &u16, fg C.SDL_Color, wrap_length u32) &C.SDL_Surface


// Create a 32-bit ARGB surface and render the given glyph at high quality, using alpha blending to dither the font with the given color.
// The glyph is rendered without any padding or centering in the X direction, and aligned normally in the Y direction.
// This function returns the new surface, or NULL if there was an error.
fn C.TTF_RenderGlyph_Blended(font &C.TTF_Font, ch u16, fg C.SDL_Color) &C.SDL_Surface

fn C.TTF_WasInit() int

fn C.TTF_CloseFont(font &C.TTF_Font)

pub const (
	version     = '0.0.1'
	sdl_version = sdl.version // TODO: remove this hack to mark sdl as used; avoids warning
)
*/
