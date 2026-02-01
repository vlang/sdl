// Copyright(C) 2026 Delyan Angelov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module main

import os
import sdl
import sdl.mixer as mix

fn main() {
	if os.args.len < 2 {
		eprintln('Usage: ${os.args[0]} <audio-file> [audio-file ...]')
		return
	}

	if !sdl.init(sdl.init_audio) {
		eprintln('Could not initialize SDL: ${sdl.get_error_v()}')
		return
	}
	defer { sdl.quit() }

	if !mix.init() {
		eprintln('Could not initialize SDL_mixer: ${sdl.get_error_v()}')
		return
	}
	defer { mix.quit() }

	mixer := mix.create_mixer_device(sdl.audio_device_default_playback, sdl.null)
	if mixer == sdl.null {
		eprintln('Could not open audio device: ${sdl.get_error_v()}')
		return
	}
	defer { mix.destroy_mixer(mixer) }

	track := mix.create_track(mixer)
	if track == sdl.null {
		eprintln('Could not create track: ${sdl.get_error_v()}')
		return
	}
	defer { mix.destroy_track(track) }

	for i := 1; i < os.args.len; i++ {
		path := os.args[i]
		if !os.exists(path) {
			eprintln('Skipping missing file: ${path}')
			continue
		}

		println('Playing ${path}')
		audio := mix.load_audio(mixer, path.str, true)
		if audio == sdl.null {
			eprintln('Failed to load ${path}: ${sdl.get_error_v()}')
			continue
		}

		_ := mix.stop_track(track, 0)
		if !mix.set_track_audio(track, audio) {
			eprintln('Failed to set track for ${path}: ${sdl.get_error_v()}')
			mix.destroy_audio(audio)
			continue
		}

		if !mix.play_track(track, sdl.PropertiesID(0)) {
			eprintln('Failed to play ${path}: ${sdl.get_error_v()}')
			mix.destroy_audio(audio)
			continue
		}

		for mix.track_playing(track) {
			sdl.delay(25)
		}

		mix.destroy_audio(audio)
	}
}
