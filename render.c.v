// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_render.h
//
// The API supports the following features:
//     * single pixel points
//     * single pixel lines
//     * filled rectangles
//     * texture images
//
// The primitives may be drawn in opaque, blended, or additive modes.
//
// The texture images may be drawn in opaque, blended, or additive modes.
// They can have an additional color tint or alpha modulation applied to
// them, and may also be stretched with linear interpolation.
//
// The API is designed to accelerate simple 2D operations. You may
// want more functionality such as polygons and particle effects and
// in that case you should use SDL's OpenGL/Direct3D support or one
// of the many good 3D engines.
//
// These functions must be called from the main thread.
// See this bug for details: http://bugzilla.libsdl.org/show_bug.cgi?id=1995

// RendererFlags is C.SDL_RendererFlags
pub enum RendererFlags {
	software      = C.SDL_RENDERER_SOFTWARE // 0x00000001 The renderer is a software fallback
	accelerated   = C.SDL_RENDERER_ACCELERATED // 0x00000002 The renderer uses hardware acceleration
	presentvsync  = C.SDL_RENDERER_PRESENTVSYNC // 0x00000004 Present is synchronized with the refresh rate
	targettexture = C.SDL_RENDERER_TARGETTEXTURE // 0x00000008
}

@[typedef]
pub struct C.SDL_RendererInfo {
pub:
	name                &char   // The name of the renderer
	flags               u32     // Supported ::SDL_RendererFlags
	num_texture_formats u32     // The number of available texture formats
	texture_formats     [16]u32 // The available texture formats
	max_texture_width   int     // The maximum texture width
	max_texture_height  int     // The maximum texture height
}

pub type RendererInfo = C.SDL_RendererInfo

@[typedef]
pub struct C.SDL_Vertex {
	position  FPoint // Vertex position, in SDL_Renderer coordinates
	color     Color  // Vertex color
	tex_coord FPoint // Normalized texture coordinates, if needed
}

// Vertex structure
// Vertex is C.SDL_Vertex
pub type Vertex = C.SDL_Vertex

// The scaling mode for a texture.
// ScaleMode is C.SDL_ScaleMode
pub enum ScaleMode {
	nearest = C.SDL_ScaleModeNearest // nearest pixel sampling
	linear  = C.SDL_ScaleModeLinear // linear filtering
	best    = C.SDL_ScaleModeBest // anisotropic filtering
}

// TextureAccess is C.SDL_TextureAccess
pub enum TextureAccess {
	@static   = C.SDL_TEXTUREACCESS_STATIC // Changes rarely, not lockable
	streaming = C.SDL_TEXTUREACCESS_STREAMING // Changes frequently, lockable
	target    = C.SDL_TEXTUREACCESS_TARGET // Texture can be used as a render target
}

// TextureModulate is C.SDL_TextureModulate
pub enum TextureModulate {
	@none = C.SDL_TEXTUREMODULATE_NONE // 0x00000000  No modulation
	color = C.SDL_TEXTUREMODULATE_COLOR // 0x00000001 srcC = srcC * color
	alpha = C.SDL_TEXTUREMODULATE_ALPHA // 0x00000002  srcA = srcA * alpha
}

// RendererFlip is C.SDL_RendererFlip
pub enum RendererFlip {
	@none      = C.SDL_FLIP_NONE // 0x00000000 Do not flip
	horizontal = C.SDL_FLIP_HORIZONTAL // 0x00000001 flip horizontally
	vertical   = C.SDL_FLIP_VERTICAL // 0x00000002  flip vertically
}

@[typedef]
pub struct C.SDL_Renderer {
}

pub type Renderer = C.SDL_Renderer

@[typedef]
pub struct C.SDL_Texture {
}

pub type Texture = C.SDL_Texture

fn C.SDL_GetNumRenderDrivers() int

// get_num_render_drivers gets the number of 2D rendering drivers available for the current display.
//
// A render driver is a set of code that handles rendering and texture
// management on a particular display. Normally there is only one, but some
// drivers may have several available with different capabilities.
//
// There may be none if SDL was compiled without render support.
//
// returns a number >= 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateRenderer
// See also: SDL_GetRenderDriverInfo
pub fn get_num_render_drivers() int {
	return C.SDL_GetNumRenderDrivers()
}

fn C.SDL_GetRenderDriverInfo(index int, info &C.SDL_RendererInfo) int

// get_render_driver_info gets info about a specific 2D rendering driver for the current display.
//
// `index` the index of the driver to query information about
// `info` an SDL_RendererInfo structure to be filled with information on
//             the rendering driver
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateRenderer
// See also: SDL_GetNumRenderDrivers
pub fn get_render_driver_info(index int, info &RendererInfo) int {
	return C.SDL_GetRenderDriverInfo(index, info)
}

fn C.SDL_CreateWindowAndRenderer(width int, height int, window_flags u32, window &&C.SDL_Window, renderer &&C.SDL_Renderer) int

// create_window_and_renderer creates a window and default renderer.
//
// `width` the width of the window
// `height` the height of the window
// `window_flags` the flags used to create the window (see
//                     SDL_CreateWindow())
// `window` a pointer filled with the window, or NULL on error
// `renderer` a pointer filled with the renderer, or NULL on error
// returns 0 on success, or -1 on error; call SDL_GetError() for more
//          information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateRenderer
// See also: SDL_CreateWindow
pub fn create_window_and_renderer(width int, height int, window_flags u32, window &&Window, renderer &&Renderer) int {
	return C.SDL_CreateWindowAndRenderer(width, height, window_flags, window, renderer)
}

fn C.SDL_CreateRenderer(window &C.SDL_Window, index int, flags u32) &C.SDL_Renderer

// create_renderer creates a 2D rendering context for a window.
//
// `window` the window where rendering is displayed
// `index` the index of the rendering driver to initialize, or -1 to
//              initialize the first one supporting the requested flags
// `flags` 0, or one or more SDL_RendererFlags OR'd together
// returns a valid rendering context or NULL if there was an error; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateSoftwareRenderer
// See also: SDL_DestroyRenderer
// See also: SDL_GetNumRenderDrivers
// See also: SDL_GetRendererInfo
pub fn create_renderer(window &Window, index int, flags u32) &Renderer {
	return C.SDL_CreateRenderer(window, index, flags)
}

fn C.SDL_CreateSoftwareRenderer(surface &C.SDL_Surface) &C.SDL_Renderer

// create_software_renderer creates a 2D software rendering context for a surface.
//
// Two other API which can be used to create SDL_Renderer:
// SDL_CreateRenderer() and SDL_CreateWindowAndRenderer(). These can _also_
// create a software renderer, but they are intended to be used with an
// SDL_Window as the final destination and not an SDL_Surface.
//
// `surface` the SDL_Surface structure representing the surface where
//                rendering is done
// returns a valid rendering context or NULL if there was an error; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateRenderer
// See also: SDL_CreateWindowRenderer
// See also: SDL_DestroyRenderer
pub fn create_software_renderer(surface &Surface) &Renderer {
	return C.SDL_CreateSoftwareRenderer(surface)
}

fn C.SDL_GetRenderer(window &C.SDL_Window) &C.SDL_Renderer

// get_renderer gets the renderer associated with a window.
//
// `window` the window to query
// returns the rendering context on success or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateRenderer
pub fn get_renderer(window &Window) &Renderer {
	return C.SDL_GetRenderer(window)
}

fn C.SDL_GetRendererInfo(renderer &C.SDL_Renderer, info &C.SDL_RendererInfo) int

// get_renderer_info gets information about a rendering context.
//
// `renderer` the rendering context
// `info` an SDL_RendererInfo structure filled with information about the
//             current renderer
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateRenderer
pub fn get_renderer_info(renderer &Renderer, info &RendererInfo) int {
	return C.SDL_GetRendererInfo(renderer, info)
}

fn C.SDL_GetRendererOutputSize(renderer &C.SDL_Renderer, w &int, h &int) int

// get_renderer_output_size gets the output size in pixels of a rendering context.
//
// Due to high-dpi displays, you might end up with a rendering context that
// has more pixels than the window that contains it, so use this instead of
// SDL_GetWindowSize() to decide how much drawing area you have.
//
// `renderer` the rendering context
// `w` an int filled with the width
// `h` an int filled with the height
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetRenderer
pub fn get_renderer_output_size(renderer &Renderer, w &int, h &int) int {
	return C.SDL_GetRendererOutputSize(renderer, w, h)
}

fn C.SDL_CreateTexture(renderer &C.SDL_Renderer, format u32, access int, w int, h int) &C.SDL_Texture

