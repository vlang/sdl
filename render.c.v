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
	software = C.SDL_RENDERER_SOFTWARE // 0x00000001 The renderer is a software fallback
	accelerated = C.SDL_RENDERER_ACCELERATED // 0x00000002 The renderer uses hardware acceleration
	presentvsync = C.SDL_RENDERER_PRESENTVSYNC // 0x00000004 Present is synchronized with the refresh rate
	targettexture = C.SDL_RENDERER_TARGETTEXTURE // 0x00000008
}

[typedef]
struct C.SDL_RendererInfo {
pub:
	name                &char   // The name of the renderer
	flags               u32     // Supported ::SDL_RendererFlags
	num_texture_formats u32     // The number of available texture formats
	texture_formats     [16]u32 // The available texture formats
	max_texture_width   int     // The maximum texture width
	max_texture_height  int     // The maximum texture height
}

pub type RendererInfo = C.SDL_RendererInfo

// TextureAccess is C.SDL_TextureAccess
pub enum TextureAccess {
	@static = C.SDL_TEXTUREACCESS_STATIC // Changes rarely, not lockable
	streaming = C.SDL_TEXTUREACCESS_STREAMING // Changes frequently, lockable
	target = C.SDL_TEXTUREACCESS_TARGET // Texture can be used as a render target
}

// TextureModulate is C.SDL_TextureModulate
pub enum TextureModulate {
	@none = C.SDL_TEXTUREMODULATE_NONE // 0x00000000  No modulation
	color = C.SDL_TEXTUREMODULATE_COLOR // 0x00000001 srcC = srcC * color
	alpha = C.SDL_TEXTUREMODULATE_ALPHA // 0x00000002  srcA = srcA * alpha
}

// RendererFlip is C.SDL_RendererFlip
pub enum RendererFlip {
	@none = C.SDL_FLIP_NONE // 0x00000000 Do not flip
	horizontal = C.SDL_FLIP_HORIZONTAL // 0x00000001 flip horizontally
	vertical = C.SDL_FLIP_VERTICAL // 0x00000002  flip vertically
}

[typedef]
struct C.SDL_Renderer {
}

pub type Renderer = C.SDL_Renderer

[typedef]
struct C.SDL_Texture {
}

pub type Texture = C.SDL_Texture

fn C.SDL_GetNumRenderDrivers() int

// get_num_render_drivers gets the number of 2D rendering drivers available for the current
// display.
//
// A render driver is a set of code that handles rendering and texture
// management on a particular display.  Normally there is only one, but
// some drivers may have several available with different capabilities.
//
// See also: SDL_GetRenderDriverInfo()
// See also: SDL_CreateRenderer()
pub fn get_num_render_drivers() int {
	return C.SDL_GetNumRenderDrivers()
}

fn C.SDL_GetRenderDriverInfo(index int, info &C.SDL_RendererInfo) int

// get_render_driver_info gets information about a specific 2D rendering driver for the current
// display.
//
// `index` The index of the driver to query information about.
// `info`  A pointer to an SDL_RendererInfo struct to be filled with
// information on the rendering driver.
//
// returns 0 on success, -1 if the index was out of range.
//
// See also: SDL_CreateRenderer()
pub fn get_render_driver_info(index int, info &RendererInfo) int {
	return C.SDL_GetRenderDriverInfo(index, info)
}

fn C.SDL_CreateWindowAndRenderer(width int, height int, window_flags u32, window &&C.SDL_Window, renderer &&C.SDL_Renderer) int

// create_window_and_renderer creates a window and default renderer
//
// `width`    The width of the window
// `height`   The height of the window
// `window_flags` The flags used to create the window
// `window`   A pointer filled with the window, or NULL on error
// `renderer` A pointer filled with the renderer, or NULL on error
//
// returns 0 on success, or -1 on error
pub fn create_window_and_renderer(width int, height int, window_flags u32, window &&Window, renderer &&Renderer) int {
	return C.SDL_CreateWindowAndRenderer(width, height, window_flags, window, renderer)
}

fn C.SDL_CreateRenderer(window &C.SDL_Window, index int, flags u32) &C.SDL_Renderer

// create_renderer creates a 2D rendering context for a window.
//
// `window` The window where rendering is displayed.
// `index`    The index of the rendering driver to initialize, or -1 to
// initialize the first one supporting the requested flags.
// `flags`    ::SDL_RendererFlags.
//
// returns A valid rendering context or NULL if there was an error.
//
// See also: SDL_CreateSoftwareRenderer()
// See also: SDL_GetRendererInfo()
// See also: SDL_DestroyRenderer()
pub fn create_renderer(window &Window, index int, flags u32) &Renderer {
	return C.SDL_CreateRenderer(window, index, flags)
}

fn C.SDL_CreateSoftwareRenderer(surface &C.SDL_Surface) &C.SDL_Renderer

// create_software_renderer creates a 2D software rendering context for a surface.
//
// `surface` The surface where rendering is done.
//
// returns A valid rendering context or NULL if there was an error.
//
// See also: SDL_CreateRenderer()
// See also: SDL_DestroyRenderer()
pub fn create_software_renderer(surface &Surface) &Renderer {
	return C.SDL_CreateSoftwareRenderer(surface)
}

fn C.SDL_GetRenderer(window &C.SDL_Window) &C.SDL_Renderer

// get_renderer gets the renderer associated with a window.
pub fn get_renderer(window &Window) &Renderer {
	return C.SDL_GetRenderer(window)
}

fn C.SDL_GetRendererInfo(renderer &C.SDL_Renderer, info &C.SDL_RendererInfo) int

// get_renderer_info gets information about a rendering context.
pub fn get_renderer_info(renderer &Renderer, info &RendererInfo) int {
	return C.SDL_GetRendererInfo(renderer, info)
}

