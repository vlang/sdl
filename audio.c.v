// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_audio.h
//

// AudioFormat
// These are what the 16 bits in SDL_AudioFormat currently mean...
// (Unspecified bits are always zero).
//
/*
```
    ++-----------------------sample is signed if set
    ||
    ||       ++-----------sample is bigendian if set
    ||       ||
    ||       ||          ++---sample is float if set
    ||       ||          ||
    ||       ||          || +---sample bit size---+
    ||       ||          || |                     |
    15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
```
*/
// There are macros in SDL 2.0 and later to query these bits.

pub type AudioFormat = u16

// Audio flags
pub const (
	audio_mask_bitsize  = C.SDL_AUDIO_MASK_BITSIZE
	audio_mask_datatype = C.SDL_AUDIO_MASK_DATATYPE
	audio_mask_endian   = C.SDL_AUDIO_MASK_ENDIAN
	audio_mask_signed   = C.SDL_AUDIO_MASK_SIGNED
)

fn C.SDL_AUDIO_BITSIZE(x int) int
pub fn audio_bitsize(x int) int {
	return C.SDL_AUDIO_BITSIZE(x)
}

fn C.SDL_AUDIO_ISFLOAT(x int) bool
pub fn audio_isfloat(x int) bool {
	return C.SDL_AUDIO_ISFLOAT(x)
}

fn C.SDL_AUDIO_ISBIGENDIAN(x int) bool
pub fn audio_isbigendian(x int) bool {
	return C.SDL_AUDIO_ISBIGENDIAN(x)
}

fn C.SDL_AUDIO_ISSIGNED(x int) bool
pub fn audio_issigned(x int) bool {
	return C.SDL_AUDIO_ISSIGNED(x)
}

fn C.SDL_AUDIO_ISINT(x int) bool
pub fn audio_isint(x int) bool {
	return C.SDL_AUDIO_ISINT(x)
}

fn C.SDL_AUDIO_ISLITTLEENDIAN(x int) bool
pub fn audio_islittleendian(x int) bool {
	return C.SDL_AUDIO_ISLITTLEENDIAN(x)
}

fn C.SDL_AUDIO_ISUNSIGNED(x int) bool
pub fn audio_isunsigned(x int) bool {
	return C.SDL_AUDIO_ISUNSIGNED(x)
}

// Audio format flags
//
// Defaults to LSB byte order.
pub const (
	audio_u8     = C.AUDIO_U8 // 0x0008, Unsigned 8-bit samples
	audio_s8     = C.AUDIO_S8 // 0x8008, Signed 8-bit samples
	audio_u16lsb = C.AUDIO_U16LSB // 0x0010, Unsigned 16-bit samples
	audio_s16lsb = C.AUDIO_S16LSB // 0x8010, Signed 16-bit samples
	audio_u16msb = C.AUDIO_U16MSB // 0x1010, As above, but big-endian byte order
	audio_s16msb = C.AUDIO_S16MSB // 0x9010, As above, but big-endian byte order
	audio_u16    = C.AUDIO_U16 // AUDIO_U16LSB
	audio_s16    = C.AUDIO_S16 // AUDIO_S16LSB
)

// int32 support
pub const (
	audio_s32lsb = C.AUDIO_S32LSB // 0x8020, 32-bit integer samples
	audio_s32msb = C.AUDIO_S32MSB // 0x9020, As above, but big-endian byte order
	audio_s32    = C.AUDIO_S32 // AUDIO_S32LSB
)

// float32 support
pub const (
	audio_f32lsb = C.AUDIO_F32LSB // 0x8120, 32-bit floating point samples
	audio_f32msb = C.AUDIO_F32MSB // 0x9120, As above, but big-endian byte order
	audio_f32    = C.AUDIO_F32
)

// Native audio byte ordering
pub const (
	audio_u16sys = C.AUDIO_U16SYS
	audio_s16sys = C.AUDIO_S16SYS
	audio_s32sys = C.AUDIO_S32SYS
	audio_f32sys = C.AUDIO_F32SYS
)

// Allow change flags
//
// Which audio format changes are allowed when opening a device.
pub const (
	audio_allow_frequency_change = C.SDL_AUDIO_ALLOW_FREQUENCY_CHANGE // 0x00000001
	audio_allow_format_change    = C.SDL_AUDIO_ALLOW_FORMAT_CHANGE // 0x00000002
	audio_allow_channels_change  = C.SDL_AUDIO_ALLOW_CHANNELS_CHANGE // 0x00000004
	audio_allow_any_change       = C.SDL_AUDIO_ALLOW_ANY_CHANGE
)

