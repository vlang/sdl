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
	locked    int     // Read-only
	lock_data voidptr // Read-only
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

// create_rgb_surface allocates and frees an RGB surface.
//
// If the depth is 4 or 8 bits, an empty palette is allocated for the surface.
// If the depth is greater than 8 bits, the pixel format is set using the
// flags '[RGB]mask'.
//
// If the function runs out of memory, it will return NULL.
//
// `flags` The `flags` are obsolete and should be set to 0.
// `width` The width in pixels of the surface to create.
// `height` The height in pixels of the surface to create.
// `depth` The depth in bits of the surface to create.
// `Rmask` The red mask of the surface to create.
// `Gmask` The green mask of the surface to create.
// `Bmask` The blue mask of the surface to create.
// `Amask` The alpha mask of the surface to create.
pub fn create_rgb_surface(flags u32, width int, height int, depth int, rmask u32, gmask u32, bmask u32, amask u32) &Surface {
	return C.SDL_CreateRGBSurface(flags, width, height, depth, rmask, gmask, bmask, amask)
}

fn C.SDL_CreateRGBSurfaceWithFormat(flags u32, width int, height int, depth int, format u32) &C.SDL_Surface
pub fn create_rgb_surface_with_format(flags u32, width int, height int, depth int, format u32) &Surface {
	return C.SDL_CreateRGBSurfaceWithFormat(flags, width, height, depth, format)
}

fn C.SDL_CreateRGBSurfaceFrom(pixels voidptr, width int, height int, depth int, pitch int, rmask u32, gmask u32, bmask u32, amask u32) &C.SDL_Surface
pub fn create_rgb_surface_from(pixels voidptr, width int, height int, depth int, pitch int, rmask u32, gmask u32, bmask u32, amask u32) &Surface {
	return C.SDL_CreateRGBSurfaceFrom(pixels, width, height, depth, pitch, rmask, gmask,
		bmask, amask)
}

fn C.SDL_CreateRGBSurfaceWithFormatFrom(pixels voidptr, width int, height int, depth int, pitch int, format u32) &C.SDL_Surface
pub fn create_rgb_surface_with_format_from(pixels voidptr, width int, height int, depth int, pitch int, format u32) &Surface {
	return C.SDL_CreateRGBSurfaceWithFormatFrom(pixels, width, height, depth, pitch, format)
}

fn C.SDL_FreeSurface(surface &C.SDL_Surface)
pub fn free_surface(surface &Surface) {
	C.SDL_FreeSurface(surface)
}

fn C.SDL_SetSurfacePalette(surface &C.SDL_Surface, palette &C.SDL_Palette) int

// set_surface_palette sets the palette used by a surface.
//
// returns 0, or -1 if the surface format doesn't use a palette.
//
// NOTE A single palette can be shared with many surfaces.
pub fn set_surface_palette(surface &Surface, palette &Palette) int {
	return C.SDL_SetSurfacePalette(surface, palette)
}

fn C.SDL_LockSurface(surface &C.SDL_Surface) int

// lock_surface sets up a surface for directly accessing the pixels.
//
// Between calls to SDL_LockSurface() / SDL_UnlockSurface(), you can write
// to and read from `surface->pixels`, using the pixel format stored in
// `surface->format`.  Once you are done accessing the surface, you should
// use SDL_UnlockSurface() to release it.
//
// Not all surfaces require locking.  If SDL_MUSTLOCK(surface) evaluates
// to 0, then you can read and write to the surface at any time, and the
// pixel format of the surface will not change.
//
// No operating system or library calls should be made between lock/unlock
// pairs, as critical system locks may be held during this time.
//
// SDL_LockSurface() returns 0, or -1 if the surface couldn't be locked.
//
// See also: SDL_UnlockSurface()
pub fn lock_surface(surface &Surface) int {
	return C.SDL_LockSurface(surface)
}

fn C.SDL_UnlockSurface(surface &C.SDL_Surface)
pub fn unlock_surface(surface &Surface) {
	C.SDL_UnlockSurface(surface)
}

fn C.SDL_LoadBMP_RW(src &C.SDL_RWops, freesrc int) &C.SDL_Surface