// create_texture creates a texture for a rendering context.
//
// You can set the texture scaling method by setting
// `SDL_HINT_RENDER_SCALE_QUALITY` before creating the texture.
//
// `renderer` the rendering context
// `format` one of the enumerated values in SDL_PixelFormatEnum
// `access` one of the enumerated values in SDL_TextureAccess
// `w` the width of the texture in pixels
// `h` the height of the texture in pixels
// returns a pointer to the created texture or NULL if no rendering context
//          was active, the format was unsupported, or the width or height
//          were out of range; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateTextureFromSurface
// See also: SDL_DestroyTexture
// See also: SDL_QueryTexture
// See also: SDL_UpdateTexture
pub fn create_texture(renderer &Renderer, format Format, access TextureAccess, w int, h int) &Texture {
	return C.SDL_CreateTexture(renderer, u32(format), int(access), w, h)
}

fn C.SDL_CreateTextureFromSurface(renderer &C.SDL_Renderer, surface &C.SDL_Surface) &C.SDL_Texture

// create_texture_from_surface creates a texture from an existing surface.
//
// The surface is not modified or freed by this function.
//
// The SDL_TextureAccess hint for the created texture is
// `SDL_TEXTUREACCESS_STATIC`.
//
// The pixel format of the created texture may be different from the pixel
// format of the surface. Use SDL_QueryTexture() to query the pixel format of
// the texture.
//
// `renderer` the rendering context
// `surface` the SDL_Surface structure containing pixel data used to fill
//                the texture
// returns the created texture or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateTexture
// See also: SDL_DestroyTexture
// See also: SDL_QueryTexture
pub fn create_texture_from_surface(renderer &Renderer, surface &Surface) &Texture {
	return C.SDL_CreateTextureFromSurface(renderer, surface)
}

fn C.SDL_QueryTexture(texture &C.SDL_Texture, format &u32, access &int, w &int, h &int) int

// query_texture queries the attributes of a texture.
//
// `texture` the texture to query
// `format` a pointer filled in with the raw format of the texture; the
//               actual format may differ, but pixel transfers will use this
//               format (one of the SDL_PixelFormatEnum values)
// `access` a pointer filled in with the actual access to the texture
//               (one of the SDL_TextureAccess values)
// `w` a pointer filled in with the width of the texture in pixels
// `h` a pointer filled in with the height of the texture in pixels
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateTexture
pub fn query_texture(texture &Texture, format &u32, access &int, w &int, h &int) int {
	return C.SDL_QueryTexture(texture, format, access, w, h)
}

fn C.SDL_SetTextureColorMod(texture &C.SDL_Texture, r u8, g u8, b u8) int

// set_texture_color_mod sets an additional color value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation each source color
// channel is modulated by the appropriate color value according to the
// following formula:
//
// `srcC = srcC * (color / 255)`
//
// Color modulation is not always supported by the renderer; it will return -1
// if color modulation is not supported.
//
// `texture` the texture to update
// `r` the red color value multiplied into copy operations
// `g` the green color value multiplied into copy operations
// `b` the blue color value multiplied into copy operations
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetTextureColorMod
// See also: SDL_SetTextureAlphaMod
pub fn set_texture_color_mod(texture &Texture, r u8, g u8, b u8) int {
	return C.SDL_SetTextureColorMod(texture, r, g, b)
}

fn C.SDL_GetTextureColorMod(texture &C.SDL_Texture, r &u8, g &u8, b &u8) int

// get_texture_color_mod gets the additional color value multiplied into render copy operations.
//
// `texture` the texture to query
// `r` a pointer filled in with the current red color value
// `g` a pointer filled in with the current green color value
// `b` a pointer filled in with the current blue color value
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetTextureAlphaMod
// See also: SDL_SetTextureColorMod
pub fn get_texture_color_mod(texture &Texture, r &u8, g &u8, b &u8) int {
	return C.SDL_GetTextureColorMod(texture, r, g, b)
}

fn C.SDL_SetTextureAlphaMod(texture &C.SDL_Texture, alpha u8) int

// set_texture_alpha_mod sets an additional alpha value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation the source alpha
// value is modulated by this alpha value according to the following formula:
//
// `srcA = srcA * (alpha / 255)`
//
// Alpha modulation is not always supported by the renderer; it will return -1
// if alpha modulation is not supported.
//
// `texture` the texture to update
// `alpha` the source alpha value multiplied into copy operations
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetTextureAlphaMod
// See also: SDL_SetTextureColorMod
pub fn set_texture_alpha_mod(texture &Texture, alpha u8) int {
	return C.SDL_SetTextureAlphaMod(texture, alpha)
}

fn C.SDL_GetTextureAlphaMod(texture &C.SDL_Texture, alpha &u8) int

// get_texture_alpha_mod gets the additional alpha value multiplied into render copy operations.
//
// `texture` the texture to query
// `alpha` a pointer filled in with the current alpha value
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetTextureColorMod
// See also: SDL_SetTextureAlphaMod
pub fn get_texture_alpha_mod(texture &Texture, alpha &u8) int {
	return C.SDL_GetTextureAlphaMod(texture, alpha)
}

fn C.SDL_SetTextureBlendMode(texture &C.SDL_Texture, blend_mode C.SDL_BlendMode) int

// set_texture_blend_mode sets the blend mode for a texture, used by SDL_RenderCopy().
//
// If the blend mode is not supported, the closest supported mode is chosen
// and this function returns -1.
//
// `texture` the texture to update
// `blendMode` the SDL_BlendMode to use for texture blending
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetTextureBlendMode
// See also: SDL_RenderCopy
pub fn set_texture_blend_mode(texture &Texture, blend_mode BlendMode) int {
	return C.SDL_SetTextureBlendMode(texture, C.SDL_BlendMode(blend_mode))
}

fn C.SDL_GetTextureBlendMode(texture &C.SDL_Texture, blend_mode &C.SDL_BlendMode) int

// get_texture_blend_mode gets the blend mode used for texture copy operations.
//
// `texture` the texture to query
// `blendMode` a pointer filled in with the current SDL_BlendMode
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetTextureBlendMode
pub fn get_texture_blend_mode(texture &Texture, blend_mode &BlendMode) int {
	return C.SDL_GetTextureBlendMode(texture, unsafe { &C.SDL_BlendMode(blend_mode) })
}

fn C.SDL_SetTextureScaleMode(texture &C.SDL_Texture, scale_mode C.SDL_ScaleMode) int

// set_texture_scale_mode sets the scale mode used for texture scale operations.
//
// If the scale mode is not supported, the closest supported mode is chosen.
//
// `texture` The texture to update.
// `scaleMode` the SDL_ScaleMode to use for texture scaling.
// returns 0 on success, or -1 if the texture is not valid.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetTextureScaleMode
pub fn set_texture_scale_mode(texture &Texture, scale_mode ScaleMode) int {
	return C.SDL_SetTextureScaleMode(texture, C.SDL_ScaleMode(int(scale_mode)))
}

fn C.SDL_GetTextureScaleMode(texture &C.SDL_Texture, scale_mode &C.SDL_ScaleMode) int

// get_texture_scale_mode gets the scale mode used for texture scale operations.
//
// `texture` the texture to query.
// `scaleMode` a pointer filled in with the current scale mode.
// returns 0 on success, or -1 if the texture is not valid.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetTextureScaleMode
pub fn get_texture_scale_mode(texture &Texture, scale_mode &ScaleMode) int {
	return unsafe { C.SDL_GetTextureScaleMode(texture, &C.SDL_ScaleMode(scale_mode)) }
}

fn C.SDL_SetTextureUserData(texture &C.SDL_Texture, userdata voidptr) int

// set_texture_user_data associates a user-specified pointer with a texture.
//
// `texture` the texture to update.
// `userdata` the pointer to associate with the texture.
// returns 0 on success, or -1 if the texture is not valid.
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_GetTextureUserData
pub fn set_texture_user_data(texture &Texture, userdata voidptr) int {
	return C.SDL_SetTextureUserData(texture, userdata)
}

fn C.SDL_GetTextureUserData(texture &Texture) voidptr

// get_texture_user_data gets the user-specified pointer associated with a texture
//
// `texture` the texture to query.
// returns the pointer associated with the texture, or NULL if the texture is
//         not valid.
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_SetTextureUserData
pub fn get_texture_user_data(texture &C.SDL_Texture) voidptr {
	return C.SDL_GetTextureUserData(texture)
}

