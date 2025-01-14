/**
	This program is about D2Q9 Lattice Boltzmann Method:
	See : https://en.wikipedia.org/wiki/Lattice_Boltzmann_methods

	It's a pet project in order to use V language: https://vlang.io/

	The simulation is single threaded, probably buggy and should not be used
    for serious things.  It's very sensible to tau parameter that should be
    carefully set. This parameter is related to fluid viscosity, and is set so
    that the fluid speed doesn't exceed a speed limit that breaks simulation.
    Too narrow passage (speed increased) may reach this limit.

    profiles files MUST be of the same size of defined width and weight and
    should be 8bits per pixels. Every non zero value is considered as an
    obstacle.

    to compile the program from within source directory:

    v -prod .

	or if you want gcc as compiler:

    v -prod -cc gcc .

	SDL module must be installed: https://vpm.vlang.io/packages/sdl
	and post install script executed, see link.

	The simulation is quite slow, but would you like to slow it down, just
 	uncomment the sdl.delay(...) in file.



    This program is released under MIT license.
 */
module main

import sdl
import sdl.image as img
import os
import time

const tau = 0.6 // Relaxation time, related to fluid viscosity.
const rho0 = 32.0 // Average normalised density.
const width = 512
const height = 128
const len_in_bytes = width * height * sizeof(u32)
const obstacle_color = u32(0xFF004000)
const low_color = u32(0xFFFFFF00)
const middle_color = u32(0xFF000000)
const high_color = u32(0xFF00FFFF)

// Type for rendering methods, used as parameter.
type Renderer = fn (l Lattice, cm []u32, mut output []u32)

const renderers = [vorticity, v_speed, h_speed, densities]
const renderers_names = ['vorticity', 'vertical speed', 'horizontal speed', 'density']

fn main() {
	argv := os.args.len

	if argv != 2 {
		println('Usage: lbm profile_file.png')
		println('       e.g:  ./lbm profiles/circle.png')
		println('During simulation press "v" to show different parameters.')
		return
	}

	if sdl.init(sdl.init_video) < 0 {
		eprintln('sdl.init() error: ${unsafe { cstring_to_vstring(sdl.get_error()) }}')
		return
	}

	flags := u32(sdl.WindowFlags.opengl) | u32(sdl.WindowFlags.resizable)
	window := sdl.create_window(c'Lattice Boltzmann Method [D2Q9]', sdl.windowpos_centered,
		sdl.windowpos_centered, width * 2, height * 2, flags)

	if window == sdl.null {
		eprintln('sdl.create_window() error: ${unsafe { cstring_to_vstring(sdl.get_error()) }}')
		return
	}

	r_flags := u32(sdl.RendererFlags.accelerated)
	renderer := sdl.create_renderer(window, -1, r_flags)

	if renderer == sdl.null {
		eprintln('sdl.create_renderer() error: ${unsafe { cstring_to_vstring(sdl.get_error()) }}')
		return
	}

	mut tex := sdl.create_texture(renderer, sdl.Format.argb8888, sdl.TextureAccess.streaming,
		width, height)

	if tex == sdl.null {
		eprintln('sdl.create_texture() error: ${unsafe { cstring_to_vstring(sdl.get_error()) }}')
		return
	}

	defer {
		sdl.destroy_texture(tex)
		sdl.destroy_renderer(renderer)
		sdl.destroy_window(window)
	}

	profile := img.load(os.args[1].str)
	if profile == sdl.null {
		eprintln('Error trying to load profile .png file: ${unsafe { cstring_to_vstring(sdl.get_error()) }}')
		return
	}

	// Check size compatibility.
	if profile.w != width || profile.h != height {
		eprintln('Error, "${os.args[1]}" profile image must match lbm lattice size : ${profile.w}x${profile.h}')
		return
	}

	// Check profile is 1 byte / pixel.
	if (profile.pitch / width) != 1 {
		eprintln('Error profile file must be 1 byte per pixel')
		return
	}

	// Build a colormap to be used
	cm := Colormap.dual(low_color, middle_color, high_color, 384)

	// Now create Lattices, with respect to loaded profile.
	mut src := Lattice.new(width, height, profile.pixels)

	src.add_flow(1.0, Vi.east)
	src.randomize(0.2)
	src.normalize()

	mut dst := Lattice.new(width, height, profile.pixels)

	// Allocate pixel buffer to draw in.
	mut pixel_buffer := []u32{len: width * height} // Dyn array heap allocated.

	mut should_close := false
	mut frame := 0
	mut render_method := vorticity

	println('Showing vorticiy. Press "v" to show different parameters.')

	for {
		evt := sdl.Event{}
		for 0 < sdl.poll_event(&evt) {
			match evt.@type {
				.quit {
					should_close = true
				}
				.keydown {
					key := unsafe { sdl.KeyCode(evt.key.keysym.sym) }
					if key == sdl.KeyCode.escape {
						should_close = true
						break
					}
					// Show next view
					if key == sdl.KeyCode.v {
						mut i := renderers.index(render_method)
						i++
						if i >= renderers.len {
							i = 0
						}
						render_method = renderers[i]
						println('Rendering : ${renderers_names[i]}')
					}
				}
				else {}
			}
		}
		if should_close {
			break
		}

		mut stop_watch := time.new_stopwatch()
		src.move(mut dst)
		dst.collide()
		render_method(dst, cm, mut pixel_buffer) // render_method can point different method !
		draw_colormap(cm, mut pixel_buffer)

		// swap src and dst buffers.
		tmp := src
		src = dst
		dst = tmp

		blit_pixels(tex, pixel_buffer)
		frame++
		stop_watch.stop()
		// println('Frame ${frame}, loop : ${stop_watch.elapsed().milliseconds()} milliseconds. ')

		sdl.render_clear(renderer)
		sdl.render_copy(renderer, tex, sdl.null, sdl.null)
		sdl.render_present(renderer)
		// sdl.delay(10)
	}
}