fn C.SDL_GetRendererOutputSize(renderer &C.SDL_Renderer, w &int, h &int) int

// get_renderer_output_size gets the output size in pixels of a rendering context.
pub fn get_renderer_output_size(renderer &Renderer, w &int, h &int) int {
	return C.SDL_GetRendererOutputSize(renderer, w, h)
}

fn C.SDL_CreateTexture(renderer &C.SDL_Renderer, format u32, access int, w int, h int) &C.SDL_Texture

// create_texture creates a texture for a rendering context.
//
// `renderer` The renderer.
// `format` The format of the texture.
// `access` One of the enumerated values in ::SDL_TextureAccess.
// `w`      The width of the texture in pixels.
// `h`      The height of the texture in pixels.
//
// returns The created texture is returned, or NULL if no rendering context was
// active,  the format was unsupported, or the width or height were out
// of range.
//
// NOTE The contents of the texture are not defined at creation.
//
// See also: SDL_QueryTexture()
// See also: SDL_UpdateTexture()
// See also: SDL_DestroyTexture()
pub fn create_texture(renderer &Renderer, format Format, access TextureAccess, w int, h int) &Texture {
	return C.SDL_CreateTexture(renderer, u32(format), int(access), w, h)
}

fn C.SDL_CreateTextureFromSurface(renderer &C.SDL_Renderer, surface &C.SDL_Surface) &C.SDL_Texture

// create_texture_from_surface creates a texture from an existing surface.
//
// `renderer` The renderer.
// `surface` The surface containing pixel data used to fill the texture.
//
// returns The created texture is returned, or NULL on error.
//
// NOTE The surface is not modified or freed by this function.
//
// See also: SDL_QueryTexture()
// See also: SDL_DestroyTexture()

pub fn create_texture_from_surface(renderer &Renderer, surface &Surface) &Texture {
	return C.SDL_CreateTextureFromSurface(renderer, surface)
}

fn C.SDL_QueryTexture(texture &C.SDL_Texture, format &u32, access &int, w &int, h &int) int

// query_texture queries the attributes of a texture
//
// `texture` A texture to be queried.
// `format`  A pointer filled in with the raw format of the texture.  The
// actual format may differ, but pixel transfers will use this
// format.
// `access`  A pointer filled in with the actual access to the texture.
// `w`       A pointer filled in with the width of the texture in pixels.
// `h`       A pointer filled in with the height of the texture in pixels.
//
// returns 0 on success, or -1 if the texture is not valid.
pub fn query_texture(texture &Texture, format &u32, access &int, w &int, h &int) int {
	return C.SDL_QueryTexture(texture, format, access, w, h)
}

fn C.SDL_SetTextureColorMod(texture &C.SDL_Texture, r byte, g byte, b byte) int

// set_texture_color_mod sets an additional color value used in render copy operations.
//
// `texture` The texture to update.
// `r`       The red color value multiplied into copy operations.
// `g`       The green color value multiplied into copy operations.
// `b`       The blue color value multiplied into copy operations.
//
// returns 0 on success, or -1 if the texture is not valid or color modulation
// is not supported.
//
// See also: SDL_GetTextureColorMod()
pub fn set_texture_color_mod(texture &Texture, r byte, g byte, b byte) int {
	return C.SDL_SetTextureColorMod(texture, r, g, b)
}

fn C.SDL_GetTextureColorMod(texture &C.SDL_Texture, r &byte, g &byte, b &byte) int

// get_texture_color_mod gets the additional color value used in render copy operations.
//
// `texture` The texture to query.
// `r`         A pointer filled in with the current red color value.
// `g`         A pointer filled in with the current green color value.
// `b`         A pointer filled in with the current blue color value.
//
// returns 0 on success, or -1 if the texture is not valid.
//
// See also: SDL_SetTextureColorMod()
pub fn get_texture_color_mod(texture &Texture, r &byte, g &byte, b &byte) int {
	return C.SDL_GetTextureColorMod(texture, r, g, b)
}

fn C.SDL_SetTextureAlphaMod(texture &C.SDL_Texture, alpha byte) int

// set_texture_alpha_mod sets an additional alpha value used in render copy operations.
//
// `texture` The texture to update.
// `alpha`     The alpha value multiplied into copy operations.
//
// returns 0 on success, or -1 if the texture is not valid or alpha modulation
// is not supported.
//
// See also: SDL_GetTextureAlphaMod()
pub fn set_texture_alpha_mod(texture &Texture, alpha byte) int {
	return C.SDL_SetTextureAlphaMod(texture, alpha)
}

fn C.SDL_GetTextureAlphaMod(texture &C.SDL_Texture, alpha &byte) int

// get_texture_alpha_mod gets the additional alpha value used in render copy operations.
//
// `texture` The texture to query.
// `alpha`     A pointer filled in with the current alpha value.
//
// returns 0 on success, or -1 if the texture is not valid.
//
// See also: SDL_SetTextureAlphaMod()
pub fn get_texture_alpha_mod(texture &Texture, alpha &byte) int {
	return C.SDL_GetTextureAlphaMod(texture, alpha)
}

fn C.SDL_SetTextureBlendMode(texture &C.SDL_Texture, blend_mode C.SDL_BlendMode) int

// set_texture_blend_mode sets the blend mode used for texture copy operations.
//
// `texture` The texture to update.
// `blendMode` ::SDL_BlendMode to use for texture blending.
//
// returns 0 on success, or -1 if the texture is not valid or the blend mode is
// not supported.
//
// NOTE If the blend mode is not supported, the closest supported mode is
// chosen.
//
// See also: SDL_GetTextureBlendMode()
pub fn set_texture_blend_mode(texture &Texture, blend_mode BlendMode) int {
	return C.SDL_SetTextureBlendMode(texture, C.SDL_BlendMode(blend_mode))
}

