// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_pixels.h
//

// SDL offers facilities for pixel management.
//
// Largely these facilities deal with pixel _format_: what does this set of
// bits represent?
//
// If you mostly want to think of a pixel as some combination of red, green,
// blue, and maybe alpha intensities, this is all pretty straightforward, and
// in many cases, is enough information to build a perfectly fine game.
//
// However, the actual definition of a pixel is more complex than that:
//
// Pixels are a representation of a color in a particular color space.
//
// The first characteristic of a color space is the color type. SDL
// understands two different color types, RGB and YCbCr, or in SDL also
// referred to as YUV.
//
// RGB colors consist of red, green, and blue channels of color that are added
// together to represent the colors we see on the screen.
//
// https://en.wikipedia.org/wiki/RGB_color_model
//
// YCbCr colors represent colors as a Y luma brightness component and red and
// blue chroma color offsets. This color representation takes advantage of the
// fact that the human eye is more sensitive to brightness than the color in
// an image. The Cb and Cr components are often compressed and have lower
// resolution than the luma component.
//
// https://en.wikipedia.org/wiki/YCbCr
//
// When the color information in YCbCr is compressed, the Y pixels are left at
// full resolution and each Cr and Cb pixel represents an average of the color
// information in a block of Y pixels. The chroma location determines where in
// that block of pixels the color information is coming from.
//
// The color range defines how much of the pixel to use when converting a
// pixel into a color on the display. When the full color range is used, the
// entire numeric range of the pixel bits is significant. When narrow color
// range is used, for historical reasons, the pixel uses only a portion of the
// numeric range to represent colors.
//
// The color primaries and white point are a definition of the colors in the
// color space relative to the standard XYZ color space.
//
// https://en.wikipedia.org/wiki/CIE_1931_color_space
//
// The transfer characteristic, or opto-electrical transfer function (OETF),
// is the way a color is converted from mathematically linear space into a
// non-linear output signals.
//
// https://en.wikipedia.org/wiki/Rec._709#Transfer_characteristics
//
// The matrix coefficients are used to convert between YCbCr and RGB colors.

// A fully opaque 8-bit alpha value.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_ALPHA_TRANSPARENT
pub const alpha_opaque = u8(C.SDL_ALPHA_OPAQUE) // 255

pub const alpha_opaque_float = C.SDL_ALPHA_OPAQUE_FLOAT // 1.0f

// A fully transparent 8-bit alpha value.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_ALPHA_OPAQUE
pub const alpha_transparent = C.SDL_ALPHA_TRANSPARENT // 0

pub const alpha_transparent_float = C.SDL_ALPHA_TRANSPARENT_FLOAT // 0.0f

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
	// appended at the end for compatibility with sdl2-compat:
	index2 = C.SDL_PIXELTYPE_INDEX2
}

// BitmapOrder is C.SDL_BitmapOrder
pub enum BitmapOrder {
	@none = C.SDL_BITMAPORDER_NONE
	_4321 = C.SDL_BITMAPORDER_4321
	_1234 = C.SDL_BITMAPORDER_1234
}

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

// PackedLayout is C.SDL_PackedLayout
pub enum PackedLayout {
	@none    = C.SDL_PACKEDLAYOUT_NONE
	_332     = C.SDL_PACKEDLAYOUT_332
	_4444    = C.SDL_PACKEDLAYOUT_4444
	_1555    = C.SDL_PACKEDLAYOUT_1555
	_5551    = C.SDL_PACKEDLAYOUT_5551
	_565     = C.SDL_PACKEDLAYOUT_565
	_8888    = C.SDL_PACKEDLAYOUT_8888
	_2101010 = C.SDL_PACKEDLAYOUT_2101010
	_1010102 = C.SDL_PACKEDLAYOUT_1010102
}

// TODO: Function: #define SDL_DEFINE_PIXELFOURCC(A, B, C, D) SDL_FOURCC(A, B, C, D)

// TODO: Non-numerical: #define SDL_DEFINE_PIXELFORMAT(type, order, layout, bits, bytes) \

// TODO: Function: #define SDL_PIXELFLAG(format)    (((format) >> 28) & 0x0F)

// TODO: Function: #define SDL_PIXELTYPE(format)    (((format) >> 24) & 0x0F)

// TODO: Function: #define SDL_PIXELORDER(format)   (((format) >> 20) & 0x0F)

// TODO: Function: #define SDL_PIXELLAYOUT(format)  (((format) >> 16) & 0x0F)

// TODO: Non-numerical: #define SDL_BITSPERPIXEL(format) \

// TODO: Non-numerical: #define SDL_BYTESPERPIXEL(format) \

// TODO: Non-numerical: #define SDL_ISPIXELFORMAT_INDEXED(format)   \

// TODO: Non-numerical: #define SDL_ISPIXELFORMAT_PACKED(format) \

// TODO: Non-numerical: #define SDL_ISPIXELFORMAT_ARRAY(format) \