// This function is called when the audio device needs more data.
//
// `userdata` An application-specific parameter saved in
//                 the SDL_AudioSpec structure
// `stream` A pointer to the audio data buffer.
// `len`    The length of that buffer in bytes.
//
// Once the callback returns, the buffer will no longer be valid.
// Stereo samples are stored in a LRLRLR ordering.
//
// You can choose to avoid callbacks and use SDL_QueueAudio() instead, if
// you like. Just open your audio device with a NULL callback.
//
// `typedef void (SDLCALL * SDL_AudioCallback) (void *userdata, Uint8 * stream, int len)`
pub type AudioCallback = fn (userdata voidptr, stream &u8, len int)

// AudioSpec
//
// The calculated values in this structure are calculated by SDL_OpenAudio().
//
// For multi-channel audio, the default SDL channel mapping is:
// 2:  FL FR                       (stereo)
// 3:  FL FR LFE                   (2.1 surround)
// 4:  FL FR BL BR                 (quad)
// 5:  FL FR FC BL BR              (quad + center)
// 6:  FL FR FC LFE SL SR          (5.1 surround - last two can also be BL BR)
// 7:  FL FR FC LFE BC SL SR       (6.1 surround)
// 8:  FL FR FC LFE BL BR SL SR    (7.1 surround)

[typedef]
pub struct C.SDL_AudioSpec {
pub:
	freq     int // DSP frequency -- samples per second
	format   AudioFormat // C.SDL_AudioFormat Audio data format
	channels u8  // Number of channels: 1 mono, 2 stereo
	silence  u8  // Audio buffer silence value (calculated)
	samples  u16 // Audio buffer size in sample FRAMES (total samples divided by channel count)
	padding  u16 // Necessary for some compile environments
	size     u32 // Audio buffer size in bytes (calculated)
	callback AudioCallback // C.SDL_AudioCallback // Callback that feeds the audio device (NULL to use SDL_QueueAudio()).
	userdata voidptr       // Userdata passed to callback (ignored for NULL callbacks).
}

pub type AudioSpec = C.SDL_AudioSpec

// `typedef void (SDLCALL * SDL_AudioFilter) (struct SDL_AudioCVT * cvt, SDL_AudioFormat format)`
pub type AudioFilter = fn (cvt &AudioCVT, format AudioFormat)

//  Upper limit of filters in SDL_AudioCVT
//
// The maximum number of SDL_AudioFilter functions in SDL_AudioCVT is
// currently limited to 9. The SDL_AudioCVT.filters array has 10 pointers,
// one of which is the terminating NULL pointer.
pub const audiocvt_max_filters = C.SDL_AUDIOCVT_MAX_FILTERS

// 9

// TODO
/*
[typedef]
pub struct C.SDL_AUDIOCVT_PACKEDSDL_AudioCVT {
pub:
	needed       int // Set to 1 if conversion possible
	src_format   AudioFormat // C.SDL_AudioFormat, Source audio format
	dst_format   AudioFormat // C.SDL_AudioFormat, Target audio format
	rate_incr    f64   // Rate conversion increment
	buf          &u8 // Buffer to hold entire audio data
	len          int   // Length of original audio buffer
	len_cvt      int   // Length of converted audio buffer
	len_mult     int   // buffer must be len*len_mult big
	len_ratio    f64   // Given len, final size is len*len_ratio
	filters      [9]AudioFilter // C.SDL_AudioFilter
	filter_index int // Current audio conversion function
}

pub type AudioCVTPackedSDLAudioCVT = C.SDL_AUDIOCVT_PACKEDSDL_AudioCVT
*/

// AudioCVT
// A structure to hold a set of audio conversion filters and buffers.
//
// Note that various parts of the conversion pipeline can take advantage
// of SIMD operations (like SSE2, for example). SDL_AudioCVT doesn't require
// you to pass it aligned data, but can possibly run much faster if you
// set both its (buf) field to a pointer that is aligned to 16 bytes, and its
// (len) field to something that's a multiple of 16, if possible.
[typedef]
pub struct C.SDL_AudioCVT {
pub:
	needed       int // Set to 1 if conversion possible
	src_format   AudioFormat // C.SDL_AudioFormat, Source audio format
	dst_format   AudioFormat // C.SDL_AudioFormat, Target audio format
	rate_incr    f64 // Rate conversion increment
	buf          &u8 // Buffer to hold entire audio data
	len          int // Length of original audio buffer
	len_cvt      int // Length of converted audio buffer
	len_mult     int // buffer must be len*len_mult big
	len_ratio    f64 // Given len, final size is len*len_ratio
	filters      [10]AudioFilter // C.SDL_AudioFilter NULL-terminated list of filter functions
	filter_index int // Current audio conversion function
}

