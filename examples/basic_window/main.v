module main

import sdl

fn main() {
	sdl.init(sdl.init_video)
	window := sdl.create_window('Hello SDL2'.str, 300, 300, 500, 300, 0)
	renderer := sdl.create_renderer(window, -1, u32(sdl.RendererFlags.accelerated) | u32(sdl.RendererFlags.presentvsync))

	mut should_close := false
	for {
		evt := sdl.Event{}
		for 0 < sdl.poll_event(&evt) {
			match evt.@type {
				.quit { should_close = true }
				else {}
			}
		}
		if should_close {
			break
		}

		sdl.set_render_draw_color(renderer, 255, 55, 55, 255)
		sdl.render_clear(renderer)
		sdl.render_present(renderer)
	}

	sdl.destroy_renderer(renderer)
	sdl.destroy_window(window)
	sdl.quit()
}
