// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_gpu.h
//

// The GPU API offers a cross-platform way for apps to talk to modern graphics
// hardware. It offers both 3D graphics and compute support, in the style of
// Metal, Vulkan, and Direct3D 12.
//
// A basic workflow might be something like this:
//
// The app creates a GPU device with SDL_CreateGPUDevice(), and assigns it to
// a window with SDL_ClaimWindowForGPUDevice()--although strictly speaking you
// can render offscreen entirely, perhaps for image processing, and not use a
// window at all.
//
// Next the app prepares static data (things that are created once and used
// over and over). For example:
//
// - Shaders (programs that run on the GPU): use SDL_CreateGPUShader().
// - Vertex buffers (arrays of geometry data) and other data rendering will
//   need: use SDL_UploadToGPUBuffer().
// - Textures (images): use SDL_UploadToGPUTexture().
// - Samplers (how textures should be read from): use SDL_CreateGPUSampler().
// - Render pipelines (precalculated rendering state): use
//   SDL_CreateGPUGraphicsPipeline()
//
// To render, the app creates one or more command buffers, with
// SDL_AcquireGPUCommandBuffer(). Command buffers collect rendering
// instructions that will be submitted to the GPU in batch. Complex scenes can
// use multiple command buffers, maybe configured across multiple threads in
// parallel, as long as they are submitted in the correct order, but many apps
// will just need one command buffer per frame.
//
// Rendering can happen to a texture (what other APIs call a "render target")
// or it can happen to the swapchain texture (which is just a special texture
// that represents a window's contents). The app can use
// SDL_WaitAndAcquireGPUSwapchainTexture() to render to the window.
//
// Rendering actually happens in a Render Pass, which is encoded into a
// command buffer. One can encode multiple render passes (or alternate between
// render and compute passes) in a single command buffer, but many apps might
// simply need a single render pass in a single command buffer. Render Passes
// can render to up to four color textures and one depth texture
// simultaneously. If the set of textures being rendered to needs to change,
// the Render Pass must be ended and a new one must be begun.
//
// The app calls SDL_BeginGPURenderPass(). Then it sets states it needs for
// each draw:
//
// - SDL_BindGPUGraphicsPipeline()
// - SDL_SetGPUViewport()
// - SDL_BindGPUVertexBuffers()
// - SDL_BindGPUVertexSamplers()
// - etc
//
// Then, make the actual draw commands with these states:
//
// - SDL_DrawGPUPrimitives()
// - SDL_DrawGPUPrimitivesIndirect()
// - SDL_DrawGPUIndexedPrimitivesIndirect()
// - etc
//
// After all the drawing commands for a pass are complete, the app should call
// SDL_EndGPURenderPass(). Once a render pass ends all render-related state is
// reset.
//
// The app can begin new Render Passes and make new draws in the same command
// buffer until the entire scene is rendered.
//
// Once all of the render commands for the scene are complete, the app calls
// SDL_SubmitGPUCommandBuffer() to send it to the GPU for processing.
//
// If the app needs to read back data from texture or buffers, the API has an
// efficient way of doing this, provided that the app is willing to tolerate
// some latency. When the app uses SDL_DownloadFromGPUTexture() or
// SDL_DownloadFromGPUBuffer(), submitting the command buffer with
// SDL_SubmitGPUCommandBufferAndAcquireFence() will return a fence handle that
// the app can poll or wait on in a thread. Once the fence indicates that the
// command buffer is done processing, it is safe to read the downloaded data.
// Make sure to call SDL_ReleaseGPUFence() when done with the fence.
//
// The API also has "compute" support. The app calls SDL_BeginGPUComputePass()
// with compute-writeable textures and/or buffers, which can be written to in
// a compute shader. Then it sets states it needs for the compute dispatches:
//
// - SDL_BindGPUComputePipeline()
// - SDL_BindGPUComputeStorageBuffers()
// - SDL_BindGPUComputeStorageTextures()
//
// Then, dispatch compute work:
//
// - SDL_DispatchGPUCompute()
//
// For advanced users, this opens up powerful GPU-driven workflows.
//
// Graphics and compute pipelines require the use of shaders, which as
// mentioned above are small programs executed on the GPU. Each backend
// (Vulkan, Metal, D3D12) requires a different shader format. When the app
// creates the GPU device, the app lets the device know which shader formats
// the app can provide. It will then select the appropriate backend depending
// on the available shader formats and the backends available on the platform.
// When creating shaders, the app must provide the correct shader format for
// the selected backend. If you would like to learn more about why the API
// works this way, there is a detailed
// [blog post](https://moonside.games/posts/layers-all-the-way-down/)
// explaining this situation.
//
// It is optimal for apps to pre-compile the shader formats they might use,
// but for ease of use SDL provides a separate project,
// [SDL_shadercross](https://github.com/libsdl-org/SDL_shadercross)
// , for performing runtime shader cross-compilation. It also has a CLI
// interface for offline precompilation as well.
//
// This is an extremely quick overview that leaves out several important
// details. Already, though, one can see that GPU programming can be quite
// complex! If you just need simple 2D graphics, the
// [Render API](https://wiki.libsdl.org/SDL3/CategoryRender)
// is much easier to use but still hardware-accelerated. That said, even for
// 2D applications the performance benefits and expressiveness of the GPU API
// are significant.
//
// The GPU API targets a feature set with a wide range of hardware support and
// ease of portability. It is designed so that the app won't have to branch
// itself by querying feature support. If you need cutting-edge features with
// limited hardware support, this API is probably not for you.
//
// Examples demonstrating proper usage of this API can be found
// [here](https://github.com/TheSpydog/SDL_gpu_examples)
// .
//
// ## Performance considerations
//
// Here are some basic tips for maximizing your rendering performance.
//
// - Beginning a new render pass is relatively expensive. Use as few render
//   passes as you can.
// - Minimize the amount of state changes. For example, binding a pipeline is
//   relatively cheap, but doing it hundreds of times when you don't need to
//   will slow the performance significantly.
// - Perform your data uploads as early as possible in the frame.
// - Don't churn resources. Creating and releasing resources is expensive.
//   It's better to create what you need up front and cache it.
// - Don't use uniform buffers for large amounts of data (more than a matrix
//   or so). Use a storage buffer instead.
// - Use cycling correctly. There is a detailed explanation of cycling further
//   below.
// - Use culling techniques to minimize pixel writes. The less writing the GPU
//   has to do the better. Culling can be a very advanced topic but even
//   simple culling techniques can boost performance significantly.
//
// In general try to remember the golden rule of performance: doing things is
// more expensive than not doing things. Don't Touch The Driver!
//
// ## FAQ
//
// **Question: When are you adding more advanced features, like ray tracing or
// mesh shaders?**
//
// Answer: We don't have immediate plans to add more bleeding-edge features,
// but we certainly might in the future, when these features prove worthwhile,
// and reasonable to implement across several platforms and underlying APIs.
// So while these things are not in the "never" category, they are definitely
// not "near future" items either.
//
// **Question: Why is my shader not working?**
//
// Answer: A common oversight when using shaders is not properly laying out
// the shader resources/registers correctly. The GPU API is very strict with
// how it wants resources to be laid out and it's difficult for the API to
// automatically validate shaders to see if they have a compatible layout. See
// the documentation for SDL_CreateGPUShader() and
// SDL_CreateGPUComputePipeline() for information on the expected layout.
//
// Another common issue is not setting the correct number of samplers,
// textures, and buffers in SDL_GPUShaderCreateInfo. If possible use shader
// reflection to extract the required information from the shader
// automatically instead of manually filling in the struct's values.
//
// **Question: My application isn't performing very well. Is this the GPU
// API's fault?**
//
// Answer: No. Long answer: The GPU API is a relatively thin layer over the
// underlying graphics API. While it's possible that we have done something
// inefficiently, it's very unlikely especially if you are relatively
// inexperienced with GPU rendering. Please see the performance tips above and
// make sure you are following them. Additionally, tools like RenderDoc can be
// very helpful for diagnosing incorrect behavior and performance issues.
//
// ## System Requirements
//
// **Vulkan:** Supported on Windows, Linux, Nintendo Switch, and certain
// Android devices. Requires Vulkan 1.0 with the following extensions and
// device features:
//
// - `VK_KHR_swapchain`
// - `VK_KHR_maintenance1`
// - `independentBlend`
// - `imageCubeArray`
// - `depthClamp`
// - `shaderClipDistance`
// - `drawIndirectFirstInstance`
//
// **D3D12:** Supported on Windows 10 or newer, Xbox One (GDK), and Xbox
// Series X|S (GDK). Requires a GPU that supports DirectX 12 Feature Level
// 11_1.
//
// **Metal:** Supported on macOS 10.14+ and iOS/tvOS 13.0+. Hardware
// requirements vary by operating system:
//
// - macOS requires an Apple Silicon or
//   [Intel Mac2 family](https://developer.apple.com/documentation/metal/mtlfeatureset/mtlfeatureset_macos_gpufamily2_v1?language=objc)
//   GPU
// - iOS/tvOS requires an A9 GPU or newer
// - iOS Simulator and tvOS Simulator are unsupported
//
// ## Uniform Data
//
// Uniforms are for passing data to shaders. The uniform data will be constant
// across all executions of the shader.
//
// There are 4 available uniform slots per shader stage (where the stages are
// vertex, fragment, and compute). Uniform data pushed to a slot on a stage
// keeps its value throughout the command buffer until you call the relevant
// Push function on that slot again.
//
// For example, you could write your vertex shaders to read a camera matrix
// from uniform binding slot 0, push the camera matrix at the start of the
// command buffer, and that data will be used for every subsequent draw call.
//
// It is valid to push uniform data during a render or compute pass.
//
// Uniforms are best for pushing small amounts of data. If you are pushing
// more than a matrix or two per call you should consider using a storage
// buffer instead.
//
// ## A Note On Cycling
//
// When using a command buffer, operations do not occur immediately - they
// occur some time after the command buffer is submitted.
//
// When a resource is used in a pending or active command buffer, it is
// considered to be "bound". When a resource is no longer used in any pending
// or active command buffers, it is considered to be "unbound".
//
// If data resources are bound, it is unspecified when that data will be
// unbound unless you acquire a fence when submitting the command buffer and
// wait on it. However, this doesn't mean you need to track resource usage
// manually.
//
// All of the functions and structs that involve writing to a resource have a
// "cycle" bool. SDL_GPUTransferBuffer, SDL_GPUBuffer, and SDL_GPUTexture all
// effectively function as ring buffers on internal resources. When cycle is
// true, if the resource is bound, the cycle rotates to the next unbound
// internal resource, or if none are available, a new one is created. This
// means you don't have to worry about complex state tracking and
// synchronization as long as cycling is correctly employed.
//
// For example: you can call SDL_MapGPUTransferBuffer(), write texture data,
// SDL_UnmapGPUTransferBuffer(), and then SDL_UploadToGPUTexture(). The next
// time you write texture data to the transfer buffer, if you set the cycle
// param to true, you don't have to worry about overwriting any data that is
// not yet uploaded.
//
// Another example: If you are using a texture in a render pass every frame,
// this can cause a data dependency between frames. If you set cycle to true
// in the SDL_GPUColorTargetInfo struct, you can prevent this data dependency.
//
// Cycling will never undefine already bound data. When cycling, all data in
// the resource is considered to be undefined for subsequent commands until
// that data is written again. You must take care not to read undefined data.
//
// Note that when cycling a texture, the entire texture will be cycled, even
// if only part of the texture is used in the call, so you must consider the
// entire texture to contain undefined data after cycling.
//
// You must also take care not to overwrite a section of data that has been
// referenced in a command without cycling first. It is OK to overwrite
// unreferenced data in a bound resource without cycling, but overwriting a
// section of data that has already been referenced will produce unexpected
// results.

// Specifies how a texture is intended to be used by the client.
//
// A texture must have at least one usage flag. Note that some usage flag
// combinations are invalid.
//
// With regards to compute storage usage, READ | WRITE means that you can have
// shader A that only writes into the texture and shader B that only reads
// from the texture and bind the same texture to either shader respectively.
// SIMULTANEOUS means that you can do reads and writes within the same shader
// or compute pass. It also implies that atomic ops can be used, since those
// are read-modify-write operations. If you use SIMULTANEOUS, you are
// responsible for avoiding data races, as there is no data synchronization
// within a compute pass. Note that SIMULTANEOUS usage is only supported by a
// limited number of texture formats.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: create_gpu_texture (SDL_CreateGPUTexture)
pub type GpuTextureUsageFlags = u32

// Specifies how a buffer is intended to be used by the client.
//
// A buffer must have at least one usage flag. Note that some usage flag
// combinations are invalid.
//
// Unlike textures, READ | WRITE can be used for simultaneous read-write
// usage. The same data synchronization concerns as textures apply.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: create_gpu_buffer (SDL_CreateGPUBuffer)
pub type GpuBufferUsageFlags = u32

// Specifies the format of shader code.
//
// Each format corresponds to a specific backend that accepts it.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: create_gpu_shader (SDL_CreateGPUShader)
pub type GpuShaderFormat = u32

// Specifies which color components are written in a graphics pipeline.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: create_gpu_graphics_pipeline (SDL_CreateGPUGraphicsPipeline)
pub type GpuColorComponentFlags = u8

@[noinit; typedef]
pub struct C.SDL_GPUDevice {
	// NOTE: Opaque type
}

pub type GPUDevice = C.SDL_GPUDevice

@[noinit; typedef]
pub struct C.SDL_GPUBuffer {
	// NOTE: Opaque type
}

pub type GPUBuffer = C.SDL_GPUBuffer

@[noinit; typedef]
pub struct C.SDL_GPUTransferBuffer {
	// NOTE: Opaque type
}

pub type GPUTransferBuffer = C.SDL_GPUTransferBuffer

@[noinit; typedef]
pub struct C.SDL_GPUTexture {
	// NOTE: Opaque type
}

pub type GPUTexture = C.SDL_GPUTexture

@[noinit; typedef]
pub struct C.SDL_GPUSampler {
	// NOTE: Opaque type
}

pub type GPUSampler = C.SDL_GPUSampler

@[noinit; typedef]
pub struct C.SDL_GPUShader {
	// NOTE: Opaque type
}

pub type GPUShader = C.SDL_GPUShader

@[noinit; typedef]
pub struct C.SDL_GPUComputePipeline {
	// NOTE: Opaque type
}

pub type GPUComputePipeline = C.SDL_GPUComputePipeline

@[noinit; typedef]
pub struct C.SDL_GPUGraphicsPipeline {
	// NOTE: Opaque type
}

pub type GPUGraphicsPipeline = C.SDL_GPUGraphicsPipeline

@[noinit; typedef]
pub struct C.SDL_GPUCommandBuffer {
	// NOTE: Opaque type
}

pub type GPUCommandBuffer = C.SDL_GPUCommandBuffer

@[noinit; typedef]
pub struct C.SDL_GPURenderPass {
	// NOTE: Opaque type
}

pub type GPURenderPass = C.SDL_GPURenderPass

@[noinit; typedef]
pub struct C.SDL_GPUComputePass {
	// NOTE: Opaque type
}

pub type GPUComputePass = C.SDL_GPUComputePass

@[noinit; typedef]
pub struct C.SDL_GPUCopyPass {
	// NOTE: Opaque type
}

pub type GPUCopyPass = C.SDL_GPUCopyPass

@[noinit; typedef]
pub struct C.SDL_GPUFence {
	// NOTE: Opaque type
}

pub type GPUFence = C.SDL_GPUFence

// GPUPrimitiveType is C.SDL_GPUPrimitiveType
pub enum GPUPrimitiveType {
	trianglelist  = C.SDL_GPU_PRIMITIVETYPE_TRIANGLELIST  // `trianglelist` A series of separate triangles.
	trianglestrip = C.SDL_GPU_PRIMITIVETYPE_TRIANGLESTRIP // `trianglestrip` A series of connected triangles.
	linelist      = C.SDL_GPU_PRIMITIVETYPE_LINELIST      // `linelist` A series of separate lines.
	linestrip     = C.SDL_GPU_PRIMITIVETYPE_LINESTRIP     // `linestrip` A series of connected lines.
	pointlist     = C.SDL_GPU_PRIMITIVETYPE_POINTLIST     // `pointlist` A series of separate points.
}

// GPULoadOp is C.SDL_GPULoadOp
pub enum GPULoadOp {
	load      = C.SDL_GPU_LOADOP_LOAD      // `load` The previous contents of the texture will be preserved.
	clear     = C.SDL_GPU_LOADOP_CLEAR     // `clear` The contents of the texture will be cleared to a color.
	dont_care = C.SDL_GPU_LOADOP_DONT_CARE // `dont_care` The previous contents of the texture need not be preserved. The contents will be undefined.
}

// GPUStoreOp is C.SDL_GPUStoreOp
pub enum GPUStoreOp {
	store             = C.SDL_GPU_STOREOP_STORE             // `store` The contents generated during the render pass will be written to memory.
	dont_care         = C.SDL_GPU_STOREOP_DONT_CARE         // `dont_care` The contents generated during the render pass are not needed and may be discarded. The contents will be undefined.
	resolve           = C.SDL_GPU_STOREOP_RESOLVE           // `resolve` The multisample contents generated during the render pass will be resolved to a non-multisample texture. The contents in the multisample texture may then be discarded and will be undefined.
	resolve_and_store = C.SDL_GPU_STOREOP_RESOLVE_AND_STORE // `resolve_and_store` The multisample contents generated during the render pass will be resolved to a non-multisample texture. The contents in the multisample texture will be written to memory.
}

// GPUIndexElementSize is C.SDL_GPUIndexElementSize
pub enum GPUIndexElementSize {
	_16bit = C.SDL_GPU_INDEXELEMENTSIZE_16BIT // `_16bit` The index elements are 16-bit.
	_32bit = C.SDL_GPU_INDEXELEMENTSIZE_32BIT // `_32bit` The index elements are 32-bit.
}