pub type AudioCVT = C.SDL_AudioCVT

// Driver discovery functions
//
// These functions return the list of built in audio drivers, in the
// order that they are normally initialized by default.
pub fn get_num_audio_drivers() int {
	return C.SDL_GetNumAudioDrivers()
}

fn C.SDL_GetNumAudioDrivers() int

pub fn get_audio_driver(index int) &char {
	return C.SDL_GetAudioDriver(index)
}

fn C.SDL_GetAudioDriver(index int) &char

// audio_init
// Initialization and cleanup
//
// These functions are used internally, and should not be used unless
// you have a specific need to specify the audio driver you want to
// use. You should normally use SDL_Init() or SDL_InitSubSystem().
pub fn audio_init(driver_name &char) int {
	return C.SDL_AudioInit(driver_name)
}

fn C.SDL_AudioInit(driver_name &char) int

pub fn audio_quit() {
	C.SDL_AudioQuit()
}

fn C.SDL_AudioQuit()

// get_current_audio_driver returns the name of the current audio driver, or NULL
// if no driver has been initialized.
pub fn get_current_audio_driver() &char {
	return C.SDL_GetCurrentAudioDriver()
}

fn C.SDL_GetCurrentAudioDriver() &char

// open_audio opens the audio device with the desired parameters, and
// returns 0 if successful, placing the actual hardware parameters in the
// structure pointed to by `obtained`.  If `obtained` is NULL, the audio
// data passed to the callback function will be guaranteed to be in the
// requested format, and will be automatically converted to the hardware
// audio format if necessary.  This function returns -1 if it failed
// to open the audio device, or couldn't set up the audio thread.
//
// When filling in the desired audio spec structure,
//   - `desired->freq` should be the desired audio frequency in samples-per-
//     second.
//   - `desired->format` should be the desired audio format.
//   - `desired->samples` is the desired size of the audio buffer, in
//     samples.  This number should be a power of two, and may be adjusted by
//     the audio driver to a value more suitable for the hardware.  Good values
//     seem to range between 512 and 8096 inclusive, depending on the
//     application and CPU speed.  Smaller values yield faster response time,
//     but can lead to underflow if the application is doing heavy processing
//     and cannot fill the audio buffer in time.  A stereo sample consists of
//     both right and left channels in LR ordering.
//     Note that the number of samples is directly related to time by the
//     following formula: ` ms = (samples*1000)/freq `
//   - `desired->size` is the size in bytes of the audio buffer, and is
//     calculated by SDL_OpenAudio().
//   - `desired->silence` is the value used to set the buffer to silence,
//     and is calculated by SDL_OpenAudio().
//   - `desired->callback` should be set to a function that will be called
//     when the audio device is ready for more data.  It is passed a pointer
//     to the audio buffer, and the length in bytes of the audio buffer.
//     This function usually runs in a separate thread, and so you should
//     protect data structures that it accesses by calling SDL_LockAudio()
//     and SDL_UnlockAudio() in your code. Alternately, you may pass a NULL
//     pointer here, and call SDL_QueueAudio() with some frequency, to queue
//     more audio samples to be played (or for capture devices, call
//     SDL_DequeueAudio() with some frequency, to obtain audio samples).
//   - `desired->userdata` is passed as the first parameter to your callback
//     function. If you passed a NULL callback, this value is ignored.
//
// The audio device starts out playing silence when it's opened, and should
// be enabled for playing by calling `SDL_PauseAudio`(0) when you are ready
// for your audio callback function to be called.  Since the audio driver
// may modify the requested size of the audio buffer, you should allocate
// any local mixing buffers after you open the audio device.
pub fn open_audio(desired &AudioSpec, obtained &AudioSpec) int {
	return C.SDL_OpenAudio(desired, obtained)
}

fn C.SDL_OpenAudio(desired &C.SDL_AudioSpec, obtained &C.SDL_AudioSpec) int

// AudioDeviceID
//
// SDL Audio Device IDs.
//
// A successful call to SDL_OpenAudio() is always device id 1, and legacy
// SDL audio APIs assume you want this device ID. SDL_OpenAudioDevice() calls
// always returns devices >= 2 on success. The legacy calls are good both
// for backwards compatibility and when you don't care about multiple,
// specific, or capture devices.
// `typedef Uint32 SDL_AudioDeviceID;`
pub type AudioDeviceID = u32

