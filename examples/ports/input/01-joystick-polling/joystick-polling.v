// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module no_main

// See also: `examples/ports/template.v` for a simple commented example demonstrating how
// to run via callbacks instead of a `fn main() {}`.
// See also: `examples/ports/README.md` for more information.
import sdl
import sdl.callbacks // use the callbacks instead of main()

fn init() {
	callbacks.on_init(app_init)
	callbacks.on_quit(app_quit)
	callbacks.on_event(app_event)
	callbacks.on_iterate(app_iterate)
}

// Ported from joystick-polling.c https://examples.libsdl.org/SDL3/input/01-joystick-polling/
// NOTE: On some combinations of devices and platforms the events are not always registered
// correctly if the device is plugged in *after* the application has started. To see if this
// affects your application run(s) try and plug a device in *before* running this application.

// This example code looks for the current joystick state once per frame,
// and draws a visual representation of it.
//
// This code is public domain. Feel free to use it for any purpose!

// Joysticks are low-level interfaces: there's something with a bunch of
// buttons, axes and hats, in no understood order or position. This is
// a flexible interface, but you'll need to build some sort of configuration
// UI to let people tell you what button, etc, does what. On top of this
// interface, SDL offers the "gamepad" API, which works with lots of devices,
// and knows how to map arbitrary buttons and such to look like an
// Xbox/PlayStation/etc gamepad. This is easier, and better, for many games,
// but isn't necessarily a good fit for complex apps and hardware. A flight
// simulator, a realistic racing game, etc, might want this interface instead
// of gamepads.

// SDL can handle multiple joysticks, but for simplicity, this program only
// deals with the first stick it sees.

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
	joystick &sdl.Joystick = unsafe { nil }
	colors   [64]sdl.Color
}

// This function runs once at startup.
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata(c'Example Input Joystick Polling', c'1.0', c'com.example.input-joystick-polling')

	if !sdl.init(sdl.init_video | sdl.init_joystick) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer(c'examples/input/joystick-polling', 640, 480, sdl.WindowFlags(0),
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

	for i := 0; i < app.colors.len; i++ {
		app.colors[i].r = u8(sdl.rand(255))
		app.colors[i].g = u8(sdl.rand(255))
		app.colors[i].b = u8(sdl.rand(255))
		app.colors[i].a = 255
	}

	return .continue // carry on with the program!
}

// This function runs when a new event (mouse input, keypresses, etc) occurs.
pub fn app_event(appstate voidptr, event &sdl.Event) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }
	match event.type {
		.quit {
			return .success // end the program, reporting success to the OS.
		}
		.joystick_added {
			// this event is sent for each hotplugged stick, but also each already-connected joystick during SDL_Init().
			if app.joystick == sdl.null { // we don't have a stick yet and one was added, open it!
				app.joystick = sdl.open_joystick(event.jdevice.which)
				if app.joystick == sdl.null {
					error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
					eprintln('Failed to open joystick ID ${event.jdevice.which}: ${error_msg}')
				}
			}
		}
		.joystick_removed {
			if app.joystick != sdl.null && sdl.get_joystick_id(app.joystick) == event.jdevice.which {
				sdl.close_joystick(app.joystick) // our joystick was unplugged.
				app.joystick = sdl.null
			}
		}
		else {}
	}

	return .continue // carry on with the program!
}