// GPUTextureFormat is C.SDL_GPUTextureFormat
pub enum GPUTextureFormat {
	invalid = C.SDL_GPU_TEXTUREFORMAT_INVALID
	// Unsigned Normalized Float Color Formats
	a8_unorm           = C.SDL_GPU_TEXTUREFORMAT_A8_UNORM
	r8_unorm           = C.SDL_GPU_TEXTUREFORMAT_R8_UNORM
	r8g8_unorm         = C.SDL_GPU_TEXTUREFORMAT_R8G8_UNORM
	r8g8b8a8_unorm     = C.SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM
	r16_unorm          = C.SDL_GPU_TEXTUREFORMAT_R16_UNORM
	r16g16_unorm       = C.SDL_GPU_TEXTUREFORMAT_R16G16_UNORM
	r16g16b16a16_unorm = C.SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UNORM
	r10g10b10a2_unorm  = C.SDL_GPU_TEXTUREFORMAT_R10G10B10A2_UNORM
	b5g6r5_unorm       = C.SDL_GPU_TEXTUREFORMAT_B5G6R5_UNORM
	b5g5r5a1_unorm     = C.SDL_GPU_TEXTUREFORMAT_B5G5R5A1_UNORM
	b4g4r4a4_unorm     = C.SDL_GPU_TEXTUREFORMAT_B4G4R4A4_UNORM
	b8g8r8a8_unorm     = C.SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM
	// Compressed Unsigned Normalized Float Color Formats
	bc1_rgba_unorm = C.SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM
	bc2_rgba_unorm = C.SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM
	bc3_rgba_unorm = C.SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM
	bc4_r_unorm    = C.SDL_GPU_TEXTUREFORMAT_BC4_R_UNORM
	bc5_rg_unorm   = C.SDL_GPU_TEXTUREFORMAT_BC5_RG_UNORM
	bc7_rgba_unorm = C.SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM
	// Compressed Signed Float Color Formats
	bc6h_rgb_float = C.SDL_GPU_TEXTUREFORMAT_BC6H_RGB_FLOAT
	// Compressed Unsigned Float Color Formats
	bc6h_rgb_ufloat = C.SDL_GPU_TEXTUREFORMAT_BC6H_RGB_UFLOAT
	// Signed Normalized Float Color Formats
	r8_snorm           = C.SDL_GPU_TEXTUREFORMAT_R8_SNORM
	r8g8_snorm         = C.SDL_GPU_TEXTUREFORMAT_R8G8_SNORM
	r8g8b8a8_snorm     = C.SDL_GPU_TEXTUREFORMAT_R8G8B8A8_SNORM
	r16_snorm          = C.SDL_GPU_TEXTUREFORMAT_R16_SNORM
	r16g16_snorm       = C.SDL_GPU_TEXTUREFORMAT_R16G16_SNORM
	r16g16b16a16_snorm = C.SDL_GPU_TEXTUREFORMAT_R16G16B16A16_SNORM
	// Signed Float Color Formats
	r16_float          = C.SDL_GPU_TEXTUREFORMAT_R16_FLOAT
	r16g16_float       = C.SDL_GPU_TEXTUREFORMAT_R16G16_FLOAT
	r16g16b16a16_float = C.SDL_GPU_TEXTUREFORMAT_R16G16B16A16_FLOAT
	r32_float          = C.SDL_GPU_TEXTUREFORMAT_R32_FLOAT
	r32g32_float       = C.SDL_GPU_TEXTUREFORMAT_R32G32_FLOAT
	r32g32b32a32_float = C.SDL_GPU_TEXTUREFORMAT_R32G32B32A32_FLOAT
	// Unsigned Float Color Formats
	r11g11b10_ufloat = C.SDL_GPU_TEXTUREFORMAT_R11G11B10_UFLOAT
	// Unsigned Integer Color Formats
	r8_uint           = C.SDL_GPU_TEXTUREFORMAT_R8_UINT
	r8g8_uint         = C.SDL_GPU_TEXTUREFORMAT_R8G8_UINT
	r8g8b8a8_uint     = C.SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UINT
	r16_uint          = C.SDL_GPU_TEXTUREFORMAT_R16_UINT
	r16g16_uint       = C.SDL_GPU_TEXTUREFORMAT_R16G16_UINT
	r16g16b16a16_uint = C.SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UINT
	r32_uint          = C.SDL_GPU_TEXTUREFORMAT_R32_UINT
	r32g32_uint       = C.SDL_GPU_TEXTUREFORMAT_R32G32_UINT
	r32g32b32a32_uint = C.SDL_GPU_TEXTUREFORMAT_R32G32B32A32_UINT
	// Signed Integer Color Formats
	r8_int           = C.SDL_GPU_TEXTUREFORMAT_R8_INT
	r8g8_int         = C.SDL_GPU_TEXTUREFORMAT_R8G8_INT
	r8g8b8a8_int     = C.SDL_GPU_TEXTUREFORMAT_R8G8B8A8_INT
	r16_int          = C.SDL_GPU_TEXTUREFORMAT_R16_INT
	r16g16_int       = C.SDL_GPU_TEXTUREFORMAT_R16G16_INT
	r16g16b16a16_int = C.SDL_GPU_TEXTUREFORMAT_R16G16B16A16_INT
	r32_int          = C.SDL_GPU_TEXTUREFORMAT_R32_INT
	r32g32_int       = C.SDL_GPU_TEXTUREFORMAT_R32G32_INT
	r32g32b32a32_int = C.SDL_GPU_TEXTUREFORMAT_R32G32B32A32_INT
	// SRGB Unsigned Normalized Color Formats
	r8g8b8a8_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM_SRGB
	b8g8r8a8_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM_SRGB
	// Compressed SRGB Unsigned Normalized Color Formats
	bc1_rgba_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM_SRGB
	bc2_rgba_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM_SRGB
	bc3_rgba_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM_SRGB
	bc7_rgba_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM_SRGB
	// Depth Formats
	d16_unorm         = C.SDL_GPU_TEXTUREFORMAT_D16_UNORM
	d24_unorm         = C.SDL_GPU_TEXTUREFORMAT_D24_UNORM
	d32_float         = C.SDL_GPU_TEXTUREFORMAT_D32_FLOAT
	d24_unorm_s8_uint = C.SDL_GPU_TEXTUREFORMAT_D24_UNORM_S8_UINT
	d32_float_s8_uint = C.SDL_GPU_TEXTUREFORMAT_D32_FLOAT_S8_UINT
	// Compressed ASTC Normalized Float Color Formats
	astc_4x4_unorm   = C.SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM
	astc_5x4_unorm   = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM
	astc_5x5_unorm   = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM
	astc_6x5_unorm   = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM
	astc_6x6_unorm   = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM
	astc_8x5_unorm   = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM
	astc_8x6_unorm   = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM
	astc_8x8_unorm   = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM
	astc_10x5_unorm  = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM
	astc_10x6_unorm  = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM
	astc_10x8_unorm  = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM
	astc_10x10_unorm = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM
	astc_12x10_unorm = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM
	astc_12x12_unorm = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM
	// Compressed SRGB ASTC Normalized Float Color Formats
	astc_4x4_unorm_srgb   = C.SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM_SRGB
	astc_5x4_unorm_srgb   = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM_SRGB
	astc_5x5_unorm_srgb   = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM_SRGB
	astc_6x5_unorm_srgb   = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM_SRGB
	astc_6x6_unorm_srgb   = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM_SRGB
	astc_8x5_unorm_srgb   = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM_SRGB
	astc_8x6_unorm_srgb   = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM_SRGB
	astc_8x8_unorm_srgb   = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM_SRGB
	astc_10x5_unorm_srgb  = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM_SRGB
	astc_10x6_unorm_srgb  = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM_SRGB
	astc_10x8_unorm_srgb  = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM_SRGB
	astc_10x10_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM_SRGB
	astc_12x10_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM_SRGB
	astc_12x12_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM_SRGB
	// Compressed ASTC Signed Float Color Formats
	astc_4x4_float   = C.SDL_GPU_TEXTUREFORMAT_ASTC_4x4_FLOAT
	astc_5x4_float   = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x4_FLOAT
	astc_5x5_float   = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x5_FLOAT
	astc_6x5_float   = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x5_FLOAT
	astc_6x6_float   = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x6_FLOAT
	astc_8x5_float   = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x5_FLOAT
	astc_8x6_float   = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x6_FLOAT
	astc_8x8_float   = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x8_FLOAT
	astc_10x5_float  = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x5_FLOAT
	astc_10x6_float  = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x6_FLOAT
	astc_10x8_float  = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x8_FLOAT
	astc_10x10_float = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x10_FLOAT
	astc_12x10_float = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x10_FLOAT
	astc_12x12_float = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x12_FLOAT
}

pub const gpu_textureusage_sampler = C.SDL_GPU_TEXTUREUSAGE_SAMPLER // (1u << 0)

pub const gpu_textureusage_color_target = C.SDL_GPU_TEXTUREUSAGE_COLOR_TARGET // (1u << 1)

pub const gpu_textureusage_depth_stencil_target = C.SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET // (1u << 2)

pub const gpu_textureusage_graphics_storage_read = C.SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ // (1u << 3)

pub const gpu_textureusage_compute_storage_read = C.SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_READ // (1u << 4)

pub const gpu_textureusage_compute_storage_write = C.SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE // (1u << 5)

pub const gpu_textureusage_compute_storage_simultaneous_read_write = C.SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE // (1u << 6)

// GPUTextureType is C.SDL_GPUTextureType
pub enum GPUTextureType {
	_2d        = C.SDL_GPU_TEXTURETYPE_2D         // `_2d` The texture is a 2-dimensional image.
	_2d_array  = C.SDL_GPU_TEXTURETYPE_2D_ARRAY   // `_2d_array` The texture is a 2-dimensional array image.
	_3d        = C.SDL_GPU_TEXTURETYPE_3D         // `_3d` The texture is a 3-dimensional image.
	cube       = C.SDL_GPU_TEXTURETYPE_CUBE       // `cube` The texture is a cube image.
	cube_array = C.SDL_GPU_TEXTURETYPE_CUBE_ARRAY // `cube_array` The texture is a cube array image.
}

// GPUSampleCount is C.SDL_GPUSampleCount
pub enum GPUSampleCount {
	_1 = C.SDL_GPU_SAMPLECOUNT_1 // `_1` No multisampling.
	_2 = C.SDL_GPU_SAMPLECOUNT_2 // `_2` MSAA 2x
	_4 = C.SDL_GPU_SAMPLECOUNT_4 // `_4` MSAA 4x
	_8 = C.SDL_GPU_SAMPLECOUNT_8 // `_8` MSAA 8x
}

// GPUCubeMapFace is C.SDL_GPUCubeMapFace
pub enum GPUCubeMapFace {
	positivex = C.SDL_GPU_CUBEMAPFACE_POSITIVEX
	negativex = C.SDL_GPU_CUBEMAPFACE_NEGATIVEX
	positivey = C.SDL_GPU_CUBEMAPFACE_POSITIVEY
	negativey = C.SDL_GPU_CUBEMAPFACE_NEGATIVEY
	positivez = C.SDL_GPU_CUBEMAPFACE_POSITIVEZ
	negativez = C.SDL_GPU_CUBEMAPFACE_NEGATIVEZ
}

pub const gpu_bufferusage_vertex = C.SDL_GPU_BUFFERUSAGE_VERTEX // (1u << 0)

pub const gpu_bufferusage_index = C.SDL_GPU_BUFFERUSAGE_INDEX // (1u << 1)

pub const gpu_bufferusage_indirect = C.SDL_GPU_BUFFERUSAGE_INDIRECT // (1u << 2)

pub const gpu_bufferusage_graphics_storage_read = C.SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ // (1u << 3)

pub const gpu_bufferusage_compute_storage_read = C.SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_READ // (1u << 4)

pub const gpu_bufferusage_compute_storage_write = C.SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE // (1u << 5)

// GPUTransferBufferUsage is C.SDL_GPUTransferBufferUsage
pub enum GPUTransferBufferUsage {
	upload   = C.SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD
	download = C.SDL_GPU_TRANSFERBUFFERUSAGE_DOWNLOAD
}

// GPUShaderStage is C.SDL_GPUShaderStage
pub enum GPUShaderStage {
	vertex   = C.SDL_GPU_SHADERSTAGE_VERTEX
	fragment = C.SDL_GPU_SHADERSTAGE_FRAGMENT
}

pub const gpu_shaderformat_invalid = C.SDL_GPU_SHADERFORMAT_INVALID // 0

pub const gpu_shaderformat_private = C.SDL_GPU_SHADERFORMAT_PRIVATE // (1u << 0)

pub const gpu_shaderformat_spirv = C.SDL_GPU_SHADERFORMAT_SPIRV // (1u << 1)

pub const gpu_shaderformat_dxbc = C.SDL_GPU_SHADERFORMAT_DXBC // (1u << 2)

pub const gpu_shaderformat_dxil = C.SDL_GPU_SHADERFORMAT_DXIL // (1u << 3)

pub const gpu_shaderformat_msl = C.SDL_GPU_SHADERFORMAT_MSL // (1u << 4)

pub const gpu_shaderformat_metallib = C.SDL_GPU_SHADERFORMAT_METALLIB // (1u << 5)

// GPUVertexElementFormat is C.SDL_GPUVertexElementFormat
pub enum GPUVertexElementFormat {
	invalid = C.SDL_GPU_VERTEXELEMENTFORMAT_INVALID
	// 32-bit Signed Integers
	int  = C.SDL_GPU_VERTEXELEMENTFORMAT_INT
	int2 = C.SDL_GPU_VERTEXELEMENTFORMAT_INT2
	int3 = C.SDL_GPU_VERTEXELEMENTFORMAT_INT3
	int4 = C.SDL_GPU_VERTEXELEMENTFORMAT_INT4
	// 32-bit Unsigned Integers
	uint  = C.SDL_GPU_VERTEXELEMENTFORMAT_UINT
	uint2 = C.SDL_GPU_VERTEXELEMENTFORMAT_UINT2
	uint3 = C.SDL_GPU_VERTEXELEMENTFORMAT_UINT3
	uint4 = C.SDL_GPU_VERTEXELEMENTFORMAT_UINT4
	// 32-bit Floats
	float  = C.SDL_GPU_VERTEXELEMENTFORMAT_FLOAT
	float2 = C.SDL_GPU_VERTEXELEMENTFORMAT_FLOAT2
	float3 = C.SDL_GPU_VERTEXELEMENTFORMAT_FLOAT3
	float4 = C.SDL_GPU_VERTEXELEMENTFORMAT_FLOAT4
	// 8-bit Signed Integers
	byte2 = C.SDL_GPU_VERTEXELEMENTFORMAT_BYTE2
	byte4 = C.SDL_GPU_VERTEXELEMENTFORMAT_BYTE4
	// 8-bit Unsigned Integers
	ubyte2 = C.SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2
	ubyte4 = C.SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4
	// 8-bit Signed Normalized
	byte2_norm = C.SDL_GPU_VERTEXELEMENTFORMAT_BYTE2_NORM
	byte4_norm = C.SDL_GPU_VERTEXELEMENTFORMAT_BYTE4_NORM
	// 8-bit Unsigned Normalized
	ubyte2_norm = C.SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2_NORM
	ubyte4_norm = C.SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4_NORM
	// 16-bit Signed Integers
	short2 = C.SDL_GPU_VERTEXELEMENTFORMAT_SHORT2
	short4 = C.SDL_GPU_VERTEXELEMENTFORMAT_SHORT4
	// 16-bit Unsigned Integers
	ushort2 = C.SDL_GPU_VERTEXELEMENTFORMAT_USHORT2
	ushort4 = C.SDL_GPU_VERTEXELEMENTFORMAT_USHORT4
	// 16-bit Signed Normalized
	short2_norm = C.SDL_GPU_VERTEXELEMENTFORMAT_SHORT2_NORM
	short4_norm = C.SDL_GPU_VERTEXELEMENTFORMAT_SHORT4_NORM
	// 16-bit Unsigned Normalized
	ushort2_norm = C.SDL_GPU_VERTEXELEMENTFORMAT_USHORT2_NORM
	ushort4_norm = C.SDL_GPU_VERTEXELEMENTFORMAT_USHORT4_NORM
	// 16-bit Floats
	half2 = C.SDL_GPU_VERTEXELEMENTFORMAT_HALF2
	half4 = C.SDL_GPU_VERTEXELEMENTFORMAT_HALF4
}

// GPUVertexInputRate is C.SDL_GPUVertexInputRate
pub enum GPUVertexInputRate {
	vertex   = C.SDL_GPU_VERTEXINPUTRATE_VERTEX   // `vertex` Attribute addressing is a function of the vertex index.
	instance = C.SDL_GPU_VERTEXINPUTRATE_INSTANCE // `instance` Attribute addressing is a function of the instance index.
}

// GPUFillMode is C.SDL_GPUFillMode
pub enum GPUFillMode {
	fill = C.SDL_GPU_FILLMODE_FILL // `fill` Polygons will be rendered via rasterization.
	line = C.SDL_GPU_FILLMODE_LINE // `line` Polygon edges will be drawn as line segments.
}

// GPUCullMode is C.SDL_GPUCullMode
pub enum GPUCullMode {
	none  = C.SDL_GPU_CULLMODE_NONE  // `none` No triangles are culled.
	front = C.SDL_GPU_CULLMODE_FRONT // `front` Front-facing triangles are culled.
	back  = C.SDL_GPU_CULLMODE_BACK  // `back` Back-facing triangles are culled.
}

// GPUFrontFace is C.SDL_GPUFrontFace
pub enum GPUFrontFace {
	counter_clockwise = C.SDL_GPU_FRONTFACE_COUNTER_CLOCKWISE // `counter_clockwise` A triangle with counter-clockwise vertex winding will be considered front-facing.
	clockwise         = C.SDL_GPU_FRONTFACE_CLOCKWISE         // `clockwise` A triangle with clockwise vertex winding will be considered front-facing.
}

// GPUCompareOp is C.SDL_GPUCompareOp
pub enum GPUCompareOp {
	invalid          = C.SDL_GPU_COMPAREOP_INVALID
	never            = C.SDL_GPU_COMPAREOP_NEVER            // `never` The comparison always evaluates false.
	less             = C.SDL_GPU_COMPAREOP_LESS             // `less` The comparison evaluates reference < test.
	equal            = C.SDL_GPU_COMPAREOP_EQUAL            // `equal` The comparison evaluates reference == test.
	less_or_equal    = C.SDL_GPU_COMPAREOP_LESS_OR_EQUAL    // `less_or_equal` The comparison evaluates reference <= test.
	greater          = C.SDL_GPU_COMPAREOP_GREATER          // `greater` The comparison evaluates reference > test.
	not_equal        = C.SDL_GPU_COMPAREOP_NOT_EQUAL        // `not_equal` The comparison evaluates reference != test.
	greater_or_equal = C.SDL_GPU_COMPAREOP_GREATER_OR_EQUAL // `greater_or_equal` The comparison evalutes reference >= test.
	always           = C.SDL_GPU_COMPAREOP_ALWAYS           // `always` The comparison always evaluates true.
}

// GPUStencilOp is C.SDL_GPUStencilOp
pub enum GPUStencilOp {
	invalid             = C.SDL_GPU_STENCILOP_INVALID
	keep                = C.SDL_GPU_STENCILOP_KEEP                // `keep` Keeps the current value.
	zero                = C.SDL_GPU_STENCILOP_ZERO                // `zero` Sets the value to 0.
	replace             = C.SDL_GPU_STENCILOP_REPLACE             // `replace` Sets the value to reference.
	increment_and_clamp = C.SDL_GPU_STENCILOP_INCREMENT_AND_CLAMP // `increment_and_clamp` Increments the current value and clamps to the maximum value.
	decrement_and_clamp = C.SDL_GPU_STENCILOP_DECREMENT_AND_CLAMP // `decrement_and_clamp` Decrements the current value and clamps to 0.
	invert              = C.SDL_GPU_STENCILOP_INVERT              // `invert` Bitwise-inverts the current value.
	increment_and_wrap  = C.SDL_GPU_STENCILOP_INCREMENT_AND_WRAP  // `increment_and_wrap` Increments the current value and wraps back to 0.
	decrement_and_wrap  = C.SDL_GPU_STENCILOP_DECREMENT_AND_WRAP  // `decrement_and_wrap` Decrements the current value and wraps to the maximum value.
}

// GPUBlendOp is C.SDL_GPUBlendOp
pub enum GPUBlendOp {
	invalid          = C.SDL_GPU_BLENDOP_INVALID
	add              = C.SDL_GPU_BLENDOP_ADD              // `add` (source * source_factor) + (destination * destination_factor)
	subtract         = C.SDL_GPU_BLENDOP_SUBTRACT         // `subtract` (source * source_factor) - (destination * destination_factor)
	reverse_subtract = C.SDL_GPU_BLENDOP_REVERSE_SUBTRACT // `reverse_subtract` (destination * destination_factor) - (source * source_factor)
	min              = C.SDL_GPU_BLENDOP_MIN              // `min` min(source, destination)
	max              = C.SDL_GPU_BLENDOP_MAX              // `max` max(source, destination)
}

// GPUBlendFactor is C.SDL_GPUBlendFactor
pub enum GPUBlendFactor {
	invalid                  = C.SDL_GPU_BLENDFACTOR_INVALID
	zero                     = C.SDL_GPU_BLENDFACTOR_ZERO                     // `zero` 0
	one                      = C.SDL_GPU_BLENDFACTOR_ONE                      // `one` 1
	src_color                = C.SDL_GPU_BLENDFACTOR_SRC_COLOR                // `src_color` source color
	one_minus_src_color      = C.SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_COLOR      // `one_minus_src_color` 1 - source color
	dst_color                = C.SDL_GPU_BLENDFACTOR_DST_COLOR                // `dst_color` destination color
	one_minus_dst_color      = C.SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_COLOR      // `one_minus_dst_color` 1 - destination color
	src_alpha                = C.SDL_GPU_BLENDFACTOR_SRC_ALPHA                // `src_alpha` source alpha
	one_minus_src_alpha      = C.SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_ALPHA      // `one_minus_src_alpha` 1 - source alpha
	dst_alpha                = C.SDL_GPU_BLENDFACTOR_DST_ALPHA                // `dst_alpha` destination alpha
	one_minus_dst_alpha      = C.SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_ALPHA      // `one_minus_dst_alpha` 1 - destination alpha
	constant_color           = C.SDL_GPU_BLENDFACTOR_CONSTANT_COLOR           // `constant_color` blend constant
	one_minus_constant_color = C.SDL_GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOR // `one_minus_constant_color` 1 - blend constant
	src_alpha_saturate       = C.SDL_GPU_BLENDFACTOR_SRC_ALPHA_SATURATE       // `src_alpha_saturate` min(source alpha, 1 - destination alpha)
}