// load_bmp_rw loads a surface from a seekable SDL data stream (memory or file).
//
// If `freesrc` is non-zero, the stream will be closed after being read.
//
// The new surface should be freed with SDL_FreeSurface().
//
// returns the new surface, or NULL if there was an error.
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

// save_bmp_rw saves a surface to a seekable SDL data stream (memory or file).
//
// Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
// BMP directly. Other RGB formats with 8-bit or higher get converted to a
// 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
// surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
// not supported.
//
// If `freedst` is non-zero, the stream will be closed after being written.
//
// returns 0 if successful or -1 if there was an error.
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
// returns 0 on success, or -1 if the surface is not valid
//
// NOTE If RLE is enabled, colorkey and alpha blending blits are much faster,
// but the surface must be locked before directly accessing the pixels.
pub fn set_surface_rle(surface &Surface, flag int) int {
	return C.SDL_SetSurfaceRLE(surface, flag)
}

fn C.SDL_SetColorKey(surface &C.SDL_Surface, flag int, key u32) int

// set_color_key sets the color key (transparent pixel) in a blittable surface.
//
// `surface` The surface to update
// `flag` Non-zero to enable colorkey and 0 to disable colorkey
// `key` The transparent pixel in the native surface format
//
// returns 0 on success, or -1 if the surface is not valid
//
// You can pass SDL_RLEACCEL to enable RLE accelerated blits.
pub fn set_color_key(surface &Surface, flag int, key u32) int {
	return C.SDL_SetColorKey(surface, flag, key)
}

fn C.SDL_GetColorKey(surface &C.SDL_Surface, key &u32) int

// get_color_key gets the color key (transparent pixel) in a blittable surface.
//
// `surface` The surface to update
// `key` A pointer filled in with the transparent pixel in the native
// surface format
//
// returns 0 on success, or -1 if the surface is not valid or colorkey is not
// enabled.
pub fn get_color_key(surface &Surface, key &u32) int {
	return C.SDL_GetColorKey(surface, key)
}

fn C.SDL_SetSurfaceColorMod(surface &C.SDL_Surface, r u8, g u8, b u8) int

// set_surface_color_mod sets an additional color value used in blit operations.
//
// `surface` The surface to update.
// `r` The red color value multiplied into blit operations.
// `g` The green color value multiplied into blit operations.
// `b` The blue color value multiplied into blit operations.
//
// returns 0 on success, or -1 if the surface is not valid.
//
// See also: SDL_GetSurfaceColorMod()
pub fn set_surface_color_mod(surface &Surface, r u8, g u8, b u8) int {
	return C.SDL_SetSurfaceColorMod(surface, r, g, b)
}

fn C.SDL_GetSurfaceColorMod(surface &C.SDL_Surface, r &u8, g &u8, b &u8) int

// get_surface_color_mod gets the additional color value used in blit operations.
//
// `surface` The surface to query.
// `r` A pointer filled in with the current red color value.
// `g` A pointer filled in with the current green color value.
// `b` A pointer filled in with the current blue color value.
//
// returns 0 on success, or -1 if the surface is not valid.
//
// See also: SDL_SetSurfaceColorMod()
pub fn get_surface_color_mod(surface &Surface, r &u8, g &u8, b &u8) int {
	return C.SDL_GetSurfaceColorMod(surface, r, g, b)
}

fn C.SDL_SetSurfaceAlphaMod(surface &C.SDL_Surface, alpha u8) int

// set_surface_alpha_mod sets an additional alpha value used in blit operations.
//
// `surface` The surface to update.
// `alpha` The alpha value multiplied into blit operations.
//
// returns 0 on success, or -1 if the surface is not valid.
//
// See also: SDL_GetSurfaceAlphaMod()
pub fn set_surface_alpha_mod(surface &Surface, alpha u8) int {
	return C.SDL_SetSurfaceAlphaMod(surface, alpha)
}

fn C.SDL_GetSurfaceAlphaMod(surface &C.SDL_Surface, alpha &u8) int