// This function runs once per frame, and is the heart of the program.
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }

	mut winw, mut winh := 640, 480
	mut text := c'Plug in a joystick, please.'
	mut x := f32(0)
	mut y := f32(0)

	if app.joystick != sdl.null { // we have a stick opened?
		text = sdl.get_joystick_name(app.joystick)
	}

	sdl.set_render_draw_color(app.renderer, 0, 0, 0, 255)
	sdl.render_clear(app.renderer)
	sdl.get_window_size(app.window, &winw, &winh)

	// note that you can get input as events, instead of polling, which is
	// better since it won't miss button presses if the system is lagging,
	// but often times checking the current state per-frame is good enough,
	// and maybe better if you'd rather _drop_ inputs due to lag.

	if app.joystick != sdl.null { // we have a stick opened?
		size := f32(30.0)
		mut total := 0

		// draw axes as bars going across middle of screen. We don't know if it's an X or Y or whatever axis, so we can't do more than this.
		total = sdl.get_num_joystick_axes(app.joystick)
		y = f32((winh - (total * size)) / 2)
		x = f32(winw) / 2.0
		for i := 0; i < total; i++ {
			color := &app.colors[i % app.colors.len]
			val := f32(sdl.get_joystick_axis(app.joystick, i)) / 32767.0 // make it -1.0f to 1.0f
			dx := x + (val * x)
			dst := sdl.FRect{dx, y, x - sdl.fabsf(dx), size}
			sdl.set_render_draw_color(app.renderer, color.r, color.g, color.b, color.a)
			sdl.render_fill_rect(app.renderer, &dst)
			y += size
		}

		// draw buttons as blocks across top of window. We only know the button numbers, but not where they are on the device.
		total = sdl.get_num_joystick_buttons(app.joystick)
		x = f32((winw - (total * size)) / 2)
		for i := 0; i < total; i++ {
			color := &app.colors[i % app.colors.len]
			dst := sdl.FRect{x, 0.0, size, size}
			if sdl.get_joystick_button(app.joystick, i) {
				sdl.set_render_draw_color(app.renderer, color.r, color.g, color.b, color.a)
			} else {
				sdl.set_render_draw_color(app.renderer, 0, 0, 0, 255)
			}
			sdl.render_fill_rect(app.renderer, &dst)
			sdl.set_render_draw_color(app.renderer, 255, 255, 255, color.a)
			sdl.render_rect(app.renderer, &dst) // outline it
			x += size
		}

		// draw hats across the bottom of the screen.
		total = sdl.get_num_joystick_hats(app.joystick)
		x = (f32((winw - (total * (size * 2.0))) / 2.0)) + (size / 2.0)
		y = f32(winh) - size
		for i := 0; i < total; i++ {
			color := &app.colors[i % app.colors.len]
			thirdsize := size / 3.0
			mut cross := []sdl.FRect{cap: 2}
			cross << sdl.FRect{x, y + thirdsize, size, thirdsize}
			cross << sdl.FRect{x + thirdsize, y, thirdsize, size}
			hat := sdl.get_joystick_hat(app.joystick, i)

			sdl.set_render_draw_color(app.renderer, 90, 90, 90, 255)
			sdl.render_fill_rects(app.renderer, cross.data, cross.len)

			sdl.set_render_draw_color(app.renderer, color.r, color.g, color.b, color.a)

			if (hat & sdl.hat_up) > 0 {
				dst := sdl.FRect{x + thirdsize, y, thirdsize, thirdsize}
				sdl.render_fill_rect(app.renderer, &dst)
			}

			if (hat & sdl.hat_right) > 0 {
				dst := sdl.FRect{x + (thirdsize * 2), y + thirdsize, thirdsize, thirdsize}
				sdl.render_fill_rect(app.renderer, &dst)
			}

			if (hat & sdl.hat_down) > 0 {
				dst := sdl.FRect{x + thirdsize, y + (thirdsize * 2), thirdsize, thirdsize}
				sdl.render_fill_rect(app.renderer, &dst)
			}

			if (hat & sdl.hat_left) > 0 {
				dst := sdl.FRect{x, y + thirdsize, thirdsize, thirdsize}
				sdl.render_fill_rect(app.renderer, &dst)
			}

			x += size * 2
		}
	}

	x = (f32(winw) - (int(sdl.strlen(text)) * sdl.debug_text_font_character_size)) / 2.0
	y = (f32(winh) - sdl.debug_text_font_character_size) / 2.0
	sdl.set_render_draw_color(app.renderer, 255, 255, 255, 255)
	sdl.render_debug_text(app.renderer, x, y, text)
	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

// This function runs once at shutdown.
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	mut app := unsafe { &SDLApp(appstate) }
	if app.joystick != sdl.null {
		sdl.close_joystick(app.joystick)
	}

	// SDL will clean up the window/renderer for us.
}