pub const gpu_colorcomponent_r = C.SDL_GPU_COLORCOMPONENT_R // (1u << 0)

pub const gpu_colorcomponent_g = C.SDL_GPU_COLORCOMPONENT_G // (1u << 1)

pub const gpu_colorcomponent_b = C.SDL_GPU_COLORCOMPONENT_B // (1u << 2)

pub const gpu_colorcomponent_a = C.SDL_GPU_COLORCOMPONENT_A // (1u << 3)

// GPUFilter is C.SDL_GPUFilter
pub enum GPUFilter {
	nearest = C.SDL_GPU_FILTER_NEAREST // `nearest` Point filtering.
	linear  = C.SDL_GPU_FILTER_LINEAR  // `linear` Linear filtering.
}

// GPUSamplerMipmapMode is C.SDL_GPUSamplerMipmapMode
pub enum GPUSamplerMipmapMode {
	nearest = C.SDL_GPU_SAMPLERMIPMAPMODE_NEAREST // `nearest` Point filtering.
	linear  = C.SDL_GPU_SAMPLERMIPMAPMODE_LINEAR  // `linear` Linear filtering.
}

// GPUSamplerAddressMode is C.SDL_GPUSamplerAddressMode
pub enum GPUSamplerAddressMode {
	repeat          = C.SDL_GPU_SAMPLERADDRESSMODE_REPEAT          // `repeat` Specifies that the coordinates will wrap around.
	mirrored_repeat = C.SDL_GPU_SAMPLERADDRESSMODE_MIRRORED_REPEAT // `mirrored_repeat` Specifies that the coordinates will wrap around mirrored.
	clamp_to_edge   = C.SDL_GPU_SAMPLERADDRESSMODE_CLAMP_TO_EDGE   // `clamp_to_edge` Specifies that the coordinates will clamp to the 0-1 range.
}

// GPUPresentMode is C.SDL_GPUPresentMode
pub enum GPUPresentMode {
	vsync     = C.SDL_GPU_PRESENTMODE_VSYNC
	immediate = C.SDL_GPU_PRESENTMODE_IMMEDIATE
	mailbox   = C.SDL_GPU_PRESENTMODE_MAILBOX
}

// GPUSwapchainComposition is C.SDL_GPUSwapchainComposition
pub enum GPUSwapchainComposition {
	sdr                 = C.SDL_GPU_SWAPCHAINCOMPOSITION_SDR
	sdr_linear          = C.SDL_GPU_SWAPCHAINCOMPOSITION_SDR_LINEAR
	hdr_extended_linear = C.SDL_GPU_SWAPCHAINCOMPOSITION_HDR_EXTENDED_LINEAR
	hdr10_st2084        = C.SDL_GPU_SWAPCHAINCOMPOSITION_HDR10_ST2084
}

@[typedef]
pub struct C.SDL_GPUViewport {
pub mut:
	x         f32 // The left offset of the viewport.
	y         f32 // The top offset of the viewport.
	w         f32 // The width of the viewport.
	h         f32 // The height of the viewport.
	min_depth f32 // The minimum depth of the viewport.
	max_depth f32 // The maximum depth of the viewport.
}

pub type GPUViewport = C.SDL_GPUViewport

@[typedef]
pub struct C.SDL_GPUTextureTransferInfo {
pub mut:
	transfer_buffer &GPUTransferBuffer = unsafe { nil } // The transfer buffer used in the transfer operation.
	offset          u32 // The starting byte of the image data in the transfer buffer.
	pixels_per_row  u32 // The number of pixels from one row to the next.
	rows_per_layer  u32 // The number of rows from one layer/depth-slice to the next.
}

pub type GPUTextureTransferInfo = C.SDL_GPUTextureTransferInfo

@[typedef]
pub struct C.SDL_GPUTransferBufferLocation {
pub mut:
	transfer_buffer &GPUTransferBuffer = unsafe { nil } // The transfer buffer used in the transfer operation.
	offset          u32 // The starting byte of the buffer data in the transfer buffer.
}

pub type GPUTransferBufferLocation = C.SDL_GPUTransferBufferLocation

@[typedef]
pub struct C.SDL_GPUTextureLocation {
pub mut:
	texture   &GPUTexture = unsafe { nil } // The texture used in the copy operation.
	mip_level u32 // The mip level index of the location.
	layer     u32 // The layer index of the location.
	x         u32 // The left offset of the location.
	y         u32 // The top offset of the location.
	z         u32 // The front offset of the location.
}

pub type GPUTextureLocation = C.SDL_GPUTextureLocation

@[typedef]
pub struct C.SDL_GPUTextureRegion {
pub mut:
	texture   &GPUTexture = unsafe { nil } // The texture used in the copy operation.
	mip_level u32 // The mip level index to transfer.
	layer     u32 // The layer index to transfer.
	x         u32 // The left offset of the region.
	y         u32 // The top offset of the region.
	z         u32 // The front offset of the region.
	w         u32 // The width of the region.
	h         u32 // The height of the region.
	d         u32 // The depth of the region.
}

pub type GPUTextureRegion = C.SDL_GPUTextureRegion

@[typedef]
pub struct C.SDL_GPUBlitRegion {
pub mut:
	texture              &GPUTexture = unsafe { nil } // The texture.
	mip_level            u32 // The mip level index of the region.
	layer_or_depth_plane u32 // The layer index or depth plane of the region. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures.
	x                    u32 // The left offset of the region.
	y                    u32 // The top offset of the region.
	w                    u32 // The width of the region.
	h                    u32 // The height of the region.
}

pub type GPUBlitRegion = C.SDL_GPUBlitRegion

@[typedef]
pub struct C.SDL_GPUBufferLocation {
pub mut:
	buffer &GPUBuffer = unsafe { nil } // The buffer.
	offset u32 // The starting byte within the buffer.
}

pub type GPUBufferLocation = C.SDL_GPUBufferLocation

@[typedef]
pub struct C.SDL_GPUBufferRegion {
pub mut:
	buffer &GPUBuffer = unsafe { nil } // The buffer.
	offset u32 // The starting byte within the buffer.
	size   u32 // The size in bytes of the region.
}

pub type GPUBufferRegion = C.SDL_GPUBufferRegion

@[typedef]
pub struct C.SDL_GPUIndirectDrawCommand {
pub mut:
	num_vertices   u32 // The number of vertices to draw.
	num_instances  u32 // The number of instances to draw.
	first_vertex   u32 // The index of the first vertex to draw.
	first_instance u32 // The ID of the first instance to draw.
}

pub type GPUIndirectDrawCommand = C.SDL_GPUIndirectDrawCommand

@[typedef]
pub struct C.SDL_GPUIndexedIndirectDrawCommand {
pub mut:
	num_indices    u32 // The number of indices to draw per instance.
	num_instances  u32 // The number of instances to draw.
	first_index    u32 // The base index within the index buffer.
	vertex_offset  i32 // The value added to the vertex index before indexing into the vertex buffer.
	first_instance u32 // The ID of the first instance to draw.
}

pub type GPUIndexedIndirectDrawCommand = C.SDL_GPUIndexedIndirectDrawCommand

@[typedef]
pub struct C.SDL_GPUIndirectDispatchCommand {
pub mut:
	groupcount_x u32 // The number of local workgroups to dispatch in the X dimension.
	groupcount_y u32 // The number of local workgroups to dispatch in the Y dimension.
	groupcount_z u32 // The number of local workgroups to dispatch in the Z dimension.
}

pub type GPUIndirectDispatchCommand = C.SDL_GPUIndirectDispatchCommand

@[typedef]
pub struct C.SDL_GPUSamplerCreateInfo {
pub mut:
	min_filter        GPUFilter             // The minification filter to apply to lookups.
	mag_filter        GPUFilter             // The magnification filter to apply to lookups.
	mipmap_mode       GPUSamplerMipmapMode  // The mipmap filter to apply to lookups.
	address_mode_u    GPUSamplerAddressMode // The addressing mode for U coordinates outside [0, 1).
	address_mode_v    GPUSamplerAddressMode // The addressing mode for V coordinates outside [0, 1).
	address_mode_w    GPUSamplerAddressMode // The addressing mode for W coordinates outside [0, 1).
	mip_lod_bias      f32                   // The bias to be added to mipmap LOD calculation.
	max_anisotropy    f32                   // The anisotropy value clamp used by the sampler. If enable_anisotropy is false, this is ignored.
	compare_op        GPUCompareOp          // The comparison operator to apply to fetched data before filtering.
	min_lod           f32                   // Clamps the minimum of the computed LOD value.
	max_lod           f32                   // Clamps the maximum of the computed LOD value.
	enable_anisotropy bool                  // true to enable anisotropic filtering.
	enable_compare    bool                  // true to enable comparison against a reference value during lookups.
	padding1          u8
	padding2          u8
	props             PropertiesID // A properties ID for extensions. Should be 0 if no extensions are needed.
}

pub type GPUSamplerCreateInfo = C.SDL_GPUSamplerCreateInfo

@[typedef]
pub struct C.SDL_GPUVertexBufferDescription {
pub mut:
	slot               u32                // The binding slot of the vertex buffer.
	pitch              u32                // The byte pitch between consecutive elements of the vertex buffer.
	input_rate         GPUVertexInputRate // Whether attribute addressing is a function of the vertex index or instance index.
	instance_step_rate u32                // The number of instances to draw using the same per-instance data before advancing in the instance buffer by one element. Ignored unless input_rate is SDL_GPU_VERTEXINPUTRATE_INSTANCE
}

pub type GPUVertexBufferDescription = C.SDL_GPUVertexBufferDescription

@[typedef]
pub struct C.SDL_GPUVertexAttribute {
pub mut:
	location    u32                    // The shader input location index.
	buffer_slot u32                    // The binding slot of the associated vertex buffer.
	format      GPUVertexElementFormat // The size and type of the attribute data.
	offset      u32                    // The byte offset of this attribute relative to the start of the vertex element.
}

pub type GPUVertexAttribute = C.SDL_GPUVertexAttribute

@[typedef]
pub struct C.SDL_GPUVertexInputState {
pub mut:
	vertex_buffer_descriptions &GPUVertexBufferDescription = unsafe { nil } // A pointer to an array of vertex buffer descriptions.
	num_vertex_buffers         u32 // The number of vertex buffer descriptions in the above array.
	vertex_attributes          &GPUVertexAttribute = unsafe { nil } // A pointer to an array of vertex attribute descriptions.
	num_vertex_attributes      u32 // The number of vertex attribute descriptions in the above array.
}

pub type GPUVertexInputState = C.SDL_GPUVertexInputState

@[typedef]
pub struct C.SDL_GPUStencilOpState {
pub mut:
	fail_op       GPUStencilOp // The action performed on samples that fail the stencil test.
	pass_op       GPUStencilOp // The action performed on samples that pass the depth and stencil tests.
	depth_fail_op GPUStencilOp // The action performed on samples that pass the stencil test and fail the depth test.
	compare_op    GPUCompareOp // The comparison operator used in the stencil test.
}

pub type GPUStencilOpState = C.SDL_GPUStencilOpState

@[typedef]
pub struct C.SDL_GPUColorTargetBlendState {
pub mut:
	src_color_blendfactor   GPUBlendFactor         // The value to be multiplied by the source RGB value.
	dst_color_blendfactor   GPUBlendFactor         // The value to be multiplied by the destination RGB value.
	color_blend_op          GPUBlendOp             // The blend operation for the RGB components.
	src_alpha_blendfactor   GPUBlendFactor         // The value to be multiplied by the source alpha.
	dst_alpha_blendfactor   GPUBlendFactor         // The value to be multiplied by the destination alpha.
	alpha_blend_op          GPUBlendOp             // The blend operation for the alpha component.
	color_write_mask        GpuColorComponentFlags // A bitmask specifying which of the RGBA components are enabled for writing. Writes to all channels if enable_color_write_mask is false.
	enable_blend            bool                   // Whether blending is enabled for the color target.
	enable_color_write_mask bool                   // Whether the color write mask is enabled.
	padding1                u8
	padding2                u8
}

pub type GPUColorTargetBlendState = C.SDL_GPUColorTargetBlendState

@[typedef]
pub struct C.SDL_GPUShaderCreateInfo {
pub mut:
	code_size            usize // The size in bytes of the code pointed to.
	code                 &u8   = unsafe { nil } // A pointer to shader code.
	entrypoint           &char = unsafe { nil } // A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader.
	format               GpuShaderFormat // The format of the shader code.
	stage                GPUShaderStage  // The stage the shader program corresponds to.
	num_samplers         u32             // The number of samplers defined in the shader.
	num_storage_textures u32             // The number of storage textures defined in the shader.
	num_storage_buffers  u32             // The number of storage buffers defined in the shader.
	num_uniform_buffers  u32             // The number of uniform buffers defined in the shader.
	props                PropertiesID    // A properties ID for extensions. Should be 0 if no extensions are needed.
}

pub type GPUShaderCreateInfo = C.SDL_GPUShaderCreateInfo

@[typedef]
pub struct C.SDL_GPUTextureCreateInfo {
pub mut:
	type                 GPUTextureType       // The base dimensionality of the texture.
	format               GPUTextureFormat     // The pixel format of the texture.
	usage                GpuTextureUsageFlags // How the texture is intended to be used by the client.
	width                u32                  // The width of the texture.
	height               u32                  // The height of the texture.
	layer_count_or_depth u32                  // The layer count or depth of the texture. This value is treated as a layer count on 2D array textures, and as a depth value on 3D textures.
	num_levels           u32                  // The number of mip levels in the texture.
	sample_count         GPUSampleCount       // The number of samples per texel. Only applies if the texture is used as a render target.
	props                PropertiesID         // A properties ID for extensions. Should be 0 if no extensions are needed.
}

pub type GPUTextureCreateInfo = C.SDL_GPUTextureCreateInfo

@[typedef]
pub struct C.SDL_GPUBufferCreateInfo {
pub mut:
	usage GpuBufferUsageFlags // How the buffer is intended to be used by the client.
	size  u32                 // The size in bytes of the buffer.
	props PropertiesID        // A properties ID for extensions. Should be 0 if no extensions are needed.
}

pub type GPUBufferCreateInfo = C.SDL_GPUBufferCreateInfo

@[typedef]
pub struct C.SDL_GPUTransferBufferCreateInfo {
pub mut:
	usage GPUTransferBufferUsage // How the transfer buffer is intended to be used by the client.
	size  u32                    // The size in bytes of the transfer buffer.
	props PropertiesID           // A properties ID for extensions. Should be 0 if no extensions are needed.
}

pub type GPUTransferBufferCreateInfo = C.SDL_GPUTransferBufferCreateInfo

@[typedef]
pub struct C.SDL_GPURasterizerState {
pub mut:
	fill_mode                  GPUFillMode  // Whether polygons will be filled in or drawn as lines.
	cull_mode                  GPUCullMode  // The facing direction in which triangles will be culled.
	front_face                 GPUFrontFace // The vertex winding that will cause a triangle to be determined as front-facing.
	depth_bias_constant_factor f32          // A scalar factor controlling the depth value added to each fragment.
	depth_bias_clamp           f32          // The maximum depth bias of a fragment.
	depth_bias_slope_factor    f32          // A scalar factor applied to a fragment's slope in depth calculations.
	enable_depth_bias          bool         // true to bias fragment depth values.
	enable_depth_clip          bool         // true to enable depth clip, false to enable depth clamp.
	padding1                   u8
	padding2                   u8
}

pub type GPURasterizerState = C.SDL_GPURasterizerState

@[typedef]
pub struct C.SDL_GPUMultisampleState {
pub mut:
	sample_count GPUSampleCount // The number of samples to be used in rasterization.
	sample_mask  u32            // Determines which samples get updated in the render targets. Treated as 0xFFFFFFFF if enable_mask is false.
	enable_mask  bool           // Enables sample masking.
	padding1     u8
	padding2     u8
	padding3     u8
}

pub type GPUMultisampleState = C.SDL_GPUMultisampleState

@[typedef]
pub struct C.SDL_GPUDepthStencilState {
pub mut:
	compare_op          GPUCompareOp      // The comparison operator used for depth testing.
	back_stencil_state  GPUStencilOpState // The stencil op state for back-facing triangles.
	front_stencil_state GPUStencilOpState // The stencil op state for front-facing triangles.
	compare_mask        u8                // Selects the bits of the stencil values participating in the stencil test.
	write_mask          u8                // Selects the bits of the stencil values updated by the stencil test.
	enable_depth_test   bool              // true enables the depth test.
	enable_depth_write  bool              // true enables depth writes. Depth writes are always disabled when enable_depth_test is false.
	enable_stencil_test bool              // true enables the stencil test.
	padding1            u8
	padding2            u8
	padding3            u8
}

pub type GPUDepthStencilState = C.SDL_GPUDepthStencilState

@[typedef]
pub struct C.SDL_GPUColorTargetDescription {
pub mut:
	format      GPUTextureFormat         // The pixel format of the texture to be used as a color target.
	blend_state GPUColorTargetBlendState // The blend state to be used for the color target.
}

pub type GPUColorTargetDescription = C.SDL_GPUColorTargetDescription

@[typedef]
pub struct C.SDL_GPUGraphicsPipelineTargetInfo {
pub mut:
	color_target_descriptions &GPUColorTargetDescription = unsafe { nil } // A pointer to an array of color target descriptions.
	num_color_targets         u32              // The number of color target descriptions in the above array.
	depth_stencil_format      GPUTextureFormat // The pixel format of the depth-stencil target. Ignored if has_depth_stencil_target is false.
	has_depth_stencil_target  bool             // true specifies that the pipeline uses a depth-stencil target.
	padding1                  u8
	padding2                  u8
	padding3                  u8
}

pub type GPUGraphicsPipelineTargetInfo = C.SDL_GPUGraphicsPipelineTargetInfo

@[typedef]
pub struct C.SDL_GPUGraphicsPipelineCreateInfo {
pub mut:
	vertex_shader       &GPUShader = unsafe { nil } // The vertex shader used by the graphics pipeline.
	fragment_shader     &GPUShader = unsafe { nil } // The fragment shader used by the graphics pipeline.
	vertex_input_state  GPUVertexInputState           // The vertex layout of the graphics pipeline.
	primitive_type      GPUPrimitiveType              // The primitive topology of the graphics pipeline.
	rasterizer_state    GPURasterizerState            // The rasterizer state of the graphics pipeline.
	multisample_state   GPUMultisampleState           // The multisample state of the graphics pipeline.
	depth_stencil_state GPUDepthStencilState          // The depth-stencil state of the graphics pipeline.
	target_info         GPUGraphicsPipelineTargetInfo // Formats and blend modes for the render targets of the graphics pipeline.
	props               PropertiesID                  // A properties ID for extensions. Should be 0 if no extensions are needed.
}

pub type GPUGraphicsPipelineCreateInfo = C.SDL_GPUGraphicsPipelineCreateInfo

@[typedef]
pub struct C.SDL_GPUComputePipelineCreateInfo {
pub mut:
	code_size                      usize // The size in bytes of the compute shader code pointed to.
	code                           &u8   = unsafe { nil } // A pointer to compute shader code.
	entrypoint                     &char = unsafe { nil } // A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader.
	format                         GpuShaderFormat // The format of the compute shader code.
	num_samplers                   u32             // The number of samplers defined in the shader.
	num_readonly_storage_textures  u32             // The number of readonly storage textures defined in the shader.
	num_readonly_storage_buffers   u32             // The number of readonly storage buffers defined in the shader.
	num_readwrite_storage_textures u32             // The number of read-write storage textures defined in the shader.
	num_readwrite_storage_buffers  u32             // The number of read-write storage buffers defined in the shader.
	num_uniform_buffers            u32             // The number of uniform buffers defined in the shader.
	threadcount_x                  u32             // The number of threads in the X dimension. This should match the value in the shader.
	threadcount_y                  u32             // The number of threads in the Y dimension. This should match the value in the shader.
	threadcount_z                  u32             // The number of threads in the Z dimension. This should match the value in the shader.
	props                          PropertiesID    // A properties ID for extensions. Should be 0 if no extensions are needed.
}

pub type GPUComputePipelineCreateInfo = C.SDL_GPUComputePipelineCreateInfo

