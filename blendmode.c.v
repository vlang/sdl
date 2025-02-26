// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_blendmode.h
//

// Blend modes decide how two colors will mix together. There are both
// standard modes for basic needs and a means to create custom modes,
// dictating what sort of math to do on what color components.

// A set of blend modes used in drawing operations.
//
// These predefined blend modes are supported everywhere.
//
// Additional values may be obtained from SDL_ComposeCustomBlendMode.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: compose_custom_blend_mode (SDL_ComposeCustomBlendMode)
pub type BlendMode = u32

pub const blendmode_none = u32(C.SDL_BLENDMODE_NONE) // 0x00000000u, no blending: dstRGBA = srcRGBA

pub const blendmode_blend = u32(C.SDL_BLENDMODE_BLEND) // 0x00000001u, alpha blending: dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA)), dstA = srcA + (dstA * (1-srcA))

pub const blendmode_blend_premultiplied = u32(C.SDL_BLENDMODE_BLEND_PREMULTIPLIED) // 0x00000010u, pre-multiplied alpha blending: dstRGBA = srcRGBA + (dstRGBA * (1-srcA))

pub const blendmode_add = u32(C.SDL_BLENDMODE_ADD) // 0x00000002u, additive blending: dstRGB = (srcRGB * srcA) + dstRGB, dstA = dstA

pub const blendmode_add_premultiplied = u32(C.SDL_BLENDMODE_ADD_PREMULTIPLIED) // 0x00000020u, pre-multiplied additive blending: dstRGB = srcRGB + dstRGB, dstA = dstA

pub const blendmode_mod = u32(C.SDL_BLENDMODE_MOD) // 0x00000004u, color modulate: dstRGB = srcRGB * dstRGB, dstA = dstA

pub const blendmode_mul = u32(C.SDL_BLENDMODE_MUL) // 0x00000008u, color multiply: dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA)), dstA = dstA

pub const blendmode_invalid = u32(C.SDL_BLENDMODE_INVALID) // 0x7FFFFFFFu

// BlendOperation is C.SDL_BlendOperation
pub enum BlendOperation {
	add          = C.SDL_BLENDOPERATION_ADD          // 0x1, dst + src: supported by all renderers
	subtract     = C.SDL_BLENDOPERATION_SUBTRACT     // 0x2, src - dst : supported by D3D, OpenGL, OpenGLES, and Vulkan
	rev_subtract = C.SDL_BLENDOPERATION_REV_SUBTRACT // 0x3, dst - src : supported by D3D, OpenGL, OpenGLES, and Vulkan
	minimum      = C.SDL_BLENDOPERATION_MINIMUM      // 0x4, min(dst, src) : supported by D3D, OpenGL, OpenGLES, and Vulkan
	maximum      = C.SDL_BLENDOPERATION_MAXIMUM      // 0x5, max(dst, src) : supported by D3D, OpenGL, OpenGLES, and Vulkan
}

// BlendFactor is C.SDL_BlendFactor
pub enum BlendFactor {
	zero                = C.SDL_BLENDFACTOR_ZERO                // 0x1, 0, 0, 0, 0
	one                 = C.SDL_BLENDFACTOR_ONE                 // 0x2, 1, 1, 1, 1
	src_color           = C.SDL_BLENDFACTOR_SRC_COLOR           // 0x3, srcR, srcG, srcB, srcA
	one_minus_src_color = C.SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR // 0x4, 1-srcR, 1-srcG, 1-srcB, 1-srcA
	src_alpha           = C.SDL_BLENDFACTOR_SRC_ALPHA           // 0x5, srcA, srcA, srcA, srcA
	one_minus_src_alpha = C.SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA // 0x6, 1-srcA, 1-srcA, 1-srcA, 1-srcA
	dst_color           = C.SDL_BLENDFACTOR_DST_COLOR           // 0x7, dstR, dstG, dstB, dstA
	one_minus_dst_color = C.SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR // 0x8, 1-dstR, 1-dstG, 1-dstB, 1-dstA
	dst_alpha           = C.SDL_BLENDFACTOR_DST_ALPHA           // 0x9, dstA, dstA, dstA, dstA
	one_minus_dst_alpha = C.SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA // 0xA, 1-dstA, 1-dstA, 1-dstA, 1-dstA
}

// C.SDL_ComposeCustomBlendMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_ComposeCustomBlendMode)
fn C.SDL_ComposeCustomBlendMode(src_color_factor BlendFactor, dst_color_factor BlendFactor, color_operation BlendOperation, src_alpha_factor BlendFactor, dst_alpha_factor BlendFactor, alpha_operation BlendOperation) BlendMode

