// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module mixer

//
// SDL_mixer.h
//
import sdl

pub const (
	major_version = C.SDL_MIXER_MAJOR_VERSION // 2
	minor_version = C.SDL_MIXER_MINOR_VERSION // 0
	patchlevel    = C.SDL_MIXER_PATCHLEVEL // 4
)

fn C.SDL_MIXER_VERSION(v &sdl.Version)

// mixer_version macro is used to fill a version structure with the compile-time
// version of the SDL_mixer library.
pub fn mixer_version(v &sdl.Version) {
	C.SDL_MIXER_VERSION(v)
}

fn C.SDL_MIXER_COMPILEDVERSION() int

// compiledversion is the version number macro for the current SDL_mixer version.
pub fn compiledversion() int {
	return C.SDL_VERSIONNUM(mixer.major_version, mixer.minor_version, mixer.patchlevel)
}

pub fn C.SDL_MIXER_VERSION_ATLEAST(x int, y int, z int) bool

// mixer_version_atleast macro evaluates to true if compiled with SDL_mixer at least X.Y.Z.
pub fn mixer_version_atleast(x int, y int, z int) bool {
	return C.SDL_MIXER_VERSION_ATLEAST(x, y, z)
}

fn C.Mix_Linked_Version() &C.SDL_version

// linked_version gets the version of the dynamically linked SDL_mixer library.
// it should NOT be used to fill a version structure, instead you should
// use the SDL_MIXER_VERSION() macro.
pub fn linked_version() &sdl.Version {
	return C.Mix_Linked_Version()
}

// InitFlags is C.MIX_InitFlags
pub enum InitFlags {
	flac = C.MIX_INIT_FLAC // 0x00000001
	mod = C.MIX_INIT_MOD // 0x00000002
	mp3 = C.MIX_INIT_MP3 // 0x00000008
	ogg = C.MIX_INIT_OGG // 0x00000010
	mid = C.MIX_INIT_MID // 0x00000020
	opus = C.MIX_INIT_OPUS // 0x00000040
}

fn C.Mix_Init(flags int) int

// init loads dynamic libraries and prepares them for use. Flags should be
// one or more flags from MIX_InitFlags OR'd together.
// It returns the flags successfully initialized, or 0 on failure.
pub fn init(flags int) int {
	return C.Mix_Init(flags)
}

fn C.Mix_Quit()

// Unloads libraries loaded with Mix_Init
pub fn quit() {
	C.Mix_Quit()
}

// The default mixer has 8 simultaneous mixing channels
pub const (
	mix_channels      = C.MIX_CHANNELS // 8
	// Good default values for a PC soundcard
	default_frequency = C.MIX_DEFAULT_FREQUENCY // 22050
	default_format    = C.MIX_DEFAULT_FORMAT
	default_channels  = C.MIX_DEFAULT_CHANNELS // 2
	maxvolume         = C.SDL_MIX_MAXVOLUME // Volume of a chunk
)

// effectsmaxspeed is C.MIX_EFFECTSMAXSPEED = "MIX_EFFECTSMAXSPEED"
pub const effectsmaxspeed = 'MIX_EFFECTSMAXSPEED'

// Chunk is the internal format for an audio chunk
[typedef]
pub struct C.Mix_Chunk {
pub:
	allocated int
	abuf      &u8
	alen      u32
	volume    u8 // Per-sample volume, 0-128
}

pub type Chunk = C.Mix_Chunk

// Fading is the different fading types supported
// Fading is C.Mix_Fading
pub enum Fading {
	no_fading = C.MIX_NO_FADING
	fading_out = C.MIX_FADING_OUT
	fading_in = C.MIX_FADING_IN
}

// MusicType are types of music files (not libraries used to load them)
// MusicType is C.Mix_MusicType
pub enum MusicType {
	@none = C.MUS_NONE
	cmd = C.MUS_CMD
	wav = C.MUS_WAV
	mod = C.MUS_MOD
	mid = C.MUS_MID
	ogg = C.MUS_OGG
	mp3 = C.MUS_MP3
	mp3_mad_unused = C.MUS_MP3_MAD_UNUSED
	flac = C.MUS_FLAC
	modplug_unused = C.MUS_MODPLUG_UNUSED
	opus = C.MUS_OPUS
}

pub const (
	channel_post = C.MIX_CHANNEL_POST // -2
)