@[typedef]
pub struct C.SDL_GPUColorTargetInfo {
pub mut:
	texture               &GPUTexture = unsafe { nil } // The texture that will be used as a color target by a render pass.
	mip_level             u32        // The mip level to use as a color target.
	layer_or_depth_plane  u32        // The layer index or depth plane to use as a color target. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures.
	clear_color           FColor     // The color to clear the color target to at the start of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used.
	load_op               GPULoadOp  // What is done with the contents of the color target at the beginning of the render pass.
	store_op              GPUStoreOp // What is done with the results of the render pass.
	resolve_texture       &GPUTexture = unsafe { nil } // The texture that will receive the results of a multisample resolve operation. Ignored if a RESOLVE* store_op is not used.
	resolve_mip_level     u32  // The mip level of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used.
	resolve_layer         u32  // The layer index of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used.
	cycle                 bool // true cycles the texture if the texture is bound and load_op is not LOAD
	cycle_resolve_texture bool // true cycles the resolve texture if the resolve texture is bound. Ignored if a RESOLVE* store_op is not used.
	padding1              u8
	padding2              u8
}

pub type GPUColorTargetInfo = C.SDL_GPUColorTargetInfo

@[typedef]
pub struct C.SDL_GPUDepthStencilTargetInfo {
pub mut:
	texture          &GPUTexture = unsafe { nil } // The texture that will be used as the depth stencil target by the render pass.
	clear_depth      f32        // The value to clear the depth component to at the beginning of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used.
	load_op          GPULoadOp  // What is done with the depth contents at the beginning of the render pass.
	store_op         GPUStoreOp // What is done with the depth results of the render pass.
	stencil_load_op  GPULoadOp  // What is done with the stencil contents at the beginning of the render pass.
	stencil_store_op GPUStoreOp // What is done with the stencil results of the render pass.
	cycle            bool       // true cycles the texture if the texture is bound and any load ops are not LOAD
	clear_stencil    u8         // The value to clear the stencil component to at the beginning of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used.
	padding1         u8
	padding2         u8
}

pub type GPUDepthStencilTargetInfo = C.SDL_GPUDepthStencilTargetInfo

@[typedef]
pub struct C.SDL_GPUBlitInfo {
pub mut:
	source      GPUBlitRegion // The source region for the blit.
	destination GPUBlitRegion // The destination region for the blit.
	load_op     GPULoadOp     // What is done with the contents of the destination before the blit.
	clear_color FColor        // The color to clear the destination region to before the blit. Ignored if load_op is not SDL_GPU_LOADOP_CLEAR.
	flip_mode   FlipMode      // The flip mode for the source region.
	filter      GPUFilter     // The filter mode used when blitting.
	cycle       bool          // true cycles the destination texture if it is already bound.
	padding1    u8
	padding2    u8
	padding3    u8
}

pub type GPUBlitInfo = C.SDL_GPUBlitInfo

@[typedef]
pub struct C.SDL_GPUBufferBinding {
pub mut:
	buffer &GPUBuffer = unsafe { nil } // The buffer to bind. Must have been created with SDL_GPU_BUFFERUSAGE_VERTEX for SDL_BindGPUVertexBuffers, or SDL_GPU_BUFFERUSAGE_INDEX for SDL_BindGPUIndexBuffer.
	offset u32 // The starting byte of the data to bind in the buffer.
}

pub type GPUBufferBinding = C.SDL_GPUBufferBinding

@[typedef]
pub struct C.SDL_GPUTextureSamplerBinding {
pub mut:
	texture &GPUTexture = unsafe { nil } // The texture to bind. Must have been created with SDL_GPU_TEXTUREUSAGE_SAMPLER.
	sampler &GPUSampler = unsafe { nil } // The sampler to bind.
}

pub type GPUTextureSamplerBinding = C.SDL_GPUTextureSamplerBinding

@[typedef]
pub struct C.SDL_GPUStorageBufferReadWriteBinding {
pub mut:
	buffer   &GPUBuffer = unsafe { nil } // The buffer to bind. Must have been created with SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE.
	cycle    bool // true cycles the buffer if it is already bound.
	padding1 u8
	padding2 u8
	padding3 u8
}

pub type GPUStorageBufferReadWriteBinding = C.SDL_GPUStorageBufferReadWriteBinding

@[typedef]
pub struct C.SDL_GPUStorageTextureReadWriteBinding {
pub mut:
	texture   &GPUTexture = unsafe { nil } // The texture to bind. Must have been created with SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE or SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE.
	mip_level u32  // The mip level index to bind.
	layer     u32  // The layer index to bind.
	cycle     bool // true cycles the texture if it is already bound.
	padding1  u8
	padding2  u8
	padding3  u8
}

pub type GPUStorageTextureReadWriteBinding = C.SDL_GPUStorageTextureReadWriteBinding

// C.SDL_GPUSupportsShaderFormats [official documentation](https://wiki.libsdl.org/SDL3/SDL_GPUSupportsShaderFormats)
fn C.SDL_GPUSupportsShaderFormats(format_flags GpuShaderFormat, const_name &char) bool

// gpu_supports_shader_formats checks for GPU runtime support.
//
// `format_flags` format_flags a bitflag indicating which shader formats the app is
//                     able to provide.
// `name` name the preferred GPU driver, or NULL to let SDL pick the optimal
//             driver.
// returns true if supported, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_gpu_device (SDL_CreateGPUDevice)
pub fn gpu_supports_shader_formats(format_flags GpuShaderFormat, const_name &char) bool {
	return C.SDL_GPUSupportsShaderFormats(format_flags, const_name)
}

// C.SDL_GPUSupportsProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GPUSupportsProperties)
fn C.SDL_GPUSupportsProperties(props PropertiesID) bool

// gpu_supports_properties checks for GPU runtime support.
//
// `props` props the properties to use.
// returns true if supported, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_gpu_device_with_properties (SDL_CreateGPUDeviceWithProperties)
pub fn gpu_supports_properties(props PropertiesID) bool {
	return C.SDL_GPUSupportsProperties(props)
}

// C.SDL_CreateGPUDevice [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateGPUDevice)
fn C.SDL_CreateGPUDevice(format_flags GpuShaderFormat, debug_mode bool, const_name &char) &GPUDevice

// create_gpu_device creates a GPU context.
//
// `format_flags` format_flags a bitflag indicating which shader formats the app is
//                     able to provide.
// `debug_mode` debug_mode enable debug mode properties and validations.
// `name` name the preferred GPU driver, or NULL to let SDL pick the optimal
//             driver.
// returns a GPU context on success or NULL on failure; call SDL_GetError()
//          for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gpu_shader_formats (SDL_GetGPUShaderFormats)
// See also: get_gpu_device_driver (SDL_GetGPUDeviceDriver)
// See also: destroy_gpu_device (SDL_DestroyGPUDevice)
// See also: gpu_supports_shader_formats (SDL_GPUSupportsShaderFormats)
pub fn create_gpu_device(format_flags GpuShaderFormat, debug_mode bool, const_name &char) &GPUDevice {
	return C.SDL_CreateGPUDevice(format_flags, debug_mode, const_name)
}

// C.SDL_CreateGPUDeviceWithProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateGPUDeviceWithProperties)
fn C.SDL_CreateGPUDeviceWithProperties(props PropertiesID) &GPUDevice

// create_gpu_device_with_properties creates a GPU context.
//
// These are the supported properties:
//
// - `SDL_PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN`: enable debug mode
//   properties and validations, defaults to true.
// - `SDL_PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN`: enable to prefer
//   energy efficiency over maximum GPU performance, defaults to false.
// - `SDL_PROP_GPU_DEVICE_CREATE_NAME_STRING`: the name of the GPU driver to
//   use, if a specific one is desired.
//
// These are the current shader format properties:
//
// - `SDL_PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN`: The app is able to
//   provide shaders for an NDA platform.
// - `SDL_PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN`: The app is able to
//   provide SPIR-V shaders if applicable.
// - `SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN`: The app is able to
//   provide DXBC shaders if applicable
// - `SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN`: The app is able to
//   provide DXIL shaders if applicable.
// - `SDL_PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN`: The app is able to
//   provide MSL shaders if applicable.
// - `SDL_PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN`: The app is able to
//   provide Metal shader libraries if applicable.
//
// With the D3D12 renderer:
//
// - `SDL_PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING`: the prefix to
//   use for all vertex semantics, default is "TEXCOORD".
//
// `props` props the properties to use.
// returns a GPU context on success or NULL on failure; call SDL_GetError()
//          for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gpu_shader_formats (SDL_GetGPUShaderFormats)
// See also: get_gpu_device_driver (SDL_GetGPUDeviceDriver)
// See also: destroy_gpu_device (SDL_DestroyGPUDevice)
// See also: gpu_supports_properties (SDL_GPUSupportsProperties)
pub fn create_gpu_device_with_properties(props PropertiesID) &GPUDevice {
	return C.SDL_CreateGPUDeviceWithProperties(props)
}

pub const prop_gpu_device_create_debugmode_boolean = C.SDL_PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN // 'SDL.gpu.device.create.debugmode'

pub const prop_gpu_device_create_preferlowpower_boolean = C.SDL_PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN // 'SDL.gpu.device.create.preferlowpower'

pub const prop_gpu_device_create_name_string = C.SDL_PROP_GPU_DEVICE_CREATE_NAME_STRING // 'SDL.gpu.device.create.name'

pub const prop_gpu_device_create_shaders_private_boolean = C.SDL_PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN // 'SDL.gpu.device.create.shaders.private'

pub const prop_gpu_device_create_shaders_spirv_boolean = C.SDL_PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN // 'SDL.gpu.device.create.shaders.spirv'

pub const prop_gpu_device_create_shaders_dxbc_boolean = C.SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN // 'SDL.gpu.device.create.shaders.dxbc'

pub const prop_gpu_device_create_shaders_dxil_boolean = C.SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN // 'SDL.gpu.device.create.shaders.dxil'

pub const prop_gpu_device_create_shaders_msl_boolean = C.SDL_PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN // 'SDL.gpu.device.create.shaders.msl'

pub const prop_gpu_device_create_shaders_metallib_boolean = C.SDL_PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN // 'SDL.gpu.device.create.shaders.metallib'

pub const prop_gpu_device_create_d3d12_semantic_name_string = C.SDL_PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING // 'SDL.gpu.device.create.d3d12.semantic'

// C.SDL_DestroyGPUDevice [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyGPUDevice)
fn C.SDL_DestroyGPUDevice(device &GPUDevice)

// destroy_gpu_device destroys a GPU context previously returned by SDL_CreateGPUDevice.
//
// `device` device a GPU Context to destroy.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_gpu_device (SDL_CreateGPUDevice)
pub fn destroy_gpu_device(device &GPUDevice) {
	C.SDL_DestroyGPUDevice(device)
}

// C.SDL_GetNumGPUDrivers [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumGPUDrivers)
fn C.SDL_GetNumGPUDrivers() int

// get_num_gpu_drivers gets the number of GPU drivers compiled into SDL.
//
// returns the number of built in GPU drivers.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gpu_driver (SDL_GetGPUDriver)
pub fn get_num_gpu_drivers() int {
	return C.SDL_GetNumGPUDrivers()
}

// C.SDL_GetGPUDriver [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGPUDriver)
fn C.SDL_GetGPUDriver(index int) &char

// get_gpu_driver gets the name of a built in GPU driver.
//
// The GPU drivers are presented in the order in which they are normally
// checked during initialization.
//
// The names of drivers are all simple, low-ASCII identifiers, like "vulkan",
// "metal" or "direct3d12". These never have Unicode characters, and are not
// meant to be proper names.
//
// `index` index the index of a GPU driver.
// returns the name of the GPU driver with the given **index**.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_gpu_drivers (SDL_GetNumGPUDrivers)
pub fn get_gpu_driver(index int) &char {
	return C.SDL_GetGPUDriver(index)
}

// C.SDL_GetGPUDeviceDriver [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGPUDeviceDriver)
fn C.SDL_GetGPUDeviceDriver(device &GPUDevice) &char

// get_gpu_device_driver returns the name of the backend used to create this GPU context.
//
// `device` device a GPU context to query.
// returns the name of the device's driver, or NULL on error.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gpu_device_driver(device &GPUDevice) &char {
	return C.SDL_GetGPUDeviceDriver(device)
}

// C.SDL_GetGPUShaderFormats [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGPUShaderFormats)
fn C.SDL_GetGPUShaderFormats(device &GPUDevice) GpuShaderFormat

// get_gpu_shader_formats returns the supported shader formats for this GPU context.
//
// `device` device a GPU context to query.
// returns a bitflag indicating which shader formats the driver is able to
//          consume.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gpu_shader_formats(device &GPUDevice) GpuShaderFormat {
	return C.SDL_GetGPUShaderFormats(device)
}

// C.SDL_CreateGPUComputePipeline [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateGPUComputePipeline)
fn C.SDL_CreateGPUComputePipeline(device &GPUDevice, const_createinfo &GPUComputePipelineCreateInfo) &GPUComputePipeline

// create_gpu_compute_pipeline creates a pipeline object to be used in a compute workflow.
//
// Shader resource bindings must be authored to follow a particular order
// depending on the shader format.
//
// For SPIR-V shaders, use the following resource sets:
//
// - 0: Sampled textures, followed by read-only storage textures, followed by
//   read-only storage buffers
// - 1: Read-write storage textures, followed by read-write storage buffers
// - 2: Uniform buffers
//
// For DXBC and DXIL shaders, use the following register order:
//
// - (t[n], space0): Sampled textures, followed by read-only storage textures,
//   followed by read-only storage buffers
// - (u[n], space1): Read-write storage textures, followed by read-write
//   storage buffers
// - (b[n], space2): Uniform buffers
//
// For MSL/metallib, use the following order:
//
// - [[buffer]]: Uniform buffers, followed by read-only storage buffers,
//   followed by read-write storage buffers
// - [[texture]]: Sampled textures, followed by read-only storage textures,
//   followed by read-write storage textures
//
// There are optional properties that can be provided through `props`. These
// are the supported properties:
//
// - `SDL_PROP_GPU_COMPUTEPIPELINE_CREATE_NAME_STRING`: a name that can be
//   displayed in debugging tools.
//
// `device` device a GPU Context.
// `createinfo` createinfo a struct describing the state of the compute pipeline to
//                   create.
// returns a compute pipeline object on success, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: bind_gpu_compute_pipeline (SDL_BindGPUComputePipeline)
// See also: release_gpu_compute_pipeline (SDL_ReleaseGPUComputePipeline)
pub fn create_gpu_compute_pipeline(device &GPUDevice, const_createinfo &GPUComputePipelineCreateInfo) &GPUComputePipeline {
	return C.SDL_CreateGPUComputePipeline(device, const_createinfo)
}

pub const prop_gpu_computepipeline_create_name_string = C.SDL_PROP_GPU_COMPUTEPIPELINE_CREATE_NAME_STRING // 'SDL.gpu.computepipeline.create.name'

// C.SDL_CreateGPUGraphicsPipeline [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateGPUGraphicsPipeline)
fn C.SDL_CreateGPUGraphicsPipeline(device &GPUDevice, const_createinfo &GPUGraphicsPipelineCreateInfo) &GPUGraphicsPipeline

// create_gpu_graphics_pipeline creates a pipeline object to be used in a graphics workflow.
//
// There are optional properties that can be provided through `props`. These
// are the supported properties:
//
// - `SDL_PROP_GPU_GRAPHICSPIPELINE_CREATE_NAME_STRING`: a name that can be
//   displayed in debugging tools.
//
// `device` device a GPU Context.
// `createinfo` createinfo a struct describing the state of the graphics pipeline to
//                   create.
// returns a graphics pipeline object on success, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_gpu_shader (SDL_CreateGPUShader)
// See also: bind_gpu_graphics_pipeline (SDL_BindGPUGraphicsPipeline)
// See also: release_gpu_graphics_pipeline (SDL_ReleaseGPUGraphicsPipeline)
pub fn create_gpu_graphics_pipeline(device &GPUDevice, const_createinfo &GPUGraphicsPipelineCreateInfo) &GPUGraphicsPipeline {
	return C.SDL_CreateGPUGraphicsPipeline(device, const_createinfo)
}

pub const prop_gpu_graphicspipeline_create_name_string = C.SDL_PROP_GPU_GRAPHICSPIPELINE_CREATE_NAME_STRING // 'SDL.gpu.graphicspipeline.create.name'

// C.SDL_CreateGPUSampler [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateGPUSampler)
fn C.SDL_CreateGPUSampler(device &GPUDevice, const_createinfo &GPUSamplerCreateInfo) &GPUSampler

// create_gpu_sampler creates a sampler object to be used when binding textures in a graphics
// workflow.
//
// There are optional properties that can be provided through `props`. These
// are the supported properties:
//
// - `SDL_PROP_GPU_SAMPLER_CREATE_NAME_STRING`: a name that can be displayed
//   in debugging tools.
//
// `device` device a GPU Context.
// `createinfo` createinfo a struct describing the state of the sampler to create.
// returns a sampler object on success, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: bind_gpu_vertex_samplers (SDL_BindGPUVertexSamplers)
// See also: bind_gpu_fragment_samplers (SDL_BindGPUFragmentSamplers)
// See also: release_gpu_sampler (SDL_ReleaseGPUSampler)
pub fn create_gpu_sampler(device &GPUDevice, const_createinfo &GPUSamplerCreateInfo) &GPUSampler {
	return C.SDL_CreateGPUSampler(device, const_createinfo)
}

pub const prop_gpu_sampler_create_name_string = C.SDL_PROP_GPU_SAMPLER_CREATE_NAME_STRING // 'SDL.gpu.sampler.create.name'

// C.SDL_CreateGPUShader [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateGPUShader)
fn C.SDL_CreateGPUShader(device &GPUDevice, const_createinfo &GPUShaderCreateInfo) &GPUShader

// create_gpu_shader creates a shader to be used when creating a graphics pipeline.
//
// Shader resource bindings must be authored to follow a particular order
// depending on the shader format.
//
// For SPIR-V shaders, use the following resource sets:
//
// For vertex shaders:
//
// - 0: Sampled textures, followed by storage textures, followed by storage
//   buffers
// - 1: Uniform buffers
//
// For fragment shaders:
//
// - 2: Sampled textures, followed by storage textures, followed by storage
//   buffers
// - 3: Uniform buffers
//
// For DXBC and DXIL shaders, use the following register order:
//
// For vertex shaders:
//
// - (t[n], space0): Sampled textures, followed by storage textures, followed
//   by storage buffers
// - (s[n], space0): Samplers with indices corresponding to the sampled
//   textures
// - (b[n], space1): Uniform buffers
//
// For pixel shaders:
//
// - (t[n], space2): Sampled textures, followed by storage textures, followed
//   by storage buffers
// - (s[n], space2): Samplers with indices corresponding to the sampled
//   textures
// - (b[n], space3): Uniform buffers
//
// For MSL/metallib, use the following order:
//
// - [[texture]]: Sampled textures, followed by storage textures
// - [[sampler]]: Samplers with indices corresponding to the sampled textures
// - [[buffer]]: Uniform buffers, followed by storage buffers. Vertex buffer 0
//   is bound at [[buffer(14)]], vertex buffer 1 at [[buffer(15)]], and so on.
//   Rather than manually authoring vertex buffer indices, use the
//   [[stage_in]] attribute which will automatically use the vertex input
//   information from the SDL_GPUGraphicsPipeline.
//
// Shader semantics other than system-value semantics do not matter in D3D12
// and for ease of use the SDL implementation assumes that non system-value
// semantics will all be TEXCOORD. If you are using HLSL as the shader source
// language, your vertex semantics should start at TEXCOORD0 and increment
// like so: TEXCOORD1, TEXCOORD2, etc. If you wish to change the semantic
// prefix to something other than TEXCOORD you can use
// SDL_PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING with
// SDL_CreateGPUDeviceWithProperties().
//
// There are optional properties that can be provided through `props`. These
// are the supported properties:
//
// - `SDL_PROP_GPU_SHADER_CREATE_NAME_STRING`: a name that can be displayed in
//   debugging tools.
//
// `device` device a GPU Context.
// `createinfo` createinfo a struct describing the state of the shader to create.
// returns a shader object on success, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_gpu_graphics_pipeline (SDL_CreateGPUGraphicsPipeline)
// See also: release_gpu_shader (SDL_ReleaseGPUShader)
pub fn create_gpu_shader(device &GPUDevice, const_createinfo &GPUShaderCreateInfo) &GPUShader {
	return C.SDL_CreateGPUShader(device, const_createinfo)
}