fn C.SDL_GetTextureBlendMode(texture &C.SDL_Texture, blend_mode &C.SDL_BlendMode) int

// get_texture_blend_mode gets the blend mode used for texture copy operations.
//
// `texture`   The texture to query.
// `blendMode` A pointer filled in with the current blend mode.
//
// returns 0 on success, or -1 if the texture is not valid.
//
// See also: SDL_SetTextureBlendMode()
pub fn get_texture_blend_mode(texture &Texture, blend_mode &BlendMode) int {
	return C.SDL_GetTextureBlendMode(texture, unsafe { &C.SDL_BlendMode(blend_mode) })
}

fn C.SDL_UpdateTexture(texture &C.SDL_Texture, const_rect &C.SDL_Rect, const_pixels voidptr, pitch int) int

// update_texture updates the given texture rectangle with new pixel data.
//
// `texture`   The texture to update
// `rect`      A pointer to the rectangle of pixels to update, or NULL to
// update the entire texture.
// `pixels`    The raw pixel data in the format of the texture.
// `pitch`     The number of bytes in a row of pixel data, including padding between lines.
//
// The pixel data must be in the format of the texture. The pixel format can be
// queried with SDL_QueryTexture.
//
// returns 0 on success, or -1 if the texture is not valid.
//
// NOTE This is a fairly slow function.
pub fn update_texture(texture &Texture, const_rect &Rect, const_pixels voidptr, pitch int) int {
	return C.SDL_UpdateTexture(texture, const_rect, const_pixels, pitch)
}

fn C.SDL_UpdateYUVTexture(texture &C.SDL_Texture, const_rect &C.SDL_Rect, const_yplane &byte, ypitch int, const_uplane &byte, upitch int, const_vplane &byte, vpitch int) int

// update_yuv_texture updates a rectangle within a planar YV12 or IYUV texture with new pixel data.
//
// `texture`   The texture to update
// `rect`      A pointer to the rectangle of pixels to update, or NULL to
// update the entire texture.
// `Yplane`    The raw pixel data for the Y plane.
// `Ypitch`    The number of bytes between rows of pixel data for the Y plane.
// `Uplane`    The raw pixel data for the U plane.
// `Upitch`    The number of bytes between rows of pixel data for the U plane.
// `Vplane`    The raw pixel data for the V plane.
// `Vpitch`    The number of bytes between rows of pixel data for the V plane.
//
// returns 0 on success, or -1 if the texture is not valid.
//
// NOTE You can use SDL_UpdateTexture() as long as your pixel data is
// a contiguous block of Y and U/V planes in the proper order, but
// this function is available if your pixel data is not contiguous.
pub fn update_yuv_texture(texture &Texture, const_rect &Rect, const_yplane &byte, ypitch int, const_uplane &byte, upitch int, const_vplane &byte, vpitch int) int {
	return C.SDL_UpdateYUVTexture(texture, const_rect, const_yplane, ypitch, const_uplane,
		upitch, const_vplane, vpitch)
}

fn C.SDL_LockTexture(texture &C.SDL_Texture, const_rect &C.SDL_Rect, pixels voidptr, pitch &int) int

// lock_texture locks a portion of the texture for write-only pixel access.
//
// `texture`   The texture to lock for access, which was created with
// ::SDL_TEXTUREACCESS_STREAMING.
// `rect`      A pointer to the rectangle to lock for access. If the rect
// is NULL, the entire texture will be locked.
// `pixels`    This is filled in with a pointer to the locked pixels,
// appropriately offset by the locked area.
// `pitch`     This is filled in with the pitch of the locked pixels.
//
// returns 0 on success, or -1 if the texture is not valid or was not created with ::SDL_TEXTUREACCESS_STREAMING.
//
// See also: SDL_UnlockTexture()
pub fn lock_texture(texture &Texture, const_rect &Rect, pixels voidptr, pitch &int) int {
	return C.SDL_LockTexture(texture, const_rect, pixels, pitch)
}

fn C.SDL_UnlockTexture(texture &C.SDL_Texture)

// unlock_texture unlocks a texture, uploading the changes to video memory, if needed.
//
// See also: SDL_LockTexture()
pub fn unlock_texture(texture &Texture) {
	C.SDL_UnlockTexture(texture)
}

fn C.SDL_RenderTargetSupported(renderer &C.SDL_Renderer) bool

// render_target_supported determines whether a window supports the use of render targets
//
// `renderer` The renderer that will be checked
//
// returns SDL_TRUE if supported, SDL_FALSE if not.
pub fn render_target_supported(renderer &Renderer) bool {
	return C.SDL_RenderTargetSupported(renderer)
}

fn C.SDL_SetRenderTarget(renderer &C.SDL_Renderer, texture &C.SDL_Texture) int

// set_render_target sets a texture as the current rendering target.
//
// `renderer` The renderer.
// `texture` The targeted texture, which must be created with the SDL_TEXTUREACCESS_TARGET flag, or NULL for the default render target
//
// returns 0 on success, or -1 on error
//
// See also: SDL_GetRenderTarget()
pub fn set_render_target(renderer &Renderer, texture &Texture) int {
	return C.SDL_SetRenderTarget(renderer, texture)
}

fn C.SDL_GetRenderTarget(renderer &C.SDL_Renderer) &C.SDL_Texture

// get_render_target gets the current render target or NULL for the default render target.
//
// returns The current render target
//
// See also: SDL_SetRenderTarget()
pub fn get_render_target(renderer &Renderer) &Texture {
	return C.SDL_GetRenderTarget(renderer)
}

fn C.SDL_RenderSetLogicalSize(renderer &C.SDL_Renderer, w int, h int) int

