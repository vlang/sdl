// Copyright(C) 2026 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// NOTE: compile this example with `-d sdl_callbacks`.
// See also: `examples/ports/template.v` for a simple commented example demonstrating how
// to run via callbacks instead of a `fn main() {}`.
// See also: `examples/ports/README.md` for more information.
import sdl
import os

#postinclude "@VMODROOT/c/sdl_main_use_callbacks_shim.h"

#flag wasm32_emscripten --embed-file "@VMODROOT/examples/assets/images/sample.bmp@images/sample.bmp"

// Ported from geometry.c https://examples.libsdl.org/SDL3/renderer/10-geometry/

// This example creates an SDL window and renderer, and then draws some
// geometry to it every frame.
//
// This code is public domain. Feel free to use it for any purpose!

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window         &sdl.Window   = unsafe { nil }
	renderer       &sdl.Renderer = unsafe { nil }
	texture        &sdl.Texture  = unsafe { nil }
	texture_width  int
	texture_height int
}

const window_width = 640
const window_height = 480

// get_asset_path returns `examples/assets` + `path` where `examples/assets` is resolved per
// supported platform.
// `path` is expected to be a `string` with a *relative* path to an asset in `examples/assets`.
// Note the `--embed-file` `#flag` at the top of this file for `wasm32_emscripten` builds
fn get_asset_path(path string) string {
	$if android || wasm32_emscripten {
		return path
	} $else {
		return os.resource_abs_path(os.join_path('..', '..', '..', 'assets', path))
	}
}

// This function runs once at startup.
@[export: 'v_sdl_app_init']
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata('Example Renderer Geometry'.str, '1.0'.str, 'com.example.renderer-geometry'.str)

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer('examples/renderer/geometry'.str, window_width,
		window_height, sdl.WindowFlags(0), &app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create window/renderer: ${error_msg}")
		return .failure
	}

	// Textures are pixel data that we upload to the video hardware for fast drawing. Lots of 2D
	// engines refer to these as "sprites." We'll do a static texture (upload once, draw many
	// times) with data from a bitmap file.

	// SDL_Surface is pixel data the CPU can access. SDL_Texture is pixel data the GPU can access.
	// Load a .bmp into a surface, move it to a texture from there.
	bmp_path := get_asset_path(os.join_path('images', 'sample.bmp'))
	surface := sdl.load_bmp(bmp_path.str)
	if surface == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't load bitmap: ${error_msg}")
		return .failure
	}

	app.texture_width = surface.w
	app.texture_height = surface.h

	app.texture = sdl.create_texture_from_surface(app.renderer, surface)
	if app.texture == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create static texture: ${error_msg}")
		return .failure
	}

	sdl.destroy_surface(surface) // done with this, the texture has a copy of the pixels now.

	return .continue // carry on with the program!
}

// This function runs when a new event (mouse input, keypresses, etc) occurs.
@[export: 'v_sdl_app_event']
pub fn app_event(appstate voidptr, event &sdl.Event) sdl.AppResult {
	match event.type {
		.quit {
			return .success // end the program, reporting success to the OS.
		}
		else {}
	}
	return .continue // carry on with the program!
}

// This function runs once per frame, and is the heart of the program.
@[export: 'v_sdl_app_iterate']
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }

	now := sdl.get_ticks()
	// we'll have the triangle grow and shrink over a few seconds.
	direction := if (now % 2000) >= 1000 { f32(1.0) } else { f32(-1.0) }
	scale := (f32(int(now % 1000) - 500) / 500.0) * direction
	size := f32(200.0) + (200.0 * scale)

	mut vertices := [4]sdl.Vertex{}

	// as you can see from this, rendering draws over whatever was drawn before it.
	sdl.set_render_draw_color(app.renderer, 0, 0, 0, sdl.alpha_opaque) // black, full alpha
	sdl.render_clear(app.renderer) // start with a blank canvas.

	// Draw a single triangle with a different color at each vertex. Center this one and make it grow and shrink.
	// You always draw triangles with this, but you can string triangles together to form polygons.
	vertices[0].position.x = f32(window_width) / 2.0
	vertices[0].position.y = (f32(window_height) - size) / 2.0
	vertices[0].color.r = 1.0
	vertices[0].color.a = 1.0
	vertices[1].position.x = (f32(window_width) + size) / 2.0
	vertices[1].position.y = (f32(window_height) + size) / 2.0
	vertices[1].color.g = 1.0
	vertices[1].color.a = 1.0
	vertices[2].position.x = (f32(window_width) - size) / 2.0
	vertices[2].position.y = (f32(window_height) + size) / 2.0
	vertices[2].color.b = 1.0
	vertices[2].color.a = 1.0

	sdl.render_geometry(app.renderer, sdl.null, &vertices[0], 3, sdl.null, 0)

	// you can also map a texture to the geometry! Texture coordinates go from 0.0f to 1.0f. That will be the location
	// in the texture bound to this vertex.
	vertices = [4]sdl.Vertex{}
	vertices[0].position.x = 10.0
	vertices[0].position.y = 10.0
	vertices[0].color.r, vertices[0].color.g, vertices[0].color.b, vertices[0].color.a = 1.0, 1.0, 1.0, 1.0
	vertices[0].tex_coord.x = 0.0
	vertices[0].tex_coord.y = 0.0
	vertices[1].position.x = 150.0
	vertices[1].position.y = 10.0
	vertices[1].color.r, vertices[1].color.g, vertices[1].color.b, vertices[1].color.a = 1.0, 1.0, 1.0, 1.0
	vertices[1].tex_coord.x = 1.0
	vertices[1].tex_coord.y = 0.0
	vertices[2].position.x = 10.0
	vertices[2].position.y = 150.0
	vertices[2].color.r, vertices[2].color.g, vertices[2].color.b, vertices[2].color.a = 1.0, 1.0, 1.0, 1.0
	vertices[2].tex_coord.x = 0.0
	vertices[2].tex_coord.y = 1.0
	sdl.render_geometry(app.renderer, app.texture, &vertices[0], 3, sdl.null, 0)

	// Did that only draw half of the texture? You can do multiple triangles sharing some vertices,
	// using indices, to get the whole thing on the screen:

	// Let's just move this over so it doesn't overlap...
	for i := 0; i < 3; i++ {
		vertices[i].position.x += 450
	}

	// we need one more vertex, since the two triangles can share two of them.
	vertices[3].position.x = 600.0
	vertices[3].position.y = 150.0
	vertices[3].color.r, vertices[0].color.g, vertices[0].color.b, vertices[0].color.a = 1.0, 1.0, 1.0, 1.0
	vertices[3].tex_coord.x = 1.0
	vertices[3].tex_coord.y = 1.0

	// And an index to tell it to reuse some of the vertices between triangles...
	{
		// 4 vertices, but 6 actual places they used. Indices need less bandwidth to transfer and can reorder vertices easily!
		indices := [0, 1, 2, 1, 2, 3]!
		sdl.render_geometry(app.renderer, app.texture, &vertices[0], 4, &indices[0], indices.len)
	}

	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

// This function runs once at shutdown.
@[export: 'v_sdl_app_quit']
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	mut app := unsafe { &SDLApp(appstate) }
	sdl.destroy_texture(app.texture)
	// SDL will clean up the window/renderer for us.
}
