// Copyright(C) 2026 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module mixer

//
// SDL_mixer.h (SDL3)
//
import sdl

pub const major_version = C.SDL_MIXER_MAJOR_VERSION
pub const minor_version = C.SDL_MIXER_MINOR_VERSION
pub const micro_version = C.SDL_MIXER_MICRO_VERSION

// compiledversion is the version number macro for the current SDL_mixer version.
pub fn compiledversion() int {
	return C.SDL_VERSIONNUM(major_version, minor_version, micro_version)
}

fn C.MIX_Version() int

// version gets the version of the dynamically linked SDL_mixer library.
pub fn version() int {
	return C.MIX_Version()
}

fn C.MIX_Init() bool

// init initializes SDL_mixer.
pub fn init() bool {
	return C.MIX_Init()
}

fn C.MIX_Quit()

// quit de-initializes SDL_mixer.
pub fn quit() {
	C.MIX_Quit()
}

@[noinit; typedef]
pub struct C.MIX_Mixer {}

pub type Mixer = C.MIX_Mixer

@[noinit; typedef]
pub struct C.MIX_Audio {}

pub type Audio = C.MIX_Audio

@[noinit; typedef]
pub struct C.MIX_Track {}

pub type Track = C.MIX_Track

fn C.MIX_CreateMixerDevice(devid sdl.AudioDeviceID, const_spec &sdl.AudioSpec) &C.MIX_Mixer

// create_mixer_device creates a mixer that plays sound directly to an audio device.
pub fn create_mixer_device(devid sdl.AudioDeviceID, const_spec &sdl.AudioSpec) &Mixer {
	return C.MIX_CreateMixerDevice(devid, const_spec)
}

fn C.MIX_DestroyMixer(mixer &C.MIX_Mixer)

// destroy_mixer frees a mixer and closes its audio device, if any.
pub fn destroy_mixer(mixer &Mixer) {
	C.MIX_DestroyMixer(mixer)
}

fn C.MIX_LoadAudio(mixer &C.MIX_Mixer, const_path &char, predecode bool) &C.MIX_Audio

// load_audio loads audio data from a filesystem path.
pub fn load_audio(mixer &Mixer, const_path &char, predecode bool) &Audio {
	return C.MIX_LoadAudio(mixer, const_path, predecode)
}

fn C.MIX_DestroyAudio(audio &C.MIX_Audio)

// destroy_audio frees audio data previously loaded.
pub fn destroy_audio(audio &Audio) {
	C.MIX_DestroyAudio(audio)
}

fn C.MIX_CreateTrack(mixer &C.MIX_Mixer) &C.MIX_Track

// create_track creates a track for mixing audio.
pub fn create_track(mixer &Mixer) &Track {
	return C.MIX_CreateTrack(mixer)
}

fn C.MIX_DestroyTrack(track &C.MIX_Track)

// destroy_track frees a track.
pub fn destroy_track(track &Track) {
	C.MIX_DestroyTrack(track)
}

fn C.MIX_SetTrackAudio(track &C.MIX_Track, audio &C.MIX_Audio) bool

// set_track_audio assigns audio data to a track.
pub fn set_track_audio(track &Track, audio &Audio) bool {
	return C.MIX_SetTrackAudio(track, audio)
}

fn C.MIX_PlayTrack(track &C.MIX_Track, options sdl.PropertiesID) bool

// play_track starts (or restarts) mixing a track.
pub fn play_track(track &Track, options sdl.PropertiesID) bool {
	return C.MIX_PlayTrack(track, options)
}

fn C.MIX_PlayAudio(mixer &C.MIX_Mixer, audio &C.MIX_Audio) bool

// play_audio plays audio in a fire-and-forget manner.
pub fn play_audio(mixer &Mixer, audio &Audio) bool {
	return C.MIX_PlayAudio(mixer, audio)
}

fn C.MIX_SetTrackLoops(track &C.MIX_Track, num_loops int) bool

// set_track_loops changes the number of times a track will loop.
pub fn set_track_loops(track &Track, num_loops int) bool {
	return C.MIX_SetTrackLoops(track, num_loops)
}

fn C.MIX_PauseTrack(track &C.MIX_Track) bool

// pause_track pauses a track.
pub fn pause_track(track &Track) bool {
	return C.MIX_PauseTrack(track)
}

fn C.MIX_ResumeTrack(track &C.MIX_Track) bool

// resume_track resumes a paused track.
pub fn resume_track(track &Track) bool {
	return C.MIX_ResumeTrack(track)
}

fn C.MIX_StopTrack(track &C.MIX_Track, fade_out_frames i64) bool

// stop_track halts a track, optionally fading out over time.
pub fn stop_track(track &Track, fade_out_frames i64) bool {
	return C.MIX_StopTrack(track, fade_out_frames)
}

fn C.MIX_TrackPlaying(track &C.MIX_Track) bool

// track_playing reports whether a track is playing.
pub fn track_playing(track &Track) bool {
	return C.MIX_TrackPlaying(track)
}

fn C.MIX_SetTrackGain(track &C.MIX_Track, gain f32) bool

// set_track_gain sets track gain; 1.0 is full volume.
pub fn set_track_gain(track &Track, gain f32) bool {
	return C.MIX_SetTrackGain(track, gain)
}
