// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_render.h
//

// RendererFlags is C.SDL_RendererFlags
pub enum RendererFlags {
	software = C.SDL_RENDERER_SOFTWARE // 0x00000001 The renderer is a software fallback
	accelerated = C.SDL_RENDERER_ACCELERATED // 0x00000002 The renderer uses hardware acceleration
	presentvsync = C.SDL_RENDERER_PRESENTVSYNC // 0x00000004 Present is synchronized with the refresh rate
	targettexture = C.SDL_RENDERER_TARGETTEXTURE // 0x00000008
}

[typedef]
struct C.SDL_RendererInfo {
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

/**
 *  \brief Get the number of 2D rendering drivers available for the current
 *         display.
 *
 *  A render driver is a set of code that handles rendering and texture
 *  management on a particular display.  Normally there is only one, but
 *  some drivers may have several available with different capabilities.
 *
 *  \sa SDL_GetRenderDriverInfo()
 *  \sa SDL_CreateRenderer()
*/
fn C.SDL_GetNumRenderDrivers() int
pub fn get_num_render_drivers() int {
	return C.SDL_GetNumRenderDrivers()
}

/**
 *  \brief Get information about a specific 2D rendering driver for the current
 *         display.
 *
 *  \param index The index of the driver to query information about.
 *  \param info  A pointer to an SDL_RendererInfo struct to be filled with
 *               information on the rendering driver.
 *
 *  \return 0 on success, -1 if the index was out of range.
 *
 *  \sa SDL_CreateRenderer()
*/
fn C.SDL_GetRenderDriverInfo(index int, info &C.SDL_RendererInfo) int
pub fn get_render_driver_info(index int, info &RendererInfo) int {
	return C.SDL_GetRenderDriverInfo(index, info)
}

/**
 *  \brief Create a window and default renderer
 *
 *  \param width    The width of the window
 *  \param height   The height of the window
 *  \param window_flags The flags used to create the window
 *  \param window   A pointer filled with the window, or NULL on error
 *  \param renderer A pointer filled with the renderer, or NULL on error
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_CreateWindowAndRenderer(width int, height int, window_flags u32, window &&C.SDL_Window, renderer &&C.SDL_Renderer) int
pub fn create_window_and_renderer(width int, height int, window_flags u32, window &&Window, renderer &&Renderer) int {
	return C.SDL_CreateWindowAndRenderer(width, height, window_flags, window, renderer)
}

/**
 *  \brief Create a 2D rendering context for a window.
 *
 *  \param window The window where rendering is displayed.
 *  \param index    The index of the rendering driver to initialize, or -1 to
 *                  initialize the first one supporting the requested flags.
 *  \param flags    ::SDL_RendererFlags.
 *
 *  \return A valid rendering context or NULL if there was an error.
 *
 *  \sa SDL_CreateSoftwareRenderer()
 *  \sa SDL_GetRendererInfo()
 *  \sa SDL_DestroyRenderer()
*/
fn C.SDL_CreateRenderer(window &C.SDL_Window, index int, flags u32) &C.SDL_Renderer
pub fn create_renderer(window &Window, index int, flags u32) &Renderer {
	return C.SDL_CreateRenderer(window, index, flags)
}

/**
 *  \brief Create a 2D software rendering context for a surface.
 *
 *  \param surface The surface where rendering is done.
 *
 *  \return A valid rendering context or NULL if there was an error.
 *
 *  \sa SDL_CreateRenderer()
 *  \sa SDL_DestroyRenderer()
*/
fn C.SDL_CreateSoftwareRenderer(surface &C.SDL_Surface) &C.SDL_Renderer
pub fn create_software_renderer(surface &Surface) &Renderer {
	return C.SDL_CreateSoftwareRenderer(surface)
}

/**
 *  \brief Get the renderer associated with a window.
*/
fn C.SDL_GetRenderer(window &C.SDL_Window) &C.SDL_Renderer
pub fn get_renderer(window &Window) &Renderer {
	return C.SDL_GetRenderer(window)
}

/**
 *  \brief Get information about a rendering context.
*/
fn C.SDL_GetRendererInfo(renderer &C.SDL_Renderer, info &C.SDL_RendererInfo) int
pub fn get_renderer_info(renderer &Renderer, info &RendererInfo) int {
	return C.SDL_GetRendererInfo(renderer, info)
}

// extern DECLSPEC int SDLCALL SDL_GetRendererOutputSize(SDL_Renderer * renderer,                                                      int *w, int *h)
fn C.SDL_GetRendererOutputSize(renderer &C.SDL_Renderer, w &int, h &int) int
pub fn get_renderer_output_size(renderer &C.SDL_Renderer, w &int, h &int) int {
	return C.SDL_GetRendererOutputSize(renderer, w, h)
}

/**
 *  \brief Get the output size in pixels of a rendering context.
*/
fn C.SDL_CreateTexture(renderer &C.SDL_Renderer, format u32, access int, w int, h int) &C.SDL_Texture
pub fn create_texture(renderer &C.SDL_Renderer, format Format, access TextureAccess, w int, h int) &C.SDL_Texture {
	return C.SDL_CreateTexture(renderer, u32(format), int(access), w, h)
}

/**
 *  \brief Create a texture for a rendering context.
 *
 *  \param renderer The renderer.
 *  \param format The format of the texture.
 *  \param access One of the enumerated values in ::SDL_TextureAccess.
 *  \param w      The width of the texture in pixels.
 *  \param h      The height of the texture in pixels.
 *
 *  \return The created texture is returned, or NULL if no rendering context was
 *          active,  the format was unsupported, or the width or height were out
 *          of range.
 *
 *  \note The contents of the texture are not defined at creation.
 *
 *  \sa SDL_QueryTexture()
 *  \sa SDL_UpdateTexture()
 *  \sa SDL_DestroyTexture()
*/
fn C.SDL_CreateTextureFromSurface(renderer &C.SDL_Renderer, surface &C.SDL_Surface) &C.SDL_Texture
pub fn create_texture_from_surface(renderer &Renderer, surface &Surface) &Texture {
	return C.SDL_CreateTextureFromSurface(renderer, surface)
}

/**
 *  \brief Query the attributes of a texture
 *
 *  \param texture A texture to be queried.
 *  \param format  A pointer filled in with the raw format of the texture.  The
 *                 actual format may differ, but pixel transfers will use this
 *                 format.
 *  \param access  A pointer filled in with the actual access to the texture.
 *  \param w       A pointer filled in with the width of the texture in pixels.
 *  \param h       A pointer filled in with the height of the texture in pixels.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
*/
fn C.SDL_QueryTexture(texture &C.SDL_Texture, format &u32, access &int, w &int, h &int) int
pub fn query_texture(texture &Texture, format &u32, access &int, w &int, h &int) int {
	return C.SDL_QueryTexture(texture, format, access, w, h)
}

/**
 *  \brief Set an additional color value used in render copy operations.
 *
 *  \param texture The texture to update.
 *  \param r       The red color value multiplied into copy operations.
 *  \param g       The green color value multiplied into copy operations.
 *  \param b       The blue color value multiplied into copy operations.
 *
 *  \return 0 on success, or -1 if the texture is not valid or color modulation
 *          is not supported.
 *
 *  \sa SDL_GetTextureColorMod()
*/
fn C.SDL_SetTextureColorMod(texture &C.SDL_Texture, r byte, g byte, b byte) int
pub fn set_texture_color_mod(texture &Texture, r byte, g byte, b byte) int {
	return C.SDL_SetTextureColorMod(texture, r, g, b)
}

/**
 *  \brief Get the additional color value used in render copy operations.
 *
 *  \param texture The texture to query.
 *  \param r         A pointer filled in with the current red color value.
 *  \param g         A pointer filled in with the current green color value.
 *  \param b         A pointer filled in with the current blue color value.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *
 *  \sa SDL_SetTextureColorMod()
*/
fn C.SDL_GetTextureColorMod(texture &C.SDL_Texture, r &byte, g &byte, b &byte) int
pub fn get_texture_color_mod(texture &Texture, r &byte, g &byte, b &byte) int {
	return C.SDL_GetTextureColorMod(texture, r, g, b)
}

/**
 *  \brief Set an additional alpha value used in render copy operations.
 *
 *  \param texture The texture to update.
 *  \param alpha     The alpha value multiplied into copy operations.
 *
 *  \return 0 on success, or -1 if the texture is not valid or alpha modulation
 *          is not supported.
 *
 *  \sa SDL_GetTextureAlphaMod()
*/
fn C.SDL_SetTextureAlphaMod(texture &C.SDL_Texture, alpha byte) int
pub fn set_texture_alpha_mod(texture &Texture, alpha byte) int {
	return C.SDL_SetTextureAlphaMod(texture, alpha)
}

/**
 *  \brief Get the additional alpha value used in render copy operations.
 *
 *  \param texture The texture to query.
 *  \param alpha     A pointer filled in with the current alpha value.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *
 *  \sa SDL_SetTextureAlphaMod()
*/
fn C.SDL_GetTextureAlphaMod(texture &C.SDL_Texture, alpha &byte) int
pub fn get_texture_alpha_mod(texture &Texture, alpha &byte) int {
	return C.SDL_GetTextureAlphaMod(texture, alpha)
}

/**
 *  \brief Set the blend mode used for texture copy operations.
 *
 *  \param texture The texture to update.
 *  \param blendMode ::SDL_BlendMode to use for texture blending.
 *
 *  \return 0 on success, or -1 if the texture is not valid or the blend mode is
 *          not supported.
 *
 *  \note If the blend mode is not supported, the closest supported mode is
 *        chosen.
 *
 *  \sa SDL_GetTextureBlendMode()
*/
fn C.SDL_SetTextureBlendMode(texture &C.SDL_Texture, blend_mode C.SDL_BlendMode) int
pub fn set_texture_blend_mode(texture &Texture, blend_mode BlendMode) int {
	return C.SDL_SetTextureBlendMode(texture, C.SDL_BlendMode(blend_mode))
}

/**
 *  \brief Get the blend mode used for texture copy operations.
 *
 *  \param texture   The texture to query.
 *  \param blendMode A pointer filled in with the current blend mode.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *
 *  \sa SDL_SetTextureBlendMode()
*/
fn C.SDL_GetTextureBlendMode(texture &C.SDL_Texture, blend_mode &C.SDL_BlendMode) int
pub fn get_texture_blend_mode(texture &Texture, blend_mode &BlendMode) int {
	return C.SDL_GetTextureBlendMode(texture, unsafe { &C.SDL_BlendMode(blend_mode) })
}

/**
 *  \brief Update the given texture rectangle with new pixel data.
 *
 *  \param texture   The texture to update
 *  \param rect      A pointer to the rectangle of pixels to update, or NULL to
 *                   update the entire texture.
 *  \param pixels    The raw pixel data in the format of the texture.
 *  \param pitch     The number of bytes in a row of pixel data, including padding between lines.
 *
 *  The pixel data must be in the format of the texture. The pixel format can be
 *  queried with SDL_QueryTexture.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *
 *  \note This is a fairly slow function.
*/
fn C.SDL_UpdateTexture(texture &C.SDL_Texture, rect &C.SDL_Rect, pixels voidptr, pitch int) int
pub fn update_texture(texture &Texture, rect &Rect, pixels voidptr, pitch int) int {
	return C.SDL_UpdateTexture(texture, rect, pixels, pitch)
}

/**
 *  \brief Update a rectangle within a planar YV12 or IYUV texture with new pixel data.
 *
 *  \param texture   The texture to update
 *  \param rect      A pointer to the rectangle of pixels to update, or NULL to
 *                   update the entire texture.
 *  \param Yplane    The raw pixel data for the Y plane.
 *  \param Ypitch    The number of bytes between rows of pixel data for the Y plane.
 *  \param Uplane    The raw pixel data for the U plane.
 *  \param Upitch    The number of bytes between rows of pixel data for the U plane.
 *  \param Vplane    The raw pixel data for the V plane.
 *  \param Vpitch    The number of bytes between rows of pixel data for the V plane.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *
 *  \note You can use SDL_UpdateTexture() as long as your pixel data is
 *        a contiguous block of Y and U/V planes in the proper order, but
 *        this function is available if your pixel data is not contiguous.
*/
fn C.SDL_UpdateYUVTexture(texture &C.SDL_Texture, rect &C.SDL_Rect, yplane &byte, ypitch int, uplane &byte, upitch int, vplane &byte, vpitch int) int
pub fn update_y_u_v_texture(texture &Texture, rect &Rect, yplane &byte, ypitch int, uplane &byte, upitch int, vplane &byte, vpitch int) int {
	return C.SDL_UpdateYUVTexture(texture, rect, yplane, ypitch, uplane, upitch, vplane,
		vpitch)
}

/**
 *  \brief Lock a portion of the texture for write-only pixel access.
 *
 *  \param texture   The texture to lock for access, which was created with
 *                   ::SDL_TEXTUREACCESS_STREAMING.
 *  \param rect      A pointer to the rectangle to lock for access. If the rect
 *                   is NULL, the entire texture will be locked.
 *  \param pixels    This is filled in with a pointer to the locked pixels,
 *                   appropriately offset by the locked area.
 *  \param pitch     This is filled in with the pitch of the locked pixels.
 *
 *  \return 0 on success, or -1 if the texture is not valid or was not created with ::SDL_TEXTUREACCESS_STREAMING.
 *
 *  \sa SDL_UnlockTexture()
*/
fn C.SDL_LockTexture(texture &C.SDL_Texture, rect &C.SDL_Rect, pixels voidptr, pitch &int) int
pub fn lock_texture(texture &Texture, rect &Rect, pixels voidptr, pitch &int) int {
	return C.SDL_LockTexture(texture, rect, pixels, pitch)
}

/**
 *  \brief Unlock a texture, uploading the changes to video memory, if needed.
 *
 *  \sa SDL_LockTexture()
*/
fn C.SDL_UnlockTexture(texture &C.SDL_Texture)
pub fn unlock_texture(texture &Texture) {
	C.SDL_UnlockTexture(texture)
}

/**
 * \brief Determines whether a window supports the use of render targets
 *
 * \param renderer The renderer that will be checked
 *
 * \return SDL_TRUE if supported, SDL_FALSE if not.
*/
fn C.SDL_RenderTargetSupported(renderer &C.SDL_Renderer) bool
pub fn render_target_supported(renderer &Renderer) bool {
	return C.SDL_RenderTargetSupported(renderer)
}

/**
 * \brief Set a texture as the current rendering target.
 *
 * \param renderer The renderer.
 * \param texture The targeted texture, which must be created with the SDL_TEXTUREACCESS_TARGET flag, or NULL for the default render target
 *
 * \return 0 on success, or -1 on error
 *
 *  \sa SDL_GetRenderTarget()
*/
fn C.SDL_SetRenderTarget(renderer &C.SDL_Renderer, texture &C.SDL_Texture) int
pub fn set_render_target(renderer &Renderer, texture &Texture) int {
	return C.SDL_SetRenderTarget(renderer, texture)
}

/**
 * \brief Get the current render target or NULL for the default render target.
 *
 * \return The current render target
 *
 *  \sa SDL_SetRenderTarget()
*/
fn C.SDL_GetRenderTarget(renderer &C.SDL_Renderer) &C.SDL_Texture
pub fn get_render_target(renderer &Renderer) &Texture {
	return C.SDL_GetRenderTarget(renderer)
}

/**
 *  \brief Set device independent resolution for rendering
 *
 *  \param renderer The renderer for which resolution should be set.
 *  \param w      The width of the logical resolution
 *  \param h      The height of the logical resolution
 *
 *  This function uses the viewport and scaling functionality to allow a fixed logical
 *  resolution for rendering, regardless of the actual output resolution.  If the actual
 *  output resolution doesn't have the same aspect ratio the output rendering will be
 *  centered within the output display.
 *
 *  If the output display is a window, mouse events in the window will be filtered
 *  and scaled so they seem to arrive within the logical resolution.
 *
 *  \note If this function results in scaling or subpixel drawing by the
 *        rendering backend, it will be handled using the appropriate
 *        quality hints.
 *
 *  \sa SDL_RenderGetLogicalSize()
 *  \sa SDL_RenderSetScale()
 *  \sa SDL_RenderSetViewport()
*/
fn C.SDL_RenderSetLogicalSize(renderer &C.SDL_Renderer, w int, h int) int
pub fn render_set_logical_size(renderer &Renderer, w int, h int) int {
	return C.SDL_RenderSetLogicalSize(renderer, w, h)
}

/**
 *  \brief Get device independent resolution for rendering
 *
 *  \param renderer The renderer from which resolution should be queried.
 *  \param w      A pointer filled with the width of the logical resolution
 *  \param h      A pointer filled with the height of the logical resolution
 *
 *  \sa SDL_RenderSetLogicalSize()
*/
fn C.SDL_RenderGetLogicalSize(renderer &C.SDL_Renderer, w &int, h &int)
pub fn render_get_logical_size(renderer &Renderer, w &int, h &int) {
	C.SDL_RenderGetLogicalSize(renderer, w, h)
}

/**
 *  \brief Set whether to force integer scales for resolution-independent rendering
 *
 *  \param renderer The renderer for which integer scaling should be set.
 *  \param enable   Enable or disable integer scaling
 *
 *  This function restricts the logical viewport to integer values - that is, when
 *  a resolution is between two multiples of a logical size, the viewport size is
 *  rounded down to the lower multiple.
 *
 *  \sa SDL_RenderSetLogicalSize()
*/
fn C.SDL_RenderSetIntegerScale(renderer &C.SDL_Renderer, enable bool) int
pub fn render_set_integer_scale(renderer &Renderer, enable bool) int {
	return C.SDL_RenderSetIntegerScale(renderer, enable)
}

/**
 *  \brief Get whether integer scales are forced for resolution-independent rendering
 *
 *  \param renderer The renderer from which integer scaling should be queried.
 *
 *  \sa SDL_RenderSetIntegerScale()
*/
fn C.SDL_RenderGetIntegerScale(renderer &C.SDL_Renderer) bool
pub fn render_get_integer_scale(renderer &Renderer) bool {
	return C.SDL_RenderGetIntegerScale(renderer)
}

/**
 *  \brief Set the drawing area for rendering on the current target.
 *
 *  \param renderer The renderer for which the drawing area should be set.
 *  \param rect The rectangle representing the drawing area, or NULL to set the viewport to the entire target.
 *
 *  The x,y of the viewport rect represents the origin for rendering.
 *
 *  \return 0 on success, or -1 on error
 *
 *  \note If the window associated with the renderer is resized, the viewport is automatically reset.
 *
 *  \sa SDL_RenderGetViewport()
 *  \sa SDL_RenderSetLogicalSize()
*/
fn C.SDL_RenderSetViewport(renderer &C.SDL_Renderer, rect &C.SDL_Rect) int
pub fn render_set_viewport(renderer &C.SDL_Renderer, rect &C.SDL_Rect) int {
	return C.SDL_RenderSetViewport(renderer, rect)
}

/**
 *  \brief Get the drawing area for the current target.
 *
 *  \sa SDL_RenderSetViewport()
*/
fn C.SDL_RenderGetViewport(renderer &C.SDL_Renderer, rect &C.SDL_Rect)
pub fn render_get_viewport(renderer &Renderer, rect &Rect) {
	C.SDL_RenderGetViewport(renderer, rect)
}

/**
 *  \brief Set the clip rectangle for the current target.
 *
 *  \param renderer The renderer for which clip rectangle should be set.
 *  \param rect   A pointer to the rectangle to set as the clip rectangle, or
 *                NULL to disable clipping.
 *
 *  \return 0 on success, or -1 on error
 *
 *  \sa SDL_RenderGetClipRect()
*/
fn C.SDL_RenderSetClipRect(renderer &C.SDL_Renderer, rect &C.SDL_Rect) int
pub fn render_set_clip_rect(renderer &Renderer, rect &Rect) int {
	return C.SDL_RenderSetClipRect(renderer, rect)
}

/**
 *  \brief Get the clip rectangle for the current target.
 *
 *  \param renderer The renderer from which clip rectangle should be queried.
 *  \param rect   A pointer filled in with the current clip rectangle, or
 *                an empty rectangle if clipping is disabled.
 *
 *  \sa SDL_RenderSetClipRect()
*/
fn C.SDL_RenderGetClipRect(renderer &Renderer, rect &C.SDL_Rect)
pub fn render_get_clip_rect(renderer &Renderer, rect &Rect) {
	C.SDL_RenderGetClipRect(renderer, rect)
}

/**
 *  \brief Get whether clipping is enabled on the given renderer.
 *
 *  \param renderer The renderer from which clip state should be queried.
 *
 *  \sa SDL_RenderGetClipRect()
*/
fn C.SDL_RenderIsClipEnabled(renderer &C.SDL_Renderer) bool
pub fn render_is_clip_enabled(renderer &Renderer) bool {
	return C.SDL_RenderIsClipEnabled(renderer)
}

/**
 *  \brief Set the drawing scale for rendering on the current target.
 *
 *  \param renderer The renderer for which the drawing scale should be set.
 *  \param scaleX The horizontal scaling factor
 *  \param scaleY The vertical scaling factor
 *
 *  The drawing coordinates are scaled by the x/y scaling factors
 *  before they are used by the renderer.  This allows resolution
 *  independent drawing with a single coordinate system.
 *
 *  \note If this results in scaling or subpixel drawing by the
 *        rendering backend, it will be handled using the appropriate
 *        quality hints.  For best results use integer scaling factors.
 *
 *  \sa SDL_RenderGetScale()
 *  \sa SDL_RenderSetLogicalSize()
*/
fn C.SDL_RenderSetScale(renderer &C.SDL_Renderer, scale_x f32, scale_y f32) int
pub fn render_set_scale(renderer &Renderer, scale_x f32, scale_y f32) int {
	return C.SDL_RenderSetScale(renderer, scale_x, scale_y)
}

/**
 *  \brief Get the drawing scale for the current target.
 *
 *  \param renderer The renderer from which drawing scale should be queried.
 *  \param scaleX A pointer filled in with the horizontal scaling factor
 *  \param scaleY A pointer filled in with the vertical scaling factor
 *
 *  \sa SDL_RenderSetScale()
*/
fn C.SDL_RenderGetScale(renderer &C.SDL_Renderer, scale_x &f32, scale_y &f32)
pub fn render_get_scale(renderer &Renderer, scale_x &f32, scale_y &f32) {
	C.SDL_RenderGetScale(renderer, scale_x, scale_y)
}

/**
 *  \brief Set the color used for drawing operations (Rect, Line and Clear).
 *
 *  \param renderer The renderer for which drawing color should be set.
 *  \param r The red value used to draw on the rendering target.
 *  \param g The green value used to draw on the rendering target.
 *  \param b The blue value used to draw on the rendering target.
 *  \param a The alpha value used to draw on the rendering target, usually
 *           ::SDL_ALPHA_OPAQUE (255).
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_SetRenderDrawColor(renderer &C.SDL_Renderer, r byte, g byte, b byte, a byte) int
pub fn set_render_draw_color(renderer &Renderer, r byte, g byte, b byte, a byte) int {
	return C.SDL_SetRenderDrawColor(renderer, r, g, b, a)
}

/**
 *  \brief Get the color used for drawing operations (Rect, Line and Clear).
 *
 *  \param renderer The renderer from which drawing color should be queried.
 *  \param r A pointer to the red value used to draw on the rendering target.
 *  \param g A pointer to the green value used to draw on the rendering target.
 *  \param b A pointer to the blue value used to draw on the rendering target.
 *  \param a A pointer to the alpha value used to draw on the rendering target,
 *           usually ::SDL_ALPHA_OPAQUE (255).
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_GetRenderDrawColor(renderer &C.SDL_Renderer, r &byte, g &byte, b &byte, a &byte) int
pub fn get_render_draw_color(renderer &Renderer, r &byte, g &byte, b &byte, a &byte) int {
	return C.SDL_GetRenderDrawColor(renderer, r, g, b, a)
}

/**
 *  \brief Set the blend mode used for drawing operations (Fill and Line).
 *
 *  \param renderer The renderer for which blend mode should be set.
 *  \param blendMode ::SDL_BlendMode to use for blending.
 *
 *  \return 0 on success, or -1 on error
 *
 *  \note If the blend mode is not supported, the closest supported mode is
 *        chosen.
 *
 *  \sa SDL_GetRenderDrawBlendMode()
*/
fn C.SDL_SetRenderDrawBlendMode(renderer &C.SDL_Renderer, blend_mode C.SDL_BlendMode) int
pub fn set_render_draw_blend_mode(renderer &Renderer, blend_mode BlendMode) int {
	return C.SDL_SetRenderDrawBlendMode(renderer, C.SDL_BlendMode(blend_mode))
}

/**
 *  \brief Get the blend mode used for drawing operations.
 *
 *  \param renderer The renderer from which blend mode should be queried.
 *  \param blendMode A pointer filled in with the current blend mode.
 *
 *  \return 0 on success, or -1 on error
 *
 *  \sa SDL_SetRenderDrawBlendMode()
*/
fn C.SDL_GetRenderDrawBlendMode(renderer &C.SDL_Renderer, blend_mode &C.SDL_BlendMode) int
pub fn get_render_draw_blend_mode(renderer &Renderer, blend_mode &BlendMode) int {
	return C.SDL_GetRenderDrawBlendMode(renderer, unsafe { &C.SDL_BlendMode(blend_mode) })
}

/**
 *  \brief Clear the current rendering target with the drawing color
 *
 *  This function clears the entire rendering target, ignoring the viewport and
 *  the clip rectangle.
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderClear(renderer &C.SDL_Renderer) int
pub fn render_clear(renderer &Renderer) int {
	return C.SDL_RenderClear(renderer)
}

/**
 *  \brief Draw a point on the current rendering target.
 *
 *  \param renderer The renderer which should draw a point.
 *  \param x The x coordinate of the point.
 *  \param y The y coordinate of the point.
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderDrawPoint(renderer &C.SDL_Renderer, x int, y int) int
pub fn render_draw_point(renderer &Renderer, x int, y int) int {
	return C.SDL_RenderDrawPoint(renderer, x, y)
}

/**
 *  \brief Draw multiple points on the current rendering target.
 *
 *  \param renderer The renderer which should draw multiple points.
 *  \param points The points to draw
 *  \param count The number of points to draw
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderDrawPoints(renderer &C.SDL_Renderer, points &C.SDL_Point, count int) int
pub fn render_draw_points(renderer &Renderer, points &Point, count int) int {
	return C.SDL_RenderDrawPoints(renderer, points, count)
}

/**
 *  \brief Draw a line on the current rendering target.
 *
 *  \param renderer The renderer which should draw a line.
 *  \param x1 The x coordinate of the start point.
 *  \param y1 The y coordinate of the start point.
 *  \param x2 The x coordinate of the end point.
 *  \param y2 The y coordinate of the end point.
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderDrawLine(renderer &C.SDL_Renderer, x1 int, y1 int, x2 int, y2 int) int
pub fn render_draw_line(renderer &Renderer, x1 int, y1 int, x2 int, y2 int) int {
	return C.SDL_RenderDrawLine(renderer, x1, y1, x2, y2)
}

/**
 *  \brief Draw a series of connected lines on the current rendering target.
 *
 *  \param renderer The renderer which should draw multiple lines.
 *  \param points The points along the lines
 *  \param count The number of points, drawing count-1 lines
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderDrawLines(renderer &C.SDL_Renderer, points &C.SDL_Point, count int) int
pub fn render_draw_lines(renderer &Renderer, points &Point, count int) int {
	return C.SDL_RenderDrawLines(renderer, points, count)
}

/**
 *  \brief Draw a rectangle on the current rendering target.
 *
 *  \param renderer The renderer which should draw a rectangle.
 *  \param rect A pointer to the destination rectangle, or NULL to outline the entire rendering target.
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderDrawRect(renderer &C.SDL_Renderer, rect &C.SDL_Rect) int
pub fn render_draw_rect(renderer &Renderer, rect &Rect) int {
	return C.SDL_RenderDrawRect(renderer, rect)
}

/**
 *  \brief Draw some number of rectangles on the current rendering target.
 *
 *  \param renderer The renderer which should draw multiple rectangles.
 *  \param rects A pointer to an array of destination rectangles.
 *  \param count The number of rectangles.
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderDrawRects(renderer &C.SDL_Renderer, rects &C.SDL_Rect, count int) int
pub fn render_draw_rects(renderer &Renderer, rects &Rect, count int) int {
	return C.SDL_RenderDrawRects(renderer, rects, count)
}

/**
 *  \brief Fill a rectangle on the current rendering target with the drawing color.
 *
 *  \param renderer The renderer which should fill a rectangle.
 *  \param rect A pointer to the destination rectangle, or NULL for the entire
 *              rendering target.
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderFillRect(renderer &C.SDL_Renderer, rect &C.SDL_Rect) int
pub fn render_fill_rect(renderer &Renderer, rect &Rect) int {
	return C.SDL_RenderFillRect(renderer, rect)
}

/**
 *  \brief Fill some number of rectangles on the current rendering target with the drawing color.
 *
 *  \param renderer The renderer which should fill multiple rectangles.
 *  \param rects A pointer to an array of destination rectangles.
 *  \param count The number of rectangles.
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderFillRects(renderer &C.SDL_Renderer, rects &C.SDL_Rect, count int) int
pub fn render_fill_rects(renderer &Renderer, rects &Rect, count int) int {
	return C.SDL_RenderFillRects(renderer, rects, count)
}

/**
 *  \brief Copy a portion of the texture to the current rendering target.
 *
 *  \param renderer The renderer which should copy parts of a texture.
 *  \param texture The source texture.
 *  \param srcrect   A pointer to the source rectangle, or NULL for the entire
 *                   texture.
 *  \param dstrect   A pointer to the destination rectangle, or NULL for the
 *                   entire rendering target.
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderCopy(renderer &C.SDL_Renderer, texture &C.SDL_Texture, srcrect &C.SDL_Rect, dstrect &C.SDL_Rect) int
pub fn render_copy(renderer &Renderer, texture &Texture, srcrect &Rect, dstrect &Rect) int {
	return C.SDL_RenderCopy(renderer, texture, srcrect, dstrect)
}

/**
 *  \brief Copy a portion of the source texture to the current rendering target, rotating it by angle around the given center
 *
 *  \param renderer The renderer which should copy parts of a texture.
 *  \param texture The source texture.
 *  \param srcrect   A pointer to the source rectangle, or NULL for the entire
 *                   texture.
 *  \param dstrect   A pointer to the destination rectangle, or NULL for the
 *                   entire rendering target.
 *  \param angle    An angle in degrees that indicates the rotation that will be applied to dstrect, rotating it in a clockwise direction
 *  \param center   A pointer to a point indicating the point around which dstrect will be rotated (if NULL, rotation will be done around dstrect.w/2, dstrect.h/2).
 *  \param flip     An SDL_RendererFlip value stating which flipping actions should be performed on the texture
 *
 *  \return 0 on success, or -1 on error
*/
fn C.SDL_RenderCopyEx(renderer &C.SDL_Renderer, texture &C.SDL_Texture, srcrect &C.SDL_Rect, dstrect &C.SDL_Rect, angle f64, center &C.SDL_Point, flip C.SDL_RendererFlip) int
pub fn render_copy_ex(renderer &Renderer, texture &Texture, srcrect &Rect, dstrect &Rect, angle f64, center &Point, flip RendererFlip) int {
	return C.SDL_RenderCopyEx(renderer, texture, srcrect, dstrect, angle, center, C.SDL_RendererFlip(int(flip)))
}

/**
 *  \brief Read pixels from the current rendering target.
 *
 *  \param renderer The renderer from which pixels should be read.
 *  \param rect   A pointer to the rectangle to read, or NULL for the entire
 *                render target.
 *  \param format The desired format of the pixel data, or 0 to use the format
 *                of the rendering target
 *  \param pixels A pointer to be filled in with the pixel data
 *  \param pitch  The pitch of the pixels parameter.
 *
 *  \return 0 on success, or -1 if pixel reading is not supported.
 *
 *  \warning This is a very slow operation, and should not be used frequently.
*/
fn C.SDL_RenderReadPixels(renderer &C.SDL_Renderer, rect &C.SDL_Rect, format u32, pixels voidptr, pitch int) int
pub fn render_read_pixels(renderer &Renderer, rect &Rect, format u32, pixels voidptr, pitch int) int {
	return C.SDL_RenderReadPixels(renderer, rect, format, pixels, pitch)
}

/**
 *  \brief Update the screen with rendering performed.
*/
fn C.SDL_RenderPresent(renderer &C.SDL_Renderer)
pub fn render_present(renderer &Renderer) {
	C.SDL_RenderPresent(renderer)
}

/**
 *  \brief Destroy the specified texture.
 *
 *  \sa SDL_CreateTexture()
 *  \sa SDL_CreateTextureFromSurface()
*/
fn C.SDL_DestroyTexture(texture &C.SDL_Texture)
pub fn destroy_texture(texture &Texture) {
	C.SDL_DestroyTexture(texture)
}

/**
 *  \brief Destroy the rendering context for a window and free associated
 *         textures.
 *
 *  \sa SDL_CreateRenderer()
*/
fn C.SDL_DestroyRenderer(renderer &C.SDL_Renderer)
pub fn destroy_renderer(renderer &Renderer) {
	C.SDL_DestroyRenderer(renderer)
}

/**
 *  \brief Bind the texture to the current OpenGL/ES/ES2 context for use with
 *         OpenGL instructions.
 *
 *  \param texture  The SDL texture to bind
 *  \param texw     A pointer to a float that will be filled with the texture width
 *  \param texh     A pointer to a float that will be filled with the texture height
 *
 *  \return 0 on success, or -1 if the operation is not supported
*/
fn C.SDL_GL_BindTexture(texture &C.SDL_Texture, texw &f32, texh &f32) int
pub fn gl_bind_texture(texture &Texture, texw &f32, texh &f32) int {
	return C.SDL_GL_BindTexture(texture, texw, texh)
}

/**
 *  \brief Unbind a texture from the current OpenGL/ES/ES2 context.
 *
 *  \param texture  The SDL texture to unbind
 *
 *  \return 0 on success, or -1 if the operation is not supported
*/
fn C.SDL_GL_UnbindTexture(texture &C.SDL_Texture) int
pub fn gl_unbind_texture(texture &Texture) int {
	return C.SDL_GL_UnbindTexture(texture)
}

/**
 *  \brief Get the CAMetalLayer associated with the given Metal renderer
 *
 *  \param renderer The renderer to query
 *
 *  \return CAMetalLayer* on success, or NULL if the renderer isn't a Metal renderer
 *
 *  \sa SDL_RenderGetMetalCommandEncoder()
*/
fn C.SDL_RenderGetMetalLayer(renderer &C.SDL_Renderer) voidptr
pub fn render_get_metal_layer(renderer &Renderer) voidptr {
	return C.SDL_RenderGetMetalLayer(renderer)
}

/**
 *  \brief Get the Metal command encoder for the current frame
 *
 *  \param renderer The renderer to query
 *
 *  \return id<MTLRenderCommandEncoder> on success, or NULL if the renderer isn't a Metal renderer
 *
 *  \sa SDL_RenderGetMetalLayer()
*/
fn C.SDL_RenderGetMetalCommandEncoder(renderer &C.SDL_Renderer) voidptr
pub fn render_get_metal_command_encoder(renderer &Renderer) voidptr {
	return C.SDL_RenderGetMetalCommandEncoder(renderer)
}
