// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_render.h
//

// Header file for SDL 2D rendering functions.
//
// This API supports the following features:
//
// - single pixel points
// - single pixel lines
// - filled rectangles
// - texture images
// - 2D polygons
//
// The primitives may be drawn in opaque, blended, or additive modes.
//
// The texture images may be drawn in opaque, blended, or additive modes. They
// can have an additional color tint or alpha modulation applied to them, and
// may also be stretched with linear interpolation.
//
// This API is designed to accelerate simple 2D operations. You may want more
// functionality such as polygons and particle effects and in that case you
// should use SDL's OpenGL/Direct3D support, the SDL3 GPU API, or one of the
// many good 3D engines.
//
// These functions must be called from the main thread. See this bug for
// details: https://github.com/libsdl-org/SDL/issues/986

// The name of the software renderer.
//
// NOTE: This macro is available since SDL 3.2.0.
pub const software_renderer = C.SDL_SOFTWARE_RENDERER // 'software'

@[typedef]
pub struct C.SDL_Vertex {
pub mut:
	position  FPoint // Vertex position, in SDL_Renderer coordinates
	color     FColor // Vertex color
	tex_coord FPoint // Normalized texture coordinates, if needed
}

pub type Vertex = C.SDL_Vertex

// TextureAccess is C.SDL_TextureAccess
pub enum TextureAccess {
	static    = C.SDL_TEXTUREACCESS_STATIC    // `static` Changes rarely, not lockable
	streaming = C.SDL_TEXTUREACCESS_STREAMING // `streaming` Changes frequently, lockable
	target    = C.SDL_TEXTUREACCESS_TARGET    // `target` Texture can be used as a render target
}

// RendererLogicalPresentation is C.SDL_RendererLogicalPresentation
pub enum RendererLogicalPresentation {
	disabled      = C.SDL_LOGICAL_PRESENTATION_DISABLED      // `disabled` There is no logical size in effect
	stretch       = C.SDL_LOGICAL_PRESENTATION_STRETCH       // `stretch` The rendered content is stretched to the output resolution
	letterbox     = C.SDL_LOGICAL_PRESENTATION_LETTERBOX     // `letterbox` The rendered content is fit to the largest dimension and the other dimension is letterboxed with black bars
	overscan      = C.SDL_LOGICAL_PRESENTATION_OVERSCAN      // `overscan` The rendered content is fit to the smallest dimension and the other dimension extends beyond the output bounds
	integer_scale = C.SDL_LOGICAL_PRESENTATION_INTEGER_SCALE // `integer_scale` The rendered content is scaled up by integer multiples to fit the output resolution
}

@[noinit; typedef]
pub struct C.SDL_Renderer {
	// NOTE: Opaque type
}

pub type Renderer = C.SDL_Renderer

@[noinit; typedef]
pub struct C.SDL_Texture {
	// NOTE: Opaque type
}

pub type Texture = C.SDL_Texture

// C.SDL_GetNumRenderDrivers [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumRenderDrivers)
fn C.SDL_GetNumRenderDrivers() int

// get_num_render_drivers gets the number of 2D rendering drivers available for the current display.
//
// A render driver is a set of code that handles rendering and texture
// management on a particular display. Normally there is only one, but some
// drivers may have several available with different capabilities.
//
// There may be none if SDL was compiled without render support.
//
// returns the number of built in render drivers.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_renderer (SDL_CreateRenderer)
// See also: get_render_driver (SDL_GetRenderDriver)
pub fn get_num_render_drivers() int {
	return C.SDL_GetNumRenderDrivers()
}

// C.SDL_GetRenderDriver [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderDriver)
fn C.SDL_GetRenderDriver(index int) &char

// get_render_driver uses this function to get the name of a built in 2D rendering driver.
//
// The list of rendering drivers is given in the order that they are normally
// initialized by default; the drivers that seem more reasonable to choose
// first (as far as the SDL developers believe) are earlier in the list.
//
// The names of drivers are all simple, low-ASCII identifiers, like "opengl",
// "direct3d12" or "metal". These never have Unicode characters, and are not
// meant to be proper names.
//
// `index` index the index of the rendering driver; the value ranges from 0 to
//              SDL_GetNumRenderDrivers() - 1.
// returns the name of the rendering driver at the requested index, or NULL
//          if an invalid index was specified.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_render_drivers (SDL_GetNumRenderDrivers)
pub fn get_render_driver(index int) &char {
	return &char(C.SDL_GetRenderDriver(index))
}

// C.SDL_CreateWindowAndRenderer [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateWindowAndRenderer)
fn C.SDL_CreateWindowAndRenderer(const_title &char, width int, height int, window_flags WindowFlags, window &&Window, renderer &&Renderer) bool

// create_window_and_renderer creates a window and default renderer.
//
// `title` title the title of the window, in UTF-8 encoding.
// `width` width the width of the window.
// `height` height the height of the window.
// `window_flags` window_flags the flags used to create the window (see
//                     SDL_CreateWindow()).
// `window` window a pointer filled with the window, or NULL on error.
// `renderer` renderer a pointer filled with the renderer, or NULL on error.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_renderer (SDL_CreateRenderer)
// See also: create_window (SDL_CreateWindow)
pub fn create_window_and_renderer(const_title &char, width int, height int, window_flags WindowFlags, window &&Window, renderer &&Renderer) bool {
	return C.SDL_CreateWindowAndRenderer(const_title, width, height, window_flags, window,
		renderer)
}

// C.SDL_CreateRenderer [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateRenderer)
fn C.SDL_CreateRenderer(window &Window, const_name &char) &Renderer

// create_renderer creates a 2D rendering context for a window.
//
// If you want a specific renderer, you can specify its name here. A list of
// available renderers can be obtained by calling SDL_GetRenderDriver()
// multiple times, with indices from 0 to SDL_GetNumRenderDrivers()-1. If you
// don't need a specific renderer, specify NULL and SDL will attempt to choose
// the best option for you, based on what is available on the user's system.
//
// If `name` is a comma-separated list, SDL will try each name, in the order
// listed, until one succeeds or all of them fail.
//
// By default the rendering size matches the window size in pixels, but you
// can call SDL_SetRenderLogicalPresentation() to change the content size and
// scaling options.
//
// `window` window the window where rendering is displayed.
// `name` name the name of the rendering driver to initialize, or NULL to let
//             SDL choose one.
// returns a valid rendering context or NULL if there was an error; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_renderer_with_properties (SDL_CreateRendererWithProperties)
// See also: create_software_renderer (SDL_CreateSoftwareRenderer)
// See also: destroy_renderer (SDL_DestroyRenderer)
// See also: get_num_render_drivers (SDL_GetNumRenderDrivers)
// See also: get_render_driver (SDL_GetRenderDriver)
// See also: get_renderer_name (SDL_GetRendererName)
pub fn create_renderer(window &Window, const_name &char) &Renderer {
	return C.SDL_CreateRenderer(window, const_name)
}

// C.SDL_CreateRendererWithProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateRendererWithProperties)
fn C.SDL_CreateRendererWithProperties(props PropertiesID) &Renderer

// create_renderer_with_properties creates a 2D rendering context for a window, with the specified properties.
//
// These are the supported properties:
//
// - `SDL_PROP_RENDERER_CREATE_NAME_STRING`: the name of the rendering driver
//   to use, if a specific one is desired
// - `SDL_PROP_RENDERER_CREATE_WINDOW_POINTER`: the window where rendering is
//   displayed, required if this isn't a software renderer using a surface
// - `SDL_PROP_RENDERER_CREATE_SURFACE_POINTER`: the surface where rendering
//   is displayed, if you want a software renderer without a window
// - `SDL_PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER`: an SDL_Colorspace
//   value describing the colorspace for output to the display, defaults to
//   SDL_COLORSPACE_SRGB. The direct3d11, direct3d12, and metal renderers
//   support SDL_COLORSPACE_SRGB_LINEAR, which is a linear color space and
//   supports HDR output. If you select SDL_COLORSPACE_SRGB_LINEAR, drawing
//   still uses the sRGB colorspace, but values can go beyond 1.0 and float
//   (linear) format textures can be used for HDR content.
// - `SDL_PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER`: non-zero if you want
//   present synchronized with the refresh rate. This property can take any
//   value that is supported by SDL_SetRenderVSync() for the renderer.
//
// With the vulkan renderer:
//
// - `SDL_PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER`: the VkInstance to use
//   with the renderer, optional.
// - `SDL_PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER`: the VkSurfaceKHR to use
//   with the renderer, optional.
// - `SDL_PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER`: the
//   VkPhysicalDevice to use with the renderer, optional.
// - `SDL_PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER`: the VkDevice to use
//   with the renderer, optional.
// - `SDL_PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER`: the
//   queue family index used for rendering.
// - `SDL_PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER`: the
//   queue family index used for presentation.
//
// `props` props the properties to use.
// returns a valid rendering context or NULL if there was an error; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_properties (SDL_CreateProperties)
// See also: create_renderer (SDL_CreateRenderer)
// See also: create_software_renderer (SDL_CreateSoftwareRenderer)
// See also: destroy_renderer (SDL_DestroyRenderer)
// See also: get_renderer_name (SDL_GetRendererName)
pub fn create_renderer_with_properties(props PropertiesID) &Renderer {
	return C.SDL_CreateRendererWithProperties(props)
}

pub const prop_renderer_create_name_string = C.SDL_PROP_RENDERER_CREATE_NAME_STRING // 'SDL.renderer.create.name'

pub const prop_renderer_create_window_pointer = C.SDL_PROP_RENDERER_CREATE_WINDOW_POINTER // 'SDL.renderer.create.window'

pub const prop_renderer_create_surface_pointer = C.SDL_PROP_RENDERER_CREATE_SURFACE_POINTER // 'SDL.renderer.create.surface'

pub const prop_renderer_create_output_colorspace_number = C.SDL_PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER // 'SDL.renderer.create.output_colorspace'

pub const prop_renderer_create_present_vsync_number = C.SDL_PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER // 'SDL.renderer.create.present_vsync'

pub const prop_renderer_create_vulkan_instance_pointer = C.SDL_PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER // 'SDL.renderer.create.vulkan.instance'

pub const prop_renderer_create_vulkan_surface_number = C.SDL_PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER // 'SDL.renderer.create.vulkan.surface'

pub const prop_renderer_create_vulkan_physical_device_pointer = C.SDL_PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER // 'SDL.renderer.create.vulkan.physical_device'

pub const prop_renderer_create_vulkan_device_pointer = C.SDL_PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER // 'SDL.renderer.create.vulkan.device'

pub const prop_renderer_create_vulkan_graphics_queue_family_index_number = C.SDL_PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER // 'SDL.renderer.create.vulkan.graphics_queue_family_index'

pub const prop_renderer_create_vulkan_present_queue_family_index_number = C.SDL_PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER // 'SDL.renderer.create.vulkan.present_queue_family_index'

// C.SDL_CreateSoftwareRenderer [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateSoftwareRenderer)
fn C.SDL_CreateSoftwareRenderer(surface &Surface) &Renderer

// create_software_renderer creates a 2D software rendering context for a surface.
//
// Two other API which can be used to create SDL_Renderer:
// SDL_CreateRenderer() and SDL_CreateWindowAndRenderer(). These can _also_
// create a software renderer, but they are intended to be used with an
// SDL_Window as the final destination and not an SDL_Surface.
//
// `surface` surface the SDL_Surface structure representing the surface where
//                rendering is done.
// returns a valid rendering context or NULL if there was an error; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_renderer (SDL_DestroyRenderer)
pub fn create_software_renderer(surface &Surface) &Renderer {
	return C.SDL_CreateSoftwareRenderer(surface)
}

// C.SDL_GetRenderer [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderer)
fn C.SDL_GetRenderer(window &Window) &Renderer

// get_renderer gets the renderer associated with a window.
//
// `window` window the window to query.
// returns the rendering context on success or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_renderer(window &Window) &Renderer {
	return C.SDL_GetRenderer(window)
}

// C.SDL_GetRenderWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderWindow)
fn C.SDL_GetRenderWindow(renderer &Renderer) &Window

// get_render_window gets the window associated with a renderer.
//
// `renderer` renderer the renderer to query.
// returns the window on success or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_render_window(renderer &Renderer) &Window {
	return C.SDL_GetRenderWindow(renderer)
}

// C.SDL_GetRendererName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRendererName)
fn C.SDL_GetRendererName(renderer &Renderer) &char

// get_renderer_name gets the name of a renderer.
//
// `renderer` renderer the rendering context.
// returns the name of the selected renderer, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_renderer (SDL_CreateRenderer)
// See also: create_renderer_with_properties (SDL_CreateRendererWithProperties)
pub fn get_renderer_name(renderer &Renderer) &char {
	return &char(C.SDL_GetRendererName(renderer))
}

// C.SDL_GetRendererProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRendererProperties)
fn C.SDL_GetRendererProperties(renderer &Renderer) PropertiesID

