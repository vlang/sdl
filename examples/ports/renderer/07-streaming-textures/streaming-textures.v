// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// NOTE: compile this example with `-d sdl_callbacks`.
// See also: `examples/ports/template.v` for a simple commented example demonstrating how
// to run via callbacks instead of a `fn main() {}`.
// See also: `examples/ports/README.md` for more information.
import sdl

#postinclude "@VMODROOT/c/sdl_main_use_callbacks_shim.h"

// Ported from streaming-textures.c https://examples.libsdl.org/SDL3/renderer/07-streaming-textures/

// This example creates an SDL window and renderer, and then draws a streaming
// texture to it every frame.
//
// This code is public domain. Feel free to use it for any purpose!

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
	texture  &sdl.Texture  = unsafe { nil }
}

const texture_size = 150

const window_width = 640
const window_height = 480

// This function runs once at startup.
@[export: 'v_sdl_app_init']
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata('Example Renderer Streaming Textures'.str, '1.0'.str, 'com.example.renderer-streaming-textures'.str)

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer('examples/renderer/streaming-textures'.str, window_width,
		window_height, sdl.WindowFlags(0), &app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create window/renderer: ${error_msg}")
		return .failure
	}

	app.texture = sdl.create_texture(app.renderer, .rgba8888, .streaming, texture_size,
		texture_size)
	if app.texture == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create streaming texture: ${error_msg}")
		return .failure
	}

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

	mut dst_rect := sdl.FRect{}
	now := sdl.get_ticks()
	surface := &sdl.Surface(sdl.null)

	// we'll have some color move around over a few seconds
	direction := if (now % 2000) >= 1000 { f32(1.0) } else { f32(-1.0) }
	scale := (f32(int(now % 1000) - 500) / 500.0) * direction

	// To update a streaming texture, you need to lock it first. This gets you access to the pixels.
	// Note that this is considered a _write-only_ operation: the buffer you get from locking
	// might not acutally have the existing contents of the texture, and you have to write to every
	// locked pixel!

	// You can use SDL_LockTexture() to get an array of raw pixels, but we're going to use
	// SDL_LockTextureToSurface() here, because it wraps that array in a temporary SDL_Surface,
	// letting us use the surface drawing functions instead of lighting up individual pixels.

	if sdl.lock_texture_to_surface(app.texture, sdl.null, &surface) {
		mut r := sdl.Rect{}

		pixel_format_details := sdl.get_pixel_format_details(surface.format)
		sdl.fill_surface_rect(surface, sdl.null, sdl.map_rgb(pixel_format_details, sdl.null,
			0, 0, 0)) // make the whole surface black
		r.w = texture_size
		r.h = texture_size / 10
		r.x = 0
		r.y = int(f32(texture_size - r.h) * ((scale + 1.0) / 2.0))
		sdl.fill_surface_rect(surface, &r, sdl.map_rgb(pixel_format_details, sdl.null,
			0, 255, 0)) // make a strip of the surface green
		sdl.unlock_texture(app.texture) // upload the changes (and frees the temporary surface)!
	} else {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't lock texture to suface: ${error_msg}")
		return .failure
	}

	// as you can see from this, rendering draws over whatever was drawn before it.
	sdl.set_render_draw_color(app.renderer, 66, 66, 66, sdl.alpha_opaque) // grey, full alpha
	sdl.render_clear(app.renderer) // start with a blank canvas.

	// Just draw the static texture a few times. You can think of it like a
	// stamp, there isn't a limit to the number of times you can draw with it.

	// Center this one. It'll draw the latest version of the texture we drew while it was locked.
	dst_rect.x = f32(window_width - texture_size) / 2.0
	dst_rect.y = f32(window_height - texture_size) / 2.0
	dst_rect.w = f32(texture_size)
	dst_rect.h = dst_rect.w
	sdl.render_texture(app.renderer, app.texture, sdl.null, &dst_rect)

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