// Music is the internal format for a music chunk interpreted via mikmod
[typedef]
pub struct C.Mix_Music {
}

pub type Music = C.Mix_Music

fn C.Mix_OpenAudio(frequency int, format u16, channels int, chunksize int) int

// open_audio opens the mixer with a certain audio format
pub fn open_audio(frequency int, format u16, channels int, chunksize int) int {
	return C.Mix_OpenAudio(frequency, format, channels, chunksize)
}

fn C.Mix_OpenAudioDevice(frequency int, format u16, channels int, chunksize int, const_device &char, allowed_changes int) int

// open_audio_device opens the mixer with specific device and certain audio format
pub fn open_audio_device(frequency int, format u16, channels int, chunksize int, const_device &char, allowed_changes int) int {
	return C.Mix_OpenAudioDevice(frequency, format, channels, chunksize, const_device,
		allowed_changes)
}

fn C.Mix_AllocateChannels(numchans int) int

// allocate_channels dynamically changes the number of channels managed by the mixer.
// If decreasing the number of channels, the upper channels are
// stopped.
// This function returns the new number of allocated channels.
pub fn allocate_channels(numchans int) int {
	return C.Mix_AllocateChannels(numchans)
}

fn C.Mix_QuerySpec(frequency &int, format &u16, channels &int) int

// query_spec finds out what the actual audio device parameters are.
// The function returns 1 if the audio has been opened, 0 otherwise.
pub fn query_spec(frequency &int, format &u16, channels &int) int {
	return C.Mix_QuerySpec(frequency, format, channels)
}

fn C.Mix_LoadWAV_RW(src &C.SDL_RWops, freesrc int) &C.Mix_Chunk

// load_wav_rw loads a wave file or a music (.mod .s3m .it .xm) file
pub fn load_wav_rw(src &sdl.RWops, freesrc int) &Chunk {
	return C.Mix_LoadWAV_RW(src, freesrc)
}

fn C.Mix_LoadWAV(file &char) &C.Mix_Chunk
pub fn load_wav(path &char) &Chunk {
	return C.Mix_LoadWAV(path)
}

fn C.Mix_LoadMUS(file &char) &C.Mix_Music

// load_mus loads a music file from an SDL_RWop object (Ogg and MikMod specific currently)
// Matt Campbell (matt@campbellhome.dhs.org) April 2000
pub fn load_mus(path &char) &Music {
	return C.Mix_LoadMUS(path)
}

fn C.Mix_LoadMUS_RW(src &C.SDL_RWops, freesrc int) &C.Mix_Music

// load_mus_rw loads a music file from an SDL_RWop object assuming a specific format
pub fn load_mus_rw(src &sdl.RWops, freesrc int) &Music {
	return C.Mix_LoadMUS_RW(src, freesrc)
}

fn C.Mix_LoadMUSType_RW(src &C.SDL_RWops, @type C.Mix_MusicType, freesrc int) &C.Mix_Music
pub fn load_mus_type_rw(src &sdl.RWops, @type MusicType, freesrc int) &Music {
	return C.Mix_LoadMUSType_RW(src, C.Mix_MusicType(@type), freesrc)
}

fn C.Mix_QuickLoad_WAV(mem &u8) &C.Mix_Chunk

// quick_load_wav loads a wave file of the mixer format from a memory buffer
pub fn quick_load_wav(mem &u8) &Chunk {
	return C.Mix_QuickLoad_WAV(mem)
}

fn C.Mix_QuickLoad_RAW(mem &u8, len u32) &C.Mix_Chunk

// quick_load_raw loads raw audio data of the mixer format from a memory buffer
pub fn quick_load_raw(mem &u8, len u32) &Chunk {
	return C.Mix_QuickLoad_RAW(mem, len)
}

fn C.Mix_FreeChunk(chunk &C.Mix_Chunk)

// free_chunk frees an audio chunk previously loaded
pub fn free_chunk(chunk &Chunk) {
	C.Mix_FreeChunk(chunk)
}

fn C.Mix_FreeMusic(music &C.Mix_Music)
pub fn free_music(music &Music) {
	C.Mix_FreeMusic(music)
}

fn C.Mix_GetNumChunkDecoders() int

