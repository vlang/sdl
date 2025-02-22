// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_surface.h
//

// SDL surfaces are buffers of pixels in system RAM. These are useful for
// passing around and manipulating images that are not stored in GPU memory.
//
// SDL_Surface makes serious efforts to manage images in various formats, and
// provides a reasonable toolbox for transforming the data, including copying
// between surfaces, filling rectangles in the image data, etc.
//
// There is also a simple .bmp loader, SDL_LoadBMP(). SDL itself does not
// provide loaders for various other file formats, but there are several
// excellent external libraries that do, including its own satellite library,
// SDL_image:
//
// https://github.com/libsdl-org/SDL_image

// The flags on an SDL_Surface.
//
// These are generally considered read-only.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type SurfaceFlags = u32

pub const surface_preallocated = C.SDL_SURFACE_PREALLOCATED // 0x00000001u

pub const surface_lock_needed = C.SDL_SURFACE_LOCK_NEEDED // 0x00000002u

pub const surface_locked = C.SDL_SURFACE_LOCKED // 0x00000004u

pub const surface_simd_aligned = C.SDL_SURFACE_SIMD_ALIGNED // 0x00000008u

// TODO: Function: #define SDL_MUSTLOCK(S) ((((S)->flags & SDL_SURFACE_LOCK_NEEDED)) == SDL_SURFACE_LOCK_NEEDED)

// ScaleMode is C.SDL_ScaleMode
pub enum ScaleMode {
	nearest = C.SDL_SCALEMODE_NEAREST // `nearest` nearest pixel sampling
	linear  = C.SDL_SCALEMODE_LINEAR  // `linear` linear filtering
}

// FlipMode is C.SDL_FlipMode
pub enum FlipMode {
	none       = C.SDL_FLIP_NONE       // `none` Do not flip
	horizontal = C.SDL_FLIP_HORIZONTAL // `horizontal` flip horizontally
	vertical   = C.SDL_FLIP_VERTICAL   // `vertical` flip vertically
}

// A collection of pixels used in software blitting.
//
// Pixels are arranged in memory in rows, with the top row first. Each row
// occupies an amount of memory given by the pitch (sometimes known as the row
// stride in non-SDL APIs).
//
// Within each row, pixels are arranged from left to right until the width is
// reached. Each pixel occupies a number of bits appropriate for its format,
// with most formats representing each pixel as one or more whole bytes (in
// some indexed formats, instead multiple pixels are packed into each byte),
// and a byte order given by the format. After encoding all pixels, any
// remaining bytes to reach the pitch are used as padding to reach a desired
// alignment, and have undefined contents.
//
// When a surface holds YUV format data, the planes are assumed to be
// contiguous without padding between them, e.g. a 32x32 surface in NV12
// format with a pitch of 32 would consist of 32x32 bytes of Y plane followed
// by 32x16 bytes of UV plane.
//
// NOTE: This struct is available since SDL 3.2.0.
//
// See also: create_surface (SDL_CreateSurface)
// See also: destroy_surface (SDL_DestroySurface)
@[noinit; typedef]
pub struct C.SDL_Surface {
	flags  SurfaceFlags // The flags of the surface, read-only
	format PixelFormat  // The format of the surface, read-only
	w      int          // The width of the surface, read-only.
	h      int          // The height of the surface, read-only.
	pitch  int          // The distance in bytes between rows of pixels, read-only

	refcount int // Application reference count, used when freeing surface

	reserved voidptr // Reserved for internal use
pub mut:
	pixels voidptr // A pointer to the pixels of the surface, the pixels are writeable if non-NULL
}

pub type Surface = C.SDL_Surface

// C.SDL_CreateSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateSurface)
fn C.SDL_CreateSurface(width int, height int, format PixelFormat) &Surface

// create_surface allocates a new surface with a specific pixel format.
//
// The pixels of the new surface are initialized to zero.
//
// `width` width the width of the surface.
// `height` height the height of the surface.
// `format` format the SDL_PixelFormat for the new surface's pixel format.
// returns the new SDL_Surface structure that is created or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_surface_from (SDL_CreateSurfaceFrom)
// See also: destroy_surface (SDL_DestroySurface)
pub fn create_surface(width int, height int, format PixelFormat) &Surface {
	return C.SDL_CreateSurface(width, height, format)
}

// C.SDL_CreateSurfaceFrom [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateSurfaceFrom)
fn C.SDL_CreateSurfaceFrom(width int, height int, format PixelFormat, pixels voidptr, pitch int) &Surface

// create_surface_from allocates a new surface with a specific pixel format and existing pixel
// data.
//
// No copy is made of the pixel data. Pixel data is not managed automatically;
// you must free the surface before you free the pixel data.
//
// Pitch is the offset in bytes from one row of pixels to the next, e.g.
// `width*4` for `SDL_PIXELFORMAT_RGBA8888`.
//
// You may pass NULL for pixels and 0 for pitch to create a surface that you
// will fill in with valid values later.
//
// `width` width the width of the surface.
// `height` height the height of the surface.
// `format` format the SDL_PixelFormat for the new surface's pixel format.
// `pixels` pixels a pointer to existing pixel data.
// `pitch` pitch the number of bytes between each row, including padding.
// returns the new SDL_Surface structure that is created or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_surface (SDL_CreateSurface)
// See also: destroy_surface (SDL_DestroySurface)
pub fn create_surface_from(width int, height int, format PixelFormat, pixels voidptr, pitch int) &Surface {
	return C.SDL_CreateSurfaceFrom(width, height, format, pixels, pitch)
}

// C.SDL_DestroySurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroySurface)
fn C.SDL_DestroySurface(surface &Surface)

// destroy_surface frees a surface.
//
// It is safe to pass NULL to this function.
//
// `surface` surface the SDL_Surface to free.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_surface (SDL_CreateSurface)
// See also: create_surface_from (SDL_CreateSurfaceFrom)
pub fn destroy_surface(surface &Surface) {
	C.SDL_DestroySurface(surface)
}

// C.SDL_GetSurfaceProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSurfaceProperties)
fn C.SDL_GetSurfaceProperties(surface &Surface) PropertiesID

// get_surface_properties gets the properties associated with a surface.
//
// The following properties are understood by SDL:
//
// - `SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT`: for HDR10 and floating point
//   surfaces, this defines the value of 100% diffuse white, with higher
//   values being displayed in the High Dynamic Range headroom. This defaults
//   to 203 for HDR10 surfaces and 1.0 for floating point surfaces.
// - `SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT`: for HDR10 and floating point
//   surfaces, this defines the maximum dynamic range used by the content, in
//   terms of the SDR white point. This defaults to 0.0, which disables tone
//   mapping.
// - `SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING`: the tone mapping operator
//   used when compressing from a surface with high dynamic range to another
//   with lower dynamic range. Currently this supports "chrome", which uses
//   the same tone mapping that Chrome uses for HDR content, the form "*=N",
//   where N is a floating point scale factor applied in linear space, and
//   "none", which disables tone mapping. This defaults to "chrome".
//
// `surface` surface the SDL_Surface structure to query.
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_surface_properties(surface &Surface) PropertiesID {
	return C.SDL_GetSurfaceProperties(surface)
}

pub const prop_surface_sdr_white_point_float = C.SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT // 'SDL.surface.SDR_white_point'

pub const prop_surface_hdr_headroom_float = C.SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT // 'SDL.surface.HDR_headroom'

pub const prop_surface_tonemap_operator_string = C.SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING // 'SDL.surface.tonemap'

// C.SDL_SetSurfaceColorspace [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetSurfaceColorspace)
fn C.SDL_SetSurfaceColorspace(surface &Surface, colorspace Colorspace) bool

