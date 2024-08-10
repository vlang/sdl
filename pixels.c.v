// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_pixels.h
//

// Transparency definitions
//
// These define alpha as the opacity of a surface.
pub const alpha_opaque = C.SDL_ALPHA_OPAQUE // 255

pub const alpha_transparent = C.SDL_ALPHA_TRANSPARENT // 0

// Pixel type.
// PixelType is C.SDL_PixelType
pub enum PixelType {
	unknown  = C.SDL_PIXELTYPE_UNKNOWN
	index1   = C.SDL_PIXELTYPE_INDEX1
	index4   = C.SDL_PIXELTYPE_INDEX4
	index8   = C.SDL_PIXELTYPE_INDEX8
	packed8  = C.SDL_PIXELTYPE_PACKED8
	packed16 = C.SDL_PIXELTYPE_PACKED16
	packed32 = C.SDL_PIXELTYPE_PACKED32
	arrayu8  = C.SDL_PIXELTYPE_ARRAYU8
	arrayu16 = C.SDL_PIXELTYPE_ARRAYU16
	arrayu32 = C.SDL_PIXELTYPE_ARRAYU32
	arrayf16 = C.SDL_PIXELTYPE_ARRAYF16
	arrayf32 = C.SDL_PIXELTYPE_ARRAYF32
}

// Bitmap pixel order, high bit -> low bit.
// BitmapOrder is C.SDL_BitmapOrder
pub enum BitmapOrder {
	@none      = C.SDL_BITMAPORDER_NONE
	order_4321 = C.SDL_BITMAPORDER_4321
	order_1234 = C.SDL_BITMAPORDER_1234
}

// Packed component order, high bit -> low bit.
// PackedOrder is C.SDL_PackedOrder
pub enum PackedOrder {
	@none = C.SDL_PACKEDORDER_NONE
	xrgb  = C.SDL_PACKEDORDER_XRGB
	rgbx  = C.SDL_PACKEDORDER_RGBX
	argb  = C.SDL_PACKEDORDER_ARGB
	rgba  = C.SDL_PACKEDORDER_RGBA
	xbgr  = C.SDL_PACKEDORDER_XBGR
	bgrx  = C.SDL_PACKEDORDER_BGRX
	abgr  = C.SDL_PACKEDORDER_ABGR
	bgra  = C.SDL_PACKEDORDER_BGRA
}

//** Array component order, low byte -> high byte. */
// ArrayOrder is C.SDL_ArrayOrder
pub enum ArrayOrder {
	@none = C.SDL_ARRAYORDER_NONE
	rgb   = C.SDL_ARRAYORDER_RGB
	rgba  = C.SDL_ARRAYORDER_RGBA
	argb  = C.SDL_ARRAYORDER_ARGB
	bgr   = C.SDL_ARRAYORDER_BGR
	bgra  = C.SDL_ARRAYORDER_BGRA
	abgr  = C.SDL_ARRAYORDER_ABGR
}

// Packed component layout.
// PackedLayout is C.SDL_PackedLayout
pub enum PackedLayout {
	@none          = C.SDL_PACKEDLAYOUT_NONE
	layout_332     = C.SDL_PACKEDLAYOUT_332
	layout_4444    = C.SDL_PACKEDLAYOUT_4444
	layout_1555    = C.SDL_PACKEDLAYOUT_1555
	layout_5551    = C.SDL_PACKEDLAYOUT_5551
	layout_565     = C.SDL_PACKEDLAYOUT_565
	layout_8888    = C.SDL_PACKEDLAYOUT_8888
	layout_2101010 = C.SDL_PACKEDLAYOUT_2101010
	layout_1010102 = C.SDL_PACKEDLAYOUT_1010102
}