fn C.SDL_UpdateTexture(texture &C.SDL_Texture, const_rect &C.SDL_Rect, const_pixels voidptr, pitch int) int

// update_texture updates the given texture rectangle with new pixel data.
//
// The pixel data must be in the pixel format of the texture. Use
// SDL_QueryTexture() to query the pixel format of the texture.
//
// This is a fairly slow function, intended for use with static textures that
// do not change often.
//
// If the texture is intended to be updated often, it is preferred to create
// the texture as streaming and use the locking functions referenced below.
// While this function will work with streaming textures, for optimization
// reasons you may not get the pixels back if you lock the texture afterward.
//
// `texture` the texture to update
// `rect` an SDL_Rect structure representing the area to update, or NULL
//             to update the entire texture
// `pixels` the raw pixel data in the format of the texture
// `pitch` the number of bytes in a row of pixel data, including padding
//              between lines
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateTexture
// See also: SDL_LockTexture
// See also: SDL_UnlockTexture
pub fn update_texture(texture &Texture, const_rect &Rect, const_pixels voidptr, pitch int) int {
	return C.SDL_UpdateTexture(texture, const_rect, const_pixels, pitch)
}

fn C.SDL_UpdateYUVTexture(texture &C.SDL_Texture, const_rect &C.SDL_Rect, const_yplane &u8, ypitch int, const_uplane &u8, upitch int, const_vplane &u8, vpitch int) int

// update_yuv_texture updates a rectangle within a planar YV12 or IYUV texture with new pixel
// data.
//
// You can use SDL_UpdateTexture() as long as your pixel data is a contiguous
// block of Y and U/V planes in the proper order, but this function is
// available if your pixel data is not contiguous.
//
// `texture` the texture to update
// `rect` a pointer to the rectangle of pixels to update, or NULL to
//             update the entire texture
// `Yplane` the raw pixel data for the Y plane
// `Ypitch` the number of bytes between rows of pixel data for the Y
//               plane
// `Uplane` the raw pixel data for the U plane
// `Upitch` the number of bytes between rows of pixel data for the U
//               plane
// `Vplane` the raw pixel data for the V plane
// `Vpitch` the number of bytes between rows of pixel data for the V
//               plane
// returns 0 on success or -1 if the texture is not valid; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.1.
//
// See also: SDL_UpdateTexture
pub fn update_yuv_texture(texture &Texture, const_rect &Rect, const_yplane &u8, ypitch int, const_uplane &u8, upitch int, const_vplane &u8, vpitch int) int {
	return C.SDL_UpdateYUVTexture(texture, const_rect, const_yplane, ypitch, const_uplane,
		upitch, const_vplane, vpitch)
}

fn C.SDL_UpdateNVTexture(texture &C.SDL_Texture, const_rect &C.SDL_Rect, const_yplane &u8, ypitch int, const_u_vplane &u8, u_vpitch int) int

// update_nv_texture updates a rectangle within a planar NV12 or NV21 texture with new pixels.
//
// You can use SDL_UpdateTexture() as long as your pixel data is a contiguous
// block of NV12/21 planes in the proper order, but this function is available
// if your pixel data is not contiguous.
//
// `texture` the texture to update
// `rect` a pointer to the rectangle of pixels to update, or NULL to
//             update the entire texture.
// `Yplane` the raw pixel data for the Y plane.
// `Ypitch` the number of bytes between rows of pixel data for the Y
//               plane.
// `UVplane` the raw pixel data for the UV plane.
// `UVpitch` the number of bytes between rows of pixel data for the UV
//                plane.
// returns 0 on success, or -1 if the texture is not valid.
//
// NOTE This function is available since SDL 2.0.16.
pub fn update_nv_texture(texture &C.SDL_Texture, const_rect &Rect, const_yplane &u8, ypitch int, const_u_vplane &u8, u_vpitch int) int {
	return C.SDL_UpdateNVTexture(texture, const_rect, const_yplane, ypitch, const_u_vplane,
		u_vpitch)
}

fn C.SDL_LockTexture(texture &C.SDL_Texture, const_rect &C.SDL_Rect, pixels voidptr, pitch &int) int

// lock_texture locks a portion of the texture for **write-only** pixel access.
//
// As an optimization, the pixels made available for editing don't necessarily
// contain the old texture data. This is a write-only operation, and if you
// need to keep a copy of the texture data you should do that at the
// application level.
//
// You must use SDL_UnlockTexture() to unlock the pixels and apply any
// changes.
//
// `texture` the texture to lock for access, which was created with
//                `SDL_TEXTUREACCESS_STREAMING`
// `rect` an SDL_Rect structure representing the area to lock for access;
//             NULL to lock the entire texture
// `pixels` this is filled in with a pointer to the locked pixels,
//               appropriately offset by the locked area
// `pitch` this is filled in with the pitch of the locked pixels; the
//              pitch is the length of one row in bytes
// returns 0 on success or a negative error code if the texture is not valid
//          or was not created with `SDL_TEXTUREACCESS_STREAMING`; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_UnlockTexture
pub fn lock_texture(texture &Texture, const_rect &Rect, pixels voidptr, pitch &int) int {
	return C.SDL_LockTexture(texture, const_rect, pixels, pitch)
}

fn C.SDL_LockTextureToSurface(texture &C.SDL_Texture, const_rect &C.SDL_Rect, surface &&C.SDL_Surface) int

// lock_texture_to_surface locks a portion of the texture for **write-only** pixel access, and expose
// it as a SDL surface.
//
// Besides providing an SDL_Surface instead of raw pixel data, this function
// operates like SDL_LockTexture.
//
// As an optimization, the pixels made available for editing don't necessarily
// contain the old texture data. This is a write-only operation, and if you
// need to keep a copy of the texture data you should do that at the
// application level.
//
// You must use SDL_UnlockTexture() to unlock the pixels and apply any
// changes.
//
// The returned surface is freed internally after calling SDL_UnlockTexture()
// or SDL_DestroyTexture(). The caller should not free it.
//
// `texture` the texture to lock for access, which was created with
//                `SDL_TEXTUREACCESS_STREAMING`
// `rect` a pointer to the rectangle to lock for access. If the rect is
//             NULL, the entire texture will be locked
// `surface` this is filled in with an SDL surface representing the
//                locked area
// returns 0 on success, or -1 if the texture is not valid or was not created
//          with `SDL_TEXTUREACCESS_STREAMING`
//
// NOTE This function is available since SDL 2.0.12.
//
// See also: SDL_LockTexture
// See also: SDL_UnlockTexture
pub fn lock_texture_to_surface(texture &Texture, const_rect &Rect, surface &&Surface) int {
	return C.SDL_LockTextureToSurface(texture, const_rect, surface)
}

fn C.SDL_UnlockTexture(texture &C.SDL_Texture)

// unlock_texture unlocks a texture, uploading the changes to video memory, if needed.
//
// **WARNING**: Please note that SDL_LockTexture() is intended to be
// write-only; it will not guarantee the previous contents of the texture will
// be provided. You must fully initialize any area of a texture that you lock
// before unlocking it, as the pixels might otherwise be uninitialized memory.
//
// Which is to say: locking and immediately unlocking a texture can result in
// corrupted textures, depending on the renderer in use.
//
// `texture` a texture locked by SDL_LockTexture()
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LockTexture
pub fn unlock_texture(texture &Texture) {
	C.SDL_UnlockTexture(texture)
}

fn C.SDL_RenderTargetSupported(renderer &C.SDL_Renderer) bool

// render_target_supported determines whether a renderer supports the use of render targets.
//
// `renderer` the renderer that will be checked
// returns SDL_TRUE if supported or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetRenderTarget
pub fn render_target_supported(renderer &Renderer) bool {
	return C.SDL_RenderTargetSupported(renderer)
}

fn C.SDL_SetRenderTarget(renderer &C.SDL_Renderer, texture &C.SDL_Texture) int

// set_render_target sets a texture as the current rendering target.
//
// Before using this function, you should check the
// `SDL_RENDERER_TARGETTEXTURE` bit in the flags of SDL_RendererInfo to see if
// render targets are supported.
//
// The default render target is the window for which the renderer was created.
// To stop rendering to a texture and render to the window again, call this
// function with a NULL `texture`.
//
// `renderer` the rendering context
// `texture` the targeted texture, which must be created with the
//                `SDL_TEXTUREACCESS_TARGET` flag, or NULL to render to the
//                window instead of a texture.
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetRenderTarget
pub fn set_render_target(renderer &Renderer, texture &Texture) int {
	return C.SDL_SetRenderTarget(renderer, texture)
}