// set_surface_colorspace sets the colorspace used by a surface.
//
// Setting the colorspace doesn't change the pixels, only how they are
// interpreted in color operations.
//
// `surface` surface the SDL_Surface structure to update.
// `colorspace` colorspace an SDL_Colorspace value describing the surface
//                   colorspace.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_surface_colorspace (SDL_GetSurfaceColorspace)
pub fn set_surface_colorspace(surface &Surface, colorspace Colorspace) bool {
	return C.SDL_SetSurfaceColorspace(surface, colorspace)
}

// C.SDL_GetSurfaceColorspace [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSurfaceColorspace)
fn C.SDL_GetSurfaceColorspace(surface &Surface) Colorspace

// get_surface_colorspace gets the colorspace used by a surface.
//
// The colorspace defaults to SDL_COLORSPACE_SRGB_LINEAR for floating point
// formats, SDL_COLORSPACE_HDR10 for 10-bit formats, SDL_COLORSPACE_SRGB for
// other RGB surfaces and SDL_COLORSPACE_BT709_FULL for YUV textures.
//
// `surface` surface the SDL_Surface structure to query.
// returns the colorspace used by the surface, or SDL_COLORSPACE_UNKNOWN if
//          the surface is NULL.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_surface_colorspace (SDL_SetSurfaceColorspace)
pub fn get_surface_colorspace(surface &Surface) Colorspace {
	return C.SDL_GetSurfaceColorspace(surface)
}

// C.SDL_CreateSurfacePalette [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateSurfacePalette)
fn C.SDL_CreateSurfacePalette(surface &Surface) &Palette

// create_surface_palette creates a palette and associate it with a surface.
//
// This function creates a palette compatible with the provided surface. The
// palette is then returned for you to modify, and the surface will
// automatically use the new palette in future operations. You do not need to
// destroy the returned palette, it will be freed when the reference count
// reaches 0, usually when the surface is destroyed.
//
// Bitmap surfaces (with format SDL_PIXELFORMAT_INDEX1LSB or
// SDL_PIXELFORMAT_INDEX1MSB) will have the palette initialized with 0 as
// white and 1 as black. Other surfaces will get a palette initialized with
// white in every entry.
//
// If this function is called for a surface that already has a palette, a new
// palette will be created to replace it.
//
// `surface` surface the SDL_Surface structure to update.
// returns a new SDL_Palette structure on success or NULL on failure (e.g. if
//          the surface didn't have an index format); call SDL_GetError() for
//          more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_palette_colors (SDL_SetPaletteColors)
pub fn create_surface_palette(surface &Surface) &Palette {
	return C.SDL_CreateSurfacePalette(surface)
}

// C.SDL_SetSurfacePalette [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetSurfacePalette)
fn C.SDL_SetSurfacePalette(surface &Surface, palette &Palette) bool

// set_surface_palette sets the palette used by a surface.
//
// A single palette can be shared with many surfaces.
//
// `surface` surface the SDL_Surface structure to update.
// `palette` palette the SDL_Palette structure to use.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_palette (SDL_CreatePalette)
// See also: get_surface_palette (SDL_GetSurfacePalette)
pub fn set_surface_palette(surface &Surface, palette &Palette) bool {
	return C.SDL_SetSurfacePalette(surface, palette)
}

// C.SDL_GetSurfacePalette [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSurfacePalette)
fn C.SDL_GetSurfacePalette(surface &Surface) &Palette

// get_surface_palette gets the palette used by a surface.
//
// `surface` surface the SDL_Surface structure to query.
// returns a pointer to the palette used by the surface, or NULL if there is
//          no palette used.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_surface_palette (SDL_SetSurfacePalette)
pub fn get_surface_palette(surface &Surface) &Palette {
	return C.SDL_GetSurfacePalette(surface)
}

// C.SDL_AddSurfaceAlternateImage [official documentation](https://wiki.libsdl.org/SDL3/SDL_AddSurfaceAlternateImage)
fn C.SDL_AddSurfaceAlternateImage(surface &Surface, image &Surface) bool

// add_surface_alternate_image adds an alternate version of a surface.
//
// This function adds an alternate version of this surface, usually used for
// content with high DPI representations like cursors or icons. The size,
// format, and content do not need to match the original surface, and these
// alternate versions will not be updated when the original surface changes.
//
// This function adds a reference to the alternate version, so you should call
// SDL_DestroySurface() on the image after this call.
//
// `surface` surface the SDL_Surface structure to update.
// `image` image a pointer to an alternate SDL_Surface to associate with this
//              surface.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: remove_surface_alternate_images (SDL_RemoveSurfaceAlternateImages)
// See also: get_surface_images (SDL_GetSurfaceImages)
// See also: surface_has_alternate_images (SDL_SurfaceHasAlternateImages)
pub fn add_surface_alternate_image(surface &Surface, image &Surface) bool {
	return C.SDL_AddSurfaceAlternateImage(surface, image)
}

// C.SDL_SurfaceHasAlternateImages [official documentation](https://wiki.libsdl.org/SDL3/SDL_SurfaceHasAlternateImages)
fn C.SDL_SurfaceHasAlternateImages(surface &Surface) bool

// surface_has_alternate_images returns whether a surface has alternate versions available.
//
// `surface` surface the SDL_Surface structure to query.
// returns true if alternate versions are available or false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_surface_alternate_image (SDL_AddSurfaceAlternateImage)
// See also: remove_surface_alternate_images (SDL_RemoveSurfaceAlternateImages)
// See also: get_surface_images (SDL_GetSurfaceImages)
pub fn surface_has_alternate_images(surface &Surface) bool {
	return C.SDL_SurfaceHasAlternateImages(surface)
}

// C.SDL_GetSurfaceImages [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSurfaceImages)
fn C.SDL_GetSurfaceImages(surface &Surface, count &int) &&C.SDL_Surface

// get_surface_images gets an array including all versions of a surface.
//
// This returns all versions of a surface, with the surface being queried as
// the first element in the returned array.
//
// Freeing the array of surfaces does not affect the surfaces in the array.
// They are still referenced by the surface being queried and will be cleaned
// up normally.
//
// `surface` surface the SDL_Surface structure to query.
// `count` count a pointer filled in with the number of surface pointers
//              returned, may be NULL.
// returns a NULL terminated array of SDL_Surface pointers or NULL on
//          failure; call SDL_GetError() for more information. This should be
//          freed with SDL_free() when it is no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_surface_alternate_image (SDL_AddSurfaceAlternateImage)
// See also: remove_surface_alternate_images (SDL_RemoveSurfaceAlternateImages)
// See also: surface_has_alternate_images (SDL_SurfaceHasAlternateImages)
pub fn get_surface_images(surface &Surface, count &int) &&C.SDL_Surface {
	return C.SDL_GetSurfaceImages(surface, count)
}

// C.SDL_RemoveSurfaceAlternateImages [official documentation](https://wiki.libsdl.org/SDL3/SDL_RemoveSurfaceAlternateImages)
fn C.SDL_RemoveSurfaceAlternateImages(surface &Surface)

// remove_surface_alternate_images removes all alternate versions of a surface.
//
// This function removes a reference from all the alternative versions,
// destroying them if this is the last reference to them.
//
// `surface` surface the SDL_Surface structure to update.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_surface_alternate_image (SDL_AddSurfaceAlternateImage)
// See also: get_surface_images (SDL_GetSurfaceImages)
// See also: surface_has_alternate_images (SDL_SurfaceHasAlternateImages)
pub fn remove_surface_alternate_images(surface &Surface) {
	C.SDL_RemoveSurfaceAlternateImages(surface)
}

