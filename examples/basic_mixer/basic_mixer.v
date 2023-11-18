// Copyright(C) 2022 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
//
// Creates a window through SDL2 and load test sounds into memory,
// and play them back in a loop on finger tab or mouse click (left/right cycles back and forth).
// sound_01.wav          - is a range copied from https://freesound.org/people/Erokia/sounds/414245 by Eroika and is licensed under the Attribution 4.0 License.
// sound_02.mp3          - is a range copied from https://freesound.org/people/haldigital97/sounds/241824 and is in the public domain.
// sound_03.flac         - is a range copied from https://freesound.org/people/taavhaap/sounds/528661 by taavhaap and is licensed under the Attribution 3.0 License.
// sound_04.ogg          - is a range copied from https://freesound.org/people/ShortRecord/sounds/575382 by ShortRecord and is licensed under the Creative Commons 0 License.
// TwintrisThosenine.mod - for info see examples/tvintris/README.md
// IcyGarden.mid         - is downloaded from https://opengameart.org/content/original-midi-album by "Roppy Chop Studios" and is licensed under the CC0 / in the public domain.
module main

import os
import sdl
import sdl.mixer

const (
	wav_sound = 'sounds/sound_01.wav'
	sounds    = ['sounds/sound_02.mp3', 'sounds/sound_03.flac', 'sounds/sound_04.ogg',
		'sounds/TwintrisThosenine.mod', 'sounds/IcyGarden.mid']
)

struct PlayCycle {
pub mut:
	cycle int
	music map[string]&mixer.Music
}

fn (mut pc PlayCycle) next() {
	pc.cycle++
	music_keys := pc.music.keys()
	if pc.cycle > music_keys.len {
		pc.cycle = 0
	}
	if pc.cycle == 0 {
		mixer.halt_music()
		return
	}
	music_key := music_keys[pc.cycle - 1]
	music := pc.music[music_key] or { panic('Music sound "${music_key}" could not be found') }
	if mixer.play_music(music, -1) == -1 {
		mixer.free_music(music)
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Music sound "${music_key}" could not be played: ${error_msg}')
	}
	println('Playing "${music_key}"')
}

fn (mut pc PlayCycle) previous() {
	pc.cycle--
	music_keys := pc.music.keys()
	if pc.cycle == 0 {
		mixer.halt_music()
		return
	}
	if pc.cycle < 0 {
		pc.cycle = music_keys.len
	}
	music_key := music_keys[pc.cycle - 1]
	music := pc.music[music_key] or { panic('Music sound "${music_key}" could not be found') }
	if mixer.play_music(music, -1) == -1 {
		mixer.free_music(music)
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Music sound "${music_key}" could not be played: ${error_msg}')
	}
	println('Playing "${music_key}"')
}

fn get_asset_path(path string) string {
	$if android {
		return path
	} $else {
		return os.resource_abs_path(os.join_path('..', 'assets', path))
	}
}

fn load_wav(path string) !&mixer.Chunk {
	asset_path := get_asset_path(path)
	rw := sdl.rw_from_file(asset_path.str, 'rb'.str)
	if rw == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		return error('Could not create wav "${path}" RW from mem data: ${error_msg}')
	}
	wav := mixer.load_wav_rw(rw, 1)
	if wav == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		return error('Could not load wav RW "${path}" data: ${error_msg}')
	}
	return wav
}

fn load_mus(path string) !&mixer.Music {
	asset_path := get_asset_path(path)
	rw := sdl.rw_from_file(asset_path.str, 'rb'.str)
	if rw == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		return error('Could not create music "${path}" RW from mem data: ${error_msg}')
	}
	mus := mixer.load_mus_rw(rw, 1)
	if mus == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		return error('Could not load music RW "${path}" data: ${error_msg}')
	}
	return mus
}

// [console] is needed on Windows to keep the terminal open
// after launch - so people can see the output we write in it.
// We output to terminal to prevent depending on e.g. sdl.tff, in case
// it doesn't work or is broken - it then become easier to
// diagnose any potential library problems a setup might have.
@[console]
fn main() {
	println('Const version ${mixer.major_version}.${mixer.minor_version}.${mixer.patchlevel}')
	mut compiled_version := sdl.Version{}
	mixer.mixer_version(&compiled_version)
	println('Compiled against version ${compiled_version.str()}')
	linked_version := mixer.linked_version()
	println('Runtime loaded version ${linked_version.major}.${linked_version.minor}.${linked_version.patch}')

	$if debug ? {
		// SDL debug info, must be called before sdl.init
		sdl.log_set_all_priority(sdl.LogPriority.debug)
	}
	if sdl.init(sdl.init_video | sdl.init_audio) < 0 {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not initialize SDL: ${error_msg}')
	}

	// Initialize SDL2_mixer
	if mixer.open_audio(u16(mixer.default_frequency), u16(mixer.default_format), u16(mixer.default_channels),
		4096) < 0 {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not initialize SDL mixer: ${error_msg}')
	}

	window := sdl.create_window('Hello SDL2_mixer (Press SPACE to pause/play)'.str, 300,
		300, 500, 300, 0)
	if window == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not create SDL window: ${error_msg}')
	}
	renderer := sdl.create_renderer(window, -1, u32(sdl.RendererFlags.accelerated) | u32(sdl.RendererFlags.presentvsync))
	if renderer == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not create SDL renderer: ${error_msg}')
	}

	// Print info to terminal
	println('Mouse click in the window to play the next sound.
On mobile you can tap the window to play the next sound.
Pressing SPACE will pause/resume all sound(s).
Use right/left arrow keys to go to next/previous sound.')

	// Load .WAV sound
	wav := load_wav(wav_sound) or { panic(err) }

	// Play WAV sound in a loop
	if mixer.play_channel(-1, wav, -1) < 0 {
		mixer.free_chunk(wav)
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('WAV sound could not be played: ${error_msg}')
	}
	println('Playing "${wav_sound}" (background loop)')

	mut pc := PlayCycle{}
	for sound in sounds {
		pc.music[sound] = load_mus(sound) or {
			eprintln('Loading of file ${sound} failed: ${err.msg()}')
			continue
		}
	}

	mut should_close := false
	for {
		evt := sdl.Event{}
		for 0 < sdl.poll_event(&evt) {
			match evt.@type {
				.quit {
					should_close = true
				}
				.mousebuttondown {
					pc.next()
				}
				.keydown {
					key := unsafe { sdl.KeyCode(evt.key.keysym.sym) }
					match key {
						.escape {
							should_close = true
							break
						}
						.space {
							if mixer.paused(-1) > 0 {
								mixer.resume(-1)
							} else {
								mixer.pause(-1)
							}
						}
						.right {
							pc.next()
						}
						.left {
							pc.previous()
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

		sdl.set_render_draw_color(renderer, 55, 55, 255, 255)
		sdl.render_clear(renderer)
		sdl.render_present(renderer)
	}

	sdl.destroy_renderer(renderer)
	sdl.destroy_window(window)
	mixer.close_audio()
	// Clean up audio
	mixer.free_chunk(wav)
	for _, v in pc.music {
		mixer.free_music(v)
	}

	sdl.quit()
}
