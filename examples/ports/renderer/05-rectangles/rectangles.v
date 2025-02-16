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

// Ported from rectangles.c https://examples.libsdl.org/SDL3/renderer/05-rectangles/

// This example creates an SDL window and renderer, and then draws some
// rectangles to it every frame.
//
// This code is public domain. Feel free to use it for any purpose!

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
}

const window_width = 640
const window_height = 480

// This function runs once at startup.
@[export: 'v_sdl_app_init']
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata('Example Renderer Rectangles'.str, '1.0'.str, 'com.example.renderer-rectangles'.str)

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer('examples/renderer/rectangles'.str, window_width,
		window_height, sdl.WindowFlags(0), &app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create window/renderer: ${error_msg}")
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

	mut rects := [16]sdl.FRect{}

	now := sdl.get_ticks()

	// we'll have the rectangles grow and shrink over a few seconds.
	direction := if (now % 2000) >= 1000 { f32(1.0) } else { f32(-1.0) }
	scale := f32((int(now % 1000) - 500) / f32(500.0)) * direction

	// as you can see from this, rendering draws over whatever was drawn before it.
	sdl.set_render_draw_color(app.renderer, 0, 0, 0, sdl.alpha_opaque) // black, full alpha
	sdl.render_clear(app.renderer) // start with a blank canvas.

	// Rectangles are comprised of set of X and Y coordinates, plus width and
	// height. (0, 0) is the top left of the window, and larger numbers go
	// down and to the right. This isn't how geometry works, but this is
	// pretty standard in 2D graphics.

	// Let's draw a single rectangle (square, really).
	rects[0].x, rects[0].y = 100, 100
	rects[0].w, rects[0].h = 100 + (100 * scale), 100 + (100 * scale)

	sdl.set_render_draw_color(app.renderer, 255, 0, 0, sdl.alpha_opaque) // red, full alpha
	sdl.render_rect(app.renderer, &rects[0])

	// Now let's draw several rectangles with one function call.
	for i := 0; i < 3; i++ {
		size := (f32(i) + 1) * 50.0
		rects[i].w = size + (size * scale)
		rects[i].h = rects[i].w
		rects[i].x = (window_width - rects[i].w) / 2 // center it.
		rects[i].y = (window_height - rects[i].h) / 2 // center it.
	}
	sdl.set_render_draw_color(app.renderer, 0, 255, 0, sdl.alpha_opaque) // green, full alpha
	sdl.render_rects(app.renderer, &rects[0], 3) // draw three rectangles at once

	// those were rectangle _outlines_, really. You can also draw _filled_ rectangles!
	rects[0].x = 400
	rects[0].y = 50
	rects[0].w = 100 + (100 * scale)
	rects[0].h = 50 + (50 * scale)
	sdl.set_render_draw_color(app.renderer, 0, 0, 255, sdl.alpha_opaque) // blue, full alpha
	sdl.render_fill_rect(app.renderer, &rects[0])

	// ...and also fill a bunch of rectangles at once...
	for i := 0; i < rects.len; i++ {
		w := f32(window_width / rects.len)
		h := f32(i) * 8.0
		rects[i].x = i * w
		rects[i].y = window_height - h
		rects[i].w = w
		rects[i].h = h
	}
	sdl.set_render_draw_color(app.renderer, 255, 255, 255, sdl.alpha_opaque) // white, full alpha
	sdl.render_fill_rects(app.renderer, &rects[0], rects.len)

	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

// This function runs once at shutdown.
@[export: 'v_sdl_app_quit']
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	// SDL will clean up the window/renderer for us.
}