pub enum Format {
	unknown      = C.SDL_PIXELFORMAT_UNKNOWN
	index1lsb    = C.SDL_PIXELFORMAT_INDEX1LSB
	index1msb    = C.SDL_PIXELFORMAT_INDEX1MSB
	index4lsb    = C.SDL_PIXELFORMAT_INDEX4LSB
	index4msb    = C.SDL_PIXELFORMAT_INDEX4MSB
	index8       = C.SDL_PIXELFORMAT_INDEX8
	rgb332       = C.SDL_PIXELFORMAT_RGB332
	xrgb4444     = C.SDL_PIXELFORMAT_XRGB4444
	rgb444       = C.SDL_PIXELFORMAT_RGB444
	xbgr4444     = C.SDL_PIXELFORMAT_XBGR4444
	bgr444       = C.SDL_PIXELFORMAT_BGR444
	xrgb1555     = C.SDL_PIXELFORMAT_XRGB1555
	rgb555       = C.SDL_PIXELFORMAT_RGB555
	xbgr1555     = C.SDL_PIXELFORMAT_XBGR1555
	bgr555       = C.SDL_PIXELFORMAT_BGR555
	argb4444     = C.SDL_PIXELFORMAT_ARGB4444
	rgba4444     = C.SDL_PIXELFORMAT_RGBA4444
	abgr4444     = C.SDL_PIXELFORMAT_ABGR4444
	bgra4444     = C.SDL_PIXELFORMAT_BGRA4444
	argb1555     = C.SDL_PIXELFORMAT_ARGB1555
	rgba5551     = C.SDL_PIXELFORMAT_RGBA5551
	abgr1555     = C.SDL_PIXELFORMAT_ABGR1555
	bgra5551     = C.SDL_PIXELFORMAT_BGRA5551
	rgb565       = C.SDL_PIXELFORMAT_RGB565
	bgr565       = C.SDL_PIXELFORMAT_BGR565
	rgb24        = C.SDL_PIXELFORMAT_RGB24
	bgr24        = C.SDL_PIXELFORMAT_BGR24
	xrgb8888     = C.SDL_PIXELFORMAT_XRGB8888
	rgb888       = C.SDL_PIXELFORMAT_RGB888
	rgbx8888     = C.SDL_PIXELFORMAT_RGBX8888
	xbgr8888     = C.SDL_PIXELFORMAT_XBGR8888
	bgr888       = C.SDL_PIXELFORMAT_BGR888
	bgrx8888     = C.SDL_PIXELFORMAT_BGRX8888
	argb8888     = C.SDL_PIXELFORMAT_ARGB8888
	rgba8888     = C.SDL_PIXELFORMAT_RGBA8888
	abgr8888     = C.SDL_PIXELFORMAT_ABGR8888
	bgra8888     = C.SDL_PIXELFORMAT_BGRA8888
	argb2101010  = C.SDL_PIXELFORMAT_ARGB2101010
	rgba32       = C.SDL_PIXELFORMAT_RGBA32
	argb32       = C.SDL_PIXELFORMAT_ARGB32
	bgra32       = C.SDL_PIXELFORMAT_BGRA32
	abgr32       = C.SDL_PIXELFORMAT_ABGR32
	yv12         = C.SDL_PIXELFORMAT_YV12         // Planar mode: Y + V + U  (3 planes)
	iyuv         = C.SDL_PIXELFORMAT_IYUV         // Planar mode: Y + U + V  (3 planes)
	yuy2         = C.SDL_PIXELFORMAT_YUY2         // Packed mode: Y0+U0+Y1+V0 (1 plane)
	uyvy         = C.SDL_PIXELFORMAT_UYVY         // Packed mode: U0+Y0+V0+Y1 (1 plane)
	yvyu         = C.SDL_PIXELFORMAT_YVYU         // Packed mode: Y0+V0+Y1+U0 (1 plane)
	nv12         = C.SDL_PIXELFORMAT_NV12         // Planar mode: Y + U/V interleaved  (2 planes)
	nv21         = C.SDL_PIXELFORMAT_NV21         // Planar mode: Y + V/U interleaved  (2 planes)
	external_oes = C.SDL_PIXELFORMAT_EXTERNAL_OES // Android video texture format
}

@[typedef]
pub struct C.SDL_Color {
pub mut:
	r u8
	g u8
	b u8
	a u8
}