fn C.SDL_GetRenderTarget(renderer &C.SDL_Renderer) &C.SDL_Texture

// get_render_target gets the current render target.
//
// The default render target is the window for which the renderer was created,
// and is reported a NULL here.
//
// `renderer` the rendering context
// returns the current render target or NULL for the default render target.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetRenderTarget
pub fn get_render_target(renderer &Renderer) &Texture {
	return C.SDL_GetRenderTarget(renderer)
}

fn C.SDL_RenderSetLogicalSize(renderer &C.SDL_Renderer, w int, h int) int

// render_set_logical_size sets a device independent resolution for rendering.
//
// This function uses the viewport and scaling functionality to allow a fixed
// logical resolution for rendering, regardless of the actual output
// resolution. If the actual output resolution doesn't have the same aspect
// ratio the output rendering will be centered within the output display.
//
// If the output display is a window, mouse and touch events in the window
// will be filtered and scaled so they seem to arrive within the logical
// resolution. The SDL_HINT_MOUSE_RELATIVE_SCALING hint controls whether
// relative motion events are also scaled.
//
// If this function results in scaling or subpixel drawing by the rendering
// backend, it will be handled using the appropriate quality hints.
//
// `renderer` the renderer for which resolution should be set
// `w` the width of the logical resolution
// `h` the height of the logical resolution
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderGetLogicalSize
pub fn render_set_logical_size(renderer &Renderer, w int, h int) int {
	return C.SDL_RenderSetLogicalSize(renderer, w, h)
}

fn C.SDL_RenderGetLogicalSize(renderer &C.SDL_Renderer, w &int, h &int)

// render_get_logical_size gets device independent resolution for rendering.
//
// This may return 0 for `w` and `h` if the SDL_Renderer has never had its
// logical size set by SDL_RenderSetLogicalSize() and never had a render
// target set.
//
// `renderer` a rendering context
// `w` an int to be filled with the width
// `h` an int to be filled with the height
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderSetLogicalSize
pub fn render_get_logical_size(renderer &Renderer, w &int, h &int) {
	C.SDL_RenderGetLogicalSize(renderer, w, h)
}

fn C.SDL_RenderSetIntegerScale(renderer &C.SDL_Renderer, enable bool) int

// render_set_integer_scale sets whether to force integer scales for resolution-independent rendering.
//
// This function restricts the logical viewport to integer values - that is,
// when a resolution is between two multiples of a logical size, the viewport
// size is rounded down to the lower multiple.
//
// `renderer` the renderer for which integer scaling should be set
// `enable` enable or disable the integer scaling for rendering
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_RenderGetIntegerScale
// See also: SDL_RenderSetLogicalSize
pub fn render_set_integer_scale(renderer &Renderer, enable bool) int {
	return C.SDL_RenderSetIntegerScale(renderer, enable)
}

fn C.SDL_RenderGetIntegerScale(renderer &C.SDL_Renderer) bool

// render_get_integer_scale gets whether integer scales are forced for resolution-independent rendering.
//
// `renderer` the renderer from which integer scaling should be queried
// returns SDL_TRUE if integer scales are forced or SDL_FALSE if not and on
//          failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_RenderSetIntegerScale
pub fn render_get_integer_scale(renderer &Renderer) bool {
	return C.SDL_RenderGetIntegerScale(renderer)
}

fn C.SDL_RenderSetViewport(renderer &C.SDL_Renderer, const_rect &C.SDL_Rect) int

// render_set_viewport sets the drawing area for rendering on the current target.
//
// When the window is resized, the viewport is reset to fill the entire new
// window size.
//
// `renderer` the rendering context
// `rect` the SDL_Rect structure representing the drawing area, or NULL
//             to set the viewport to the entire target
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderGetViewport
pub fn render_set_viewport(renderer &Renderer, const_rect &Rect) int {
	return C.SDL_RenderSetViewport(renderer, const_rect)
}

fn C.SDL_RenderGetViewport(renderer &C.SDL_Renderer, rect &C.SDL_Rect)

// render_get_viewport gets the drawing area for the current target.
//
// `renderer` the rendering context
// `rect` an SDL_Rect structure filled in with the current drawing area
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderSetViewport
pub fn render_get_viewport(renderer &Renderer, rect &Rect) {
	C.SDL_RenderGetViewport(renderer, rect)
}

fn C.SDL_RenderSetClipRect(renderer &C.SDL_Renderer, const_rect &C.SDL_Rect) int

// render_set_clip_rect sets the clip rectangle for rendering on the specified target.
//
// `renderer` the rendering context for which clip rectangle should be
//                 set
// `rect` an SDL_Rect structure representing the clip area, relative to
//             the viewport, or NULL to disable clipping
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderGetClipRect
// See also: SDL_RenderIsClipEnabled
pub fn render_set_clip_rect(renderer &Renderer, const_rect &Rect) int {
	return C.SDL_RenderSetClipRect(renderer, const_rect)
}

fn C.SDL_RenderGetClipRect(renderer &Renderer, rect &C.SDL_Rect)

// render_get_clip_rect gets the clip rectangle for the current target.
//
// `renderer` the rendering context from which clip rectangle should be
//                 queried
// `rect` an SDL_Rect structure filled in with the current clipping area
//             or an empty rectangle if clipping is disabled
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderIsClipEnabled
// See also: SDL_RenderSetClipRect
pub fn render_get_clip_rect(renderer &Renderer, rect &Rect) {
	C.SDL_RenderGetClipRect(renderer, rect)
}

fn C.SDL_RenderIsClipEnabled(renderer &C.SDL_Renderer) bool

// render_is_clip_enabled gets whether clipping is enabled on the given renderer.
//
// `renderer` the renderer from which clip state should be queried
// returns SDL_TRUE if clipping is enabled or SDL_FALSE if not; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.4.
//
// See also: SDL_RenderGetClipRect
// See also: SDL_RenderSetClipRect
pub fn render_is_clip_enabled(renderer &Renderer) bool {
	return C.SDL_RenderIsClipEnabled(renderer)
}

fn C.SDL_RenderSetScale(renderer &C.SDL_Renderer, scale_x f32, scale_y f32) int

// render_set_scale sets the drawing scale for rendering on the current target.
//
// The drawing coordinates are scaled by the x/y scaling factors before they
// are used by the renderer. This allows resolution independent drawing with a
// single coordinate system.
//
// If this results in scaling or subpixel drawing by the rendering backend, it
// will be handled using the appropriate quality hints. For best results use
// integer scaling factors.
//
// `renderer` a rendering context
// `scaleX` the horizontal scaling factor
// `scaleY` the vertical scaling factor
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderGetScale
// See also: SDL_RenderSetLogicalSize
pub fn render_set_scale(renderer &Renderer, scale_x f32, scale_y f32) int {
	return C.SDL_RenderSetScale(renderer, scale_x, scale_y)
}

fn C.SDL_RenderGetScale(renderer &C.SDL_Renderer, scale_x &f32, scale_y &f32)

// render_get_scale gets the drawing scale for the current target.
//
// `renderer` the renderer from which drawing scale should be queried
// `scaleX` a pointer filled in with the horizontal scaling factor
// `scaleY` a pointer filled in with the vertical scaling factor
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderSetScale
pub fn render_get_scale(renderer &Renderer, scale_x &f32, scale_y &f32) {
	C.SDL_RenderGetScale(renderer, scale_x, scale_y)
}

fn C.SDL_RenderWindowToLogical(renderer &C.SDL_Renderer, window_x int, window_y int, logical_x &f32, logical_y &f32)

// render_window_to_logical gets logical coordinates of point in renderer when given real coordinates of
// point in window.
//
// Logical coordinates will differ from real coordinates when render is scaled
// and logical renderer size set
//
// `renderer` the renderer from which the logical coordinates should be
//                 calcualted
// `windowX` the real X coordinate in the window
// `windowY` the real Y coordinate in the window
// `logicalX` the pointer filled with the logical x coordinate
// `logicalY` the pointer filled with the logical y coordinate
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_RenderGetScale
// See also: SDL_RenderSetScale
// See also: SDL_RenderGetLogicalSize
// See also: SDL_RenderSetLogicalSize
pub fn render_window_to_logical(renderer &Renderer, window_x int, window_y int, logical_x &f32, logical_y &f32) {
	C.SDL_RenderWindowToLogical(renderer, window_x, window_y, logical_x, logical_y)
}

fn C.SDL_RenderLogicalToWindow(renderer &C.SDL_Renderer, logical_x f32, logical_y f32, window_x &int, window_y &int)

