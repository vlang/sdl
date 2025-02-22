// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// See also: `examples/ports/template.v` for a simple commented example demonstrating how
// to run via callbacks instead of a `fn main() {}`.
// See also: `examples/ports/README.md` for more information.
import os
import sdl
import sdl.callbacks

fn init() {
	callbacks.on_init(app_init)
	callbacks.on_quit(app_quit)
	callbacks.on_iterate(app_iterate)
}

#flag wasm32_emscripten --embed-file "@VMODROOT/examples/assets/images/sample.bmp@images/sample.bmp"

// Ported from textures.c https://examples.libsdl.org/SDL3/renderer/06-textures/

// This example creates an SDL window and renderer, and then draws some
// textures to it every frame.
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
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata(c'Example Renderer Textures', c'1.0', c'com.example.renderer-textures')

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer(c'examples/renderer/textures', window_width, window_height,
		sdl.WindowFlags(0), &app.window, &app.renderer) {
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
	surface := sdl.load_bmp(&char(bmp_path.str))
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

// This function runs once per frame, and is the heart of the program.
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }

	mut dst_rect := sdl.FRect{}
	now := sdl.get_ticks()

	// we'll have some textures move around over a few seconds.
	direction := if (now % 2000) >= 1000 { f32(1.0) } else { f32(-1.0) }
	scale := (f32(int(now % 1000) - 500) / 500.0) * direction

	// as you can see from this, rendering draws over whatever was drawn before it.
	sdl.set_render_draw_color(app.renderer, 0, 0, 0, sdl.alpha_opaque) // black, full alpha
	sdl.render_clear(app.renderer) // start with a blank canvas.

	// Just draw the static texture a few times. You can think of it like a
	// stamp, there isn't a limit to the number of times you can draw with it.

	texture_width := f32(app.texture_width)
	texture_height := f32(app.texture_height)

	// top left
	dst_rect.x = 100 * scale
	dst_rect.y = 0.0
	dst_rect.w = texture_width
	dst_rect.h = texture_height
	sdl.render_texture(app.renderer, app.texture, sdl.null, &dst_rect)

	// center this one.
	dst_rect.x = f32(window_width - texture_width) / 2.0
	dst_rect.y = f32(window_height - texture_height) / 2.0
	dst_rect.w = texture_width
	dst_rect.h = texture_height
	sdl.render_texture(app.renderer, app.texture, sdl.null, &dst_rect)

	// bottom right.
	dst_rect.x = f32(window_width - texture_width) - (100.0 * scale)
	dst_rect.y = f32(window_height - texture_height)
	dst_rect.w = texture_width
	dst_rect.h = texture_height
	sdl.render_texture(app.renderer, app.texture, sdl.null, &dst_rect)

	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

// This function runs once at shutdown.
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	mut app := unsafe { &SDLApp(appstate) }
	sdl.destroy_texture(app.texture)
	// SDL will clean up the window/renderer for us.
}