// get_surface_alpha_mod gets the additional alpha value used in blit operations.
//
// `surface` The surface to query.
// `alpha` A pointer filled in with the current alpha value.
//
// returns 0 on success, or -1 if the surface is not valid.
//
// See also: SDL_SetSurfaceAlphaMod()
pub fn get_surface_alpha_mod(surface &Surface, alpha &u8) int {
	return C.SDL_GetSurfaceAlphaMod(surface, alpha)
}

fn C.SDL_SetSurfaceBlendMode(surface &C.SDL_Surface, blend_mode C.SDL_BlendMode) int

// set_surface_blend_mode sets the blend mode used for blit operations.
//
// `surface` The surface to update.
// `blendMode` ::SDL_BlendMode to use for blit blending.
//
// returns 0 on success, or -1 if the parameters are not valid.
//
// See also: SDL_GetSurfaceBlendMode()
pub fn set_surface_blend_mode(surface &Surface, blend_mode BlendMode) int {
	return C.SDL_SetSurfaceBlendMode(surface, C.SDL_BlendMode(int(blend_mode)))
}

fn C.SDL_GetSurfaceBlendMode(surface &C.SDL_Surface, blend_mode &C.SDL_BlendMode) int

// get_surface_blend_mode gets the blend mode used for blit operations.
//
// `surface`   The surface to query.
// `blendMode` A pointer filled in with the current blend mode.
//
// returns 0 on success, or -1 if the surface is not valid.
//
// See also: SDL_SetSurfaceBlendMode()
pub fn get_surface_blend_mode(surface &Surface, blend_mode &BlendMode) int {
	return C.SDL_GetSurfaceBlendMode(surface, &C.SDL_BlendMode(int(blend_mode)))
}

fn C.SDL_SetClipRect(surface &C.SDL_Surface, const_rect &C.SDL_Rect) bool

// set_clip_rect sets the clipping rectangle for the destination surface in a blit.
//
// If the clip rectangle is NULL, clipping will be disabled.
//
// If the clip rectangle doesn't intersect the surface, the function will
// return SDL_FALSE and blits will be completely clipped.  Otherwise the
// function returns SDL_TRUE and blits to the surface will be clipped to
// the intersection of the surface area and the clipping rectangle.
//
// Note that blits are automatically clipped to the edges of the source
// and destination surfaces.
pub fn set_clip_rect(surface &Surface, const_rect &Rect) bool {
	return C.SDL_SetClipRect(surface, const_rect)
}

fn C.SDL_GetClipRect(surface &C.SDL_Surface, rect &C.SDL_Rect)

// get_clip_rect gets the clipping rectangle for the destination surface in a blit.
//
// `rect` must be a pointer to a valid rectangle which will be filled
// with the correct values.
pub fn get_clip_rect(surface &Surface, rect &Rect) {
	C.SDL_GetClipRect(surface, rect)
}

fn C.SDL_DuplicateSurface(surface &C.SDL_Surface) &C.SDL_Surface

// duplicate_surface creates a new surface identical to the existing surface
pub fn duplicate_surface(surface &Surface) &Surface {
	return C.SDL_DuplicateSurface(surface)
}

fn C.SDL_ConvertSurface(src &C.SDL_Surface, const_fmt &C.SDL_PixelFormat, flags u32) &C.SDL_Surface

// convert_surface creates a new surface of the specified format, and then copies and maps
// the given surface to it so the blit of the converted surface will be as
// fast as possible.  If this function fails, it returns NULL.
//
// The `flags` parameter is passed to SDL_CreateRGBSurface() and has those
// semantics.  You can also pass ::SDL_RLEACCEL in the flags parameter and
// SDL will try to RLE accelerate colorkey and alpha blits in the resulting
// surface.
pub fn convert_surface(src &Surface, const_fmt &PixelFormat, flags u32) &Surface {
	return C.SDL_ConvertSurface(src, const_fmt, flags)
}

fn C.SDL_ConvertSurfaceFormat(src &C.SDL_Surface, pixel_format u32, flags u32) &C.SDL_Surface
pub fn convert_surface_format(src &Surface, pixel_format u32, flags u32) &Surface {
	return C.SDL_ConvertSurfaceFormat(src, pixel_format, flags)
}

fn C.SDL_ConvertPixels(width int, height int, const_src_format u32, const_src voidptr, const_src_pitch int, dst_format u32, dst voidptr, dst_pitch int) int