// C.SDL_LockSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_LockSurface)
fn C.SDL_LockSurface(surface &Surface) bool

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
// `surface` surface the SDL_Surface structure to be locked.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: mustlock (SDL_MUSTLOCK)
// See also: unlock_surface (SDL_UnlockSurface)
pub fn lock_surface(surface &Surface) bool {
	return C.SDL_LockSurface(surface)
}

// C.SDL_UnlockSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnlockSurface)
fn C.SDL_UnlockSurface(surface &Surface)

// unlock_surface releases a surface after directly accessing the pixels.
//
// `surface` surface the SDL_Surface structure to be unlocked.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_surface (SDL_LockSurface)
pub fn unlock_surface(surface &Surface) {
	C.SDL_UnlockSurface(surface)
}

// C.SDL_LoadBMP_IO [official documentation](https://wiki.libsdl.org/SDL3/SDL_LoadBMP_IO)
fn C.SDL_LoadBMP_IO(src &IOStream, closeio bool) &Surface

// load_bmpio loads a BMP image from a seekable SDL data stream.
//
// The new surface should be freed with SDL_DestroySurface(). Not doing so
// will result in a memory leak.
//
// `src` src the data stream for the surface.
// `closeio` closeio if true, calls SDL_CloseIO() on `src` before returning, even
//                in the case of an error.
// returns a pointer to a new SDL_Surface structure or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_surface (SDL_DestroySurface)
// See also: load_bmp (SDL_LoadBMP)
// See also: save_bmpio (SDL_SaveBMP_IO)
pub fn load_bmpio(src &IOStream, closeio bool) &Surface {
	return C.SDL_LoadBMP_IO(src, closeio)
}

// C.SDL_LoadBMP [official documentation](https://wiki.libsdl.org/SDL3/SDL_LoadBMP)
fn C.SDL_LoadBMP(const_file &char) &Surface

// load_bmp loads a BMP image from a file.
//
// The new surface should be freed with SDL_DestroySurface(). Not doing so
// will result in a memory leak.
//
// `file` file the BMP file to load.
// returns a pointer to a new SDL_Surface structure or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_surface (SDL_DestroySurface)
// See also: load_bmpio (SDL_LoadBMP_IO)
// See also: save_bmp (SDL_SaveBMP)
pub fn load_bmp(const_file &char) &Surface {
	return C.SDL_LoadBMP(const_file)
}

// C.SDL_SaveBMP_IO [official documentation](https://wiki.libsdl.org/SDL3/SDL_SaveBMP_IO)
fn C.SDL_SaveBMP_IO(surface &Surface, dst &IOStream, closeio bool) bool

// save_bmpio saves a surface to a seekable SDL data stream in BMP format.
//
// Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
// BMP directly. Other RGB formats with 8-bit or higher get converted to a
// 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
// surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
// not supported.
//
// `surface` surface the SDL_Surface structure containing the image to be saved.
// `dst` dst a data stream to save to.
// `closeio` closeio if true, calls SDL_CloseIO() on `dst` before returning, even
//                in the case of an error.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: load_bmpio (SDL_LoadBMP_IO)
// See also: save_bmp (SDL_SaveBMP)
pub fn save_bmpio(surface &Surface, dst &IOStream, closeio bool) bool {
	return C.SDL_SaveBMP_IO(surface, dst, closeio)
}

// C.SDL_SaveBMP [official documentation](https://wiki.libsdl.org/SDL3/SDL_SaveBMP)
fn C.SDL_SaveBMP(surface &Surface, const_file &char) bool

// save_bmp saves a surface to a file.
//
// Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
// BMP directly. Other RGB formats with 8-bit or higher get converted to a
// 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
// surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
// not supported.
//
// `surface` surface the SDL_Surface structure containing the image to be saved.
// `file` file a file to save to.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: load_bmp (SDL_LoadBMP)
// See also: save_bmpio (SDL_SaveBMP_IO)
pub fn save_bmp(surface &Surface, const_file &char) bool {
	return C.SDL_SaveBMP(surface, const_file)
}

// C.SDL_SetSurfaceRLE [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetSurfaceRLE)
fn C.SDL_SetSurfaceRLE(surface &Surface, enabled bool) bool

// set_surface_rle sets the RLE acceleration hint for a surface.
//
// If RLE is enabled, color key and alpha blending blits are much faster, but
// the surface must be locked before directly accessing the pixels.
//
// `surface` surface the SDL_Surface structure to optimize.
// `enabled` enabled true to enable RLE acceleration, false to disable it.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: blit_surface (SDL_BlitSurface)
// See also: lock_surface (SDL_LockSurface)
// See also: unlock_surface (SDL_UnlockSurface)
pub fn set_surface_rle(surface &Surface, enabled bool) bool {
	return C.SDL_SetSurfaceRLE(surface, enabled)
}

// C.SDL_SurfaceHasRLE [official documentation](https://wiki.libsdl.org/SDL3/SDL_SurfaceHasRLE)
fn C.SDL_SurfaceHasRLE(surface &Surface) bool

// surface_has_rle returns whether the surface is RLE enabled.
//
// It is safe to pass a NULL `surface` here; it will return false.
//
// `surface` surface the SDL_Surface structure to query.
// returns true if the surface is RLE enabled, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_surface_rle (SDL_SetSurfaceRLE)
pub fn surface_has_rle(surface &Surface) bool {
	return C.SDL_SurfaceHasRLE(surface)
}

// C.SDL_SetSurfaceColorKey [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetSurfaceColorKey)
fn C.SDL_SetSurfaceColorKey(surface &Surface, enabled bool, key u32) bool

// set_surface_color_key sets the color key (transparent pixel) in a surface.
//
// The color key defines a pixel value that will be treated as transparent in
// a blit. For example, one can use this to specify that cyan pixels should be
// considered transparent, and therefore not rendered.
//
// It is a pixel of the format used by the surface, as generated by
// SDL_MapRGB().
//
// `surface` surface the SDL_Surface structure to update.
// `enabled` enabled true to enable color key, false to disable color key.
// `key` key the transparent pixel.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_surface_color_key (SDL_GetSurfaceColorKey)
// See also: set_surface_rle (SDL_SetSurfaceRLE)
// See also: surface_has_color_key (SDL_SurfaceHasColorKey)
pub fn set_surface_color_key(surface &Surface, enabled bool, key u32) bool {
	return C.SDL_SetSurfaceColorKey(surface, enabled, key)
}

// C.SDL_SurfaceHasColorKey [official documentation](https://wiki.libsdl.org/SDL3/SDL_SurfaceHasColorKey)
fn C.SDL_SurfaceHasColorKey(surface &Surface) bool

// surface_has_color_key returns whether the surface has a color key.
//
// It is safe to pass a NULL `surface` here; it will return false.
//
// `surface` surface the SDL_Surface structure to query.
// returns true if the surface has a color key, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_surface_color_key (SDL_SetSurfaceColorKey)
// See also: get_surface_color_key (SDL_GetSurfaceColorKey)
pub fn surface_has_color_key(surface &Surface) bool {
	return C.SDL_SurfaceHasColorKey(surface)
}

// C.SDL_GetSurfaceColorKey [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSurfaceColorKey)
fn C.SDL_GetSurfaceColorKey(surface &Surface, key &u32) bool

// get_surface_color_key gets the color key (transparent pixel) for a surface.
//
// The color key is a pixel of the format used by the surface, as generated by
// SDL_MapRGB().
//
// If the surface doesn't have color key enabled this function returns false.
//
// `surface` surface the SDL_Surface structure to query.
// `key` key a pointer filled in with the transparent pixel.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_surface_color_key (SDL_SetSurfaceColorKey)
// See also: surface_has_color_key (SDL_SurfaceHasColorKey)
pub fn get_surface_color_key(surface &Surface, key &u32) bool {
	return C.SDL_GetSurfaceColorKey(surface, key)
}