// get_num_chunk_decoders gets a list of chunk/music decoders that this build of SDL_mixer provides.
// This list can change between builds AND runs of the program, if external
// libraries that add functionality become available.
// You must successfully call Mix_OpenAudio() before calling these functions.
// This API is only available in SDL_mixer 1.2.9 and later.

// usage...
/*
```
   int i;
   const int total = Mix_GetNumChunkDecoders();
   for (i = 0; i < total; i++)
       printf("Supported chunk decoder: [%s]\n", Mix_GetChunkDecoder(i));
```
*/
// Appearing in this list doesn't promise your specific audio file will
// decode...but it's handy to know if you have, say, a functioning Timidity
// install.
//
// These return values are static, read-only data; do not modify or free it.
// The pointers remain valid until you call Mix_CloseAudio().
pub fn get_num_chunk_decoders() int {
	return C.Mix_GetNumChunkDecoders()
}

fn C.Mix_GetChunkDecoder(index int) &char
pub fn get_chunk_decoder(index int) &char {
	return C.Mix_GetChunkDecoder(index)
}

fn C.Mix_HasChunkDecoder(name &char) bool
pub fn has_chunk_decoder(name &char) bool {
	return C.Mix_HasChunkDecoder(name)
}

fn C.Mix_GetNumMusicDecoders() int
pub fn get_num_music_decoders() int {
	return C.Mix_GetNumMusicDecoders()
}

fn C.Mix_GetMusicDecoder(index int) &char
pub fn get_music_decoder(index int) &char {
	return C.Mix_GetMusicDecoder(index)
}

/*
TODO: Yields "undefined reference to `Mix_HasMusicDecoder'"???
fn C.Mix_HasMusicDecoder(name &char) bool
pub fn has_music_decoder(name &char) bool {
	return C.Mix_HasMusicDecoder(name)
}
*/

fn C.Mix_GetMusicType(music &C.Mix_Music) C.Mix_MusicType

// get_music_type finds out the music format of a mixer music, or the currently playing
// music, if 'music' is NULL.
pub fn get_music_type(music &Music) MusicType {
	return MusicType(C.Mix_GetMusicType(music))
}

// `void (SDLCALL *mix_func)(void *udata, Uint8 *stream, int len)`
pub type MixFunc = fn (udata voidptr, stream &u8, len int)

// `void (SDLCALL *music_finished)(void)`
pub type MusicFinished = fn ()

fn C.Mix_SetPostMix(mix_func MixFunc, arg voidptr)

// set_post_mix set a function that is called after all mixing is performed.
// This can be used to provide real-time visual display of the audio stream
// or add a custom mixer filter for the stream data.
pub fn set_post_mix(mix_func MixFunc, arg voidptr) {
	C.Mix_SetPostMix(mix_func, arg)
}

// hook_music adds your own music player or additional mixer function.
// If 'mix_func' is NULL, the default music player is re-enabled.
fn C.Mix_HookMusic(mix_func MixFunc, arg voidptr)
pub fn hook_music(mix_func MixFunc, arg voidptr) {
	C.Mix_HookMusic(mix_func, arg)
}

// hook_music_finished adds your own callback for when the music has finished playing or when it is
// stopped from a call to Mix_HaltMusic.
fn C.Mix_HookMusicFinished(finished MusicFinished)
pub fn hook_music_finished(finished MusicFinished) {
	C.Mix_HookMusicFinished(finished)
}

fn C.Mix_GetMusicHookData() voidptr

// get_music_hook_data gets a pointer to the user data for the current music hook
pub fn get_music_hook_data() voidptr {
	return C.Mix_GetMusicHookData()
}

// `void (SDLCALL *channel_finished)(int channel)`
pub type ChannelFinished = fn (channel int)

fn C.Mix_ChannelFinished(channel_finished ChannelFinished)

// channel_finished adds your own callback when a channel has finished playing. NULL
// to disable callback. The callback may be called from the mixer's audio
// callback or it could be called as a result of Mix_HaltChannel(), etc.
// do not call SDL_LockAudio() from this callback; you will either be
// inside the audio callback, or SDL_mixer will explicitly lock the audio
// before calling your callback.
pub fn channel_finished(channel_finished ChannelFinished) {
	C.Mix_ChannelFinished(channel_finished)
}