// render_logical_to_window gets real coordinates of point in window when given logical coordinates of point in renderer.
// Logical coordinates will differ from real coordinates when render is scaled and logical renderer size set
//
// `renderer` the renderer from which the window coordinates should be calculated
// `logicalX` the logical x coordinate
// `logicalY` the logical y coordinate
// `windowX` the pointer filled with the real X coordinate in the window
// `windowY` the pointer filled with the real Y coordinate in the window
//
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_RenderGetScale
// See also: SDL_RenderSetScale
// See also: SDL_RenderGetLogicalSize
// See also: SDL_RenderSetLogicalSize
pub fn render_logical_to_window(renderer &Renderer, logical_x f32, logical_y f32, window_x &int, window_y &int) {
	C.SDL_RenderLogicalToWindow(renderer, logical_x, logical_y, window_x, window_y)
}

fn C.SDL_SetRenderDrawColor(renderer &C.SDL_Renderer, r u8, g u8, b u8, a u8) int

// set_render_draw_color sets the color used for drawing operations (Rect, Line and Clear).
//
// Set the color for drawing or filling rectangles, lines, and points, and for
// SDL_RenderClear().
//
// `renderer` the rendering context
// `r` the red value used to draw on the rendering target
// `g` the green value used to draw on the rendering target
// `b` the blue value used to draw on the rendering target
// `a` the alpha value used to draw on the rendering target; usually
//          `SDL_ALPHA_OPAQUE` (255). Use SDL_SetRenderDrawBlendMode to
//          specify how the alpha channel is used
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetRenderDrawColor
// See also: SDL_RenderClear
// See also: SDL_RenderDrawLine
// See also: SDL_RenderDrawLines
// See also: SDL_RenderDrawPoint
// See also: SDL_RenderDrawPoints
// See also: SDL_RenderDrawRect
// See also: SDL_RenderDrawRects
// See also: SDL_RenderFillRect
// See also: SDL_RenderFillRects
pub fn set_render_draw_color(renderer &Renderer, r u8, g u8, b u8, a u8) int {
	return C.SDL_SetRenderDrawColor(renderer, r, g, b, a)
}

fn C.SDL_GetRenderDrawColor(renderer &C.SDL_Renderer, r &u8, g &u8, b &u8, a &u8) int

// get_render_draw_color gets the color used for drawing operations (Rect, Line and Clear).
//
// `renderer` the rendering context
// `r` a pointer filled in with the red value used to draw on the
//          rendering target
// `g` a pointer filled in with the green value used to draw on the
//          rendering target
// `b` a pointer filled in with the blue value used to draw on the
//          rendering target
// `a` a pointer filled in with the alpha value used to draw on the
//          rendering target; usually `SDL_ALPHA_OPAQUE` (255)
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetRenderDrawColor
pub fn get_render_draw_color(renderer &Renderer, r &u8, g &u8, b &u8, a &u8) int {
	return C.SDL_GetRenderDrawColor(renderer, r, g, b, a)
}

fn C.SDL_SetRenderDrawBlendMode(renderer &C.SDL_Renderer, blend_mode C.SDL_BlendMode) int

// set_render_draw_blend_mode sets the blend mode used for drawing operations (Fill and Line).
//
// If the blend mode is not supported, the closest supported mode is chosen.
//
// `renderer` the rendering context
// `blendMode` the SDL_BlendMode to use for blending
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetRenderDrawBlendMode
// See also: SDL_RenderDrawLine
// See also: SDL_RenderDrawLines
// See also: SDL_RenderDrawPoint
// See also: SDL_RenderDrawPoints
// See also: SDL_RenderDrawRect
// See also: SDL_RenderDrawRects
// See also: SDL_RenderFillRect
// See also: SDL_RenderFillRects
pub fn set_render_draw_blend_mode(renderer &Renderer, blend_mode BlendMode) int {
	return C.SDL_SetRenderDrawBlendMode(renderer, C.SDL_BlendMode(blend_mode))
}

fn C.SDL_GetRenderDrawBlendMode(renderer &C.SDL_Renderer, blend_mode &C.SDL_BlendMode) int

// get_render_draw_blend_mode gets the blend mode used for drawing operations.
//
// `renderer` the rendering context
// `blendMode` a pointer filled in with the current SDL_BlendMode
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetRenderDrawBlendMode
pub fn get_render_draw_blend_mode(renderer &Renderer, blend_mode &BlendMode) int {
	return C.SDL_GetRenderDrawBlendMode(renderer, unsafe { &C.SDL_BlendMode(blend_mode) })
}

fn C.SDL_RenderClear(renderer &C.SDL_Renderer) int

// render_clear clears the current rendering target with the drawing color.
//
// This function clears the entire rendering target, ignoring the viewport and
// the clip rectangle.
//
// `renderer` the rendering context
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetRenderDrawColor
pub fn render_clear(renderer &Renderer) int {
	return C.SDL_RenderClear(renderer)
}

fn C.SDL_RenderDrawPoint(renderer &C.SDL_Renderer, x int, y int) int

// render_draw_point draws a point on the current rendering target.
//
// SDL_RenderDrawPoint() draws a single point. If you want to draw multiple,
// use SDL_RenderDrawPoints() instead.
//
// `renderer` the rendering context
// `x` the x coordinate of the point
// `y` the y coordinate of the point
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderDrawLine
// See also: SDL_RenderDrawLines
// See also: SDL_RenderDrawPoints
// See also: SDL_RenderDrawRect
// See also: SDL_RenderDrawRects
// See also: SDL_RenderFillRect
// See also: SDL_RenderFillRects
// See also: SDL_RenderPresent
// See also: SDL_SetRenderDrawBlendMode
// See also: SDL_SetRenderDrawColor
pub fn render_draw_point(renderer &Renderer, x int, y int) int {
	return C.SDL_RenderDrawPoint(renderer, x, y)
}

fn C.SDL_RenderDrawPoints(renderer &C.SDL_Renderer, const_points &C.SDL_Point, count int) int

// render_draw_points draws multiple points on the current rendering target.
//
// `renderer` the rendering context
// `points` an array of SDL_Point structures that represent the points to
//               draw
// `count` the number of points to draw
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderDrawLine
// See also: SDL_RenderDrawLines
// See also: SDL_RenderDrawPoint
// See also: SDL_RenderDrawRect
// See also: SDL_RenderDrawRects
// See also: SDL_RenderFillRect
// See also: SDL_RenderFillRects
// See also: SDL_RenderPresent
// See also: SDL_SetRenderDrawBlendMode
// See also: SDL_SetRenderDrawColor
pub fn render_draw_points(renderer &Renderer, const_points &Point, count int) int {
	return C.SDL_RenderDrawPoints(renderer, const_points, count)
}

fn C.SDL_RenderDrawLine(renderer &C.SDL_Renderer, x1 int, y1 int, x2 int, y2 int) int

// render_draw_line draws a line on the current rendering target.
//
// SDL_RenderDrawLine() draws the line to include both end points. If you want
// to draw multiple, connecting lines use SDL_RenderDrawLines() instead.
//
// `renderer` the rendering context
// `x1` the x coordinate of the start point
// `y1` the y coordinate of the start point
// `x2` the x coordinate of the end point
// `y2` the y coordinate of the end point
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderDrawLines
// See also: SDL_RenderDrawPoint
// See also: SDL_RenderDrawPoints
// See also: SDL_RenderDrawRect
// See also: SDL_RenderDrawRects
// See also: SDL_RenderFillRect
// See also: SDL_RenderFillRects
// See also: SDL_RenderPresent
// See also: SDL_SetRenderDrawBlendMode
// See also: SDL_SetRenderDrawColor
pub fn render_draw_line(renderer &Renderer, x1 int, y1 int, x2 int, y2 int) int {
	return C.SDL_RenderDrawLine(renderer, x1, y1, x2, y2)
}

fn C.SDL_RenderDrawLines(renderer &C.SDL_Renderer, const_points &C.SDL_Point, count int) int

// render_draw_lines draws a series of connected lines on the current rendering target.
//
// `renderer` the rendering context
// `points` an array of SDL_Point structures representing points along
//               the lines
// `count` the number of points, drawing count-1 lines
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderDrawLine
// See also: SDL_RenderDrawPoint
// See also: SDL_RenderDrawPoints
// See also: SDL_RenderDrawRect
// See also: SDL_RenderDrawRects
// See also: SDL_RenderFillRect
// See also: SDL_RenderFillRects
// See also: SDL_RenderPresent
// See also: SDL_SetRenderDrawBlendMode
// See also: SDL_SetRenderDrawColor
pub fn render_draw_lines(renderer &Renderer, const_points &Point, count int) int {
	return C.SDL_RenderDrawLines(renderer, const_points, count)
}