// get_renderer_properties gets the properties associated with a renderer.
//
// The following read-only properties are provided by SDL:
//
// - `SDL_PROP_RENDERER_NAME_STRING`: the name of the rendering driver
// - `SDL_PROP_RENDERER_WINDOW_POINTER`: the window where rendering is
//   displayed, if any
// - `SDL_PROP_RENDERER_SURFACE_POINTER`: the surface where rendering is
//   displayed, if this is a software renderer without a window
// - `SDL_PROP_RENDERER_VSYNC_NUMBER`: the current vsync setting
// - `SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER`: the maximum texture width
//   and height
// - `SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER`: a (const SDL_PixelFormat *)
//   array of pixel formats, terminated with SDL_PIXELFORMAT_UNKNOWN,
//   representing the available texture formats for this renderer.
// - `SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER`: an SDL_Colorspace value
//   describing the colorspace for output to the display, defaults to
//   SDL_COLORSPACE_SRGB.
// - `SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN`: true if the output colorspace is
//   SDL_COLORSPACE_SRGB_LINEAR and the renderer is showing on a display with
//   HDR enabled. This property can change dynamically when
//   SDL_EVENT_WINDOW_HDR_STATE_CHANGED is sent.
// - `SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT`: the value of SDR white in the
//   SDL_COLORSPACE_SRGB_LINEAR colorspace. When HDR is enabled, this value is
//   automatically multiplied into the color scale. This property can change
//   dynamically when SDL_EVENT_WINDOW_HDR_STATE_CHANGED is sent.
// - `SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT`: the additional high dynamic range
//   that can be displayed, in terms of the SDR white point. When HDR is not
//   enabled, this will be 1.0. This property can change dynamically when
//   SDL_EVENT_WINDOW_HDR_STATE_CHANGED is sent.
//
// With the direct3d renderer:
//
// - `SDL_PROP_RENDERER_D3D9_DEVICE_POINTER`: the IDirect3DDevice9 associated
//   with the renderer
//
// With the direct3d11 renderer:
//
// - `SDL_PROP_RENDERER_D3D11_DEVICE_POINTER`: the ID3D11Device associated
//   with the renderer
// - `SDL_PROP_RENDERER_D3D11_SWAPCHAIN_POINTER`: the IDXGISwapChain1
//   associated with the renderer. This may change when the window is resized.
//
// With the direct3d12 renderer:
//
// - `SDL_PROP_RENDERER_D3D12_DEVICE_POINTER`: the ID3D12Device associated
//   with the renderer
// - `SDL_PROP_RENDERER_D3D12_SWAPCHAIN_POINTER`: the IDXGISwapChain4
//   associated with the renderer.
// - `SDL_PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER`: the ID3D12CommandQueue
//   associated with the renderer
//
// With the vulkan renderer:
//
// - `SDL_PROP_RENDERER_VULKAN_INSTANCE_POINTER`: the VkInstance associated
//   with the renderer
// - `SDL_PROP_RENDERER_VULKAN_SURFACE_NUMBER`: the VkSurfaceKHR associated
//   with the renderer
// - `SDL_PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER`: the VkPhysicalDevice
//   associated with the renderer
// - `SDL_PROP_RENDERER_VULKAN_DEVICE_POINTER`: the VkDevice associated with
//   the renderer
// - `SDL_PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER`: the queue
//   family index used for rendering
// - `SDL_PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER`: the queue
//   family index used for presentation
// - `SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER`: the number of
//   swapchain images, or potential frames in flight, used by the Vulkan
//   renderer
//
// With the gpu renderer:
//
// - `SDL_PROP_RENDERER_GPU_DEVICE_POINTER`: the SDL_GPUDevice associated with
//   the renderer
//
// `renderer` renderer the rendering context.
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_renderer_properties(renderer &Renderer) PropertiesID {
	return C.SDL_GetRendererProperties(renderer)
}

pub const prop_renderer_name_string = C.SDL_PROP_RENDERER_NAME_STRING // 'SDL.renderer.name'

pub const prop_renderer_window_pointer = C.SDL_PROP_RENDERER_WINDOW_POINTER // 'SDL.renderer.window'

pub const prop_renderer_surface_pointer = C.SDL_PROP_RENDERER_SURFACE_POINTER // 'SDL.renderer.surface'

pub const prop_renderer_vsync_number = C.SDL_PROP_RENDERER_VSYNC_NUMBER // 'SDL.renderer.vsync'

pub const prop_renderer_max_texture_size_number = C.SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER // 'SDL.renderer.max_texture_size'

pub const prop_renderer_texture_formats_pointer = C.SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER // 'SDL.renderer.texture_formats'

pub const prop_renderer_output_colorspace_number = C.SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER // 'SDL.renderer.output_colorspace'

pub const prop_renderer_hdr_enabled_boolean = C.SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN // 'SDL.renderer.HDR_enabled'

pub const prop_renderer_sdr_white_point_float = C.SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT // 'SDL.renderer.SDR_white_point'

pub const prop_renderer_hdr_headroom_float = C.SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT // 'SDL.renderer.HDR_headroom'

pub const prop_renderer_d3d9_device_pointer = C.SDL_PROP_RENDERER_D3D9_DEVICE_POINTER // 'SDL.renderer.d3d9.device'

pub const prop_renderer_d3d11_device_pointer = C.SDL_PROP_RENDERER_D3D11_DEVICE_POINTER // 'SDL.renderer.d3d11.device'

pub const prop_renderer_d3d11_swapchain_pointer = C.SDL_PROP_RENDERER_D3D11_SWAPCHAIN_POINTER // 'SDL.renderer.d3d11.swap_chain'

pub const prop_renderer_d3d12_device_pointer = C.SDL_PROP_RENDERER_D3D12_DEVICE_POINTER // 'SDL.renderer.d3d12.device'

pub const prop_renderer_d3d12_swapchain_pointer = C.SDL_PROP_RENDERER_D3D12_SWAPCHAIN_POINTER // 'SDL.renderer.d3d12.swap_chain'

pub const prop_renderer_d3d12_command_queue_pointer = C.SDL_PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER // 'SDL.renderer.d3d12.command_queue'

pub const prop_renderer_vulkan_instance_pointer = C.SDL_PROP_RENDERER_VULKAN_INSTANCE_POINTER // 'SDL.renderer.vulkan.instance'

pub const prop_renderer_vulkan_surface_number = C.SDL_PROP_RENDERER_VULKAN_SURFACE_NUMBER // 'SDL.renderer.vulkan.surface'

pub const prop_renderer_vulkan_physical_device_pointer = C.SDL_PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER // 'SDL.renderer.vulkan.physical_device'

pub const prop_renderer_vulkan_device_pointer = C.SDL_PROP_RENDERER_VULKAN_DEVICE_POINTER // 'SDL.renderer.vulkan.device'

pub const prop_renderer_vulkan_graphics_queue_family_index_number = C.SDL_PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER // 'SDL.renderer.vulkan.graphics_queue_family_index'

pub const prop_renderer_vulkan_present_queue_family_index_number = C.SDL_PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER // 'SDL.renderer.vulkan.present_queue_family_index'

pub const prop_renderer_vulkan_swapchain_image_count_number = C.SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER // 'SDL.renderer.vulkan.swapchain_image_count'

pub const prop_renderer_gpu_device_pointer = C.SDL_PROP_RENDERER_GPU_DEVICE_POINTER // 'SDL.renderer.gpu.device'

// C.SDL_GetRenderOutputSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderOutputSize)
fn C.SDL_GetRenderOutputSize(renderer &Renderer, w &int, h &int) bool

// get_render_output_size gets the output size in pixels of a rendering context.
//
// This returns the true output size in pixels, ignoring any render targets or
// logical size and presentation.
//
// `renderer` renderer the rendering context.
// `w` w a pointer filled in with the width in pixels.
// `h` h a pointer filled in with the height in pixels.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_current_render_output_size (SDL_GetCurrentRenderOutputSize)
pub fn get_render_output_size(renderer &Renderer, w &int, h &int) bool {
	return C.SDL_GetRenderOutputSize(renderer, w, h)
}

// C.SDL_GetCurrentRenderOutputSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCurrentRenderOutputSize)
fn C.SDL_GetCurrentRenderOutputSize(renderer &Renderer, w &int, h &int) bool

// get_current_render_output_size gets the current output size in pixels of a rendering context.
//
// If a rendering target is active, this will return the size of the rendering
// target in pixels, otherwise if a logical size is set, it will return the
// logical size, otherwise it will return the value of
// SDL_GetRenderOutputSize().
//
// `renderer` renderer the rendering context.
// `w` w a pointer filled in with the current width.
// `h` h a pointer filled in with the current height.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_output_size (SDL_GetRenderOutputSize)
pub fn get_current_render_output_size(renderer &Renderer, w &int, h &int) bool {
	return C.SDL_GetCurrentRenderOutputSize(renderer, w, h)
}

// C.SDL_CreateTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateTexture)
fn C.SDL_CreateTexture(renderer &Renderer, format PixelFormat, access TextureAccess, w int, h int) &Texture

// create_texture creates a texture for a rendering context.
//
// The contents of a texture when first created are not defined.
//
// `renderer` renderer the rendering context.
// `format` format one of the enumerated values in SDL_PixelFormat.
// `access` access one of the enumerated values in SDL_TextureAccess.
// `w` w the width of the texture in pixels.
// `h` h the height of the texture in pixels.
// returns the created texture or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_texture_from_surface (SDL_CreateTextureFromSurface)
// See also: create_texture_with_properties (SDL_CreateTextureWithProperties)
// See also: destroy_texture (SDL_DestroyTexture)
// See also: get_texture_size (SDL_GetTextureSize)
// See also: update_texture (SDL_UpdateTexture)
pub fn create_texture(renderer &Renderer, format PixelFormat, access TextureAccess, w int, h int) &Texture {
	return C.SDL_CreateTexture(renderer, format, access, w, h)
}

// C.SDL_CreateTextureFromSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateTextureFromSurface)
fn C.SDL_CreateTextureFromSurface(renderer &Renderer, surface &Surface) &Texture

// create_texture_from_surface creates a texture from an existing surface.
//
// The surface is not modified or freed by this function.
//
// The SDL_TextureAccess hint for the created texture is
// `SDL_TEXTUREACCESS_STATIC`.
//
// The pixel format of the created texture may be different from the pixel
// format of the surface, and can be queried using the
// SDL_PROP_TEXTURE_FORMAT_NUMBER property.
//
// `renderer` renderer the rendering context.
// `surface` surface the SDL_Surface structure containing pixel data used to fill
//                the texture.
// returns the created texture or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_texture (SDL_CreateTexture)
// See also: create_texture_with_properties (SDL_CreateTextureWithProperties)
// See also: destroy_texture (SDL_DestroyTexture)
pub fn create_texture_from_surface(renderer &Renderer, surface &Surface) &Texture {
	return C.SDL_CreateTextureFromSurface(renderer, surface)
}

// C.SDL_CreateTextureWithProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateTextureWithProperties)
fn C.SDL_CreateTextureWithProperties(renderer &Renderer, props PropertiesID) &Texture

// create_texture_with_properties creates a texture for a rendering context with the specified properties.
//
// These are the supported properties:
//
// - `SDL_PROP_TEXTURE_CREATE_COLORSPACE_NUMBER`: an SDL_Colorspace value
//   describing the texture colorspace, defaults to SDL_COLORSPACE_SRGB_LINEAR
//   for floating point textures, SDL_COLORSPACE_HDR10 for 10-bit textures,
//   SDL_COLORSPACE_SRGB for other RGB textures and SDL_COLORSPACE_JPEG for
//   YUV textures.
// - `SDL_PROP_TEXTURE_CREATE_FORMAT_NUMBER`: one of the enumerated values in
//   SDL_PixelFormat, defaults to the best RGBA format for the renderer
// - `SDL_PROP_TEXTURE_CREATE_ACCESS_NUMBER`: one of the enumerated values in
//   SDL_TextureAccess, defaults to SDL_TEXTUREACCESS_STATIC
// - `SDL_PROP_TEXTURE_CREATE_WIDTH_NUMBER`: the width of the texture in
//   pixels, required
// - `SDL_PROP_TEXTURE_CREATE_HEIGHT_NUMBER`: the height of the texture in
//   pixels, required
// - `SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT`: for HDR10 and floating
//   point textures, this defines the value of 100% diffuse white, with higher
//   values being displayed in the High Dynamic Range headroom. This defaults
//   to 100 for HDR10 textures and 1.0 for floating point textures.
// - `SDL_PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT`: for HDR10 and floating
//   point textures, this defines the maximum dynamic range used by the
//   content, in terms of the SDR white point. This would be equivalent to
//   maxCLL / SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT for HDR10 content.
//   If this is defined, any values outside the range supported by the display
//   will be scaled into the available HDR headroom, otherwise they are
//   clipped.
//
// With the direct3d11 renderer:
//
// - `SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER`: the ID3D11Texture2D
//   associated with the texture, if you want to wrap an existing texture.
// - `SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER`: the ID3D11Texture2D
//   associated with the U plane of a YUV texture, if you want to wrap an
//   existing texture.
// - `SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER`: the ID3D11Texture2D
//   associated with the V plane of a YUV texture, if you want to wrap an
//   existing texture.
//
// With the direct3d12 renderer:
//
// - `SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER`: the ID3D12Resource
//   associated with the texture, if you want to wrap an existing texture.
// - `SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER`: the ID3D12Resource
//   associated with the U plane of a YUV texture, if you want to wrap an
//   existing texture.
// - `SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER`: the ID3D12Resource
//   associated with the V plane of a YUV texture, if you want to wrap an
//   existing texture.
//
// With the metal renderer:
//
// - `SDL_PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER`: the CVPixelBufferRef
//   associated with the texture, if you want to create a texture from an
//   existing pixel buffer.
//
// With the opengl renderer:
//
// - `SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER`: the GLuint texture
//   associated with the texture, if you want to wrap an existing texture.
// - `SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER`: the GLuint texture
//   associated with the UV plane of an NV12 texture, if you want to wrap an
//   existing texture.
// - `SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER`: the GLuint texture
//   associated with the U plane of a YUV texture, if you want to wrap an
//   existing texture.
// - `SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER`: the GLuint texture
//   associated with the V plane of a YUV texture, if you want to wrap an
//   existing texture.
//
// With the opengles2 renderer:
//
// - `SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER`: the GLuint texture
//   associated with the texture, if you want to wrap an existing texture.
// - `SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER`: the GLuint texture
//   associated with the texture, if you want to wrap an existing texture.
// - `SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER`: the GLuint texture
//   associated with the UV plane of an NV12 texture, if you want to wrap an
//   existing texture.
// - `SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER`: the GLuint texture
//   associated with the U plane of a YUV texture, if you want to wrap an
//   existing texture.
// - `SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER`: the GLuint texture
//   associated with the V plane of a YUV texture, if you want to wrap an
//   existing texture.
//
// With the vulkan renderer:
//
// - `SDL_PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER`: the VkImage with layout
//   VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL associated with the texture, if
//   you want to wrap an existing texture.
//
// `renderer` renderer the rendering context.
// `props` props the properties to use.
// returns the created texture or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_properties (SDL_CreateProperties)
// See also: create_texture (SDL_CreateTexture)
// See also: create_texture_from_surface (SDL_CreateTextureFromSurface)
// See also: destroy_texture (SDL_DestroyTexture)
// See also: get_texture_size (SDL_GetTextureSize)
// See also: update_texture (SDL_UpdateTexture)
pub fn create_texture_with_properties(renderer &Renderer, props PropertiesID) &Texture {
	return C.SDL_CreateTextureWithProperties(renderer, props)
}

