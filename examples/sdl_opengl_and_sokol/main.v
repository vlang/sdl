// Copyright(C) 2022 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module main

import sdl
import sokol.gfx

#flag -I @VMODROOT/.
#include "example_shader.h"

fn C.example_shader_desc(gfx.Backend) &gfx.ShaderDesc

// Vertex_t makes it possible to model vertex buffer data
// for use with the shader system
struct Vertex_t {
	// Position
	x f32
	y f32
	z f32
	// Color
	r f32
	g f32
	b f32
	a f32
}

const win_width = 500
const win_height = 300
const sample_count = 4

pub fn create_desc() gfx.Desc {
	return gfx.Desc{
		environment: glue_environment()
	}
}

// create_default_pass creates a default `gfx.Pass` compatible with `SDL` and `sokol.gfx.begin_pass/1`.
pub fn create_default_pass(action gfx.PassAction) gfx.Pass {
	return gfx.Pass{
		action:    action
		swapchain: glue_swapchain()
	}
}

// glue_environment returns a `gfx.Environment` compatible for use with `SDL` specific `gfx.Pass`es.
// The retuned `gfx.Environment` can be used when rendering via `SDL`.
// See also: documentation at the top of thirdparty/sokol/sokol_gfx.h
pub fn glue_environment() gfx.Environment {
	mut env := gfx.Environment{}
	unsafe { vmemset(&env, 0, int(sizeof(env))) }
	env.defaults.color_format = .rgba8
	env.defaults.depth_format = .@none
	env.defaults.sample_count = sample_count
	return env
}

// glue_swapchain returns a `gfx.Swapchain` compatible for use with `SDL` specific display/rendering `gfx.Pass`es.
// The retuned `gfx.Swapchain` can be used when rendering via `SDL`.
// See also: documentation at the top of thirdparty/sokol/sokol_gfx.h
pub fn glue_swapchain() gfx.Swapchain {
	mut swapchain := gfx.Swapchain{}
	unsafe { vmemset(&swapchain, 0, int(sizeof(swapchain))) }
	swapchain.width = win_width
	swapchain.height = win_height
	swapchain.sample_count = sample_count
	swapchain.color_format = .rgba8
	swapchain.depth_format = .@none
	swapchain.gl.framebuffer = 0 // use default framebuffer (usually 0)
	return swapchain
}

@[console]
fn main() {
	sdl.init(sdl.init_video)

	$if wasm32_emscripten || android {
		sdl.gl_set_attribute(.context_profile_mask, sdl.gl_context_profile_es)
		sdl.gl_set_attribute(.context_major_version, 3)
	} $else {
		sdl.gl_set_attribute(.context_flags, sdl.gl_context_forward_compatible_flag)
		sdl.gl_set_attribute(.context_profile_mask, sdl.gl_context_profile_core)
		sdl.gl_set_attribute(.context_major_version, 4)
		sdl.gl_set_attribute(.context_minor_version, 1)
	}
	sdl.gl_set_attribute(.doublebuffer, 1)
	sdl.gl_set_attribute(.depth_size, 24)
	sdl.gl_set_attribute(.stencil_size, 8)

	mut window_flags := sdl.WindowFlags(sdl.window_opengl)
	window := sdl.create_window('Hello SDL3 + Sokol (OpenGL)'.str, win_width, win_height,
		window_flags)
	if window == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not create SDL window, SDL says:\n${error_msg}')
	}

	gl_context := sdl.gl_create_context(window)
	if gl_context == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not create OpenGL context, SDL says:\n${error_msg}')
	}

	sdl.gl_make_current(window, gl_context)
	// Enable VSYNC (Sync buffer swaps with monitors vertical refresh rate)
	if !sdl.gl_set_swap_interval(1) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not set OpenGL swap interval to vsync:\n${error_msg}')
	}

	desc := create_desc()
	gfx.setup(&desc)
	assert gfx.is_valid() == true

	pass_action := gfx.create_clear_pass_action(0.0, 0.0, 0.0, 1.0)
	pass := create_default_pass(pass_action)
	mut bind := gfx.Bindings{}

	vertices := [
		Vertex_t{0.0, 0.5, 0.5, 1.0, 0.0, 0.0, 1.0},
		Vertex_t{0.5, -0.5, 0.5, 0.0, 1.0, 0.0, 1.0},
		Vertex_t{-0.5, -0.5, 0.5, 0.0, 0.0, 1.0, 1.0},
	]

	mut vertex_buffer_desc := gfx.BufferDesc{
		label: c'triangle-vertices'
	}
	unsafe { vmemset(&vertex_buffer_desc, 0, int(sizeof(vertex_buffer_desc))) }

	vertex_buffer_desc.size = usize(vertices.len * int(sizeof(Vertex_t)))
	vertex_buffer_desc.data = gfx.Range{
		ptr:  vertices.data
		size: vertex_buffer_desc.size
	}

	bind.vertex_buffers[0] = gfx.make_buffer(&vertex_buffer_desc)

	shader := gfx.make_shader(C.example_shader_desc(gfx.query_backend()))

	mut pipeline_desc := gfx.PipelineDesc{}
	unsafe { vmemset(&pipeline_desc, 0, int(sizeof(pipeline_desc))) }

	pipeline_desc.shader = shader

	pipeline_desc.layout.attrs[C.ATTR_vs_position].format = .float3 // x,y,z as f32
	pipeline_desc.layout.attrs[C.ATTR_vs_color0].format = .float4 // r, g, b, a as f32

	pipeline_desc.label = c'triangle-pipeline'

	shader_pipeline := gfx.make_pipeline(&pipeline_desc)

	mut should_close := false

	for {
		evt := sdl.Event{}
		for sdl.poll_event(&evt) {
			match evt.type {
				.quit { should_close = true }
				else {}
			}
		}
		if should_close {
			break
		}

		gfx.begin_pass(&pass)

		gfx.apply_pipeline(shader_pipeline)
		gfx.apply_bindings(&bind)

		gfx.draw(0, 3, 1)
		gfx.end_pass()
		gfx.commit()

		sdl.gl_swap_window(window)
	}

	gfx.shutdown()
	sdl.gl_destroy_context(gl_context)
	sdl.destroy_window(window)
	sdl.quit()
}
