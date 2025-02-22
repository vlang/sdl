// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// See also: `examples/ports/template.v` for a simple commented example demonstrating how
// to run via callbacks instead of a `fn main() {}`.
// See also: `examples/ports/README.md` for more information.
import sdl
import sdl.callbacks

fn init() {
	callbacks.on_init(app_init)
	callbacks.on_iterate(app_iterate)
}

// Ported from primitives.c https://examples.libsdl.org/SDL3/renderer/02-primitives/

// This example creates an SDL window and renderer, and then draws some lines,
// rectangles and points to it every frame.
//
// This code is public domain. Feel free to use it for any purpose!

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
	points   [500]sdl.FPoint
}

// This function runs once at startup.
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata(c'Example Renderer Primitives', c'1.0', c'com.example.renderer-primitives')

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer(c'examples/renderer/primitives', 640, 480, sdl.WindowFlags(0),
		&app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create window/renderer: ${error_msg}")
		return .failure
	}

	// set up some random points
	for i := 0; i < app.points.len; i++ {
		app.points[i].x = (sdl.randf() * 440.0) + 100.0
		app.points[i].y = (sdl.randf() * 280.0) + 100.0
	}

	return .continue // carry on with the program!
}

// This function runs once per frame, and is the heart of the program.
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }

	mut rect := sdl.FRect{}

	// as you can see from this, rendering draws over whatever was drawn before it.
	sdl.set_render_draw_color(app.renderer, 33, 33, 33, sdl.alpha_opaque) // dark gray, full alpha
	sdl.render_clear(app.renderer) // start with a blank canvas.

	// draw a filled rectangle in the middle of the canvas.
	sdl.set_render_draw_color(app.renderer, 0, 0, 255, sdl.alpha_opaque) // blue, full alpha
	rect.x, rect.y = 100, 100
	rect.w = 440
	rect.h = 280
	sdl.render_fill_rect(app.renderer, &rect)

	// draw some points across the canvas.
	sdl.set_render_draw_color(app.renderer, 255, 0, 0, sdl.alpha_opaque) // red, full alpha
	sdl.render_points(app.renderer, &app.points[0], app.points.len)

	// draw a unfilled rectangle in-set a little bit.
	sdl.set_render_draw_color(app.renderer, 0, 255, 0, sdl.alpha_opaque) // green, full alpha
	rect.x += 30
	rect.y += 30
	rect.w -= 60
	rect.h -= 60
	sdl.render_rect(app.renderer, &rect)

	// draw two lines in an X across the whole canvas.
	sdl.set_render_draw_color(app.renderer, 255, 255, 0, sdl.alpha_opaque) // yellow, full alpha
	sdl.render_line(app.renderer, 0, 0, 640, 480)
	sdl.render_line(app.renderer, 0, 480, 640, 0)
	sdl.render_present(app.renderer) // put it all on the screen!
	return .continue
}