// C.SDL_SetSurfaceColorMod [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetSurfaceColorMod)
fn C.SDL_SetSurfaceColorMod(surface &Surface, r u8, g u8, b u8) bool

// set_surface_color_mod sets an additional color value multiplied into blit operations.
//
// When this surface is blitted, during the blit operation each source color
// channel is modulated by the appropriate color value according to the
// following formula:
//
// `srcC = srcC * (color / 255)`
//
// `surface` surface the SDL_Surface structure to update.
// `r` r the red color value multiplied into blit operations.
// `g` g the green color value multiplied into blit operations.
// `b` b the blue color value multiplied into blit operations.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_surface_color_mod (SDL_GetSurfaceColorMod)
// See also: set_surface_alpha_mod (SDL_SetSurfaceAlphaMod)
pub fn set_surface_color_mod(surface &Surface, r u8, g u8, b u8) bool {
	return C.SDL_SetSurfaceColorMod(surface, r, g, b)
}

// C.SDL_GetSurfaceColorMod [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSurfaceColorMod)
fn C.SDL_GetSurfaceColorMod(surface &Surface, r &u8, g &u8, b &u8) bool

// get_surface_color_mod gets the additional color value multiplied into blit operations.
//
// `surface` surface the SDL_Surface structure to query.
// `r` r a pointer filled in with the current red color value.
// `g` g a pointer filled in with the current green color value.
// `b` b a pointer filled in with the current blue color value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_surface_alpha_mod (SDL_GetSurfaceAlphaMod)
// See also: set_surface_color_mod (SDL_SetSurfaceColorMod)
pub fn get_surface_color_mod(surface &Surface, r &u8, g &u8, b &u8) bool {
	return C.SDL_GetSurfaceColorMod(surface, r, g, b)
}

// C.SDL_SetSurfaceAlphaMod [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetSurfaceAlphaMod)
fn C.SDL_SetSurfaceAlphaMod(surface &Surface, alpha u8) bool

// set_surface_alpha_mod sets an additional alpha value used in blit operations.
//
// When this surface is blitted, during the blit operation the source alpha
// value is modulated by this alpha value according to the following formula:
//
// `srcA = srcA * (alpha / 255)`
//
// `surface` surface the SDL_Surface structure to update.
// `alpha` alpha the alpha value multiplied into blit operations.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_surface_alpha_mod (SDL_GetSurfaceAlphaMod)
// See also: set_surface_color_mod (SDL_SetSurfaceColorMod)
pub fn set_surface_alpha_mod(surface &Surface, alpha u8) bool {
	return C.SDL_SetSurfaceAlphaMod(surface, alpha)
}

// C.SDL_GetSurfaceAlphaMod [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSurfaceAlphaMod)
fn C.SDL_GetSurfaceAlphaMod(surface &Surface, alpha &u8) bool

// get_surface_alpha_mod gets the additional alpha value used in blit operations.
//
// `surface` surface the SDL_Surface structure to query.
// `alpha` alpha a pointer filled in with the current alpha value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_surface_color_mod (SDL_GetSurfaceColorMod)
// See also: set_surface_alpha_mod (SDL_SetSurfaceAlphaMod)
pub fn get_surface_alpha_mod(surface &Surface, alpha &u8) bool {
	return C.SDL_GetSurfaceAlphaMod(surface, alpha)
}

// C.SDL_SetSurfaceBlendMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetSurfaceBlendMode)
fn C.SDL_SetSurfaceBlendMode(surface &Surface, blend_mode BlendMode) bool

// set_surface_blend_mode sets the blend mode used for blit operations.
//
// To copy a surface to another surface (or texture) without blending with the
// existing data, the blendmode of the SOURCE surface should be set to
// `SDL_BLENDMODE_NONE`.
//
// `surface` surface the SDL_Surface structure to update.
// `blend_mode` blendMode the SDL_BlendMode to use for blit blending.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_surface_blend_mode (SDL_GetSurfaceBlendMode)
pub fn set_surface_blend_mode(surface &Surface, blend_mode BlendMode) bool {
	return C.SDL_SetSurfaceBlendMode(surface, blend_mode)
}

// C.SDL_GetSurfaceBlendMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSurfaceBlendMode)
fn C.SDL_GetSurfaceBlendMode(surface &Surface, blend_mode &BlendMode) bool

// get_surface_blend_mode gets the blend mode used for blit operations.
//
// `surface` surface the SDL_Surface structure to query.
// `blend_mode` blendMode a pointer filled in with the current SDL_BlendMode.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_surface_blend_mode (SDL_SetSurfaceBlendMode)
pub fn get_surface_blend_mode(surface &Surface, blend_mode &BlendMode) bool {
	return C.SDL_GetSurfaceBlendMode(surface, blend_mode)
}

// C.SDL_SetSurfaceClipRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetSurfaceClipRect)
fn C.SDL_SetSurfaceClipRect(surface &Surface, const_rect &Rect) bool

// set_surface_clip_rect sets the clipping rectangle for a surface.
//
// When `surface` is the destination of a blit, only the area within the clip
// rectangle is drawn into.
//
// Note that blits are automatically clipped to the edges of the source and
// destination surfaces.
//
// `surface` surface the SDL_Surface structure to be clipped.
// `rect` rect the SDL_Rect structure representing the clipping rectangle, or
//             NULL to disable clipping.
// returns true if the rectangle intersects the surface, otherwise false and
//          blits will be completely clipped.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_surface_clip_rect (SDL_GetSurfaceClipRect)
pub fn set_surface_clip_rect(surface &Surface, const_rect &Rect) bool {
	return C.SDL_SetSurfaceClipRect(surface, const_rect)
}

// C.SDL_GetSurfaceClipRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSurfaceClipRect)
fn C.SDL_GetSurfaceClipRect(surface &Surface, rect &Rect) bool

// get_surface_clip_rect gets the clipping rectangle for a surface.
//
// When `surface` is the destination of a blit, only the area within the clip
// rectangle is drawn into.
//
// `surface` surface the SDL_Surface structure representing the surface to be
//                clipped.
// `rect` rect an SDL_Rect structure filled in with the clipping rectangle for
//             the surface.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_surface_clip_rect (SDL_SetSurfaceClipRect)
pub fn get_surface_clip_rect(surface &Surface, rect &Rect) bool {
	return C.SDL_GetSurfaceClipRect(surface, rect)
}

// C.SDL_FlipSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_FlipSurface)
fn C.SDL_FlipSurface(surface &Surface, flip FlipMode) bool

// flip_surface flips a surface vertically or horizontally.
//
// `surface` surface the surface to flip.
// `flip` flip the direction to flip.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn flip_surface(surface &Surface, flip FlipMode) bool {
	return C.SDL_FlipSurface(surface, flip)
}

// C.SDL_DuplicateSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_DuplicateSurface)
fn C.SDL_DuplicateSurface(surface &Surface) &Surface

// duplicate_surface creates a new surface identical to the existing surface.
//
// If the original surface has alternate images, the new surface will have a
// reference to them as well.
//
// The returned surface should be freed with SDL_DestroySurface().
//
// `surface` surface the surface to duplicate.
// returns a copy of the surface or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_surface (SDL_DestroySurface)
pub fn duplicate_surface(surface &Surface) &Surface {
	return C.SDL_DuplicateSurface(surface)
}

// C.SDL_ScaleSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_ScaleSurface)
fn C.SDL_ScaleSurface(surface &Surface, width int, height int, scale_mode ScaleMode) &Surface

