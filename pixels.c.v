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
pub const (
	alpha_opaque      = C.SDL_ALPHA_OPAQUE // 255
	alpha_transparent = C.SDL_ALPHA_TRANSPARENT // 0
)

// Pixel type.
// PixelType is C.SDL_PixelType
pub enum PixelType {
	unknown = C.SDL_PIXELTYPE_UNKNOWN
	index1 = C.SDL_PIXELTYPE_INDEX1
	index4 = C.SDL_PIXELTYPE_INDEX4
	index8 = C.SDL_PIXELTYPE_INDEX8
	packed8 = C.SDL_PIXELTYPE_PACKED8
	packed16 = C.SDL_PIXELTYPE_PACKED16
	packed32 = C.SDL_PIXELTYPE_PACKED32
	arrayu8 = C.SDL_PIXELTYPE_ARRAYU8
	arrayu16 = C.SDL_PIXELTYPE_ARRAYU16
	arrayu32 = C.SDL_PIXELTYPE_ARRAYU32
	arrayf16 = C.SDL_PIXELTYPE_ARRAYF16
	arrayf32 = C.SDL_PIXELTYPE_ARRAYF32
}

// Bitmap pixel order, high bit -> low bit.
// BitmapOrder is C.SDL_BitmapOrder
pub enum BitmapOrder {
	@none = C.SDL_BITMAPORDER_NONE
	order_4321 = C.SDL_BITMAPORDER_4321
	order_1234 = C.SDL_BITMAPORDER_1234
}

// Packed component order, high bit -> low bit.
// PackedOrder is C.SDL_PackedOrder
pub enum PackedOrder {
	@none = C.SDL_PACKEDORDER_NONE
	xrgb = C.SDL_PACKEDORDER_XRGB
	rgbx = C.SDL_PACKEDORDER_RGBX
	argb = C.SDL_PACKEDORDER_ARGB
	rgba = C.SDL_PACKEDORDER_RGBA
	xbgr = C.SDL_PACKEDORDER_XBGR
	bgrx = C.SDL_PACKEDORDER_BGRX
	abgr = C.SDL_PACKEDORDER_ABGR
	bgra = C.SDL_PACKEDORDER_BGRA
}

//** Array component order, low byte -> high byte. */
// ArrayOrder is C.SDL_ArrayOrder
pub enum ArrayOrder {
	@none = C.SDL_ARRAYORDER_NONE
	rgb = C.SDL_ARRAYORDER_RGB
	rgba = C.SDL_ARRAYORDER_RGBA
	argb = C.SDL_ARRAYORDER_ARGB
	bgr = C.SDL_ARRAYORDER_BGR
	bgra = C.SDL_ARRAYORDER_BGRA
	abgr = C.SDL_ARRAYORDER_ABGR
}

// Packed component layout.
// PackedLayout is C.SDL_PackedLayout
pub enum PackedLayout {
	@none = C.SDL_PACKEDLAYOUT_NONE
	layout_332 = C.SDL_PACKEDLAYOUT_332
	layout_4444 = C.SDL_PACKEDLAYOUT_4444
	layout_1555 = C.SDL_PACKEDLAYOUT_1555
	layout_5551 = C.SDL_PACKEDLAYOUT_5551
	layout_565 = C.SDL_PACKEDLAYOUT_565
	layout_8888 = C.SDL_PACKEDLAYOUT_8888
	layout_2101010 = C.SDL_PACKEDLAYOUT_2101010
	layout_1010102 = C.SDL_PACKEDLAYOUT_1010102
}