// TODO: Non-numerical: #define SDL_ISPIXELFORMAT_10BIT(format)    \

// TODO: Non-numerical: #define SDL_ISPIXELFORMAT_FLOAT(format)    \

// TODO: Non-numerical: #define SDL_ISPIXELFORMAT_ALPHA(format)   \

// TODO: Function: #define SDL_ISPIXELFORMAT_FOURCC(format)

// PixelFormat is C.SDL_PixelFormat
pub enum PixelFormat {
	unknown   = C.SDL_PIXELFORMAT_UNKNOWN   // 0,
	index1lsb = C.SDL_PIXELFORMAT_INDEX1LSB // 0x11100100u,
	// 0x11200100u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX1, SDL_BITMAPORDER_4321, 0, 1, 0),
	index1msb = C.SDL_PIXELFORMAT_INDEX1MSB
	// 0x1c100200u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX1, SDL_BITMAPORDER_1234, 0, 1, 0),
	index2lsb = C.SDL_PIXELFORMAT_INDEX2LSB
	// 0x1c200200u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX2, SDL_BITMAPORDER_4321, 0, 2, 0),
	index2msb = C.SDL_PIXELFORMAT_INDEX2MSB
	// 0x12100400u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX2, SDL_BITMAPORDER_1234, 0, 2, 0),
	index4lsb = C.SDL_PIXELFORMAT_INDEX4LSB
	// 0x12200400u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX4, SDL_BITMAPORDER_4321, 0, 4, 0),
	index4msb = C.SDL_PIXELFORMAT_INDEX4MSB
	// 0x13000801u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX4, SDL_BITMAPORDER_1234, 0, 4, 0),
	index8 = C.SDL_PIXELFORMAT_INDEX8
	// 0x14110801u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX8, 0, 0, 8, 1),
	rgb332 = C.SDL_PIXELFORMAT_RGB332
	// 0x15120c02u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED8, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_332, 8, 1),
	xrgb4444 = C.SDL_PIXELFORMAT_XRGB4444
	// 0x15520c02u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_4444, 12, 2),
	xbgr4444 = C.SDL_PIXELFORMAT_XBGR4444
	// 0x15130f02u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_4444, 12, 2),
	xrgb1555 = C.SDL_PIXELFORMAT_XRGB1555
	// 0x15530f02u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_1555, 15, 2),
	xbgr1555 = C.SDL_PIXELFORMAT_XBGR1555
	// 0x15321002u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_1555, 15, 2),
	argb4444 = C.SDL_PIXELFORMAT_ARGB4444
	// 0x15421002u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_4444, 16, 2),
	rgba4444 = C.SDL_PIXELFORMAT_RGBA4444
	// 0x15721002u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_4444, 16, 2),
	abgr4444 = C.SDL_PIXELFORMAT_ABGR4444
	// 0x15821002u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_4444, 16, 2),
	bgra4444 = C.SDL_PIXELFORMAT_BGRA4444
	// 0x15331002u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_4444, 16, 2),
	argb1555 = C.SDL_PIXELFORMAT_ARGB1555
	// 0x15441002u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_1555, 16, 2),
	rgba5551 = C.SDL_PIXELFORMAT_RGBA5551
	// 0x15731002u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_5551, 16, 2),
	abgr1555 = C.SDL_PIXELFORMAT_ABGR1555
	// 0x15841002u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_1555, 16, 2),
	bgra5551 = C.SDL_PIXELFORMAT_BGRA5551
	// 0x15151002u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_5551, 16, 2),
	rgb565 = C.SDL_PIXELFORMAT_RGB565
	// 0x15551002u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_565, 16, 2),
	bgr565 = C.SDL_PIXELFORMAT_BGR565
	// 0x17101803u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_565, 16, 2),
	rgb24 = C.SDL_PIXELFORMAT_RGB24
	// 0x17401803u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU8, SDL_ARRAYORDER_RGB, 0, 24, 3),
	bgr24 = C.SDL_PIXELFORMAT_BGR24
	// 0x16161804u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU8, SDL_ARRAYORDER_BGR, 0, 24, 3),
	xrgb8888 = C.SDL_PIXELFORMAT_XRGB8888
	// 0x16261804u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_8888, 24, 4),
	rgbx8888 = C.SDL_PIXELFORMAT_RGBX8888
	// 0x16561804u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_RGBX, SDL_PACKEDLAYOUT_8888, 24, 4),
	xbgr8888 = C.SDL_PIXELFORMAT_XBGR8888
	// 0x16661804u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_8888, 24, 4),
	bgrx8888 = C.SDL_PIXELFORMAT_BGRX8888
	// 0x16362004u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_BGRX, SDL_PACKEDLAYOUT_8888, 24, 4),
	argb8888 = C.SDL_PIXELFORMAT_ARGB8888
	// 0x16462004u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_8888, 32, 4),
	rgba8888 = C.SDL_PIXELFORMAT_RGBA8888
	// 0x16762004u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_8888, 32, 4),
	abgr8888 = C.SDL_PIXELFORMAT_ABGR8888
	// 0x16862004u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_8888, 32, 4),
	bgra8888 = C.SDL_PIXELFORMAT_BGRA8888
	// 0x16172004u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_8888, 32, 4),
	xrgb2101010 = C.SDL_PIXELFORMAT_XRGB2101010
	// 0x16572004u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_2101010, 32, 4),
	xbgr2101010 = C.SDL_PIXELFORMAT_XBGR2101010
	// 0x16372004u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_2101010, 32, 4),
	argb2101010 = C.SDL_PIXELFORMAT_ARGB2101010
	// 0x16772004u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_2101010, 32, 4),
	abgr2101010 = C.SDL_PIXELFORMAT_ABGR2101010
	// 0x18103006u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_2101010, 32, 4),
	rgb48 = C.SDL_PIXELFORMAT_RGB48
	// 0x18403006u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_RGB, 0, 48, 6),
	bgr48 = C.SDL_PIXELFORMAT_BGR48
	// 0x18204008u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_BGR, 0, 48, 6),
	rgba64 = C.SDL_PIXELFORMAT_RGBA64
	// 0x18304008u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_RGBA, 0, 64, 8),
	argb64 = C.SDL_PIXELFORMAT_ARGB64
	// 0x18504008u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_ARGB, 0, 64, 8),
	bgra64 = C.SDL_PIXELFORMAT_BGRA64
	// 0x18604008u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_BGRA, 0, 64, 8),
	abgr64 = C.SDL_PIXELFORMAT_ABGR64
	// 0x1a103006u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_ABGR, 0, 64, 8),
	rgb48_float = C.SDL_PIXELFORMAT_RGB48_FLOAT
	// 0x1a403006u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_RGB, 0, 48, 6),
	bgr48_float = C.SDL_PIXELFORMAT_BGR48_FLOAT
	// 0x1a204008u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_BGR, 0, 48, 6),
	rgba64_float = C.SDL_PIXELFORMAT_RGBA64_FLOAT
	// 0x1a304008u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_RGBA, 0, 64, 8),
	argb64_float = C.SDL_PIXELFORMAT_ARGB64_FLOAT
	// 0x1a504008u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_ARGB, 0, 64, 8),
	bgra64_float = C.SDL_PIXELFORMAT_BGRA64_FLOAT
	// 0x1a604008u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_BGRA, 0, 64, 8),
	abgr64_float = C.SDL_PIXELFORMAT_ABGR64_FLOAT
	// 0x1b10600cu, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_ABGR, 0, 64, 8),
	rgb96_float = C.SDL_PIXELFORMAT_RGB96_FLOAT
	// 0x1b40600cu, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_RGB, 0, 96, 12),
	bgr96_float = C.SDL_PIXELFORMAT_BGR96_FLOAT
	// 0x1b208010u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_BGR, 0, 96, 12),
	rgba128_float = C.SDL_PIXELFORMAT_RGBA128_FLOAT
	// 0x1b308010u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_RGBA, 0, 128, 16),
	argb128_float = C.SDL_PIXELFORMAT_ARGB128_FLOAT
	// 0x1b508010u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_ARGB, 0, 128, 16),
	bgra128_float = C.SDL_PIXELFORMAT_BGRA128_FLOAT
	// 0x1b608010u, SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_BGRA, 0, 128, 16),
	abgr128_float = C.SDL_PIXELFORMAT_ABGR128_FLOAT
	yv12          = C.SDL_PIXELFORMAT_YV12         // 0x32315659u, Planar mode: Y + V + U(3 planes)
	iyuv          = C.SDL_PIXELFORMAT_IYUV         // 0x56555949u, Planar mode: Y + U + V(3 planes)
	yuy2          = C.SDL_PIXELFORMAT_YUY2         // 0x32595559u, Packed mode: Y0+U0+Y1+V0 (1 plane)
	uyvy          = C.SDL_PIXELFORMAT_UYVY         // 0x59565955u, Packed mode: U0+Y0+V0+Y1 (1 plane)
	yvyu          = C.SDL_PIXELFORMAT_YVYU         // 0x55595659u, Packed mode: Y0+V0+Y1+U0 (1 plane)
	nv12          = C.SDL_PIXELFORMAT_NV12         // 0x3231564eu, Planar mode: Y + U/V interleaved(2 planes)
	nv21          = C.SDL_PIXELFORMAT_NV21         // 0x3132564eu, Planar mode: Y + V/U interleaved(2 planes)
	p010          = C.SDL_PIXELFORMAT_P010         // 0x30313050u, Planar mode: Y + U/V interleaved(2 planes)
	external_oes  = C.SDL_PIXELFORMAT_EXTERNAL_OES // 0x2053454fu, Android video texture format
	rgba32        = C.SDL_PIXELFORMAT_RGBA32       // SDL_PIXELFORMAT_RGBA8888,
	argb32        = C.SDL_PIXELFORMAT_ARGB32       // SDL_PIXELFORMAT_ARGB8888,
	bgra32        = C.SDL_PIXELFORMAT_BGRA32       // SDL_PIXELFORMAT_BGRA8888,
	abgr32        = C.SDL_PIXELFORMAT_ABGR32       // SDL_PIXELFORMAT_ABGR8888,
	rgbx32        = C.SDL_PIXELFORMAT_RGBX32       // SDL_PIXELFORMAT_RGBX8888,
	xrgb32        = C.SDL_PIXELFORMAT_XRGB32       // SDL_PIXELFORMAT_XRGB8888,
	bgrx32        = C.SDL_PIXELFORMAT_BGRX32       // SDL_PIXELFORMAT_BGRX8888,
	xbgr32        = C.SDL_PIXELFORMAT_XBGR32       // SDL_PIXELFORMAT_XBGR8888,
}

