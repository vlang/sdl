// Copyright(C) 2022 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
//
// Creates a window through SDL2 and load all test images into memory,
// and display them in a grid.
// If an image can not be loaded it may be because the host platform's
// SDL2_image library is not compiled with support for the specific
// image format. A successful test should show 5 images.
module main

import os
import sdl
import sdl.image

const images = ['v-logo.svg', 'v-logo.png', 'v-logo.jpg', 'v-logo.lossless.webp', 'v-logo.webp']

fn get_asset_path(path string) string {
	$if android {
		return os.join_path('images', path)
	} $else {
		return os.resource_abs_path(os.join_path('..', 'assets', 'images', path))
	}
}

fn load_image(path string) !&sdl.Surface {
	asset_path := get_asset_path(path)
	rw := sdl.rw_from_file(asset_path.str, 'rb'.str)
	if rw == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		return error('Could not load image "${path}" RW from mem data: ${error_msg}')
	}
	img := image.load_rw(rw, 1)
	if img == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		return error('Could not load image RW "${path}" data: ${error_msg}')
	}
	return img
}

fn main() {
	println('Const version ${image.major_version}.${image.minor_version}.${image.patchlevel}')
	mut compiled_version := sdl.Version{}
	C.SDL_IMAGE_VERSION(&compiled_version)
	println('Compiled against version ${compiled_version.str()}')
	linked_version := image.linked_version()
	println('Runtime loaded version ${linked_version.major}.${linked_version.minor}.${linked_version.patch}')

	$if debug ? {
		// SDL debug info, must be called before sdl.init
		sdl.log_set_all_priority(sdl.LogPriority.verbose)
	}
	sdl.init(sdl.init_video)
	window := sdl.create_window('Hello SDL2_image'.str, 300, 300, 500, 300, 0)
	renderer := sdl.create_renderer(window, -1, u32(sdl.RendererFlags.accelerated) | u32(sdl.RendererFlags.presentvsync))

	flags := int(image.InitFlags.png)

	image_init_result := image.init(flags)
	if (image_init_result & flags) != flags {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not initialize SDL2_image: ${error_msg}')
	}

	// Hint the render, before creating textures, that we want
	// as high a scale quality as possible. This improves the
	// view quality of most textures when they are scaled down.
	sdl.set_hint(sdl.hint_render_scale_quality.str, '2'.str)

	mut image_textures := []&sdl.Texture{}
	for image in images {
		surface := load_image(image) or {
			eprintln('Loading of image ${image} failed: ${err.msg()}')
			// No panic or exit here. This way the example also
			// serves as a visual test, of what SDL2_image *can* load
			// on this platform.
			continue
		}
		image_textures << sdl.create_texture_from_surface(renderer, surface)
	}

	mut should_close := false
	for {
		evt := sdl.Event{}
		for 0 < sdl.poll_event(&evt) {
			match evt.@type {
				.quit {
					should_close = true
				}
				.keydown {
					key := unsafe { sdl.KeyCode(evt.key.keysym.sym) }
					match key {
						.escape {
							should_close = true
						}
						else {}
					}
				}
				else {}
			}
		}
		if should_close {
			break
		}

		sdl.set_render_draw_color(renderer, 255, 255, 255, 255)
		sdl.render_clear(renderer)

		mut win_w := 0
		sdl.get_window_size(window, win_w, sdl.null)

		// Render images in a grid
		pad := 20 // Padding between each image
		render_dim := 100 // Render the image texture as size "dim x dim"
		cols := int(win_w / (20 + render_dim))
		mut y := pad
		mut x := pad
		mut col := 0
		for texture in image_textures {
			x = pad + (col * (pad + render_dim))
			if x + render_dim > win_w {
				x = pad
				y += pad + render_dim
			}
			mut dstrect := sdl.Rect{x, y, render_dim, render_dim}
			sdl.render_copy(renderer, texture, sdl.null, &dstrect)

			col++
			if col > cols {
				col = 1
			}
		}

		sdl.render_present(renderer)
	}

	for texture in image_textures {
		if !isnil(texture) {
			sdl.destroy_texture(texture)
		}
	}

	sdl.destroy_renderer(renderer)
	sdl.destroy_window(window)
	sdl.quit()
}