pub enum Format {
	unknown = C.SDL_PIXELFORMAT_UNKNOWN
	index1lsb = C.SDL_PIXELFORMAT_INDEX1LSB
	index1msb = C.SDL_PIXELFORMAT_INDEX1MSB
	index4lsb = C.SDL_PIXELFORMAT_INDEX4LSB
	index4msb = C.SDL_PIXELFORMAT_INDEX4MSB
	index8 = C.SDL_PIXELFORMAT_INDEX8
	rgb332 = C.SDL_PIXELFORMAT_RGB332
	xrgb4444 = C.SDL_PIXELFORMAT_XRGB4444
	rgb444 = C.SDL_PIXELFORMAT_RGB444
	xbgr4444 = C.SDL_PIXELFORMAT_XBGR4444
	bgr444 = C.SDL_PIXELFORMAT_BGR444
	xrgb1555 = C.SDL_PIXELFORMAT_XRGB1555
	rgb555 = C.SDL_PIXELFORMAT_RGB555
	xbgr1555 = C.SDL_PIXELFORMAT_XBGR1555
	bgr555 = C.SDL_PIXELFORMAT_BGR555
	argb4444 = C.SDL_PIXELFORMAT_ARGB4444
	rgba4444 = C.SDL_PIXELFORMAT_RGBA4444
	abgr4444 = C.SDL_PIXELFORMAT_ABGR4444
	bgra4444 = C.SDL_PIXELFORMAT_BGRA4444
	argb1555 = C.SDL_PIXELFORMAT_ARGB1555
	rgba5551 = C.SDL_PIXELFORMAT_RGBA5551
	abgr1555 = C.SDL_PIXELFORMAT_ABGR1555
	bgra5551 = C.SDL_PIXELFORMAT_BGRA5551
	rgb565 = C.SDL_PIXELFORMAT_RGB565
	bgr565 = C.SDL_PIXELFORMAT_BGR565
	rgb24 = C.SDL_PIXELFORMAT_RGB24
	bgr24 = C.SDL_PIXELFORMAT_BGR24
	xrgb8888 = C.SDL_PIXELFORMAT_XRGB8888
	rgb888 = C.SDL_PIXELFORMAT_RGB888
	rgbx8888 = C.SDL_PIXELFORMAT_RGBX8888
	xbgr8888 = C.SDL_PIXELFORMAT_XBGR8888
	bgr888 = C.SDL_PIXELFORMAT_BGR888
	bgrx8888 = C.SDL_PIXELFORMAT_BGRX8888
	argb8888 = C.SDL_PIXELFORMAT_ARGB8888
	rgba8888 = C.SDL_PIXELFORMAT_RGBA8888
	abgr8888 = C.SDL_PIXELFORMAT_ABGR8888
	bgra8888 = C.SDL_PIXELFORMAT_BGRA8888
	argb2101010 = C.SDL_PIXELFORMAT_ARGB2101010
	rgba32 = C.SDL_PIXELFORMAT_RGBA32
	argb32 = C.SDL_PIXELFORMAT_ARGB32
	bgra32 = C.SDL_PIXELFORMAT_BGRA32
	abgr32 = C.SDL_PIXELFORMAT_ABGR32
	yv12 = C.SDL_PIXELFORMAT_YV12 // Planar mode: Y + V + U  (3 planes)
	iyuv = C.SDL_PIXELFORMAT_IYUV // Planar mode: Y + U + V  (3 planes)
	yuy2 = C.SDL_PIXELFORMAT_YUY2 // Packed mode: Y0+U0+Y1+V0 (1 plane)
	uyvy = C.SDL_PIXELFORMAT_UYVY // Packed mode: U0+Y0+V0+Y1 (1 plane)
	yvyu = C.SDL_PIXELFORMAT_YVYU // Packed mode: Y0+V0+Y1+U0 (1 plane)
	nv12 = C.SDL_PIXELFORMAT_NV12 // Planar mode: Y + U/V interleaved  (2 planes)
	nv21 = C.SDL_PIXELFORMAT_NV21 // Planar mode: Y + V/U interleaved  (2 planes)
	external_oes = C.SDL_PIXELFORMAT_EXTERNAL_OES // Android video texture format
}

[typedef]
struct C.SDL_Color {
pub mut:
	r byte
	g byte
	b byte
	a byte
}

pub type Color = C.SDL_Color

[typedef]
struct C.SDL_Palette {
pub mut:
	ncolors  int
	colors   &Color
	version  u32
	refcount int
}

pub type Palette = C.SDL_Palette

// NOTE Everything in the pixel format structure is read-only.
[typedef]
struct C.SDL_PixelFormat {
pub:
	format          Format
	palette         &Palette
	bits_per_pixel  byte
	bytes_per_pixel byte
	padding         [2]byte
	rmask           u32
	gmask           u32
	bmask           u32
	amask           u32
	rloss           byte
	gloss           byte
	bloss           byte
	aloss           byte
	rshift          byte
	gshift          byte
	bshift          byte
	ashift          byte
	refcount        int
	next            &PixelFormat
}

// PixelFormat is C.SDL_PixelFormat
pub type PixelFormat = C.SDL_PixelFormat

fn C.SDL_GetPixelFormatName(format Format) &char

// get the human readable name of a pixel format
pub fn get_pixel_format_name(format Format) string {
	return unsafe { cstring_to_vstring(C.SDL_GetPixelFormatName(format)) }
}

fn C.SDL_PixelFormatEnumToMasks(format Format, bpp &int, rmask &u32, gmask &u32, bmask &u32, amask &u32) bool

// pixel_format_enum_to_masks converts one of the enumerated pixel formats to a bpp and RGBA masks.
//
// returns SDL_TRUE, or SDL_FALSE if the conversion wasn't possible.
//
// See also: SDL_MasksToPixelFormatEnum()
pub fn pixel_format_enum_to_masks(format Format, bpp &int, rmask &u32, gmask &u32, bmask &u32, amask &u32) bool {
	return C.SDL_PixelFormatEnumToMasks(format, bpp, rmask, gmask, bmask, amask)
}