// scale_surface creates a new surface identical to the existing surface, scaled to the
// desired size.
//
// The returned surface should be freed with SDL_DestroySurface().
//
// `surface` surface the surface to duplicate and scale.
// `width` width the width of the new surface.
// `height` height the height of the new surface.
// `scale_mode` scaleMode the SDL_ScaleMode to be used.
// returns a copy of the surface or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_surface (SDL_DestroySurface)
pub fn scale_surface(surface &Surface, width int, height int, scale_mode ScaleMode) &Surface {
	return C.SDL_ScaleSurface(surface, width, height, scale_mode)
}

// C.SDL_ConvertSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_ConvertSurface)
fn C.SDL_ConvertSurface(surface &Surface, format PixelFormat) &Surface

// convert_surface copys an existing surface to a new surface of the specified format.
//
// This function is used to optimize images for faster *repeat* blitting. This
// is accomplished by converting the original and storing the result as a new
// surface. The new, optimized surface can then be used as the source for
// future blits, making them faster.
//
// If you are converting to an indexed surface and want to map colors to a
// palette, you can use SDL_ConvertSurfaceAndColorspace() instead.
//
// If the original surface has alternate images, the new surface will have a
// reference to them as well.
//
// `surface` surface the existing SDL_Surface structure to convert.
// `format` format the new pixel format.
// returns the new SDL_Surface structure that is created or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: convert_surface_and_colorspace (SDL_ConvertSurfaceAndColorspace)
// See also: destroy_surface (SDL_DestroySurface)
pub fn convert_surface(surface &Surface, format PixelFormat) &Surface {
	return C.SDL_ConvertSurface(surface, format)
}

// C.SDL_ConvertSurfaceAndColorspace [official documentation](https://wiki.libsdl.org/SDL3/SDL_ConvertSurfaceAndColorspace)
fn C.SDL_ConvertSurfaceAndColorspace(surface &Surface, format PixelFormat, palette &Palette, colorspace Colorspace, props PropertiesID) &Surface

// convert_surface_and_colorspace copys an existing surface to a new surface of the specified format and
// colorspace.
//
// This function converts an existing surface to a new format and colorspace
// and returns the new surface. This will perform any pixel format and
// colorspace conversion needed.
//
// If the original surface has alternate images, the new surface will have a
// reference to them as well.
//
// `surface` surface the existing SDL_Surface structure to convert.
// `format` format the new pixel format.
// `palette` palette an optional palette to use for indexed formats, may be NULL.
// `colorspace` colorspace the new colorspace.
// `props` props an SDL_PropertiesID with additional color properties, or 0.
// returns the new SDL_Surface structure that is created or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: convert_surface (SDL_ConvertSurface)
// See also: destroy_surface (SDL_DestroySurface)
pub fn convert_surface_and_colorspace(surface &Surface, format PixelFormat, palette &Palette, colorspace Colorspace, props PropertiesID) &Surface {
	return C.SDL_ConvertSurfaceAndColorspace(surface, format, palette, colorspace, props)
}

// C.SDL_ConvertPixels [official documentation](https://wiki.libsdl.org/SDL3/SDL_ConvertPixels)
fn C.SDL_ConvertPixels(width int, height int, src_format PixelFormat, const_src voidptr, src_pitch int, dst_format PixelFormat, dst voidptr, dst_pitch int) bool

// convert_pixels copys a block of pixels of one format to another format.
//
// `width` width the width of the block to copy, in pixels.
// `height` height the height of the block to copy, in pixels.
// `src_format` src_format an SDL_PixelFormat value of the `src` pixels format.
// `src` src a pointer to the source pixels.
// `src_pitch` src_pitch the pitch of the source pixels, in bytes.
// `dst_format` dst_format an SDL_PixelFormat value of the `dst` pixels format.
// `dst` dst a pointer to be filled in with new pixel data.
// `dst_pitch` dst_pitch the pitch of the destination pixels, in bytes.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: convert_pixels_and_colorspace (SDL_ConvertPixelsAndColorspace)
pub fn convert_pixels(width int, height int, src_format PixelFormat, const_src voidptr, src_pitch int, dst_format PixelFormat, dst voidptr, dst_pitch int) bool {
	return C.SDL_ConvertPixels(width, height, src_format, const_src, src_pitch, dst_format,
		dst, dst_pitch)
}

// C.SDL_ConvertPixelsAndColorspace [official documentation](https://wiki.libsdl.org/SDL3/SDL_ConvertPixelsAndColorspace)
fn C.SDL_ConvertPixelsAndColorspace(width int, height int, src_format PixelFormat, src_colorspace Colorspace, src_properties PropertiesID, const_src voidptr, src_pitch int, dst_format PixelFormat, dst_colorspace Colorspace, dst_properties PropertiesID, dst voidptr, dst_pitch int) bool

// convert_pixels_and_colorspace copys a block of pixels of one format and colorspace to another format and
// colorspace.
//
// `width` width the width of the block to copy, in pixels.
// `height` height the height of the block to copy, in pixels.
// `src_format` src_format an SDL_PixelFormat value of the `src` pixels format.
// `src_colorspace` src_colorspace an SDL_Colorspace value describing the colorspace of
//                       the `src` pixels.
// `src_properties` src_properties an SDL_PropertiesID with additional source color
//                       properties, or 0.
// `src` src a pointer to the source pixels.
// `src_pitch` src_pitch the pitch of the source pixels, in bytes.
// `dst_format` dst_format an SDL_PixelFormat value of the `dst` pixels format.
// `dst_colorspace` dst_colorspace an SDL_Colorspace value describing the colorspace of
//                       the `dst` pixels.
// `dst_properties` dst_properties an SDL_PropertiesID with additional destination color
//                       properties, or 0.
// `dst` dst a pointer to be filled in with new pixel data.
// `dst_pitch` dst_pitch the pitch of the destination pixels, in bytes.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: convert_pixels (SDL_ConvertPixels)
pub fn convert_pixels_and_colorspace(width int, height int, src_format PixelFormat, src_colorspace Colorspace, src_properties PropertiesID, const_src voidptr, src_pitch int, dst_format PixelFormat, dst_colorspace Colorspace, dst_properties PropertiesID, dst voidptr, dst_pitch int) bool {
	return C.SDL_ConvertPixelsAndColorspace(width, height, src_format, src_colorspace,
		src_properties, const_src, src_pitch, dst_format, dst_colorspace, dst_properties,
		dst, dst_pitch)
}

// C.SDL_PremultiplyAlpha [official documentation](https://wiki.libsdl.org/SDL3/SDL_PremultiplyAlpha)
fn C.SDL_PremultiplyAlpha(width int, height int, src_format PixelFormat, const_src voidptr, src_pitch int, dst_format PixelFormat, dst voidptr, dst_pitch int, linear bool) bool

// premultiply_alpha premultiplys the alpha on a block of pixels.
//
// This is safe to use with src == dst, but not for other overlapping areas.
//
// `width` width the width of the block to convert, in pixels.
// `height` height the height of the block to convert, in pixels.
// `src_format` src_format an SDL_PixelFormat value of the `src` pixels format.
// `src` src a pointer to the source pixels.
// `src_pitch` src_pitch the pitch of the source pixels, in bytes.
// `dst_format` dst_format an SDL_PixelFormat value of the `dst` pixels format.
// `dst` dst a pointer to be filled in with premultiplied pixel data.
// `dst_pitch` dst_pitch the pitch of the destination pixels, in bytes.
// `linear` linear true to convert from sRGB to linear space for the alpha
//               multiplication, false to do multiplication in sRGB space.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn premultiply_alpha(width int, height int, src_format PixelFormat, const_src voidptr, src_pitch int, dst_format PixelFormat, dst voidptr, dst_pitch int, linear bool) bool {
	return C.SDL_PremultiplyAlpha(width, height, src_format, const_src, src_pitch, dst_format,
		dst, dst_pitch, linear)
}

