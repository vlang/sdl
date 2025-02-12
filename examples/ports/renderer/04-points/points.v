// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// NOTE: compile this example with `-d sdl_callbacks`.
// See also: `examples/ports/v-sdl-no-main` for a simple example demonstrating how
// the examples can run via callbacks instead of a `fn main() {}`.
import sdl

#postinclude "@VMODROOT/c/sdl_main_use_callbacks_shim.h"

// Ported from points.c https://examples.libsdl.org/SDL3/renderer/04-points/

// This example creates an SDL window and renderer, and then draws some points
// to it every frame.
//
// This code is public domain. Feel free to use it for any purpose!

// (track everything as parallel arrays instead of a array of structs,
// so we can pass the coordinates to the renderer in a single function call.)
//
// Points are plotted as a set of X and Y coordinates.
// (0, 0) is the top left of the window, and larger numbers go down
// and to the right. This isn't how geometry works, but this is pretty
// standard in 2D graphics.
//
// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window       &sdl.Window   = unsafe { nil }
	renderer     &sdl.Renderer = unsafe { nil }
	last_time    u64
	points       [num_points]sdl.FPoint
	point_speeds [num_points]f32
}

const window_width = 640
const window_height = 480

const num_points = 500
const min_pixels_per_second = 30 // move at least this many pixels per second.
const max_pixels_per_second = 60 // move this many pixels per second at most.

// This function runs once at startup.
@[export: 'v_sdl_app_init']
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata('Example Renderer Points'.str, '1.0'.str, 'com.example.renderer-points'.str)

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln('Could not initialize SDL: ${error_msg}')
		return .failure
	}

	if !sdl.create_window_and_renderer('examples/renderer/points'.str, window_width, window_height,
		sdl.WindowFlags(0), &app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln('Could not create window/renderer: ${error_msg}')
		return .failure
	}

	// set up the data for a bunch of points.
	for i := 0; i < app.points.len; i++ {
		app.points[i].x = sdl.randf() * f32(window_width)
		app.points[i].y = sdl.randf() * f32(window_height)
		app.point_speeds[i] = min_pixels_per_second +
			(sdl.randf() * (max_pixels_per_second - min_pixels_per_second))
	}

	app.last_time = sdl.get_ticks()

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
	elapsed := f32(now - app.last_time) / f32(1000) // seconds since last iteration

	// let's move all our points a little for a new frame.
	for i := 0; i < app.points.len; i++ {
		distance := elapsed * app.point_speeds[i]
		app.points[i].x += distance
		app.points[i].y += distance
		if app.points[i].x >= window_width || app.points[i].y >= window_height {
			// off the screen; restart it elsewhere!
			if sdl.rand(2) == 1 {
				app.points[i].x = sdl.randf() * window_width
				app.points[i].y = 0.0
			} else {
				app.points[i].x = 0.0
				app.points[i].y = sdl.randf() * window_height
			}
			app.point_speeds[i] = min_pixels_per_second +
				(sdl.randf() * (max_pixels_per_second - min_pixels_per_second))
		}
	}

	app.last_time = now
	// as you can see from this, rendering draws over whatever was drawn before it.
	sdl.set_render_draw_color(app.renderer, 0, 0, 0, sdl.alpha_opaque) // black, full alpha
	sdl.render_clear(app.renderer) // start with a blank canvas.

	sdl.set_render_draw_color(app.renderer, 255, 255, 255, sdl.alpha_opaque) // white, full alpha

	sdl.render_points(app.renderer, &app.points[0], app.points.len) // draw all the points!

	// You can also draw single points with SDL_RenderPoint(), but it's
	// cheaper (sometimes significantly so) to do them all at once.

	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

// This function runs once at shutdown.
@[export: 'v_sdl_app_quit']
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	// SDL will clean up the window/renderer for us.
}