// ColorType is C.SDL_ColorType
pub enum ColorType {
	unknown = C.SDL_COLOR_TYPE_UNKNOWN // 0,
	rgb     = C.SDL_COLOR_TYPE_RGB     // 1,
	ycbcr   = C.SDL_COLOR_TYPE_YCBCR   // 2,
}

// ColorRange is C.SDL_ColorRange
pub enum ColorRange {
	unknown = C.SDL_COLOR_RANGE_UNKNOWN // 0,
	limited = C.SDL_COLOR_RANGE_LIMITED // 1, Narrow range, e.g. 16-235 for 8-bit RGB and luma, and 16-240 for 8-bit chroma
	full    = C.SDL_COLOR_RANGE_FULL    // 2, Full range, e.g. 0-255 for 8-bit RGB and luma, and 1-255 for 8-bit chroma
}

// ColorPrimaries is C.SDL_ColorPrimaries
pub enum ColorPrimaries {
	unknown      = C.SDL_COLOR_PRIMARIES_UNKNOWN      // 0,
	bt709        = C.SDL_COLOR_PRIMARIES_BT709        // 1, ITU-R BT.709-6
	unspecified  = C.SDL_COLOR_PRIMARIES_UNSPECIFIED  // 2,
	bt470m       = C.SDL_COLOR_PRIMARIES_BT470M       // 4, ITU-R BT.470-6 System M
	bt470bg      = C.SDL_COLOR_PRIMARIES_BT470BG      // 5, ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625
	bt601        = C.SDL_COLOR_PRIMARIES_BT601        // 6, ITU-R BT.601-7 525, SMPTE 170M
	smpte240     = C.SDL_COLOR_PRIMARIES_SMPTE240     // 7, SMPTE 240M, functionally the same as SDL_COLOR_PRIMARIES_BT601
	generic_film = C.SDL_COLOR_PRIMARIES_GENERIC_FILM // 8, Generic film (color filters using Illuminant C)
	bt2020       = C.SDL_COLOR_PRIMARIES_BT2020       // 9, ITU-R BT.2020-2 / ITU-R BT.2100-0
	xyz          = C.SDL_COLOR_PRIMARIES_XYZ          // 10, SMPTE ST 428-1
	smpte431     = C.SDL_COLOR_PRIMARIES_SMPTE431     // 11, SMPTE RP 431-2
	smpte432     = C.SDL_COLOR_PRIMARIES_SMPTE432     // 12, SMPTE EG 432-1 / DCI P3
	ebu3213      = C.SDL_COLOR_PRIMARIES_EBU3213      // 22, EBU Tech. 3213-E
	custom       = C.SDL_COLOR_PRIMARIES_CUSTOM       // 31,
}