// No bound checking here
// blit_pixels from buffer to texture.
@[direct_array_access]
fn blit_pixels(t &sdl.Texture, data []u32) {
	mut pixels := unsafe { voidptr(nil) }
	mut pitch := int(0)

	success := sdl.lock_texture(t, sdl.null, &pixels, &pitch)
	if success < 0 {
		panic('sdl.lock_texture error: ${sdl.get_error()}')
	}
	unsafe { vmemcpy(pixels, data.data, len_in_bytes) }
	sdl.unlock_texture(t)
}

fn draw_colormap(cm []u32, mut data []u32) {
	data[0] = 0xFF000000
	data[width] = 0xFF000000
	data[2 * width] = 0xFF000000
	for i in 0 .. cm.len {
		data[i + 1] = 0xFF000000
		data[i + width + 1] = cm[i]
		data[i + 1 + 2 * width] = 0xFF000000
	}
	data[cm.len] = 0xFF000000
	data[width + cm.len] = 0xFF000000
	data[2 * width + cm.len] = 0xFF000000
}

// densities is a Renderer type function
fn densities(l Lattice, cm []u32, mut output []u32) {
	mut ind := 0

	min_rho := l.min_rho()
	max_rho := l.max_rho()
	linear := (max_rho - min_rho) / (cm.len - 1)

	for c in l.m {
		if c.obstacle == true {
			output[ind] = obstacle_color
			ind++
			continue
		}

		rho := int((c.rho() - min_rho) / linear)
		output[ind] = cm[rho]
		ind++
	}
}

// h_speed is a Renderer type function
fn h_speed(l Lattice, cm []u32, mut output []u32) {
	mut ind := 0

	min_ux := l.min_ux()
	max_ux := l.max_ux()
	linear := (max_ux - min_ux) / (cm.len - 1)

	for c in l.m {
		if c.obstacle == true {
			output[ind] = obstacle_color
			ind++
			continue
		}

		rho := int((c.ux() - min_ux) / linear)
		output[ind] = cm[rho]
		ind++
	}
}

// h_speed is a Renderer type function
fn v_speed(l Lattice, cm []u32, mut output []u32) {
	mut ind := 0

	min_uy := l.min_uy()
	max_uy := l.max_uy()
	linear := (max_uy - min_uy) / (cm.len - 1)

	for c in l.m {
		if c.obstacle == true {
			output[ind] = obstacle_color
			ind++
			continue
		}

		rho := int((c.uy() - min_uy) / linear)
		output[ind] = cm[rho]
		ind++
	}
}

// vorticity is a Renderer type function
fn vorticity(l Lattice, cm []u32, mut output []u32) {
	mut min := 0.0
	mut max := 0.0
	cm2 := u32(cm.len / 2)
	mut vorticity_table := []f64{len: l.w * l.h}

	for y in 0 .. l.h {
		for x in 0 .. l.w {
			out := (y * l.w) + x
			if l.m[out].obstacle {
				vorticity_table[out] = -1000000.0
			} else {
				v := l.vorticity(x, y)
				vorticity_table[out] = v
				if min > v {
					min = v
				}
				if max < v {
					max = v
				}
			}
		}
	}

	linear := (max - min) / f64(cm.len - 1)

	for ind, v in vorticity_table {
		if v < -100.0 {
			output[ind] = obstacle_color
		} else {
			mut id := cm2 + u32(v / linear)

			if id < 0 {
				id = 0
			} else if id >= cm.len {
				id = u32(cm.len - 1)
			}
			output[ind] = cm[id]
		}
	}
}