pub type Color = C.SDL_Color

@[typedef]
pub struct C.SDL_Palette {
pub mut:
	ncolors  int
	colors   &Color
	version  u32
	refcount int
}

pub type Palette = C.SDL_Palette

// NOTE Everything in the pixel format structure is read-only.
@[typedef]
pub struct C.SDL_PixelFormat {
pub:
	format        Format
	palette       &Palette
	BitsPerPixel  u8
	BytesPerPixel u8
	padding       [2]u8
	Rmask         u32
	Gmask         u32
	Bmask         u32
	Amask         u32
	Rloss         u8
	Gloss         u8
	Bloss         u8
	Aloss         u8
	Rshift        u8
	Gshift        u8
	Bshift        u8
	Ashift        u8
	refcount      int
	next          &PixelFormat
}

// PixelFormat is C.SDL_PixelFormat
pub type PixelFormat = C.SDL_PixelFormat

fn C.SDL_GetPixelFormatName(format Format) &char

// get_pixel_format_name gets the human readable name of a pixel format.
//
// `format` the pixel format to query
// returns the human readable name of the specified pixel format or
//          `SDL_PIXELFORMAT_UNKNOWN` if the format isn't recognized.
//
// NOTE This function is available since SDL 2.0.0.
pub fn get_pixel_format_name(format Format) &char {
	return C.SDL_GetPixelFormatName(format)
}

fn C.SDL_PixelFormatEnumToMasks(format Format, bpp &int, rmask &u32, gmask &u32, bmask &u32, amask &u32) bool

// pixel_format_enum_to_masks converts one of the enumerated pixel formats to a bpp value and RGBA masks.
//
// `format` one of the SDL_PixelFormatEnum values
// `bpp` a bits per pixel value; usually 15, 16, or 32
// `Rmask` a pointer filled in with the red mask for the format
// `Gmask` a pointer filled in with the green mask for the format
// `Bmask` a pointer filled in with the blue mask for the format
// `Amask` a pointer filled in with the alpha mask for the format
// returns SDL_TRUE on success or SDL_FALSE if the conversion wasn't
//          possible; call SDL_GetError() for more information.
//
// See also: SDL_MasksToPixelFormatEnum
pub fn pixel_format_enum_to_masks(format Format, bpp &int, rmask &u32, gmask &u32, bmask &u32, amask &u32) bool {
	return C.SDL_PixelFormatEnumToMasks(format, bpp, rmask, gmask, bmask, amask)
}

fn C.SDL_MasksToPixelFormatEnum(bpp int, rmask u32, gmask u32, bmask u32, amask u32) u32

// masks_to_pixel_format_enum converts a bpp value and RGBA masks to an enumerated pixel format.
//
// This will return `SDL_PIXELFORMAT_UNKNOWN` if the conversion wasn't
// possible.
//
// `bpp` a bits per pixel value; usually 15, 16, or 32
// `Rmask` the red mask for the format
// `Gmask` the green mask for the format
// `Bmask` the blue mask for the format
// `Amask` the alpha mask for the format
// returns one of the SDL_PixelFormatEnum values
//
// See also: SDL_PixelFormatEnumToMasks
pub fn masks_to_pixel_format_enum(bpp int, rmask u32, gmask u32, bmask u32, amask u32) Format {
	return unsafe { Format(C.SDL_MasksToPixelFormatEnum(bpp, rmask, gmask, bmask, amask)) }
}

fn C.SDL_AllocFormat(pixel_format Format) &C.SDL_PixelFormat

// alloc_format creates an SDL_PixelFormat structure corresponding to a pixel format.
//
// Returned structure may come from a shared global cache (i.e. not newly
// allocated), and hence should not be modified, especially the palette. Weird
// errors such as `Blit combination not supported` may occur.
//
// `pixel_format` one of the SDL_PixelFormatEnum values
// returns the new SDL_PixelFormat structure or NULL on failure; call
//          SDL_GetError() for more information.
//
// See also: SDL_FreeFormat
pub fn alloc_format(pixel_format Format) &PixelFormat {
	return C.SDL_AllocFormat(pixel_format)
}