// TransferCharacteristics is C.SDL_TransferCharacteristics
pub enum TransferCharacteristics {
	unknown       = C.SDL_TRANSFER_CHARACTERISTICS_UNKNOWN       // 0,
	bt709         = C.SDL_TRANSFER_CHARACTERISTICS_BT709         // 1, Rec. ITU-R BT.709-6 / ITU-R BT1361
	unspecified   = C.SDL_TRANSFER_CHARACTERISTICS_UNSPECIFIED   // 2,
	gamma22       = C.SDL_TRANSFER_CHARACTERISTICS_GAMMA22       // 4, ITU-R BT.470-6 System M / ITU-R BT1700 625 PAL & SECAM
	gamma28       = C.SDL_TRANSFER_CHARACTERISTICS_GAMMA28       // 5, ITU-R BT.470-6 System B, G
	bt601         = C.SDL_TRANSFER_CHARACTERISTICS_BT601         // 6, SMPTE ST 170M / ITU-R BT.601-7 525 or 625
	smpte240      = C.SDL_TRANSFER_CHARACTERISTICS_SMPTE240      // 7, SMPTE ST 240M
	linear        = C.SDL_TRANSFER_CHARACTERISTICS_LINEAR        // 8,
	log100        = C.SDL_TRANSFER_CHARACTERISTICS_LOG100        // 9,
	log100_sqrt10 = C.SDL_TRANSFER_CHARACTERISTICS_LOG100_SQRT10 // 10,
	iec61966      = C.SDL_TRANSFER_CHARACTERISTICS_IEC61966      // 11, IEC 61966-2-4
	bt1361        = C.SDL_TRANSFER_CHARACTERISTICS_BT1361        // 12, ITU-R BT1361 Extended Colour Gamut
	srgb          = C.SDL_TRANSFER_CHARACTERISTICS_SRGB          // 13, IEC 61966-2-1 (sRGB or sYCC)
	bt2020_10bit  = C.SDL_TRANSFER_CHARACTERISTICS_BT2020_10BIT  // 14, ITU-R BT2020 for 10-bit system
	bt2020_12bit  = C.SDL_TRANSFER_CHARACTERISTICS_BT2020_12BIT  // 15, ITU-R BT2020 for 12-bit system
	pq            = C.SDL_TRANSFER_CHARACTERISTICS_PQ            // 16, SMPTE ST 2084 for 10-, 12-, 14- and 16-bit systems
	smpte428      = C.SDL_TRANSFER_CHARACTERISTICS_SMPTE428      // 17, SMPTE ST 428-1
	hlg           = C.SDL_TRANSFER_CHARACTERISTICS_HLG           // 18, ARIB STD-B67, known as "hybrid log-gamma" (HLG)
	custom        = C.SDL_TRANSFER_CHARACTERISTICS_CUSTOM        // 31,
}

