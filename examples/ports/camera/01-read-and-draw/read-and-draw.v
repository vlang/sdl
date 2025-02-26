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

// Ported from read-and-draw.c https://examples.libsdl.org/SDL3/camera/01-read-and-draw/

// This example code reads frames from a camera and draws it to the screen.
//
// This is a very simple approach that is often Good Enough. You can get
// fancier with this: multiple cameras, front/back facing cameras on phones,
// color spaces, choosing formats and framerates...this just requests
// _anything_ and goes with what it is handed.
//
// This code is public domain. Feel free to use it for any purpose!

// We will use this renderer to draw into this window every frame.
struct SDLApp {
mut:
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
	camera   &sdl.Camera   = unsafe { nil }
	texture  &sdl.Texture  = unsafe { nil }
}

// This function runs once at startup.
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata(c'Example Camera Read and Draw', c'1.0', c'com.example.camera-read-and-draw')

	if !sdl.init(sdl.init_video | sdl.init_camera) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't initialize SDL: ${error_msg}")
		return .failure
	}

	if !sdl.create_window_and_renderer(c'examples/camera/read-and-draw', 640, 480, sdl.WindowFlags(0),
		&app.window, &app.renderer) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't create window/renderer: ${error_msg}")
		return .failure
	}

	mut devcount := 0
	devices := sdl.get_cameras(&devcount)
	if devices == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't enumerate camera devices: ${error_msg}")
		return .failure
	} else if devcount == 0 {
		eprintln("Couldn't find any camera devices! Please connect a camera and try again.")
		return .failure
	}

	app.camera = sdl.open_camera(unsafe { devices[0] }, sdl.null) // just take the first thing we see in any format it wants.
	sdl.free(devices)
	if app.camera == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		eprintln("Couldn't open camera: ${error_msg}")
		return .failure
	}

	return .continue // carry on with the program!
}

// This function runs when a new event (mouse input, keypresses, etc) occurs.
pub fn app_event(appstate voidptr, event &sdl.Event) sdl.AppResult {
	match event.type {
		.quit {
			return .success // end the program, reporting success to the OS.
		}
		.camera_device_approved {
			eprintln('Camera use approved by user!')
		}
		.camera_device_denied {
			eprintln('Camera use denied by user!')
		}
		else {}
	}
	return .continue // carry on with the program!
}

// This function runs once per frame, and is the heart of the program.
pub fn app_iterate(appstate voidptr) sdl.AppResult {
	mut app := unsafe { &SDLApp(appstate) }

	timestamp_ns := u64(0)
	frame := sdl.acquire_camera_frame(app.camera, &timestamp_ns)

	if frame != sdl.null {
		// Some platforms (like Emscripten) don't know _what_ the camera offers
		// until the user gives permission, so we build the texture and resize
		// the window when we get a first frame from the camera.
		if app.texture == sdl.null {
			sdl.set_window_size(app.window, frame.w, frame.h) // Resize the window to match
			app.texture = sdl.create_texture(app.renderer, frame.format, .streaming, frame.w,
				frame.h)
		}
		if app.texture != sdl.null {
			sdl.update_texture(app.texture, sdl.null, frame.pixels, frame.pitch)
		}

		sdl.release_camera_frame(app.camera, frame)
	}

	sdl.set_render_draw_color(app.renderer, 0x99, 0x99, 0x99, sdl.alpha_opaque)
	sdl.render_clear(app.renderer)
	if app.texture != sdl.null { // draw the latest camera frame, if available.
		sdl.render_texture(app.renderer, app.texture, sdl.null, sdl.null)
	}
	sdl.render_present(app.renderer) // put it all on the screen!

	return .continue // carry on with the program!
}

// This function runs once at shutdown.
pub fn app_quit(appstate voidptr, result sdl.AppResult) {
	mut app := unsafe { &SDLApp(appstate) }
	sdl.close_camera(app.camera)
	sdl.destroy_texture(app.texture)
	// SDL will clean up the window/renderer for us.
}