pub const prop_texture_create_colorspace_number = C.SDL_PROP_TEXTURE_CREATE_COLORSPACE_NUMBER // 'SDL.texture.create.colorspace'

pub const prop_texture_create_format_number = C.SDL_PROP_TEXTURE_CREATE_FORMAT_NUMBER // 'SDL.texture.create.format'

pub const prop_texture_create_access_number = C.SDL_PROP_TEXTURE_CREATE_ACCESS_NUMBER // 'SDL.texture.create.access'

pub const prop_texture_create_width_number = C.SDL_PROP_TEXTURE_CREATE_WIDTH_NUMBER // 'SDL.texture.create.width'

pub const prop_texture_create_height_number = C.SDL_PROP_TEXTURE_CREATE_HEIGHT_NUMBER // 'SDL.texture.create.height'

pub const prop_texture_create_sdr_white_point_float = C.SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT // 'SDL.texture.create.SDR_white_point'

pub const prop_texture_create_hdr_headroom_float = C.SDL_PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT // 'SDL.texture.create.HDR_headroom'

pub const prop_texture_create_d3d11_texture_pointer = C.SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER // 'SDL.texture.create.d3d11.texture'

pub const prop_texture_create_d3d11_texture_u_pointer = C.SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER // 'SDL.texture.create.d3d11.texture_u'

pub const prop_texture_create_d3d11_texture_v_pointer = C.SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER // 'SDL.texture.create.d3d11.texture_v'

pub const prop_texture_create_d3d12_texture_pointer = C.SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER // 'SDL.texture.create.d3d12.texture'

pub const prop_texture_create_d3d12_texture_u_pointer = C.SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER // 'SDL.texture.create.d3d12.texture_u'

pub const prop_texture_create_d3d12_texture_v_pointer = C.SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER // 'SDL.texture.create.d3d12.texture_v'

pub const prop_texture_create_metal_pixelbuffer_pointer = C.SDL_PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER // 'SDL.texture.create.metal.pixelbuffer'

pub const prop_texture_create_opengl_texture_number = C.SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER // 'SDL.texture.create.opengl.texture'

pub const prop_texture_create_opengl_texture_uv_number = C.SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER // 'SDL.texture.create.opengl.texture_uv'

pub const prop_texture_create_opengl_texture_u_number = C.SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER // 'SDL.texture.create.opengl.texture_u'

pub const prop_texture_create_opengl_texture_v_number = C.SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER // 'SDL.texture.create.opengl.texture_v'

pub const prop_texture_create_opengles2_texture_number = C.SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER // 'SDL.texture.create.opengles2.texture'

pub const prop_texture_create_opengles2_texture_uv_number = C.SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER // 'SDL.texture.create.opengles2.texture_uv'

pub const prop_texture_create_opengles2_texture_u_number = C.SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER // 'SDL.texture.create.opengles2.texture_u'

pub const prop_texture_create_opengles2_texture_v_number = C.SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER // 'SDL.texture.create.opengles2.texture_v'

pub const prop_texture_create_vulkan_texture_number = C.SDL_PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER // 'SDL.texture.create.vulkan.texture'

// C.SDL_GetTextureProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTextureProperties)
fn C.SDL_GetTextureProperties(texture &Texture) PropertiesID

// get_texture_properties gets the properties associated with a texture.
//
// The following read-only properties are provided by SDL:
//
// - `SDL_PROP_TEXTURE_COLORSPACE_NUMBER`: an SDL_Colorspace value describing
//   the texture colorspace.
// - `SDL_PROP_TEXTURE_FORMAT_NUMBER`: one of the enumerated values in
//   SDL_PixelFormat.
// - `SDL_PROP_TEXTURE_ACCESS_NUMBER`: one of the enumerated values in
//   SDL_TextureAccess.
// - `SDL_PROP_TEXTURE_WIDTH_NUMBER`: the width of the texture in pixels.
// - `SDL_PROP_TEXTURE_HEIGHT_NUMBER`: the height of the texture in pixels.
// - `SDL_PROP_TEXTURE_SDR_WHITE_POINT_FLOAT`: for HDR10 and floating point
//   textures, this defines the value of 100% diffuse white, with higher
//   values being displayed in the High Dynamic Range headroom. This defaults
//   to 100 for HDR10 textures and 1.0 for other textures.
// - `SDL_PROP_TEXTURE_HDR_HEADROOM_FLOAT`: for HDR10 and floating point
//   textures, this defines the maximum dynamic range used by the content, in
//   terms of the SDR white point. If this is defined, any values outside the
//   range supported by the display will be scaled into the available HDR
//   headroom, otherwise they are clipped. This defaults to 1.0 for SDR
//   textures, 4.0 for HDR10 textures, and no default for floating point
//   textures.
//
// With the direct3d11 renderer:
//
// - `SDL_PROP_TEXTURE_D3D11_TEXTURE_POINTER`: the ID3D11Texture2D associated
//   with the texture
// - `SDL_PROP_TEXTURE_D3D11_TEXTURE_U_POINTER`: the ID3D11Texture2D
//   associated with the U plane of a YUV texture
// - `SDL_PROP_TEXTURE_D3D11_TEXTURE_V_POINTER`: the ID3D11Texture2D
//   associated with the V plane of a YUV texture
//
// With the direct3d12 renderer:
//
// - `SDL_PROP_TEXTURE_D3D12_TEXTURE_POINTER`: the ID3D12Resource associated
//   with the texture
// - `SDL_PROP_TEXTURE_D3D12_TEXTURE_U_POINTER`: the ID3D12Resource associated
//   with the U plane of a YUV texture
// - `SDL_PROP_TEXTURE_D3D12_TEXTURE_V_POINTER`: the ID3D12Resource associated
//   with the V plane of a YUV texture
//
// With the vulkan renderer:
//
// - `SDL_PROP_TEXTURE_VULKAN_TEXTURE_NUMBER`: the VkImage associated with the
//   texture
//
// With the opengl renderer:
//
// - `SDL_PROP_TEXTURE_OPENGL_TEXTURE_NUMBER`: the GLuint texture associated
//   with the texture
// - `SDL_PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER`: the GLuint texture
//   associated with the UV plane of an NV12 texture
// - `SDL_PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER`: the GLuint texture associated
//   with the U plane of a YUV texture
// - `SDL_PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER`: the GLuint texture associated
//   with the V plane of a YUV texture
// - `SDL_PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER`: the GLenum for the
//   texture target (`GL_TEXTURE_2D`, `GL_TEXTURE_RECTANGLE_ARB`, etc)
// - `SDL_PROP_TEXTURE_OPENGL_TEX_W_FLOAT`: the texture coordinate width of
//   the texture (0.0 - 1.0)
// - `SDL_PROP_TEXTURE_OPENGL_TEX_H_FLOAT`: the texture coordinate height of
//   the texture (0.0 - 1.0)
//
// With the opengles2 renderer:
//
// - `SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER`: the GLuint texture
//   associated with the texture
// - `SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER`: the GLuint texture
//   associated with the UV plane of an NV12 texture
// - `SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER`: the GLuint texture
//   associated with the U plane of a YUV texture
// - `SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER`: the GLuint texture
//   associated with the V plane of a YUV texture
// - `SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER`: the GLenum for the
//   texture target (`GL_TEXTURE_2D`, `GL_TEXTURE_EXTERNAL_OES`, etc)
//
// `texture` texture the texture to query.
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_texture_properties(texture &Texture) PropertiesID {
	return C.SDL_GetTextureProperties(texture)
}

pub const prop_texture_colorspace_number = C.SDL_PROP_TEXTURE_COLORSPACE_NUMBER // 'SDL.texture.colorspace'

pub const prop_texture_format_number = C.SDL_PROP_TEXTURE_FORMAT_NUMBER // 'SDL.texture.format'

pub const prop_texture_access_number = C.SDL_PROP_TEXTURE_ACCESS_NUMBER // 'SDL.texture.access'

pub const prop_texture_width_number = C.SDL_PROP_TEXTURE_WIDTH_NUMBER // 'SDL.texture.width'

pub const prop_texture_height_number = C.SDL_PROP_TEXTURE_HEIGHT_NUMBER // 'SDL.texture.height'

pub const prop_texture_sdr_white_point_float = C.SDL_PROP_TEXTURE_SDR_WHITE_POINT_FLOAT // 'SDL.texture.SDR_white_point'

pub const prop_texture_hdr_headroom_float = C.SDL_PROP_TEXTURE_HDR_HEADROOM_FLOAT // 'SDL.texture.HDR_headroom'

pub const prop_texture_d3d11_texture_pointer = C.SDL_PROP_TEXTURE_D3D11_TEXTURE_POINTER // 'SDL.texture.d3d11.texture'

pub const prop_texture_d3d11_texture_u_pointer = C.SDL_PROP_TEXTURE_D3D11_TEXTURE_U_POINTER // 'SDL.texture.d3d11.texture_u'

pub const prop_texture_d3d11_texture_v_pointer = C.SDL_PROP_TEXTURE_D3D11_TEXTURE_V_POINTER // 'SDL.texture.d3d11.texture_v'

pub const prop_texture_d3d12_texture_pointer = C.SDL_PROP_TEXTURE_D3D12_TEXTURE_POINTER // 'SDL.texture.d3d12.texture'

pub const prop_texture_d3d12_texture_u_pointer = C.SDL_PROP_TEXTURE_D3D12_TEXTURE_U_POINTER // 'SDL.texture.d3d12.texture_u'

pub const prop_texture_d3d12_texture_v_pointer = C.SDL_PROP_TEXTURE_D3D12_TEXTURE_V_POINTER // 'SDL.texture.d3d12.texture_v'

pub const prop_texture_opengl_texture_number = C.SDL_PROP_TEXTURE_OPENGL_TEXTURE_NUMBER // 'SDL.texture.opengl.texture'

pub const prop_texture_opengl_texture_uv_number = C.SDL_PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER // 'SDL.texture.opengl.texture_uv'

pub const prop_texture_opengl_texture_u_number = C.SDL_PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER // 'SDL.texture.opengl.texture_u'

pub const prop_texture_opengl_texture_v_number = C.SDL_PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER // 'SDL.texture.opengl.texture_v'

pub const prop_texture_opengl_texture_target_number = C.SDL_PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER // 'SDL.texture.opengl.target'

pub const prop_texture_opengl_tex_w_float = C.SDL_PROP_TEXTURE_OPENGL_TEX_W_FLOAT // 'SDL.texture.opengl.tex_w'

pub const prop_texture_opengl_tex_h_float = C.SDL_PROP_TEXTURE_OPENGL_TEX_H_FLOAT // 'SDL.texture.opengl.tex_h'

pub const prop_texture_opengles2_texture_number = C.SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER // 'SDL.texture.opengles2.texture'

pub const prop_texture_opengles2_texture_uv_number = C.SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER // 'SDL.texture.opengles2.texture_uv'

pub const prop_texture_opengles2_texture_u_number = C.SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER // 'SDL.texture.opengles2.texture_u'

pub const prop_texture_opengles2_texture_v_number = C.SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER // 'SDL.texture.opengles2.texture_v'

pub const prop_texture_opengles2_texture_target_number = C.SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER // 'SDL.texture.opengles2.target'

