module main

import sdl

fn main() {
	init(init_video)
	window := create_window('Hello SDL2'.str, 300, 300, 500, 300, 0)
	renderer := create_renderer(window, -1, u32(RendererFlags.accelerated) | u32(RendererFlags.presentvsync))

	mut should_close := false
	for {
		evt := Event{}
		for 0 < poll_event(&evt) {
			match evt.@type {
				.quit { should_close = true }
				else {}
			}
		}
		if should_close {
			break
		}

		set_render_draw_color(renderer, 255, 55, 55, 255)
		render_clear(renderer)
		render_present(renderer)
	}

	destroy_renderer(renderer)
	destroy_window(window)
	quit()
}