fn C.SDL_RenderDrawRect(renderer &C.SDL_Renderer, const_rect &C.SDL_Rect) int

// render_draw_rect draws a rectangle on the current rendering target.
//
// `renderer` the rendering context
// `rect` an SDL_Rect structure representing the rectangle to draw, or
//             NULL to outline the entire rendering target
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderDrawLine
// See also: SDL_RenderDrawLines
// See also: SDL_RenderDrawPoint
// See also: SDL_RenderDrawPoints
// See also: SDL_RenderDrawRects
// See also: SDL_RenderFillRect
// See also: SDL_RenderFillRects
// See also: SDL_RenderPresent
// See also: SDL_SetRenderDrawBlendMode
// See also: SDL_SetRenderDrawColor
pub fn render_draw_rect(renderer &Renderer, const_rect &Rect) int {
	return C.SDL_RenderDrawRect(renderer, const_rect)
}

fn C.SDL_RenderDrawRects(renderer &C.SDL_Renderer, const_rects &C.SDL_Rect, count int) int

// render_draw_rects draws some number of rectangles on the current rendering target.
//
// `renderer` the rendering context
// `rects` an array of SDL_Rect structures representing the rectangles to
//              be drawn
// `count` the number of rectangles
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderDrawLine
// See also: SDL_RenderDrawLines
// See also: SDL_RenderDrawPoint
// See also: SDL_RenderDrawPoints
// See also: SDL_RenderDrawRect
// See also: SDL_RenderFillRect
// See also: SDL_RenderFillRects
// See also: SDL_RenderPresent
// See also: SDL_SetRenderDrawBlendMode
// See also: SDL_SetRenderDrawColor
pub fn render_draw_rects(renderer &Renderer, const_rects &Rect, count int) int {
	return C.SDL_RenderDrawRects(renderer, const_rects, count)
}

fn C.SDL_RenderFillRect(renderer &C.SDL_Renderer, const_rect &C.SDL_Rect) int

// render_fill_rect fills a rectangle on the current rendering target with the drawing color.
//
// The current drawing color is set by SDL_SetRenderDrawColor(), and the
// color's alpha value is ignored unless blending is enabled with the
// appropriate call to SDL_SetRenderDrawBlendMode().
//
// `renderer` the rendering context
// `rect` the SDL_Rect structure representing the rectangle to fill, or
//             NULL for the entire rendering target
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderDrawLine
// See also: SDL_RenderDrawLines
// See also: SDL_RenderDrawPoint
// See also: SDL_RenderDrawPoints
// See also: SDL_RenderDrawRect
// See also: SDL_RenderDrawRects
// See also: SDL_RenderFillRects
// See also: SDL_RenderPresent
// See also: SDL_SetRenderDrawBlendMode
// See also: SDL_SetRenderDrawColor
pub fn render_fill_rect(renderer &Renderer, const_rect &Rect) int {
	return C.SDL_RenderFillRect(renderer, const_rect)
}

fn C.SDL_RenderFillRects(renderer &C.SDL_Renderer, const_rects &C.SDL_Rect, count int) int

// render_fill_rects fills some number of rectangles on the current rendering target with the
// drawing color.
//
// `renderer` the rendering context
// `rects` an array of SDL_Rect structures representing the rectangles to
//              be filled
// `count` the number of rectangles
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderDrawLine
// See also: SDL_RenderDrawLines
// See also: SDL_RenderDrawPoint
// See also: SDL_RenderDrawPoints
// See also: SDL_RenderDrawRect
// See also: SDL_RenderDrawRects
// See also: SDL_RenderFillRect
// See also: SDL_RenderPresent
pub fn render_fill_rects(renderer &Renderer, const_rects &Rect, count int) int {
	return C.SDL_RenderFillRects(renderer, const_rects, count)
}

fn C.SDL_RenderCopy(renderer &C.SDL_Renderer, texture &C.SDL_Texture, const_srcrect &C.SDL_Rect, const_dstrect &C.SDL_Rect) int

// render_copy copies a portion of the texture to the current rendering target.
//
// The texture is blended with the destination based on its blend mode set
// with SDL_SetTextureBlendMode().
//
// The texture color is affected based on its color modulation set by
// SDL_SetTextureColorMod().
//
// The texture alpha is affected based on its alpha modulation set by
// SDL_SetTextureAlphaMod().
//
// `renderer` the rendering context
// `texture` the source texture
// `srcrect` the source SDL_Rect structure or NULL for the entire texture
// `dstrect` the destination SDL_Rect structure or NULL for the entire
//                rendering target; the texture will be stretched to fill the
//                given rectangle
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderCopyEx
// See also: SDL_SetTextureAlphaMod
// See also: SDL_SetTextureBlendMode
// See also: SDL_SetTextureColorMod
pub fn render_copy(renderer &Renderer, texture &Texture, const_srcrect &Rect, const_dstrect &Rect) int {
	return C.SDL_RenderCopy(renderer, texture, const_srcrect, const_dstrect)
}

fn C.SDL_RenderCopyEx(renderer &C.SDL_Renderer, texture &C.SDL_Texture, const_srcrect &C.SDL_Rect, const_dstrect &C.SDL_Rect, const_angle f64, const_center &C.SDL_Point, const_flip C.SDL_RendererFlip) int

// render_copy_ex copies a portion of the texture to the current rendering, with optional
// rotation and flipping.
//
// Copy a portion of the texture to the current rendering target, optionally
// rotating it by angle around the given center and also flipping it
// top-bottom and/or left-right.
//
// The texture is blended with the destination based on its blend mode set
// with SDL_SetTextureBlendMode().
//
// The texture color is affected based on its color modulation set by
// SDL_SetTextureColorMod().
//
// The texture alpha is affected based on its alpha modulation set by
// SDL_SetTextureAlphaMod().
//
// `renderer` the rendering context
// `texture` the source texture
// `srcrect` the source SDL_Rect structure or NULL for the entire texture
// `dstrect` the destination SDL_Rect structure or NULL for the entire
//                rendering target
// `angle` an angle in degrees that indicates the rotation that will be
//              applied to dstrect, rotating it in a clockwise direction
// `center` a pointer to a point indicating the point around which
//               dstrect will be rotated (if NULL, rotation will be done
//               around `dstrect.w / 2`, `dstrect.h / 2`)
// `flip` a SDL_RendererFlip value stating which flipping actions should
//             be performed on the texture
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderCopy
// See also: SDL_SetTextureAlphaMod
// See also: SDL_SetTextureBlendMode
// See also: SDL_SetTextureColorMod
pub fn render_copy_ex(renderer &Renderer, texture &Texture, const_srcrect &Rect, const_dstrect &Rect, const_angle f64, const_center &Point, const_flip RendererFlip) int {
	return C.SDL_RenderCopyEx(renderer, texture, const_srcrect, const_dstrect, const_angle,
		const_center, C.SDL_RendererFlip(int(const_flip)))
}

fn C.SDL_RenderDrawPointF(renderer &C.SDL_Renderer, x f32, y f32) int

// render_draw_point_f draws a point on the current rendering target at subpixel precision.
//
// `renderer` The renderer which should draw a point.
// `x` The x coordinate of the point.
// `y` The y coordinate of the point.
// returns 0 on success, or -1 on error
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_draw_point_f(renderer &Renderer, x f32, y f32) int {
	return C.SDL_RenderDrawPointF(renderer, x, y)
}

fn C.SDL_RenderDrawPointsF(renderer &C.SDL_Renderer, const_points &C.SDL_FPoint, count int) int

// render_draw_points_f draws multiple points on the current rendering target at subpixel precision.
//
// `renderer` The renderer which should draw multiple points.
// `points` The points to draw
// `count` The number of points to draw
// returns 0 on success, or -1 on error
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_draw_points_f(renderer &Renderer, const_points &FPoint, count int) int {
	return C.SDL_RenderDrawPointsF(renderer, const_points, count)
}

fn C.SDL_RenderDrawLineF(renderer &C.SDL_Renderer, x1 f32, y1 f32, x2 f32, y2 f32) int

// render_draw_line_f draws a line on the current rendering target at subpixel precision.
//
// `renderer` The renderer which should draw a line.
// `x1` The x coordinate of the start point.
// `y1` The y coordinate of the start point.
// `x2` The x coordinate of the end point.
// `y2` The y coordinate of the end point.
// returns 0 on success, or -1 on error
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_draw_line_f(renderer &Renderer, x1 f32, y1 f32, x2 f32, y2 f32) int {
	return C.SDL_RenderDrawLineF(renderer, x1, y1, x2, y2)
}