// render_set_logical_size sets device independent resolution for rendering
//
// `renderer` The renderer for which resolution should be set.
// `w`      The width of the logical resolution
// `h`      The height of the logical resolution
//
// This function uses the viewport and scaling functionality to allow a fixed logical
// resolution for rendering, regardless of the actual output resolution.  If the actual
// output resolution doesn't have the same aspect ratio the output rendering will be
// centered within the output display.
//
// If the output display is a window, mouse events in the window will be filtered
// and scaled so they seem to arrive within the logical resolution.
//
// NOTE If this function results in scaling or subpixel drawing by the
// rendering backend, it will be handled using the appropriate
// quality hints.
//
// See also: SDL_RenderGetLogicalSize()
// See also: SDL_RenderSetScale()
// See also: SDL_RenderSetViewport()
pub fn render_set_logical_size(renderer &Renderer, w int, h int) int {
	return C.SDL_RenderSetLogicalSize(renderer, w, h)
}

fn C.SDL_RenderGetLogicalSize(renderer &C.SDL_Renderer, w &int, h &int)

// render_get_logical_size gets device independent resolution for rendering
//
// `renderer` The renderer from which resolution should be queried.
// `w`      A pointer filled with the width of the logical resolution
// `h`      A pointer filled with the height of the logical resolution
//
// See also: SDL_RenderSetLogicalSize()
pub fn render_get_logical_size(renderer &Renderer, w &int, h &int) {
	C.SDL_RenderGetLogicalSize(renderer, w, h)
}

fn C.SDL_RenderSetIntegerScale(renderer &C.SDL_Renderer, enable bool) int

// render_set_integer_scale sets whether to force integer scales for resolution-independent rendering
//
// `renderer` The renderer for which integer scaling should be set.
// `enable`   Enable or disable integer scaling
//
// This function restricts the logical viewport to integer values - that is, when
// a resolution is between two multiples of a logical size, the viewport size is
// rounded down to the lower multiple.
//
// See also: SDL_RenderSetLogicalSize()
pub fn render_set_integer_scale(renderer &Renderer, enable bool) int {
	return C.SDL_RenderSetIntegerScale(renderer, enable)
}

fn C.SDL_RenderGetIntegerScale(renderer &C.SDL_Renderer) bool

// render_get_integer_scale gets whether integer scales are forced for resolution-independent rendering
//
// `renderer` The renderer from which integer scaling should be queried.
//
// See also: SDL_RenderSetIntegerScale()
pub fn render_get_integer_scale(renderer &Renderer) bool {
	return C.SDL_RenderGetIntegerScale(renderer)
}

fn C.SDL_RenderSetViewport(renderer &C.SDL_Renderer, const_rect &C.SDL_Rect) int

// render_set_viewport sets the drawing area for rendering on the current target.
//
// `renderer` The renderer for which the drawing area should be set.
// `rect` The rectangle representing the drawing area, or NULL to set the viewport to the entire target.
//
// The x,y of the viewport rect represents the origin for rendering.
//
// returns 0 on success, or -1 on error
//
// NOTE If the window associated with the renderer is resized, the viewport is automatically reset.
//
// See also: SDL_RenderGetViewport()
// See also: SDL_RenderSetLogicalSize()
pub fn render_set_viewport(renderer &Renderer, const_rect &Rect) int {
	return C.SDL_RenderSetViewport(renderer, const_rect)
}

fn C.SDL_RenderGetViewport(renderer &C.SDL_Renderer, rect &C.SDL_Rect)

// render_get_viewport gets the drawing area for the current target.
//
// See also: SDL_RenderSetViewport()
pub fn render_get_viewport(renderer &Renderer, rect &Rect) {
	C.SDL_RenderGetViewport(renderer, rect)
}

fn C.SDL_RenderSetClipRect(renderer &C.SDL_Renderer, const_rect &C.SDL_Rect) int

// render_set_clip_rect sets the clip rectangle for the current target.
//
// `renderer` The renderer for which clip rectangle should be set.
// `rect`   A pointer to the rectangle to set as the clip rectangle, or
// NULL to disable clipping.
//
// returns 0 on success, or -1 on error
//
// See also: SDL_RenderGetClipRect()
pub fn render_set_clip_rect(renderer &Renderer, const_rect &Rect) int {
	return C.SDL_RenderSetClipRect(renderer, const_rect)
}

fn C.SDL_RenderGetClipRect(renderer &Renderer, rect &C.SDL_Rect)

// render_get_clip_rect gets the clip rectangle for the current target.
//
// `renderer` The renderer from which clip rectangle should be queried.
// `rect`   A pointer filled in with the current clip rectangle, or
// an empty rectangle if clipping is disabled.
//
// See also: SDL_RenderSetClipRect()
pub fn render_get_clip_rect(renderer &Renderer, rect &Rect) {
	C.SDL_RenderGetClipRect(renderer, rect)
}

fn C.SDL_RenderIsClipEnabled(renderer &C.SDL_Renderer) bool

// render_is_clip_enabled gets whether clipping is enabled on the given renderer.
//
// `renderer` The renderer from which clip state should be queried.
//
// See also: SDL_RenderGetClipRect()
pub fn render_is_clip_enabled(renderer &Renderer) bool {
	return C.SDL_RenderIsClipEnabled(renderer)
}

fn C.SDL_RenderSetScale(renderer &C.SDL_Renderer, scale_x f32, scale_y f32) int