// get_num_audio_devices gets the number of available
// devices exposed by the current driver.
// Only valid after a successfully initializing the audio subsystem.
// Returns -1 if an explicit list of devices can't be determined; this is
// not an error. For example, if SDL is set up to talk to a remote audio
// server, it can't list every one available on the Internet, but it will
// still allow a specific host to be specified to SDL_OpenAudioDevice().
//
// In many common cases, when this function returns a value <= 0, it can still
// successfully open the default device (NULL for first argument of
// SDL_OpenAudioDevice()).
pub fn get_num_audio_devices(iscapture int) int {
	return C.SDL_GetNumAudioDevices(iscapture)
}

fn C.SDL_GetNumAudioDevices(iscapture int) int

// get_audio_device_name gets the human-readable
// name of a specific audio device.
// Must be a value between 0 and (number of audio devices-1).
// Only valid after a successfully initializing the audio subsystem.
// The values returned by this function reflect the latest call to
// SDL_GetNumAudioDevices(); recall that function to redetect available
// hardware.
//
// The string returned by this function is UTF-8 encoded, read-only, and
// managed internally. You are not to free it. If you need to keep the
// string for any length of time, you should make your own copy of it, as it
// will be invalid next time any of several other SDL functions is called.
pub fn get_audio_device_name(index int, iscapture int) &char {
	return C.SDL_GetAudioDeviceName(index, iscapture)
}

fn C.SDL_GetAudioDeviceName(index int, iscapture int) &char

// open_audio_device opens a specific audio device.
// Passing in a device name of NULL requests
// the most reasonable default (and is equivalent to calling SDL_OpenAudio()).
//
// The device name is a UTF-8 string reported by SDL_GetAudioDeviceName(), but
// some drivers allow arbitrary and driver-specific strings, such as a
// hostname/IP address for a remote audio server, or a filename in the
// diskaudio driver.
//
// returns 0 on error, a valid device ID that is >= 2 on success.
//
// SDL_OpenAudio(), unlike this function, always acts on device ID 1.
pub fn open_audio_device(const_device &char, iscapture int, const_desired &AudioSpec, obtained &AudioSpec, allowed_changes int) AudioDeviceID {
	return u32(C.SDL_OpenAudioDevice(const_device, iscapture, const_desired, obtained,
		allowed_changes))
}

fn C.SDL_OpenAudioDevice(const_device &char, iscapture int, const_desired &C.SDL_AudioSpec, obtained &C.SDL_AudioSpec, allowed_changes int) AudioDeviceID

// AudioStatus
//
// Audio state
//
// Get the current audio state.
// AudioStatus is C.SDL_AudioStatus
pub enum AudioStatus {
	audio_stopped = C.SDL_AUDIO_STOPPED // 0
	audio_playing = C.SDL_AUDIO_PLAYING
	audio_paused  = C.SDL_AUDIO_PAUSED
}

pub fn get_audio_status() AudioStatus {
	return AudioStatus(C.SDL_GetAudioStatus())
}

fn C.SDL_GetAudioStatus() AudioStatus

pub fn get_audio_device_status(dev AudioDeviceID) AudioStatus {
	return AudioStatus(C.SDL_GetAudioDeviceStatus(dev))
}

fn C.SDL_GetAudioDeviceStatus(dev AudioDeviceID) AudioStatus

// Pause audio functions
//
// These functions pause and unpause the audio callback processing.
// They should be called with a parameter of 0 after opening the audio
// device to start playing sound.  This is so you can safely initialize
// data for your callback function after opening the audio device.
// Silence will be written to the audio device during the pause.
pub fn pause_audio(pause_on int) {
	C.SDL_PauseAudio(pause_on)
}

fn C.SDL_PauseAudio(pause_on int)

fn C.SDL_PauseAudioDevice(dev C.SDL_AudioDeviceID, pause_on int)
pub fn pause_audio_device(dev AudioDeviceID, pause_on int) {
	C.SDL_PauseAudioDevice(C.SDL_AudioDeviceID(dev), pause_on)
}

fn C.SDL_LoadWAV_RW(src &C.SDL_RWops, freesrc int, spec &C.SDL_AudioSpec, audio_buf &&u8, audio_len &u32) &C.SDL_AudioSpec