// This is the format of a special effect callback:
//
// myeffect(int chan, void *stream, int len, void *udata);
//
// (chan) is the channel number that your effect is affecting. (stream) is
// the buffer of data to work upon. (len) is the size of (stream), and
// (udata) is a user-defined bit of data, which you pass as the last arg of
// Mix_RegisterEffect(), and is passed back unmolested to your callback.
// Your effect changes the contents of (stream) based on whatever parameters
// are significant, or just leaves it be, if you prefer. You can do whatever
// you like to the buffer, though, and it will continue in its changed state
// down the mixing pipeline, through any other effect functions, then finally
// to be mixed with the rest of the channels and music for the final output
// stream.
//
// DO NOT EVER call SDL_LockAudio() from your callback function!
//
// `typedef void (SDLCALL *Mix_EffectFunc_t)(int chan, void *stream, int len, void *udata);`
pub type MixEffectFunc = fn (channel int, stream voidptr, len int, udata voidptr)

// This is a callback that signifies that a channel has finished all its
// loops and has completed playback. This gets called if the buffer
// plays out normally, or if you call Mix_HaltChannel(), implicitly stop
// a channel via Mix_AllocateChannels(), or unregister a callback while
// it's still playing.
//
// DO NOT EVER call SDL_LockAudio() from your callback function!
//
// typedef void (SDLCALL *Mix_EffectDone_t)(int chan, void *udata);
pub type MixEffectDone = fn (channel int, udata voidptr)

fn C.Mix_RegisterEffect(channel int, f MixEffectFunc, d MixEffectDone, arg voidptr) int

// register_effect registers a special effect function. At mixing time, the channel data is
// copied into a buffer and passed through each registered effect function.
// After it passes through all the functions, it is mixed into the final
// output stream. The copy to buffer is performed once, then each effect
// function performs on the output of the previous effect. Understand that
// this extra copy to a buffer is not performed if there are no effects
// registered for a given chunk, which saves CPU cycles, and any given
// effect will be extra cycles, too, so it is crucial that your code run
// fast. Also note that the data that your function is given is in the
// format of the sound device, and not the format you gave to Mix_OpenAudio(),
// although they may in reality be the same. This is an unfortunate but
// necessary speed concern. Use Mix_QuerySpec() to determine if you can
// handle the data before you register your effect, and take appropriate
// actions.
// You may also specify a callback (Mix_EffectDone_t) that is called when
// the channel finishes playing. This gives you a more fine-grained control
// than Mix_ChannelFinished(), in case you need to free effect-specific
// resources, etc. If you don't need this, you can specify NULL.
// You may set the callbacks before or after calling Mix_PlayChannel().
// Things like Mix_SetPanning() are just internal special effect functions,
// so if you are using that, you've already incurred the overhead of a copy
// to a separate buffer, and that these effects will be in the queue with
// any functions you've registered. The list of registered effects for a
// channel is reset when a chunk finishes playing, so you need to explicitly
// set them with each call to Mix_PlayChannel*().
// You may also register a special effect function that is to be run after
// final mixing occurs. The rules for these callbacks are identical to those
// in Mix_RegisterEffect, but they are run after all the channels and the
// music have been mixed into a single stream, whereas channel-specific
// effects run on a given channel before any other mixing occurs. These
// global effect callbacks are call "posteffects". Posteffects only have
// their Mix_EffectDone_t function called when they are unregistered (since
// the main output stream is never "done" in the same sense as a channel).
// You must unregister them manually when you've had enough. Your callback
// will be told that the channel being mixed is (MIX_CHANNEL_POST) if the
// processing is considered a posteffect.
//
// After all these effects have finished processing, the callback registered
// through Mix_SetPostMix() runs, and then the stream goes to the audio
// device.
//
// DO NOT EVER call SDL_LockAudio() from your callback function!
//
// returns zero if error (no such channel), nonzero if added.
// Error messages can be retrieved from Mix_GetError().
pub fn register_effect(channel int, f MixEffectFunc, d MixEffectDone, arg voidptr) int {
	return C.Mix_RegisterEffect(channel, f, d, arg)
}

// unregister_effect. You may not need to call this explicitly, unless you need to stop an
// effect from processing in the middle of a chunk's playback.
// Posteffects are never implicitly unregistered as they are for channels,
// but they may be explicitly unregistered through this function by
// specifying MIX_CHANNEL_POST for a channel.
// returns zero if error (no such channel or effect), nonzero if removed.
// Error messages can be retrieved from Mix_GetError().
fn C.Mix_UnregisterEffect(channel int, f MixEffectFunc) int
pub fn unregister_effect(channel int, f MixEffectFunc) int {
	return C.Mix_UnregisterEffect(channel, f)
}