// MatrixCoefficients is C.SDL_MatrixCoefficients
pub enum MatrixCoefficients {
	identity           = C.SDL_MATRIX_COEFFICIENTS_IDENTITY           // 0,
	bt709              = C.SDL_MATRIX_COEFFICIENTS_BT709              // 1, ITU-R BT.709-6
	unspecified        = C.SDL_MATRIX_COEFFICIENTS_UNSPECIFIED        // 2,
	fcc                = C.SDL_MATRIX_COEFFICIENTS_FCC                // 4, US FCC Title 47
	bt470bg            = C.SDL_MATRIX_COEFFICIENTS_BT470BG            // 5, ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625, functionally the same as SDL_MATRIX_COEFFICIENTS_BT601
	bt601              = C.SDL_MATRIX_COEFFICIENTS_BT601              // 6, ITU-R BT.601-7 525
	smpte240           = C.SDL_MATRIX_COEFFICIENTS_SMPTE240           // 7, SMPTE 240M
	ycgco              = C.SDL_MATRIX_COEFFICIENTS_YCGCO              // 8,
	bt2020_ncl         = C.SDL_MATRIX_COEFFICIENTS_BT2020_NCL         // 9, ITU-R BT.2020-2 non-constant luminance
	bt2020_cl          = C.SDL_MATRIX_COEFFICIENTS_BT2020_CL          // 10, ITU-R BT.2020-2 constant luminance
	smpte2085          = C.SDL_MATRIX_COEFFICIENTS_SMPTE2085          // 11, SMPTE ST 2085
	chroma_derived_ncl = C.SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_NCL // 12,
	chroma_derived_cl  = C.SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_CL  // 13,
	ictcp              = C.SDL_MATRIX_COEFFICIENTS_ICTCP              // 14, ITU-R BT.2100-0 ICTCP
	custom             = C.SDL_MATRIX_COEFFICIENTS_CUSTOM             // 31,
}

// ChromaLocation is C.SDL_ChromaLocation
pub enum ChromaLocation {
	@none   = C.SDL_CHROMA_LOCATION_NONE    // 0, RGB, no chroma sampling
	left    = C.SDL_CHROMA_LOCATION_LEFT    // 1, In MPEG-2, MPEG-4, and AVC, Cb and Cr are taken on midpoint of the left-edge of the 2x2 square. In other words, they have the same horizontal location as the top-left pixel, but is shifted one-half pixel down vertically.
	center  = C.SDL_CHROMA_LOCATION_CENTER  // 2, In JPEG/JFIF, H.261, and MPEG-1, Cb and Cr are taken at the center of the 2x2 square. In other words, they are offset one-half pixel to the right and one-half pixel down compared to the top-left pixel.
	topleft = C.SDL_CHROMA_LOCATION_TOPLEFT // 3, In HEVC for BT.2020 and BT.2100 content (in particular on Blu-rays), Cb and Cr are sampled at the same location as the group's top-left Y pixel ("co-sited", "co-located").
}

// TODO: Non-numerical: #define SDL_DEFINE_COLORSPACE(type, range, primaries, transfer, matrix, chroma) \

// TODO: Function: #define SDL_COLORSPACETYPE(cspace)       (SDL_ColorType)(((cspace) >> 28) & 0x0F)

// TODO: Function: #define SDL_COLORSPACERANGE(cspace)      (SDL_ColorRange)(((cspace) >> 24) & 0x0F)