// render_set_scale sets the drawing scale for rendering on the current target.
//
// `renderer` The renderer for which the drawing scale should be set.
// `scaleX` The horizontal scaling factor
// `scaleY` The vertical scaling factor
//
// The drawing coordinates are scaled by the x/y scaling factors
// before they are used by the renderer.  This allows resolution
// independent drawing with a single coordinate system.
//
// NOTE If this results in scaling or subpixel drawing by the
// rendering backend, it will be handled using the appropriate
// quality hints.  For best results use integer scaling factors.
//
// See also: SDL_RenderGetScale()
// See also: SDL_RenderSetLogicalSize()
pub fn render_set_scale(renderer &Renderer, scale_x f32, scale_y f32) int {
	return C.SDL_RenderSetScale(renderer, scale_x, scale_y)
}

fn C.SDL_RenderGetScale(renderer &C.SDL_Renderer, scale_x &f32, scale_y &f32)

// render_get_scale gets the drawing scale for the current target.
//
// `renderer` The renderer from which drawing scale should be queried.
// `scaleX` A pointer filled in with the horizontal scaling factor
// `scaleY` A pointer filled in with the vertical scaling factor
//
// See also: SDL_RenderSetScale()
pub fn render_get_scale(renderer &Renderer, scale_x &f32, scale_y &f32) {
	C.SDL_RenderGetScale(renderer, scale_x, scale_y)
}

fn C.SDL_SetRenderDrawColor(renderer &C.SDL_Renderer, r byte, g byte, b byte, a byte) int

// set_render_draw_color sets the color used for drawing operations (Rect, Line and Clear).
//
// `renderer` The renderer for which drawing color should be set.
// `r` The red value used to draw on the rendering target.
// `g` The green value used to draw on the rendering target.
// `b` The blue value used to draw on the rendering target.
// `a` The alpha value used to draw on the rendering target, usually
// ::SDL_ALPHA_OPAQUE (255).
//
// returns 0 on success, or -1 on error
pub fn set_render_draw_color(renderer &Renderer, r byte, g byte, b byte, a byte) int {
	return C.SDL_SetRenderDrawColor(renderer, r, g, b, a)
}

fn C.SDL_GetRenderDrawColor(renderer &C.SDL_Renderer, r &byte, g &byte, b &byte, a &byte) int

// get_render_draw_color gets the color used for drawing operations (Rect, Line and Clear).
//
// `renderer` The renderer from which drawing color should be queried.
// `r` A pointer to the red value used to draw on the rendering target.
// `g` A pointer to the green value used to draw on the rendering target.
// `b` A pointer to the blue value used to draw on the rendering target.
// `a` A pointer to the alpha value used to draw on the rendering target,
// usually ::SDL_ALPHA_OPAQUE (255).
//
// returns 0 on success, or -1 on error
pub fn get_render_draw_color(renderer &Renderer, r &byte, g &byte, b &byte, a &byte) int {
	return C.SDL_GetRenderDrawColor(renderer, r, g, b, a)
}

fn C.SDL_SetRenderDrawBlendMode(renderer &C.SDL_Renderer, blend_mode C.SDL_BlendMode) int

// set_render_draw_blend_mode sets the blend mode used for drawing operations (Fill and Line).
//
// `renderer` The renderer for which blend mode should be set.
// `blendMode` ::SDL_BlendMode to use for blending.
//
// returns 0 on success, or -1 on error
//
// NOTE If the blend mode is not supported, the closest supported mode is
// chosen.
//
// See also: SDL_GetRenderDrawBlendMode()
pub fn set_render_draw_blend_mode(renderer &Renderer, blend_mode BlendMode) int {
	return C.SDL_SetRenderDrawBlendMode(renderer, C.SDL_BlendMode(blend_mode))
}

fn C.SDL_GetRenderDrawBlendMode(renderer &C.SDL_Renderer, blend_mode &C.SDL_BlendMode) int

// get_render_draw_blend_mode gets the blend mode used for drawing operations.
//
// `renderer` The renderer from which blend mode should be queried.
// `blendMode` A pointer filled in with the current blend mode.
//
// returns 0 on success, or -1 on error
//
// See also: SDL_SetRenderDrawBlendMode()
pub fn get_render_draw_blend_mode(renderer &Renderer, blend_mode &BlendMode) int {
	return C.SDL_GetRenderDrawBlendMode(renderer, unsafe { &C.SDL_BlendMode(blend_mode) })
}

fn C.SDL_RenderClear(renderer &C.SDL_Renderer) int

// render_clear clears the current rendering target with the drawing color
//
// This function clears the entire rendering target, ignoring the viewport and
// the clip rectangle.
//
// returns 0 on success, or -1 on error
pub fn render_clear(renderer &Renderer) int {
	return C.SDL_RenderClear(renderer)
}

fn C.SDL_RenderDrawPoint(renderer &C.SDL_Renderer, x int, y int) int

// render_draw_point draws a point on the current rendering target.
//
// `renderer` The renderer which should draw a point.
// `x` The x coordinate of the point.
// `y` The y coordinate of the point.
//
// returns 0 on success, or -1 on error
pub fn render_draw_point(renderer &Renderer, x int, y int) int {
	return C.SDL_RenderDrawPoint(renderer, x, y)
}

fn C.SDL_RenderDrawPoints(renderer &C.SDL_Renderer, const_points &C.SDL_Point, count int) int

// render_draw_points draws multiple points on the current rendering target.
//
// `renderer` The renderer which should draw multiple points.
// `points` The points to draw
// `count` The number of points to draw
//
// returns 0 on success, or -1 on error
pub fn render_draw_points(renderer &Renderer, const_points &Point, count int) int {
	return C.SDL_RenderDrawPoints(renderer, const_points, count)
}

fn C.SDL_RenderDrawLine(renderer &C.SDL_Renderer, x1 int, y1 int, x2 int, y2 int) int