fn C.SDL_FreeFormat(format &C.SDL_PixelFormat)

// free_format frees an SDL_PixelFormat structure allocated by SDL_AllocFormat().
//
// `format` the SDL_PixelFormat structure to free
//
// See also: SDL_AllocFormat
pub fn free_format(format &PixelFormat) {
	C.SDL_FreeFormat(format)
}

fn C.SDL_AllocPalette(ncolors int) &C.SDL_Palette

// alloc_palette creates a palette structure with the specified number of color entries.
//
// The palette entries are initialized to white.
//
// `ncolors` represents the number of color entries in the color palette
// returns a new SDL_Palette structure on success or NULL on failure (e.g. if
//          there wasn't enough memory); call SDL_GetError() for more
//          information.
//
// See also: SDL_FreePalette
pub fn alloc_palette(ncolors int) &Palette {
	return C.SDL_AllocPalette(ncolors)
}

fn C.SDL_SetPixelFormatPalette(format &C.SDL_PixelFormat, palette &C.SDL_Palette) int

// set_pixel_format_palette sets the palette for a pixel format structure.
//
// `format` the SDL_PixelFormat structure that will use the palette
// `palette` the SDL_Palette structure that will be used
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// See also: SDL_AllocPalette
// See also: SDL_FreePalette
pub fn set_pixel_format_palette(format &PixelFormat, palette &Palette) int {
	return C.SDL_SetPixelFormatPalette(format, palette)
}

fn C.SDL_SetPaletteColors(palette &C.SDL_Palette, const_colors &C.SDL_Color, firstcolor int, nconst_colors int) int

// set_palette_colors sets a range of colors in a palette.
//
// `palette` the SDL_Palette structure to modify
// `colors` an array of SDL_Color structures to copy into the palette
// `firstcolor` the index of the first palette entry to modify
// `ncolors` the number of entries to modify
// returns 0 on success or a negative error code if not all of the colors
//          could be set; call SDL_GetError() for more information.
//
// See also: SDL_AllocPalette
// See also: SDL_CreateRGBSurface
pub fn set_palette_colors(palette &Palette, const_colors &Color, firstcolor int, nconst_colors int) int {
	return C.SDL_SetPaletteColors(palette, const_colors, firstcolor, nconst_colors)
}

fn C.SDL_FreePalette(palette &C.SDL_Palette)

// free_palette frees a palette created with SDL_AllocPalette().
//
// `palette` the SDL_Palette structure to be freed
//
// See also: SDL_AllocPalette
pub fn free_palette(palette &Palette) {
	C.SDL_FreePalette(palette)
}

fn C.SDL_MapRGB(format &C.SDL_PixelFormat, r u8, g u8, b u8) u32

// map_rgb maps an RGB triple to an opaque pixel value for a given pixel format.
//
// This function maps the RGB color value to the specified pixel format and
// returns the pixel value best approximating the given RGB color value for
// the given pixel format.
//
// If the format has a palette (8-bit) the index of the closest matching color
// in the palette will be returned.
//
// If the specified pixel format has an alpha component it will be returned as
// all 1 bits (fully opaque).
//
// If the pixel format bpp (color depth) is less than 32-bpp then the unused
// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
// format the return value can be assigned to a Uint16, and similarly a Uint8
// for an 8-bpp format).
//
// `format` an SDL_PixelFormat structure describing the pixel format
// `r` the red component of the pixel in the range 0-255
// `g` the green component of the pixel in the range 0-255
// `b` the blue component of the pixel in the range 0-255
// returns a pixel value
//
// See also: SDL_GetRGB
// See also: SDL_GetRGBA
// See also: SDL_MapRGBA
pub fn map_rgb(format &PixelFormat, r u8, g u8, b u8) u32 {
	return C.SDL_MapRGB(format, r, g, b)
}