// TODO: Function: #define SDL_COLORSPACECHROMA(cspace)     (SDL_ChromaLocation)(((cspace) >> 20) & 0x0F)

// TODO: Function: #define SDL_COLORSPACEPRIMARIES(cspace)  (SDL_ColorPrimaries)(((cspace) >> 10) & 0x1F)

// TODO: Function: #define SDL_COLORSPACETRANSFER(cspace)   (SDL_TransferCharacteristics)(((cspace) >> 5) & 0x1F)

// TODO: Function: #define SDL_COLORSPACEMATRIX(cspace)     (SDL_MatrixCoefficients)((cspace) & 0x1F)

// TODO: Function: #define SDL_ISCOLORSPACE_MATRIX_BT601(cspace)        (SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT601 || SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT470BG)

// TODO: Function: #define SDL_ISCOLORSPACE_MATRIX_BT709(cspace)        (SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT709)

// TODO: Function: #define SDL_ISCOLORSPACE_MATRIX_BT2020_NCL(cspace)   (SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT2020_NCL)

// TODO: Function: #define SDL_ISCOLORSPACE_LIMITED_RANGE(cspace)       (SDL_COLORSPACERANGE(cspace) != SDL_COLOR_RANGE_FULL)

// TODO: Function: #define SDL_ISCOLORSPACE_FULL_RANGE(cspace)          (SDL_COLORSPACERANGE(cspace) == SDL_COLOR_RANGE_FULL)

// Colorspace is C.SDL_Colorspace
pub enum Colorspace {
	unknown        = C.SDL_COLORSPACE_UNKNOWN        // 0,
	srgb           = C.SDL_COLORSPACE_SRGB           // 0x120005a0u, Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709
	srgb_linear    = C.SDL_COLORSPACE_SRGB_LINEAR    // 0x12000500u, Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709
	hdr10          = C.SDL_COLORSPACE_HDR10          // 0x12002600u, Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020
	jpeg           = C.SDL_COLORSPACE_JPEG           // 0x220004c6u, Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_NONE_P709_X601
	bt601_limited  = C.SDL_COLORSPACE_BT601_LIMITED  // 0x211018c6u, Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601
	bt601_full     = C.SDL_COLORSPACE_BT601_FULL     // 0x221018c6u, Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601
	bt709_limited  = C.SDL_COLORSPACE_BT709_LIMITED  // 0x21100421u, Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709
	bt709_full     = C.SDL_COLORSPACE_BT709_FULL     // 0x22100421u, Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709
	bt2020_limited = C.SDL_COLORSPACE_BT2020_LIMITED // 0x21102609u, Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P2020
	bt2020_full    = C.SDL_COLORSPACE_BT2020_FULL    // 0x22102609u, Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P2020
	rgb_default    = C.SDL_COLORSPACE_RGB_DEFAULT    // SDL_COLORSPACE_SRGB, The default colorspace for RGB surfaces if no colorspace is specified
	yuv_default    = C.SDL_COLORSPACE_YUV_DEFAULT    // SDL_COLORSPACE_JPEG, The default colorspace for YUV surfaces if no colorspace is specified
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
pub struct C.SDL_FColor {
pub mut:
	r f32
	g f32
	b f32
	a f32
}

pub type FColor = C.SDL_FColor

@[typedef]
pub struct C.SDL_Palette {
pub mut:
	ncolors  int // number of elements in `colors`.
	colors   &Color = unsafe { nil } // an array of colors, `ncolors` long.
	version  u32 // internal use only, do not touch.
	refcount int // internal use only, do not touch.
}

pub type Palette = C.SDL_Palette

@[typedef]
pub struct C.SDL_PixelFormatDetails {
pub mut:
	format          PixelFormat
	bits_per_pixel  u8
	bytes_per_pixel u8
	// TODO 	padding [2]u8
	Rmask  u32
	Gmask  u32
	Bmask  u32
	Amask  u32
	Rbits  u8
	Gbits  u8
	Bbits  u8
	Abits  u8
	Rshift u8
	Gshift u8
	Bshift u8
	Ashift u8
}

pub type PixelFormatDetails = C.SDL_PixelFormatDetails

// C.SDL_GetPixelFormatName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPixelFormatName)
fn C.SDL_GetPixelFormatName(format PixelFormat) &char

// get_pixel_format_name gets the human readable name of a pixel format.
//
// `format` format the pixel format to query.
// returns the human readable name of the specified pixel format or
//          "SDL_PIXELFORMAT_UNKNOWN" if the format isn't recognized.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_pixel_format_name(format PixelFormat) &char {
	return C.SDL_GetPixelFormatName(format)
}

// C.SDL_GetMasksForPixelFormat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetMasksForPixelFormat)
fn C.SDL_GetMasksForPixelFormat(format PixelFormat, bpp &int, rmask &u32, gmask &u32, bmask &u32, amask &u32) bool