pub const prop_texture_vulkan_texture_number = C.SDL_PROP_TEXTURE_VULKAN_TEXTURE_NUMBER // 'SDL.texture.vulkan.texture'

// C.SDL_GetRendererFromTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRendererFromTexture)
fn C.SDL_GetRendererFromTexture(texture &Texture) &Renderer

// get_renderer_from_texture gets the renderer that created an SDL_Texture.
//
// `texture` texture the texture to query.
// returns a pointer to the SDL_Renderer that created the texture, or NULL on
//          failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_renderer_from_texture(texture &Texture) &Renderer {
	return C.SDL_GetRendererFromTexture(texture)
}

// C.SDL_GetTextureSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTextureSize)
fn C.SDL_GetTextureSize(texture &Texture, w &f32, h &f32) bool

// get_texture_size gets the size of a texture, as floating point values.
//
// `texture` texture the texture to query.
// `w` w a pointer filled in with the width of the texture in pixels. This
//          argument can be NULL if you don't need this information.
// `h` h a pointer filled in with the height of the texture in pixels. This
//          argument can be NULL if you don't need this information.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_texture_size(texture &Texture, w &f32, h &f32) bool {
	return C.SDL_GetTextureSize(texture, w, h)
}

// C.SDL_SetTextureColorMod [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTextureColorMod)
fn C.SDL_SetTextureColorMod(texture &Texture, r u8, g u8, b u8) bool

// set_texture_color_mod sets an additional color value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation each source color
// channel is modulated by the appropriate color value according to the
// following formula:
//
// `srcC = srcC * (color / 255)`
//
// Color modulation is not always supported by the renderer; it will return
// false if color modulation is not supported.
//
// `texture` texture the texture to update.
// `r` r the red color value multiplied into copy operations.
// `g` g the green color value multiplied into copy operations.
// `b` b the blue color value multiplied into copy operations.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_texture_color_mod (SDL_GetTextureColorMod)
// See also: set_texture_alpha_mod (SDL_SetTextureAlphaMod)
// See also: set_texture_color_mod_float (SDL_SetTextureColorModFloat)
pub fn set_texture_color_mod(texture &Texture, r u8, g u8, b u8) bool {
	return C.SDL_SetTextureColorMod(texture, r, g, b)
}

// C.SDL_SetTextureColorModFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTextureColorModFloat)
fn C.SDL_SetTextureColorModFloat(texture &Texture, r f32, g f32, b f32) bool

// set_texture_color_mod_float sets an additional color value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation each source color
// channel is modulated by the appropriate color value according to the
// following formula:
//
// `srcC = srcC * color`
//
// Color modulation is not always supported by the renderer; it will return
// false if color modulation is not supported.
//
// `texture` texture the texture to update.
// `r` r the red color value multiplied into copy operations.
// `g` g the green color value multiplied into copy operations.
// `b` b the blue color value multiplied into copy operations.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_texture_color_mod_float (SDL_GetTextureColorModFloat)
// See also: set_texture_alpha_mod_float (SDL_SetTextureAlphaModFloat)
// See also: set_texture_color_mod (SDL_SetTextureColorMod)
pub fn set_texture_color_mod_float(texture &Texture, r f32, g f32, b f32) bool {
	return C.SDL_SetTextureColorModFloat(texture, r, g, b)
}

// C.SDL_GetTextureColorMod [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTextureColorMod)
fn C.SDL_GetTextureColorMod(texture &Texture, r &u8, g &u8, b &u8) bool

// get_texture_color_mod gets the additional color value multiplied into render copy operations.
//
// `texture` texture the texture to query.
// `r` r a pointer filled in with the current red color value.
// `g` g a pointer filled in with the current green color value.
// `b` b a pointer filled in with the current blue color value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_texture_alpha_mod (SDL_GetTextureAlphaMod)
// See also: get_texture_color_mod_float (SDL_GetTextureColorModFloat)
// See also: set_texture_color_mod (SDL_SetTextureColorMod)
pub fn get_texture_color_mod(texture &Texture, r &u8, g &u8, b &u8) bool {
	return C.SDL_GetTextureColorMod(texture, r, g, b)
}

// C.SDL_GetTextureColorModFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTextureColorModFloat)
fn C.SDL_GetTextureColorModFloat(texture &Texture, r &f32, g &f32, b &f32) bool

// get_texture_color_mod_float gets the additional color value multiplied into render copy operations.
//
// `texture` texture the texture to query.
// `r` r a pointer filled in with the current red color value.
// `g` g a pointer filled in with the current green color value.
// `b` b a pointer filled in with the current blue color value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_texture_alpha_mod_float (SDL_GetTextureAlphaModFloat)
// See also: get_texture_color_mod (SDL_GetTextureColorMod)
// See also: set_texture_color_mod_float (SDL_SetTextureColorModFloat)
pub fn get_texture_color_mod_float(texture &Texture, r &f32, g &f32, b &f32) bool {
	return C.SDL_GetTextureColorModFloat(texture, r, g, b)
}

// C.SDL_SetTextureAlphaMod [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTextureAlphaMod)
fn C.SDL_SetTextureAlphaMod(texture &Texture, alpha u8) bool

// set_texture_alpha_mod sets an additional alpha value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation the source alpha
// value is modulated by this alpha value according to the following formula:
//
// `srcA = srcA * (alpha / 255)`
//
// Alpha modulation is not always supported by the renderer; it will return
// false if alpha modulation is not supported.
//
// `texture` texture the texture to update.
// `alpha` alpha the source alpha value multiplied into copy operations.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_texture_alpha_mod (SDL_GetTextureAlphaMod)
// See also: set_texture_alpha_mod_float (SDL_SetTextureAlphaModFloat)
// See also: set_texture_color_mod (SDL_SetTextureColorMod)
pub fn set_texture_alpha_mod(texture &Texture, alpha u8) bool {
	return C.SDL_SetTextureAlphaMod(texture, alpha)
}

// C.SDL_SetTextureAlphaModFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTextureAlphaModFloat)
fn C.SDL_SetTextureAlphaModFloat(texture &Texture, alpha f32) bool

// set_texture_alpha_mod_float sets an additional alpha value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation the source alpha
// value is modulated by this alpha value according to the following formula:
//
// `srcA = srcA * alpha`
//
// Alpha modulation is not always supported by the renderer; it will return
// false if alpha modulation is not supported.
//
// `texture` texture the texture to update.
// `alpha` alpha the source alpha value multiplied into copy operations.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_texture_alpha_mod_float (SDL_GetTextureAlphaModFloat)
// See also: set_texture_alpha_mod (SDL_SetTextureAlphaMod)
// See also: set_texture_color_mod_float (SDL_SetTextureColorModFloat)
pub fn set_texture_alpha_mod_float(texture &Texture, alpha f32) bool {
	return C.SDL_SetTextureAlphaModFloat(texture, alpha)
}

// C.SDL_GetTextureAlphaMod [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTextureAlphaMod)
fn C.SDL_GetTextureAlphaMod(texture &Texture, alpha &u8) bool

// get_texture_alpha_mod gets the additional alpha value multiplied into render copy operations.
//
// `texture` texture the texture to query.
// `alpha` alpha a pointer filled in with the current alpha value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_texture_alpha_mod_float (SDL_GetTextureAlphaModFloat)
// See also: get_texture_color_mod (SDL_GetTextureColorMod)
// See also: set_texture_alpha_mod (SDL_SetTextureAlphaMod)
pub fn get_texture_alpha_mod(texture &Texture, alpha &u8) bool {
	return C.SDL_GetTextureAlphaMod(texture, alpha)
}

// C.SDL_GetTextureAlphaModFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTextureAlphaModFloat)
fn C.SDL_GetTextureAlphaModFloat(texture &Texture, alpha &f32) bool

// get_texture_alpha_mod_float gets the additional alpha value multiplied into render copy operations.
//
// `texture` texture the texture to query.
// `alpha` alpha a pointer filled in with the current alpha value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_texture_alpha_mod (SDL_GetTextureAlphaMod)
// See also: get_texture_color_mod_float (SDL_GetTextureColorModFloat)
// See also: set_texture_alpha_mod_float (SDL_SetTextureAlphaModFloat)
pub fn get_texture_alpha_mod_float(texture &Texture, alpha &f32) bool {
	return C.SDL_GetTextureAlphaModFloat(texture, alpha)
}

// C.SDL_SetTextureBlendMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTextureBlendMode)
fn C.SDL_SetTextureBlendMode(texture &Texture, blend_mode BlendMode) bool

// set_texture_blend_mode sets the blend mode for a texture, used by SDL_RenderTexture().
//
// If the blend mode is not supported, the closest supported mode is chosen
// and this function returns false.
//
// `texture` texture the texture to update.
// `blend_mode` blendMode the SDL_BlendMode to use for texture blending.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_texture_blend_mode (SDL_GetTextureBlendMode)
pub fn set_texture_blend_mode(texture &Texture, blend_mode BlendMode) bool {
	return C.SDL_SetTextureBlendMode(texture, blend_mode)
}

// C.SDL_GetTextureBlendMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTextureBlendMode)
fn C.SDL_GetTextureBlendMode(texture &Texture, blend_mode &BlendMode) bool

// get_texture_blend_mode gets the blend mode used for texture copy operations.
//
// `texture` texture the texture to query.
// `blend_mode` blendMode a pointer filled in with the current SDL_BlendMode.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_texture_blend_mode (SDL_SetTextureBlendMode)
pub fn get_texture_blend_mode(texture &Texture, blend_mode &BlendMode) bool {
	return C.SDL_GetTextureBlendMode(texture, blend_mode)
}

// C.SDL_SetTextureScaleMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTextureScaleMode)
fn C.SDL_SetTextureScaleMode(texture &Texture, scale_mode ScaleMode) bool

// set_texture_scale_mode sets the scale mode used for texture scale operations.
//
// The default texture scale mode is SDL_SCALEMODE_LINEAR.
//
// If the scale mode is not supported, the closest supported mode is chosen.
//
// `texture` texture the texture to update.
// `scale_mode` scaleMode the SDL_ScaleMode to use for texture scaling.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_texture_scale_mode (SDL_GetTextureScaleMode)
pub fn set_texture_scale_mode(texture &Texture, scale_mode ScaleMode) bool {
	return C.SDL_SetTextureScaleMode(texture, scale_mode)
}

// C.SDL_GetTextureScaleMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTextureScaleMode)
fn C.SDL_GetTextureScaleMode(texture &Texture, scale_mode &ScaleMode) bool

// get_texture_scale_mode gets the scale mode used for texture scale operations.
//
// `texture` texture the texture to query.
// `scale_mode` scaleMode a pointer filled in with the current scale mode.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_texture_scale_mode (SDL_SetTextureScaleMode)
pub fn get_texture_scale_mode(texture &Texture, scale_mode &ScaleMode) bool {
	return C.SDL_GetTextureScaleMode(texture, &scale_mode)
}

// C.SDL_UpdateTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_UpdateTexture)
fn C.SDL_UpdateTexture(texture &Texture, const_rect &Rect, const_pixels voidptr, pitch int) bool

// update_texture updates the given texture rectangle with new pixel data.
//
// The pixel data must be in the pixel format of the texture, which can be
// queried using the SDL_PROP_TEXTURE_FORMAT_NUMBER property.
//
// This is a fairly slow function, intended for use with static textures that
// do not change often.
//
// If the texture is intended to be updated often, it is preferred to create
// the texture as streaming and use the locking functions referenced below.
// While this function will work with streaming textures, for optimization
// reasons you may not get the pixels back if you lock the texture afterward.
//
// `texture` texture the texture to update.
// `rect` rect an SDL_Rect structure representing the area to update, or NULL
//             to update the entire texture.
// `pixels` pixels the raw pixel data in the format of the texture.
// `pitch` pitch the number of bytes in a row of pixel data, including padding
//              between lines.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_texture (SDL_LockTexture)
// See also: unlock_texture (SDL_UnlockTexture)
// See also: update_nv_texture (SDL_UpdateNVTexture)
// See also: update_yuv_texture (SDL_UpdateYUVTexture)
pub fn update_texture(texture &Texture, const_rect &Rect, const_pixels voidptr, pitch int) bool {
	return C.SDL_UpdateTexture(texture, const_rect, const_pixels, pitch)
}

// C.SDL_UpdateYUVTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_UpdateYUVTexture)
fn C.SDL_UpdateYUVTexture(texture &Texture, const_rect &Rect, const_yplane &u8, ypitch int, const_uplane &u8, upitch int, const_vplane &u8, vpitch int) bool

// update_yuv_texture updates a rectangle within a planar YV12 or IYUV texture with new pixel
// data.
//
// You can use SDL_UpdateTexture() as long as your pixel data is a contiguous
// block of Y and U/V planes in the proper order, but this function is
// available if your pixel data is not contiguous.
//
// `texture` texture the texture to update.
// `rect` rect a pointer to the rectangle of pixels to update, or NULL to
//             update the entire texture.
// `yplane` Yplane the raw pixel data for the Y plane.
// `ypitch` Ypitch the number of bytes between rows of pixel data for the Y
//               plane.
// `uplane` Uplane the raw pixel data for the U plane.
// `upitch` Upitch the number of bytes between rows of pixel data for the U
//               plane.
// `vplane` Vplane the raw pixel data for the V plane.
// `vpitch` Vpitch the number of bytes between rows of pixel data for the V
//               plane.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: update_nv_texture (SDL_UpdateNVTexture)
// See also: update_texture (SDL_UpdateTexture)
pub fn update_yuv_texture(texture &Texture, const_rect &Rect, const_yplane &u8, ypitch int, const_uplane &u8, upitch int, const_vplane &u8, vpitch int) bool {
	return C.SDL_UpdateYUVTexture(texture, const_rect, const_yplane, ypitch, const_uplane,
		upitch, const_vplane, vpitch)
}