// compose_custom_blend_mode composes a custom blend mode for renderers.
//
// The functions SDL_SetRenderDrawBlendMode and SDL_SetTextureBlendMode accept
// the SDL_BlendMode returned by this function if the renderer supports it.
//
// A blend mode controls how the pixels from a drawing operation (source) get
// combined with the pixels from the render target (destination). First, the
// components of the source and destination pixels get multiplied with their
// blend factors. Then, the blend operation takes the two products and
// calculates the result that will get stored in the render target.
//
// Expressed in pseudocode, it would look like this:
//
// ```c
// dstRGB = colorOperation(srcRGB * srcColorFactor, dstRGB * dstColorFactor);
// dstA = alphaOperation(srcA * srcAlphaFactor, dstA * dstAlphaFactor);
// ```
//
// Where the functions `colorOperation(src, dst)` and `alphaOperation(src,
// dst)` can return one of the following:
//
// - `src + dst`
// - `src - dst`
// - `dst - src`
// - `min(src, dst)`
// - `max(src, dst)`
//
// The red, green, and blue components are always multiplied with the first,
// second, and third components of the SDL_BlendFactor, respectively. The
// fourth component is not used.
//
// The alpha component is always multiplied with the fourth component of the
// SDL_BlendFactor. The other components are not used in the alpha
// calculation.
//
// Support for these blend modes varies for each renderer. To check if a
// specific SDL_BlendMode is supported, create a renderer and pass it to
// either SDL_SetRenderDrawBlendMode or SDL_SetTextureBlendMode. They will
// return with an error if the blend mode is not supported.
//
// This list describes the support of custom blend modes for each renderer.
// All renderers support the four blend modes listed in the SDL_BlendMode
// enumeration.
//
// - **direct3d**: Supports all operations with all factors. However, some
//   factors produce unexpected results with `SDL_BLENDOPERATION_MINIMUM` and
//   `SDL_BLENDOPERATION_MAXIMUM`.
// - **direct3d11**: Same as Direct3D 9.
// - **opengl**: Supports the `SDL_BLENDOPERATION_ADD` operation with all
//   factors. OpenGL versions 1.1, 1.2, and 1.3 do not work correctly here.
// - **opengles2**: Supports the `SDL_BLENDOPERATION_ADD`,
//   `SDL_BLENDOPERATION_SUBTRACT`, `SDL_BLENDOPERATION_REV_SUBTRACT`
//   operations with all factors.
// - **psp**: No custom blend mode support.
// - **software**: No custom blend mode support.
//
// Some renderers do not provide an alpha component for the default render
// target. The `SDL_BLENDFACTOR_DST_ALPHA` and
// `SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA` factors do not have an effect in this
// case.
//
// `src_color_factor` srcColorFactor the SDL_BlendFactor applied to the red, green, and
//                       blue components of the source pixels.
// `dst_color_factor` dstColorFactor the SDL_BlendFactor applied to the red, green, and
//                       blue components of the destination pixels.
// `color_operation` colorOperation the SDL_BlendOperation used to combine the red,
//                       green, and blue components of the source and
//                       destination pixels.
// `src_alpha_factor` srcAlphaFactor the SDL_BlendFactor applied to the alpha component of
//                       the source pixels.
// `dst_alpha_factor` dstAlphaFactor the SDL_BlendFactor applied to the alpha component of
//                       the destination pixels.
// `alpha_operation` alphaOperation the SDL_BlendOperation used to combine the alpha
//                       component of the source and destination pixels.
// returns an SDL_BlendMode that represents the chosen factors and
//          operations.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_render_draw_blend_mode (SDL_SetRenderDrawBlendMode)
// See also: get_render_draw_blend_mode (SDL_GetRenderDrawBlendMode)
// See also: set_texture_blend_mode (SDL_SetTextureBlendMode)
// See also: get_texture_blend_mode (SDL_GetTextureBlendMode)
pub fn compose_custom_blend_mode(src_color_factor BlendFactor, dst_color_factor BlendFactor, color_operation BlendOperation, src_alpha_factor BlendFactor, dst_alpha_factor BlendFactor, alpha_operation BlendOperation) BlendMode {
	return C.SDL_ComposeCustomBlendMode(src_color_factor, dst_color_factor, color_operation,
		src_alpha_factor, dst_alpha_factor, alpha_operation)
}
