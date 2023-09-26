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
	@none   = C.SDL_BLENDMODE_NONE // 0x00000000, no blending       dstRGBA = srcRGBA
	blend   = C.SDL_BLENDMODE_BLEND // 0x00000001, alpha blending    dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA)) dstA = srcA + (dstA * (1-srcA))
	add     = C.SDL_BLENDMODE_ADD // 0x00000002, additive blending   dstRGB = (srcRGB * srcA) + dstRGB dstA = dstA
	mod     = C.SDL_BLENDMODE_MOD // 0x00000004, color modulate      dstRGB = srcRGB * dstRGB dstA = dstA
	invalid = C.SDL_BLENDMODE_INVALID // 0x7FFFFFFF
}

// BlendOperation is the blend operation used when combining source and destination pixel components
// BlendOperation is C.SDL_BlendOperation
pub enum BlendOperation {
	add          = C.SDL_BLENDOPERATION_ADD // 0x1, dst + src: supported by all renderers
	subtract     = C.SDL_BLENDOPERATION_SUBTRACT // 0x2, dst - src : supported by D3D9, D3D11, OpenGL, OpenGLES
	rev_subtract = C.SDL_BLENDOPERATION_REV_SUBTRACT // 0x3, src - dst : supported by D3D9, D3D11, OpenGL, OpenGLES
	minimum      = C.SDL_BLENDOPERATION_MINIMUM // 0x4, min(dst, src) : supported by D3D11
	maximum      = C.SDL_BLENDOPERATION_MAXIMUM // 0x5 max(dst, src) : supported by D3D11
}

// BlendFactor is the normalized factor used to multiply pixel components
// BlendFactor is C.SDL_BlendFactor
pub enum BlendFactor {
	zero                = C.SDL_BLENDFACTOR_ZERO // 0x1, 0, 0, 0, 0
	one                 = C.SDL_BLENDFACTOR_ONE // 0x2, 1, 1, 1, 1
	src_color           = C.SDL_BLENDFACTOR_SRC_COLOR // 0x3, srcR, srcG, srcB, srcA
	one_minus_src_color = C.SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR // 0x4, 1-srcR, 1-srcG, 1-srcB, 1-srcA
	src_alpha           = C.SDL_BLENDFACTOR_SRC_ALPHA // 0x5, srcA, srcA, srcA, srcA
	one_minus_src_alpha = C.SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA // 0x6, 1-srcA, 1-srcA, 1-srcA, 1-srcA
	dst_color           = C.SDL_BLENDFACTOR_DST_COLOR // 0x7, dstR, dstG, dstB, dstA
	one_minus_dst_color = C.SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR // 0x8, 1-dstR, 1-dstG, 1-dstB, 1-dstA
	dst_alpha           = C.SDL_BLENDFACTOR_DST_ALPHA // 0x9, dstA, dstA, dstA, dstA
	one_minus_dst_alpha = C.SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA // 0xA, 1-dstA, 1-dstA, 1-dstA, 1-dstA
}

fn C.SDL_ComposeCustomBlendMode(src_color_factor C.SDL_BlendFactor, dst_color_factor C.SDL_BlendFactor, color_operation C.SDL_BlendOperation, src_alpha_factor C.SDL_BlendFactor, dst_alpha_factor C.SDL_BlendFactor, alpha_operation C.SDL_BlendOperation) C.SDL_BlendMode

// compose_custom_blend_mode creates a custom blend mode, which may
// or may not be supported by a given renderer
//
// `srcColorFactor`
// `dstColorFactor`
// `colorOperation`
// `srcAlphaFactor`
// `dstAlphaFactor`
// `alphaOperation`
//
// The result of the blend mode operation will be:
// dstRGB = dstRGB * dstColorFactor colorOperation srcRGB * srcColorFactor
// and
// dstA = dstA * dstAlphaFactor alphaOperation srcA * srcAlphaFactor
pub fn compose_custom_blend_mode(src_color_factor BlendFactor, dst_color_factor BlendFactor, color_operation BlendOperation, src_alpha_factor BlendFactor, dst_alpha_factor BlendFactor, alpha_operation BlendOperation) BlendMode {
	return unsafe {
		BlendMode(int(C.SDL_ComposeCustomBlendMode(C.SDL_BlendFactor(src_color_factor),
			C.SDL_BlendFactor(dst_color_factor), C.SDL_BlendOperation(color_operation),
			C.SDL_BlendFactor(src_alpha_factor), C.SDL_BlendFactor(dst_alpha_factor),
			C.SDL_BlendOperation(alpha_operation))))
	}
}