// render_draw_line draws a line on the current rendering target.
//
// `renderer` The renderer which should draw a line.
// `x`1 The x coordinate of the start point.
// `y`1 The y coordinate of the start point.
// `x`2 The x coordinate of the end point.
// `y`2 The y coordinate of the end point.
//
// returns 0 on success, or -1 on error
pub fn render_draw_line(renderer &Renderer, x1 int, y1 int, x2 int, y2 int) int {
	return C.SDL_RenderDrawLine(renderer, x1, y1, x2, y2)
}

fn C.SDL_RenderDrawLines(renderer &C.SDL_Renderer, const_points &C.SDL_Point, count int) int

// render_draw_lines draws a series of connected lines on the current rendering target.
//
// `renderer` The renderer which should draw multiple lines.
// `points` The points along the lines
// `count` The number of points, drawing count-1 lines
//
// returns 0 on success, or -1 on error
pub fn render_draw_lines(renderer &Renderer, const_points &Point, count int) int {
	return C.SDL_RenderDrawLines(renderer, const_points, count)
}

fn C.SDL_RenderDrawRect(renderer &C.SDL_Renderer, const_rect &C.SDL_Rect) int

// render_draw_rect draws a rectangle on the current rendering target.
//
// `renderer` The renderer which should draw a rectangle.
// `rect` A pointer to the destination rectangle, or NULL to outline the entire rendering target.
//
// returns 0 on success, or -1 on error
pub fn render_draw_rect(renderer &Renderer, const_rect &Rect) int {
	return C.SDL_RenderDrawRect(renderer, const_rect)
}

fn C.SDL_RenderDrawRects(renderer &C.SDL_Renderer, const_rects &C.SDL_Rect, count int) int

// render_draw_rects draws some number of rectangles on the current rendering target.
//
// `renderer` The renderer which should draw multiple rectangles.
// `rects` A pointer to an array of destination rectangles.
// `count` The number of rectangles.
//
// returns 0 on success, or -1 on error
pub fn render_draw_rects(renderer &Renderer, const_rects &Rect, count int) int {
	return C.SDL_RenderDrawRects(renderer, const_rects, count)
}

fn C.SDL_RenderFillRect(renderer &C.SDL_Renderer, const_rect &C.SDL_Rect) int

// render_fill_rect fills a rectangle on the current rendering target with the drawing color.
//
// `renderer` The renderer which should fill a rectangle.
// `rect` A pointer to the destination rectangle, or NULL for the entire
// rendering target.
//
// returns 0 on success, or -1 on error
pub fn render_fill_rect(renderer &Renderer, const_rect &Rect) int {
	return C.SDL_RenderFillRect(renderer, const_rect)
}

fn C.SDL_RenderFillRects(renderer &C.SDL_Renderer, const_rects &C.SDL_Rect, count int) int

// render_fill_rects fills some number of rectangles on the current rendering target with the drawing color.
//
// `renderer` The renderer which should fill multiple rectangles.
// `rects` A pointer to an array of destination rectangles.
// `count` The number of rectangles.
//
// returns 0 on success, or -1 on error
pub fn render_fill_rects(renderer &Renderer, const_rects &Rect, count int) int {
	return C.SDL_RenderFillRects(renderer, const_rects, count)
}

fn C.SDL_RenderCopy(renderer &C.SDL_Renderer, texture &C.SDL_Texture, const_srcrect &C.SDL_Rect, const_dstrect &C.SDL_Rect) int

// render_copy copies a portion of the texture to the current rendering target.
//
// `renderer` The renderer which should copy parts of a texture.
// `texture` The source texture.
// `srcrect`   A pointer to the source rectangle, or NULL for the entire
// texture.
// `dstrect`   A pointer to the destination rectangle, or NULL for the
// entire rendering target.
//
// returns 0 on success, or -1 on error
pub fn render_copy(renderer &Renderer, texture &Texture, const_srcrect &Rect, const_dstrect &Rect) int {
	return C.SDL_RenderCopy(renderer, texture, const_srcrect, const_dstrect)
}

fn C.SDL_RenderCopyEx(renderer &C.SDL_Renderer, texture &C.SDL_Texture, const_srcrect &C.SDL_Rect, const_dstrect &C.SDL_Rect, const_angle f64, const_center &C.SDL_Point, const_flip C.SDL_RendererFlip) int

// render_copy_ex copies a portion of the source texture to the current rendering target, rotating it by angle around the given center
//
// `renderer` The renderer which should copy parts of a texture.
// `texture` The source texture.
// `srcrect`   A pointer to the source rectangle, or NULL for the entire
// texture.
// `dstrect`   A pointer to the destination rectangle, or NULL for the
// entire rendering target.
// `angle`    An angle in degrees that indicates the rotation that will be applied to dstrect, rotating it in a clockwise direction
// `center`   A pointer to a point indicating the point around which dstrect will be rotated (if NULL, rotation will be done around dstrect.w/2, dstrect.h/2).
// `flip`     An SDL_RendererFlip value stating which flipping actions should be performed on the texture
//
// returns 0 on success, or -1 on error
pub fn render_copy_ex(renderer &Renderer, texture &Texture, const_srcrect &Rect, const_dstrect &Rect, const_angle f64, const_center &Point, const_flip RendererFlip) int {
	return C.SDL_RenderCopyEx(renderer, texture, const_srcrect, const_dstrect, const_angle,
		const_center, C.SDL_RendererFlip(int(const_flip)))
}

fn C.SDL_RenderDrawPointF(renderer &C.SDL_Renderer, x f32, y f32) int

// render_draw_point_f draws a point on the current rendering target.
//
//  `renderer` The renderer which should draw a point.
//  `x` The x coordinate of the point.
//  `y` The y coordinate of the point.
//
//  returns 0 on success, or -1 on error
///
pub fn render_draw_point_f(renderer &Renderer, x f32, y f32) int {
	return C.SDL_RenderDrawPointF(renderer, x, y)
}