fn C.SDL_RenderDrawLinesF(renderer &C.SDL_Renderer, const_points &C.SDL_FPoint, count int) int

// render_draw_lines_f draws a series of connected lines on the current rendering target at
// subpixel precision.
//
// `renderer` The renderer which should draw multiple lines.
// `points` The points along the lines
// `count` The number of points, drawing count-1 lines
// returns 0 on success, or -1 on error
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_draw_lines_f(renderer &Renderer, const_points &FPoint, count int) int {
	return C.SDL_RenderDrawLinesF(renderer, const_points, count)
}

fn C.SDL_RenderDrawRectF(renderer &C.SDL_Renderer, const_rect &C.SDL_FRect) int

// render_draw_rect_f draws a rectangle on the current rendering target at subpixel precision.
//
// `renderer` The renderer which should draw a rectangle.
// `rect` A pointer to the destination rectangle, or NULL to outline the
//             entire rendering target.
// returns 0 on success, or -1 on error
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_draw_rect_f(renderer &Renderer, const_rect &FRect) int {
	return C.SDL_RenderDrawRectF(renderer, const_rect)
}

fn C.SDL_RenderDrawRectsF(renderer &C.SDL_Renderer, const_rects &C.SDL_FRect, count int) int

// render_draw_rects_f draws some number of rectangles on the current rendering target at subpixel
// precision.
//
// `renderer` The renderer which should draw multiple rectangles.
// `rects` A pointer to an array of destination rectangles.
// `count` The number of rectangles.
// returns 0 on success, or -1 on error
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_draw_rects_f(renderer &Renderer, const_rects &FRect, count int) int {
	return C.SDL_RenderDrawRectsF(renderer, const_rects, count)
}

fn C.SDL_RenderFillRectF(renderer &C.SDL_Renderer, const_rect &C.SDL_FRect) int

// render_fill_rect_f fills a rectangle on the current rendering target with the drawing color at
// subpixel precision.
//
// `renderer` The renderer which should fill a rectangle.
// `rect` A pointer to the destination rectangle, or NULL for the entire
//             rendering target.
// returns 0 on success, or -1 on error
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_fill_rect_f(renderer &Renderer, const_rect &FRect) int {
	return C.SDL_RenderFillRectF(renderer, const_rect)
}

fn C.SDL_RenderFillRectsF(renderer &C.SDL_Renderer, const_rects &C.SDL_FRect, count int) int

// render_fill_rects_f fills some number of rectangles on the current rendering target with the
// drawing color at subpixel precision.
//
// `renderer` The renderer which should fill multiple rectangles.
// `rects` A pointer to an array of destination rectangles.
// `count` The number of rectangles.
// returns 0 on success, or -1 on error
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_fill_rects_f(renderer &Renderer, const_rects &FRect, count int) int {
	return C.SDL_RenderFillRectsF(renderer, const_rects, count)
}

fn C.SDL_RenderCopyF(renderer &C.SDL_Renderer, texture &C.SDL_Texture, const_srcrect &C.SDL_Rect, const_dstrect &C.SDL_FRect) int

// render_copy_f copies a portion of the texture to the current rendering target at subpixel
// precision.
//
// `renderer` The renderer which should copy parts of a texture.
// `texture` The source texture.
// `srcrect` A pointer to the source rectangle, or NULL for the entire
//                texture.
// `dstrect` A pointer to the destination rectangle, or NULL for the
//                entire rendering target.
// returns 0 on success, or -1 on error
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_copy_f(renderer &Renderer, texture &Texture, const_srcrect &Rect, const_dstrect &FRect) int {
	return C.SDL_RenderCopyF(renderer, texture, const_srcrect, const_dstrect)
}

fn C.SDL_RenderCopyExF(renderer &C.SDL_Renderer, texture &C.SDL_Texture, const_srcrect &C.SDL_Rect, const_dstrect &C.SDL_FRect, const_angle f64, const_center &C.SDL_FPoint, const_flip C.SDL_RendererFlip) int

// render_copy_ex_f copies a portion of the source texture to the current rendering target, with
// rotation and flipping, at subpixel precision.
//
// `renderer` The renderer which should copy parts of a texture.
// `texture` The source texture.
// `srcrect` A pointer to the source rectangle, or NULL for the entire
//                texture.
// `dstrect` A pointer to the destination rectangle, or NULL for the
//                entire rendering target.
// `angle` An angle in degrees that indicates the rotation that will be
//              applied to dstrect, rotating it in a clockwise direction
// `center` A pointer to a point indicating the point around which
//               dstrect will be rotated (if NULL, rotation will be done
//               around dstrect.w/2, dstrect.h/2).
// `flip` An SDL_RendererFlip value stating which flipping actions should
//             be performed on the texture
// returns 0 on success, or -1 on error
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_copy_ex_f(renderer &Renderer, texture &Texture, const_srcrect &Rect, const_dstrect &FRect, const_angle f64, const_center &FPoint, const_flip RendererFlip) int {
	return C.SDL_RenderCopyExF(renderer, texture, const_srcrect, const_dstrect, const_angle,
		const_center, C.SDL_RendererFlip(int(const_flip)))
}

fn C.SDL_RenderGeometry(renderer &C.SDL_Renderer, texture &C.SDL_Texture, const_vertices &C.SDL_Vertex, num_vertices int, const_indices &int, num_indices int) int

// render_geometry renders a list of triangles, optionally using a texture and indices into the
// vertex array Color and alpha modulation is done per vertex
// (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
//
// `texture` (optional) The SDL texture to use.
// `vertices` Vertices.
// `num_vertices` Number of vertices.
// `indices` (optional) An array of integer indices into the 'vertices'
//                array, if NULL all vertices will be rendered in sequential
//                order.
// `num_indices` Number of indices.
// returns 0 on success, or -1 if the operation is not supported
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_RenderGeometryRaw
// See also: SDL_Vertex
pub fn render_geometry(renderer &Renderer, texture &Texture, const_vertices &Vertex, num_vertices int, const_indices &int, num_indices int) int {
	return C.SDL_RenderGeometry(renderer, texture, const_vertices, num_vertices, const_indices,
		num_indices)
}

fn C.SDL_RenderGeometryRaw(renderer &C.SDL_Renderer, texture &C.SDL_Texture, const_xy &f32, xy_stride int, const_color &C.SDL_Color, color_stride int, const_uv &f32, uv_stride int, num_vertices int, const_indices voidptr, num_indices int, size_indices int) int

// render_geometry_raw renders a list of triangles, optionally using a texture and indices into the
// vertex arrays Color and alpha modulation is done per vertex
// (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
//
// `texture` (optional) The SDL texture to use.
// `xy` Vertex positions
// `xy_stride` Byte size to move from one element to the next element
// `color` Vertex colors (as SDL_Color)
// `color_stride` Byte size to move from one element to the next element
// `uv` Vertex normalized texture coordinates
// `uv_stride` Byte size to move from one element to the next element
// `num_vertices` Number of vertices.
// `indices` (optional) An array of indices into the 'vertices' arrays,
//                if NULL all vertices will be rendered in sequential order.
// `num_indices` Number of indices.
// `size_indices` Index size: 1 (byte), 2 (short), 4 (int)
// returns 0 on success, or -1 if the operation is not supported
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_RenderGeometry
// See also: SDL_Vertex
pub fn render_geometry_raw(renderer &Renderer, texture &Texture, const_xy &f32, xy_stride int, const_color &Color, color_stride int, const_uv &f32, uv_stride int, num_vertices int, const_indices voidptr, num_indices int, size_indices int) int {
	return C.SDL_RenderGeometryRaw(renderer, texture, const_xy, xy_stride, const_color,
		color_stride, const_uv, uv_stride, num_vertices, const_indices, num_indices, size_indices)
}

fn C.SDL_RenderReadPixels(renderer &C.SDL_Renderer, const_rect &C.SDL_Rect, format u32, pixels voidptr, pitch int) int