// get_masks_for_pixel_format converts one of the enumerated pixel formats to a bpp value and RGBA masks.
//
// `format` format one of the SDL_PixelFormat values.
// `bpp` bpp a bits per pixel value; usually 15, 16, or 32.
// `rmask` Rmask a pointer filled in with the red mask for the format.
// `gmask` Gmask a pointer filled in with the green mask for the format.
// `bmask` Bmask a pointer filled in with the blue mask for the format.
// `amask` Amask a pointer filled in with the alpha mask for the format.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_pixel_format_for_masks (SDL_GetPixelFormatForMasks)
pub fn get_masks_for_pixel_format(format PixelFormat, bpp &int, rmask &u32, gmask &u32, bmask &u32, amask &u32) bool {
	return C.SDL_GetMasksForPixelFormat(format, bpp, rmask, gmask, bmask, amask)
}

// C.SDL_GetPixelFormatForMasks [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPixelFormatForMasks)
fn C.SDL_GetPixelFormatForMasks(bpp int, rmask u32, gmask u32, bmask u32, amask u32) PixelFormat

// get_pixel_format_for_masks converts a bpp value and RGBA masks to an enumerated pixel format.
//
// This will return `SDL_PIXELFORMAT_UNKNOWN` if the conversion wasn't
// possible.
//
// `bpp` bpp a bits per pixel value; usually 15, 16, or 32.
// `rmask` Rmask the red mask for the format.
// `gmask` Gmask the green mask for the format.
// `bmask` Bmask the blue mask for the format.
// `amask` Amask the alpha mask for the format.
// returns the SDL_PixelFormat value corresponding to the format masks, or
//          SDL_PIXELFORMAT_UNKNOWN if there isn't a match.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_masks_for_pixel_format (SDL_GetMasksForPixelFormat)
pub fn get_pixel_format_for_masks(bpp int, rmask u32, gmask u32, bmask u32, amask u32) PixelFormat {
	return C.SDL_GetPixelFormatForMasks(bpp, rmask, gmask, bmask, amask)
}

// C.SDL_GetPixelFormatDetails [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPixelFormatDetails)
fn C.SDL_GetPixelFormatDetails(format PixelFormat) &PixelFormatDetails

// get_pixel_format_details creates an SDL_PixelFormatDetails structure corresponding to a pixel format.
//
// Returned structure may come from a shared global cache (i.e. not newly
// allocated), and hence should not be modified, especially the palette. Weird
// errors such as `Blit combination not supported` may occur.
//
// `format` format one of the SDL_PixelFormat values.
// returns a pointer to a SDL_PixelFormatDetails structure or NULL on
//          failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_pixel_format_details(format PixelFormat) &PixelFormatDetails {
	return C.SDL_GetPixelFormatDetails(format)
}

// C.SDL_CreatePalette [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreatePalette)
fn C.SDL_CreatePalette(ncolors int) &Palette

// create_palette creates a palette structure with the specified number of color entries.
//
// The palette entries are initialized to white.
//
// `ncolors` ncolors represents the number of color entries in the color palette.
// returns a new SDL_Palette structure on success or NULL on failure (e.g. if
//          there wasn't enough memory); call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_palette (SDL_DestroyPalette)
// See also: set_palette_colors (SDL_SetPaletteColors)
// See also: set_surface_palette (SDL_SetSurfacePalette)
pub fn create_palette(ncolors int) &Palette {
	return C.SDL_CreatePalette(ncolors)
}

// C.SDL_SetPaletteColors [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetPaletteColors)
fn C.SDL_SetPaletteColors(palette &Palette, const_colors &Color, firstcolor int, ncolors int) bool

// set_palette_colors sets a range of colors in a palette.
//
// `palette` palette the SDL_Palette structure to modify.
// `colors` colors an array of SDL_Color structures to copy into the palette.
// `firstcolor` firstcolor the index of the first palette entry to modify.
// `ncolors` ncolors the number of entries to modify.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread, as long as
//               the palette is not modified or destroyed in another thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_palette_colors(palette &Palette, const_colors &Color, firstcolor int, ncolors int) bool {
	return C.SDL_SetPaletteColors(palette, const_colors, firstcolor, ncolors)
}

// C.SDL_DestroyPalette [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyPalette)
fn C.SDL_DestroyPalette(palette &Palette)

// destroy_palette frees a palette created with SDL_CreatePalette().
//
// `palette` palette the SDL_Palette structure to be freed.
//
// NOTE: (thread safety) It is safe to call this function from any thread, as long as
//               the palette is not modified or destroyed in another thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_palette (SDL_CreatePalette)
pub fn destroy_palette(palette &Palette) {
	C.SDL_DestroyPalette(palette)
}

