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

// Ported from joystick-events.c https://examples.libsdl.org/SDL3/input/02-joystick-events/
// NOTE: On some combinations of devices and platforms the events are not always registered
// correctly if the device is plugged in *after* the application has started. To see if this
// affects your application run(s) try and plug a device in *before* running this application.

// This example code looks for joystick input in the event handler, and
// reports any changes as a flood of info.

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

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window        &sdl.Window   = unsafe { nil }
	renderer      &sdl.Renderer = unsafe { nil }
	colors        [64]sdl.Color
	messages      EventMessage
	messages_tail &EventMessage = unsafe { nil }
}

const motion_event_cooldown = 40

struct EventMessage {
mut:
	str         &char = unsafe { nil }
	color       sdl.Color
	start_ticks u64
	next        &EventMessage = unsafe { nil }
}

fn hat_state_string(state u8) string {
	return match state {
		sdl.hat_centered { 'CENTERED' }
		sdl.hat_up { 'UP' }
		sdl.hat_right { 'RIGHT' }
		sdl.hat_down { 'DOWN' }
		sdl.hat_left { 'LEFT' }
		sdl.hat_rightup { 'RIGHT+UP' }
		sdl.hat_rightdown { 'RIGHT+DOWN' }
		sdl.hat_leftup { 'LEFT+UP' }
		sdl.hat_leftdown { 'LEFT+DOWN' }
		else { 'UNKNOWN' }
	}
}

fn battery_state_string(state sdl.PowerState) string {
	return match state {
		.error { 'ERROR' }
		.on_battery { 'ON BATTERY' }
		.no_battery { 'NO BATTERY' }
		.charging { 'CHARGING' }
		.charged { 'CHARGED' }
		else { 'UNKNOWN' }
	}
}

fn (mut app SDLApp) add_message(jid sdl.JoystickID, message string) {
	color := &app.colors[usize(jid) % usize(app.colors.len)]

	msg := &EventMessage{
		str:         message.str
		color:       color
		start_ticks: sdl.get_ticks()
		next:        &EventMessage(unsafe { nil })
	}
	app.messages_tail.next = msg
	app.messages_tail = msg
}

// This function runs once at startup.
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	app.messages_tail = &app.messages
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata(c'Example Input Joystick Events', c'1.0', c'com.example.input-joystick-events')

	if !sdl.init(sdl.init_video | sdl.init_joystick) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer(c'examples/input/joystick-events', 640, 480, sdl.WindowFlags(0),
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

	app.colors[0].r, app.colors[0].g, app.colors[0].b, app.colors[0].a = 255, 255, 255, 255
	for i := 1; i < app.colors.len; i++ {
		app.colors[i].r = u8(sdl.rand(255))
		app.colors[i].g = u8(sdl.rand(255))
		app.colors[i].b = u8(sdl.rand(255))
		app.colors[i].a = 255
	}

	app.add_message(sdl.JoystickID(0), 'Please plug in a joystick.')

	return .continue // carry on with the program!
}

// This function runs when a new event (mouse input, keypresses, etc) occurs.
@[unsafe]
pub fn app_event(appstate voidptr, event &sdl.Event) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }

	match event.type {
		.quit {
			return .success // end the program, reporting success to the OS.
		}
		.joystick_added {
			// this event is sent for each hotplugged stick, but also each already-connected joystick during SDL_Init().
			which := event.jdevice.which
			joystick := sdl.open_joystick(which)
			if joystick == sdl.null {
				error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
				app.add_message(which, 'Joystick #${which} added, but not opened: ${error_msg}')
			} else {
				joystick_name := unsafe { cstring_to_vstring(sdl.get_joystick_name(joystick)) }
				app.add_message(which, "Joystick #${which} ('${joystick_name}') added")
			}
		}
		.joystick_removed {
			which := event.jdevice.which
			joystick := sdl.get_joystick_from_id(which)
			if joystick != sdl.null {
				sdl.close_joystick(joystick) // the joystick was unplugged.
			}
			app.add_message(which, 'Joystick #${which} removed')
		}
		.joystick_axis_motion {
			mut static axis_motion_cooldown_time := u64(0) // these are spammy, only show every X milliseconds.
			now := sdl.get_ticks()
			if now >= axis_motion_cooldown_time {
				which := event.jaxis.which
				axis_motion_cooldown_time = now + motion_event_cooldown
				app.add_message(which, 'Joystick #${which} axis ${event.jaxis.axis} -> ${event.jaxis.value}')
			}
		}
		.joystick_ball_motion {
			mut static ball_motion_cooldown_time := u64(0) // these are spammy, only show every X milliseconds.
			now := sdl.get_ticks()
			if now >= ball_motion_cooldown_time {
				which := event.jball.which
				ball_motion_cooldown_time = now + motion_event_cooldown
				app.add_message(which, 'Joystick #${which} ball ${event.jball.ball} -> ${event.jball.xrel}, ${event.jball.yrel}')
			}
		}
		.joystick_hat_motion {
			which := event.jhat.which
			app.add_message(which, 'Joystick #${which} hat ${event.jhat.hat} -> ${event.jhat.value}')
		}
		.joystick_button_up, .joystick_button_down {
			which := event.jbutton.which
			up_down := if event.jbutton.down { 'PRESSED' } else { 'RELEASED' }
			app.add_message(which, 'Joystick #${which} button ${event.jbutton.button} -> ${up_down}')
		}
		.joystick_battery_updated {
			which := event.jbattery.which
			app.add_message(which, 'Joystick #${which} battery -> ${event.jbattery.state} - ${event.jbattery.percent}%')
		}
		else {}
	}

	return .continue // carry on with the program!
}

// This function runs once per frame, and is the heart of the program.
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }

	now := sdl.get_ticks()
	msg_lifetime := f32(3500.0) // milliseconds a message lives for.
	mut msg := app.messages.next
	mut prev_y := 0.0
	mut winw, mut winh := 640, 480

	sdl.set_render_draw_color(app.renderer, 0, 0, 0, 255)
	sdl.render_clear(app.renderer)
	sdl.get_window_size(app.window, &winw, &winh)

	for msg != sdl.null {
		mut x, mut y := f32(0), f32(0)
		life_percent := f32((now - msg.start_ticks)) / msg_lifetime
		if life_percent >= 1.0 { // msg is done.
			app.messages.next = msg.next
			if app.messages_tail == msg {
				app.messages_tail = &app.messages
			}
			unsafe { free(msg) }
			msg = app.messages.next
			continue
		}
		x = (f32(winw) - (sdl.strlen(msg.str) * usize(sdl.debug_text_font_character_size))) / 2.0
		y = f32(winh) * life_percent
		if prev_y != 0.0 && (prev_y - y) < f32(sdl.debug_text_font_character_size) {
			msg.start_ticks = now
			break // wait for the previous message to tick up a little.
		}

		sdl.set_render_draw_color(app.renderer, msg.color.r, msg.color.g, msg.color.b,
			u8(f32(msg.color.a) * (1.0 - life_percent)))
		sdl.render_debug_text(app.renderer, x, y, msg.str)

		prev_y = y
		msg = msg.next
	}

	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

// This function runs once at shutdown.
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	// SDL will clean up the window/renderer for us. We let the joysticks leak.
}
