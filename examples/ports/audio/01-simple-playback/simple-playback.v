// Copyright(C) 2025 Delyan Angelov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
// This is a port of https://examples.libsdl.org/SDL3/audio/01-simple-playback/
module no_main

import sdl
import sdl.callbacks

fn init() {
	callbacks.on_init(app_init)
	callbacks.on_iterate(app_iterate)
}

// SDLApp is dedicated to holding the state of the application
struct SDLApp {
	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
mut:
	stream              &sdl.AudioStream = unsafe { nil }
	current_sine_sample int
}

// app_init runs once at startup.
pub fn app_init(appstate &&SDLApp, argc int, argv &&char) sdl.AppResult {
	// Allocate / instantiate the state struct on the heap
	// Hand it over to SDL so it can be retreived in the other App* callbacks
	mut app := &SDLApp{}
	unsafe {
		*appstate = app
	}
	sdl.set_app_metadata(c'Example Audio Simple Playback', c'1.0', c'com.example.audio-simple-playback')
	if !sdl.init(sdl.init_video | sdl.init_audio) {
		eprintln('Could not initialize SDL: ${sdl.get_error_v()}')
		return .failure
	}
	if !sdl.create_window_and_renderer(c'examples/audio/simple-playback', 640, 480, 0,
		&app.window, &app.renderer) {
		eprintln('Could not create window/renderer: ${sdl.get_error_v()}')
		return .failure
	}
	sdl.set_render_v_sync(app.renderer, 1) // Note: commenting this will cause app_iterate to be called as fast as possible, which leads to much higher CPU usage - 4-5% or more.
	// As it is, with this call, the CPU usage should be around 0.25% on Linux for i3-3225, for a monitor with refresh rate of 60Hz
	spec := sdl.AudioSpec{
		channels: 1
		format:   ._f32_1
		freq:     8000
	}
	app.stream = sdl.open_audio_device_stream(sdl.audio_device_default_playback, &spec,
		sdl.null, sdl.null)
	if app.stream == sdl.null {
		eprintln('Could not create audio stream: ${sdl.get_error_v()}')
		return .failure
	}
	// open_audio_device_stream starts the device paused. You have to tell it to resume playing:
	sdl.resume_audio_stream_device(app.stream)
	return .continue // carry on with the program!
}

const minimum_audio = 8000 * int(sizeof(f32)) / 2 // 8000 float samples per second. Half of that.
// app_iterate runs once per frame, and is the heart of the program.
// Note: `app` will be the same state instance, that we initialised in `app_init`
@[unsafe]
pub fn app_iterate(mut app SDLApp) sdl.AppResult {
	// see if we need to feed the audio stream more data yet.
	// We're being lazy here, but if there's less than half a second queued, generate more.
	// A sine wave is unchanging audio--easy to stream--but for video games, you'll want
	// to generate significantly _less_ audio ahead of time!
	if sdl.get_audio_stream_available(app.stream) < minimum_audio {
		mut static samples := [512]f32{} // this will feed 512 samples each frame until we get to our maximum.
		// generate a 440Hz pure tone
		for i := 0; i < samples.len; i++ {
			freq := 440
			phase := f32(app.current_sine_sample * freq) / f32(8000)
			samples[i] = sdl.sinf(phase * 2 * f32(sdl.pi_f))
			app.current_sine_sample++
		}
		// wrapping around to avoid floating-point errors
		app.current_sine_sample %= 8000
		// feed the new data to the stream. It will queue at the end, and trickle out as the hardware needs more data.
		sdl.put_audio_stream_data(app.stream, &samples[0], int(sizeof(samples)))
	}
	// we're not doing anything with the renderer, so just blank it out
	sdl.render_clear(app.renderer)
	sdl.render_present(app.renderer)
	// all the work of feeding the audio stream is happening in a callback in a background thread
	return .continue // carry on with the program!
}
