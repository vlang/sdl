// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_surface.h
//

[typedef]
struct C.SDL_Surface {
pub:
	flags u32 // Read-only
	format &C.SDL_PixelFormat // Read-only
	w int // Read-only
	h int // Read-only
	pitch int // Read-only
	//
	locked int // Read-only
	lock_data voidptr // Read-only
	clip_rect C.SDL_Rect // Read-only
	// @map &C.SDL_BlitMap // Private
	refcount int // Read-mostly
pub mut:
	pixels voidptr // Read-write
	userdata voidptr  // Read-write
}
pub type Surface = C.SDL_Surface


/**
 * \brief The type of function used for surface blitting functions.
 */
//typedef int (SDLCALL *SDL_blit) (struct SDL_Surface * src, SDL_Rect * srcrect, struct SDL_Surface * dst, SDL_Rect * dstrect);
fn C.SDL_blit(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int
type BlitCall = fn (src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int

// YUVConversionMode is C.SDL_YUV_CONVERSION_MODE
pub enum YUVConversionMode {
	jpeg  =  C.SDL_YUV_CONVERSION_JPEG        // Full range JPEG
    bt601 = C.SDL_YUV_CONVERSION_BT601       // BT.601 (the default)
    bt709  =   C.SDL_YUV_CONVERSION_BT709       // BT.709
    automatic = C.SDL_YUV_CONVERSION_AUTOMATIC    // BT.601 for SD content, BT.709 for HD content
}


/**
 *  Allocate and free an RGB surface.
 *
 *  If the depth is 4 or 8 bits, an empty palette is allocated for the surface.
 *  If the depth is greater than 8 bits, the pixel format is set using the
 *  flags '[RGB]mask'.
 *
 *  If the function runs out of memory, it will return NULL.
 *
 *  \param flags The \c flags are obsolete and should be set to 0.
 *  \param width The width in pixels of the surface to create.
 *  \param height The height in pixels of the surface to create.
 *  \param depth The depth in bits of the surface to create.
 *  \param Rmask The red mask of the surface to create.
 *  \param Gmask The green mask of the surface to create.
 *  \param Bmask The blue mask of the surface to create.
 *  \param Amask The alpha mask of the surface to create.
 */
fn C.SDL_CreateRGBSurface(flags u32, width int, height int, depth int, rmask u32, gmask u32, bmask u32, amask u32) &C.SDL_Surface
pub fn create_rgb_surface(flags u32, width int, height int, depth int, rmask u32, gmask u32, bmask u32, amask u32) &Surface{
	return C.SDL_CreateRGBSurface(flags, width, height, depth, rmask, gmask, bmask, amask)
}

fn C.SDL_CreateRGBSurfaceWithFormat(flags u32, width int, height int, depth int, format u32) &C.SDL_Surface
pub fn create_rgb_surface_with_format(flags u32, width int, height int, depth int, format u32) &C.SDL_Surface{
	return C.SDL_CreateRGBSurfaceWithFormat(flags, width, height, depth, format)
}

fn C.SDL_CreateRGBSurfaceFrom(pixels voidptr, width int, height int, depth int, pitch int, rmask u32, gmask u32, bmask u32, amask u32) &C.SDL_Surface
pub fn create_rgb_surface_from(pixels voidptr, width int, height int, depth int, pitch int, rmask u32, gmask u32, bmask u32, amask u32) &C.SDL_Surface{
	return C.SDL_CreateRGBSurfaceFrom(pixels, width, height, depth, pitch, rmask, gmask, bmask, amask)
}

fn C.SDL_CreateRGBSurfaceWithFormatFrom(pixels voidptr, width int, height int, depth int, pitch int, format u32) &C.SDL_Surface
pub fn create_rgb_surface_with_format_from(pixels voidptr, width int, height int, depth int, pitch int, format u32) &C.SDL_Surface{
	return C.SDL_CreateRGBSurfaceWithFormatFrom(pixels, width, height, depth, pitch, format)
}

fn C.SDL_FreeSurface(surface &C.SDL_Surface)
pub fn free_surface(surface &Surface){
	 C.SDL_FreeSurface(surface)
}

/**
 *  \brief Set the palette used by a surface.
 *
 *  \return 0, or -1 if the surface format doesn't use a palette.
 *
 *  \note A single palette can be shared with many surfaces.
 */
fn C.SDL_SetSurfacePalette(surface &C.SDL_Surface, palette &C.SDL_Palette) int
pub fn set_surface_palette(surface &Surface, palette &Palette) int{
	return C.SDL_SetSurfacePalette(surface, palette)
}

/**
 *  \brief Sets up a surface for directly accessing the pixels.
 *
 *  Between calls to SDL_LockSurface() / SDL_UnlockSurface(), you can write
 *  to and read from \c surface->pixels, using the pixel format stored in
 *  \c surface->format.  Once you are done accessing the surface, you should
 *  use SDL_UnlockSurface() to release it.
 *
 *  Not all surfaces require locking.  If SDL_MUSTLOCK(surface) evaluates
 *  to 0, then you can read and write to the surface at any time, and the
 *  pixel format of the surface will not change.
 *
 *  No operating system or library calls should be made between lock/unlock
 *  pairs, as critical system locks may be held during this time.
 *
 *  SDL_LockSurface() returns 0, or -1 if the surface couldn't be locked.
 *
 *  \sa SDL_UnlockSurface()
 */
fn C.SDL_LockSurface(surface &C.SDL_Surface) int
pub fn lock_surface(surface &Surface) int{
	return C.SDL_LockSurface(surface)
}

fn C.SDL_UnlockSurface(surface &C.SDL_Surface)
pub fn unlock_surface(surface &C.SDL_Surface){
	 C.SDL_UnlockSurface(surface)
}

/**
 *  Load a surface from a seekable SDL data stream (memory or file).
 *
 *  If \c freesrc is non-zero, the stream will be closed after being read.
 *
 *  The new surface should be freed with SDL_FreeSurface().
 *
 *  \return the new surface, or NULL if there was an error.
 */
fn C.SDL_LoadBMP_RW(src &C.SDL_RWops, freesrc int) &C.SDL_Surface
pub fn load_bmp_rw(src &RWops, freesrc int) &Surface{
	return C.SDL_LoadBMP_RW(src, freesrc)
}

/**
 *  Load a surface from a file.
 *
 *  Convenience macro.
 */
fn C.SDL_LoadBMP(file &char) &C.SDL_Surface
pub fn load_bmp(path string) &Surface{
	return C.SDL_LoadBMP(path.str)
}

/**
 *  Save a surface to a seekable SDL data stream (memory or file).
 *
 *  Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
 *  BMP directly. Other RGB formats with 8-bit or higher get converted to a
 *  24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
 *  surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
 *  not supported.
 *
 *  If \c freedst is non-zero, the stream will be closed after being written.
 *
 *  \return 0 if successful or -1 if there was an error.
 */
fn C.SDL_SaveBMP_RW(surface &C.SDL_Surface, dst &C.SDL_RWops, freedst int) int
pub fn save_bmp_rw(surface &Surface, dst &RWops, freedst int) int{
	return C.SDL_SaveBMP_RW(surface, dst, freedst)
}

/**
 *  Save a surface to a file.
 *
 *  Convenience macro.
 */
fn C.SDL_SaveBMP(surface &C.SDL_Surface, file &char)
pub fn save_bmp(surface &Surface, path string) {
	C.SDL_SaveBMP(surface, path.str)
}

/**
 *  \brief Sets the RLE acceleration hint for a surface.
 *
 *  \return 0 on success, or -1 if the surface is not valid
 *
 *  \note If RLE is enabled, colorkey and alpha blending blits are much faster,
 *        but the surface must be locked before directly accessing the pixels.
 */
fn C.SDL_SetSurfaceRLE(surface &C.SDL_Surface, flag int) int
pub fn set_surface_rle(surface &Surface, flag int) int{
	return C.SDL_SetSurfaceRLE(surface, flag)
}

/**
 *  \brief Sets the color key (transparent pixel) in a blittable surface.
 *
 *  \param surface The surface to update
 *  \param flag Non-zero to enable colorkey and 0 to disable colorkey
 *  \param key The transparent pixel in the native surface format
 *
 *  \return 0 on success, or -1 if the surface is not valid
 *
 *  You can pass SDL_RLEACCEL to enable RLE accelerated blits.
 */
fn C.SDL_SetColorKey(surface &C.SDL_Surface, flag int, key u32) int
pub fn set_color_key(surface &Surface, flag int, key u32) int{
	return C.SDL_SetColorKey(surface, flag, key)
}

/**
 *  \brief Gets the color key (transparent pixel) in a blittable surface.
 *
 *  \param surface The surface to update
 *  \param key A pointer filled in with the transparent pixel in the native
 *             surface format
 *
 *  \return 0 on success, or -1 if the surface is not valid or colorkey is not
 *          enabled.
 */
fn C.SDL_GetColorKey(surface &C.SDL_Surface, key &u32) int
pub fn get_color_key(surface &Surface, key &u32) int{
	return C.SDL_GetColorKey(surface, key)
}

/**
 *  \brief Set an additional color value used in blit operations.
 *
 *  \param surface The surface to update.
 *  \param r The red color value multiplied into blit operations.
 *  \param g The green color value multiplied into blit operations.
 *  \param b The blue color value multiplied into blit operations.
 *
 *  \return 0 on success, or -1 if the surface is not valid.
 *
 *  \sa SDL_GetSurfaceColorMod()
 */
fn C.SDL_SetSurfaceColorMod(surface &C.SDL_Surface, r byte, g byte, b byte) int
pub fn set_surface_color_mod(surface &Surface, r byte, g byte, b byte) int{
	return C.SDL_SetSurfaceColorMod(surface, r, g, b)
}

/**
 *  \brief Get the additional color value used in blit operations.
 *
 *  \param surface The surface to query.
 *  \param r A pointer filled in with the current red color value.
 *  \param g A pointer filled in with the current green color value.
 *  \param b A pointer filled in with the current blue color value.
 *
 *  \return 0 on success, or -1 if the surface is not valid.
 *
 *  \sa SDL_SetSurfaceColorMod()
 */
fn C.SDL_GetSurfaceColorMod(surface &C.SDL_Surface, r &byte, g &byte, b &byte) int
pub fn get_surface_color_mod(surface &Surface, r &byte, g &byte, b &byte) int{
	return C.SDL_GetSurfaceColorMod(surface, r, g, b)
}

/**
 *  \brief Set an additional alpha value used in blit operations.
 *
 *  \param surface The surface to update.
 *  \param alpha The alpha value multiplied into blit operations.
 *
 *  \return 0 on success, or -1 if the surface is not valid.
 *
 *  \sa SDL_GetSurfaceAlphaMod()
 */
fn C.SDL_SetSurfaceAlphaMod(surface &C.SDL_Surface, alpha byte) int
pub fn set_surface_alpha_mod(surface &Surface, alpha byte) int{
	return C.SDL_SetSurfaceAlphaMod(surface, alpha)
}

/**
 *  \brief Get the additional alpha value used in blit operations.
 *
 *  \param surface The surface to query.
 *  \param alpha A pointer filled in with the current alpha value.
 *
 *  \return 0 on success, or -1 if the surface is not valid.
 *
 *  \sa SDL_SetSurfaceAlphaMod()
 */
fn C.SDL_GetSurfaceAlphaMod(surface &C.SDL_Surface, alpha &byte) int
pub fn get_surface_alpha_mod(surface &Surface, alpha &byte) int{
	return C.SDL_GetSurfaceAlphaMod(surface, alpha)
}

/**
 *  \brief Set the blend mode used for blit operations.
 *
 *  \param surface The surface to update.
 *  \param blendMode ::SDL_BlendMode to use for blit blending.
 *
 *  \return 0 on success, or -1 if the parameters are not valid.
 *
 *  \sa SDL_GetSurfaceBlendMode()
 */
fn C.SDL_SetSurfaceBlendMode(surface &C.SDL_Surface, blend_mode C.SDL_BlendMode) int
pub fn set_surface_blend_mode(surface &Surface, blend_mode BlendMode) int{
	return C.SDL_SetSurfaceBlendMode(surface, C.SDL_BlendMode(int(blend_mode)))
}

/**
 *  \brief Get the blend mode used for blit operations.
 *
 *  \param surface   The surface to query.
 *  \param blendMode A pointer filled in with the current blend mode.
 *
 *  \return 0 on success, or -1 if the surface is not valid.
 *
 *  \sa SDL_SetSurfaceBlendMode()
 */
fn C.SDL_GetSurfaceBlendMode(surface &C.SDL_Surface, blend_mode &C.SDL_BlendMode) int
pub fn get_surface_blend_mode(surface &Surface, blend_mode &BlendMode) int{
	return C.SDL_GetSurfaceBlendMode(surface, &C.SDL_BlendMode(int(blend_mode)))
}

/**
 *  Sets the clipping rectangle for the destination surface in a blit.
 *
 *  If the clip rectangle is NULL, clipping will be disabled.
 *
 *  If the clip rectangle doesn't intersect the surface, the function will
 *  return SDL_FALSE and blits will be completely clipped.  Otherwise the
 *  function returns SDL_TRUE and blits to the surface will be clipped to
 *  the intersection of the surface area and the clipping rectangle.
 *
 *  Note that blits are automatically clipped to the edges of the source
 *  and destination surfaces.
 */
fn C.SDL_SetClipRect(surface &C.SDL_Surface, rect &C.SDL_Rect) bool
pub fn set_clip_rect(surface &Surface, rect &Rect) bool{
	return C.SDL_SetClipRect(surface, rect)
}

/**
 *  Gets the clipping rectangle for the destination surface in a blit.
 *
 *  \c rect must be a pointer to a valid rectangle which will be filled
 *  with the correct values.
 */
fn C.SDL_GetClipRect(surface &C.SDL_Surface, rect &C.SDL_Rect)
pub fn get_clip_rect(surface &Surface, rect &Rect){
	 C.SDL_GetClipRect(surface, rect)
}

/*
 * Creates a new surface identical to the existing surface
 */
fn C.SDL_DuplicateSurface(surface &C.SDL_Surface) &C.SDL_Surface
pub fn duplicate_surface(surface &Surface) &Surface{
	return C.SDL_DuplicateSurface(surface)
}

/**
 *  Creates a new surface of the specified format, and then copies and maps
 *  the given surface to it so the blit of the converted surface will be as
 *  fast as possible.  If this function fails, it returns NULL.
 *
 *  The \c flags parameter is passed to SDL_CreateRGBSurface() and has those
 *  semantics.  You can also pass ::SDL_RLEACCEL in the flags parameter and
 *  SDL will try to RLE accelerate colorkey and alpha blits in the resulting
 *  surface.
 */
fn C.SDL_ConvertSurface(src &C.SDL_Surface, fmt &C.SDL_PixelFormat, flags u32) &C.SDL_Surface
pub fn convert_surface(src &C.SDL_Surface, fmt &PixelFormat, flags u32) &Surface{
	return C.SDL_ConvertSurface(src, fmt, flags)
}

fn C.SDL_ConvertSurfaceFormat(src &C.SDL_Surface, pixel_format u32, flags u32) &C.SDL_Surface
pub fn convert_surface_format(src &C.SDL_Surface, pixel_format u32, flags u32) &C.SDL_Surface{
	return C.SDL_ConvertSurfaceFormat(src, pixel_format, flags)
}

/**
 * \brief Copy a block of pixels of one format to another format
 *
 *  \return 0 on success, or -1 if there was an error
 */
fn C.SDL_ConvertPixels(width int, height int, src_format u32, src voidptr, src_pitch int, dst_format u32, dst voidptr, dst_pitch int) int
pub fn convert_pixels(width int, height int, src_format u32, src voidptr, src_pitch int, dst_format u32, dst voidptr, dst_pitch int) int{
	return C.SDL_ConvertPixels(width, height, src_format, src, src_pitch, dst_format, dst, dst_pitch)
}

/**
 *  Performs a fast fill of the given rectangle with \c color.
 *
 *  If \c rect is NULL, the whole surface will be filled with \c color.
 *
 *  The color should be a pixel of the format used by the surface, and
 *  can be generated by the SDL_MapRGB() function.
 *
 *  \return 0 on success, or -1 on error.
 */
fn C.SDL_FillRect(dst &C.SDL_Surface, rect &C.SDL_Rect, color u32) int
pub fn fill_rect(dst &Surface, rect &Rect, color u32) int{
	return C.SDL_FillRect(dst, rect, color)
}

fn C.SDL_FillRects(dst &C.SDL_Surface, rects &C.SDL_Rect, count int, color u32) int
pub fn fill_rects(dst &C.SDL_Surface, rects &C.SDL_Rect, count int, color u32) int{
	return C.SDL_FillRects(dst, rects, count, color)
}

/**
 *  Performs a fast blit from the source surface to the destination surface.
 *
 *  This assumes that the source and destination rectangles are
 *  the same size.  If either \c srcrect or \c dstrect are NULL, the entire
 *  surface (\c src or \c dst) is copied.  The final blit rectangles are saved
 *  in \c srcrect and \c dstrect after all clipping is performed.
 *
 *  \return If the blit is successful, it returns 0, otherwise it returns -1.
 *
 *  The blit function should not be called on a locked surface.
 *
 *  The blit semantics for surfaces with and without blending and colorkey
 *  are defined as follows:
 *  \verbatim
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
    \endverbatim
 *
 *  You should call SDL_BlitSurface() unless you know exactly how SDL
 *  blitting works internally and how to use the other blit functions.
 */
fn C.SDL_BlitSurface(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int
pub fn blit_surface(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int{
	return C.SDL_UpperBlit(src, srcrect, dst, dstrect)
}

/**
 *  This is the public blit function, SDL_BlitSurface(), and it performs
 *  rectangle validation and clipping before passing it to SDL_LowerBlit()
 */
fn C.SDL_UpperBlit(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int
pub fn upper_blit(src &Surface, srcrect &Rect, dst &C.SDL_Surface, dstrect &Rect) int{
	return C.SDL_UpperBlit(src, srcrect, dst, dstrect)
}
/**
 *  This is a semi-private blit function and it performs low-level surface
 *  blitting only.
 */
fn C.SDL_LowerBlit(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int
pub fn lower_blit(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int{
	return C.SDL_LowerBlit(src, srcrect, dst, dstrect)
}

/**
 *  \brief Perform a fast, low quality, stretch blit between two surfaces of the
 *         same pixel format.
 *
 *  \note This function uses a static buffer, and is not thread-safe.
 */
fn C.SDL_SoftStretch(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int
pub fn soft_stretch(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int{
	return C.SDL_SoftStretch(src, srcrect, dst, dstrect)
}

fn C.SDL_BlitScaled(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int
pub fn blit_scaled(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int{
	return C.SDL_UpperBlitScaled(src, srcrect, dst, dstrect)
}

/**
 *  This is the public scaled blit function, SDL_BlitScaled(), and it performs
 *  rectangle validation and clipping before passing it to SDL_LowerBlitScaled()
 */
fn C.SDL_UpperBlitScaled(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int
pub fn upper_blit_scaled(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int{
	return C.SDL_UpperBlitScaled(src, srcrect, dst, dstrect)
}

/**
 *  This is a semi-private blit function and it performs low-level surface
 *  scaled blitting only.
 */
fn C.SDL_LowerBlitScaled(src &C.SDL_Surface, srcrect &C.SDL_Rect, dst &C.SDL_Surface, dstrect &C.SDL_Rect) int
pub fn lower_blit_scaled(src &Surface, srcrect &Rect, dst &Surface, dstrect &Rect) int{
	return C.SDL_LowerBlitScaled(src, srcrect, dst, dstrect)
}

/**
 *  \brief Set the YUV conversion mode
 */
fn C.SDL_SetYUVConversionMode(mode C.SDL_YUV_CONVERSION_MODE)
pub fn set_yuv_conversion_mode(mode YUVConversionMode){
	 C.SDL_SetYUVConversionMode(C.SDL_YUV_CONVERSION_MODE(int(mode)))
}

/**
 *  \brief Get the YUV conversion mode
 */
fn C.SDL_GetYUVConversionMode() C.SDL_YUV_CONVERSION_MODE
pub fn get_yuv_conversion_mode() YUVConversionMode {
	return YUVConversionMode(int(C.SDL_GetYUVConversionMode()))
}

/**
 *  \brief Get the YUV conversion mode, returning the correct mode for the resolution when the current conversion mode is SDL_YUV_CONVERSION_AUTOMATIC
 */
fn C.SDL_GetYUVConversionModeForResolution(width int, height int) C.SDL_YUV_CONVERSION_MODE
pub fn get_yuv_conversion_mode_for_resolution(width int, height int) YUVConversionMode{
	return YUVConversionMode(int(C.SDL_GetYUVConversionModeForResolution(width, height)))
}