// convert_pixels copies a block of pixels of one format to another format
//
// returns 0 on success, or -1 if there was an error
pub fn convert_pixels(width int, height int, const_src_format u32, const_src voidptr, const_src_pitch int, dst_format u32, dst voidptr, dst_pitch int) int {
	return C.SDL_ConvertPixels(width, height, const_src_format, const_src, const_src_pitch,
		dst_format, dst, dst_pitch)
}

fn C.SDL_FillRect(dst &C.SDL_Surface, const_rect &C.SDL_Rect, color u32) int

// fill_rect performs a fast fill of the given rectangle with `color`.
//
// If `rect` is NULL, the whole surface will be filled with `color`.
//
// The color should be a pixel of the format used by the surface, and
// can be generated by the SDL_MapRGB() function.
//
// returns 0 on success, or -1 on error.
pub fn fill_rect(dst &Surface, const_rect &Rect, color u32) int {
	return C.SDL_FillRect(dst, const_rect, color)
}

fn C.SDL_FillRects(dst &C.SDL_Surface, const_rects &C.SDL_Rect, count int, color u32) int
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

// upper_blit is the public blit function, SDL_BlitSurface(), and it performs
// rectangle validation and clipping before passing it to SDL_LowerBlit()
pub fn upper_blit(src &Surface, const_srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_UpperBlit(src, const_srcrect, dst, dstrect)
}

fn C.SDL_LowerBlit(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int

// lower_blit is a semi-private blit function and it performs low-level surface
// blitting only.
pub fn lower_blit(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_LowerBlit(src, srcrect, dst, dstrect)
}

fn C.SDL_SoftStretch(src &C.SDL_Surface, const_srcrect &C.SDL_Rect, dst &C.SDL_Surface, const_dstrect &C.SDL_Rect) int

// soft_stretch performs a fast, low quality, stretch blit between two surfaces of the
// same pixel format.
//
// NOTE This function uses a static buffer, and is not thread-safe.
pub fn soft_stretch(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect) int {
	return C.SDL_SoftStretch(src, const_srcrect, dst, const_dstrect)
}

fn C.SDL_BlitScaled(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int
pub fn blit_scaled(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_UpperBlitScaled(src, srcrect, dst, dstrect)
}

fn C.SDL_UpperBlitScaled(src &C.SDL_Surface, const_srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int

// upper_blit_scaled is the public scaled blit function, SDL_BlitScaled(), and it performs
// rectangle validation and clipping before passing it to SDL_LowerBlitScaled()
pub fn upper_blit_scaled(src &Surface, const_srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_UpperBlitScaled(src, const_srcrect, dst, dstrect)
}

fn C.SDL_LowerBlitScaled(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int

// lower_blit_scaled is a semi-private blit function and it performs low-level surface
// scaled blitting only.
pub fn lower_blit_scaled(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int {
	return C.SDL_LowerBlitScaled(src, srcrect, dst, dstrect)
}

fn C.SDL_SetYUVConversionMode(mode C.SDL_YUV_CONVERSION_MODE)

// set_yuv_conversion_mode sets the YUV conversion mode
pub fn set_yuv_conversion_mode(mode YUVConversionMode) {
	C.SDL_SetYUVConversionMode(C.SDL_YUV_CONVERSION_MODE(int(mode)))
}

fn C.SDL_GetYUVConversionMode() YUVConversionMode

// get_yuv_conversion_mode gets the YUV conversion mode
pub fn get_yuv_conversion_mode() YUVConversionMode {
	return unsafe { YUVConversionMode(int(C.SDL_GetYUVConversionMode())) }
}

fn C.SDL_GetYUVConversionModeForResolution(width int, height int) YUVConversionMode

// get_yuv_conversion_mode_for_resolution gets the YUV conversion mode, returning the correct mode for the resolution when
// the current conversion mode is SDL_YUV_CONVERSION_AUTOMATIC
pub fn get_yuv_conversion_mode_for_resolution(width int, height int) YUVConversionMode {
	return unsafe {
		YUVConversionMode(int(C.SDL_GetYUVConversionModeForResolution(width, height)))
	}
}