fn C.SDL_RenderDrawPointsF(renderer &C.SDL_Renderer, const_points &C.SDL_FPoint, count int) int

// render_draw_points_f draws multiple points on the current rendering target.
//
//  `renderer` The renderer which should draw multiple points.
//  `points` The points to draw
//  `count` The number of points to draw
//
//  returns 0 on success, or -1 on error
///
pub fn render_draw_points_f(renderer &Renderer, const_points &FPoint, count int) int {
	return C.SDL_RenderDrawPointsF(renderer, const_points, count)
}

fn C.SDL_RenderDrawLineF(renderer &C.SDL_Renderer, x1 f32, y1 f32, x2 f32, y2 f32) int

// render_draw_line_f draws a line on the current rendering target.
//
//  `renderer` The renderer which should draw a line.
//  `x`1 The x coordinate of the start point.
//  `y`1 The y coordinate of the start point.
//  `x`2 The x coordinate of the end point.
//  `y`2 The y coordinate of the end point.
//
//  returns 0 on success, or -1 on error
///
pub fn render_draw_line_f(renderer &Renderer, x1 f32, y1 f32, x2 f32, y2 f32) int {
	return C.SDL_RenderDrawLineF(renderer, x1, y1, x2, y2)
}

fn C.SDL_RenderDrawLinesF(renderer &C.SDL_Renderer, const_points &C.SDL_FPoint, count int) int

// render_draw_lines_f draws a series of connected lines on the current rendering target.
//
//  `renderer` The renderer which should draw multiple lines.
//  `points` The points along the lines
//  `count` The number of points, drawing count-1 lines
//
//  returns 0 on success, or -1 on error
///
pub fn render_draw_lines_f(renderer &Renderer, const_points &FPoint, count int) int {
	return C.SDL_RenderDrawLinesF(renderer, const_points, count)
}

fn C.SDL_RenderDrawRectF(renderer &C.SDL_Renderer, const_rect &C.SDL_FRect) int

// render_draw_rect_f draws a rectangle on the current rendering target.
//
//  `renderer` The renderer which should draw a rectangle.
//  `rect` A pointer to the destination rectangle, or NULL to outline the entire rendering target.
//
//  returns 0 on success, or -1 on error
///
pub fn render_draw_rect_f(renderer &Renderer, const_rect &FRect) int {
	return C.SDL_RenderDrawRectF(renderer, const_rect)
}

fn C.SDL_RenderDrawRectsF(renderer &C.SDL_Renderer, const_rects &C.SDL_FRect, count int) int

// render_draw_rects_f draws some number of rectangles on the current rendering target.
//
//  `renderer` The renderer which should draw multiple rectangles.
//  `rects` A pointer to an array of destination rectangles.
//  `count` The number of rectangles.
//
//  returns 0 on success, or -1 on error
///
pub fn render_draw_rects_f(renderer &Renderer, const_rects &FRect, count int) int {
	return C.SDL_RenderDrawRectsF(renderer, const_rects, count)
}

fn C.SDL_RenderFillRectF(renderer &C.SDL_Renderer, const_rect &C.SDL_FRect) int

// render_fill_rect_f fills a rectangle on the current rendering target with the drawing color.
//
//  `renderer` The renderer which should fill a rectangle.
//  `rect` A pointer to the destination rectangle, or NULL for the entire
//              rendering target.
//
//  returns 0 on success, or -1 on error
///
pub fn render_fill_rect_f(renderer &Renderer, const_rect &FRect) int {
	return C.SDL_RenderFillRectF(renderer, const_rect)
}

fn C.SDL_RenderFillRectsF(renderer &C.SDL_Renderer, const_rects &C.SDL_FRect, count int) int

// render_fill_rects_f fills some number of rectangles on the current rendering target with the drawing color.
//
//  `renderer` The renderer which should fill multiple rectangles.
//  `rects` A pointer to an array of destination rectangles.
//  `count` The number of rectangles.
//
//  returns 0 on success, or -1 on error
///
pub fn render_fill_rects_f(renderer &Renderer, const_rects &FRect, count int) int {
	return C.SDL_RenderFillRectsF(renderer, const_rects, count)
}

fn C.SDL_RenderCopyF(renderer &C.SDL_Renderer, texture &C.SDL_Texture, const_srcrect &C.SDL_Rect, const_dstrect &C.SDL_FRect) int

// render_copy_f copys a portion of the texture to the current rendering target.
//
//  `renderer` The renderer which should copy parts of a texture.
//  `texture` The source texture.
//  `srcrect`   A pointer to the source rectangle, or NULL for the entire
//                   texture.
//  `dstrect`   A pointer to the destination rectangle, or NULL for the
//                   entire rendering target.
//
//  returns 0 on success, or -1 on error
///
pub fn render_copy_f(renderer &Renderer, texture &Texture, const_srcrect &Rect, const_dstrect &FRect) int {
	return C.SDL_RenderCopyF(renderer, texture, const_srcrect, const_dstrect)
}

fn C.SDL_RenderCopyExF(renderer &C.SDL_Renderer, texture &C.SDL_Texture, const_srcrect &C.SDL_Rect, const_dstrect &C.SDL_FRect, const_angle f64, const_center &C.SDL_FPoint, const_flip C.SDL_RendererFlip) int

