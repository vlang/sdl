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
	callbacks.on_quit(app_quit)
	callbacks.on_event(app_event)
	callbacks.on_iterate(app_iterate)
}

// Ported from drawing-lines.c https://examples.libsdl.org/SDL3/pen/01-drawing-lines/

// This example code reads pen/stylus input and draws lines. Darker lines
// for harder pressure.
//
// SDL can track multiple pens, but for simplicity here, this assumes any
// pen input we see was from one device.
//
// This code is public domain. Feel free to use it for any purpose!

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window           &sdl.Window   = unsafe { nil }
	renderer         &sdl.Renderer = unsafe { nil }
	render_target    &sdl.Texture  = unsafe { nil }
	pressure         f32
	previous_touch_x f32 = -1.0
	previous_touch_y f32 = -1.0
	tilt_x           f32
	tilt_y           f32
}

// This function runs once at startup.
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata(c'Example Pen Drawing Lines', c'1.0', c'com.example.pen-drawing-lines')

	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer(c'examples/pen/drawing-lines', 640, 480, sdl.WindowFlags(0),
		&app.window, &app.renderer) {
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

	// we make a render target so we can draw lines to it and not have to record and redraw every pen stroke each frame.
	// Instead rendering a frame for us is a single texture draw.

	// make sure the render target matches output size (for hidpi displays, etc) so drawing matches the pen's position on a tablet display.
	mut w, mut h := 0, 0
	sdl.get_render_output_size(app.renderer, &w, &h)
	app.render_target = sdl.create_texture(app.renderer, .rgba8888, .target, w, h)
	if app.render_target == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create render target: ${error_msg}")
		return .failure
	}

	// just blank the render target to gray to start.
	sdl.set_render_target(app.renderer, app.render_target)
	sdl.set_render_draw_color(app.renderer, 100, 100, 100, sdl.alpha_opaque)
	sdl.render_clear(app.renderer)
	sdl.set_render_target(app.renderer, sdl.null)
	sdl.set_render_draw_blend_mode(app.renderer, sdl.blendmode_blend)

	return .continue // carry on with the program!
}

// This function runs when a new event (mouse input, keypresses, etc) occurs.
pub fn app_event(appstate voidptr, event &sdl.Event) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }
	match event.type {
		.quit {
			return .success // end the program, reporting success to the OS.
		}
		// There are several events that track the specific stages of pen activity,
		//  but we're only going to look for motion and pressure, for simplicity.
		.pen_motion {
			// you can check for when the pen is touching, but if pressure > 0.0f, it's definitely touching!
			if app.pressure > 0.0 {
				if app.previous_touch_x >= 0.0 { // only draw if we're moving while touching
					// draw with the alpha set to the pressure, so you effectively get a fainter line for lighter presses.
					sdl.set_render_target(app.renderer, app.render_target)
					sdl.set_render_draw_color_float(app.renderer, 0, 0, 0, app.pressure)
					sdl.render_line(app.renderer, app.previous_touch_x, app.previous_touch_y,
						event.pmotion.x, event.pmotion.y)
				}
				app.previous_touch_x = event.pmotion.x
				app.previous_touch_y = event.pmotion.y
			} else {
				app.previous_touch_x, app.previous_touch_y = -1.0, -1.0
			}
		}
		.pen_axis {
			match event.paxis.axis {
				.pressure {
					app.pressure = event.paxis.value // remember new pressure for later draws.
				}
				.xtilt {
					app.tilt_x = event.paxis.value
				}
				.ytilt {
					app.tilt_y = event.paxis.value
				}
				else {}
			}
		}
		else {}
	}

	return .continue // carry on with the program!
}

// This function runs once per frame, and is the heart of the program.
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }

	// make sure we're drawing to the window and not the render target
	sdl.set_render_target(app.renderer, sdl.null)
	sdl.set_render_draw_color(app.renderer, 0, 0, 0, sdl.alpha_opaque)
	sdl.render_clear(app.renderer) // just in case.
	sdl.render_texture(app.renderer, app.render_target, sdl.null, sdl.null)
	sdl.render_debug_text(app.renderer, 0, 8, 'Tilt: ${app.tilt_x} ${app.tilt_y}'.str)
	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

// This function runs once at shutdown.
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	mut app := unsafe { &SDLApp(appstate) }
	sdl.destroy_texture(app.render_target)
	// SDL will clean up the window/renderer for us.
}