pub const prop_gpu_shader_create_name_string = C.SDL_PROP_GPU_SHADER_CREATE_NAME_STRING // 'SDL.gpu.shader.create.name'

// C.SDL_CreateGPUTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateGPUTexture)
fn C.SDL_CreateGPUTexture(device &GPUDevice, const_createinfo &GPUTextureCreateInfo) &GPUTexture

// create_gpu_texture creates a texture object to be used in graphics or compute workflows.
//
// The contents of this texture are undefined until data is written to the
// texture.
//
// Note that certain combinations of usage flags are invalid. For example, a
// texture cannot have both the SAMPLER and GRAPHICS_STORAGE_READ flags.
//
// If you request a sample count higher than the hardware supports, the
// implementation will automatically fall back to the highest available sample
// count.
//
// There are optional properties that can be provided through
// SDL_GPUTextureCreateInfo's `props`. These are the supported properties:
//
// - `SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_R_FLOAT`: (Direct3D 12 only) if
//   the texture usage is SDL_GPU_TEXTUREUSAGE_COLOR_TARGET, clear the texture
//   to a color with this red intensity. Defaults to zero.
// - `SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_G_FLOAT`: (Direct3D 12 only) if
//   the texture usage is SDL_GPU_TEXTUREUSAGE_COLOR_TARGET, clear the texture
//   to a color with this green intensity. Defaults to zero.
// - `SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_B_FLOAT`: (Direct3D 12 only) if
//   the texture usage is SDL_GPU_TEXTUREUSAGE_COLOR_TARGET, clear the texture
//   to a color with this blue intensity. Defaults to zero.
// - `SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_A_FLOAT`: (Direct3D 12 only) if
//   the texture usage is SDL_GPU_TEXTUREUSAGE_COLOR_TARGET, clear the texture
//   to a color with this alpha intensity. Defaults to zero.
// - `SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_DEPTH_FLOAT`: (Direct3D 12 only)
//   if the texture usage is SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET, clear
//   the texture to a depth of this value. Defaults to zero.
// - `SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_STENCIL_UINT8`: (Direct3D 12
//   only) if the texture usage is SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET,
//   clear the texture to a stencil of this value. Defaults to zero.
// - `SDL_PROP_GPU_TEXTURE_CREATE_NAME_STRING`: a name that can be displayed
//   in debugging tools.
//
// `device` device a GPU Context.
// `createinfo` createinfo a struct describing the state of the texture to create.
// returns a texture object on success, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: upload_to_gpu_texture (SDL_UploadToGPUTexture)
// See also: download_from_gpu_texture (SDL_DownloadFromGPUTexture)
// See also: bind_gpu_vertex_samplers (SDL_BindGPUVertexSamplers)
// See also: bind_gpu_vertex_storage_textures (SDL_BindGPUVertexStorageTextures)
// See also: bind_gpu_fragment_samplers (SDL_BindGPUFragmentSamplers)
// See also: bind_gpu_fragment_storage_textures (SDL_BindGPUFragmentStorageTextures)
// See also: bind_gpu_compute_storage_textures (SDL_BindGPUComputeStorageTextures)
// See also: blit_gpu_texture (SDL_BlitGPUTexture)
// See also: release_gpu_texture (SDL_ReleaseGPUTexture)
// See also: gpu_texture_supports_format (SDL_GPUTextureSupportsFormat)
pub fn create_gpu_texture(device &GPUDevice, const_createinfo &GPUTextureCreateInfo) &GPUTexture {
	return C.SDL_CreateGPUTexture(device, const_createinfo)
}

pub const prop_gpu_texture_create_d3d12_clear_r_float = C.SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_R_FLOAT // 'SDL.gpu.texture.create.d3d12.clear.r'

pub const prop_gpu_texture_create_d3d12_clear_g_float = C.SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_G_FLOAT // 'SDL.gpu.texture.create.d3d12.clear.g'

pub const prop_gpu_texture_create_d3d12_clear_b_float = C.SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_B_FLOAT // 'SDL.gpu.texture.create.d3d12.clear.b'

pub const prop_gpu_texture_create_d3d12_clear_a_float = C.SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_A_FLOAT // 'SDL.gpu.texture.create.d3d12.clear.a'

pub const prop_gpu_texture_create_d3d12_clear_depth_float = C.SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_DEPTH_FLOAT // 'SDL.gpu.texture.create.d3d12.clear.depth'

pub const prop_gpu_texture_create_d3d12_clear_stencil_uint8 = C.SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_STENCIL_UINT8 // 'SDL.gpu.texture.create.d3d12.clear.stencil'

pub const prop_gpu_texture_create_name_string = C.SDL_PROP_GPU_TEXTURE_CREATE_NAME_STRING // 'SDL.gpu.texture.create.name'

// C.SDL_CreateGPUBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateGPUBuffer)
fn C.SDL_CreateGPUBuffer(device &GPUDevice, const_createinfo &GPUBufferCreateInfo) &GPUBuffer

// create_gpu_buffer creates a buffer object to be used in graphics or compute workflows.
//
// The contents of this buffer are undefined until data is written to the
// buffer.
//
// Note that certain combinations of usage flags are invalid. For example, a
// buffer cannot have both the VERTEX and INDEX flags.
//
// For better understanding of underlying concepts and memory management with
// SDL GPU API, you may refer
// [this blog post](https://moonside.games/posts/sdl-gpu-concepts-cycling/)
// .
//
// There are optional properties that can be provided through `props`. These
// are the supported properties:
//
// - `SDL_PROP_GPU_BUFFER_CREATE_NAME_STRING`: a name that can be displayed in
//   debugging tools.
//
// `device` device a GPU Context.
// `createinfo` createinfo a struct describing the state of the buffer to create.
// returns a buffer object on success, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: upload_to_gpu_buffer (SDL_UploadToGPUBuffer)
// See also: download_from_gpu_buffer (SDL_DownloadFromGPUBuffer)
// See also: copy_gpu_buffer_to_buffer (SDL_CopyGPUBufferToBuffer)
// See also: bind_gpu_vertex_buffers (SDL_BindGPUVertexBuffers)
// See also: bind_gpu_index_buffer (SDL_BindGPUIndexBuffer)
// See also: bind_gpu_vertex_storage_buffers (SDL_BindGPUVertexStorageBuffers)
// See also: bind_gpu_fragment_storage_buffers (SDL_BindGPUFragmentStorageBuffers)
// See also: draw_gpu_primitives_indirect (SDL_DrawGPUPrimitivesIndirect)
// See also: draw_gpu_indexed_primitives_indirect (SDL_DrawGPUIndexedPrimitivesIndirect)
// See also: bind_gpu_compute_storage_buffers (SDL_BindGPUComputeStorageBuffers)
// See also: dispatch_gpu_compute_indirect (SDL_DispatchGPUComputeIndirect)
// See also: release_gpu_buffer (SDL_ReleaseGPUBuffer)
pub fn create_gpu_buffer(device &GPUDevice, const_createinfo &GPUBufferCreateInfo) &GPUBuffer {
	return C.SDL_CreateGPUBuffer(device, const_createinfo)
}

pub const prop_gpu_buffer_create_name_string = C.SDL_PROP_GPU_BUFFER_CREATE_NAME_STRING // 'SDL.gpu.buffer.create.name'

// C.SDL_CreateGPUTransferBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateGPUTransferBuffer)
fn C.SDL_CreateGPUTransferBuffer(device &GPUDevice, const_createinfo &GPUTransferBufferCreateInfo) &GPUTransferBuffer

// create_gpu_transfer_buffer creates a transfer buffer to be used when uploading to or downloading from
// graphics resources.
//
// Download buffers can be particularly expensive to create, so it is good
// practice to reuse them if data will be downloaded regularly.
//
// There are optional properties that can be provided through `props`. These
// are the supported properties:
//
// - `SDL_PROP_GPU_TRANSFERBUFFER_CREATE_NAME_STRING`: a name that can be
//   displayed in debugging tools.
//
// `device` device a GPU Context.
// `createinfo` createinfo a struct describing the state of the transfer buffer to
//                   create.
// returns a transfer buffer on success, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: upload_to_gpu_buffer (SDL_UploadToGPUBuffer)
// See also: download_from_gpu_buffer (SDL_DownloadFromGPUBuffer)
// See also: upload_to_gpu_texture (SDL_UploadToGPUTexture)
// See also: download_from_gpu_texture (SDL_DownloadFromGPUTexture)
// See also: release_gpu_transfer_buffer (SDL_ReleaseGPUTransferBuffer)
pub fn create_gpu_transfer_buffer(device &GPUDevice, const_createinfo &GPUTransferBufferCreateInfo) &GPUTransferBuffer {
	return C.SDL_CreateGPUTransferBuffer(device, const_createinfo)
}

pub const prop_gpu_transferbuffer_create_name_string = C.SDL_PROP_GPU_TRANSFERBUFFER_CREATE_NAME_STRING // 'SDL.gpu.transferbuffer.create.name'

// C.SDL_SetGPUBufferName [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGPUBufferName)
fn C.SDL_SetGPUBufferName(device &GPUDevice, buffer &GPUBuffer, const_text &char)

// set_gpu_buffer_name sets an arbitrary string constant to label a buffer.
//
// You should use SDL_PROP_GPU_BUFFER_CREATE_NAME_STRING with
// SDL_CreateGPUBuffer instead of this function to avoid thread safety issues.
//
// `device` device a GPU Context.
// `buffer` buffer a buffer to attach the name to.
// `text` text a UTF-8 string constant to mark as the name of the buffer.
//
// NOTE: (thread safety) This function is not thread safe, you must make sure the
//               buffer is not simultaneously used by any other thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_gpu_buffer (SDL_CreateGPUBuffer)
pub fn set_gpu_buffer_name(device &GPUDevice, buffer &GPUBuffer, const_text &char) {
	C.SDL_SetGPUBufferName(device, buffer, const_text)
}

// C.SDL_SetGPUTextureName [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGPUTextureName)
fn C.SDL_SetGPUTextureName(device &GPUDevice, texture &GPUTexture, const_text &char)

// set_gpu_texture_name sets an arbitrary string constant to label a texture.
//
// You should use SDL_PROP_GPU_TEXTURE_CREATE_NAME_STRING with
// SDL_CreateGPUTexture instead of this function to avoid thread safety
// issues.
//
// `device` device a GPU Context.
// `texture` texture a texture to attach the name to.
// `text` text a UTF-8 string constant to mark as the name of the texture.
//
// NOTE: (thread safety) This function is not thread safe, you must make sure the
//               texture is not simultaneously used by any other thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_gpu_texture (SDL_CreateGPUTexture)
pub fn set_gpu_texture_name(device &GPUDevice, texture &GPUTexture, const_text &char) {
	C.SDL_SetGPUTextureName(device, texture, const_text)
}

// C.SDL_InsertGPUDebugLabel [official documentation](https://wiki.libsdl.org/SDL3/SDL_InsertGPUDebugLabel)
fn C.SDL_InsertGPUDebugLabel(command_buffer &GPUCommandBuffer, const_text &char)

// insert_gpu_debug_label inserts an arbitrary string label into the command buffer callstream.
//
// Useful for debugging.
//
// `command_buffer` command_buffer a command buffer.
// `text` text a UTF-8 string constant to insert as the label.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn insert_gpu_debug_label(command_buffer &GPUCommandBuffer, const_text &char) {
	C.SDL_InsertGPUDebugLabel(command_buffer, const_text)
}

// C.SDL_PushGPUDebugGroup [official documentation](https://wiki.libsdl.org/SDL3/SDL_PushGPUDebugGroup)
fn C.SDL_PushGPUDebugGroup(command_buffer &GPUCommandBuffer, const_name &char)

// push_gpu_debug_group begins a debug group with an arbitary name.
//
// Used for denoting groups of calls when viewing the command buffer
// callstream in a graphics debugging tool.
//
// Each call to SDL_PushGPUDebugGroup must have a corresponding call to
// SDL_PopGPUDebugGroup.
//
// On some backends (e.g. Metal), pushing a debug group during a
// render/blit/compute pass will create a group that is scoped to the native
// pass rather than the command buffer. For best results, if you push a debug
// group during a pass, always pop it in the same pass.
//
// `command_buffer` command_buffer a command buffer.
// `name` name a UTF-8 string constant that names the group.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: pop_gpu_debug_group (SDL_PopGPUDebugGroup)
pub fn push_gpu_debug_group(command_buffer &GPUCommandBuffer, const_name &char) {
	C.SDL_PushGPUDebugGroup(command_buffer, const_name)
}

// C.SDL_PopGPUDebugGroup [official documentation](https://wiki.libsdl.org/SDL3/SDL_PopGPUDebugGroup)
fn C.SDL_PopGPUDebugGroup(command_buffer &GPUCommandBuffer)

// pop_gpu_debug_group ends the most-recently pushed debug group.
//
// `command_buffer` command_buffer a command buffer.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: push_gpu_debug_group (SDL_PushGPUDebugGroup)
pub fn pop_gpu_debug_group(command_buffer &GPUCommandBuffer) {
	C.SDL_PopGPUDebugGroup(command_buffer)
}

// C.SDL_ReleaseGPUTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReleaseGPUTexture)
fn C.SDL_ReleaseGPUTexture(device &GPUDevice, texture &GPUTexture)

// release_gpu_texture frees the given texture as soon as it is safe to do so.
//
// You must not reference the texture after calling this function.
//
// `device` device a GPU context.
// `texture` texture a texture to be destroyed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn release_gpu_texture(device &GPUDevice, texture &GPUTexture) {
	C.SDL_ReleaseGPUTexture(device, texture)
}

// C.SDL_ReleaseGPUSampler [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReleaseGPUSampler)
fn C.SDL_ReleaseGPUSampler(device &GPUDevice, sampler &GPUSampler)

// release_gpu_sampler frees the given sampler as soon as it is safe to do so.
//
// You must not reference the sampler after calling this function.
//
// `device` device a GPU context.
// `sampler` sampler a sampler to be destroyed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn release_gpu_sampler(device &GPUDevice, sampler &GPUSampler) {
	C.SDL_ReleaseGPUSampler(device, sampler)
}

// C.SDL_ReleaseGPUBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReleaseGPUBuffer)
fn C.SDL_ReleaseGPUBuffer(device &GPUDevice, buffer &GPUBuffer)

// release_gpu_buffer frees the given buffer as soon as it is safe to do so.
//
// You must not reference the buffer after calling this function.
//
// `device` device a GPU context.
// `buffer` buffer a buffer to be destroyed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn release_gpu_buffer(device &GPUDevice, buffer &GPUBuffer) {
	C.SDL_ReleaseGPUBuffer(device, buffer)
}

// C.SDL_ReleaseGPUTransferBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReleaseGPUTransferBuffer)
fn C.SDL_ReleaseGPUTransferBuffer(device &GPUDevice, transfer_buffer &GPUTransferBuffer)

// release_gpu_transfer_buffer frees the given transfer buffer as soon as it is safe to do so.
//
// You must not reference the transfer buffer after calling this function.
//
// `device` device a GPU context.
// `transfer_buffer` transfer_buffer a transfer buffer to be destroyed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn release_gpu_transfer_buffer(device &GPUDevice, transfer_buffer &GPUTransferBuffer) {
	C.SDL_ReleaseGPUTransferBuffer(device, transfer_buffer)
}

// C.SDL_ReleaseGPUComputePipeline [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReleaseGPUComputePipeline)
fn C.SDL_ReleaseGPUComputePipeline(device &GPUDevice, compute_pipeline &GPUComputePipeline)

// release_gpu_compute_pipeline frees the given compute pipeline as soon as it is safe to do so.
//
// You must not reference the compute pipeline after calling this function.
//
// `device` device a GPU context.
// `compute_pipeline` compute_pipeline a compute pipeline to be destroyed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn release_gpu_compute_pipeline(device &GPUDevice, compute_pipeline &GPUComputePipeline) {
	C.SDL_ReleaseGPUComputePipeline(device, compute_pipeline)
}

// C.SDL_ReleaseGPUShader [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReleaseGPUShader)
fn C.SDL_ReleaseGPUShader(device &GPUDevice, shader &GPUShader)

// release_gpu_shader frees the given shader as soon as it is safe to do so.
//
// You must not reference the shader after calling this function.
//
// `device` device a GPU context.
// `shader` shader a shader to be destroyed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn release_gpu_shader(device &GPUDevice, shader &GPUShader) {
	C.SDL_ReleaseGPUShader(device, shader)
}

// C.SDL_ReleaseGPUGraphicsPipeline [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReleaseGPUGraphicsPipeline)
fn C.SDL_ReleaseGPUGraphicsPipeline(device &GPUDevice, graphics_pipeline &GPUGraphicsPipeline)

// release_gpu_graphics_pipeline frees the given graphics pipeline as soon as it is safe to do so.
//
// You must not reference the graphics pipeline after calling this function.
//
// `device` device a GPU context.
// `graphics_pipeline` graphics_pipeline a graphics pipeline to be destroyed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn release_gpu_graphics_pipeline(device &GPUDevice, graphics_pipeline &GPUGraphicsPipeline) {
	C.SDL_ReleaseGPUGraphicsPipeline(device, graphics_pipeline)
}

// C.SDL_AcquireGPUCommandBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_AcquireGPUCommandBuffer)
fn C.SDL_AcquireGPUCommandBuffer(device &GPUDevice) &GPUCommandBuffer

// acquire_gpu_command_buffer acquires a command buffer.
//
// This command buffer is managed by the implementation and should not be
// freed by the user. The command buffer may only be used on the thread it was
// acquired on. The command buffer should be submitted on the thread it was
// acquired on.
//
// It is valid to acquire multiple command buffers on the same thread at once.
// In fact a common design pattern is to acquire two command buffers per frame
// where one is dedicated to render and compute passes and the other is
// dedicated to copy passes and other preparatory work such as generating
// mipmaps. Interleaving commands between the two command buffers reduces the
// total amount of passes overall which improves rendering performance.
//
// `device` device a GPU context.
// returns a command buffer, or NULL on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: submit_gpu_command_buffer (SDL_SubmitGPUCommandBuffer)
// See also: submit_gpu_command_buffer_and_acquire_fence (SDL_SubmitGPUCommandBufferAndAcquireFence)
pub fn acquire_gpu_command_buffer(device &GPUDevice) &GPUCommandBuffer {
	return C.SDL_AcquireGPUCommandBuffer(device)
}

// C.SDL_PushGPUVertexUniformData [official documentation](https://wiki.libsdl.org/SDL3/SDL_PushGPUVertexUniformData)
fn C.SDL_PushGPUVertexUniformData(command_buffer &GPUCommandBuffer, slot_index u32, const_data voidptr, length u32)

// push_gpu_vertex_uniform_data pushes data to a vertex uniform slot on the command buffer.
//
// Subsequent draw calls will use this uniform data.
//
// `command_buffer` command_buffer a command buffer.
// `slot_index` slot_index the vertex uniform slot to push data to.
// `data` data client data to write.
// `length` length the length of the data to write.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn push_gpu_vertex_uniform_data(command_buffer &GPUCommandBuffer, slot_index u32, const_data voidptr, length u32) {
	C.SDL_PushGPUVertexUniformData(command_buffer, slot_index, const_data, length)
}

// C.SDL_PushGPUFragmentUniformData [official documentation](https://wiki.libsdl.org/SDL3/SDL_PushGPUFragmentUniformData)
fn C.SDL_PushGPUFragmentUniformData(command_buffer &GPUCommandBuffer, slot_index u32, const_data voidptr, length u32)

// push_gpu_fragment_uniform_data pushes data to a fragment uniform slot on the command buffer.
//
// Subsequent draw calls will use this uniform data.
//
// `command_buffer` command_buffer a command buffer.
// `slot_index` slot_index the fragment uniform slot to push data to.
// `data` data client data to write.
// `length` length the length of the data to write.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn push_gpu_fragment_uniform_data(command_buffer &GPUCommandBuffer, slot_index u32, const_data voidptr, length u32) {
	C.SDL_PushGPUFragmentUniformData(command_buffer, slot_index, const_data, length)
}

// C.SDL_PushGPUComputeUniformData [official documentation](https://wiki.libsdl.org/SDL3/SDL_PushGPUComputeUniformData)
fn C.SDL_PushGPUComputeUniformData(command_buffer &GPUCommandBuffer, slot_index u32, const_data voidptr, length u32)

