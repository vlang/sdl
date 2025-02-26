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

// Ported from read-pixels.c https://examples.libsdl.org/SDL3/renderer/14-read-pixels/

// This example creates an SDL window and renderer, and draws a
// rotating texture to it, reads back the rendered pixels, converts them to
// black and white, and then draws the converted image to a corner of the
// screen.
//
// This isn't necessarily an efficient thing to do--in real life one might
// want to do this sort of thing with a render target--but it's just a visual
// example of how to use SDL_RenderReadPixels().
//
// This code is public domain. Feel free to use it for any purpose!

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window                   &sdl.Window   = unsafe { nil }
	renderer                 &sdl.Renderer = unsafe { nil }
	texture                  &sdl.Texture  = unsafe { nil }
	texture_width            int
	texture_height           int
	converted_texture        &sdl.Texture = unsafe { nil }
	converted_texture_width  int
	converted_texture_height int
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
	sdl.set_app_metadata(c'Example Renderer Read Pixels', c'1.0', c'com.example.renderer-read-pixels')

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer(c'examples/renderer/read-pixels', window_width,
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

	now := sdl.get_ticks()
	mut center := sdl.FPoint{}
	mut dst_rect := sdl.FRect{}

	// we'll have a texture rotate around over 2 seconds (2000 milliseconds). 360 degrees in a circle!
	rotation := f32(f32(int(now % 2000)) / 2000.0) * 360.0

	texture_width := f32(app.texture_width)
	texture_height := f32(app.texture_height)
	// as you can see from this, rendering draws over whatever was drawn before it.
	sdl.set_render_draw_color(app.renderer, 0, 0, 0, sdl.alpha_opaque) // black, full alpha
	sdl.render_clear(app.renderer) // start with a blank canvas.

	// Center this one, and draw it with some rotation so it spins!
	dst_rect.x = f32(window_width - texture_width) / 2.0
	dst_rect.y = f32(window_height - texture_height) / 2.0
	dst_rect.w = texture_width
	dst_rect.h = texture_height
	// rotate it around the center of the texture; you can rotate it from a different point, too!
	center.x = texture_width / 2.0
	center.y = texture_height / 2.0
	sdl.render_texture_rotated(app.renderer, app.texture, sdl.null, &dst_rect, rotation,
		&center, .none)

	// this next whole thing is _super_ expensive. Seriously, don't do this in real life.

	// Download the pixels of what has just been rendered. This has to wait for the GPU to finish rendering it and everything before it,
	// and then make an expensive copy from the GPU to system RAM!
	mut surface := sdl.render_read_pixels(app.renderer, sdl.null)

	// This is also expensive, but easier: convert the pixels to a format we want.
	if surface != sdl.null && (surface.format != .rgba8888 && surface.format != .bgra8888) {
		mut converted := sdl.convert_surface(surface, .rgba8888)
		sdl.destroy_surface(surface)
		surface = converted
	}

	if surface != sdl.null {
		// Rebuild converted_texture if the dimensions have changed (window resized, etc).
		if surface.w != app.converted_texture_width || surface.h != app.converted_texture_height {
			sdl.destroy_texture(app.converted_texture)
			app.converted_texture = sdl.create_texture(app.renderer, .rgba8888, .streaming,
				surface.w, surface.h)
			if app.converted_texture == sdl.null {
				error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
				eprintln("Couldn't (re)create conversion texture: ${error_msg}")
				return .failure
			}
			app.converted_texture_width = surface.w
			app.converted_texture_height = surface.h
		}

		// Turn each pixel into either black or white. This is a lousy technique but it works here.
		// In real life, something like Floyd-Steinberg dithering might work
		// better: https://en.wikipedia.org/wiki/Floyd%E2%80%93Steinberg_dithering
		for y := 0; y < surface.h; y++ {
			unsafe {
				pixels := &u32(&u8(surface.pixels) + int(y * surface.pitch))
				for x := 0; x < surface.w; x++ {
					mut p := &u8(&pixels[x])
					const_average := (u32(p[1]) + u32(p[2]) + u32(p[3])) / 3
					if const_average == 0 {
						p[0], p[3] = 0xFF, 0xFF
						p[1], p[2] = 0, 0 // make pure black pixels red.
					} else {
						hex := if const_average > 50 { u8(0xFF) } else { u8(0x00) }
						p[1], p[2], p[3] = hex, hex, hex // make everything else either black or white.
					}
				}
			}
		}

		// upload the processed pixels back into a texture.
		sdl.update_texture(app.converted_texture, sdl.null, surface.pixels, surface.pitch)
		sdl.destroy_surface(surface)

		// draw the texture to the top-left of the screen.
		dst_rect.x, dst_rect.y = 0.0, 0.0
		dst_rect.w = f32(window_width) / 4.0
		dst_rect.h = f32(window_height) / 4.0
		sdl.render_texture(app.renderer, app.converted_texture, sdl.null, &dst_rect)
	}

	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

// This function runs once at shutdown.
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	mut app := unsafe { &SDLApp(appstate) }
	sdl.destroy_texture(app.converted_texture)
	sdl.destroy_texture(app.texture)
	// SDL will clean up the window/renderer for us.
}