// unregister_all_effects. You may not need to call this explicitly, unless you need to stop all
// effects from processing in the middle of a chunk's playback. Note that
// this will also shut off some internal effect processing, since
// Mix_SetPanning() and others may use this API under the hood. This is
// called internally when a channel completes playback.
// Posteffects are never implicitly unregistered as they are for channels,
// but they may be explicitly unregistered through this function by
// specifying MIX_CHANNEL_POST for a channel.
// returns zero if error (no such channel), nonzero if all effects removed.
// Error messages can be retrieved from Mix_GetError().
fn C.Mix_UnregisterAllEffects(channel int) int
pub fn unregister_all_effects(channel int) int {
	return C.Mix_UnregisterAllEffects(channel)
}

// These are the internally-defined mixing effects. They use the same API that
// effects defined in the application use, but are provided here as a
// convenience. Some effects can reduce their quality or use more memory in
// the name of speed; to enable this, make sure the environment variable
// MIX_EFFECTSMAXSPEED (see above) is defined before you call
// Mix_OpenAudio().

fn C.Mix_SetPanning(channel int, left u8, right u8) int

// set_panning sets the panning of a channel. The left and right channels are specified
// as integers between 0 and 255, quietest to loudest, respectively.
//
// Technically, this is just individual volume control for a sample with
// two (stereo) channels, so it can be used for more than just panning.
// If you want real panning, call it like this:
//
// Mix_SetPanning(channel, left, 255 - left);
//
// ...which isn't so hard.
//
// Setting (channel) to MIX_CHANNEL_POST registers this as a posteffect, and
// the panning will be done to the final mixed stream before passing it on
// to the audio device.
//
// This uses the Mix_RegisterEffect() API internally, and returns without
// registering the effect function if the audio device is not configured
// for stereo output. Setting both (left) and (right) to 255 causes this
// effect to be unregistered, since that is the data's normal state.
//
// returns zero if error (no such channel or Mix_RegisterEffect() fails),
// nonzero if panning effect enabled. Note that an audio device in mono
// mode is a no-op, but this call will return successful in that case.
// Error messages can be retrieved from Mix_GetError().
pub fn set_panning(channel int, left u8, right u8) int {
	return C.Mix_SetPanning(channel, left, right)
}

fn C.Mix_SetPosition(channel int, angle i16, distance u8) int

// set_position sets the position of a channel. (angle) is an integer from 0 to 360, that
// specifies the location of the sound in relation to the listener. (angle)
// will be reduced as neccesary (540 becomes 180 degrees, -100 becomes 260).
// Angle 0 is due north, and rotates clockwise as the value increases.
// For efficiency, the precision of this effect may be limited (angles 1
// through 7 might all produce the same effect, 8 through 15 are equal, etc).
// (distance) is an integer between 0 and 255 that specifies the space
// between the sound and the listener. The larger the number, the further
// away the sound is. Using 255 does not guarantee that the channel will be
// culled from the mixing process or be completely silent. For efficiency,
// the precision of this effect may be limited (distance 0 through 5 might
// all produce the same effect, 6 through 10 are equal, etc). Setting (angle)
// and (distance) to 0 unregisters this effect, since the data would be
// unchanged.
//
// If you need more precise positional audio, consider using OpenAL for
// spatialized effects instead of SDL_mixer. This is only meant to be a
// basic effect for simple "3D" games.
//
// If the audio device is configured for mono output, then you won't get
// any effectiveness from the angle; however, distance attenuation on the
// channel will still occur. While this effect will function with stereo
// voices, it makes more sense to use voices with only one channel of sound,
// so when they are mixed through this effect, the positioning will sound
// correct. You can convert them to mono through SDL before giving them to
// the mixer in the first place if you like.
//
// Setting (channel) to MIX_CHANNEL_POST registers this as a posteffect, and
// the positioning will be done to the final mixed stream before passing it
// on to the audio device.
//
// This is a convenience wrapper over Mix_SetDistance() and Mix_SetPanning().
//
// returns zero if error (no such channel or Mix_RegisterEffect() fails),
// nonzero if position effect is enabled.
// Error messages can be retrieved from Mix_GetError().
pub fn set_position(channel int, angle i16, distance u8) int {
	return C.Mix_SetPosition(channel, angle, distance)
}