// push_gpu_compute_uniform_data pushes data to a uniform slot on the command buffer.
//
// Subsequent draw calls will use this uniform data.
//
// `command_buffer` command_buffer a command buffer.
// `slot_index` slot_index the uniform slot to push data to.
// `data` data client data to write.
// `length` length the length of the data to write.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn push_gpu_compute_uniform_data(command_buffer &GPUCommandBuffer, slot_index u32, const_data voidptr, length u32) {
	C.SDL_PushGPUComputeUniformData(command_buffer, slot_index, const_data, length)
}

// C.SDL_BeginGPURenderPass [official documentation](https://wiki.libsdl.org/SDL3/SDL_BeginGPURenderPass)
fn C.SDL_BeginGPURenderPass(command_buffer &GPUCommandBuffer, const_color_target_infos &GPUColorTargetInfo, num_color_targets u32, const_depth_stencil_target_info &GPUDepthStencilTargetInfo) &GPURenderPass

// begin_gpu_render_pass begins a render pass on a command buffer.
//
// A render pass consists of a set of texture subresources (or depth slices in
// the 3D texture case) which will be rendered to during the render pass,
// along with corresponding clear values and load/store operations. All
// operations related to graphics pipelines must take place inside of a render
// pass. A default viewport and scissor state are automatically set when this
// is called. You cannot begin another render pass, or begin a compute pass or
// copy pass until you have ended the render pass.
//
// `command_buffer` command_buffer a command buffer.
// `color_target_infos` color_target_infos an array of texture subresources with
//                           corresponding clear values and load/store ops.
// `num_color_targets` num_color_targets the number of color targets in the
//                          color_target_infos array.
// `depth_stencil_target_info` depth_stencil_target_info a texture subresource with corresponding
//                                  clear value and load/store ops, may be
//                                  NULL.
// returns a render pass handle.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: end_gpu_render_pass (SDL_EndGPURenderPass)
pub fn begin_gpu_render_pass(command_buffer &GPUCommandBuffer, const_color_target_infos &GPUColorTargetInfo, num_color_targets u32, const_depth_stencil_target_info &GPUDepthStencilTargetInfo) &GPURenderPass {
	return C.SDL_BeginGPURenderPass(command_buffer, const_color_target_infos, num_color_targets,
		const_depth_stencil_target_info)
}

// C.SDL_BindGPUGraphicsPipeline [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUGraphicsPipeline)
fn C.SDL_BindGPUGraphicsPipeline(render_pass &GPURenderPass, graphics_pipeline &GPUGraphicsPipeline)

// bind_gpu_graphics_pipeline binds a graphics pipeline on a render pass to be used in rendering.
//
// A graphics pipeline must be bound before making any draw calls.
//
// `render_pass` render_pass a render pass handle.
// `graphics_pipeline` graphics_pipeline the graphics pipeline to bind.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_graphics_pipeline(render_pass &GPURenderPass, graphics_pipeline &GPUGraphicsPipeline) {
	C.SDL_BindGPUGraphicsPipeline(render_pass, graphics_pipeline)
}

// C.SDL_SetGPUViewport [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGPUViewport)
fn C.SDL_SetGPUViewport(render_pass &GPURenderPass, const_viewport &GPUViewport)

// set_gpu_viewport sets the current viewport state on a command buffer.
//
// `render_pass` render_pass a render pass handle.
// `viewport` viewport the viewport to set.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_gpu_viewport(render_pass &GPURenderPass, const_viewport &GPUViewport) {
	C.SDL_SetGPUViewport(render_pass, const_viewport)
}

// C.SDL_SetGPUScissor [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGPUScissor)
fn C.SDL_SetGPUScissor(render_pass &GPURenderPass, const_scissor &Rect)

// set_gpu_scissor sets the current scissor state on a command buffer.
//
// `render_pass` render_pass a render pass handle.
// `scissor` scissor the scissor area to set.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_gpu_scissor(render_pass &GPURenderPass, const_scissor &Rect) {
	C.SDL_SetGPUScissor(render_pass, const_scissor)
}

// C.SDL_SetGPUBlendConstants [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGPUBlendConstants)
fn C.SDL_SetGPUBlendConstants(render_pass &GPURenderPass, blend_constants FColor)

// set_gpu_blend_constants sets the current blend constants on a command buffer.
//
// `render_pass` render_pass a render pass handle.
// `blend_constants` blend_constants the blend constant color.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gpublendfactorconstantcolor (SDL_GPU_BLENDFACTOR_CONSTANT_COLOR)
// See also: gpublendfactoroneminusconstantcolor (SDL_GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOR)
pub fn set_gpu_blend_constants(render_pass &GPURenderPass, blend_constants FColor) {
	C.SDL_SetGPUBlendConstants(render_pass, blend_constants)
}

// C.SDL_SetGPUStencilReference [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGPUStencilReference)
fn C.SDL_SetGPUStencilReference(render_pass &GPURenderPass, reference u8)

// set_gpu_stencil_reference sets the current stencil reference value on a command buffer.
//
// `render_pass` render_pass a render pass handle.
// `reference` reference the stencil reference value to set.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_gpu_stencil_reference(render_pass &GPURenderPass, reference u8) {
	C.SDL_SetGPUStencilReference(render_pass, reference)
}

// C.SDL_BindGPUVertexBuffers [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUVertexBuffers)
fn C.SDL_BindGPUVertexBuffers(render_pass &GPURenderPass, first_slot u32, const_bindings &GPUBufferBinding, num_bindings u32)

// bind_gpu_vertex_buffers binds vertex buffers on a command buffer for use with subsequent draw
// calls.
//
// `render_pass` render_pass a render pass handle.
// `first_slot` first_slot the vertex buffer slot to begin binding from.
// `bindings` bindings an array of SDL_GPUBufferBinding structs containing vertex
//                 buffers and offset values.
// `num_bindings` num_bindings the number of bindings in the bindings array.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_vertex_buffers(render_pass &GPURenderPass, first_slot u32, const_bindings &GPUBufferBinding, num_bindings u32) {
	C.SDL_BindGPUVertexBuffers(render_pass, first_slot, const_bindings, num_bindings)
}

// C.SDL_BindGPUIndexBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUIndexBuffer)
fn C.SDL_BindGPUIndexBuffer(render_pass &GPURenderPass, const_binding &GPUBufferBinding, index_element_size GPUIndexElementSize)

// bind_gpu_index_buffer binds an index buffer on a command buffer for use with subsequent draw
// calls.
//
// `render_pass` render_pass a render pass handle.
// `binding` binding a pointer to a struct containing an index buffer and offset.
// `index_element_size` index_element_size whether the index values in the buffer are 16- or
//                           32-bit.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_index_buffer(render_pass &GPURenderPass, const_binding &GPUBufferBinding, index_element_size GPUIndexElementSize) {
	C.SDL_BindGPUIndexBuffer(render_pass, const_binding, index_element_size)
}

// C.SDL_BindGPUVertexSamplers [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUVertexSamplers)
fn C.SDL_BindGPUVertexSamplers(render_pass &GPURenderPass, first_slot u32, const_texture_sampler_bindings &GPUTextureSamplerBinding, num_bindings u32)

// bind_gpu_vertex_samplers binds texture-sampler pairs for use on the vertex shader.
//
// The textures must have been created with SDL_GPU_TEXTUREUSAGE_SAMPLER.
//
// `render_pass` render_pass a render pass handle.
// `first_slot` first_slot the vertex sampler slot to begin binding from.
// `texture_sampler_bindings` texture_sampler_bindings an array of texture-sampler binding
//                                 structs.
// `num_bindings` num_bindings the number of texture-sampler pairs to bind from the
//                     array.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_vertex_samplers(render_pass &GPURenderPass, first_slot u32, const_texture_sampler_bindings &GPUTextureSamplerBinding, num_bindings u32) {
	C.SDL_BindGPUVertexSamplers(render_pass, first_slot, const_texture_sampler_bindings,
		num_bindings)
}

// C.SDL_BindGPUVertexStorageTextures [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUVertexStorageTextures)
fn C.SDL_BindGPUVertexStorageTextures(render_pass &GPURenderPass, first_slot u32, const_storage_textures &&C.SDL_GPUTexture, num_bindings u32)

// bind_gpu_vertex_storage_textures binds storage textures for use on the vertex shader.
//
// These textures must have been created with
// SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ.
//
// `render_pass` render_pass a render pass handle.
// `first_slot` first_slot the vertex storage texture slot to begin binding from.
// `storage_textures` storage_textures an array of storage textures.
// `num_bindings` num_bindings the number of storage texture to bind from the array.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_vertex_storage_textures(render_pass &GPURenderPass, first_slot u32, const_storage_textures &&C.SDL_GPUTexture, num_bindings u32) {
	C.SDL_BindGPUVertexStorageTextures(render_pass, first_slot, const_storage_textures,
		num_bindings)
}

// C.SDL_BindGPUVertexStorageBuffers [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUVertexStorageBuffers)
fn C.SDL_BindGPUVertexStorageBuffers(render_pass &GPURenderPass, first_slot u32, const_storage_buffers &&C.SDL_GPUBuffer, num_bindings u32)

// bind_gpu_vertex_storage_buffers binds storage buffers for use on the vertex shader.
//
// These buffers must have been created with
// SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ.
//
// `render_pass` render_pass a render pass handle.
// `first_slot` first_slot the vertex storage buffer slot to begin binding from.
// `storage_buffers` storage_buffers an array of buffers.
// `num_bindings` num_bindings the number of buffers to bind from the array.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_vertex_storage_buffers(render_pass &GPURenderPass, first_slot u32, const_storage_buffers &&C.SDL_GPUBuffer, num_bindings u32) {
	C.SDL_BindGPUVertexStorageBuffers(render_pass, first_slot, const_storage_buffers,
		num_bindings)
}

// C.SDL_BindGPUFragmentSamplers [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUFragmentSamplers)
fn C.SDL_BindGPUFragmentSamplers(render_pass &GPURenderPass, first_slot u32, const_texture_sampler_bindings &GPUTextureSamplerBinding, num_bindings u32)

// bind_gpu_fragment_samplers binds texture-sampler pairs for use on the fragment shader.
//
// The textures must have been created with SDL_GPU_TEXTUREUSAGE_SAMPLER.
//
// `render_pass` render_pass a render pass handle.
// `first_slot` first_slot the fragment sampler slot to begin binding from.
// `texture_sampler_bindings` texture_sampler_bindings an array of texture-sampler binding
//                                 structs.
// `num_bindings` num_bindings the number of texture-sampler pairs to bind from the
//                     array.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_fragment_samplers(render_pass &GPURenderPass, first_slot u32, const_texture_sampler_bindings &GPUTextureSamplerBinding, num_bindings u32) {
	C.SDL_BindGPUFragmentSamplers(render_pass, first_slot, const_texture_sampler_bindings,
		num_bindings)
}

// C.SDL_BindGPUFragmentStorageTextures [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUFragmentStorageTextures)
fn C.SDL_BindGPUFragmentStorageTextures(render_pass &GPURenderPass, first_slot u32, const_storage_textures &&C.SDL_GPUTexture, num_bindings u32)

// bind_gpu_fragment_storage_textures binds storage textures for use on the fragment shader.
//
// These textures must have been created with
// SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ.
//
// `render_pass` render_pass a render pass handle.
// `first_slot` first_slot the fragment storage texture slot to begin binding from.
// `storage_textures` storage_textures an array of storage textures.
// `num_bindings` num_bindings the number of storage textures to bind from the array.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_fragment_storage_textures(render_pass &GPURenderPass, first_slot u32, const_storage_textures &&C.SDL_GPUTexture, num_bindings u32) {
	C.SDL_BindGPUFragmentStorageTextures(render_pass, first_slot, const_storage_textures,
		num_bindings)
}

// C.SDL_BindGPUFragmentStorageBuffers [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUFragmentStorageBuffers)
fn C.SDL_BindGPUFragmentStorageBuffers(render_pass &GPURenderPass, first_slot u32, const_storage_buffers &&C.SDL_GPUBuffer, num_bindings u32)

// bind_gpu_fragment_storage_buffers binds storage buffers for use on the fragment shader.
//
// These buffers must have been created with
// SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ.
//
// `render_pass` render_pass a render pass handle.
// `first_slot` first_slot the fragment storage buffer slot to begin binding from.
// `storage_buffers` storage_buffers an array of storage buffers.
// `num_bindings` num_bindings the number of storage buffers to bind from the array.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_fragment_storage_buffers(render_pass &GPURenderPass, first_slot u32, const_storage_buffers &&C.SDL_GPUBuffer, num_bindings u32) {
	C.SDL_BindGPUFragmentStorageBuffers(render_pass, first_slot, const_storage_buffers,
		num_bindings)
}

// C.SDL_DrawGPUIndexedPrimitives [official documentation](https://wiki.libsdl.org/SDL3/SDL_DrawGPUIndexedPrimitives)
fn C.SDL_DrawGPUIndexedPrimitives(render_pass &GPURenderPass, num_indices u32, num_instances u32, first_index u32, vertex_offset i32, first_instance u32)

// draw_gpu_indexed_primitives draws data using bound graphics state with an index buffer and instancing
// enabled.
//
// You must not call this function before binding a graphics pipeline.
//
// Note that the `first_vertex` and `first_instance` parameters are NOT
// compatible with built-in vertex/instance ID variables in shaders (for
// example, SV_VertexID); GPU APIs and shader languages do not define these
// built-in variables consistently, so if your shader depends on them, the
// only way to keep behavior consistent and portable is to always pass 0 for
// the correlating parameter in the draw calls.
//
// `render_pass` render_pass a render pass handle.
// `num_indices` num_indices the number of indices to draw per instance.
// `num_instances` num_instances the number of instances to draw.
// `first_index` first_index the starting index within the index buffer.
// `vertex_offset` vertex_offset value added to vertex index before indexing into the
//                      vertex buffer.
// `first_instance` first_instance the ID of the first instance to draw.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn draw_gpu_indexed_primitives(render_pass &GPURenderPass, num_indices u32, num_instances u32, first_index u32, vertex_offset i32, first_instance u32) {
	C.SDL_DrawGPUIndexedPrimitives(render_pass, num_indices, num_instances, first_index,
		vertex_offset, first_instance)
}

// C.SDL_DrawGPUPrimitives [official documentation](https://wiki.libsdl.org/SDL3/SDL_DrawGPUPrimitives)
fn C.SDL_DrawGPUPrimitives(render_pass &GPURenderPass, num_vertices u32, num_instances u32, first_vertex u32, first_instance u32)

// draw_gpu_primitives draws data using bound graphics state.
//
// You must not call this function before binding a graphics pipeline.
//
// Note that the `first_vertex` and `first_instance` parameters are NOT
// compatible with built-in vertex/instance ID variables in shaders (for
// example, SV_VertexID); GPU APIs and shader languages do not define these
// built-in variables consistently, so if your shader depends on them, the
// only way to keep behavior consistent and portable is to always pass 0 for
// the correlating parameter in the draw calls.
//
// `render_pass` render_pass a render pass handle.
// `num_vertices` num_vertices the number of vertices to draw.
// `num_instances` num_instances the number of instances that will be drawn.
// `first_vertex` first_vertex the index of the first vertex to draw.
// `first_instance` first_instance the ID of the first instance to draw.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn draw_gpu_primitives(render_pass &GPURenderPass, num_vertices u32, num_instances u32, first_vertex u32, first_instance u32) {
	C.SDL_DrawGPUPrimitives(render_pass, num_vertices, num_instances, first_vertex, first_instance)
}

// C.SDL_DrawGPUPrimitivesIndirect [official documentation](https://wiki.libsdl.org/SDL3/SDL_DrawGPUPrimitivesIndirect)
fn C.SDL_DrawGPUPrimitivesIndirect(render_pass &GPURenderPass, buffer &GPUBuffer, offset u32, draw_count u32)

// draw_gpu_primitives_indirect draws data using bound graphics state and with draw parameters set from a
// buffer.
//
// The buffer must consist of tightly-packed draw parameter sets that each
// match the layout of SDL_GPUIndirectDrawCommand. You must not call this
// function before binding a graphics pipeline.
//
// `render_pass` render_pass a render pass handle.
// `buffer` buffer a buffer containing draw parameters.
// `offset` offset the offset to start reading from the draw buffer.
// `draw_count` draw_count the number of draw parameter sets that should be read
//                   from the draw buffer.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn draw_gpu_primitives_indirect(render_pass &GPURenderPass, buffer &GPUBuffer, offset u32, draw_count u32) {
	C.SDL_DrawGPUPrimitivesIndirect(render_pass, buffer, offset, draw_count)
}

// C.SDL_DrawGPUIndexedPrimitivesIndirect [official documentation](https://wiki.libsdl.org/SDL3/SDL_DrawGPUIndexedPrimitivesIndirect)
fn C.SDL_DrawGPUIndexedPrimitivesIndirect(render_pass &GPURenderPass, buffer &GPUBuffer, offset u32, draw_count u32)

// draw_gpu_indexed_primitives_indirect draws data using bound graphics state with an index buffer enabled and with
// draw parameters set from a buffer.
//
// The buffer must consist of tightly-packed draw parameter sets that each
// match the layout of SDL_GPUIndexedIndirectDrawCommand. You must not call
// this function before binding a graphics pipeline.
//
// `render_pass` render_pass a render pass handle.
// `buffer` buffer a buffer containing draw parameters.
// `offset` offset the offset to start reading from the draw buffer.
// `draw_count` draw_count the number of draw parameter sets that should be read
//                   from the draw buffer.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn draw_gpu_indexed_primitives_indirect(render_pass &GPURenderPass, buffer &GPUBuffer, offset u32, draw_count u32) {
	C.SDL_DrawGPUIndexedPrimitivesIndirect(render_pass, buffer, offset, draw_count)
}

// C.SDL_EndGPURenderPass [official documentation](https://wiki.libsdl.org/SDL3/SDL_EndGPURenderPass)
fn C.SDL_EndGPURenderPass(render_pass &GPURenderPass)

// end_gpu_render_pass ends the given render pass.
//
// All bound graphics state on the render pass command buffer is unset. The
// render pass handle is now invalid.
//
// `render_pass` render_pass a render pass handle.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn end_gpu_render_pass(render_pass &GPURenderPass) {
	C.SDL_EndGPURenderPass(render_pass)
}

// C.SDL_BeginGPUComputePass [official documentation](https://wiki.libsdl.org/SDL3/SDL_BeginGPUComputePass)
fn C.SDL_BeginGPUComputePass(command_buffer &GPUCommandBuffer, const_storage_texture_bindings &GPUStorageTextureReadWriteBinding, num_storage_texture_bindings u32, const_storage_buffer_bindings &GPUStorageBufferReadWriteBinding, num_storage_buffer_bindings u32) &GPUComputePass

// begin_gpu_compute_pass begins a compute pass on a command buffer.
//
// A compute pass is defined by a set of texture subresources and buffers that
// may be written to by compute pipelines. These textures and buffers must
// have been created with the COMPUTE_STORAGE_WRITE bit or the
// COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE bit. If you do not create a texture
// with COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE, you must not read from the
// texture in the compute pass. All operations related to compute pipelines
// must take place inside of a compute pass. You must not begin another
// compute pass, or a render pass or copy pass before ending the compute pass.
//
// A VERY IMPORTANT NOTE - Reads and writes in compute passes are NOT
// implicitly synchronized. This means you may cause data races by both
// reading and writing a resource region in a compute pass, or by writing
// multiple times to a resource region. If your compute work depends on
// reading the completed output from a previous dispatch, you MUST end the
// current compute pass and begin a new one before you can safely access the
// data. Otherwise you will receive unexpected results. Reading and writing a
// texture in the same compute pass is only supported by specific texture
// formats. Make sure you check the format support!
//
// `command_buffer` command_buffer a command buffer.
// `storage_texture_bindings` storage_texture_bindings an array of writeable storage texture
//                                 binding structs.
// `num_storage_texture_bindings` num_storage_texture_bindings the number of storage textures to bind
//                                     from the array.
// `storage_buffer_bindings` storage_buffer_bindings an array of writeable storage buffer binding
//                                structs.
// `num_storage_buffer_bindings` num_storage_buffer_bindings the number of storage buffers to bind
//                                    from the array.
// returns a compute pass handle.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: end_gpu_compute_pass (SDL_EndGPUComputePass)
pub fn begin_gpu_compute_pass(command_buffer &GPUCommandBuffer, const_storage_texture_bindings &GPUStorageTextureReadWriteBinding, num_storage_texture_bindings u32, const_storage_buffer_bindings &GPUStorageBufferReadWriteBinding, num_storage_buffer_bindings u32) &GPUComputePass {
	return C.SDL_BeginGPUComputePass(command_buffer, const_storage_texture_bindings, num_storage_texture_bindings,
		const_storage_buffer_bindings, num_storage_buffer_bindings)
}