// C.SDL_UpdateNVTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_UpdateNVTexture)
fn C.SDL_UpdateNVTexture(texture &Texture, const_rect &Rect, const_yplane &u8, ypitch int, const_u_vplane &u8, u_vpitch int) bool

// update_nv_texture updates a rectangle within a planar NV12 or NV21 texture with new pixels.
//
// You can use SDL_UpdateTexture() as long as your pixel data is a contiguous
// block of NV12/21 planes in the proper order, but this function is available
// if your pixel data is not contiguous.
//
// `texture` texture the texture to update.
// `rect` rect a pointer to the rectangle of pixels to update, or NULL to
//             update the entire texture.
// `yplane` Yplane the raw pixel data for the Y plane.
// `ypitch` Ypitch the number of bytes between rows of pixel data for the Y
//               plane.
// `u_vplane` UVplane the raw pixel data for the UV plane.
// `u_vpitch` UVpitch the number of bytes between rows of pixel data for the UV
//                plane.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: update_texture (SDL_UpdateTexture)
// See also: update_yuv_texture (SDL_UpdateYUVTexture)
pub fn update_nv_texture(texture &Texture, const_rect &Rect, const_yplane &u8, ypitch int, const_u_vplane &u8, u_vpitch int) bool {
	return C.SDL_UpdateNVTexture(texture, const_rect, const_yplane, ypitch, const_u_vplane,
		u_vpitch)
}

// C.SDL_LockTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_LockTexture)
fn C.SDL_LockTexture(texture &Texture, const_rect &Rect, pixels &voidptr, pitch &int) bool

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
// `texture` texture the texture to lock for access, which was created with
//                `SDL_TEXTUREACCESS_STREAMING`.
// `rect` rect an SDL_Rect structure representing the area to lock for access;
//             NULL to lock the entire texture.
// `pixels` pixels this is filled in with a pointer to the locked pixels,
//               appropriately offset by the locked area.
// `pitch` pitch this is filled in with the pitch of the locked pixels; the
//              pitch is the length of one row in bytes.
// returns true on success or false if the texture is not valid or was not
//          created with `SDL_TEXTUREACCESS_STREAMING`; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_texture_to_surface (SDL_LockTextureToSurface)
// See also: unlock_texture (SDL_UnlockTexture)
pub fn lock_texture(texture &Texture, const_rect &Rect, pixels &voidptr, pitch &int) bool {
	return C.SDL_LockTexture(texture, const_rect, pixels, pitch)
}

// C.SDL_LockTextureToSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_LockTextureToSurface)
fn C.SDL_LockTextureToSurface(texture &Texture, const_rect &Rect, surface &&Surface) bool

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
// `texture` texture the texture to lock for access, which must be created with
//                `SDL_TEXTUREACCESS_STREAMING`.
// `rect` rect a pointer to the rectangle to lock for access. If the rect is
//             NULL, the entire texture will be locked.
// `surface` surface a pointer to an SDL surface of size **rect**. Don't assume
//                any specific pixel content.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_texture (SDL_LockTexture)
// See also: unlock_texture (SDL_UnlockTexture)
pub fn lock_texture_to_surface(texture &Texture, const_rect &Rect, surface &&Surface) bool {
	return C.SDL_LockTextureToSurface(texture, const_rect, surface)
}

// C.SDL_UnlockTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnlockTexture)
fn C.SDL_UnlockTexture(texture &Texture)

// unlock_texture unlocks a texture, uploading the changes to video memory, if needed.
//
// **Warning**: Please note that SDL_LockTexture() is intended to be
// write-only; it will not guarantee the previous contents of the texture will
// be provided. You must fully initialize any area of a texture that you lock
// before unlocking it, as the pixels might otherwise be uninitialized memory.
//
// Which is to say: locking and immediately unlocking a texture can result in
// corrupted textures, depending on the renderer in use.
//
// `texture` texture a texture locked by SDL_LockTexture().
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_texture (SDL_LockTexture)
pub fn unlock_texture(texture &Texture) {
	C.SDL_UnlockTexture(texture)
}

// C.SDL_SetRenderTarget [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetRenderTarget)
fn C.SDL_SetRenderTarget(renderer &Renderer, texture &Texture) bool

// set_render_target sets a texture as the current rendering target.
//
// The default render target is the window for which the renderer was created.
// To stop rendering to a texture and render to the window again, call this
// function with a NULL `texture`.
//
// `renderer` renderer the rendering context.
// `texture` texture the targeted texture, which must be created with the
//                `SDL_TEXTUREACCESS_TARGET` flag, or NULL to render to the
//                window instead of a texture.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_target (SDL_GetRenderTarget)
pub fn set_render_target(renderer &Renderer, texture &Texture) bool {
	return C.SDL_SetRenderTarget(renderer, texture)
}

// C.SDL_GetRenderTarget [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderTarget)
fn C.SDL_GetRenderTarget(renderer &Renderer) &Texture

// get_render_target gets the current render target.
//
// The default render target is the window for which the renderer was created,
// and is reported a NULL here.
//
// `renderer` renderer the rendering context.
// returns the current render target or NULL for the default render target.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_target (SDL_SetRenderTarget)
pub fn get_render_target(renderer &Renderer) &Texture {
	return C.SDL_GetRenderTarget(renderer)
}

// C.SDL_SetRenderLogicalPresentation [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetRenderLogicalPresentation)
fn C.SDL_SetRenderLogicalPresentation(renderer &Renderer, w int, h int, mode RendererLogicalPresentation) bool

// set_render_logical_presentation sets a device independent resolution and presentation mode for rendering.
//
// This function sets the width and height of the logical rendering output.
// The renderer will act as if the window is always the requested dimensions,
// scaling to the actual window resolution as necessary.
//
// This can be useful for games that expect a fixed size, but would like to
// scale the output to whatever is available, regardless of how a user resizes
// a window, or if the display is high DPI.
//
// You can disable logical coordinates by setting the mode to
// SDL_LOGICAL_PRESENTATION_DISABLED, and in that case you get the full pixel
// resolution of the output window; it is safe to toggle logical presentation
// during the rendering of a frame: perhaps most of the rendering is done to
// specific dimensions but to make fonts look sharp, the app turns off logical
// presentation while drawing text.
//
// Letterboxing will only happen if logical presentation is enabled during
// SDL_RenderPresent; be sure to reenable it first if you were using it.
//
// You can convert coordinates in an event into rendering coordinates using
// SDL_ConvertEventToRenderCoordinates().
//
// `renderer` renderer the rendering context.
// `w` w the width of the logical resolution.
// `h` h the height of the logical resolution.
// `mode` mode the presentation mode used.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: convert_event_to_render_coordinates (SDL_ConvertEventToRenderCoordinates)
// See also: get_render_logical_presentation (SDL_GetRenderLogicalPresentation)
// See also: get_render_logical_presentation_rect (SDL_GetRenderLogicalPresentationRect)
pub fn set_render_logical_presentation(renderer &Renderer, w int, h int, mode RendererLogicalPresentation) bool {
	return C.SDL_SetRenderLogicalPresentation(renderer, w, h, mode)
}

// C.SDL_GetRenderLogicalPresentation [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderLogicalPresentation)
fn C.SDL_GetRenderLogicalPresentation(renderer &Renderer, w &int, h &int, mode &RendererLogicalPresentation) bool

// get_render_logical_presentation gets device independent resolution and presentation mode for rendering.
//
// This function gets the width and height of the logical rendering output, or
// the output size in pixels if a logical resolution is not enabled.
//
// `renderer` renderer the rendering context.
// `w` w an int to be filled with the width.
// `h` h an int to be filled with the height.
// `mode` mode the presentation mode used.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_logical_presentation (SDL_SetRenderLogicalPresentation)
pub fn get_render_logical_presentation(renderer &Renderer, w &int, h &int, mode &RendererLogicalPresentation) bool {
	return C.SDL_GetRenderLogicalPresentation(renderer, w, h, &mode)
}

// C.SDL_GetRenderLogicalPresentationRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderLogicalPresentationRect)
fn C.SDL_GetRenderLogicalPresentationRect(renderer &Renderer, rect &FRect) bool

// get_render_logical_presentation_rect gets the final presentation rectangle for rendering.
//
// This function returns the calculated rectangle used for logical
// presentation, based on the presentation mode and output size. If logical
// presentation is disabled, it will fill the rectangle with the output size,
// in pixels.
//
// `renderer` renderer the rendering context.
// `rect` rect a pointer filled in with the final presentation rectangle, may
//             be NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_logical_presentation (SDL_SetRenderLogicalPresentation)
pub fn get_render_logical_presentation_rect(renderer &Renderer, rect &FRect) bool {
	return C.SDL_GetRenderLogicalPresentationRect(renderer, rect)
}

// C.SDL_RenderCoordinatesFromWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderCoordinatesFromWindow)
fn C.SDL_RenderCoordinatesFromWindow(renderer &Renderer, window_x f32, window_y f32, x &f32, y &f32) bool

// render_coordinates_from_window gets a point in render coordinates when given a point in window coordinates.
//
// This takes into account several states:
//
// - The window dimensions.
// - The logical presentation settings (SDL_SetRenderLogicalPresentation)
// - The scale (SDL_SetRenderScale)
// - The viewport (SDL_SetRenderViewport)
//
// `renderer` renderer the rendering context.
// `window_x` window_x the x coordinate in window coordinates.
// `window_y` window_y the y coordinate in window coordinates.
// `x` x a pointer filled with the x coordinate in render coordinates.
// `y` y a pointer filled with the y coordinate in render coordinates.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_logical_presentation (SDL_SetRenderLogicalPresentation)
// See also: set_render_scale (SDL_SetRenderScale)
pub fn render_coordinates_from_window(renderer &Renderer, window_x f32, window_y f32, x &f32, y &f32) bool {
	return C.SDL_RenderCoordinatesFromWindow(renderer, window_x, window_y, x, y)
}

// C.SDL_RenderCoordinatesToWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderCoordinatesToWindow)
fn C.SDL_RenderCoordinatesToWindow(renderer &Renderer, x f32, y f32, window_x &f32, window_y &f32) bool

// render_coordinates_to_window gets a point in window coordinates when given a point in render coordinates.
//
// This takes into account several states:
//
// - The window dimensions.
// - The logical presentation settings (SDL_SetRenderLogicalPresentation)
// - The scale (SDL_SetRenderScale)
// - The viewport (SDL_SetRenderViewport)
//
// `renderer` renderer the rendering context.
// `x` x the x coordinate in render coordinates.
// `y` y the y coordinate in render coordinates.
// `window_x` window_x a pointer filled with the x coordinate in window
//                 coordinates.
// `window_y` window_y a pointer filled with the y coordinate in window
//                 coordinates.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_logical_presentation (SDL_SetRenderLogicalPresentation)
// See also: set_render_scale (SDL_SetRenderScale)
// See also: set_render_viewport (SDL_SetRenderViewport)
pub fn render_coordinates_to_window(renderer &Renderer, x f32, y f32, window_x &f32, window_y &f32) bool {
	return C.SDL_RenderCoordinatesToWindow(renderer, x, y, window_x, window_y)
}

// C.SDL_ConvertEventToRenderCoordinates [official documentation](https://wiki.libsdl.org/SDL3/SDL_ConvertEventToRenderCoordinates)
fn C.SDL_ConvertEventToRenderCoordinates(renderer &Renderer, event &Event) bool

// convert_event_to_render_coordinates converts the coordinates in an event to render coordinates.
//
// This takes into account several states:
//
// - The window dimensions.
// - The logical presentation settings (SDL_SetRenderLogicalPresentation)
// - The scale (SDL_SetRenderScale)
// - The viewport (SDL_SetRenderViewport)
//
// Various event types are converted with this function: mouse, touch, pen,
// etc.
//
// Touch coordinates are converted from normalized coordinates in the window
// to non-normalized rendering coordinates.
//
// Relative mouse coordinates (xrel and yrel event fields) are _also_
// converted. Applications that do not want these fields converted should use
// SDL_RenderCoordinatesFromWindow() on the specific event fields instead of
// converting the entire event structure.
//
// Once converted, coordinates may be outside the rendering area.
//
// `renderer` renderer the rendering context.
// `event` event the event to modify.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_coordinates_from_window (SDL_RenderCoordinatesFromWindow)
pub fn convert_event_to_render_coordinates(renderer &Renderer, event &Event) bool {
	return C.SDL_ConvertEventToRenderCoordinates(renderer, event)
}

// C.SDL_SetRenderViewport [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetRenderViewport)
fn C.SDL_SetRenderViewport(renderer &Renderer, const_rect &Rect) bool