fn C.Mix_SetDistance(channel int, distance u8) int

// set_distance set the "distance" of a channel. (distance) is an integer from 0 to 255
// that specifies the location of the sound in relation to the listener.
// Distance 0 is overlapping the listener, and 255 is as far away as possible
// A distance of 255 does not guarantee silence; in such a case, you might
// want to try changing the chunk's volume, or just cull the sample from the
// mixing process with Mix_HaltChannel().
// For efficiency, the precision of this effect may be limited (distances 1
// through 7 might all produce the same effect, 8 through 15 are equal, etc).
// (distance) is an integer between 0 and 255 that specifies the space
// between the sound and the listener. The larger the number, the further
// away the sound is.
// Setting (distance) to 0 unregisters this effect, since the data would be
// unchanged.
// If you need more precise positional audio, consider using OpenAL for
// spatialized effects instead of SDL_mixer. This is only meant to be a
// basic effect for simple "3D" games.
//
// Setting (channel) to MIX_CHANNEL_POST registers this as a posteffect, and
// the distance attenuation will be done to the final mixed stream before
// passing it on to the audio device.
//
// This uses the Mix_RegisterEffect() API internally.
//
// returns zero if error (no such channel or Mix_RegisterEffect() fails),
// nonzero if position effect is enabled.
// Error messages can be retrieved from Mix_GetError().
pub fn set_distance(channel int, distance u8) int {
	return C.Mix_SetDistance(channel, distance)
}

fn C.Mix_SetReverseStereo(channel int, flip int) int

// set_reverse_stereo causes a channel to reverse its stereo. This is handy if the user has his
// speakers hooked up backwards, or you would like to have a minor bit of
// psychedelia in your sound code.  :)  Calling this function with (flip)
// set to non-zero reverses the chunks's usual channels. If (flip) is zero,
// the effect is unregistered.
//
// This uses the Mix_RegisterEffect() API internally, and thus is probably
// more CPU intensive than having the user just plug in his speakers
// correctly. Mix_SetReverseStereo() returns without registering the effect
// function if the audio device is not configured for stereo output.
//
// If you specify MIX_CHANNEL_POST for (channel), then this the effect is used
// on the final mixed stream before sending it on to the audio device (a
// posteffect).
//
// returns zero if error (no such channel or Mix_RegisterEffect() fails),
// nonzero if reversing effect is enabled. Note that an audio device in mono
// mode is a no-op, but this call will return successful in that case.
// Error messages can be retrieved from Mix_GetError().
pub fn set_reverse_stereo(channel int, flip int) int {
	return C.Mix_SetReverseStereo(channel, flip)
}

fn C.Mix_ReserveChannels(num int) int

// reserve_channels reserves the first channels (0 -> n-1) for the application, i.e. don't allocate
// them dynamically to the next sample if requested with a -1 value below.
// Returns the number of reserved channels.
pub fn reserve_channels(num int) int {
	return C.Mix_ReserveChannels(num)
}

// Channel grouping functions
fn C.Mix_GroupChannel(which int, tag int) int

// group_channel attaches a tag to a channel. A tag can be assigned to several mixer
// channels, to form groups of channels.
// If 'tag' is -1, the tag is removed (actually -1 is the tag used to
// represent the group of all the channels).
// Returns true if everything was OK.
pub fn group_channel(which int, tag int) int {
	return C.Mix_GroupChannel(which, tag)
}

fn C.Mix_GroupChannels(from int, to int, tag int) int

// group_channels assigns several consecutive channels to a group
pub fn group_channels(from int, to int, tag int) int {
	return C.Mix_GroupChannels(from, to, tag)
}

fn C.Mix_GroupAvailable(tag int) int

// group_available finds the first available channel in a group of channels,
// returning -1 if none are available.
pub fn group_available(tag int) int {
	return C.Mix_GroupAvailable(tag)
}

fn C.Mix_GroupCount(tag int) int

// group_count returns the number of channels in a group. This is also a subtle
// way to get the total number of channels when 'tag' is -1
pub fn group_count(tag int) int {
	return C.Mix_GroupCount(tag)
}

fn C.Mix_GroupOldest(tag int) int

// group_oldest finds the "oldest" sample playing in a group of channels
pub fn group_oldest(tag int) int {
	return C.Mix_GroupOldest(tag)
}

