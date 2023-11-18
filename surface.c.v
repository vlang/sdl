// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_surface.h
//

// Surface is a collection of pixels used in software blitting.
//
// NOTE This structure should be treated as read-only, except for `pixels`,
// which, if not NULL, contains the raw pixel data for the surface.
//
@[typedef]
pub struct C.SDL_Surface {
pub:
	flags  u32 // Read-only
	format &C.SDL_PixelFormat // Read-only
	w      int // Read-only
	h      int // Read-only
	pitch  int // Read-only
	// information needed for surfaces requiring locks
	locked int // Read-only
	// list of BlitMap that hold a reference to this surface
	// list_blitmap voidptr // Private
	// clipping information
	clip_rect C.SDL_Rect // Read-only
	// @map &C.SDL_BlitMap // Private
	// Reference count -- used when freeing surface
	refcount int // Read-mostly
pub mut:
	pixels voidptr // Read-write
	// Application data associated with the surface
	userdata voidptr // Read-write
}

pub type Surface = C.SDL_Surface

// `typedef int (SDLCALL *SDL_blit) (struct SDL_Surface * src, SDL_Rect * srcrect, struct SDL_Surface * dst, SDL_Rect * dstrect);`
fn C.SDL_blit(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int

// BlitCall is the type of function used for surface blitting functions.
pub type BlitCall = fn (src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int

// YUVConversionMode is the formula used for converting between YUV and RGB
// YUVConversionMode is C.SDL_YUV_CONVERSION_MODE
pub enum YUVConversionMode {
	jpeg      = C.SDL_YUV_CONVERSION_JPEG // Full range JPEG
	bt601     = C.SDL_YUV_CONVERSION_BT601 // BT.601 (the default)
	bt709     = C.SDL_YUV_CONVERSION_BT709 // BT.709
	automatic = C.SDL_YUV_CONVERSION_AUTOMATIC // BT.601 for SD content, BT.709 for HD content
}

fn C.SDL_CreateRGBSurface(flags u32, width int, height int, depth int, rmask u32, gmask u32, bmask u32, amask u32) &C.SDL_Surface

// create_rgb_surface allocates a new RGB surface.
//
// If `depth` is 4 or 8 bits, an empty palette is allocated for the surface.
// If `depth` is greater than 8 bits, the pixel format is set using the
// [RGBA]mask parameters.
//
// The [RGBA]mask parameters are the bitmasks used to extract that color from
// a pixel. For instance, `Rmask` being 0xFF000000 means the red data is
// stored in the most significant byte. Using zeros for the RGB masks sets a
// default value, based on the depth. For example:
//
/*
```c++
 SDL_CreateRGBSurface(0,w,h,32,0,0,0,0);
```
*/
//
// However, using zero for the Amask results in an Amask of 0.
//
// By default surfaces with an alpha mask are set up for blending as with:
//
/*
```c++
 SDL_SetSurfaceBlendMode(surface, SDL_BLENDMODE_BLEND)
```
*/
//
// You can change this by calling SDL_SetSurfaceBlendMode() and selecting a
// different `blendMode`.
//
// `flags` the flags are unused and should be set to 0
// `width` the width of the surface
// `height` the height of the surface
// `depth` the depth of the surface in bits
// `Rmask` the red mask for the pixels
// `Gmask` the green mask for the pixels
// `Bmask` the blue mask for the pixels
// `Amask` the alpha mask for the pixels
// returns the new SDL_Surface structure that is created or NULL if it fails;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateRGBSurfaceFrom
// See also: SDL_CreateRGBSurfaceWithFormat
// See also: SDL_FreeSurface
pub fn create_rgb_surface(flags u32, width int, height int, depth int, rmask u32, gmask u32, bmask u32, amask u32) &Surface {
	return C.SDL_CreateRGBSurface(flags, width, height, depth, rmask, gmask, bmask, amask)
}

fn C.SDL_CreateRGBSurfaceWithFormat(flags u32, width int, height int, depth int, format u32) &C.SDL_Surface

// create_rgb_surface_with_format allocates a new RGB surface with a specific pixel format.
//
// This function operates mostly like SDL_CreateRGBSurface(), except instead
// of providing pixel color masks, you provide it with a predefined format
// from SDL_PixelFormatEnum.
//
// `flags` the flags are unused and should be set to 0
// `width` the width of the surface
// `height` the height of the surface
// `depth` the depth of the surface in bits
// `format` the SDL_PixelFormatEnum for the new surface's pixel format.
// returns the new SDL_Surface structure that is created or NULL if it fails;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_CreateRGBSurface
// See also: SDL_CreateRGBSurfaceFrom
// See also: SDL_FreeSurface
pub fn create_rgb_surface_with_format(flags u32, width int, height int, depth int, format u32) &Surface {
	return C.SDL_CreateRGBSurfaceWithFormat(flags, width, height, depth, format)
}

fn C.SDL_CreateRGBSurfaceFrom(pixels voidptr, width int, height int, depth int, pitch int, rmask u32, gmask u32, bmask u32, amask u32) &C.SDL_Surface

// create_rgb_surface_from allocates a new RGB surface with existing pixel data.
//
// This function operates mostly like SDL_CreateRGBSurface(), except it does
// not allocate memory for the pixel data, instead the caller provides an
// existing buffer of data for the surface to use.
//
// No copy is made of the pixel data. Pixel data is not managed automatically;
// you must free the surface before you free the pixel data.
//
// `pixels` a pointer to existing pixel data
// `width` the width of the surface
// `height` the height of the surface
// `depth` the depth of the surface in bits
// `pitch` the pitch of the surface in bytes
// `Rmask` the red mask for the pixels
// `Gmask` the green mask for the pixels
// `Bmask` the blue mask for the pixels
// `Amask` the alpha mask for the pixels
// returns the new SDL_Surface structure that is created or NULL if it fails;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateRGBSurface
// See also: SDL_CreateRGBSurfaceWithFormat
// See also: SDL_FreeSurface
pub fn create_rgb_surface_from(pixels voidptr, width int, height int, depth int, pitch int, rmask u32, gmask u32, bmask u32, amask u32) &Surface {
	return C.SDL_CreateRGBSurfaceFrom(pixels, width, height, depth, pitch, rmask, gmask,
		bmask, amask)
}

fn C.SDL_CreateRGBSurfaceWithFormatFrom(pixels voidptr, width int, height int, depth int, pitch int, format u32) &C.SDL_Surface

// create_rgb_surface_with_format_from allocates a new RGB surface with with a specific pixel format and existing
// pixel data.
//
// This function operates mostly like SDL_CreateRGBSurfaceFrom(), except
// instead of providing pixel color masks, you provide it with a predefined
// format from SDL_PixelFormatEnum.
//
// No copy is made of the pixel data. Pixel data is not managed automatically;
// you must free the surface before you free the pixel data.
//
// `pixels` a pointer to existing pixel data
// `width` the width of the surface
// `height` the height of the surface
// `depth` the depth of the surface in bits
// `pitch` the pitch of the surface in bytes
// `format` the SDL_PixelFormatEnum for the new surface's pixel format.
// returns the new SDL_Surface structure that is created or NULL if it fails;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_CreateRGBSurfaceFrom
// See also: SDL_CreateRGBSurfaceWithFormat
// See also: SDL_FreeSurface
pub fn create_rgb_surface_with_format_from(pixels voidptr, width int, height int, depth int, pitch int, format u32) &Surface {
	return C.SDL_CreateRGBSurfaceWithFormatFrom(pixels, width, height, depth, pitch, format)
}

fn C.SDL_FreeSurface(surface &C.SDL_Surface)

// free_surface frees an RGB surface.
//
// It is safe to pass NULL to this function.
//
// `surface` the SDL_Surface to free.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateRGBSurface
// See also: SDL_CreateRGBSurfaceFrom
// See also: SDL_LoadBMP
// See also: SDL_LoadBMP_RW
pub fn free_surface(surface &Surface) {
	C.SDL_FreeSurface(surface)
}

fn C.SDL_SetSurfacePalette(surface &C.SDL_Surface, palette &C.SDL_Palette) int

// set_surface_palette sets the palette used by a surface.
//
// A single palette can be shared with many surfaces.
//
// `surface` the SDL_Surface structure to update
// `palette` the SDL_Palette structure to use
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
pub fn set_surface_palette(surface &Surface, palette &Palette) int {
	return C.SDL_SetSurfacePalette(surface, palette)
}

fn C.SDL_LockSurface(surface &C.SDL_Surface) int

// lock_surface sets up a surface for directly accessing the pixels.
//
// Between calls to SDL_LockSurface() / SDL_UnlockSurface(), you can write to
// and read from `surface->pixels`, using the pixel format stored in
// `surface->format`. Once you are done accessing the surface, you should use
// SDL_UnlockSurface() to release it.
//
// Not all surfaces require locking. If `SDL_MUSTLOCK(surface)` evaluates to
// 0, then you can read and write to the surface at any time, and the pixel
// format of the surface will not change.
//
// `surface` the SDL_Surface structure to be locked
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_MUSTLOCK
// See also: SDL_UnlockSurface
pub fn lock_surface(surface &Surface) int {
	return C.SDL_LockSurface(surface)
}

fn C.SDL_UnlockSurface(surface &C.SDL_Surface)

// unlock_surface releases a surface after directly accessing the pixels.
//
// `surface` the SDL_Surface structure to be unlocked
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LockSurface
pub fn unlock_surface(surface &Surface) {
	C.SDL_UnlockSurface(surface)
}

fn C.SDL_LoadBMP_RW(src &C.SDL_RWops, freesrc int) &C.SDL_Surface

// load_bmp_rw loads a BMP image from a seekable SDL data stream.
//
// The new surface should be freed with SDL_FreeSurface(). Not doing so will
// result in a memory leak.
//
// src is an open SDL_RWops buffer, typically loaded with SDL_RWFromFile.
// Alternitavely, you might also use the macro SDL_LoadBMP to load a bitmap
// from a file, convert it to an SDL_Surface and then close the file.
//
// `src` the data stream for the surface
// `freesrc` non-zero to close the stream after being read
// returns a pointer to a new SDL_Surface structure or NULL if there was an
//          error; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_FreeSurface
// See also: SDL_RWFromFile
// See also: SDL_LoadBMP
// See also: SDL_SaveBMP_RW
pub fn load_bmp_rw(src &RWops, freesrc int) &Surface {
	return C.SDL_LoadBMP_RW(src, freesrc)
}

fn C.SDL_LoadBMP(file &char) &C.SDL_Surface

// load_bmp loads a surface from a file.
//
// Convenience macro.
pub fn load_bmp(path &char) &Surface {
	return C.SDL_LoadBMP(path)
}

fn C.SDL_SaveBMP_RW(surface &C.SDL_Surface, dst &C.SDL_RWops, freedst int) int

// save_bmp_rw saves a surface to a seekable SDL data stream in BMP format.
//
// Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
// BMP directly. Other RGB formats with 8-bit or higher get converted to a
// 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
// surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
// not supported.
//
// `surface` the SDL_Surface structure containing the image to be saved
// `dst` a data stream to save to
// `freedst` non-zero to close the stream after being written
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LoadBMP_RW
// See also: SDL_SaveBMP
pub fn save_bmp_rw(surface &Surface, dst &RWops, freedst int) int {
	return C.SDL_SaveBMP_RW(surface, dst, freedst)
}

fn C.SDL_SaveBMP(surface &C.SDL_Surface, file &char)

// save_bmp save a surface to a file.
//
// Convenience macro.
pub fn save_bmp(surface &Surface, path &char) {
	C.SDL_SaveBMP(surface, path)
}

fn C.SDL_SetSurfaceRLE(surface &C.SDL_Surface, flag int) int

// set_surface_rle sets the RLE acceleration hint for a surface.
//
// If RLE is enabled, color key and alpha blending blits are much faster, but
// the surface must be locked before directly accessing the pixels.
//
// `surface` the SDL_Surface structure to optimize
// `flag` 0 to disable, non-zero to enable RLE acceleration
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_BlitSurface
// See also: SDL_LockSurface
// See also: SDL_UnlockSurface
pub fn set_surface_rle(surface &Surface, flag int) int {
	return C.SDL_SetSurfaceRLE(surface, flag)
}

fn C.SDL_HasSurfaceRLE(surface &C.SDL_Surface) bool

// has_surface_rle returns whether the surface is RLE enabled
//
// It is safe to pass a NULL `surface` here; it will return SDL_FALSE.
//
// `surface` the SDL_Surface structure to query
// returns SDL_TRUE if the surface is RLE enabled, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.14.
//
// See also: SDL_SetSurfaceRLE
pub fn has_surface_rle(surface &Surface) bool {
	return C.SDL_HasSurfaceRLE(surface)
}

fn C.SDL_SetColorKey(surface &C.SDL_Surface, flag int, key u32) int

// set_color_key sets the color key (transparent pixel) in a surface.
//
// The color key defines a pixel value that will be treated as transparent in
// a blit. For example, one can use this to specify that cyan pixels should be
// considered transparent, and therefore not rendered.
//
// It is a pixel of the format used by the surface, as generated by
// SDL_MapRGB().
//
// RLE acceleration can substantially speed up blitting of images with large
// horizontal runs of transparent pixels. See SDL_SetSurfaceRLE() for details.
//
// `surface` the SDL_Surface structure to update
// `flag` SDL_TRUE to enable color key, SDL_FALSE to disable color key
// `key` the transparent pixel
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_BlitSurface
// See also: SDL_GetColorKey
pub fn set_color_key(surface &Surface, flag int, key u32) int {
	return C.SDL_SetColorKey(surface, flag, key)
}

fn C.SDL_HasColorKey(surface &C.SDL_Surface) bool

// has_color_key returns whether the surface has a color key
//
// It is safe to pass a NULL `surface` here; it will return SDL_FALSE.
//
// `surface` the SDL_Surface structure to query
// returns SDL_TRUE if the surface has a color key, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetColorKey
// See also: SDL_GetColorKey
pub fn has_color_key(surface &Surface) bool {
	return C.SDL_HasColorKey(surface)
}

fn C.SDL_GetColorKey(surface &C.SDL_Surface, key &u32) int

// get_color_key gets the color key (transparent pixel) for a surface.
//
// The color key is a pixel of the format used by the surface, as generated by
// SDL_MapRGB().
//
// If the surface doesn't have color key enabled this function returns -1.
//
// `surface` the SDL_Surface structure to query
// `key` a pointer filled in with the transparent pixel
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_BlitSurface
// See also: SDL_SetColorKey
pub fn get_color_key(surface &Surface, key &u32) int {
	return C.SDL_GetColorKey(surface, key)
}

fn C.SDL_SetSurfaceColorMod(surface &C.SDL_Surface, r u8, g u8, b u8) int

// set_surface_color_mod sets an additional color value multiplied into blit operations.
//
// When this surface is blitted, during the blit operation each source color
// channel is modulated by the appropriate color value according to the
// following formula:
//
// `srcC = srcC * (color / 255)`
//
// `surface` the SDL_Surface structure to update
// `r` the red color value multiplied into blit operations
// `g` the green color value multiplied into blit operations
// `b` the blue color value multiplied into blit operations
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetSurfaceColorMod
// See also: SDL_SetSurfaceAlphaMod
pub fn set_surface_color_mod(surface &Surface, r u8, g u8, b u8) int {
	return C.SDL_SetSurfaceColorMod(surface, r, g, b)
}

fn C.SDL_GetSurfaceColorMod(surface &C.SDL_Surface, r &u8, g &u8, b &u8) int

// get_surface_color_mod gets the additional color value multiplied into blit operations.
//
// `surface` the SDL_Surface structure to query
// `r` a pointer filled in with the current red color value
// `g` a pointer filled in with the current green color value
// `b` a pointer filled in with the current blue color value
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetSurfaceAlphaMod
// See also: SDL_SetSurfaceColorMod
pub fn get_surface_color_mod(surface &Surface, r &u8, g &u8, b &u8) int {
	return C.SDL_GetSurfaceColorMod(surface, r, g, b)
}

fn C.SDL_SetSurfaceAlphaMod(surface &C.SDL_Surface, alpha u8) int

// set_surface_alpha_mod sets an additional alpha value used in blit operations.
//
// When this surface is blitted, during the blit operation the source alpha
// value is modulated by this alpha value according to the following formula:
//
// `srcA = srcA * (alpha / 255)`
//
// `surface` the SDL_Surface structure to update
// `alpha` the alpha value multiplied into blit operations
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetSurfaceAlphaMod
// See also: SDL_SetSurfaceColorMod
pub fn set_surface_alpha_mod(surface &Surface, alpha u8) int {
	return C.SDL_SetSurfaceAlphaMod(surface, alpha)
}

fn C.SDL_GetSurfaceAlphaMod(surface &C.SDL_Surface, alpha &u8) int

// get_surface_alpha_mod gets the additional alpha value used in blit operations.
//
// `surface` the SDL_Surface structure to query
// `alpha` a pointer filled in with the current alpha value
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetSurfaceColorMod
// See also: SDL_SetSurfaceAlphaMod
pub fn get_surface_alpha_mod(surface &Surface, alpha &u8) int {
	return C.SDL_GetSurfaceAlphaMod(surface, alpha)
}

fn C.SDL_SetSurfaceBlendMode(surface &C.SDL_Surface, blend_mode C.SDL_BlendMode) int

// set_surface_blend_mode sets the blend mode used for blit operations.
//
// To copy a surface to another surface (or texture) without blending with the
// existing data, the blendmode of the SOURCE surface should be set to
// `SDL_BLENDMODE_NONE`.
//
// `surface` the SDL_Surface structure to update
// `blendMode` the SDL_BlendMode to use for blit blending
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetSurfaceBlendMode
pub fn set_surface_blend_mode(surface &Surface, blend_mode BlendMode) int {
	return C.SDL_SetSurfaceBlendMode(surface, C.SDL_BlendMode(int(blend_mode)))
}

fn C.SDL_GetSurfaceBlendMode(surface &C.SDL_Surface, blend_mode &C.SDL_BlendMode) int

// get_surface_blend_mode gets the blend mode used for blit operations.
//
// `surface` the SDL_Surface structure to query
// `blendMode` a pointer filled in with the current SDL_BlendMode
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetSurfaceBlendMode
pub fn get_surface_blend_mode(surface &Surface, blend_mode &BlendMode) int {
	return C.SDL_GetSurfaceBlendMode(surface, &C.SDL_BlendMode(int(blend_mode)))
}

fn C.SDL_SetClipRect(surface &C.SDL_Surface, const_rect &C.SDL_Rect) bool

// set_clip_rect sets the clipping rectangle for a surface.
//
// When `surface` is the destination of a blit, only the area within the clip
// rectangle is drawn into.
//
// Note that blits are automatically clipped to the edges of the source and
// destination surfaces.
//
// `surface` the SDL_Surface structure to be clipped
// `rect` the SDL_Rect structure representing the clipping rectangle, or
//             NULL to disable clipping
// returns SDL_TRUE if the rectangle intersects the surface, otherwise
//          SDL_FALSE and blits will be completely clipped.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_BlitSurface
// See also: SDL_GetClipRect
pub fn set_clip_rect(surface &Surface, const_rect &Rect) bool {
	return C.SDL_SetClipRect(surface, const_rect)
}

fn C.SDL_GetClipRect(surface &C.SDL_Surface, rect &C.SDL_Rect)

// get_clip_rect gets the clipping rectangle for a surface.
//
// When `surface` is the destination of a blit, only the area within the clip
// rectangle is drawn into.
//
// `surface` the SDL_Surface structure representing the surface to be
//                clipped
// `rect` an SDL_Rect structure filled in with the clipping rectangle for
//             the surface
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_BlitSurface
// See also: SDL_SetClipRect
pub fn get_clip_rect(surface &Surface, rect &Rect) {
	C.SDL_GetClipRect(surface, rect)
}

fn C.SDL_DuplicateSurface(surface &C.SDL_Surface) &C.SDL_Surface

// duplicate_surface creates a new surface identical to the existing surface.
//
// The returned surface should be freed with SDL_FreeSurface().
//
// `surface` the surface to duplicate.
// returns a copy of the surface, or NULL on failure; call SDL_GetError() for
//          more information.
pub fn duplicate_surface(surface &Surface) &Surface {
	return C.SDL_DuplicateSurface(surface)
}

fn C.SDL_ConvertSurface(src &C.SDL_Surface, const_fmt &C.SDL_PixelFormat, flags u32) &C.SDL_Surface

// convert_surface copies an existing surface to a new surface of the specified format.
//
// This function is used to optimize images for faster *repeat* blitting. This
// is accomplished by converting the original and storing the result as a new
// surface. The new, optimized surface can then be used as the source for
// future blits, making them faster.
//
// `src` the existing SDL_Surface structure to convert
// `fmt` the SDL_PixelFormat structure that the new surface is optimized
//            for
// `flags` the flags are unused and should be set to 0; this is a
//              leftover from SDL 1.2's API
// returns the new SDL_Surface structure that is created or NULL if it fails;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AllocFormat
// See also: SDL_ConvertSurfaceFormat
// See also: SDL_CreateRGBSurface
pub fn convert_surface(src &Surface, const_fmt &PixelFormat, flags u32) &Surface {
	return C.SDL_ConvertSurface(src, const_fmt, flags)
}

fn C.SDL_ConvertSurfaceFormat(src &C.SDL_Surface, pixel_format u32, flags u32) &C.SDL_Surface

// convert_surface_format copies an existing surface to a new surface of the specified format enum.
//
// This function operates just like SDL_ConvertSurface(), but accepts an
// SDL_PixelFormatEnum value instead of an SDL_PixelFormat structure. As such,
// it might be easier to call but it doesn't have access to palette
// information for the destination surface, in case that would be important.
//
// `src` the existing SDL_Surface structure to convert
// `pixel_format` the SDL_PixelFormatEnum that the new surface is
//                     optimized for
// `flags` the flags are unused and should be set to 0; this is a
//              leftover from SDL 1.2's API
// returns the new SDL_Surface structure that is created or NULL if it fails;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AllocFormat
// See also: SDL_ConvertSurface
// See also: SDL_CreateRGBSurface
pub fn convert_surface_format(src &Surface, pixel_format u32, flags u32) &Surface {
	return C.SDL_ConvertSurfaceFormat(src, pixel_format, flags)
}

fn C.SDL_ConvertPixels(width int, height int, const_src_format u32, const_src voidptr, const_src_pitch int, dst_format u32, dst voidptr, dst_pitch int) int

// convert_pixels copies a block of pixels of one format to another format.
//
// `width` the width of the block to copy, in pixels
// `height` the height of the block to copy, in pixels
// `src_format` an SDL_PixelFormatEnum value of the `src` pixels format
// `src` a pointer to the source pixels
// `src_pitch` the pitch of the source pixels, in bytes
// `dst_format` an SDL_PixelFormatEnum value of the `dst` pixels format
// `dst` a pointer to be filled in with new pixel data
// `dst_pitch` the pitch of the destination pixels, in bytes
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
pub fn convert_pixels(width int, height int, const_src_format u32, const_src voidptr, const_src_pitch int, dst_format u32, dst voidptr, dst_pitch int) int {
	return C.SDL_ConvertPixels(width, height, const_src_format, const_src, const_src_pitch,
		dst_format, dst, dst_pitch)
}

fn C.SDL_PremultiplyAlpha(width int, height int, src_format u32, const_src voidptr, src_pitch int, dst_format u32, dst voidptr, dst_pitch int) int

// premultiply_alpha premultiplys the alpha on a block of pixels.
//
// This is safe to use with src == dst, but not for other overlapping areas.
//
// This function is currently only implemented for SDL_PIXELFORMAT_ARGB8888.
//
// `width` the width of the block to convert, in pixels
// `height` the height of the block to convert, in pixels
// `src_format` an SDL_PixelFormatEnum value of the `src` pixels format
// `src` a pointer to the source pixels
// `src_pitch` the pitch of the source pixels, in bytes
// `dst_format` an SDL_PixelFormatEnum value of the `dst` pixels format
// `dst` a pointer to be filled in with premultiplied pixel data
// `dst_pitch` the pitch of the destination pixels, in bytes
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.18.
pub fn premultiply_alpha(width int, height int, src_format u32, const_src voidptr, src_pitch int, dst_format u32, dst voidptr, dst_pitch int) int {
	return C.SDL_PremultiplyAlpha(width, height, src_format, const_src, src_pitch, dst_format,
		dst, dst_pitch)
}

fn C.SDL_FillRect(dst &C.SDL_Surface, const_rect &C.SDL_Rect, color u32) int

// fill_rect performs a fast fill of a rectangle with a specific color.
//
// `color` should be a pixel of the format used by the surface, and can be
// generated by SDL_MapRGB() or SDL_MapRGBA(). If the color value contains an
// alpha component then the destination is simply filled with that alpha
// information, no blending takes place.
//
// If there is a clip rectangle set on the destination (set via
// SDL_SetClipRect()), then this function will fill based on the intersection
// of the clip rectangle and `rect`.
//
// `dst` the SDL_Surface structure that is the drawing target
// `rect` the SDL_Rect structure representing the rectangle to fill, or
//             NULL to fill the entire surface
// `color` the color to fill with
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_FillRects
pub fn fill_rect(dst &Surface, const_rect &Rect, color u32) int {
	return C.SDL_FillRect(dst, const_rect, color)
}

fn C.SDL_FillRects(dst &C.SDL_Surface, const_rects &C.SDL_Rect, count int, color u32) int

// fill_rects performs a fast fill of a set of rectangles with a specific color.
//
// `color` should be a pixel of the format used by the surface, and can be
// generated by SDL_MapRGB() or SDL_MapRGBA(). If the color value contains an
// alpha component then the destination is simply filled with that alpha
// information, no blending takes place.
//
// If there is a clip rectangle set on the destination (set via
// SDL_SetClipRect()), then this function will fill based on the intersection
// of the clip rectangle and `rect`.
//
// `dst` the SDL_Surface structure that is the drawing target
// `rects` an array of SDL_Rects representing the rectangles to fill.
// `count` the number of rectangles in the array
// `color` the color to fill with
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_FillRect
pub fn fill_rects(dst &Surface, const_rects &Rect, count int, color u32) int {
	return C.SDL_FillRects(dst, const_rects, count, color)
}

fn C.SDL_BlitSurface(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int

// blit_surface performs a fast blit from the source surface to the destination surface.
//
// This assumes that the source and destination rectangles are
// the same size.  If either `srcrect` or `dstrect` are NULL, the entire
// surface (`src` or `dst`) is copied.  The final blit rectangles are saved
// in `srcrect` and `dstrect` after all clipping is performed.
//
// returns If the blit is successful, it returns 0, otherwise it returns -1.
//
// The blit function should not be called on a locked surface.
//
// The blit semantics for surfaces with and without blending and colorkey
// are defined as follows:
/*
```
    RGBA->RGB:
      Source surface blend mode set to SDL_BLENDMODE_BLEND:
        alpha-blend (using the source alpha-channel and per-surface alpha)
        SDL_SRCCOLORKEY ignored.
      Source surface blend mode set to SDL_BLENDMODE_NONE:
        copy RGB.
        if SDL_SRCCOLORKEY set, only copy the pixels matching the
        RGB values of the source color key, ignoring alpha in the
        comparison.

    RGB->RGBA:
      Source surface blend mode set to SDL_BLENDMODE_BLEND:
        alpha-blend (using the source per-surface alpha)
      Source surface blend mode set to SDL_BLENDMODE_NONE:
        copy RGB, set destination alpha to source per-surface alpha value.
      both:
        if SDL_SRCCOLORKEY set, only copy the pixels matching the
        source color key.

    RGBA->RGBA:
      Source surface blend mode set to SDL_BLENDMODE_BLEND:
        alpha-blend (using the source alpha-channel and per-surface alpha)
        SDL_SRCCOLORKEY ignored.
      Source surface blend mode set to SDL_BLENDMODE_NONE:
        copy all of RGBA to the destination.
        if SDL_SRCCOLORKEY set, only copy the pixels matching the
        RGB values of the source color key, ignoring alpha in the
        comparison.

    RGB->RGB:
      Source surface blend mode set to SDL_BLENDMODE_BLEND:
        alpha-blend (using the source per-surface alpha)
      Source surface blend mode set to SDL_BLENDMODE_NONE:
        copy RGB.
      both:
        if SDL_SRCCOLORKEY set, only copy the pixels matching the
        source color key.
```
*/
//
// You should call SDL_BlitSurface() unless you know exactly how SDL
// blitting works internally and how to use the other blit functions.
pub fn blit_surface(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_UpperBlit(src, srcrect, dst, dstrect)
}

fn C.SDL_UpperBlit(src &C.SDL_Surface, const_srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int

// upper_blit performs a fast blit from the source surface to the destination surface.
//
// SDL_UpperBlit() has been replaced by SDL_BlitSurface(), which is merely a
// macro for this function with a less confusing name.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_BlitSurface
pub fn upper_blit(src &Surface, const_srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_UpperBlit(src, const_srcrect, dst, dstrect)
}

fn C.SDL_LowerBlit(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int

// lower_blit performs low-level surface blitting only.
//
// This is a semi-private blit function and it performs low-level surface
// blitting, assuming the input rectangles have already been clipped.
//
// Unless you know what you're doing, you should be using SDL_BlitSurface()
// instead.
//
// `src` the SDL_Surface structure to be copied from
// `srcrect` the SDL_Rect structure representing the rectangle to be
//                copied, or NULL to copy the entire surface
// `dst` the SDL_Surface structure that is the blit target
// `dstrect` the SDL_Rect structure representing the rectangle that is
//                copied into
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_BlitSurface
pub fn lower_blit(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_LowerBlit(src, srcrect, dst, dstrect)
}

fn C.SDL_SoftStretch(src &C.SDL_Surface, const_srcrect &C.SDL_Rect, dst &C.SDL_Surface, const_dstrect &C.SDL_Rect) int

// soft_stretch performs a fast, low quality, stretch blit between two surfaces of the same
// format.
//
// Please use SDL_BlitScaled() instead.
//
// NOTE This function is available since SDL 2.0.0.
pub fn soft_stretch(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect) int {
	return C.SDL_SoftStretch(src, const_srcrect, dst, const_dstrect)
}

fn C.SDL_SoftStretchLinear(src &C.SDL_Surface, const_srcrect &C.SDL_Rect, dst &C.SDL_Surface, const_dstrect &C.SDL_Rect) int

// soft_stretch_linear performs bilinear scaling between two surfaces of the same format, 32BPP.
//
// NOTE This function is available since SDL 2.0.16.
pub fn soft_stretch_linear(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect) int {
	return C.SDL_SoftStretchLinear(src, const_srcrect, dst, const_dstrect)
}

fn C.SDL_BlitScaled(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int
pub fn blit_scaled(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_UpperBlitScaled(src, srcrect, dst, dstrect)
}

fn C.SDL_UpperBlitScaled(src &C.SDL_Surface, const_srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int

// upper_blit_scaled performs a scaled surface copy to a destination surface.
//
// SDL_UpperBlitScaled() has been replaced by SDL_BlitScaled(), which is
// merely a macro for this function with a less confusing name.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_BlitScaled
pub fn upper_blit_scaled(src &Surface, const_srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_UpperBlitScaled(src, const_srcrect, dst, dstrect)
}

fn C.SDL_LowerBlitScaled(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int

// lower_blit_scaled performs low-level surface scaled blitting only.
//
// This is a semi-private function and it performs low-level surface blitting,
// assuming the input rectangles have already been clipped.
//
// `src` the SDL_Surface structure to be copied from
// `srcrect` the SDL_Rect structure representing the rectangle to be
//                copied
// `dst` the SDL_Surface structure that is the blit target
// `dstrect` the SDL_Rect structure representing the rectangle that is
//                copied into
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_BlitScaled
pub fn lower_blit_scaled(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_LowerBlitScaled(src, srcrect, dst, dstrect)
}

fn C.SDL_SetYUVConversionMode(mode C.SDL_YUV_CONVERSION_MODE)

// set_yuv_conversion_mode sets the YUV conversion mode
//
// NOTE This function is available since SDL 2.0.8.
pub fn set_yuv_conversion_mode(mode YUVConversionMode) {
	C.SDL_SetYUVConversionMode(C.SDL_YUV_CONVERSION_MODE(int(mode)))
}

fn C.SDL_GetYUVConversionMode() YUVConversionMode

// get_yuv_conversion_mode gets the YUV conversion mode
//
// NOTE This function is available since SDL 2.0.8.
pub fn get_yuv_conversion_mode() YUVConversionMode {
	return unsafe { YUVConversionMode(int(C.SDL_GetYUVConversionMode())) }
}

fn C.SDL_GetYUVConversionModeForResolution(width int, height int) YUVConversionMode

// get_yuv_conversion_mode_for_resolution gets the YUV conversion mode, returning the correct mode for the resolution
// when the current conversion mode is SDL_YUV_CONVERSION_AUTOMATIC
//
// NOTE This function is available since SDL 2.0.8.
pub fn get_yuv_conversion_mode_for_resolution(width int, height int) YUVConversionMode {
	return unsafe {
		YUVConversionMode(int(C.SDL_GetYUVConversionModeForResolution(width, height)))
	}
}