// load_wav_rw loads a WAVE from the data source, automatically freeing
// that source if `freesrc` is non-zero.  For example, to load a WAVE file,
// you could do:
/*
```
     SDL_LoadWAV_RW(SDL_RWFromFile("sample.wav", "rb"), 1, ...);
```
*/
// If this function succeeds, it returns the given SDL_AudioSpec,
// filled with the audio data format of the wave data, and sets
// `audio_buf` to a malloc()'d buffer containing the audio data,
// and sets `audio_len` to the length of that audio buffer, in bytes.
// You need to free the audio buffer with SDL_FreeWAV() when you are
// done with it.
//
// This function returns NULL and sets the SDL error message if the
// wave file cannot be opened, uses an unknown data format, or is
// corrupt.  Currently raw and MS-ADPCM WAVE files are supported.
pub fn load_wav_rw(src &RWops, freesrc int, spec &AudioSpec, audio_buf &&u8, audio_len &u32) &AudioSpec {
	return C.SDL_LoadWAV_RW(src, freesrc, spec, audio_buf, audio_len)
}

fn C.SDL_LoadWAV(file &char, spec &C.SDL_AudioSpec, audio_buf &&u8, audio_len &u32) &C.SDL_AudioSpec

// load_wav loads a WAV from a file.
// Compatibility convenience function.
pub fn load_wav(file &char, spec &AudioSpec, audio_buf &&u8, audio_len &u32) &AudioSpec {
	return C.SDL_LoadWAV(file, spec, audio_buf, audio_len)
}

fn C.SDL_FreeWAV(audio_buf &u8)

// free_wav frees data previously allocated with SDL_LoadWAV_RW()
pub fn free_wav(audio_buf &u8) {
	C.SDL_FreeWAV(audio_buf)
}

fn C.SDL_BuildAudioCVT(cvt &C.SDL_AudioCVT, src_format C.SDL_AudioFormat, src_channels u8, src_rate int, dst_format C.SDL_AudioFormat, dst_channels u8, dst_rate int) int

// build_audio_cvt takes a source format and rate and a destination format
// and rate, and initializes the `cvt` structure with information needed
// by SDL_ConvertAudio() to convert a buffer of audio data from one format
// to the other. An unsupported format causes an error and -1 will be returned.
//
// returns 0 if no conversion is needed, 1 if the audio filter is set up,
// or -1 on error.
pub fn build_audio_cvt(cvt &AudioCVT, src_format AudioFormat, src_channels u8, src_rate int, dst_format AudioFormat, dst_channels u8, dst_rate int) int {
	return C.SDL_BuildAudioCVT(cvt, C.SDL_AudioFormat(src_format), src_channels, src_rate,
		C.SDL_AudioFormat(dst_format), dst_channels, dst_rate)
}

fn C.SDL_ConvertAudio(cvt &C.SDL_AudioCVT) int

// convert_audio
// Once you have initialized the `cvt` structure using SDL_BuildAudioCVT(),
// created an audio buffer `cvt->buf`, and filled it with `cvt->len` bytes of
// audio data in the source format, this function will convert it in-place
// to the desired format.
//
// The data conversion may expand the size of the audio data, so the buffer
// `cvt->buf` should be allocated after the `cvt` structure is initialized by
// SDL_BuildAudioCVT(), and should be `cvt->len` * `cvt->len_mult` bytes long.
//
// returns 0 on success or -1 if `cvt->buf` is NULL.
pub fn convert_audio(cvt &AudioCVT) int {
	return C.SDL_ConvertAudio(cvt)
}

// AudioStream
//
// SDL_AudioStream is a new audio conversion interface.
// The benefits vs SDL_AudioCVT:
// - it can handle resampling data in chunks without generating
//   artifacts, when it doesn't have the complete buffer available.
// - it can handle incoming data in any variable size.
// - You push data as you have it, and pull it when you need it
//
// this is opaque to the outside world.
[typedef]
pub struct C.SDL_AudioStream {
}

pub type AudioStream = C.SDL_AudioStream

fn C.SDL_NewAudioStream(const_src_format C.SDL_AudioFormat, const_src_channels u8, const_src_rate int, const_dst_format C.SDL_AudioFormat, const_dst_channels u8, const_dst_rate int) &C.SDL_AudioStream

// new_audio_stream creates a new audio stream
//
// `src_format` The format of the source audio
// `src_channels` The number of channels of the source audio
// `src_rate` The sampling rate of the source audio
// `dst_format` The format of the desired audio output
// `dst_channels` The number of channels of the desired audio output
// `dst_rate` The sampling rate of the desired audio output
// returns 0 on success, or -1 on error.
//
// See also: SDL_AudioStreamPut
// See also: SDL_AudioStreamGet
// See also: SDL_AudioStreamAvailable
// See also: SDL_AudioStreamFlush
// See also: SDL_AudioStreamClear
// See also: SDL_FreeAudioStream
pub fn new_audio_stream(const_src_format AudioFormat, const_src_channels u8, const_src_rate int, const_dst_format AudioFormat, const_dst_channels u8, const_dst_rate int) &AudioStream {
	return C.SDL_NewAudioStream(C.SDL_AudioFormat(const_src_format), const_src_channels,
		const_src_rate, C.SDL_AudioFormat(const_dst_format), const_dst_channels, const_dst_rate)
}