fn C.SDL_MapRGBA(format &C.SDL_PixelFormat, r u8, g u8, b u8, a u8) u32

// map_rgba maps an RGBA quadruple to a pixel value for a given pixel format.
//
// This function maps the RGBA color value to the specified pixel format and
// returns the pixel value best approximating the given RGBA color value for
// the given pixel format.
//
// If the specified pixel format has no alpha component the alpha value will
// be ignored (as it will be in formats with a palette).
//
// If the format has a palette (8-bit) the index of the closest matching color
// in the palette will be returned.
//
// If the pixel format bpp (color depth) is less than 32-bpp then the unused
// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
// format the return value can be assigned to a Uint16, and similarly a Uint8
// for an 8-bpp format).
//
// `format` an SDL_PixelFormat structure describing the format of the
//               pixel
// `r` the red component of the pixel in the range 0-255
// `g` the green component of the pixel in the range 0-255
// `b` the blue component of the pixel in the range 0-255
// `a` the alpha component of the pixel in the range 0-255
// returns a pixel value
//
// See also: SDL_GetRGB
// See also: SDL_GetRGBA
// See also: SDL_MapRGB
pub fn map_rgba(format &PixelFormat, r u8, g u8, b u8, a u8) u32 {
	return C.SDL_MapRGBA(format, r, g, b, a)
}

fn C.SDL_GetRGB(pixel u32, const_format &C.SDL_PixelFormat, r &u8, g &u8, b &u8)

// get_rgb gets RGB values from a pixel in the specified format.
//
// This function uses the entire 8-bit [0..255] range when converting color
// components from pixel formats with less than 8-bits per RGB component
// (e.g., a completely white pixel in 16-bit RGB565 format would return [0xff,
// 0xff, 0xff] not [0xf8, 0xfc, 0xf8]).
//
// `pixel` a pixel value
// `format` an SDL_PixelFormat structure describing the format of the
//               pixel
// `r` a pointer filled in with the red component
// `g` a pointer filled in with the green component
// `b` a pointer filled in with the blue component
//
// See also: SDL_GetRGBA
// See also: SDL_MapRGB
// See also: SDL_MapRGBA
pub fn get_rgb(pixel u32, const_format &PixelFormat, r &u8, g &u8, b &u8) {
	C.SDL_GetRGB(pixel, const_format, r, g, b)
}

fn C.SDL_GetRGBA(pixel u32, const_format &C.SDL_PixelFormat, r &u8, g &u8, b &u8, a &u8)

// get_rgba gets RGBA values from a pixel in the specified format.
//
// This function uses the entire 8-bit [0..255] range when converting color
// components from pixel formats with less than 8-bits per RGB component
// (e.g., a completely white pixel in 16-bit RGB565 format would return [0xff,
// 0xff, 0xff] not [0xf8, 0xfc, 0xf8]).
//
// If the surface has no alpha component, the alpha will be returned as 0xff
// (100% opaque).
//
// `pixel` a pixel value
// `format` an SDL_PixelFormat structure describing the format of the
//               pixel
// `r` a pointer filled in with the red component
// `g` a pointer filled in with the green component
// `b` a pointer filled in with the blue component
// `a` a pointer filled in with the alpha component
//
// See also: SDL_GetRGB
// See also: SDL_MapRGB
// See also: SDL_MapRGBA
pub fn get_rgba(pixel u32, const_format &PixelFormat, r &u8, g &u8, b &u8, a &u8) {
	C.SDL_GetRGBA(pixel, const_format, r, g, b, a)
}

fn C.SDL_CalculateGammaRamp(gamma f32, ramp &u16)

// calculate_gamma_ramp calculates a 256 entry gamma ramp for a gamma value.
//
// `gamma` a gamma value where 0.0 is black and 1.0 is identity
// `ramp` an array of 256 values filled in with the gamma ramp
//
// See also: SDL_SetWindowGammaRamp
pub fn calculate_gamma_ramp(gamma f32, ramp &u16) {
	C.SDL_CalculateGammaRamp(gamma, ramp)
}