// C.SDL_MapRGB [official documentation](https://wiki.libsdl.org/SDL3/SDL_MapRGB)
fn C.SDL_MapRGB(const_format &PixelFormatDetails, const_palette &Palette, r u8, g u8, b u8) u32

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
// `format` format a pointer to SDL_PixelFormatDetails describing the pixel
//               format.
// `palette` palette an optional palette for indexed formats, may be NULL.
// `r` r the red component of the pixel in the range 0-255.
// `g` g the green component of the pixel in the range 0-255.
// `b` b the blue component of the pixel in the range 0-255.
// returns a pixel value.
//
// NOTE: (thread safety) It is safe to call this function from any thread, as long as
//               the palette is not modified.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_pixel_format_details (SDL_GetPixelFormatDetails)
// See also: get_rgb (SDL_GetRGB)
// See also: map_rgba (SDL_MapRGBA)
// See also: map_surface_rgb (SDL_MapSurfaceRGB)
pub fn map_rgb(const_format &PixelFormatDetails, const_palette &Palette, r u8, g u8, b u8) u32 {
	return C.SDL_MapRGB(const_format, const_palette, r, g, b)
}

// C.SDL_MapRGBA [official documentation](https://wiki.libsdl.org/SDL3/SDL_MapRGBA)
fn C.SDL_MapRGBA(const_format &PixelFormatDetails, const_palette &Palette, r u8, g u8, b u8, a u8) u32

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
// `format` format a pointer to SDL_PixelFormatDetails describing the pixel
//               format.
// `palette` palette an optional palette for indexed formats, may be NULL.
// `r` r the red component of the pixel in the range 0-255.
// `g` g the green component of the pixel in the range 0-255.
// `b` b the blue component of the pixel in the range 0-255.
// `a` a the alpha component of the pixel in the range 0-255.
// returns a pixel value.
//
// NOTE: (thread safety) It is safe to call this function from any thread, as long as
//               the palette is not modified.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_pixel_format_details (SDL_GetPixelFormatDetails)
// See also: get_rgba (SDL_GetRGBA)
// See also: map_rgb (SDL_MapRGB)
// See also: map_surface_rgba (SDL_MapSurfaceRGBA)
pub fn map_rgba(const_format &PixelFormatDetails, const_palette &Palette, r u8, g u8, b u8, a u8) u32 {
	return C.SDL_MapRGBA(const_format, const_palette, r, g, b, a)
}

// C.SDL_GetRGB [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRGB)
fn C.SDL_GetRGB(pixel u32, const_format &PixelFormatDetails, const_palette &Palette, r &u8, g &u8, b &u8)

// get_rgb gets RGB values from a pixel in the specified format.
//
// This function uses the entire 8-bit [0..255] range when converting color
// components from pixel formats with less than 8-bits per RGB component
// (e.g., a completely white pixel in 16-bit RGB565 format would return [0xff,
// 0xff, 0xff] not [0xf8, 0xfc, 0xf8]).
//
// `pixel` pixel a pixel value.
// `format` format a pointer to SDL_PixelFormatDetails describing the pixel
//               format.
// `palette` palette an optional palette for indexed formats, may be NULL.
// `r` r a pointer filled in with the red component, may be NULL.
// `g` g a pointer filled in with the green component, may be NULL.
// `b` b a pointer filled in with the blue component, may be NULL.
//
// NOTE: (thread safety) It is safe to call this function from any thread, as long as
//               the palette is not modified.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_pixel_format_details (SDL_GetPixelFormatDetails)
// See also: get_rgba (SDL_GetRGBA)
// See also: map_rgb (SDL_MapRGB)
// See also: map_rgba (SDL_MapRGBA)
pub fn get_rgb(pixel u32, const_format &PixelFormatDetails, const_palette &Palette, r &u8, g &u8, b &u8) {
	C.SDL_GetRGB(pixel, const_format, const_palette, r, g, b)
}

// C.SDL_GetRGBA [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRGBA)
fn C.SDL_GetRGBA(pixel u32, const_format &PixelFormatDetails, const_palette &Palette, r &u8, g &u8, b &u8, a &u8)

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
// `pixel` pixel a pixel value.
// `format` format a pointer to SDL_PixelFormatDetails describing the pixel
//               format.
// `palette` palette an optional palette for indexed formats, may be NULL.
// `r` r a pointer filled in with the red component, may be NULL.
// `g` g a pointer filled in with the green component, may be NULL.
// `b` b a pointer filled in with the blue component, may be NULL.
// `a` a a pointer filled in with the alpha component, may be NULL.
//
// NOTE: (thread safety) It is safe to call this function from any thread, as long as
//               the palette is not modified.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_pixel_format_details (SDL_GetPixelFormatDetails)
// See also: get_rgb (SDL_GetRGB)
// See also: map_rgb (SDL_MapRGB)
// See also: map_rgba (SDL_MapRGBA)
pub fn get_rgba(pixel u32, const_format &PixelFormatDetails, const_palette &Palette, r &u8, g &u8, b &u8, a &u8) {
	C.SDL_GetRGBA(pixel, const_format, const_palette, r, g, b, a)
}