fn C.SDL_AudioStreamPut(stream &C.SDL_AudioStream, const_buf voidptr, len int) int

// audio_stream_put adds data to be converted/resampled to the stream
//
// `stream` The stream the audio data is being added to
// `buf` A pointer to the audio data to add
// `len` The number of bytes to write to the stream
// returns 0 on success, or -1 on error.
//
// See also: SDL_NewAudioStream
// See also: SDL_AudioStreamGet
// See also: SDL_AudioStreamAvailable
// See also: SDL_AudioStreamFlush
// See also: SDL_AudioStreamClear
// See also: SDL_FreeAudioStream
pub fn audio_stream_put(stream &AudioStream, const_buf voidptr, len int) int {
	return C.SDL_AudioStreamPut(stream, const_buf, len)
}

fn C.SDL_AudioStreamGet(stream &C.SDL_AudioStream, buf voidptr, len int) int

// audio_stream_get gets the converted/resampled data from the stream
//
// `stream` The stream the audio is being requested from
// `buf` A buffer to fill with audio data
// `len` The maximum number of bytes to fill
// returns The number of bytes read from the stream, or -1 on error
//
// See also: SDL_NewAudioStream
// See also: SDL_AudioStreamPut
// See also: SDL_AudioStreamAvailable
// See also: SDL_AudioStreamFlush
// See also: SDL_AudioStreamClear
// See also: SDL_FreeAudioStream
pub fn audio_stream_get(stream &AudioStream, buf voidptr, len int) int {
	return C.SDL_AudioStreamGet(stream, buf, len)
}

fn C.SDL_AudioStreamAvailable(stream &C.SDL_AudioStream) int

// audio_stream_available gets the number of converted/resampled
// bytes available. The stream may be
// buffering data behind the scenes until it has enough to resample
// correctly, so this number might be lower than what you expect, or even
// be zero. Add more data or flush the stream if you need the data now.
//
// See also: SDL_NewAudioStream
// See also: SDL_AudioStreamPut
// See also: SDL_AudioStreamGet
// See also: SDL_AudioStreamFlush
// See also: SDL_AudioStreamClear
// See also: SDL_FreeAudioStream
pub fn audio_stream_available(stream &AudioStream) int {
	return C.SDL_AudioStreamAvailable(stream)
}

fn C.SDL_AudioStreamFlush(stream &C.SDL_AudioStream) int

// audio_stream_flush tella the stream that you're done
// sending data, and anything being buffered
// should be converted/resampled and made available immediately.
//
// It is legal to add more data to a stream after flushing, but there will
// be audio gaps in the output. Generally this is intended to signal the
// end of input, so the complete output becomes available.
//
// See also: SDL_NewAudioStream
// See also: SDL_AudioStreamPut
// See also: SDL_AudioStreamGet
// See also: SDL_AudioStreamAvailable
// See also: SDL_AudioStreamClear
// See also: SDL_FreeAudioStream
pub fn audio_stream_flush(stream &AudioStream) int {
	return C.SDL_AudioStreamFlush(stream)
}

fn C.SDL_AudioStreamClear(stream &C.SDL_AudioStream)

// audio_stream_clear cleara any pending data in
// the stream without converting it
//
// See also: SDL_NewAudioStream
// See also: SDL_AudioStreamPut
// See also: SDL_AudioStreamGet
// See also: SDL_AudioStreamAvailable
// See also: SDL_AudioStreamFlush
// See also: SDL_FreeAudioStream
pub fn audio_stream_clear(stream &AudioStream) {
	C.SDL_AudioStreamClear(stream)
}

fn C.SDL_FreeAudioStream(stream &C.SDL_AudioStream)

// free_audio_stream frees an audio stream
//
// See also: SDL_NewAudioStream
// See also: SDL_AudioStreamPut
// See also: SDL_AudioStreamGet
// See also: SDL_AudioStreamAvailable
// See also: SDL_AudioStreamFlush
// See also: SDL_AudioStreamClear
pub fn free_audio_stream(stream &AudioStream) {
	C.SDL_FreeAudioStream(stream)
}

fn C.SDL_MixAudio(dst &u8, const_src &u8, len u32, volume int)

