// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_blendmode.h
//

// BlendMode is the blend mode used in SDL_RenderCopy() and drawing operations.
// BlendMode is SDL_BlendMode
pub enum BlendMode {
	@none = C.SDL_BLENDMODE_NONE // 0x00000000, no blending       dstRGBA = srcRGBA
	blend = C.SDL_BLENDMODE_BLEND // 0x00000001, alpha blending    dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA)) dstA = srcA + (dstA * (1-srcA))
	add = C.SDL_BLENDMODE_ADD // 0x00000002, additive blending   dstRGB = (srcRGB * srcA) + dstRGB dstA = dstA
	mod = C.SDL_BLENDMODE_MOD // 0x00000004, color modulate      dstRGB = srcRGB * dstRGB dstA = dstA
	mul = C.SDL_BLENDMODE_MUL // 0x00000008, color multiply dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA)) dstA = (srcA * dstA) + (dstA * (1-srcA))
	invalid = C.SDL_BLENDMODE_INVALID // 0x7FFFFFFF
}

// BlendOperation is the blend operation used when combining source and destination pixel components
// BlendOperation is C.SDL_BlendOperation
pub enum BlendOperation {
	add = C.SDL_BLENDOPERATION_ADD // 0x1, dst + src: supported by all renderers
	subtract = C.SDL_BLENDOPERATION_SUBTRACT // 0x2, dst - src : supported by D3D9, D3D11, OpenGL, OpenGLES
	rev_subtract = C.SDL_BLENDOPERATION_REV_SUBTRACT // 0x3, src - dst : supported by D3D9, D3D11, OpenGL, OpenGLES
	minimum = C.SDL_BLENDOPERATION_MINIMUM // 0x4, min(dst, src) : supported by D3D11
	maximum = C.SDL_BLENDOPERATION_MAXIMUM // 0x5 max(dst, src) : supported by D3D11
}

// BlendFactor is the normalized factor used to multiply pixel components
// BlendFactor is C.SDL_BlendFactor
pub enum BlendFactor {
	zero = C.SDL_BLENDFACTOR_ZERO // 0x1, 0, 0, 0, 0
	one = C.SDL_BLENDFACTOR_ONE // 0x2, 1, 1, 1, 1
	src_color = C.SDL_BLENDFACTOR_SRC_COLOR // 0x3, srcR, srcG, srcB, srcA
	one_minus_src_color = C.SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR // 0x4, 1-srcR, 1-srcG, 1-srcB, 1-srcA
	src_alpha = C.SDL_BLENDFACTOR_SRC_ALPHA // 0x5, srcA, srcA, srcA, srcA
	one_minus_src_alpha = C.SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA // 0x6, 1-srcA, 1-srcA, 1-srcA, 1-srcA
	dst_color = C.SDL_BLENDFACTOR_DST_COLOR // 0x7, dstR, dstG, dstB, dstA
	one_minus_dst_color = C.SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR // 0x8, 1-dstR, 1-dstG, 1-dstB, 1-dstA
	dst_alpha = C.SDL_BLENDFACTOR_DST_ALPHA // 0x9, dstA, dstA, dstA, dstA
	one_minus_dst_alpha = C.SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA // 0xA, 1-dstA, 1-dstA, 1-dstA, 1-dstA
}

fn C.SDL_ComposeCustomBlendMode(src_color_factor C.SDL_BlendFactor, dst_color_factor C.SDL_BlendFactor, color_operation C.SDL_BlendOperation, src_alpha_factor C.SDL_BlendFactor, dst_alpha_factor C.SDL_BlendFactor, alpha_operation C.SDL_BlendOperation) C.SDL_BlendMode

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
/*
```c
 dstRGB = colorOperation(srcRGB * srcColorFactor, dstRGB * dstColorFactor);
 dstA = alphaOperation(srcA * srcAlphaFactor, dstA * dstAlphaFactor);
```
*/
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
// This list describes the support of custom blend modes for each renderer in
// SDL 2.0.6. All renderers support the four blend modes listed in the
// SDL_BlendMode enumeration.
//
// - **direct3d**: Supports `SDL_BLENDOPERATION_ADD` with all factors.
// - **direct3d11**: Supports all operations with all factors. However, some
//   factors produce unexpected results with `SDL_BLENDOPERATION_MINIMUM` and
//   `SDL_BLENDOPERATION_MAXIMUM`.
// - **opengl**: Supports the `SDL_BLENDOPERATION_ADD` operation with all
//   factors. OpenGL versions 1.1, 1.2, and 1.3 do not work correctly with SDL
//   2.0.6.
// - **opengles**: Supports the `SDL_BLENDOPERATION_ADD` operation with all
//   factors. Color and alpha factors need to be the same. OpenGL ES 1
//   implementation specific: May also support `SDL_BLENDOPERATION_SUBTRACT`
//   and `SDL_BLENDOPERATION_REV_SUBTRACT`. May support color and alpha
//   operations being different from each other. May support color and alpha
//   factors being different from each other.
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
// `srcColorFactor` the SDL_BlendFactor applied to the red, green, and
//                  blue components of the source pixels
// `dstColorFactor` the SDL_BlendFactor applied to the red, green, and
//                  blue components of the destination pixels
// `colorOperation` the SDL_BlendOperation used to combine the red,
//                  green, and blue components of the source and
//                  destination pixels
// `srcAlphaFactor` the SDL_BlendFactor applied to the alpha component of
//                  the source pixels
// `dstAlphaFactor` the SDL_BlendFactor applied to the alpha component of
//                  the destination pixels
// `alphaOperation` the SDL_BlendOperation used to combine the alpha
//                  component of the source and destination pixels
// returns an SDL_BlendMode that represents the chosen factors and
//         operations.
//
// NOTE This function is available in SDL 2.0.6.
//
// See also: SDL_SetRenderDrawBlendMode
// See also: SDL_GetRenderDrawBlendMode
// See also: SDL_SetTextureBlendMode
// See also: SDL_GetTextureBlendMode
pub fn compose_custom_blend_mode(src_color_factor BlendFactor, dst_color_factor BlendFactor, color_operation BlendOperation, src_alpha_factor BlendFactor, dst_alpha_factor BlendFactor, alpha_operation BlendOperation) BlendMode {
	return unsafe {
		BlendMode(int(C.SDL_ComposeCustomBlendMode(C.SDL_BlendFactor(src_color_factor),
			C.SDL_BlendFactor(dst_color_factor), C.SDL_BlendOperation(color_operation),
			C.SDL_BlendFactor(src_alpha_factor), C.SDL_BlendFactor(dst_alpha_factor),
			C.SDL_BlendOperation(alpha_operation))))
	}
}