fn C.Mix_GroupNewer(tag int) int

// group_newer finds the "most recent" (i.e. last) sample playing in a group of channels
pub fn group_newer(tag int) int {
	return C.Mix_GroupNewer(tag)
}

fn C.Mix_PlayChannel(channel int, chunk &C.Mix_Chunk, loops int) int

// play_channel plays an audio chunk on a specific channel.
// If the specified channel is -1, play on the first free channel.
// If 'loops' is greater than zero, loop the sound that many times.
// If 'loops' is -1, loop inifinitely (~65000 times).
// Returns which channel was used to play the sound.
pub fn play_channel(channel int, chunk &Chunk, loops int) int {
	return C.Mix_PlayChannel(channel, chunk, loops)
}

fn C.Mix_PlayChannelTimed(channel int, chunk &C.Mix_Chunk, loops int, ticks int) int

// play_channel_timed does the same as above, but the sound is played at most 'ticks' milliseconds
pub fn play_channel_timed(channel int, chunk &Chunk, loops int, ticks int) int {
	return C.Mix_PlayChannelTimed(channel, chunk, loops, ticks)
}

fn C.Mix_PlayMusic(music &C.Mix_Music, loops int) int
pub fn play_music(music &Music, loops int) int {
	return C.Mix_PlayMusic(music, loops)
}

fn C.Mix_FadeInMusic(music &C.Mix_Music, loops int, ms int) int

// fade_in_music fades in music or a channel over "ms" milliseconds, same semantics as the "Play" functions
pub fn fade_in_music(music &Music, loops int, ms int) int {
	return C.Mix_FadeInMusic(music, loops, ms)
}

fn C.Mix_FadeInMusicPos(music &C.Mix_Music, loops int, ms int, position f64) int
pub fn fade_in_music_pos(music &Music, loops int, ms int, position f64) int {
	return C.Mix_FadeInMusicPos(music, loops, ms, position)
}

fn C.Mix_FadeInChannel(channel int, chunk &C.Mix_Chunk, loops int, ms int) int
pub fn fade_in_channel(channel int, chunk &Chunk, loops int, ms int) int {
	return C.Mix_FadeInChannel(channel, chunk, loops, ms)
}

fn C.Mix_FadeInChannelTimed(channel int, chunk &C.Mix_Chunk, loops int, ms int, ticks int) int
pub fn fade_in_channel_timed(channel int, chunk &Chunk, loops int, ms int, ticks int) int {
	return C.Mix_FadeInChannelTimed(channel, chunk, loops, ms, ticks)
}

fn C.Mix_Volume(channel int, volume int) int

// volume sets the volume in the range of 0-128 of a specific channel or chunk.
// If the specified channel is -1, set volume for all channels.
// Returns the original volume.
// If the specified volume is -1, just return the current volume.
pub fn volume(channel int, volume int) int {
	return C.Mix_Volume(channel, volume)
}

fn C.Mix_VolumeChunk(chunk &C.Mix_Chunk, volume int) int
pub fn volume_chunk(chunk &C.Mix_Chunk, volume int) int {
	return C.Mix_VolumeChunk(chunk, volume)
}

fn C.Mix_VolumeMusic(volume int) int
pub fn volume_music(volume int) int {
	return C.Mix_VolumeMusic(volume)
}

fn C.Mix_HaltChannel(channel int) int

// halt_channel halts playing of a particular channel
pub fn halt_channel(channel int) int {
	return C.Mix_HaltChannel(channel)
}

fn C.Mix_HaltGroup(tag int) int
pub fn halt_group(tag int) int {
	return C.Mix_HaltGroup(tag)
}

fn C.Mix_HaltMusic() int
pub fn halt_music() int {
	return C.Mix_HaltMusic()
}

fn C.Mix_ExpireChannel(channel int, ticks int) int

// expire_channel changes the expiration delay for a particular channel.
// The sample will stop playing after the 'ticks' milliseconds have elapsed,
// or remove the expiration if 'ticks' is -1
pub fn expire_channel(channel int, ticks int) int {
	return C.Mix_ExpireChannel(channel, ticks)
}

fn C.Mix_FadeOutChannel(which int, ms int) int

