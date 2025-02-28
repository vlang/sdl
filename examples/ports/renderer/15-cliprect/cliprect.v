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

// Ported from cliprect.c https://examples.libsdl.org/SDL3/renderer/15-cliprect/

// This example creates an SDL window and renderer, and then draws a scene
// to it every frame, while sliding around a clipping rectangle.
//
// This code is public domain. Feel free to use it for any purpose!

const window_width = 640
const window_height = 480
const cliprect_size = 250
const cliprect_speed = 200 // pixels per second

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window             &sdl.Window   = unsafe { nil }
	renderer           &sdl.Renderer = unsafe { nil }
	texture            &sdl.Texture  = unsafe { nil }
	cliprect_position  sdl.FPoint
	cliprect_direction sdl.FPoint
	last_time          u64
}

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

// A lot of this program is examples/renderer/02-primitives, so we have a good
// visual that we can slide a clip rect around. The actual new magic in here
// is the SDL_SetRenderClipRect() function.

// This function runs once at startup.
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata(c'Example Renderer Cliprect', c'1.0', c'com.example.renderer-cliprect')

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer(c'examples/renderer/cliprect', window_width, window_height,
		sdl.WindowFlags(0), &app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create window/renderer: ${error_msg}")
		return .failure
	}
	// SDL does not enable vertical monitor refresh-rate sync per default. To keep CPU usage low we add it, if possible.
	// NOTE: this is not part of the original example.
	if !sdl.set_render_v_sync(app.renderer, 1) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln('notice: SDL could not enable vsync for the renderer:\n${error_msg}\nSee also docs for `set_render_v_sync`.')
	}

	app.cliprect_direction.x, app.cliprect_direction.y = 1.0, 1.0

	app.last_time = sdl.get_ticks()

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

	cliprect := sdl.Rect{int(sdl.roundf(app.cliprect_position.x)), int(sdl.roundf(app.cliprect_position.y)), cliprect_size, cliprect_size}
	now := sdl.get_ticks()
	elapsed := f32(now - app.last_time) / 1000.0 // seconds since last iteration
	distance := elapsed * cliprect_speed

	// Set a new clipping rectangle position
	app.cliprect_position.x += distance * app.cliprect_direction.x
	if app.cliprect_position.x < 0.0 {
		app.cliprect_position.x = 0.0
		app.cliprect_direction.x = 1.0
	} else if app.cliprect_position.x >= (window_width - cliprect_size) {
		app.cliprect_position.x = (window_width - cliprect_size) - 1
		app.cliprect_direction.x = -1.0
	}

	app.cliprect_position.y += distance * app.cliprect_direction.y
	if app.cliprect_position.y < 0.0 {
		app.cliprect_position.y = 0.0
		app.cliprect_direction.y = 1.0
	} else if app.cliprect_position.y >= (window_height - cliprect_size) {
		app.cliprect_position.y = (window_height - cliprect_size) - 1
		app.cliprect_direction.y = -1.0
	}
	sdl.set_render_clip_rect(app.renderer, &cliprect)

	app.last_time = now

	// okay, now draw!

	// Note that SDL_RenderClear is _not_ affected by the clipping rectangle!
	sdl.set_render_draw_color(app.renderer, 33, 33, 33, sdl.alpha_opaque) // grey, full alpha
	sdl.render_clear(app.renderer) // start with a blank canvas.

	// stretch the texture across the entire window. Only the piece in the
	// clipping rectangle will actually render, though!
	sdl.render_texture(app.renderer, app.texture, sdl.null, sdl.null)

	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

// This function runs once at shutdown.
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	mut app := unsafe { &SDLApp(appstate) }
	sdl.destroy_texture(app.texture)
	// SDL will clean up the window/renderer for us.
}
