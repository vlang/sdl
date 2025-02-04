module main

import sdl

struct SDLApp {
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
}

fn main() {
	mut app := SDLApp{}

	sdl.init(sdl.init_video | sdl.init_events)

	if !sdl.create_window_and_renderer('Hello SDL3'.str, 500, 300, sdl.WindowFlags(0),
		&app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not create SDL window and renderer. SDL error:\n${error_msg}')
	}

	mut should_close := false
	for {
		evt := sdl.Event{}
		for sdl.poll_event(&evt) {
			match evt.type {
				.quit {
					should_close = true
				}
				.key_down {
					key := unsafe { sdl.KeyCode(evt.key.key) }
					match key {
						.escape { should_close = true }
						else {}
					}
				}
				else {}
			}
		}
		if should_close {
			break
		}

		sdl.set_render_draw_color(app.renderer, 255, 55, 55, sdl.alpha_opaque)
		sdl.render_clear(app.renderer)
		sdl.render_present(app.renderer)
	}

	sdl.destroy_renderer(app.renderer)
	sdl.destroy_window(app.window)
	sdl.quit()
}