fn C.SDL_MasksToPixelFormatEnum(bpp int, rmask u32, gmask u32, bmask u32, amask u32) u32

// masks_to_pixel_format_enum converts a bpp and RGBA masks to an enumerated pixel format.
//
// returns The pixel format, or ::SDL_PIXELFORMAT_UNKNOWN if the conversion
// wasn't possible.
//
// See also: SDL_PixelFormatEnumToMasks()
pub fn masks_to_pixel_format_enum(bpp int, rmask u32, gmask u32, bmask u32, amask u32) Format {
	return Format(C.SDL_MasksToPixelFormatEnum(bpp, rmask, gmask, bmask, amask))
}

fn C.SDL_AllocFormat(pixel_format Format) &C.SDL_PixelFormat

// alloc_format creates an SDL_PixelFormat structure from a pixel format enum.
pub fn alloc_format(pixel_format Format) &PixelFormat {
	return C.SDL_AllocFormat(pixel_format)
}

fn C.SDL_FreeFormat(format &C.SDL_PixelFormat)

// free_format frees an SDL_PixelFormat structure.
pub fn free_format(format &PixelFormat) {
	C.SDL_FreeFormat(format)
}

fn C.SDL_AllocPalette(ncolors int) &C.SDL_Palette

// alloc_palette create a palette structure with the specified
// number of color entries.
//
// returns A new palette, or NULL if there wasn't enough memory.
//
// NOTE The palette entries are initialized to white.
//
// See also: SDL_FreePalette()
pub fn alloc_palette(ncolors int) &Palette {
	return C.SDL_AllocPalette(ncolors)
}

fn C.SDL_SetPixelFormatPalette(format &C.SDL_PixelFormat, palette &C.SDL_Palette) int

// set_pixel_format_palette set the palette for a pixel format structure.
pub fn set_pixel_format_palette(format &PixelFormat, palette &Palette) int {
	return C.SDL_SetPixelFormatPalette(format, palette)
}

fn C.SDL_SetPaletteColors(palette &C.SDL_Palette, colors &C.SDL_Color, firstcolor int, ncolors int) int

// set_palette_colors sets a range of colors in a palette.
//
// `palette`    The palette to modify.
// `colors`     An array of colors to copy into the palette.
// `firstcolor` The index of the first palette entry to modify.
// `ncolors`    The number of entries to modify.
//
// returns 0 on success, or -1 if not all of the colors could be set.
pub fn set_palette_colors(palette &Palette, colors &Color, firstcolor int, ncolors int) int {
	return C.SDL_SetPaletteColors(palette, colors, firstcolor, ncolors)
}

fn C.SDL_FreePalette(palette &C.SDL_Palette)

// free_palette frees a palette created with SDL_AllocPalette().
pub fn free_palette(palette &Palette) {
	C.SDL_FreePalette(palette)
}

fn C.SDL_MapRGB(format &C.SDL_PixelFormat, r byte, g byte, b byte) u32

// map_rgb maps an RGB triple to an opaque pixel value for a given pixel format.
pub fn map_rgb(format &PixelFormat, r byte, g byte, b byte) u32 {
	return C.SDL_MapRGB(format, r, g, b)
}

fn C.SDL_MapRGBA(format &C.SDL_PixelFormat, r byte, g byte, b byte, a byte) u32

// map_rgba maps an RGBA quadruple to a pixel value for a given pixel format.
pub fn map_rgba(format &PixelFormat, r byte, g byte, b byte, a byte) u32 {
	return C.SDL_MapRGBA(format, r, g, b, a)
}

fn C.SDL_GetRGB(pixel u32, format &C.SDL_PixelFormat, r &byte, g &byte, b &byte)

// get_rgb gets the RGB components from a pixel of the specified format.
pub fn get_rgb(pixel u32, format &PixelFormat, r &byte, g &byte, b &byte) {
	C.SDL_GetRGB(pixel, format, r, g, b)
}

fn C.SDL_GetRGBA(pixel u32, format &C.SDL_PixelFormat, r &byte, g &byte, b &byte, a &byte)

// get_rgba gets the RGBA components from a pixel of the specified format.
pub fn get_rgba(pixel u32, format &PixelFormat, r &byte, g &byte, b &byte, a &byte) {
	C.SDL_GetRGBA(pixel, format, r, g, b, a)
}

fn C.SDL_CalculateGammaRamp(gamma f32, ramp &u16)

// calculate_gamma_ramp calculates a 256 entry gamma ramp for a gamma value.
pub fn calculate_gamma_ramp(gamma f32, ramp &u16) {
	C.SDL_CalculateGammaRamp(gamma, ramp)
}