// set_render_viewport sets the drawing area for rendering on the current target.
//
// Drawing will clip to this area (separately from any clipping done with
// SDL_SetRenderClipRect), and the top left of the area will become coordinate
// (0, 0) for future drawing commands.
//
// The area's width and height must be >= 0.
//
// `renderer` renderer the rendering context.
// `rect` rect the SDL_Rect structure representing the drawing area, or NULL
//             to set the viewport to the entire target.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_viewport (SDL_GetRenderViewport)
// See also: render_viewport_set (SDL_RenderViewportSet)
pub fn set_render_viewport(renderer &Renderer, const_rect &Rect) bool {
	return C.SDL_SetRenderViewport(renderer, const_rect)
}

// C.SDL_GetRenderViewport [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderViewport)
fn C.SDL_GetRenderViewport(renderer &Renderer, rect &Rect) bool

// get_render_viewport gets the drawing area for the current target.
//
// `renderer` renderer the rendering context.
// `rect` rect an SDL_Rect structure filled in with the current drawing area.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_viewport_set (SDL_RenderViewportSet)
// See also: set_render_viewport (SDL_SetRenderViewport)
pub fn get_render_viewport(renderer &Renderer, rect &Rect) bool {
	return C.SDL_GetRenderViewport(renderer, rect)
}

// C.SDL_RenderViewportSet [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderViewportSet)
fn C.SDL_RenderViewportSet(renderer &Renderer) bool

// render_viewport_set returns whether an explicit rectangle was set as the viewport.
//
// This is useful if you're saving and restoring the viewport and want to know
// whether you should restore a specific rectangle or NULL. Note that the
// viewport is always reset when changing rendering targets.
//
// `renderer` renderer the rendering context.
// returns true if the viewport was set to a specific rectangle, or false if
//          it was set to NULL (the entire target).
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_viewport (SDL_GetRenderViewport)
// See also: set_render_viewport (SDL_SetRenderViewport)
pub fn render_viewport_set(renderer &Renderer) bool {
	return C.SDL_RenderViewportSet(renderer)
}

// C.SDL_GetRenderSafeArea [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderSafeArea)
fn C.SDL_GetRenderSafeArea(renderer &Renderer, rect &Rect) bool

// get_render_safe_area gets the safe area for rendering within the current viewport.
//
// Some devices have portions of the screen which are partially obscured or
// not interactive, possibly due to on-screen controls, curved edges, camera
// notches, TV overscan, etc. This function provides the area of the current
// viewport which is safe to have interactible content. You should continue
// rendering into the rest of the render target, but it should not contain
// visually important or interactible content.
//
// `renderer` renderer the rendering context.
// `rect` rect a pointer filled in with the area that is safe for interactive
//             content.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_render_safe_area(renderer &Renderer, rect &Rect) bool {
	return C.SDL_GetRenderSafeArea(renderer, rect)
}

// C.SDL_SetRenderClipRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetRenderClipRect)
fn C.SDL_SetRenderClipRect(renderer &Renderer, const_rect &Rect) bool

// set_render_clip_rect sets the clip rectangle for rendering on the specified target.
//
// `renderer` renderer the rendering context.
// `rect` rect an SDL_Rect structure representing the clip area, relative to
//             the viewport, or NULL to disable clipping.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_clip_rect (SDL_GetRenderClipRect)
// See also: render_clip_enabled (SDL_RenderClipEnabled)
pub fn set_render_clip_rect(renderer &Renderer, const_rect &Rect) bool {
	return C.SDL_SetRenderClipRect(renderer, const_rect)
}

// C.SDL_GetRenderClipRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderClipRect)
fn C.SDL_GetRenderClipRect(renderer &Renderer, rect &Rect) bool

// get_render_clip_rect gets the clip rectangle for the current target.
//
// `renderer` renderer the rendering context.
// `rect` rect an SDL_Rect structure filled in with the current clipping area
//             or an empty rectangle if clipping is disabled.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_clip_enabled (SDL_RenderClipEnabled)
// See also: set_render_clip_rect (SDL_SetRenderClipRect)
pub fn get_render_clip_rect(renderer &Renderer, rect &Rect) bool {
	return C.SDL_GetRenderClipRect(renderer, rect)
}

// C.SDL_RenderClipEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderClipEnabled)
fn C.SDL_RenderClipEnabled(renderer &Renderer) bool

// render_clip_enabled gets whether clipping is enabled on the given renderer.
//
// `renderer` renderer the rendering context.
// returns true if clipping is enabled or false if not; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_clip_rect (SDL_GetRenderClipRect)
// See also: set_render_clip_rect (SDL_SetRenderClipRect)
pub fn render_clip_enabled(renderer &Renderer) bool {
	return C.SDL_RenderClipEnabled(renderer)
}

// C.SDL_SetRenderScale [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetRenderScale)
fn C.SDL_SetRenderScale(renderer &Renderer, scale_x f32, scale_y f32) bool

// set_render_scale sets the drawing scale for rendering on the current target.
//
// The drawing coordinates are scaled by the x/y scaling factors before they
// are used by the renderer. This allows resolution independent drawing with a
// single coordinate system.
//
// If this results in scaling or subpixel drawing by the rendering backend, it
// will be handled using the appropriate quality hints. For best results use
// integer scaling factors.
//
// `renderer` renderer the rendering context.
// `scale_x` scaleX the horizontal scaling factor.
// `scale_y` scaleY the vertical scaling factor.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_scale (SDL_GetRenderScale)
pub fn set_render_scale(renderer &Renderer, scale_x f32, scale_y f32) bool {
	return C.SDL_SetRenderScale(renderer, scale_x, scale_y)
}

// C.SDL_GetRenderScale [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderScale)
fn C.SDL_GetRenderScale(renderer &Renderer, scale_x &f32, scale_y &f32) bool

// get_render_scale gets the drawing scale for the current target.
//
// `renderer` renderer the rendering context.
// `scale_x` scaleX a pointer filled in with the horizontal scaling factor.
// `scale_y` scaleY a pointer filled in with the vertical scaling factor.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_scale (SDL_SetRenderScale)
pub fn get_render_scale(renderer &Renderer, scale_x &f32, scale_y &f32) bool {
	return C.SDL_GetRenderScale(renderer, scale_x, scale_y)
}

// C.SDL_SetRenderDrawColor [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetRenderDrawColor)
fn C.SDL_SetRenderDrawColor(renderer &Renderer, r u8, g u8, b u8, a u8) bool

// set_render_draw_color sets the color used for drawing operations.
//
// Set the color for drawing or filling rectangles, lines, and points, and for
// SDL_RenderClear().
//
// `renderer` renderer the rendering context.
// `r` r the red value used to draw on the rendering target.
// `g` g the green value used to draw on the rendering target.
// `b` b the blue value used to draw on the rendering target.
// `a` a the alpha value used to draw on the rendering target; usually
//          `SDL_ALPHA_OPAQUE` (255). Use SDL_SetRenderDrawBlendMode to
//          specify how the alpha channel is used.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_draw_color (SDL_GetRenderDrawColor)
// See also: set_render_draw_color_float (SDL_SetRenderDrawColorFloat)
pub fn set_render_draw_color(renderer &Renderer, r u8, g u8, b u8, a u8) bool {
	return C.SDL_SetRenderDrawColor(renderer, r, g, b, a)
}

// C.SDL_SetRenderDrawColorFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetRenderDrawColorFloat)
fn C.SDL_SetRenderDrawColorFloat(renderer &Renderer, r f32, g f32, b f32, a f32) bool

// set_render_draw_color_float sets the color used for drawing operations (Rect, Line and Clear).
//
// Set the color for drawing or filling rectangles, lines, and points, and for
// SDL_RenderClear().
//
// `renderer` renderer the rendering context.
// `r` r the red value used to draw on the rendering target.
// `g` g the green value used to draw on the rendering target.
// `b` b the blue value used to draw on the rendering target.
// `a` a the alpha value used to draw on the rendering target. Use
//          SDL_SetRenderDrawBlendMode to specify how the alpha channel is
//          used.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_draw_color_float (SDL_GetRenderDrawColorFloat)
// See also: set_render_draw_color (SDL_SetRenderDrawColor)
pub fn set_render_draw_color_float(renderer &Renderer, r f32, g f32, b f32, a f32) bool {
	return C.SDL_SetRenderDrawColorFloat(renderer, r, g, b, a)
}

// C.SDL_GetRenderDrawColor [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderDrawColor)
fn C.SDL_GetRenderDrawColor(renderer &Renderer, r &u8, g &u8, b &u8, a &u8) bool

// get_render_draw_color gets the color used for drawing operations (Rect, Line and Clear).
//
// `renderer` renderer the rendering context.
// `r` r a pointer filled in with the red value used to draw on the
//          rendering target.
// `g` g a pointer filled in with the green value used to draw on the
//          rendering target.
// `b` b a pointer filled in with the blue value used to draw on the
//          rendering target.
// `a` a a pointer filled in with the alpha value used to draw on the
//          rendering target; usually `SDL_ALPHA_OPAQUE` (255).
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_draw_color_float (SDL_GetRenderDrawColorFloat)
// See also: set_render_draw_color (SDL_SetRenderDrawColor)
pub fn get_render_draw_color(renderer &Renderer, r &u8, g &u8, b &u8, a &u8) bool {
	return C.SDL_GetRenderDrawColor(renderer, r, g, b, a)
}

// C.SDL_GetRenderDrawColorFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderDrawColorFloat)
fn C.SDL_GetRenderDrawColorFloat(renderer &Renderer, r &f32, g &f32, b &f32, a &f32) bool

// get_render_draw_color_float gets the color used for drawing operations (Rect, Line and Clear).
//
// `renderer` renderer the rendering context.
// `r` r a pointer filled in with the red value used to draw on the
//          rendering target.
// `g` g a pointer filled in with the green value used to draw on the
//          rendering target.
// `b` b a pointer filled in with the blue value used to draw on the
//          rendering target.
// `a` a a pointer filled in with the alpha value used to draw on the
//          rendering target.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_draw_color_float (SDL_SetRenderDrawColorFloat)
// See also: get_render_draw_color (SDL_GetRenderDrawColor)
pub fn get_render_draw_color_float(renderer &Renderer, r &f32, g &f32, b &f32, a &f32) bool {
	return C.SDL_GetRenderDrawColorFloat(renderer, r, g, b, a)
}

// C.SDL_SetRenderColorScale [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetRenderColorScale)
fn C.SDL_SetRenderColorScale(renderer &Renderer, scale f32) bool

// set_render_color_scale sets the color scale used for render operations.
//
// The color scale is an additional scale multiplied into the pixel color
// value while rendering. This can be used to adjust the brightness of colors
// during HDR rendering, or changing HDR video brightness when playing on an
// SDR display.
//
// The color scale does not affect the alpha channel, only the color
// brightness.
//
// `renderer` renderer the rendering context.
// `scale` scale the color scale value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_color_scale (SDL_GetRenderColorScale)
pub fn set_render_color_scale(renderer &Renderer, scale f32) bool {
	return C.SDL_SetRenderColorScale(renderer, scale)
}

// C.SDL_GetRenderColorScale [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderColorScale)
fn C.SDL_GetRenderColorScale(renderer &Renderer, scale &f32) bool

// get_render_color_scale gets the color scale used for render operations.
//
// `renderer` renderer the rendering context.
// `scale` scale a pointer filled in with the current color scale value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_color_scale (SDL_SetRenderColorScale)
pub fn get_render_color_scale(renderer &Renderer, scale &f32) bool {
	return C.SDL_GetRenderColorScale(renderer, scale)
}

// C.SDL_SetRenderDrawBlendMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetRenderDrawBlendMode)
fn C.SDL_SetRenderDrawBlendMode(renderer &Renderer, blend_mode BlendMode) bool

// set_render_draw_blend_mode sets the blend mode used for drawing operations (Fill and Line).
//
// If the blend mode is not supported, the closest supported mode is chosen.
//
// `renderer` renderer the rendering context.
// `blend_mode` blendMode the SDL_BlendMode to use for blending.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_draw_blend_mode (SDL_GetRenderDrawBlendMode)
pub fn set_render_draw_blend_mode(renderer &Renderer, blend_mode BlendMode) bool {
	return C.SDL_SetRenderDrawBlendMode(renderer, blend_mode)
}

// C.SDL_GetRenderDrawBlendMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderDrawBlendMode)
fn C.SDL_GetRenderDrawBlendMode(renderer &Renderer, blend_mode &BlendMode) bool

// get_render_draw_blend_mode gets the blend mode used for drawing operations.
//
// `renderer` renderer the rendering context.
// `blend_mode` blendMode a pointer filled in with the current SDL_BlendMode.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_draw_blend_mode (SDL_SetRenderDrawBlendMode)
pub fn get_render_draw_blend_mode(renderer &Renderer, blend_mode &BlendMode) bool {
	return C.SDL_GetRenderDrawBlendMode(renderer, blend_mode)
}

// C.SDL_RenderClear [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderClear)
fn C.SDL_RenderClear(renderer &Renderer) bool

// render_clear clears the current rendering target with the drawing color.
//
// This function clears the entire rendering target, ignoring the viewport and
// the clip rectangle. Note, that clearing will also set/fill all pixels of
// the rendering target to current renderer draw color, so make sure to invoke
// SDL_SetRenderDrawColor() when needed.
//
// `renderer` renderer the rendering context.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_draw_color (SDL_SetRenderDrawColor)
pub fn render_clear(renderer &Renderer) bool {
	return C.SDL_RenderClear(renderer)
}

// C.SDL_RenderPoint [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderPoint)
fn C.SDL_RenderPoint(renderer &Renderer, x f32, y f32) bool