// mix_audio takes two audio buffers of the playing audio format and mixes
// them, performing addition, volume adjustment, and overflow clipping.
// The volume ranges from 0 - 128, and should be set to ::SDL_MIX_MAXVOLUME
// for full audio volume.  Note this does not change hardware volume.
// This is provided for convenience -- you can mix your own audio data.
pub fn mix_audio(dst &u8, const_src &u8, len u32, volume int) {
	C.SDL_MixAudio(dst, const_src, len, volume)
}

fn C.SDL_MixAudioFormat(dst &u8, const_src &u8, format C.SDL_AudioFormat, len u32, volume int)

// mix_audio_format works like SDL_MixAudio(), but you specify the audio format instead of
// using the format of audio device 1. Thus it can be used when no audio
// device is open at all.
pub fn mix_audio_format(dst &u8, const_src &u8, format AudioFormat, len u32, volume int) {
	C.SDL_MixAudioFormat(dst, const_src, C.SDL_AudioFormat(format), len, volume)
}

fn C.SDL_QueueAudio(dev C.SDL_AudioDeviceID, const_data voidptr, len u32) int

// queue_audio queues more audio on non-callback devices.
//
// (If you are looking to retrieve queued audio from a non-callback capture
// device, you want SDL_DequeueAudio() instead. This will return -1 to
// signify an error if you use it with capture devices.)
//
// SDL offers two ways to feed audio to the device: you can either supply a
// callback that SDL triggers with some frequency to obtain more audio
// (pull method), or you can supply no callback, and then SDL will expect
// you to supply data at regular intervals (push method) with this function.
//
// There are no limits on the amount of data you can queue, short of
// exhaustion of address space. Queued data will drain to the device as
// necessary without further intervention from you. If the device needs
// audio but there is not enough queued, it will play silence to make up
// the difference. This means you will have skips in your audio playback
// if you aren't routinely queueing sufficient data.
//
// This function copies the supplied data, so you are safe to free it when
// the function returns. This function is thread-safe, but queueing to the
// same device from two threads at once does not promise which buffer will
// be queued first.
//
// You may not queue audio on a device that is using an application-supplied
// callback; doing so returns an error. You have to use the audio callback
// or queue audio with this function, but not both.
//
// You should not call SDL_LockAudio() on the device before queueing; SDL
// handles locking internally for this function.
//
// `dev` The device ID to which we will queue audio.
// `data` The data to queue to the device for later playback.
// `len` The number of bytes (not samples!) to which (data) points.
// returns 0 on success, or -1 on error.
//
// See also: SDL_GetQueuedAudioSize
// See also: SDL_ClearQueuedAudio
pub fn queue_audio(dev AudioDeviceID, const_data voidptr, len u32) int {
	return C.SDL_QueueAudio(C.SDL_AudioDeviceID(dev), const_data, len)
}

fn C.SDL_DequeueAudio(dev C.SDL_AudioDeviceID, data voidptr, len u32) u32

// dequeue_audio dequeues more audio on non-callback devices.
//
// (If you are looking to queue audio for output on a non-callback playback
// device, you want SDL_QueueAudio() instead. This will always return 0
// if you use it with playback devices.)
//
// SDL offers two ways to retrieve audio from a capture device: you can
// either supply a callback that SDL triggers with some frequency as the
// device records more audio data, (push method), or you can supply no
// callback, and then SDL will expect you to retrieve data at regular
// intervals (pull method) with this function.
//
// There are no limits on the amount of data you can queue, short of
// exhaustion of address space. Data from the device will keep queuing as
// necessary without further intervention from you. This means you will
// eventually run out of memory if you aren't routinely dequeueing data.
//
// Capture devices will not queue data when paused; if you are expecting
// to not need captured audio for some length of time, use
// SDL_PauseAudioDevice() to stop the capture device from queueing more
// data. This can be useful during, say, level loading times. When
// unpaused, capture devices will start queueing data from that point,
// having flushed any capturable data available while paused.
//
// This function is thread-safe, but dequeueing from the same device from
// two threads at once does not promise which thread will dequeued data
// first.
//
// You may not dequeue audio from a device that is using an
// application-supplied callback; doing so returns an error. You have to use
// the audio callback, or dequeue audio with this function, but not both.
//
// You should not call SDL_LockAudio() on the device before queueing; SDL
// handles locking internally for this function.
//
// `dev` The device ID from which we will dequeue audio.
// `data` A pointer into where audio data should be copied.
// `len` The number of bytes (not samples!) to which (data) points.
// returns number of bytes dequeued, which could be less than requested.
//
// See also: SDL_GetQueuedAudioSize
// See also: SDL_ClearQueuedAudio
pub fn dequeue_audio(dev AudioDeviceID, data voidptr, len u32) u32 {
	return C.SDL_DequeueAudio(C.SDL_AudioDeviceID(dev), data, len)
}