// C.SDL_PremultiplySurfaceAlpha [official documentation](https://wiki.libsdl.org/SDL3/SDL_PremultiplySurfaceAlpha)
fn C.SDL_PremultiplySurfaceAlpha(surface &Surface, linear bool) bool

// premultiply_surface_alpha premultiplys the alpha in a surface.
//
// This is safe to use with src == dst, but not for other overlapping areas.
//
// `surface` surface the surface to modify.
// `linear` linear true to convert from sRGB to linear space for the alpha
//               multiplication, false to do multiplication in sRGB space.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn premultiply_surface_alpha(surface &Surface, linear bool) bool {
	return C.SDL_PremultiplySurfaceAlpha(surface, linear)
}

// C.SDL_ClearSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_ClearSurface)
fn C.SDL_ClearSurface(surface &Surface, r f32, g f32, b f32, a f32) bool

// clear_surface clears a surface with a specific color, with floating point precision.
//
// This function handles all surface formats, and ignores any clip rectangle.
//
// If the surface is YUV, the color is assumed to be in the sRGB colorspace,
// otherwise the color is assumed to be in the colorspace of the suface.
//
// `surface` surface the SDL_Surface to clear.
// `r` r the red component of the pixel, normally in the range 0-1.
// `g` g the green component of the pixel, normally in the range 0-1.
// `b` b the blue component of the pixel, normally in the range 0-1.
// `a` a the alpha component of the pixel, normally in the range 0-1.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn clear_surface(surface &Surface, r f32, g f32, b f32, a f32) bool {
	return C.SDL_ClearSurface(surface, r, g, b, a)
}

// C.SDL_FillSurfaceRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_FillSurfaceRect)
fn C.SDL_FillSurfaceRect(dst &Surface, const_rect &Rect, color u32) bool

// fill_surface_rect performs a fast fill of a rectangle with a specific color.
//
// `color` should be a pixel of the format used by the surface, and can be
// generated by SDL_MapRGB() or SDL_MapRGBA(). If the color value contains an
// alpha component then the destination is simply filled with that alpha
// information, no blending takes place.
//
// If there is a clip rectangle set on the destination (set via
// SDL_SetSurfaceClipRect()), then this function will fill based on the
// intersection of the clip rectangle and `rect`.
//
// `dst` dst the SDL_Surface structure that is the drawing target.
// `rect` rect the SDL_Rect structure representing the rectangle to fill, or
//             NULL to fill the entire surface.
// `color` color the color to fill with.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: fill_surface_rects (SDL_FillSurfaceRects)
pub fn fill_surface_rect(dst &Surface, const_rect &Rect, color u32) bool {
	return C.SDL_FillSurfaceRect(dst, const_rect, color)
}

// C.SDL_FillSurfaceRects [official documentation](https://wiki.libsdl.org/SDL3/SDL_FillSurfaceRects)
fn C.SDL_FillSurfaceRects(dst &Surface, const_rects &Rect, count int, color u32) bool

// fill_surface_rects performs a fast fill of a set of rectangles with a specific color.
//
// `color` should be a pixel of the format used by the surface, and can be
// generated by SDL_MapRGB() or SDL_MapRGBA(). If the color value contains an
// alpha component then the destination is simply filled with that alpha
// information, no blending takes place.
//
// If there is a clip rectangle set on the destination (set via
// SDL_SetSurfaceClipRect()), then this function will fill based on the
// intersection of the clip rectangle and `rect`.
//
// `dst` dst the SDL_Surface structure that is the drawing target.
// `rects` rects an array of SDL_Rects representing the rectangles to fill.
// `count` count the number of rectangles in the array.
// `color` color the color to fill with.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: fill_surface_rect (SDL_FillSurfaceRect)
pub fn fill_surface_rects(dst &Surface, const_rects &Rect, count int, color u32) bool {
	return C.SDL_FillSurfaceRects(dst, const_rects, count, color)
}

// C.SDL_BlitSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_BlitSurface)
fn C.SDL_BlitSurface(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect) bool

// blit_surface performs a fast blit from the source surface to the destination surface
// with clipping.
//
// If either `srcrect` or `dstrect` are NULL, the entire surface (`src` or
// `dst`) is copied while ensuring clipping to `dst->clip_rect`.
//
// The final blit rectangles are saved in `srcrect` and `dstrect` after all
// clipping is performed.
//
// The blit function should not be called on a locked surface.
//
// The blit semantics for surfaces with and without blending and colorkey are
// defined as follows:
//
// ```
//    RGBA->RGB:
//      Source surface blend mode set to SDL_BLENDMODE_BLEND:
//       alpha-blend (using the source alpha-channel and per-surface alpha)
//       SDL_SRCCOLORKEY ignored.
//     Source surface blend mode set to SDL_BLENDMODE_NONE:
//       copy RGB.
//       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
//       RGB values of the source color key, ignoring alpha in the
//       comparison.
//
//   RGB->RGBA:
//     Source surface blend mode set to SDL_BLENDMODE_BLEND:
//       alpha-blend (using the source per-surface alpha)
//     Source surface blend mode set to SDL_BLENDMODE_NONE:
//       copy RGB, set destination alpha to source per-surface alpha value.
//     both:
//       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
//       source color key.
//
//   RGBA->RGBA:
//     Source surface blend mode set to SDL_BLENDMODE_BLEND:
//       alpha-blend (using the source alpha-channel and per-surface alpha)
//       SDL_SRCCOLORKEY ignored.
//     Source surface blend mode set to SDL_BLENDMODE_NONE:
//       copy all of RGBA to the destination.
//       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
//       RGB values of the source color key, ignoring alpha in the
//       comparison.
//
//   RGB->RGB:
//     Source surface blend mode set to SDL_BLENDMODE_BLEND:
//       alpha-blend (using the source per-surface alpha)
//     Source surface blend mode set to SDL_BLENDMODE_NONE:
//       copy RGB.
//     both:
//       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
//       source color key.
// ```
//
// `src` src the SDL_Surface structure to be copied from.
// `srcrect` srcrect the SDL_Rect structure representing the rectangle to be
//                copied, or NULL to copy the entire surface.
// `dst` dst the SDL_Surface structure that is the blit target.
// `dstrect` dstrect the SDL_Rect structure representing the x and y position in
//                the destination surface, or NULL for (0,0). The width and
//                height are ignored, and are copied from `srcrect`. If you
//                want a specific width and height, you should use
//                SDL_BlitSurfaceScaled().
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) The same destination surface should not be used from two
//               threads at once. It is safe to use the same source surface
//               from multiple threads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: blit_surface_scaled (SDL_BlitSurfaceScaled)
pub fn blit_surface(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect) bool {
	return C.SDL_BlitSurface(src, const_srcrect, dst, const_dstrect)
}

// C.SDL_BlitSurfaceUnchecked [official documentation](https://wiki.libsdl.org/SDL3/SDL_BlitSurfaceUnchecked)
fn C.SDL_BlitSurfaceUnchecked(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect) bool