// render_point draws a point on the current rendering target at subpixel precision.
//
// `renderer` renderer the renderer which should draw a point.
// `x` x the x coordinate of the point.
// `y` y the y coordinate of the point.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_points (SDL_RenderPoints)
pub fn render_point(renderer &Renderer, x f32, y f32) bool {
	return C.SDL_RenderPoint(renderer, x, y)
}

// C.SDL_RenderPoints [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderPoints)
fn C.SDL_RenderPoints(renderer &Renderer, const_points &FPoint, count int) bool

// render_points draws multiple points on the current rendering target at subpixel precision.
//
// `renderer` renderer the renderer which should draw multiple points.
// `points` points the points to draw.
// `count` count the number of points to draw.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_point (SDL_RenderPoint)
pub fn render_points(renderer &Renderer, const_points &FPoint, count int) bool {
	return C.SDL_RenderPoints(renderer, const_points, count)
}

// C.SDL_RenderLine [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderLine)
fn C.SDL_RenderLine(renderer &Renderer, x1 f32, y1 f32, x2 f32, y2 f32) bool

// render_line draws a line on the current rendering target at subpixel precision.
//
// `renderer` renderer the renderer which should draw a line.
// `x1` x1 the x coordinate of the start point.
// `y1` y1 the y coordinate of the start point.
// `x2` x2 the x coordinate of the end point.
// `y2` y2 the y coordinate of the end point.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_lines (SDL_RenderLines)
pub fn render_line(renderer &Renderer, x1 f32, y1 f32, x2 f32, y2 f32) bool {
	return C.SDL_RenderLine(renderer, x1, y1, x2, y2)
}

// C.SDL_RenderLines [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderLines)
fn C.SDL_RenderLines(renderer &Renderer, const_points &FPoint, count int) bool

// render_lines draws a series of connected lines on the current rendering target at
// subpixel precision.
//
// `renderer` renderer the renderer which should draw multiple lines.
// `points` points the points along the lines.
// `count` count the number of points, drawing count-1 lines.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_line (SDL_RenderLine)
pub fn render_lines(renderer &Renderer, const_points &FPoint, count int) bool {
	return C.SDL_RenderLines(renderer, const_points, count)
}

// C.SDL_RenderRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderRect)
fn C.SDL_RenderRect(renderer &Renderer, const_rect &FRect) bool

// render_rect draws a rectangle on the current rendering target at subpixel precision.
//
// `renderer` renderer the renderer which should draw a rectangle.
// `rect` rect a pointer to the destination rectangle, or NULL to outline the
//             entire rendering target.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_rects (SDL_RenderRects)
pub fn render_rect(renderer &Renderer, const_rect &FRect) bool {
	return C.SDL_RenderRect(renderer, const_rect)
}

// C.SDL_RenderRects [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderRects)
fn C.SDL_RenderRects(renderer &Renderer, const_rects &FRect, count int) bool

// render_rects draws some number of rectangles on the current rendering target at subpixel
// precision.
//
// `renderer` renderer the renderer which should draw multiple rectangles.
// `rects` rects a pointer to an array of destination rectangles.
// `count` count the number of rectangles.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_rect (SDL_RenderRect)
pub fn render_rects(renderer &Renderer, const_rects &FRect, count int) bool {
	return C.SDL_RenderRects(renderer, const_rects, count)
}

// C.SDL_RenderFillRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderFillRect)
fn C.SDL_RenderFillRect(renderer &Renderer, const_rect &FRect) bool

// render_fill_rect fills a rectangle on the current rendering target with the drawing color at
// subpixel precision.
//
// `renderer` renderer the renderer which should fill a rectangle.
// `rect` rect a pointer to the destination rectangle, or NULL for the entire
//             rendering target.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_fill_rects (SDL_RenderFillRects)
pub fn render_fill_rect(renderer &Renderer, const_rect &FRect) bool {
	return C.SDL_RenderFillRect(renderer, const_rect)
}

// C.SDL_RenderFillRects [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderFillRects)
fn C.SDL_RenderFillRects(renderer &Renderer, const_rects &FRect, count int) bool

// render_fill_rects fills some number of rectangles on the current rendering target with the
// drawing color at subpixel precision.
//
// `renderer` renderer the renderer which should fill multiple rectangles.
// `rects` rects a pointer to an array of destination rectangles.
// `count` count the number of rectangles.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_fill_rect (SDL_RenderFillRect)
pub fn render_fill_rects(renderer &Renderer, const_rects &FRect, count int) bool {
	return C.SDL_RenderFillRects(renderer, const_rects, count)
}

// C.SDL_RenderTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderTexture)
fn C.SDL_RenderTexture(renderer &Renderer, texture &Texture, const_srcrect &FRect, const_dstrect &FRect) bool

// render_texture copys a portion of the texture to the current rendering target at subpixel
// precision.
//
// `renderer` renderer the renderer which should copy parts of a texture.
// `texture` texture the source texture.
// `srcrect` srcrect a pointer to the source rectangle, or NULL for the entire
//                texture.
// `dstrect` dstrect a pointer to the destination rectangle, or NULL for the
//                entire rendering target.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_texture_rotated (SDL_RenderTextureRotated)
// See also: render_texture_tiled (SDL_RenderTextureTiled)
pub fn render_texture(renderer &Renderer, texture &Texture, const_srcrect &FRect, const_dstrect &FRect) bool {
	return C.SDL_RenderTexture(renderer, texture, const_srcrect, const_dstrect)
}

// C.SDL_RenderTextureRotated [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderTextureRotated)
fn C.SDL_RenderTextureRotated(renderer &Renderer, texture &Texture, const_srcrect &FRect, const_dstrect &FRect, angle f64, const_center &FPoint, flip FlipMode) bool

// render_texture_rotated copys a portion of the source texture to the current rendering target, with
// rotation and flipping, at subpixel precision.
//
// `renderer` renderer the renderer which should copy parts of a texture.
// `texture` texture the source texture.
// `srcrect` srcrect a pointer to the source rectangle, or NULL for the entire
//                texture.
// `dstrect` dstrect a pointer to the destination rectangle, or NULL for the
//                entire rendering target.
// `angle` angle an angle in degrees that indicates the rotation that will be
//              applied to dstrect, rotating it in a clockwise direction.
// `center` center a pointer to a point indicating the point around which
//               dstrect will be rotated (if NULL, rotation will be done
//               around dstrect.w/2, dstrect.h/2).
// `flip` flip an SDL_FlipMode value stating which flipping actions should be
//             performed on the texture.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_texture (SDL_RenderTexture)
pub fn render_texture_rotated(renderer &Renderer, texture &Texture, const_srcrect &FRect, const_dstrect &FRect, angle f64, const_center &FPoint, flip FlipMode) bool {
	return C.SDL_RenderTextureRotated(renderer, texture, const_srcrect, const_dstrect,
		angle, const_center, flip)
}

// C.SDL_RenderTextureAffine [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderTextureAffine)
fn C.SDL_RenderTextureAffine(renderer &Renderer, texture &Texture, const_srcrect &FRect, const_origin &FPoint, const_right &FPoint, const_down &FPoint) bool

// render_texture_affine copys a portion of the source texture to the current rendering target, with
// affine transform, at subpixel precision.
//
// `renderer` renderer the renderer which should copy parts of a texture.
// `texture` texture the source texture.
// `srcrect` srcrect a pointer to the source rectangle, or NULL for the entire
//                texture.
// `origin` origin a pointer to a point indicating where the top-left corner of
//               srcrect should be mapped to, or NULL for the rendering
//               target's origin.
// `right` right a pointer to a point indicating where the top-right corner of
//              srcrect should be mapped to, or NULL for the rendering
//              target's top-right corner.
// `down` down a pointer to a point indicating where the bottom-left corner of
//             srcrect should be mapped to, or NULL for the rendering target's
//             bottom-left corner.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) You may only call this function from the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_texture (SDL_RenderTexture)
pub fn render_texture_affine(renderer &Renderer, texture &Texture, const_srcrect &FRect, const_origin &FPoint, const_right &FPoint, const_down &FPoint) bool {
	return C.SDL_RenderTextureAffine(renderer, texture, const_srcrect, const_origin, const_right,
		const_down)
}

// C.SDL_RenderTextureTiled [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderTextureTiled)
fn C.SDL_RenderTextureTiled(renderer &Renderer, texture &Texture, const_srcrect &FRect, scale f32, const_dstrect &FRect) bool

// render_texture_tiled tiles a portion of the texture to the current rendering target at subpixel
// precision.
//
// The pixels in `srcrect` will be repeated as many times as needed to
// completely fill `dstrect`.
//
// `renderer` renderer the renderer which should copy parts of a texture.
// `texture` texture the source texture.
// `srcrect` srcrect a pointer to the source rectangle, or NULL for the entire
//                texture.
// `scale` scale the scale used to transform srcrect into the destination
//              rectangle, e.g. a 32x32 texture with a scale of 2 would fill
//              64x64 tiles.
// `dstrect` dstrect a pointer to the destination rectangle, or NULL for the
//                entire rendering target.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_texture (SDL_RenderTexture)
pub fn render_texture_tiled(renderer &Renderer, texture &Texture, const_srcrect &FRect, scale f32, const_dstrect &FRect) bool {
	return C.SDL_RenderTextureTiled(renderer, texture, const_srcrect, scale, const_dstrect)
}

// C.SDL_RenderTexture9Grid [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderTexture9Grid)
fn C.SDL_RenderTexture9Grid(renderer &Renderer, texture &Texture, const_srcrect &FRect, left_width f32, right_width f32, top_height f32, bottom_height f32, scale f32, const_dstrect &FRect) bool

// render_texture9_grid performs a scaled copy using the 9-grid algorithm to the current rendering
// target at subpixel precision.
//
// The pixels in the texture are split into a 3x3 grid, using the different
// corner sizes for each corner, and the sides and center making up the
// remaining pixels. The corners are then scaled using `scale` and fit into
// the corners of the destination rectangle. The sides and center are then
// stretched into place to cover the remaining destination rectangle.
//
// `renderer` renderer the renderer which should copy parts of a texture.
// `texture` texture the source texture.
// `srcrect` srcrect the SDL_Rect structure representing the rectangle to be used
//                for the 9-grid, or NULL to use the entire texture.
// `left_width` left_width the width, in pixels, of the left corners in `srcrect`.
// `right_width` right_width the width, in pixels, of the right corners in `srcrect`.
// `top_height` top_height the height, in pixels, of the top corners in `srcrect`.
// `bottom_height` bottom_height the height, in pixels, of the bottom corners in
//                      `srcrect`.
// `scale` scale the scale used to transform the corner of `srcrect` into the
//              corner of `dstrect`, or 0.0f for an unscaled copy.
// `dstrect` dstrect a pointer to the destination rectangle, or NULL for the
//                entire rendering target.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_texture (SDL_RenderTexture)
pub fn render_texture9_grid(renderer &Renderer, texture &Texture, const_srcrect &FRect, left_width f32, right_width f32, top_height f32, bottom_height f32, scale f32, const_dstrect &FRect) bool {
	return C.SDL_RenderTexture9Grid(renderer, texture, const_srcrect, left_width, right_width,
		top_height, bottom_height, scale, const_dstrect)
}

// C.SDL_RenderGeometry [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderGeometry)
fn C.SDL_RenderGeometry(renderer &Renderer, texture &Texture, const_vertices &Vertex, num_vertices int, const_indices &int, num_indices int) bool

// render_geometry renders a list of triangles, optionally using a texture and indices into the
// vertex array Color and alpha modulation is done per vertex
// (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
//
// `renderer` renderer the rendering context.
// `texture` texture (optional) The SDL texture to use.
// `vertices` vertices vertices.
// `num_vertices` num_vertices number of vertices.
// `indices` indices (optional) An array of integer indices into the 'vertices'
//                array, if NULL all vertices will be rendered in sequential
//                order.
// `num_indices` num_indices number of indices.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_geometry_raw (SDL_RenderGeometryRaw)
pub fn render_geometry(renderer &Renderer, texture &Texture, const_vertices &Vertex, num_vertices int, const_indices &int, num_indices int) bool {
	return C.SDL_RenderGeometry(renderer, texture, const_vertices, num_vertices, const_indices,
		num_indices)
}

// C.SDL_RenderGeometryRaw [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderGeometryRaw)
fn C.SDL_RenderGeometryRaw(renderer &Renderer, texture &Texture, const_xy &f32, xy_stride int, const_color &FColor, color_stride int, const_uv &f32, uv_stride int, num_vertices int, const_indices voidptr, num_indices int, size_indices int) bool

// render_geometry_raw renders a list of triangles, optionally using a texture and indices into the
// vertex arrays Color and alpha modulation is done per vertex
// (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
//
// `renderer` renderer the rendering context.
// `texture` texture (optional) The SDL texture to use.
// `xy` xy vertex positions.
// `xy_stride` xy_stride byte size to move from one element to the next element.
// `color` color vertex colors (as SDL_FColor).
// `color_stride` color_stride byte size to move from one element to the next element.
// `uv` uv vertex normalized texture coordinates.
// `uv_stride` uv_stride byte size to move from one element to the next element.
// `num_vertices` num_vertices number of vertices.
// `indices` indices (optional) An array of indices into the 'vertices' arrays,
//                if NULL all vertices will be rendered in sequential order.
// `num_indices` num_indices number of indices.
// `size_indices` size_indices index size: 1 (byte), 2 (short), 4 (int).
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_geometry (SDL_RenderGeometry)
pub fn render_geometry_raw(renderer &Renderer, texture &Texture, const_xy &f32, xy_stride int, const_color &FColor, color_stride int, const_uv &f32, uv_stride int, num_vertices int, const_indices voidptr, num_indices int, size_indices int) bool {
	return C.SDL_RenderGeometryRaw(renderer, texture, const_xy, xy_stride, const_color,
		color_stride, const_uv, uv_stride, num_vertices, const_indices, num_indices, size_indices)
}