// render_copy_ex_f copys a portion of the source texture to the current rendering target, rotating it by angle around the given center
//
//  `renderer` The renderer which should copy parts of a texture.
//  `texture` The source texture.
//  `srcrect`   A pointer to the source rectangle, or NULL for the entire
//                   texture.
//  `dstrect`   A pointer to the destination rectangle, or NULL for the
//                   entire rendering target.
//  `angle`    An angle in degrees that indicates the rotation that will be applied to dstrect, rotating it in a clockwise direction
//  `center`   A pointer to a point indicating the point around which dstrect will be rotated (if NULL, rotation will be done around dstrect.w/2, dstrect.h/2).
//  `flip`     An SDL_RendererFlip value stating which flipping actions should be performed on the texture
//
//  returns 0 on success, or -1 on error
///
pub fn render_copy_ex_f(renderer &Renderer, texture &Texture, const_srcrect &Rect, const_dstrect &FRect, const_angle f64, const_center &FPoint, const_flip RendererFlip) int {
	return C.SDL_RenderCopyExF(renderer, texture, const_srcrect, const_dstrect, const_angle,
		const_center, C.SDL_RendererFlip(int(const_flip)))
}

fn C.SDL_RenderReadPixels(renderer &C.SDL_Renderer, const_rect &C.SDL_Rect, format u32, pixels voidptr, pitch int) int

// render_read_pixels reads pixels from the current rendering target.
//
// `renderer` The renderer from which pixels should be read.
// `rect`   A pointer to the rectangle to read, or NULL for the entire
// render target.
// `format` The desired format of the pixel data, or 0 to use the format
// of the rendering target
// `pixels` A pointer to be filled in with the pixel data
// `pitch`  The pitch of the pixels parameter.
//
// returns 0 on success, or -1 if pixel reading is not supported.
//
// WARNING This is a very slow operation, and should not be used frequently.
pub fn render_read_pixels(renderer &Renderer, const_rect &Rect, format u32, pixels voidptr, pitch int) int {
	return C.SDL_RenderReadPixels(renderer, const_rect, format, pixels, pitch)
}

fn C.SDL_RenderPresent(renderer &C.SDL_Renderer)

// render_present updates the screen with rendering performed.
pub fn render_present(renderer &Renderer) {
	C.SDL_RenderPresent(renderer)
}

fn C.SDL_DestroyTexture(texture &C.SDL_Texture)

// destroy_texture destroys the specified texture.
//
// See also: SDL_CreateTexture()
// See also: SDL_CreateTextureFromSurface()
pub fn destroy_texture(texture &Texture) {
	C.SDL_DestroyTexture(texture)
}

fn C.SDL_DestroyRenderer(renderer &C.SDL_Renderer)

// destroy_renderer destroys the rendering context for a window and free associated
// textures.
//
// See also: SDL_CreateRenderer()
pub fn destroy_renderer(renderer &Renderer) {
	C.SDL_DestroyRenderer(renderer)
}

fn C.SDL_RenderFlush(renderer &C.SDL_Renderer) int

// render_flush forces the rendering context to flush any pending commands to the
//              underlying rendering API.
//
//  You do not need to (and in fact, shouldn't) call this function unless
//  you are planning to call into OpenGL/Direct3D/Metal/whatever directly
//  in addition to using an SDL_Renderer.
//
//  This is for a very-specific case: if you are using SDL's render API,
//  you asked for a specific renderer backend (OpenGL, Direct3D, etc),
//  you set SDL_HINT_RENDER_BATCHING to "1", and you plan to make
//  OpenGL/D3D/whatever calls in addition to SDL render API calls. If all of
//  this applies, you should call SDL_RenderFlush() between calls to SDL's
//  render API and the low-level API you're using in cooperation.
//
//  In all other cases, you can ignore this function. This is only here to
//  get maximum performance out of a specific situation. In all other cases,
//  SDL will do the right thing, perhaps at a performance loss.
//
//  This function is first available in SDL 2.0.10, and is not needed in
//  2.0.9 and earlier, as earlier versions did not queue rendering commands
//  at all, instead flushing them to the OS immediately.
///
pub fn render_flush(renderer &Renderer) int {
	return C.SDL_RenderFlush(renderer)
}

fn C.SDL_GL_BindTexture(texture &C.SDL_Texture, texw &f32, texh &f32) int

// gl_bind_texture binds the texture to the current OpenGL/ES/ES2 context for use with
// OpenGL instructions.
//
// `texture`  The SDL texture to bind
// `texw`     A pointer to a float that will be filled with the texture width
// `texh`     A pointer to a float that will be filled with the texture height
//
// returns 0 on success, or -1 if the operation is not supported
pub fn gl_bind_texture(texture &Texture, texw &f32, texh &f32) int {
	return C.SDL_GL_BindTexture(texture, texw, texh)
}

fn C.SDL_GL_UnbindTexture(texture &C.SDL_Texture) int

// gl_unbind_texture unbinds a texture from the current OpenGL/ES/ES2 context.
//
// `texture`  The SDL texture to unbind
//
// returns 0 on success, or -1 if the operation is not supported
pub fn gl_unbind_texture(texture &Texture) int {
	return C.SDL_GL_UnbindTexture(texture)
}

fn C.SDL_RenderGetMetalLayer(renderer &C.SDL_Renderer) voidptr

// render_get_metal_layer gets the CAMetalLayer associated with the given Metal renderer
//
// `renderer` The renderer to query
//
// returns CAMetalLayer* on success, or NULL if the renderer isn't a Metal renderer
//
// See also: SDL_RenderGetMetalCommandEncoder()
pub fn render_get_metal_layer(renderer &Renderer) voidptr {
	return C.SDL_RenderGetMetalLayer(renderer)
}

fn C.SDL_RenderGetMetalCommandEncoder(renderer &C.SDL_Renderer) voidptr

// render_get_metal_command_encoder gets the Metal command encoder for the current frame
//
// `renderer` The renderer to query
//
// returns id<MTLRenderCommandEncoder> on success, or NULL if the renderer isn't a Metal renderer
//
// See also: SDL_RenderGetMetalLayer()
pub fn render_get_metal_command_encoder(renderer &Renderer) voidptr {
	return C.SDL_RenderGetMetalCommandEncoder(renderer)
}