// blit_surface_unchecked performs low-level surface blitting only.
//
// This is a semi-private blit function and it performs low-level surface
// blitting, assuming the input rectangles have already been clipped.
//
// `src` src the SDL_Surface structure to be copied from.
// `srcrect` srcrect the SDL_Rect structure representing the rectangle to be
//                copied, may not be NULL.
// `dst` dst the SDL_Surface structure that is the blit target.
// `dstrect` dstrect the SDL_Rect structure representing the target rectangle in
//                the destination surface, may not be NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) The same destination surface should not be used from two
//               threads at once. It is safe to use the same source surface
//               from multiple threads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: blit_surface (SDL_BlitSurface)
pub fn blit_surface_unchecked(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect) bool {
	return C.SDL_BlitSurfaceUnchecked(src, const_srcrect, dst, const_dstrect)
}

// C.SDL_BlitSurfaceScaled [official documentation](https://wiki.libsdl.org/SDL3/SDL_BlitSurfaceScaled)
fn C.SDL_BlitSurfaceScaled(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect, scale_mode ScaleMode) bool

// blit_surface_scaled performs a scaled blit to a destination surface, which may be of a different
// format.
//
// `src` src the SDL_Surface structure to be copied from.
// `srcrect` srcrect the SDL_Rect structure representing the rectangle to be
//                copied, or NULL to copy the entire surface.
// `dst` dst the SDL_Surface structure that is the blit target.
// `dstrect` dstrect the SDL_Rect structure representing the target rectangle in
//                the destination surface, or NULL to fill the entire
//                destination surface.
// `scale_mode` scaleMode the SDL_ScaleMode to be used.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) The same destination surface should not be used from two
//               threads at once. It is safe to use the same source surface
//               from multiple threads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: blit_surface (SDL_BlitSurface)
pub fn blit_surface_scaled(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect, scale_mode ScaleMode) bool {
	return C.SDL_BlitSurfaceScaled(src, const_srcrect, dst, const_dstrect, scale_mode)
}

// C.SDL_BlitSurfaceUncheckedScaled [official documentation](https://wiki.libsdl.org/SDL3/SDL_BlitSurfaceUncheckedScaled)
fn C.SDL_BlitSurfaceUncheckedScaled(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect, scale_mode ScaleMode) bool

// blit_surface_unchecked_scaled performs low-level surface scaled blitting only.
//
// This is a semi-private function and it performs low-level surface blitting,
// assuming the input rectangles have already been clipped.
//
// `src` src the SDL_Surface structure to be copied from.
// `srcrect` srcrect the SDL_Rect structure representing the rectangle to be
//                copied, may not be NULL.
// `dst` dst the SDL_Surface structure that is the blit target.
// `dstrect` dstrect the SDL_Rect structure representing the target rectangle in
//                the destination surface, may not be NULL.
// `scale_mode` scaleMode the SDL_ScaleMode to be used.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) The same destination surface should not be used from two
//               threads at once. It is safe to use the same source surface
//               from multiple threads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: blit_surface_scaled (SDL_BlitSurfaceScaled)
pub fn blit_surface_unchecked_scaled(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect, scale_mode ScaleMode) bool {
	return C.SDL_BlitSurfaceUncheckedScaled(src, const_srcrect, dst, const_dstrect, scale_mode)
}

// C.SDL_BlitSurfaceTiled [official documentation](https://wiki.libsdl.org/SDL3/SDL_BlitSurfaceTiled)
fn C.SDL_BlitSurfaceTiled(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect) bool

// blit_surface_tiled performs a tiled blit to a destination surface, which may be of a different
// format.
//
// The pixels in `srcrect` will be repeated as many times as needed to
// completely fill `dstrect`.
//
// `src` src the SDL_Surface structure to be copied from.
// `srcrect` srcrect the SDL_Rect structure representing the rectangle to be
//                copied, or NULL to copy the entire surface.
// `dst` dst the SDL_Surface structure that is the blit target.
// `dstrect` dstrect the SDL_Rect structure representing the target rectangle in
//                the destination surface, or NULL to fill the entire surface.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) The same destination surface should not be used from two
//               threads at once. It is safe to use the same source surface
//               from multiple threads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: blit_surface (SDL_BlitSurface)
pub fn blit_surface_tiled(src &Surface, const_srcrect &Rect, dst &Surface, const_dstrect &Rect) bool {
	return C.SDL_BlitSurfaceTiled(src, const_srcrect, dst, const_dstrect)
}

// C.SDL_BlitSurfaceTiledWithScale [official documentation](https://wiki.libsdl.org/SDL3/SDL_BlitSurfaceTiledWithScale)
fn C.SDL_BlitSurfaceTiledWithScale(src &Surface, const_srcrect &Rect, scale f32, scale_mode ScaleMode, dst &Surface, const_dstrect &Rect) bool

// blit_surface_tiled_with_scale performs a scaled and tiled blit to a destination surface, which may be of a
// different format.
//
// The pixels in `srcrect` will be scaled and repeated as many times as needed
// to completely fill `dstrect`.
//
// `src` src the SDL_Surface structure to be copied from.
// `srcrect` srcrect the SDL_Rect structure representing the rectangle to be
//                copied, or NULL to copy the entire surface.
// `scale` scale the scale used to transform srcrect into the destination
//              rectangle, e.g. a 32x32 texture with a scale of 2 would fill
//              64x64 tiles.
// `scale_mode` scaleMode scale algorithm to be used.
// `dst` dst the SDL_Surface structure that is the blit target.
// `dstrect` dstrect the SDL_Rect structure representing the target rectangle in
//                the destination surface, or NULL to fill the entire surface.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) The same destination surface should not be used from two
//               threads at once. It is safe to use the same source surface
//               from multiple threads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: blit_surface (SDL_BlitSurface)
pub fn blit_surface_tiled_with_scale(src &Surface, const_srcrect &Rect, scale f32, scale_mode ScaleMode, dst &Surface, const_dstrect &Rect) bool {
	return C.SDL_BlitSurfaceTiledWithScale(src, const_srcrect, scale, scale_mode, dst,
		const_dstrect)
}

// C.SDL_BlitSurface9Grid [official documentation](https://wiki.libsdl.org/SDL3/SDL_BlitSurface9Grid)
fn C.SDL_BlitSurface9Grid(src &Surface, const_srcrect &Rect, left_width int, right_width int, top_height int, bottom_height int, scale f32, scale_mode ScaleMode, dst &Surface, const_dstrect &Rect) bool

// blit_surface9_grid performs a scaled blit using the 9-grid algorithm to a destination surface,
// which may be of a different format.
//
// The pixels in the source surface are split into a 3x3 grid, using the
// different corner sizes for each corner, and the sides and center making up
// the remaining pixels. The corners are then scaled using `scale` and fit
// into the corners of the destination rectangle. The sides and center are
// then stretched into place to cover the remaining destination rectangle.
//
// `src` src the SDL_Surface structure to be copied from.
// `srcrect` srcrect the SDL_Rect structure representing the rectangle to be used
//                for the 9-grid, or NULL to use the entire surface.
// `left_width` left_width the width, in pixels, of the left corners in `srcrect`.
// `right_width` right_width the width, in pixels, of the right corners in `srcrect`.
// `top_height` top_height the height, in pixels, of the top corners in `srcrect`.
// `bottom_height` bottom_height the height, in pixels, of the bottom corners in
//                      `srcrect`.
// `scale` scale the scale used to transform the corner of `srcrect` into the
//              corner of `dstrect`, or 0.0f for an unscaled blit.
// `scale_mode` scaleMode scale algorithm to be used.
// `dst` dst the SDL_Surface structure that is the blit target.
// `dstrect` dstrect the SDL_Rect structure representing the target rectangle in
//                the destination surface, or NULL to fill the entire surface.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) The same destination surface should not be used from two
//               threads at once. It is safe to use the same source surface
//               from multiple threads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: blit_surface (SDL_BlitSurface)
pub fn blit_surface9_grid(src &Surface, const_srcrect &Rect, left_width int, right_width int, top_height int, bottom_height int, scale f32, scale_mode ScaleMode, dst &Surface, const_dstrect &Rect) bool {
	return C.SDL_BlitSurface9Grid(src, const_srcrect, left_width, right_width, top_height,
		bottom_height, scale, scale_mode, dst, const_dstrect)
}