// C.SDL_RenderReadPixels [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderReadPixels)
fn C.SDL_RenderReadPixels(renderer &Renderer, const_rect &Rect) &Surface

// render_read_pixels reads pixels from the current rendering target.
//
// The returned surface should be freed with SDL_DestroySurface()
//
// **WARNING**: This is a very slow operation, and should not be used
// frequently. If you're using this on the main rendering target, it should be
// called after rendering and before SDL_RenderPresent().
//
// `renderer` renderer the rendering context.
// `rect` rect an SDL_Rect structure representing the area in pixels relative
//             to the to current viewport, or NULL for the entire viewport.
// returns a new SDL_Surface on success or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn render_read_pixels(renderer &Renderer, const_rect &Rect) &Surface {
	return C.SDL_RenderReadPixels(renderer, const_rect)
}

// C.SDL_RenderPresent [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderPresent)
fn C.SDL_RenderPresent(renderer &Renderer) bool

// render_present updates the screen with any rendering performed since the previous call.
//
// SDL's rendering functions operate on a backbuffer; that is, calling a
// rendering function such as SDL_RenderLine() does not directly put a line on
// the screen, but rather updates the backbuffer. As such, you compose your
// entire scene and *present* the composed backbuffer to the screen as a
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
// Please note, that in case of rendering to a texture - there is **no need**
// to call `SDL_RenderPresent` after drawing needed objects to a texture, and
// should not be done; you are only required to change back the rendering
// target to default via `SDL_SetRenderTarget(renderer, NULL)` afterwards, as
// textures by themselves do not have a concept of backbuffers. Calling
// SDL_RenderPresent while rendering to a texture will still update the screen
// with any current drawing that has been done _to the window itself_.
//
// `renderer` renderer the rendering context.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_renderer (SDL_CreateRenderer)
// See also: render_clear (SDL_RenderClear)
// See also: render_fill_rect (SDL_RenderFillRect)
// See also: render_fill_rects (SDL_RenderFillRects)
// See also: render_line (SDL_RenderLine)
// See also: render_lines (SDL_RenderLines)
// See also: render_point (SDL_RenderPoint)
// See also: render_points (SDL_RenderPoints)
// See also: render_rect (SDL_RenderRect)
// See also: render_rects (SDL_RenderRects)
// See also: set_render_draw_blend_mode (SDL_SetRenderDrawBlendMode)
// See also: set_render_draw_color (SDL_SetRenderDrawColor)
pub fn render_present(renderer &Renderer) bool {
	return C.SDL_RenderPresent(renderer)
}

// C.SDL_DestroyTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyTexture)
fn C.SDL_DestroyTexture(texture &Texture)

// destroy_texture destroys the specified texture.
//
// Passing NULL or an otherwise invalid texture will set the SDL error message
// to "Invalid texture".
//
// `texture` texture the texture to destroy.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_texture (SDL_CreateTexture)
// See also: create_texture_from_surface (SDL_CreateTextureFromSurface)
pub fn destroy_texture(texture &Texture) {
	C.SDL_DestroyTexture(texture)
}

// C.SDL_DestroyRenderer [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyRenderer)
fn C.SDL_DestroyRenderer(renderer &Renderer)

// destroy_renderer destroys the rendering context for a window and free all associated
// textures.
//
// This should be called before destroying the associated window.
//
// `renderer` renderer the rendering context.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_renderer (SDL_CreateRenderer)
pub fn destroy_renderer(renderer &Renderer) {
	C.SDL_DestroyRenderer(renderer)
}

// C.SDL_FlushRenderer [official documentation](https://wiki.libsdl.org/SDL3/SDL_FlushRenderer)
fn C.SDL_FlushRenderer(renderer &Renderer) bool

// flush_renderer forces the rendering context to flush any pending commands and state.
//
// You do not need to (and in fact, shouldn't) call this function unless you
// are planning to call into OpenGL/Direct3D/Metal/whatever directly, in
// addition to using an SDL_Renderer.
//
// This is for a very-specific case: if you are using SDL's render API, and
// you plan to make OpenGL/D3D/whatever calls in addition to SDL render API
// calls. If this applies, you should call this function between calls to
// SDL's render API and the low-level API you're using in cooperation.
//
// In all other cases, you can ignore this function.
//
// This call makes SDL flush any pending rendering work it was queueing up to
// do later in a single batch, and marks any internal cached state as invalid,
// so it'll prepare all its state again later, from scratch.
//
// This means you do not need to save state in your rendering code to protect
// the SDL renderer. However, there lots of arbitrary pieces of Direct3D and
// OpenGL state that can confuse things; you should use your best judgment and
// be prepared to make changes if specific state needs to be protected.
//
// `renderer` renderer the rendering context.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn flush_renderer(renderer &Renderer) bool {
	return C.SDL_FlushRenderer(renderer)
}

// C.SDL_GetRenderMetalLayer [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderMetalLayer)
fn C.SDL_GetRenderMetalLayer(renderer &Renderer) voidptr

// get_render_metal_layer gets the CAMetalLayer associated with the given Metal renderer.
//
// This function returns `void *`, so SDL doesn't have to include Metal's
// headers, but it can be safely cast to a `CAMetalLayer *`.
//
// `renderer` renderer the renderer to query.
// returns a `CAMetalLayer *` on success, or NULL if the renderer isn't a
//          Metal renderer.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_metal_command_encoder (SDL_GetRenderMetalCommandEncoder)
pub fn get_render_metal_layer(renderer &Renderer) voidptr {
	return C.SDL_GetRenderMetalLayer(renderer)
}

// C.SDL_GetRenderMetalCommandEncoder [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderMetalCommandEncoder)
fn C.SDL_GetRenderMetalCommandEncoder(renderer &Renderer) voidptr

// get_render_metal_command_encoder gets the Metal command encoder for the current frame.
//
// This function returns `void *`, so SDL doesn't have to include Metal's
// headers, but it can be safely cast to an `id<MTLRenderCommandEncoder>`.
//
// This will return NULL if Metal refuses to give SDL a drawable to render to,
// which might happen if the window is hidden/minimized/offscreen. This
// doesn't apply to command encoders for render targets, just the window's
// backbuffer. Check your return values!
//
// `renderer` renderer the renderer to query.
// returns an `id<MTLRenderCommandEncoder>` on success, or NULL if the
//          renderer isn't a Metal renderer or there was an error.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_metal_layer (SDL_GetRenderMetalLayer)
pub fn get_render_metal_command_encoder(renderer &Renderer) voidptr {
	return C.SDL_GetRenderMetalCommandEncoder(renderer)
}

// C.SDL_AddVulkanRenderSemaphores [official documentation](https://wiki.libsdl.org/SDL3/SDL_AddVulkanRenderSemaphores)
fn C.SDL_AddVulkanRenderSemaphores(renderer &Renderer, wait_stage_mask u32, wait_semaphore i64, signal_semaphore i64) bool

// add_vulkan_render_semaphores adds a set of synchronization semaphores for the current frame.
//
// The Vulkan renderer will wait for `wait_semaphore` before submitting
// rendering commands and signal `signal_semaphore` after rendering commands
// are complete for this frame.
//
// This should be called each frame that you want semaphore synchronization.
// The Vulkan renderer may have multiple frames in flight on the GPU, so you
// should have multiple semaphores that are used for synchronization. Querying
// SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER will give you the
// maximum number of semaphores you'll need.
//
// `renderer` renderer the rendering context.
// `wait_stage_mask` wait_stage_mask the VkPipelineStageFlags for the wait.
// `wait_semaphore` wait_semaphore a VkSempahore to wait on before rendering the current
//                       frame, or 0 if not needed.
// `signal_semaphore` signal_semaphore a VkSempahore that SDL will signal when rendering
//                         for the current frame is complete, or 0 if not
//                         needed.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is **NOT** safe to call this function from two threads at
//               once.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn add_vulkan_render_semaphores(renderer &Renderer, wait_stage_mask u32, wait_semaphore i64, signal_semaphore i64) bool {
	return C.SDL_AddVulkanRenderSemaphores(renderer, wait_stage_mask, wait_semaphore,
		signal_semaphore)
}

// C.SDL_SetRenderVSync [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetRenderVSync)
fn C.SDL_SetRenderVSync(renderer &Renderer, vsync int) bool

// set_render_v_sync toggles VSync of the given renderer.
//
// When a renderer is created, vsync defaults to SDL_RENDERER_VSYNC_DISABLED.
//
// The `vsync` parameter can be 1 to synchronize present with every vertical
// refresh, 2 to synchronize present with every second vertical refresh, etc.,
// SDL_RENDERER_VSYNC_ADAPTIVE for late swap tearing (adaptive vsync), or
// SDL_RENDERER_VSYNC_DISABLED to disable. Not every value is supported by
// every driver, so you should check the return value to see whether the
// requested setting is supported.
//
// `renderer` renderer the renderer to toggle.
// `vsync` vsync the vertical refresh sync interval.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_v_sync (SDL_GetRenderVSync)
pub fn set_render_v_sync(renderer &Renderer, vsync int) bool {
	return C.SDL_SetRenderVSync(renderer, vsync)
}

pub const renderer_vsync_disabled = C.SDL_RENDERER_VSYNC_DISABLED // 0

pub const renderer_vsync_adaptive = C.SDL_RENDERER_VSYNC_ADAPTIVE // (-1)

// C.SDL_GetRenderVSync [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRenderVSync)
fn C.SDL_GetRenderVSync(renderer &Renderer, vsync &int) bool

// get_render_v_sync gets VSync of the given renderer.
//
// `renderer` renderer the renderer to toggle.
// `vsync` vsync an int filled with the current vertical refresh sync interval.
//              See SDL_SetRenderVSync() for the meaning of the value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_v_sync (SDL_SetRenderVSync)
pub fn get_render_v_sync(renderer &Renderer, vsync &int) bool {
	return C.SDL_GetRenderVSync(renderer, vsync)
}

// The size, in pixels, of a single SDL_RenderDebugText() character.
//
// The font is monospaced and square, so this applies to all characters.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_RenderDebugText
pub const debug_text_font_character_size = C.SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE // 8

// C.SDL_RenderDebugText [official documentation](https://wiki.libsdl.org/SDL3/SDL_RenderDebugText)
fn C.SDL_RenderDebugText(renderer &Renderer, x f32, y f32, const_str &char) bool

// render_debug_text draws debug text to an SDL_Renderer.
//
// This function will render a string of text to an SDL_Renderer. Note that
// this is a convenience function for debugging, with severe limitations, and
// not intended to be used for production apps and games.
//
// Among these limitations:
//
// - It accepts UTF-8 strings, but will only renders ASCII characters.
// - It has a single, tiny size (8x8 pixels). One can use logical presentation
//   or scaling to adjust it, but it will be blurry.
// - It uses a simple, hardcoded bitmap font. It does not allow different font
//   selections and it does not support truetype, for proper scaling.
// - It does no word-wrapping and does not treat newline characters as a line
//   break. If the text goes out of the window, it's gone.
//
// For serious text rendering, there are several good options, such as
// SDL_ttf, stb_truetype, or other external libraries.
//
// On first use, this will create an internal texture for rendering glyphs.
// This texture will live until the renderer is destroyed.
//
// The text is drawn in the color specified by SDL_SetRenderDrawColor().
//
// `renderer` renderer the renderer which should draw a line of text.
// `x` x the x coordinate where the top-left corner of the text will draw.
// `y` y the y coordinate where the top-left corner of the text will draw.
// `str` str the string to render.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_debug_text_format (SDL_RenderDebugTextFormat)
// See also: debugtextfontcharactersize (SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE)
pub fn render_debug_text(renderer &Renderer, x f32, y f32, const_str &char) bool {
	return C.SDL_RenderDebugText(renderer, x, y, const_str)
}

// TODO: extern SDL_DECLSPEC bool SDLCALL SDL_RenderDebugTextFormat(SDL_Renderer *renderer, float x, float y, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(4);

// render_debug_text_format draws debug text to an SDL_Renderer.
//
// This function will render a printf()-style format string to a renderer.
// Note that this is a convinence function for debugging, with severe
// limitations, and is not intended to be used for production apps and games.
//
// For the full list of limitations and other useful information, see
// SDL_RenderDebugText.
//
// `renderer` renderer the renderer which should draw the text.
// `x` x the x coordinate where the top-left corner of the text will draw.
// `y` y the y coordinate where the top-left corner of the text will draw.
// `fmt` fmt the format string to draw.
// `...` ... additional parameters matching % tokens in the `fmt` string, if
//            any.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: render_debug_text (SDL_RenderDebugText)
// See also: debugtextfontcharactersize (SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE)
// TODO: render_debug_text_format(renderer &Renderer, x f32, y f32, const_fmt &char, ...) bool {}
