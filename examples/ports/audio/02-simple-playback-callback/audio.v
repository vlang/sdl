// Copyright(C) 2025 Delyan Angelov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
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

fn feed_more(mut app SDLApp, astream &sdl.AudioStream, oadditional_amount int, total_amount int) {
	// total_amount is how much data the audio stream is eating right now, additional_amount is how much more it needs
	// than what it currently has queued (which might be zero!). You can supply any amount of data here; it will take what
	// it needs and use the extra later. If you don't give it enough, it will take everything and then feed silence to the
	// hardware for the rest. Ideally, though, we always give it what it needs and no extra, so we aren't buffering more
	// than necessary
	mut additional_amount := 32 + (oadditional_amount / int(sizeof(f32))) // convert from bytes to samples, with some slack, to prevent cracks with tcc/debug/gc (32 samples is 4ms for a 8000 sampling rate)
	for additional_amount > 0 {
		mut samples := [128]f32{} // this will feed 128 samples each iteration until we have enough
		total := int_min(additional_amount, samples.len)
		// generate a 440Hz pure tone
		for i := 0; i < total; i++ {
			freq := 440
			phase := f32(app.current_sine_sample * freq) / f32(8000)
			samples[i] = sdl.sinf(phase * 2 * f32(sdl.pi_f))
			app.current_sine_sample++
		}
		// wrapping around to avoid floating-point errors
		app.current_sine_sample %= 8000

		// feed the new data to the stream. It will queue at the end, and trickle out as the hardware needs more data
		sdl.put_audio_stream_data(astream, &samples[0], total * int(sizeof(f32)))
		additional_amount -= total // subtract what we've just fed the stream
	}
}

// app_init runs once at startup.
pub fn app_init(appstate &&SDLApp, argc int, argv &&char) sdl.AppResult {
	// Allocate / instantiate the state struct on the heap
	// Hand it over to SDL so it can be retreived in the other App* callbacks
	mut app := &SDLApp{}
	defer {
		unsafe {
			*appstate = app
		}
	}

	sdl.set_app_metadata(c'Example Simple Audio Playback Callbacl', c'1.0', c'com.example.audio-simple-playback-callback')
	if !sdl.init(sdl.init_video | sdl.init_audio) {
		eprintln('Could not initialize SDL: ${sdl.get_error_v()}')
		return .failure
	}
	// we don't _need_ a window for audio-only things but it's good policy to have one.
	if !sdl.create_window_and_renderer(c'examples/audio/simple-playback-callback', 640,
		480, 0, &app.window, &app.renderer) {
		eprintln('Could not create window/renderer: ${sdl.get_error_v()}')
		return .failure
	}
	spec := sdl.AudioSpec{
		channels: 1
		format:   ._f32_1
		freq:     8000
	}
	stream := sdl.open_audio_device_stream(sdl.audio_device_default_playback, &spec, feed_more,
		app)
	if stream == unsafe { C.NULL } {
		eprintln('Could not create audio stream: ${sdl.get_error_v()}')
		return .failure
	}
	app.stream = stream
	// open_audio_device_stream starts the device paused. You have to tell it to resume playing:
	sdl.resume_audio_stream_device(stream)
	return .continue
}

// app_iterate runs once per frame, and is the heart of the program.
pub fn app_iterate(mut app SDLApp) sdl.AppResult {
	// app will be the same state instance, that we initialised in `app_init`
	// sdl.set_render_draw_color_float(app.renderer, 0.5, 0.5, 1.0, sdl.alpha_opaque)
	sdl.render_clear(app.renderer)
	sdl.render_present(app.renderer)
	// all the work of feeding the audio stream is happening in a callback in a background thread
	return .continue
}