// fade_out_channel halts a channel, fading it out progressively till it's silent
// The ms parameter indicates the number of milliseconds the fading
// will take.
pub fn fade_out_channel(which int, ms int) int {
	return C.Mix_FadeOutChannel(which, ms)
}

fn C.Mix_FadeOutGroup(tag int, ms int) int
pub fn fade_out_group(tag int, ms int) int {
	return C.Mix_FadeOutGroup(tag, ms)
}

fn C.Mix_FadeOutMusic(ms int) int
pub fn fade_out_music(ms int) int {
	return C.Mix_FadeOutMusic(ms)
}

fn C.Mix_FadingMusic() C.Mix_Fading

// fading_music queries the fading status of a channel
pub fn fading_music() Fading {
	return Fading(C.Mix_FadingMusic())
}

fn C.Mix_FadingChannel(which int) C.Mix_Fading
pub fn fading_channel(which int) Fading {
	return Fading(C.Mix_FadingChannel(which))
}

fn C.Mix_Pause(channel int)

// pause pauses a particular channel
pub fn pause(channel int) {
	C.Mix_Pause(channel)
}

fn C.Mix_Resume(channel int)

// resume resumes a particular channel
pub fn resume(channel int) {
	C.Mix_Resume(channel)
}

fn C.Mix_Paused(channel int) int
pub fn paused(channel int) int {
	return C.Mix_Paused(channel)
}

// Pause/Resume the music stream
fn C.Mix_PauseMusic()
pub fn pause_music() {
	C.Mix_PauseMusic()
}

fn C.Mix_ResumeMusic()
pub fn resume_music() {
	C.Mix_ResumeMusic()
}

fn C.Mix_RewindMusic()
pub fn rewind_music() {
	C.Mix_RewindMusic()
}

fn C.Mix_PausedMusic() int
pub fn paused_music() int {
	return C.Mix_PausedMusic()
}

fn C.Mix_SetMusicPosition(position f64) int

// set_music_position sets the current position in the music stream.
// This returns 0 if successful, or -1 if it failed or isn't implemented.
// This function is only implemented for MOD music formats (set pattern
// order number) and for OGG, FLAC, MP3_MAD, MP3_MPG and MODPLUG music
// (set position in seconds), at the moment.
pub fn set_music_position(position f64) int {
	return C.Mix_SetMusicPosition(position)
}

fn C.Mix_Playing(channel int) int

// playing checks the status of a specific channel.
// If the specified channel is -1, check all channels.
pub fn playing(channel int) int {
	return C.Mix_Playing(channel)
}

fn C.Mix_PlayingMusic() int
pub fn playing_music() int {
	return C.Mix_PlayingMusic()
}

fn C.Mix_SetMusicCMD(command &char) int

// set_music_cmd stops music and set external music playback command
pub fn set_music_cmd(command &char) int {
	return C.Mix_SetMusicCMD(command)
}

fn C.Mix_SetSynchroValue(value int) int

// set_synchro_value. Synchro value is set by MikMod from modules while playing
pub fn set_synchro_value(value int) int {
	return C.Mix_SetSynchroValue(value)
}

fn C.Mix_GetSynchroValue() int
pub fn get_synchro_value() int {
	return C.Mix_GetSynchroValue()
}

fn C.Mix_SetSoundFonts(paths &char) int

// set_sound_fonts set/get/iterate SoundFonts paths to use by supported MIDI backends
pub fn set_sound_fonts(paths &char) int {
	return C.Mix_SetSoundFonts(paths)
}

fn C.Mix_GetSoundFonts() &char
pub fn get_sound_fonts() &char {
	return C.Mix_GetSoundFonts()
}

// `int (SDLCALL *function)(const char*, void*)`
pub type Func = fn (const_a &char, b voidptr) int

fn C.Mix_EachSoundFont(f Func, data voidptr) int
pub fn each_sound_font(f Func, data voidptr) int {
	return C.Mix_EachSoundFont(f, data)
}

fn C.Mix_GetChunk(channel int) &C.Mix_Chunk

// get_chunk gets the Mix_Chunk currently associated with a mixer channel
// Returns NULL if it's an invalid channel, or there's no chunk associated.
pub fn get_chunk(channel int) &Chunk {
	return C.Mix_GetChunk(channel)
}

fn C.Mix_CloseAudio()

// close_audio closes the mixer, halting all playing audio
pub fn close_audio() {
	C.Mix_CloseAudio()
}