// C.SDL_MapSurfaceRGB [official documentation](https://wiki.libsdl.org/SDL3/SDL_MapSurfaceRGB)
fn C.SDL_MapSurfaceRGB(surface &Surface, r u8, g u8, b u8) u32

// map_surface_rgb maps an RGB triple to an opaque pixel value for a surface.
//
// This function maps the RGB color value to the specified pixel format and
// returns the pixel value best approximating the given RGB color value for
// the given pixel format.
//
// If the surface has a palette, the index of the closest matching color in
// the palette will be returned.
//
// If the surface pixel format has an alpha component it will be returned as
// all 1 bits (fully opaque).
//
// If the pixel format bpp (color depth) is less than 32-bpp then the unused
// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
// format the return value can be assigned to a Uint16, and similarly a Uint8
// for an 8-bpp format).
//
// `surface` surface the surface to use for the pixel format and palette.
// `r` r the red component of the pixel in the range 0-255.
// `g` g the green component of the pixel in the range 0-255.
// `b` b the blue component of the pixel in the range 0-255.
// returns a pixel value.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: map_surface_rgba (SDL_MapSurfaceRGBA)
pub fn map_surface_rgb(surface &Surface, r u8, g u8, b u8) u32 {
	return C.SDL_MapSurfaceRGB(surface, r, g, b)
}

// C.SDL_MapSurfaceRGBA [official documentation](https://wiki.libsdl.org/SDL3/SDL_MapSurfaceRGBA)
fn C.SDL_MapSurfaceRGBA(surface &Surface, r u8, g u8, b u8, a u8) u32

// map_surface_rgba maps an RGBA quadruple to a pixel value for a surface.
//
// This function maps the RGBA color value to the specified pixel format and
// returns the pixel value best approximating the given RGBA color value for
// the given pixel format.
//
// If the surface pixel format has no alpha component the alpha value will be
// ignored (as it will be in formats with a palette).
//
// If the surface has a palette, the index of the closest matching color in
// the palette will be returned.
//
// If the pixel format bpp (color depth) is less than 32-bpp then the unused
// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
// format the return value can be assigned to a Uint16, and similarly a Uint8
// for an 8-bpp format).
//
// `surface` surface the surface to use for the pixel format and palette.
// `r` r the red component of the pixel in the range 0-255.
// `g` g the green component of the pixel in the range 0-255.
// `b` b the blue component of the pixel in the range 0-255.
// `a` a the alpha component of the pixel in the range 0-255.
// returns a pixel value.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: map_surface_rgb (SDL_MapSurfaceRGB)
pub fn map_surface_rgba(surface &Surface, r u8, g u8, b u8, a u8) u32 {
	return C.SDL_MapSurfaceRGBA(surface, r, g, b, a)
}

// C.SDL_ReadSurfacePixel [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadSurfacePixel)
fn C.SDL_ReadSurfacePixel(surface &Surface, x int, y int, r &u8, g &u8, b &u8, a &u8) bool

// read_surface_pixel retrieves a single pixel from a surface.
//
// This function prioritizes correctness over speed: it is suitable for unit
// tests, but is not intended for use in a game engine.
//
// Like SDL_GetRGBA, this uses the entire 0..255 range when converting color
// components from pixel formats with less than 8 bits per RGB component.
//
// `surface` surface the surface to read.
// `x` x the horizontal coordinate, 0 <= x < width.
// `y` y the vertical coordinate, 0 <= y < height.
// `r` r a pointer filled in with the red channel, 0-255, or NULL to ignore
//          this channel.
// `g` g a pointer filled in with the green channel, 0-255, or NULL to
//          ignore this channel.
// `b` b a pointer filled in with the blue channel, 0-255, or NULL to
//          ignore this channel.
// `a` a a pointer filled in with the alpha channel, 0-255, or NULL to
//          ignore this channel.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_surface_pixel(surface &Surface, x int, y int, r &u8, g &u8, b &u8, a &u8) bool {
	return C.SDL_ReadSurfacePixel(surface, x, y, r, g, b, a)
}

// C.SDL_ReadSurfacePixelFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadSurfacePixelFloat)
fn C.SDL_ReadSurfacePixelFloat(surface &Surface, x int, y int, r &f32, g &f32, b &f32, a &f32) bool

// read_surface_pixel_float retrieves a single pixel from a surface.
//
// This function prioritizes correctness over speed: it is suitable for unit
// tests, but is not intended for use in a game engine.
//
// `surface` surface the surface to read.
// `x` x the horizontal coordinate, 0 <= x < width.
// `y` y the vertical coordinate, 0 <= y < height.
// `r` r a pointer filled in with the red channel, normally in the range
//          0-1, or NULL to ignore this channel.
// `g` g a pointer filled in with the green channel, normally in the range
//          0-1, or NULL to ignore this channel.
// `b` b a pointer filled in with the blue channel, normally in the range
//          0-1, or NULL to ignore this channel.
// `a` a a pointer filled in with the alpha channel, normally in the range
//          0-1, or NULL to ignore this channel.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn read_surface_pixel_float(surface &Surface, x int, y int, r &f32, g &f32, b &f32, a &f32) bool {
	return C.SDL_ReadSurfacePixelFloat(surface, x, y, r, g, b, a)
}

// C.SDL_WriteSurfacePixel [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteSurfacePixel)
fn C.SDL_WriteSurfacePixel(surface &Surface, x int, y int, r u8, g u8, b u8, a u8) bool

// write_surface_pixel writes a single pixel to a surface.
//
// This function prioritizes correctness over speed: it is suitable for unit
// tests, but is not intended for use in a game engine.
//
// Like SDL_MapRGBA, this uses the entire 0..255 range when converting color
// components from pixel formats with less than 8 bits per RGB component.
//
// `surface` surface the surface to write.
// `x` x the horizontal coordinate, 0 <= x < width.
// `y` y the vertical coordinate, 0 <= y < height.
// `r` r the red channel value, 0-255.
// `g` g the green channel value, 0-255.
// `b` b the blue channel value, 0-255.
// `a` a the alpha channel value, 0-255.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_surface_pixel(surface &Surface, x int, y int, r u8, g u8, b u8, a u8) bool {
	return C.SDL_WriteSurfacePixel(surface, x, y, r, g, b, a)
}

// C.SDL_WriteSurfacePixelFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_WriteSurfacePixelFloat)
fn C.SDL_WriteSurfacePixelFloat(surface &Surface, x int, y int, r f32, g f32, b f32, a f32) bool

// write_surface_pixel_float writes a single pixel to a surface.
//
// This function prioritizes correctness over speed: it is suitable for unit
// tests, but is not intended for use in a game engine.
//
// `surface` surface the surface to write.
// `x` x the horizontal coordinate, 0 <= x < width.
// `y` y the vertical coordinate, 0 <= y < height.
// `r` r the red channel value, normally in the range 0-1.
// `g` g the green channel value, normally in the range 0-1.
// `b` b the blue channel value, normally in the range 0-1.
// `a` a the alpha channel value, normally in the range 0-1.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn write_surface_pixel_float(surface &Surface, x int, y int, r f32, g f32, b f32, a f32) bool {
	return C.SDL_WriteSurfacePixelFloat(surface, x, y, r, g, b, a)
}