// render_read_pixels reads pixels from the current rendering target to an array of pixels.
//
// **WARNING**: This is a very slow operation, and should not be used
// frequently.
//
// `pitch` specifies the number of bytes between rows in the destination
// `pixels` data. This allows you to write to a subrectangle or have padded
// rows in the destination. Generally, `pitch` should equal the number of
// pixels per row in the `pixels` data times the number of bytes per pixel,
// but it might contain additional padding (for example, 24bit RGB Windows
// Bitmap data pads all rows to multiples of 4 bytes).
//
// `renderer` the rendering context
// `rect` an SDL_Rect structure representing the area to read, or NULL
//             for the entire render target
// `format` an SDL_PixelFormatEnum value of the desired format of the
//               pixel data, or 0 to use the format of the rendering target
// `pixels` a pointer to the pixel data to copy into
// `pitch` the pitch of the `pixels` parameter
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
pub fn render_read_pixels(renderer &Renderer, const_rect &Rect, format u32, pixels voidptr, pitch int) int {
	return C.SDL_RenderReadPixels(renderer, const_rect, format, pixels, pitch)
}

fn C.SDL_RenderPresent(renderer &C.SDL_Renderer)

// render_present updates the screen with any rendering performed since the previous call.
//
// SDL's rendering functions operate on a backbuffer; that is, calling a
// rendering function such as SDL_RenderDrawLine() does not directly put a
// line on the screen, but rather updates the backbuffer. As such, you compose
// your entire scene and *present* the composed backbuffer to the screen as a
// complete picture.
//
// Therefore, when using SDL's rendering API, one does all drawing intended
// for the frame, and then calls this function once per frame to present the
// final drawing to the user.
//
// The backbuffer should be considered invalidated after each present; do not
// assume that previous contents will exist between frames. You are strongly
// encouraged to call SDL_RenderClear() to initialize the backbuffer before
// starting each new frame's drawing, even if you plan to overwrite every
// pixel.
//
// `renderer` the rendering context
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_RenderClear
// See also: SDL_RenderDrawLine
// See also: SDL_RenderDrawLines
// See also: SDL_RenderDrawPoint
// See also: SDL_RenderDrawPoints
// See also: SDL_RenderDrawRect
// See also: SDL_RenderDrawRects
// See also: SDL_RenderFillRect
// See also: SDL_RenderFillRects
// See also: SDL_SetRenderDrawBlendMode
// See also: SDL_SetRenderDrawColor
pub fn render_present(renderer &Renderer) {
	C.SDL_RenderPresent(renderer)
}

fn C.SDL_DestroyTexture(texture &C.SDL_Texture)

// destroy_texture destroys the specified texture.
//
// Passing NULL or an otherwise invalid texture will set the SDL error message
// to "Invalid texture".
//
// `texture` the texture to destroy
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateTexture
// See also: SDL_CreateTextureFromSurface
pub fn destroy_texture(texture &Texture) {
	C.SDL_DestroyTexture(texture)
}

fn C.SDL_DestroyRenderer(renderer &C.SDL_Renderer)

// destroy_renderer destroys the rendering context for a window and free associated textures.
//
// `renderer` the rendering context
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateRenderer
pub fn destroy_renderer(renderer &Renderer) {
	C.SDL_DestroyRenderer(renderer)
}

fn C.SDL_RenderFlush(renderer &C.SDL_Renderer) int

// render_flush forces the rendering context to flush any pending commands to the underlying
// rendering API.
//
// You do not need to (and in fact, shouldn't) call this function unless you
// are planning to call into OpenGL/Direct3D/Metal/whatever directly in
// addition to using an SDL_Renderer.
//
// This is for a very-specific case: if you are using SDL's render API, you
// asked for a specific renderer backend (OpenGL, Direct3D, etc), you set
// SDL_HINT_RENDER_BATCHING to "1", and you plan to make OpenGL/D3D/whatever
// calls in addition to SDL render API calls. If all of this applies, you
// should call SDL_RenderFlush() between calls to SDL's render API and the
// low-level API you're using in cooperation.
//
// In all other cases, you can ignore this function. This is only here to get
// maximum performance out of a specific situation. In all other cases, SDL
// will do the right thing, perhaps at a performance loss.
//
// This function is first available in SDL 2.0.10, and is not needed in 2.0.9
// and earlier, as earlier versions did not queue rendering commands at all,
// instead flushing them to the OS immediately.
//
// `renderer` the rendering context
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.10.
pub fn render_flush(renderer &Renderer) int {
	return C.SDL_RenderFlush(renderer)
}

fn C.SDL_GL_BindTexture(texture &C.SDL_Texture, texw &f32, texh &f32) int

// gl_bind_texture binds an OpenGL/ES/ES2 texture to the current context.
//
// This is for use with OpenGL instructions when rendering OpenGL primitives
// directly.
//
// If not NULL, `texw` and `texh` will be filled with the width and height
// values suitable for the provided texture. In most cases, both will be 1.0,
// however, on systems that support the GL_ARB_texture_rectangle extension,
// these values will actually be the pixel width and height used to create the
// texture, so this factor needs to be taken into account when providing
// texture coordinates to OpenGL.
//
// You need a renderer to create an SDL_Texture, therefore you can only use
// this function with an implicit OpenGL context from SDL_CreateRenderer(),
// not with your own OpenGL context. If you need control over your OpenGL
// context, you need to write your own texture-loading methods.
//
// Also note that SDL may upload RGB textures as BGR (or vice-versa), and
// re-order the color channels in the shaders phase, so the uploaded texture
// may have swapped color channels.
//
// `texture` the texture to bind to the current OpenGL/ES/ES2 context
// `texw` a pointer to a float value which will be filled with the
//             texture width or NULL if you don't need that value
// `texh` a pointer to a float value which will be filled with the
//             texture height or NULL if you don't need that value
// returns 0 on success, or -1 if the operation is not supported; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_MakeCurrent
// See also: SDL_GL_UnbindTexture
pub fn gl_bind_texture(texture &Texture, texw &f32, texh &f32) int {
	return C.SDL_GL_BindTexture(texture, texw, texh)
}

fn C.SDL_GL_UnbindTexture(texture &C.SDL_Texture) int

// gl_unbind_texture unbinds an OpenGL/ES/ES2 texture from the current context.
//
// See SDL_GL_BindTexture() for examples on how to use these functions
//
// `texture` the texture to unbind from the current OpenGL/ES/ES2 context
// returns 0 on success, or -1 if the operation is not supported
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_BindTexture
// See also: SDL_GL_MakeCurrent
pub fn gl_unbind_texture(texture &Texture) int {
	return C.SDL_GL_UnbindTexture(texture)
}

fn C.SDL_RenderGetMetalLayer(renderer &C.SDL_Renderer) voidptr

// render_get_metal_layer gets the CAMetalLayer associated with the given Metal renderer.
//
// This function returns `void *`, so SDL doesn't have to include Metal's
// headers, but it can be safely cast to a `CAMetalLayer *`.
//
// `renderer` The renderer to query
// returns a `CAMetalLayer *` on success, or NULL if the renderer isn't a
//          Metal renderer
//
// NOTE This function is available since SDL 2.0.8.
//
// See also: SDL_RenderGetMetalCommandEncoder
pub fn render_get_metal_layer(renderer &Renderer) voidptr {
	return C.SDL_RenderGetMetalLayer(renderer)
}

fn C.SDL_RenderGetMetalCommandEncoder(renderer &C.SDL_Renderer) voidptr

// render_get_metal_command_encoder gets the Metal command encoder for the current frame
//
// This function returns `void *`, so SDL doesn't have to include Metal's
// headers, but it can be safely cast to an `id<MTLRenderCommandEncoder>`.
//
// Note that as of SDL 2.0.18, this will return NULL if Metal refuses to give
// SDL a drawable to render to, which might happen if the window is
// hidden/minimized/offscreen. This doesn't apply to command encoders for
// render targets, just the window's backbacker. Check your return values!
//
// `renderer` The renderer to query
// returns an `id<MTLRenderCommandEncoder>` on success, or NULL if the
//          renderer isn't a Metal renderer or there was an error.
//
// NOTE This function is available since SDL 2.0.8.
//
// See also: SDL_RenderGetMetalLayer
pub fn render_get_metal_command_encoder(renderer &Renderer) voidptr {
	return C.SDL_RenderGetMetalCommandEncoder(renderer)
}

fn C.SDL_RenderSetVSync(renderer &C.SDL_Renderer, vsync int) int

// render_set_v_sync toggles VSync of the given renderer.
//
// `renderer` The renderer to toggle
// `vsync` 1 for on, 0 for off. All other values are reserved
// returns a 0 int on success, or non-zero on failure
//
// NOTE This function is available since SDL 2.0.18.
pub fn render_set_v_sync(renderer &Renderer, vsync int) int {
	return C.SDL_RenderSetVSync(renderer, vsync)
}