// C.SDL_BindGPUComputePipeline [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUComputePipeline)
fn C.SDL_BindGPUComputePipeline(compute_pass &GPUComputePass, compute_pipeline &GPUComputePipeline)

// bind_gpu_compute_pipeline binds a compute pipeline on a command buffer for use in compute dispatch.
//
// `compute_pass` compute_pass a compute pass handle.
// `compute_pipeline` compute_pipeline a compute pipeline to bind.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_compute_pipeline(compute_pass &GPUComputePass, compute_pipeline &GPUComputePipeline) {
	C.SDL_BindGPUComputePipeline(compute_pass, compute_pipeline)
}

// C.SDL_BindGPUComputeSamplers [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUComputeSamplers)
fn C.SDL_BindGPUComputeSamplers(compute_pass &GPUComputePass, first_slot u32, const_texture_sampler_bindings &GPUTextureSamplerBinding, num_bindings u32)

// bind_gpu_compute_samplers binds texture-sampler pairs for use on the compute shader.
//
// The textures must have been created with SDL_GPU_TEXTUREUSAGE_SAMPLER.
//
// `compute_pass` compute_pass a compute pass handle.
// `first_slot` first_slot the compute sampler slot to begin binding from.
// `texture_sampler_bindings` texture_sampler_bindings an array of texture-sampler binding
//                                 structs.
// `num_bindings` num_bindings the number of texture-sampler bindings to bind from the
//                     array.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_compute_samplers(compute_pass &GPUComputePass, first_slot u32, const_texture_sampler_bindings &GPUTextureSamplerBinding, num_bindings u32) {
	C.SDL_BindGPUComputeSamplers(compute_pass, first_slot, const_texture_sampler_bindings,
		num_bindings)
}

// C.SDL_BindGPUComputeStorageTextures [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUComputeStorageTextures)
fn C.SDL_BindGPUComputeStorageTextures(compute_pass &GPUComputePass, first_slot u32, const_storage_textures &&C.SDL_GPUTexture, num_bindings u32)

// bind_gpu_compute_storage_textures binds storage textures as readonly for use on the compute pipeline.
//
// These textures must have been created with
// SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_READ.
//
// `compute_pass` compute_pass a compute pass handle.
// `first_slot` first_slot the compute storage texture slot to begin binding from.
// `storage_textures` storage_textures an array of storage textures.
// `num_bindings` num_bindings the number of storage textures to bind from the array.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_compute_storage_textures(compute_pass &GPUComputePass, first_slot u32, const_storage_textures &&C.SDL_GPUTexture, num_bindings u32) {
	C.SDL_BindGPUComputeStorageTextures(compute_pass, first_slot, const_storage_textures,
		num_bindings)
}

// C.SDL_BindGPUComputeStorageBuffers [official documentation](https://wiki.libsdl.org/SDL3/SDL_BindGPUComputeStorageBuffers)
fn C.SDL_BindGPUComputeStorageBuffers(compute_pass &GPUComputePass, first_slot u32, const_storage_buffers &&C.SDL_GPUBuffer, num_bindings u32)

// bind_gpu_compute_storage_buffers binds storage buffers as readonly for use on the compute pipeline.
//
// These buffers must have been created with
// SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_READ.
//
// `compute_pass` compute_pass a compute pass handle.
// `first_slot` first_slot the compute storage buffer slot to begin binding from.
// `storage_buffers` storage_buffers an array of storage buffer binding structs.
// `num_bindings` num_bindings the number of storage buffers to bind from the array.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn bind_gpu_compute_storage_buffers(compute_pass &GPUComputePass, first_slot u32, const_storage_buffers &&C.SDL_GPUBuffer, num_bindings u32) {
	C.SDL_BindGPUComputeStorageBuffers(compute_pass, first_slot, const_storage_buffers,
		num_bindings)
}

// C.SDL_DispatchGPUCompute [official documentation](https://wiki.libsdl.org/SDL3/SDL_DispatchGPUCompute)
fn C.SDL_DispatchGPUCompute(compute_pass &GPUComputePass, groupcount_x u32, groupcount_y u32, groupcount_z u32)

// dispatch_gpu_compute dispatches compute work.
//
// You must not call this function before binding a compute pipeline.
//
// A VERY IMPORTANT NOTE If you dispatch multiple times in a compute pass, and
// the dispatches write to the same resource region as each other, there is no
// guarantee of which order the writes will occur. If the write order matters,
// you MUST end the compute pass and begin another one.
//
// `compute_pass` compute_pass a compute pass handle.
// `groupcount_x` groupcount_x number of local workgroups to dispatch in the X
//                     dimension.
// `groupcount_y` groupcount_y number of local workgroups to dispatch in the Y
//                     dimension.
// `groupcount_z` groupcount_z number of local workgroups to dispatch in the Z
//                     dimension.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn dispatch_gpu_compute(compute_pass &GPUComputePass, groupcount_x u32, groupcount_y u32, groupcount_z u32) {
	C.SDL_DispatchGPUCompute(compute_pass, groupcount_x, groupcount_y, groupcount_z)
}

// C.SDL_DispatchGPUComputeIndirect [official documentation](https://wiki.libsdl.org/SDL3/SDL_DispatchGPUComputeIndirect)
fn C.SDL_DispatchGPUComputeIndirect(compute_pass &GPUComputePass, buffer &GPUBuffer, offset u32)

// dispatch_gpu_compute_indirect dispatches compute work with parameters set from a buffer.
//
// The buffer layout should match the layout of
// SDL_GPUIndirectDispatchCommand. You must not call this function before
// binding a compute pipeline.
//
// A VERY IMPORTANT NOTE If you dispatch multiple times in a compute pass, and
// the dispatches write to the same resource region as each other, there is no
// guarantee of which order the writes will occur. If the write order matters,
// you MUST end the compute pass and begin another one.
//
// `compute_pass` compute_pass a compute pass handle.
// `buffer` buffer a buffer containing dispatch parameters.
// `offset` offset the offset to start reading from the dispatch buffer.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn dispatch_gpu_compute_indirect(compute_pass &GPUComputePass, buffer &GPUBuffer, offset u32) {
	C.SDL_DispatchGPUComputeIndirect(compute_pass, buffer, offset)
}

// C.SDL_EndGPUComputePass [official documentation](https://wiki.libsdl.org/SDL3/SDL_EndGPUComputePass)
fn C.SDL_EndGPUComputePass(compute_pass &GPUComputePass)

// end_gpu_compute_pass ends the current compute pass.
//
// All bound compute state on the command buffer is unset. The compute pass
// handle is now invalid.
//
// `compute_pass` compute_pass a compute pass handle.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn end_gpu_compute_pass(compute_pass &GPUComputePass) {
	C.SDL_EndGPUComputePass(compute_pass)
}

// C.SDL_MapGPUTransferBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_MapGPUTransferBuffer)
fn C.SDL_MapGPUTransferBuffer(device &GPUDevice, transfer_buffer &GPUTransferBuffer, cycle bool) voidptr

// map_gpu_transfer_buffer maps a transfer buffer into application address space.
//
// You must unmap the transfer buffer before encoding upload commands.
//
// `device` device a GPU context.
// `transfer_buffer` transfer_buffer a transfer buffer.
// `cycle` cycle if true, cycles the transfer buffer if it is already bound.
// returns the address of the mapped transfer buffer memory, or NULL on
//          failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn map_gpu_transfer_buffer(device &GPUDevice, transfer_buffer &GPUTransferBuffer, cycle bool) voidptr {
	return C.SDL_MapGPUTransferBuffer(device, transfer_buffer, cycle)
}

// C.SDL_UnmapGPUTransferBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnmapGPUTransferBuffer)
fn C.SDL_UnmapGPUTransferBuffer(device &GPUDevice, transfer_buffer &GPUTransferBuffer)

// unmap_gpu_transfer_buffer unmaps a previously mapped transfer buffer.
//
// `device` device a GPU context.
// `transfer_buffer` transfer_buffer a previously mapped transfer buffer.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn unmap_gpu_transfer_buffer(device &GPUDevice, transfer_buffer &GPUTransferBuffer) {
	C.SDL_UnmapGPUTransferBuffer(device, transfer_buffer)
}

// C.SDL_BeginGPUCopyPass [official documentation](https://wiki.libsdl.org/SDL3/SDL_BeginGPUCopyPass)
fn C.SDL_BeginGPUCopyPass(command_buffer &GPUCommandBuffer) &GPUCopyPass

// begin_gpu_copy_pass begins a copy pass on a command buffer.
//
// All operations related to copying to or from buffers or textures take place
// inside a copy pass. You must not begin another copy pass, or a render pass
// or compute pass before ending the copy pass.
//
// `command_buffer` command_buffer a command buffer.
// returns a copy pass handle.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn begin_gpu_copy_pass(command_buffer &GPUCommandBuffer) &GPUCopyPass {
	return C.SDL_BeginGPUCopyPass(command_buffer)
}

// C.SDL_UploadToGPUTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_UploadToGPUTexture)
fn C.SDL_UploadToGPUTexture(copy_pass &GPUCopyPass, const_source &GPUTextureTransferInfo, const_destination &GPUTextureRegion, cycle bool)

// upload_to_gpu_texture uploads data from a transfer buffer to a texture.
//
// The upload occurs on the GPU timeline. You may assume that the upload has
// finished in subsequent commands.
//
// You must align the data in the transfer buffer to a multiple of the texel
// size of the texture format.
//
// `copy_pass` copy_pass a copy pass handle.
// `source` source the source transfer buffer with image layout information.
// `destination` destination the destination texture region.
// `cycle` cycle if true, cycles the texture if the texture is bound, otherwise
//              overwrites the data.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn upload_to_gpu_texture(copy_pass &GPUCopyPass, const_source &GPUTextureTransferInfo, const_destination &GPUTextureRegion, cycle bool) {
	C.SDL_UploadToGPUTexture(copy_pass, const_source, const_destination, cycle)
}

// C.SDL_UploadToGPUBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_UploadToGPUBuffer)
fn C.SDL_UploadToGPUBuffer(copy_pass &GPUCopyPass, const_source &GPUTransferBufferLocation, const_destination &GPUBufferRegion, cycle bool)

// upload_to_gpu_buffer uploads data from a transfer buffer to a buffer.
//
// The upload occurs on the GPU timeline. You may assume that the upload has
// finished in subsequent commands.
//
// `copy_pass` copy_pass a copy pass handle.
// `source` source the source transfer buffer with offset.
// `destination` destination the destination buffer with offset and size.
// `cycle` cycle if true, cycles the buffer if it is already bound, otherwise
//              overwrites the data.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn upload_to_gpu_buffer(copy_pass &GPUCopyPass, const_source &GPUTransferBufferLocation, const_destination &GPUBufferRegion, cycle bool) {
	C.SDL_UploadToGPUBuffer(copy_pass, const_source, const_destination, cycle)
}

// C.SDL_CopyGPUTextureToTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_CopyGPUTextureToTexture)
fn C.SDL_CopyGPUTextureToTexture(copy_pass &GPUCopyPass, const_source &GPUTextureLocation, const_destination &GPUTextureLocation, w u32, h u32, d u32, cycle bool)

// copy_gpu_texture_to_texture performs a texture-to-texture copy.
//
// This copy occurs on the GPU timeline. You may assume the copy has finished
// in subsequent commands.
//
// `copy_pass` copy_pass a copy pass handle.
// `source` source a source texture region.
// `destination` destination a destination texture region.
// `w` w the width of the region to copy.
// `h` h the height of the region to copy.
// `d` d the depth of the region to copy.
// `cycle` cycle if true, cycles the destination texture if the destination
//              texture is bound, otherwise overwrites the data.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn copy_gpu_texture_to_texture(copy_pass &GPUCopyPass, const_source &GPUTextureLocation, const_destination &GPUTextureLocation, w u32, h u32, d u32, cycle bool) {
	C.SDL_CopyGPUTextureToTexture(copy_pass, const_source, const_destination, w, h, d,
		cycle)
}

// C.SDL_CopyGPUBufferToBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_CopyGPUBufferToBuffer)
fn C.SDL_CopyGPUBufferToBuffer(copy_pass &GPUCopyPass, const_source &GPUBufferLocation, const_destination &GPUBufferLocation, size u32, cycle bool)

// copy_gpu_buffer_to_buffer performs a buffer-to-buffer copy.
//
// This copy occurs on the GPU timeline. You may assume the copy has finished
// in subsequent commands.
//
// `copy_pass` copy_pass a copy pass handle.
// `source` source the buffer and offset to copy from.
// `destination` destination the buffer and offset to copy to.
// `size` size the length of the buffer to copy.
// `cycle` cycle if true, cycles the destination buffer if it is already bound,
//              otherwise overwrites the data.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn copy_gpu_buffer_to_buffer(copy_pass &GPUCopyPass, const_source &GPUBufferLocation, const_destination &GPUBufferLocation, size u32, cycle bool) {
	C.SDL_CopyGPUBufferToBuffer(copy_pass, const_source, const_destination, size, cycle)
}

// C.SDL_DownloadFromGPUTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_DownloadFromGPUTexture)
fn C.SDL_DownloadFromGPUTexture(copy_pass &GPUCopyPass, const_source &GPUTextureRegion, const_destination &GPUTextureTransferInfo)

// download_from_gpu_texture copies data from a texture to a transfer buffer on the GPU timeline.
//
// This data is not guaranteed to be copied until the command buffer fence is
// signaled.
//
// `copy_pass` copy_pass a copy pass handle.
// `source` source the source texture region.
// `destination` destination the destination transfer buffer with image layout
//                    information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn download_from_gpu_texture(copy_pass &GPUCopyPass, const_source &GPUTextureRegion, const_destination &GPUTextureTransferInfo) {
	C.SDL_DownloadFromGPUTexture(copy_pass, const_source, const_destination)
}

// C.SDL_DownloadFromGPUBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_DownloadFromGPUBuffer)
fn C.SDL_DownloadFromGPUBuffer(copy_pass &GPUCopyPass, const_source &GPUBufferRegion, const_destination &GPUTransferBufferLocation)

// download_from_gpu_buffer copies data from a buffer to a transfer buffer on the GPU timeline.
//
// This data is not guaranteed to be copied until the command buffer fence is
// signaled.
//
// `copy_pass` copy_pass a copy pass handle.
// `source` source the source buffer with offset and size.
// `destination` destination the destination transfer buffer with offset.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn download_from_gpu_buffer(copy_pass &GPUCopyPass, const_source &GPUBufferRegion, const_destination &GPUTransferBufferLocation) {
	C.SDL_DownloadFromGPUBuffer(copy_pass, const_source, const_destination)
}

// C.SDL_EndGPUCopyPass [official documentation](https://wiki.libsdl.org/SDL3/SDL_EndGPUCopyPass)
fn C.SDL_EndGPUCopyPass(copy_pass &GPUCopyPass)

// end_gpu_copy_pass ends the current copy pass.
//
// `copy_pass` copy_pass a copy pass handle.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn end_gpu_copy_pass(copy_pass &GPUCopyPass) {
	C.SDL_EndGPUCopyPass(copy_pass)
}

// C.SDL_GenerateMipmapsForGPUTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_GenerateMipmapsForGPUTexture)
fn C.SDL_GenerateMipmapsForGPUTexture(command_buffer &GPUCommandBuffer, texture &GPUTexture)

// generate_mipmaps_for_gpu_texture generates mipmaps for the given texture.
//
// This function must not be called inside of any pass.
//
// `command_buffer` command_buffer a command_buffer.
// `texture` texture a texture with more than 1 mip level.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn generate_mipmaps_for_gpu_texture(command_buffer &GPUCommandBuffer, texture &GPUTexture) {
	C.SDL_GenerateMipmapsForGPUTexture(command_buffer, texture)
}

// C.SDL_BlitGPUTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_BlitGPUTexture)
fn C.SDL_BlitGPUTexture(command_buffer &GPUCommandBuffer, const_info &GPUBlitInfo)

// blit_gpu_texture blits from a source texture region to a destination texture region.
//
// This function must not be called inside of any pass.
//
// `command_buffer` command_buffer a command buffer.
// `info` info the blit info struct containing the blit parameters.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn blit_gpu_texture(command_buffer &GPUCommandBuffer, const_info &GPUBlitInfo) {
	C.SDL_BlitGPUTexture(command_buffer, const_info)
}

// C.SDL_WindowSupportsGPUSwapchainComposition [official documentation](https://wiki.libsdl.org/SDL3/SDL_WindowSupportsGPUSwapchainComposition)
fn C.SDL_WindowSupportsGPUSwapchainComposition(device &GPUDevice, window &Window, swapchain_composition GPUSwapchainComposition) bool

// window_supports_gpu_swapchain_composition determines whether a swapchain composition is supported by the window.
//
// The window must be claimed before calling this function.
//
// `device` device a GPU context.
// `window` window an SDL_Window.
// `swapchain_composition` swapchain_composition the swapchain composition to check.
// returns true if supported, false if unsupported.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: claim_window_for_gpu_device (SDL_ClaimWindowForGPUDevice)
pub fn window_supports_gpu_swapchain_composition(device &GPUDevice, window &Window, swapchain_composition GPUSwapchainComposition) bool {
	return C.SDL_WindowSupportsGPUSwapchainComposition(device, window, swapchain_composition)
}

// C.SDL_WindowSupportsGPUPresentMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_WindowSupportsGPUPresentMode)
fn C.SDL_WindowSupportsGPUPresentMode(device &GPUDevice, window &Window, present_mode GPUPresentMode) bool

// window_supports_gpu_present_mode determines whether a presentation mode is supported by the window.
//
// The window must be claimed before calling this function.
//
// `device` device a GPU context.
// `window` window an SDL_Window.
// `present_mode` present_mode the presentation mode to check.
// returns true if supported, false if unsupported.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: claim_window_for_gpu_device (SDL_ClaimWindowForGPUDevice)
pub fn window_supports_gpu_present_mode(device &GPUDevice, window &Window, present_mode GPUPresentMode) bool {
	return C.SDL_WindowSupportsGPUPresentMode(device, window, present_mode)
}

// C.SDL_ClaimWindowForGPUDevice [official documentation](https://wiki.libsdl.org/SDL3/SDL_ClaimWindowForGPUDevice)
fn C.SDL_ClaimWindowForGPUDevice(device &GPUDevice, window &Window) bool

// claim_window_for_gpu_device claims a window, creating a swapchain structure for it.
//
// This must be called before SDL_AcquireGPUSwapchainTexture is called using
// the window. You should only call this function from the thread that created
// the window.
//
// The swapchain will be created with SDL_GPU_SWAPCHAINCOMPOSITION_SDR and
// SDL_GPU_PRESENTMODE_VSYNC. If you want to have different swapchain
// parameters, you must call SDL_SetGPUSwapchainParameters after claiming the
// window.
//
// `device` device a GPU context.
// `window` window an SDL_Window.
// returns true on success, or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called from the thread that
//               created the window.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: wait_and_acquire_gpu_swapchain_texture (SDL_WaitAndAcquireGPUSwapchainTexture)
// See also: release_window_from_gpu_device (SDL_ReleaseWindowFromGPUDevice)
// See also: window_supports_gpu_present_mode (SDL_WindowSupportsGPUPresentMode)
// See also: window_supports_gpu_swapchain_composition (SDL_WindowSupportsGPUSwapchainComposition)
pub fn claim_window_for_gpu_device(device &GPUDevice, window &Window) bool {
	return C.SDL_ClaimWindowForGPUDevice(device, window)
}

// C.SDL_ReleaseWindowFromGPUDevice [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReleaseWindowFromGPUDevice)
fn C.SDL_ReleaseWindowFromGPUDevice(device &GPUDevice, window &Window)

