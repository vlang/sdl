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

[console]
fn main() {
	init(init_video)

	gl_set_attribute(.context_flags, int(GLcontextFlag.forward_compatible_flag))
	gl_set_attribute(.context_profile_mask, int(GLprofile.core))
	gl_set_attribute(.context_major_version, 3)
	gl_set_attribute(.context_minor_version, 3)
	gl_set_attribute(.doublebuffer, 1)
	gl_set_attribute(.depth_size, 24)
	gl_set_attribute(.stencil_size, 8)

	mut window_flags := u32(WindowFlags.opengl)
	window := create_window('Hello SDL2 + Sokol (OpenGL)'.str, 300, 300, 500, 300, window_flags)
	if window == null {
		error_msg := unsafe { cstring_to_vstring(get_error()) }
		panic('Could not create SDL window, SDL says:\n$error_msg')
	}

	gl_context := gl_create_context(window)
	if gl_context == null {
		error_msg := unsafe { cstring_to_vstring(get_error()) }
		panic('Could not create OpenGL context, SDL says:\n$error_msg')
	}

	gl_make_current(window, gl_context)
	// Enable VSYNC (Sync buffer swaps with monitors vertical refresh rate)
	if gl_set_swap_interval(1) < 0 {
		error_msg := unsafe { cstring_to_vstring(get_error()) }
		panic('Could not set OpenGL swap interval to vsync:\n$error_msg')
	}

	desc := gfx.Desc{}
	gfx.setup(&desc)
	assert gfx.is_valid() == true

	pass_action := gfx.create_clear_pass(0.0, 0.0, 0.0, 1.0)
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
		ptr: vertices.data
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

	mut w := 0
	mut h := 0
	for {
		evt := Event{}
		for 0 < poll_event(&evt) {
			match evt.@type {
				.quit { should_close = true }
				else {}
			}
		}
		if should_close {
			break
		}

		gl_get_drawable_size(window, &w, &h)
		gfx.begin_default_pass(&pass_action, w, h)

		gfx.apply_pipeline(shader_pipeline)
		gfx.apply_bindings(&bind)

		gfx.draw(0, 3, 1)
		gfx.end_pass()
		gfx.commit()

		gl_swap_window(window)
	}

	gfx.shutdown()
	gl_delete_context(gl_context)
	destroy_window(window)
	quit()
}