fn C.SDL_GetQueuedAudioSize(dev C.SDL_AudioDeviceID) u32

// get_queued_audio_size gets the number of bytes of still-queued audio.
//
// For playback device:
//
//   This is the number of bytes that have been queued for playback with
//   SDL_QueueAudio(), but have not yet been sent to the hardware. This
//   number may shrink at any time, so this only informs of pending data.
//
//   Once we've sent it to the hardware, this function can not decide the
//   exact byte boundary of what has been played. It's possible that we just
//   gave the hardware several kilobytes right before you called this
//   function, but it hasn't played any of it yet, or maybe half of it, etc.
//
// For capture devices:
//
//   This is the number of bytes that have been captured by the device and
//   are waiting for you to dequeue. This number may grow at any time, so
//   this only informs of the lower-bound of available data.
//
// You may not queue audio on a device that is using an application-supplied
// callback; calling this function on such a device always returns 0.
// You have to queue audio with SDL_QueueAudio()/SDL_DequeueAudio(), or use
// the audio callback, but not both.
//
// You should not call SDL_LockAudio() on the device before querying; SDL
// handles locking internally for this function.
//
// `dev` The device ID of which we will query queued audio size.
// returns Number of bytes (not samples!) of queued audio.
//
// See also: SDL_QueueAudio
// See also: SDL_ClearQueuedAudio
pub fn get_queued_audio_size(dev AudioDeviceID) u32 {
	return C.SDL_GetQueuedAudioSize(C.SDL_AudioDeviceID(dev))
}

fn C.SDL_ClearQueuedAudio(dev C.SDL_AudioDeviceID)

// clear_queued_audio drops any queued audio data.
// For playback devices, this is any queued data
// still waiting to be submitted to the hardware. For capture devices, this
// is any data that was queued by the device that hasn't yet been dequeued by
// the application.
//
// Immediately after this call, SDL_GetQueuedAudioSize() will return 0. For
// playback devices, the hardware will start playing silence if more audio
// isn't queued. Unpaused capture devices will start filling the queue again
// as soon as they have more data available (which, depending on the state
// of the hardware and the thread, could be before this function call
// returns!).
//
// This will not prevent playback of queued audio that's already been sent
// to the hardware, as we can not undo that, so expect there to be some
// fraction of a second of audio that might still be heard. This can be
// useful if you want to, say, drop any pending music during a level change
// in your game.
//
// You may not queue audio on a device that is using an application-supplied
// callback; calling this function on such a device is always a no-op.
// You have to queue audio with SDL_QueueAudio()/SDL_DequeueAudio(), or use
// the audio callback, but not both.
//
// You should not call SDL_LockAudio() on the device before clearing the
// queue; SDL handles locking internally for this function.
//
// This function always succeeds and thus returns void.
//
// `dev` The device ID of which to clear the audio queue.
//
// See also: SDL_QueueAudio
// See also: SDL_GetQueuedAudioSize
pub fn clear_queued_audio(dev AudioDeviceID) {
	C.SDL_ClearQueuedAudio(C.SDL_AudioDeviceID(dev))
}

fn C.SDL_LockAudio()

// Audio lock functions
//
// The lock manipulated by these functions protects the callback function.
// During a SDL_LockAudio()/SDL_UnlockAudio() pair, you can be guaranteed that
// the callback function is not running.  Do not call these from the callback
// function or you will cause deadlock.
pub fn lock_audio() {
	C.SDL_LockAudio()
}

fn C.SDL_LockAudioDevice(dev C.SDL_AudioDeviceID)

pub fn lock_audio_device(dev AudioDeviceID) {
	C.SDL_LockAudioDevice(C.SDL_AudioDeviceID(dev))
}

fn C.SDL_UnlockAudio()
pub fn unlock_audio() {
	C.SDL_UnlockAudio()
}

fn C.SDL_UnlockAudioDevice(dev C.SDL_AudioDeviceID)
pub fn unlock_audio_device(dev AudioDeviceID) {
	C.SDL_UnlockAudioDevice(C.SDL_AudioDeviceID(dev))
}

fn C.SDL_CloseAudio()

// close_audio shuts down audio processing and closes the audio device.
pub fn close_audio() {
	C.SDL_CloseAudio()
}

fn C.SDL_CloseAudioDevice(dev C.SDL_AudioDeviceID)
pub fn close_audio_device(dev AudioDeviceID) {
	C.SDL_CloseAudioDevice(C.SDL_AudioDeviceID(dev))
}