// release_window_from_gpu_device unclaims a window, destroying its swapchain structure.
//
// `device` device a GPU context.
// `window` window an SDL_Window that has been claimed.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: claim_window_for_gpu_device (SDL_ClaimWindowForGPUDevice)
pub fn release_window_from_gpu_device(device &GPUDevice, window &Window) {
	C.SDL_ReleaseWindowFromGPUDevice(device, window)
}

// C.SDL_SetGPUSwapchainParameters [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGPUSwapchainParameters)
fn C.SDL_SetGPUSwapchainParameters(device &GPUDevice, window &Window, swapchain_composition GPUSwapchainComposition, present_mode GPUPresentMode) bool

// set_gpu_swapchain_parameters changes the swapchain parameters for the given claimed window.
//
// This function will fail if the requested present mode or swapchain
// composition are unsupported by the device. Check if the parameters are
// supported via SDL_WindowSupportsGPUPresentMode /
// SDL_WindowSupportsGPUSwapchainComposition prior to calling this function.
//
// SDL_GPU_PRESENTMODE_VSYNC and SDL_GPU_SWAPCHAINCOMPOSITION_SDR are always
// supported.
//
// `device` device a GPU context.
// `window` window an SDL_Window that has been claimed.
// `swapchain_composition` swapchain_composition the desired composition of the swapchain.
// `present_mode` present_mode the desired present mode for the swapchain.
// returns true if successful, false on error; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: window_supports_gpu_present_mode (SDL_WindowSupportsGPUPresentMode)
// See also: window_supports_gpu_swapchain_composition (SDL_WindowSupportsGPUSwapchainComposition)
pub fn set_gpu_swapchain_parameters(device &GPUDevice, window &Window, swapchain_composition GPUSwapchainComposition, present_mode GPUPresentMode) bool {
	return C.SDL_SetGPUSwapchainParameters(device, window, swapchain_composition, present_mode)
}

// C.SDL_SetGPUAllowedFramesInFlight [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGPUAllowedFramesInFlight)
fn C.SDL_SetGPUAllowedFramesInFlight(device &GPUDevice, allowed_frames_in_flight u32) bool

// set_gpu_allowed_frames_in_flight configures the maximum allowed number of frames in flight.
//
// The default value when the device is created is 2. This means that after
// you have submitted 2 frames for presentation, if the GPU has not finished
// working on the first frame, SDL_AcquireGPUSwapchainTexture() will fill the
// swapchain texture pointer with NULL, and
// SDL_WaitAndAcquireGPUSwapchainTexture() will block.
//
// Higher values increase throughput at the expense of visual latency. Lower
// values decrease visual latency at the expense of throughput.
//
// Note that calling this function will stall and flush the command queue to
// prevent synchronization issues.
//
// The minimum value of allowed frames in flight is 1, and the maximum is 3.
//
// `device` device a GPU context.
// `allowed_frames_in_flight` allowed_frames_in_flight the maximum number of frames that can be
//                                 pending on the GPU.
// returns true if successful, false on error; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_gpu_allowed_frames_in_flight(device &GPUDevice, allowed_frames_in_flight u32) bool {
	return C.SDL_SetGPUAllowedFramesInFlight(device, allowed_frames_in_flight)
}

// C.SDL_GetGPUSwapchainTextureFormat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGPUSwapchainTextureFormat)
fn C.SDL_GetGPUSwapchainTextureFormat(device &GPUDevice, window &Window) GPUTextureFormat

// get_gpu_swapchain_texture_format obtains the texture format of the swapchain for the given window.
//
// Note that this format can change if the swapchain parameters change.
//
// `device` device a GPU context.
// `window` window an SDL_Window that has been claimed.
// returns the texture format of the swapchain.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gpu_swapchain_texture_format(device &GPUDevice, window &Window) GPUTextureFormat {
	return C.SDL_GetGPUSwapchainTextureFormat(device, window)
}

// C.SDL_AcquireGPUSwapchainTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_AcquireGPUSwapchainTexture)
fn C.SDL_AcquireGPUSwapchainTexture(command_buffer &GPUCommandBuffer, window &Window, swapchain_texture &&GPUTexture, swapchain_texture_width &u32, swapchain_texture_height &u32) bool

// acquire_gpu_swapchain_texture acquires a texture to use in presentation.
//
// When a swapchain texture is acquired on a command buffer, it will
// automatically be submitted for presentation when the command buffer is
// submitted. The swapchain texture should only be referenced by the command
// buffer used to acquire it.
//
// This function will fill the swapchain texture handle with NULL if too many
// frames are in flight. This is not an error.
//
// If you use this function, it is possible to create a situation where many
// command buffers are allocated while the rendering context waits for the GPU
// to catch up, which will cause memory usage to grow. You should use
// SDL_WaitAndAcquireGPUSwapchainTexture() unless you know what you are doing
// with timing.
//
// The swapchain texture is managed by the implementation and must not be
// freed by the user. You MUST NOT call this function from any thread other
// than the one that created the window.
//
// `command_buffer` command_buffer a command buffer.
// `window` window a window that has been claimed.
// `swapchain_texture` swapchain_texture a pointer filled in with a swapchain texture
//                          handle.
// `swapchain_texture_width` swapchain_texture_width a pointer filled in with the swapchain
//                                texture width, may be NULL.
// `swapchain_texture_height` swapchain_texture_height a pointer filled in with the swapchain
//                                 texture height, may be NULL.
// returns true on success, false on error; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called from the thread that
//               created the window.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: claim_window_for_gpu_device (SDL_ClaimWindowForGPUDevice)
// See also: submit_gpu_command_buffer (SDL_SubmitGPUCommandBuffer)
// See also: submit_gpu_command_buffer_and_acquire_fence (SDL_SubmitGPUCommandBufferAndAcquireFence)
// See also: cancel_gpu_command_buffer (SDL_CancelGPUCommandBuffer)
// See also: get_window_size_in_pixels (SDL_GetWindowSizeInPixels)
// See also: wait_for_gpu_swapchain (SDL_WaitForGPUSwapchain)
// See also: wait_and_acquire_gpu_swapchain_texture (SDL_WaitAndAcquireGPUSwapchainTexture)
// See also: set_gpu_allowed_frames_in_flight (SDL_SetGPUAllowedFramesInFlight)
pub fn acquire_gpu_swapchain_texture(command_buffer &GPUCommandBuffer, window &Window, swapchain_texture &&GPUTexture, swapchain_texture_width &u32, swapchain_texture_height &u32) bool {
	return C.SDL_AcquireGPUSwapchainTexture(command_buffer, window, swapchain_texture,
		swapchain_texture_width, swapchain_texture_height)
}

// C.SDL_WaitForGPUSwapchain [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitForGPUSwapchain)
fn C.SDL_WaitForGPUSwapchain(device &GPUDevice, window &Window) bool

// wait_for_gpu_swapchain blocks the thread until a swapchain texture is available to be acquired.
//
// `device` device a GPU context.
// `window` window a window that has been claimed.
// returns true on success, false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called from the thread that
//               created the window.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: acquire_gpu_swapchain_texture (SDL_AcquireGPUSwapchainTexture)
// See also: wait_and_acquire_gpu_swapchain_texture (SDL_WaitAndAcquireGPUSwapchainTexture)
// See also: set_gpu_allowed_frames_in_flight (SDL_SetGPUAllowedFramesInFlight)
pub fn wait_for_gpu_swapchain(device &GPUDevice, window &Window) bool {
	return C.SDL_WaitForGPUSwapchain(device, window)
}

// C.SDL_WaitAndAcquireGPUSwapchainTexture [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitAndAcquireGPUSwapchainTexture)
fn C.SDL_WaitAndAcquireGPUSwapchainTexture(command_buffer &GPUCommandBuffer, window &Window, swapchain_texture &&GPUTexture, swapchain_texture_width &u32, swapchain_texture_height &u32) bool

// wait_and_acquire_gpu_swapchain_texture blocks the thread until a swapchain texture is available to be acquired,
// and then acquires it.
//
// When a swapchain texture is acquired on a command buffer, it will
// automatically be submitted for presentation when the command buffer is
// submitted. The swapchain texture should only be referenced by the command
// buffer used to acquire it. It is an error to call
// SDL_CancelGPUCommandBuffer() after a swapchain texture is acquired.
//
// This function can fill the swapchain texture handle with NULL in certain
// cases, for example if the window is minimized. This is not an error. You
// should always make sure to check whether the pointer is NULL before
// actually using it.
//
// The swapchain texture is managed by the implementation and must not be
// freed by the user. You MUST NOT call this function from any thread other
// than the one that created the window.
//
// `command_buffer` command_buffer a command buffer.
// `window` window a window that has been claimed.
// `swapchain_texture` swapchain_texture a pointer filled in with a swapchain texture
//                          handle.
// `swapchain_texture_width` swapchain_texture_width a pointer filled in with the swapchain
//                                texture width, may be NULL.
// `swapchain_texture_height` swapchain_texture_height a pointer filled in with the swapchain
//                                 texture height, may be NULL.
// returns true on success, false on error; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called from the thread that
//               created the window.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: submit_gpu_command_buffer (SDL_SubmitGPUCommandBuffer)
// See also: submit_gpu_command_buffer_and_acquire_fence (SDL_SubmitGPUCommandBufferAndAcquireFence)
pub fn wait_and_acquire_gpu_swapchain_texture(command_buffer &GPUCommandBuffer, window &Window, swapchain_texture &&GPUTexture, swapchain_texture_width &u32, swapchain_texture_height &u32) bool {
	return C.SDL_WaitAndAcquireGPUSwapchainTexture(command_buffer, window, swapchain_texture,
		swapchain_texture_width, swapchain_texture_height)
}

// C.SDL_SubmitGPUCommandBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_SubmitGPUCommandBuffer)
fn C.SDL_SubmitGPUCommandBuffer(command_buffer &GPUCommandBuffer) bool

// submit_gpu_command_buffer submits a command buffer so its commands can be processed on the GPU.
//
// It is invalid to use the command buffer after this is called.
//
// This must be called from the thread the command buffer was acquired on.
//
// All commands in the submission are guaranteed to begin executing before any
// command in a subsequent submission begins executing.
//
// `command_buffer` command_buffer a command buffer.
// returns true on success, false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: acquire_gpu_command_buffer (SDL_AcquireGPUCommandBuffer)
// See also: wait_and_acquire_gpu_swapchain_texture (SDL_WaitAndAcquireGPUSwapchainTexture)
// See also: acquire_gpu_swapchain_texture (SDL_AcquireGPUSwapchainTexture)
// See also: submit_gpu_command_buffer_and_acquire_fence (SDL_SubmitGPUCommandBufferAndAcquireFence)
pub fn submit_gpu_command_buffer(command_buffer &GPUCommandBuffer) bool {
	return C.SDL_SubmitGPUCommandBuffer(command_buffer)
}

// C.SDL_SubmitGPUCommandBufferAndAcquireFence [official documentation](https://wiki.libsdl.org/SDL3/SDL_SubmitGPUCommandBufferAndAcquireFence)
fn C.SDL_SubmitGPUCommandBufferAndAcquireFence(command_buffer &GPUCommandBuffer) &GPUFence

// submit_gpu_command_buffer_and_acquire_fence submits a command buffer so its commands can be processed on the GPU, and
// acquires a fence associated with the command buffer.
//
// You must release this fence when it is no longer needed or it will cause a
// leak. It is invalid to use the command buffer after this is called.
//
// This must be called from the thread the command buffer was acquired on.
//
// All commands in the submission are guaranteed to begin executing before any
// command in a subsequent submission begins executing.
//
// `command_buffer` command_buffer a command buffer.
// returns a fence associated with the command buffer, or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: acquire_gpu_command_buffer (SDL_AcquireGPUCommandBuffer)
// See also: wait_and_acquire_gpu_swapchain_texture (SDL_WaitAndAcquireGPUSwapchainTexture)
// See also: acquire_gpu_swapchain_texture (SDL_AcquireGPUSwapchainTexture)
// See also: submit_gpu_command_buffer (SDL_SubmitGPUCommandBuffer)
// See also: release_gpu_fence (SDL_ReleaseGPUFence)
pub fn submit_gpu_command_buffer_and_acquire_fence(command_buffer &GPUCommandBuffer) &GPUFence {
	return C.SDL_SubmitGPUCommandBufferAndAcquireFence(command_buffer)
}

// C.SDL_CancelGPUCommandBuffer [official documentation](https://wiki.libsdl.org/SDL3/SDL_CancelGPUCommandBuffer)
fn C.SDL_CancelGPUCommandBuffer(command_buffer &GPUCommandBuffer) bool

// cancel_gpu_command_buffer cancels a command buffer.
//
// None of the enqueued commands are executed.
//
// It is an error to call this function after a swapchain texture has been
// acquired.
//
// This must be called from the thread the command buffer was acquired on.
//
// You must not reference the command buffer after calling this function.
//
// `command_buffer` command_buffer a command buffer.
// returns true on success, false on error; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: wait_and_acquire_gpu_swapchain_texture (SDL_WaitAndAcquireGPUSwapchainTexture)
// See also: acquire_gpu_command_buffer (SDL_AcquireGPUCommandBuffer)
// See also: acquire_gpu_swapchain_texture (SDL_AcquireGPUSwapchainTexture)
pub fn cancel_gpu_command_buffer(command_buffer &GPUCommandBuffer) bool {
	return C.SDL_CancelGPUCommandBuffer(command_buffer)
}

// C.SDL_WaitForGPUIdle [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitForGPUIdle)
fn C.SDL_WaitForGPUIdle(device &GPUDevice) bool

// wait_for_gpu_idle blocks the thread until the GPU is completely idle.
//
// `device` device a GPU context.
// returns true on success, false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: wait_for_gpu_fences (SDL_WaitForGPUFences)
pub fn wait_for_gpu_idle(device &GPUDevice) bool {
	return C.SDL_WaitForGPUIdle(device)
}

// C.SDL_WaitForGPUFences [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitForGPUFences)
fn C.SDL_WaitForGPUFences(device &GPUDevice, wait_all bool, const_fences &&C.SDL_GPUFence, num_fences u32) bool

// wait_for_gpu_fences blocks the thread until the given fences are signaled.
//
// `device` device a GPU context.
// `wait_all` wait_all if 0, wait for any fence to be signaled, if 1, wait for all
//                 fences to be signaled.
// `fences` fences an array of fences to wait on.
// `num_fences` num_fences the number of fences in the fences array.
// returns true on success, false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: submit_gpu_command_buffer_and_acquire_fence (SDL_SubmitGPUCommandBufferAndAcquireFence)
// See also: wait_for_gpu_idle (SDL_WaitForGPUIdle)
pub fn wait_for_gpu_fences(device &GPUDevice, wait_all bool, const_fences &&C.SDL_GPUFence, num_fences u32) bool {
	return C.SDL_WaitForGPUFences(device, wait_all, const_fences, num_fences)
}

// C.SDL_QueryGPUFence [official documentation](https://wiki.libsdl.org/SDL3/SDL_QueryGPUFence)
fn C.SDL_QueryGPUFence(device &GPUDevice, fence &GPUFence) bool

// query_gpu_fence checks the status of a fence.
//
// `device` device a GPU context.
// `fence` fence a fence.
// returns true if the fence is signaled, false if it is not.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: submit_gpu_command_buffer_and_acquire_fence (SDL_SubmitGPUCommandBufferAndAcquireFence)
pub fn query_gpu_fence(device &GPUDevice, fence &GPUFence) bool {
	return C.SDL_QueryGPUFence(device, fence)
}

// C.SDL_ReleaseGPUFence [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReleaseGPUFence)
fn C.SDL_ReleaseGPUFence(device &GPUDevice, fence &GPUFence)

// release_gpu_fence releases a fence obtained from SDL_SubmitGPUCommandBufferAndAcquireFence.
//
// `device` device a GPU context.
// `fence` fence a fence.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: submit_gpu_command_buffer_and_acquire_fence (SDL_SubmitGPUCommandBufferAndAcquireFence)
pub fn release_gpu_fence(device &GPUDevice, fence &GPUFence) {
	C.SDL_ReleaseGPUFence(device, fence)
}

// C.SDL_GPUTextureFormatTexelBlockSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GPUTextureFormatTexelBlockSize)
fn C.SDL_GPUTextureFormatTexelBlockSize(format GPUTextureFormat) u32

// gpu_texture_format_texel_block_size obtains the texel block size for a texture format.
//
// `format` format the texture format you want to know the texel size of.
// returns the texel block size of the texture format.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: upload_to_gpu_texture (SDL_UploadToGPUTexture)
pub fn gpu_texture_format_texel_block_size(format GPUTextureFormat) u32 {
	return C.SDL_GPUTextureFormatTexelBlockSize(format)
}

// C.SDL_GPUTextureSupportsFormat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GPUTextureSupportsFormat)
fn C.SDL_GPUTextureSupportsFormat(device &GPUDevice, format GPUTextureFormat, typ GPUTextureType, usage GpuTextureUsageFlags) bool

// gpu_texture_supports_format determines whether a texture format is supported for a given type and
// usage.
//
// `device` device a GPU context.
// `format` format the texture format to check.
// `type` type the type of texture (2D, 3D, Cube).
// `usage` usage a bitmask of all usage scenarios to check.
// returns whether the texture format is supported for this type and usage.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn gpu_texture_supports_format(device &GPUDevice, format GPUTextureFormat, typ GPUTextureType, usage GpuTextureUsageFlags) bool {
	return C.SDL_GPUTextureSupportsFormat(device, format, typ, usage)
}

// C.SDL_GPUTextureSupportsSampleCount [official documentation](https://wiki.libsdl.org/SDL3/SDL_GPUTextureSupportsSampleCount)
fn C.SDL_GPUTextureSupportsSampleCount(device &GPUDevice, format GPUTextureFormat, sample_count GPUSampleCount) bool

// gpu_texture_supports_sample_count determines if a sample count for a texture format is supported.
//
// `device` device a GPU context.
// `format` format the texture format to check.
// `sample_count` sample_count the sample count to check.
// returns a hardware-specific version of min(preferred, possible).
//
// NOTE: This function is available since SDL 3.2.0.
pub fn gpu_texture_supports_sample_count(device &GPUDevice, format GPUTextureFormat, sample_count GPUSampleCount) bool {
	return C.SDL_GPUTextureSupportsSampleCount(device, format, sample_count)
}

// C.SDL_CalculateGPUTextureFormatSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_CalculateGPUTextureFormatSize)
fn C.SDL_CalculateGPUTextureFormatSize(format GPUTextureFormat, width u32, height u32, depth_or_layer_count u32) u32

// calculate_gpu_texture_format_size calculates the size in bytes of a texture format with dimensions.
//
// `format` format a texture format.
// `width` width width in pixels.
// `height` height height in pixels.
// `depth_or_layer_count` depth_or_layer_count depth for 3D textures or layer count otherwise.
// returns the size of a texture with this format and dimensions.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn calculate_gpu_texture_format_size(format GPUTextureFormat, width u32, height u32, depth_or_layer_count u32) u32 {
	return C.SDL_CalculateGPUTextureFormatSize(format, width, height, depth_or_layer_count)
}

// C.SDL_GDKSuspendGPU [official documentation](https://wiki.libsdl.org/SDL3/SDL_GDKSuspendGPU)
fn C.SDL_GDKSuspendGPU(device &GPUDevice)

// gdk_suspend_gpu calls this to suspend GPU operation on Xbox when you receive the
// SDL_EVENT_DID_ENTER_BACKGROUND event.
//
// Do NOT call any SDL_GPU functions after calling this function! This must
// also be called before calling SDL_GDKSuspendComplete.
//
// `device` device a GPU context.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_event_watch (SDL_AddEventWatch)
pub fn gdk_suspend_gpu(device &GPUDevice) {
	C.SDL_GDKSuspendGPU(device)
}

// C.SDL_GDKResumeGPU [official documentation](https://wiki.libsdl.org/SDL3/SDL_GDKResumeGPU)
fn C.SDL_GDKResumeGPU(device &GPUDevice)

// gdk_resume_gpu calls this to resume GPU operation on Xbox when you receive the
// SDL_EVENT_WILL_ENTER_FOREGROUND event.
//
// When resuming, this function MUST be called before calling any other
// SDL_GPU functions.
//
// `device` device a GPU context.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_event_watch (SDL_AddEventWatch)
pub fn gdk_resume_gpu(device &GPUDevice) {
	C.SDL_GDKResumeGPU(device)
}
