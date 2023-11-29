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
pub const audio_mask_bitsize = C.SDL_AUDIO_MASK_BITSIZE
pub const audio_mask_datatype = C.SDL_AUDIO_MASK_DATATYPE
pub const audio_mask_endian = C.SDL_AUDIO_MASK_ENDIAN
pub const audio_mask_signed = C.SDL_AUDIO_MASK_SIGNED

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
pub const audio_u8 = C.AUDIO_U8 // 0x0008, Unsigned 8-bit samples

pub const audio_s8 = C.AUDIO_S8 // 0x8008, Signed 8-bit samples

pub const audio_u16lsb = C.AUDIO_U16LSB // 0x0010, Unsigned 16-bit samples

pub const audio_s16lsb = C.AUDIO_S16LSB // 0x8010, Signed 16-bit samples

pub const audio_u16msb = C.AUDIO_U16MSB // 0x1010, As above, but big-endian byte order

pub const audio_s16msb = C.AUDIO_S16MSB // 0x9010, As above, but big-endian byte order

pub const audio_u16 = C.AUDIO_U16 // AUDIO_U16LSB

pub const audio_s16 = C.AUDIO_S16 // AUDIO_S16LSB

// int32 support
pub const audio_s32lsb = C.AUDIO_S32LSB // 0x8020, 32-bit integer samples

pub const audio_s32msb = C.AUDIO_S32MSB // 0x9020, As above, but big-endian byte order

pub const audio_s32 = C.AUDIO_S32 // AUDIO_S32LSB

// float32 support
pub const audio_f32lsb = C.AUDIO_F32LSB // 0x8120, 32-bit floating point samples

pub const audio_f32msb = C.AUDIO_F32MSB // 0x9120, As above, but big-endian byte order

pub const audio_f32 = C.AUDIO_F32

// Native audio byte ordering
pub const audio_u16sys = C.AUDIO_U16SYS
pub const audio_s16sys = C.AUDIO_S16SYS
pub const audio_s32sys = C.AUDIO_S32SYS
pub const audio_f32sys = C.AUDIO_F32SYS

// Allow change flags
//
// Which audio format changes are allowed when opening a device.
pub const audio_allow_frequency_change = C.SDL_AUDIO_ALLOW_FREQUENCY_CHANGE // 0x00000001

pub const audio_allow_format_change = C.SDL_AUDIO_ALLOW_FORMAT_CHANGE // 0x00000002

pub const audio_allow_channels_change = C.SDL_AUDIO_ALLOW_CHANNELS_CHANGE // 0x00000004

pub const sdl_audio_allow_samples_change = C.SDL_AUDIO_ALLOW_SAMPLES_CHANGE // 0x00000008

pub const audio_allow_any_change = C.SDL_AUDIO_ALLOW_ANY_CHANGE

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
// 5:  FL FR FC BL BR              (4.1 surround)
// 6:  FL FR FC LFE SL SR          (5.1 surround - last two can also be BL BR)
// 7:  FL FR FC LFE BC SL SR       (6.1 surround)
// 8:  FL FR FC LFE BL BR SL SR    (7.1 surround)

@[typedef]
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
@[typedef]
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

fn C.SDL_GetNumAudioDrivers() int

// get_num_audio_drivers gets the number of built-in audio drivers.
//
// This function returns a hardcoded number. This never returns a negative
// value; if there are no drivers compiled into this build of SDL, this
// function returns zero. The presence of a driver in this list does not mean
// it will function, it just means SDL is capable of interacting with that
// interface. For example, a build of SDL might have esound support, but if
// there's no esound server available, SDL's esound driver would fail if used.
//
// By default, SDL tries all drivers, in its preferred order, until one is
// found to be usable.
//
// returns the number of built-in audio drivers.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetAudioDriver
pub fn get_num_audio_drivers() int {
	return C.SDL_GetNumAudioDrivers()
}

fn C.SDL_GetAudioDriver(index int) &char

// get_audio_driver gets the name of a built in audio driver.
//
// The list of audio drivers is given in the order that they are normally
// initialized by default; the drivers that seem more reasonable to choose
// first (as far as the SDL developers believe) are earlier in the list.
//
// The names of drivers are all simple, low-ASCII identifiers, like "alsa",
// "coreaudio" or "xaudio2". These never have Unicode characters, and are not
// meant to be proper names.
//
// `index` the index of the audio driver; the value ranges from 0 to
//              SDL_GetNumAudioDrivers() - 1
// returns the name of the audio driver at the requested index, or NULL if an
//          invalid index was specified.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetNumAudioDrivers
pub fn get_audio_driver(index int) &char {
	return C.SDL_GetAudioDriver(index)
}

// audio_init
// Initialization and cleanup
//
// These functions are used internally, and should not be used unless
// you have a specific need to specify the audio driver you want to
// use. You should normally use SDL_Init() or SDL_InitSubSystem().

fn C.SDL_AudioInit(driver_name &char) int

// Use this function to initialize a particular audio driver.
//
// This function is used internally, and should not be used unless you have a
// specific need to designate the audio driver you want to use. You should
// normally use SDL_Init() or SDL_InitSubSystem().
//
// `driver_name` the name of the desired audio driver
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AudioQuit
pub fn audio_init(driver_name &char) int {
	return C.SDL_AudioInit(driver_name)
}

fn C.SDL_AudioQuit()

// Use this function to shut down audio if you initialized it with
// SDL_AudioInit().
//
// This function is used internally, and should not be used unless you have a
// specific need to specify the audio driver you want to use. You should
// normally use SDL_Quit() or SDL_QuitSubSystem().
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AudioInit
pub fn audio_quit() {
	C.SDL_AudioQuit()
}

// get_current_audio_driver gets the name of the current audio driver.
//
// The returned string points to internal static memory and thus never becomes
// invalid, even if you quit the audio subsystem and initialize a new driver
// (although such a case would return a different static string from another
// call to this function, of course). As such, you should not modify or free
// the returned string.
//
// returns the name of the current audio driver or NULL if no driver has been
// initialized.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AudioInit
pub fn get_current_audio_driver() &char {
	return C.SDL_GetCurrentAudioDriver()
}

fn C.SDL_GetCurrentAudioDriver() &char

// This function is a legacy means of opening the audio device.
//
// This function remains for compatibility with SDL 1.2, but also because it's
// slightly easier to use than the new functions in SDL 2.0. The new, more
// powerful, and preferred way to do this is SDL_OpenAudioDevice().
//
// This function is roughly equivalent to:
//
/*
```c
SDL_OpenAudioDevice(NULL, 0, desired, obtained, SDL_AUDIO_ALLOW_ANY_CHANGE);
```
*/
//
// With two notable exceptions:
//
// - If `obtained` is NULL, we use `desired` (and allow no changes), which
//   means desired will be modified to have the correct values for silence,
//   etc, and SDL will convert any differences between your app's specific
//   request and the hardware behind the scenes.
// - The return value is always success or failure, and not a device ID, which
//   means you can only have one device open at a time with this function.
//
// `desired` an SDL_AudioSpec structure representing the desired output
//           format. Please refer to the SDL_OpenAudioDevice
//           documentation for details on how to prepare this structure.
// `obtained` an SDL_AudioSpec structure filled in with the actual
//            parameters, or NULL.
// returns 0 if successful, placing the actual hardware parameters in the
// structure pointed to by `obtained`.
//
// If `obtained` is NULL, the audio data passed to the callback
// function will be guaranteed to be in the requested format, and
// will be automatically converted to the actual hardware audio
// format if necessary. If `obtained` is NULL, `desired` will have
// fields modified.
//
// This function returns a negative error code on failure to open the
// audio device or failure to set up the audio thread; call
// SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CloseAudio
// See also: SDL_LockAudio
// See also: SDL_PauseAudio
// See also: SDL_UnlockAudio
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

fn C.SDL_GetNumAudioDevices(iscapture int) int

// get_num_audio_devices gets the number of built-in audio devices.
//
// This function is only valid after successfully initializing the audio
// subsystem.
//
// Note that audio capture support is not implemented as of SDL 2.0.4, so the
// `iscapture` parameter is for future expansion and should always be zero for
// now.
//
// This function will return -1 if an explicit list of devices can't be
// determined. Returning -1 is not an error. For example, if SDL is set up to
// talk to a remote audio server, it can't list every one available on the
// Internet, but it will still allow a specific host to be specified in
// SDL_OpenAudioDevice().
//
// In many common cases, when this function returns a value <= 0, it can still
// successfully open the default device (NULL for first argument of
// SDL_OpenAudioDevice()).
//
// This function may trigger a complete redetect of available hardware. It
// should not be called for each iteration of a loop, but rather once at the
// start of a loop:
//
/*
```c
// Don't do this:
for (int i = 0; i < SDL_GetNumAudioDevices(0); i++)

// do this instead:
const int count = SDL_GetNumAudioDevices(0);
for (int i = 0; i < count; ++i) { do_something_here(); }
```
*/
//
// `iscapture` zero to request playback devices, non-zero to request
//             recording devices
// returns the number of available devices exposed by the current driver or
//         -1 if an explicit list of devices can't be determined. A return
//         value of -1 does not necessarily mean an error condition.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetAudioDeviceName
// See also: SDL_OpenAudioDevice
pub fn get_num_audio_devices(iscapture int) int {
	return C.SDL_GetNumAudioDevices(iscapture)
}

fn C.SDL_GetAudioDeviceName(index int, iscapture int) &char

// get_audio_device_name gets the human-readable name of a specific audio device.
//
// This function is only valid after successfully initializing the audio
// subsystem. The values returned by this function reflect the latest call to
// SDL_GetNumAudioDevices(); re-call that function to redetect available
// hardware.
//
// The string returned by this function is UTF-8 encoded, read-only, and
// managed internally. You are not to free it. If you need to keep the string
// for any length of time, you should make your own copy of it, as it will be
// invalid next time any of several other SDL functions are called.
//
// `index` the index of the audio device; valid values range from 0 to
//         SDL_GetNumAudioDevices() - 1
// `iscapture` non-zero to query the list of recording devices, zero to
//             query the list of output devices.
// returns the name of the audio device at the requested index, or NULL on
//         error.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetNumAudioDevices
// See also: SDL_GetDefaultAudioInfo
pub fn get_audio_device_name(index int, iscapture int) &char {
	return C.SDL_GetAudioDeviceName(index, iscapture)
}

fn C.SDL_GetAudioDeviceSpec(index int, iscapture int, spec &C.SDL_AudioSpec) int

// get_audio_device_spec gets the preferred audio format of a specific audio device.
//
// This function is only valid after a successfully initializing the audio
// subsystem. The values returned by this function reflect the latest call to
// SDL_GetNumAudioDevices(); re-call that function to redetect available
// hardware.
//
// `spec` will be filled with the sample rate, sample format, and channel
// count.
//
// `index` the index of the audio device; valid values range from 0 to
//         SDL_GetNumAudioDevices() - 1
// `iscapture` non-zero to query the list of recording devices, zero to
//             query the list of output devices.
// `spec` The SDL_AudioSpec to be initialized by this function.
// returns 0 on success, nonzero on error
//
// NOTE This function is available since SDL 2.0.16.
//
// See also: SDL_GetNumAudioDevices
// See also: SDL_GetDefaultAudioInfo
pub fn get_audio_device_spec(index int, iscapture int, spec &AudioSpec) int {
	return C.SDL_GetAudioDeviceSpec(index, iscapture, spec)
}

fn C.SDL_GetDefaultAudioInfo(name &&char, spec &AudioSpec, iscapture int) int

// get_default_audio_info gets the name and preferred format of the default audio device.
//
// Some (but not all!) platforms have an isolated mechanism to get information
// about the "default" device. This can actually be a completely different
// device that's not in the list you get from SDL_GetAudioDeviceSpec(). It can
// even be a network address! (This is discussed in SDL_OpenAudioDevice().)
//
// As a result, this call is not guaranteed to be performant, as it can query
// the sound server directly every time, unlike the other query functions. You
// should call this function sparingly!
//
// `spec` will be filled with the sample rate, sample format, and channel
// count, if a default device exists on the system. If `name` is provided,
// will be filled with either a dynamically-allocated UTF-8 string or NULL.
//
// `name`` A pointer to be filled with the name of the default device (can
//             be NULL). Please call SDL_free() when you are done with this
//             pointer!
// `spec`` The SDL_AudioSpec to be initialized by this function.
// `iscapture` non-zero to query the default recording device, zero to
//                  query the default output device.
// returns 0 on success, nonzero on error
//
// NOTE This function is available since SDL 2.24.0.
//
// See also: SDL_GetAudioDeviceName
// See also: SDL_GetAudioDeviceSpec
// See also: SDL_OpenAudioDevice
pub fn get_default_audio_info(name &&char, spec &AudioSpec, iscapture int) int {
	return C.SDL_GetDefaultAudioInfo(name, spec, iscapture)
}

// open_audio_device opens a specific audio device.
//
// SDL_OpenAudio(), unlike this function, always acts on device ID 1. As such,
// this function will never return a 1 so as not to conflict with the legacy
// function.
//
// Please note that SDL 2.0 before 2.0.5 did not support recording; as such,
// this function would fail if `iscapture` was not zero. Starting with SDL
// 2.0.5, recording is implemented and this value can be non-zero.
//
// Passing in a `device` name of NULL requests the most reasonable default
// (and is equivalent to what SDL_OpenAudio() does to choose a device). The
// `device` name is a UTF-8 string reported by SDL_GetAudioDeviceName(), but
// some drivers allow arbitrary and driver-specific strings, such as a
// hostname/IP address for a remote audio server, or a filename in the
// diskaudio driver.
//
// An opened audio device starts out paused, and should be enabled for playing
// by calling SDL_PauseAudioDevice(devid, 0) when you are ready for your audio
// callback function to be called. Since the audio driver may modify the
// requested size of the audio buffer, you should allocate any local mixing
// buffers after you open the audio device.
//
// The audio callback runs in a separate thread in most cases; you can prevent
// race conditions between your callback and other threads without fully
// pausing playback with SDL_LockAudioDevice(). For more information about the
// callback, see SDL_AudioSpec.
//
// Managing the audio spec via 'desired' and 'obtained':
//
// When filling in the desired audio spec structure:
//
// - `desired->freq` should be the frequency in sample-frames-per-second (Hz).
// - `desired->format` should be the audio format (`AUDIO_S16SYS`, etc).
// - `desired->samples` is the desired size of the audio buffer, in _sample
//   frames_ (with stereo output, two samples--left and right--would make a
//   single sample frame). This number should be a power of two, and may be
//   adjusted by the audio driver to a value more suitable for the hardware.
//   Good values seem to range between 512 and 8096 inclusive, depending on
//   the application and CPU speed. Smaller values reduce latency, but can
//   lead to underflow if the application is doing heavy processing and cannot
//   fill the audio buffer in time. Note that the number of sample frames is
//   directly related to time by the following formula: `ms =
//   (sampleframes*1000)/freq`
// - `desired->size` is the size in _bytes_ of the audio buffer, and is
//   calculated by SDL_OpenAudioDevice(). You don't initialize this.
// - `desired->silence` is the value used to set the buffer to silence, and is
//   calculated by SDL_OpenAudioDevice(). You don't initialize this.
// - `desired->callback` should be set to a function that will be called when
//   the audio device is ready for more data. It is passed a pointer to the
//   audio buffer, and the length in bytes of the audio buffer. This function
//   usually runs in a separate thread, and so you should protect data
//   structures that it accesses by calling SDL_LockAudioDevice() and
//   SDL_UnlockAudioDevice() in your code. Alternately, you may pass a NULL
//   pointer here, and call SDL_QueueAudio() with some frequency, to queue
//   more audio samples to be played (or for capture devices, call
//   SDL_DequeueAudio() with some frequency, to obtain audio samples).
// - `desired->userdata` is passed as the first parameter to your callback
//   function. If you passed a NULL callback, this value is ignored.
//
// `allowed_changes` can have the following flags OR'd together:
//
// - `SDL_AUDIO_ALLOW_FREQUENCY_CHANGE`
// - `SDL_AUDIO_ALLOW_FORMAT_CHANGE`
// - `SDL_AUDIO_ALLOW_CHANNELS_CHANGE`
// - `SDL_AUDIO_ALLOW_SAMPLES_CHANGE`
// - `SDL_AUDIO_ALLOW_ANY_CHANGE`
//
// These flags specify how SDL should behave when a device cannot offer a
// specific feature. If the application requests a feature that the hardware
// doesn't offer, SDL will always try to get the closest equivalent.
//
// For example, if you ask for float32 audio format, but the sound card only
// supports int16, SDL will set the hardware to int16. If you had set
// SDL_AUDIO_ALLOW_FORMAT_CHANGE, SDL will change the format in the `obtained`
// structure. If that flag was *not* set, SDL will prepare to convert your
// callback's float32 audio to int16 before feeding it to the hardware and
// will keep the originally requested format in the `obtained` structure.
//
// The resulting audio specs, varying depending on hardware and on what
// changes were allowed, will then be written back to `obtained`.
//
// If your application can only handle one specific data format, pass a zero
// for `allowed_changes` and let SDL transparently handle any differences.
//
// `device` a UTF-8 string reported by SDL_GetAudioDeviceName() or a
//          driver-specific name as appropriate. NULL requests the most
//          reasonable default device.
// `iscapture` non-zero to specify a device should be opened for
//             recording, not playback
// `desired` an SDL_AudioSpec structure representing the desired output
//           format; see SDL_OpenAudio() for more information
// `obtained` an SDL_AudioSpec structure filled in with the actual output
//            format; see SDL_OpenAudio() for more information
// `allowed_changes` 0, or one or more flags OR'd together
// returns a valid device ID that is > 0 on success or 0 on failure; call
//         SDL_GetError() for more information.
//
//         For compatibility with SDL 1.2, this will never return 1, since
//         SDL reserves that ID for the legacy SDL_OpenAudio() function.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CloseAudioDevice
// See also: SDL_GetAudioDeviceName
// See also: SDL_LockAudioDevice
// See also: SDL_OpenAudio
// See also: SDL_PauseAudioDevice
// See also: SDL_UnlockAudioDevice
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

fn C.SDL_GetAudioStatus() AudioStatus

// get_audio_status is a legacy means of querying the audio device.
//
// New programs might want to use SDL_GetAudioDeviceStatus() instead. This
// function is equivalent to calling...
//
// ```c
// SDL_GetAudioDeviceStatus(1);
// ```
//
// ...and is only useful if you used the legacy SDL_OpenAudio() function.
//
// returns the SDL_AudioStatus of the audio device opened by SDL_OpenAudio().
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetAudioDeviceStatus
pub fn get_audio_status() AudioStatus {
	return AudioStatus(C.SDL_GetAudioStatus())
}

fn C.SDL_GetAudioDeviceStatus(dev AudioDeviceID) AudioStatus

// get_audio_device_status gets the current audio state of an audio device.
//
// `dev` the ID of an audio device previously opened with
//            SDL_OpenAudioDevice()
// returns the SDL_AudioStatus of the specified audio device.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_PauseAudioDevice
pub fn get_audio_device_status(dev AudioDeviceID) AudioStatus {
	return AudioStatus(C.SDL_GetAudioDeviceStatus(dev))
}

// Pause audio functions
//
// These functions pause and unpause the audio callback processing.
// They should be called with a parameter of 0 after opening the audio
// device to start playing sound.  This is so you can safely initialize
// data for your callback function after opening the audio device.
// Silence will be written to the audio device during the pause.

fn C.SDL_PauseAudio(pause_on int)

// pause_audio is a legacy means of pausing the audio device.
//
// New programs might want to use SDL_PauseAudioDevice() instead. This
// function is equivalent to calling...
//
/*
```c
 SDL_PauseAudioDevice(1, pause_on);
```
*/
//
// ...and is only useful if you used the legacy SDL_OpenAudio() function.
//
// `pause_on` non-zero to pause, 0 to unpause
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetAudioStatus
// See also: SDL_PauseAudioDevice
pub fn pause_audio(pause_on int) {
	C.SDL_PauseAudio(pause_on)
}

fn C.SDL_PauseAudioDevice(dev C.SDL_AudioDeviceID, pause_on int)

// Use this function to pause and unpause audio playback on a specified
// device.
//
// This function pauses and unpauses the audio callback processing for a given
// device. Newly-opened audio devices start in the paused state, so you must
// call this function with **pause_on**=0 after opening the specified audio
// device to start playing sound. This allows you to safely initialize data
// for your callback function after opening the audio device. Silence will be
// written to the audio device while paused, and the audio callback is
// guaranteed to not be called. Pausing one device does not prevent other
// unpaused devices from running their callbacks.
//
// Pausing state does not stack; even if you pause a device several times, a
// single unpause will start the device playing again, and vice versa. This is
// different from how SDL_LockAudioDevice() works.
//
// If you just need to protect a few variables from race conditions vs your
// callback, you shouldn't pause the audio device, as it will lead to dropouts
// in the audio playback. Instead, you should use SDL_LockAudioDevice().
//
// `dev` a device opened by SDL_OpenAudioDevice()
// `pause_on` non-zero to pause, 0 to unpause
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LockAudioDevice
pub fn pause_audio_device(dev AudioDeviceID, pause_on int) {
	C.SDL_PauseAudioDevice(C.SDL_AudioDeviceID(dev), pause_on)
}

fn C.SDL_LoadWAV_RW(src &C.SDL_RWops, freesrc int, spec &C.SDL_AudioSpec, audio_buf &&u8, audio_len &u32) &C.SDL_AudioSpec

// load_wav_rw loads the audio data of a WAVE file into memory.
//
// Loading a WAVE file requires `src`, `spec`, `audio_buf` and `audio_len` to
// be valid pointers. The entire data portion of the file is then loaded into
// memory and decoded if necessary.
//
// If `freesrc` is non-zero, the data source gets automatically closed and
// freed before the function returns.
//
// Supported formats are RIFF WAVE files with the formats PCM (8, 16, 24, and
// 32 bits), IEEE Float (32 bits), Microsoft ADPCM and IMA ADPCM (4 bits), and
// A-law and mu-law (8 bits). Other formats are currently unsupported and
// cause an error.
//
// If this function succeeds, the pointer returned by it is equal to `spec`
// and the pointer to the audio data allocated by the function is written to
// `audio_buf` and its length in bytes to `audio_len`. The SDL_AudioSpec
// members `freq`, `channels`, and `format` are set to the values of the audio
// data in the buffer. The `samples` member is set to a sane default and all
// others are set to zero.
//
// It's necessary to use SDL_FreeWAV() to free the audio data returned in
// `audio_buf` when it is no longer used.
//
// Because of the underspecification of the .WAV format, there are many
// problematic files in the wild that cause issues with strict decoders. To
// provide compatibility with these files, this decoder is lenient in regards
// to the truncation of the file, the fact chunk, and the size of the RIFF
// chunk. The hints `SDL_HINT_WAVE_RIFF_CHUNK_SIZE`,
// `SDL_HINT_WAVE_TRUNCATION`, and `SDL_HINT_WAVE_FACT_CHUNK` can be used to
// tune the behavior of the loading process.
//
// Any file that is invalid (due to truncation, corruption, or wrong values in
// the headers), too big, or unsupported causes an error. Additionally, any
// critical I/O error from the data source will terminate the loading process
// with an error. The function returns NULL on error and in all cases (with
// the exception of `src` being NULL), an appropriate error message will be
// set.
//
// It is required that the data source supports seeking.
//
// Example:
//
/*
```c
 SDL_LoadWAV_RW(SDL_RWFromFile("sample.wav", "rb"), 1, &spec, &buf, &len);
```
*/
//
// Note that the SDL_LoadWAV macro does this same thing for you, but in a less
// messy way:
//
/*
```c
 SDL_LoadWAV("sample.wav", &spec, &buf, &len);
```
*/
//
// `src` The data source for the WAVE data
// `freesrc` If non-zero, SDL will _always_ free the data source
// `spec` An SDL_AudioSpec that will be filled in with the wave file's
//        format details
// `audio_buf` A pointer filled with the audio data, allocated by the
//             function.
// `audio_len` A pointer filled with the length of the audio data buffer
//             in bytes
// returns This function, if successfully called, returns `spec`, which will
//         be filled with the audio data format of the wave source data.
//         `audio_buf` will be filled with a pointer to an allocated buffer
//         containing the audio data, and `audio_len` is filled with the
//         length of that audio buffer in bytes.
//
//         This function returns NULL if the .WAV file cannot be opened, uses
//         an unknown data format, or is corrupt; call SDL_GetError() for
//         more information.
//
//         When the application is done with the data returned in
//         `audio_buf`, it should call SDL_FreeWAV() to dispose of it.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_FreeWAV
// See also: SDL_LoadWAV
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

// free_wav frees data previously allocated with SDL_LoadWAV() or SDL_LoadWAV_RW().
//
// After a WAVE file has been opened with SDL_LoadWAV() or SDL_LoadWAV_RW()
// its data can eventually be freed with SDL_FreeWAV(). It is safe to call
// this function with a NULL pointer.
//
// `audio_buf` a pointer to the buffer created by SDL_LoadWAV() or
//             SDL_LoadWAV_RW()
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LoadWAV
// See also: SDL_LoadWAV_RW
pub fn free_wav(audio_buf &u8) {
	C.SDL_FreeWAV(audio_buf)
}

fn C.SDL_BuildAudioCVT(cvt &C.SDL_AudioCVT, src_format C.SDL_AudioFormat, src_channels u8, src_rate int, dst_format C.SDL_AudioFormat, dst_channels u8, dst_rate int) int

// build_audio_cvt initializes an SDL_AudioCVT structure for conversion.
//
// Before an SDL_AudioCVT structure can be used to convert audio data it must
// be initialized with source and destination information.
//
// This function will zero out every field of the SDL_AudioCVT, so it must be
// called before the application fills in the final buffer information.
//
// Once this function has returned successfully, and reported that a
// conversion is necessary, the application fills in the rest of the fields in
// SDL_AudioCVT, now that it knows how large a buffer it needs to allocate,
// and then can call SDL_ConvertAudio() to complete the conversion.
//
// `cvt` an SDL_AudioCVT structure filled in with audio conversion
//       information
// `src_format` the source format of the audio data; for more info see
//              SDL_AudioFormat
// `src_channels` the number of channels in the source
// `src_rate` the frequency (sample-frames-per-second) of the source
// `dst_format` the destination format of the audio data; for more info
//              see SDL_AudioFormat
// `dst_channels` the number of channels in the destination
// `dst_rate` the frequency (sample-frames-per-second) of the destination
// returns 1 if the audio filter is prepared, 0 if no conversion is needed,
//         or a negative error code on failure; call SDL_GetError() for more
//         information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_ConvertAudio
pub fn build_audio_cvt(cvt &AudioCVT, src_format AudioFormat, src_channels u8, src_rate int, dst_format AudioFormat, dst_channels u8, dst_rate int) int {
	return C.SDL_BuildAudioCVT(cvt, C.SDL_AudioFormat(src_format), src_channels, src_rate,
		C.SDL_AudioFormat(dst_format), dst_channels, dst_rate)
}

fn C.SDL_ConvertAudio(cvt &C.SDL_AudioCVT) int

// convert_audio converts audio data to a desired audio format.
//
// This function does the actual audio data conversion, after the application
// has called SDL_BuildAudioCVT() to prepare the conversion information and
// then filled in the buffer details.
//
// Once the application has initialized the `cvt` structure using
// SDL_BuildAudioCVT(), allocated an audio buffer and filled it with audio
// data in the source format, this function will convert the buffer, in-place,
// to the desired format.
//
// The data conversion may go through several passes; any given pass may
// possibly temporarily increase the size of the data. For example, SDL might
// expand 16-bit data to 32 bits before resampling to a lower frequency,
// shrinking the data size after having grown it briefly. Since the supplied
// buffer will be both the source and destination, converting as necessary
// in-place, the application must allocate a buffer that will fully contain
// the data during its largest conversion pass. After SDL_BuildAudioCVT()
// returns, the application should set the `cvt->len` field to the size, in
// bytes, of the source data, and allocate a buffer that is `cvt->len *
// cvt->len_mult` bytes long for the `buf` field.
//
// The source data should be copied into this buffer before the call to
// SDL_ConvertAudio(). Upon successful return, this buffer will contain the
// converted audio, and `cvt->len_cvt` will be the size of the converted data,
// in bytes. Any bytes in the buffer past `cvt->len_cvt` are undefined once
// this function returns.
//
// `cvt` an SDL_AudioCVT structure that was previously set up by
//       SDL_BuildAudioCVT().
// returns 0 if the conversion was completed successfully or a negative error
//         code on failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_BuildAudioCVT
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
@[typedef]
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
// NOTE This function is available since SDL 2.0.7.
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
// NOTE This function is available since SDL 2.0.7.
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
// returns the number of bytes read from the stream, or -1 on error
//
// NOTE This function is available since SDL 2.0.7.
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

// audio_stream_available gets the number of converted/resampled bytes available.
//
// The stream may be buffering data behind the scenes until it has enough to
// resample correctly, so this number might be lower than what you expect, or
// even be zero. Add more data or flush the stream if you need the data now.
//
// NOTE This function is available since SDL 2.0.7.
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

// audio_stream_flush tells the stream that you're done sending data, and anything being buffered
// should be converted/resampled and made available immediately.
//
// It is legal to add more data to a stream after flushing, but there will be
// audio gaps in the output. Generally this is intended to signal the end of
// input, so the complete output becomes available.
//
// NOTE This function is available since SDL 2.0.7.
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
// NOTE This function is available since SDL 2.0.7.
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
// NOTE This function is available since SDL 2.0.7.
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

// mix_audio this function is a legacy means of mixing audio.
//
// This function is equivalent to calling
//
/*
```c
 SDL_MixAudioFormat(dst, src, format, len, volume);
```
*/
//
// where `format` is the obtained format of the audio device from the
// legacy SDL_OpenAudio() function.
//
// `dst` the destination for the mixed audio
// `src` the source audio buffer to be mixed
// `len` the length of the audio buffer in bytes
// `volume` ranges from 0 - 128, and should be set to SDL_MIX_MAXVOLUME
//          for full audio volume
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_MixAudioFormat
pub fn mix_audio(dst &u8, const_src &u8, len u32, volume int) {
	C.SDL_MixAudio(dst, const_src, len, volume)
}

fn C.SDL_MixAudioFormat(dst &u8, const_src &u8, format C.SDL_AudioFormat, len u32, volume int)

// mix_audio_format mixes audio data in a specified format.
//
// This takes an audio buffer `src` of `len` bytes of `format` data and mixes
// it into `dst`, performing addition, volume adjustment, and overflow
// clipping. The buffer pointed to by `dst` must also be `len` bytes of
// `format` data.
//
// This is provided for convenience -- you can mix your own audio data.
//
// Do not use this function for mixing together more than two streams of
// sample data. The output from repeated application of this function may be
// distorted by clipping, because there is no accumulator with greater range
// than the input (not to mention this being an inefficient way of doing it).
//
// It is a common misconception that this function is required to write audio
// data to an output stream in an audio callback. While you can do that,
// SDL_MixAudioFormat() is really only needed when you're mixing a single
// audio stream with a volume adjustment.
//
// `dst` the destination for the mixed audio
// `src` the source audio buffer to be mixed
// `format` the SDL_AudioFormat structure representing the desired audio
//          format
// `len` the length of the audio buffer in bytes
// `volume` ranges from 0 - 128, and should be set to SDL_MIX_MAXVOLUME
//          for full audio volume
//
// NOTE This function is available since SDL 2.0.0.
pub fn mix_audio_format(dst &u8, const_src &u8, format AudioFormat, len u32, volume int) {
	C.SDL_MixAudioFormat(dst, const_src, C.SDL_AudioFormat(format), len, volume)
}

fn C.SDL_QueueAudio(dev C.SDL_AudioDeviceID, const_data voidptr, len u32) int

// queue_audio queues more audio on non-callback devices.
//
// If you are looking to retrieve queued audio from a non-callback capture
// device, you want SDL_DequeueAudio() instead. SDL_QueueAudio() will return
// -1 to signify an error if you use it with capture devices.
//
// SDL offers two ways to feed audio to the device: you can either supply a
// callback that SDL triggers with some frequency to obtain more audio (pull
// method), or you can supply no callback, and then SDL will expect you to
// supply data at regular intervals (push method) with this function.
//
// There are no limits on the amount of data you can queue, short of
// exhaustion of address space. Queued data will drain to the device as
// necessary without further intervention from you. If the device needs audio
// but there is not enough queued, it will play silence to make up the
// difference. This means you will have skips in your audio playback if you
// aren't routinely queueing sufficient data.
//
// This function copies the supplied data, so you are safe to free it when the
// function returns. This function is thread-safe, but queueing to the same
// device from two threads at once does not promise which buffer will be
// queued first.
//
// You may not queue audio on a device that is using an application-supplied
// callback; doing so returns an error. You have to use the audio callback or
// queue audio with this function, but not both.
//
// You should not call SDL_LockAudio() on the device before queueing; SDL
// handles locking internally for this function.
//
// Note that SDL2 does not support planar audio. You will need to resample
// from planar audio formats into a non-planar one (see SDL_AudioFormat)
// before queuing audio.
//
// `dev` the device ID to which we will queue audio
// `data` the data to queue to the device for later playback
// `len` the number of bytes (not samples!) to which `data` points
// returns 0 on success or a negative error code on failure; call
//         SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.4.
//
// See also: SDL_ClearQueuedAudio
// See also: SDL_GetQueuedAudioSize
pub fn queue_audio(dev AudioDeviceID, const_data voidptr, len u32) int {
	return C.SDL_QueueAudio(C.SDL_AudioDeviceID(dev), const_data, len)
}

fn C.SDL_DequeueAudio(dev C.SDL_AudioDeviceID, data voidptr, len u32) u32

// dequeue_audio dequeues more audio on non-callback devices.
//
// If you are looking to queue audio for output on a non-callback playback
// device, you want SDL_QueueAudio() instead. SDL_DequeueAudio() will always
// return 0 if you use it with playback devices.
//
// SDL offers two ways to retrieve audio from a capture device: you can either
// supply a callback that SDL triggers with some frequency as the device
// records more audio data, (push method), or you can supply no callback, and
// then SDL will expect you to retrieve data at regular intervals (pull
// method) with this function.
//
// There are no limits on the amount of data you can queue, short of
// exhaustion of address space. Data from the device will keep queuing as
// necessary without further intervention from you. This means you will
// eventually run out of memory if you aren't routinely dequeueing data.
//
// Capture devices will not queue data when paused; if you are expecting to
// not need captured audio for some length of time, use SDL_PauseAudioDevice()
// to stop the capture device from queueing more data. This can be useful
// during, say, level loading times. When unpaused, capture devices will start
// queueing data from that point, having flushed any capturable data available
// while paused.
//
// This function is thread-safe, but dequeueing from the same device from two
// threads at once does not promise which thread will dequeue data first.
//
// You may not dequeue audio from a device that is using an
// application-supplied callback; doing so returns an error. You have to use
// the audio callback, or dequeue audio with this function, but not both.
//
// You should not call SDL_LockAudio() on the device before dequeueing; SDL
// handles locking internally for this function.
//
// `dev` the device ID from which we will dequeue audio
// `data` a pointer into where audio data should be copied
// `len` the number of bytes (not samples!) to which (data) points
// returns the number of bytes dequeued, which could be less than requested;
//         call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_ClearQueuedAudio
// See also: SDL_GetQueuedAudioSize
pub fn dequeue_audio(dev AudioDeviceID, data voidptr, len u32) u32 {
	return C.SDL_DequeueAudio(C.SDL_AudioDeviceID(dev), data, len)
}

fn C.SDL_GetQueuedAudioSize(dev C.SDL_AudioDeviceID) u32

// get_queued_audio_size gets the number of bytes of still-queued audio.
//
// For playback devices: this is the number of bytes that have been queued for
// playback with SDL_QueueAudio(), but have not yet been sent to the hardware.
//
// Once we've sent it to the hardware, this function can not decide the exact
// byte boundary of what has been played. It's possible that we just gave the
// hardware several kilobytes right before you called this function, but it
// hasn't played any of it yet, or maybe half of it, etc.
//
// For capture devices, this is the number of bytes that have been captured by
// the device and are waiting for you to dequeue. This number may grow at any
// time, so this only informs of the lower-bound of available data.
//
// You may not queue or dequeue audio on a device that is using an
// application-supplied callback; calling this function on such a device
// always returns 0. You have to use the audio callback or queue audio, but
// not both.
//
// You should not call SDL_LockAudio() on the device before querying; SDL
// handles locking internally for this function.
//
// `dev` the device ID of which we will query queued audio size
// returns the number of bytes (not samples!) of queued audio.
//
// NOTE This function is available since SDL 2.0.4.
//
// See also: SDL_ClearQueuedAudio
// See also: SDL_QueueAudio
// See also: SDL_DequeueAudio
pub fn get_queued_audio_size(dev AudioDeviceID) u32 {
	return C.SDL_GetQueuedAudioSize(C.SDL_AudioDeviceID(dev))
}

fn C.SDL_ClearQueuedAudio(dev C.SDL_AudioDeviceID)

// clear_queued_audio drops any queued audio data waiting to be sent to the hardware.
//
// Immediately after this call, SDL_GetQueuedAudioSize() will return 0. For
// output devices, the hardware will start playing silence if more audio isn't
// queued. For capture devices, the hardware will start filling the empty
// queue with new data if the capture device isn't paused.
//
// This will not prevent playback of queued audio that's already been sent to
// the hardware, as we can not undo that, so expect there to be some fraction
// of a second of audio that might still be heard. This can be useful if you
// want to, say, drop any pending music or any unprocessed microphone input
// during a level change in your game.
//
// You may not queue or dequeue audio on a device that is using an
// application-supplied callback; calling this function on such a device
// always returns 0. You have to use the audio callback or queue audio, but
// not both.
//
// You should not call SDL_LockAudio() on the device before clearing the
// queue; SDL handles locking internally for this function.
//
// This function always succeeds and thus returns void.
//
// `dev` the device ID of which to clear the audio queue
//
// NOTE This function is available since SDL 2.0.4.
//
// See also: SDL_GetQueuedAudioSize
// See also: SDL_QueueAudio
// See also: SDL_DequeueAudio
pub fn clear_queued_audio(dev AudioDeviceID) {
	C.SDL_ClearQueuedAudio(C.SDL_AudioDeviceID(dev))
}

// Audio lock functions
//
// The lock manipulated by these functions protects the callback function.
// During a SDL_LockAudio()/SDL_UnlockAudio() pair, you can be guaranteed that
// the callback function is not running.  Do not call these from the callback
// function or you will cause deadlock.

fn C.SDL_LockAudio()

// lock_audio is a legacy means of locking the audio device.
//
// New programs might want to use SDL_LockAudioDevice() instead. This function
// is equivalent to calling...
//
// ```c
// SDL_LockAudioDevice(1);
// ```
//
// ...and is only useful if you used the legacy SDL_OpenAudio() function.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LockAudioDevice
// See also: SDL_UnlockAudio
// See also: SDL_UnlockAudioDevice
pub fn lock_audio() {
	C.SDL_LockAudio()
}

fn C.SDL_LockAudioDevice(dev C.SDL_AudioDeviceID)

// lock_audio_device locks out the audio callback function for a specified
// device.
//
// The lock manipulated by these functions protects the audio callback
// function specified in SDL_OpenAudioDevice(). During a
// SDL_LockAudioDevice()/SDL_UnlockAudioDevice() pair, you can be guaranteed
// that the callback function for that device is not running, even if the
// device is not paused. While a device is locked, any other unpaused,
// unlocked devices may still run their callbacks.
//
// Calling this function from inside your audio callback is unnecessary. SDL
// obtains this lock before calling your function, and releases it when the
// function returns.
//
// You should not hold the lock longer than absolutely necessary. If you hold
// it too long, you'll experience dropouts in your audio playback. Ideally,
// your application locks the device, sets a few variables and unlocks again.
// Do not do heavy work while holding the lock for a device.
//
// It is safe to lock the audio device multiple times, as long as you unlock
// it an equivalent number of times. The callback will not run until the
// device has been unlocked completely in this way. If your application fails
// to unlock the device appropriately, your callback will never run, you might
// hear repeating bursts of audio, and SDL_CloseAudioDevice() will probably
// deadlock.
//
// Internally, the audio device lock is a mutex; if you lock from two threads
// at once, not only will you block the audio callback, you'll block the other
// thread.
//
// `dev` the ID of the device to be locked
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_UnlockAudioDevice
pub fn lock_audio_device(dev AudioDeviceID) {
	C.SDL_LockAudioDevice(C.SDL_AudioDeviceID(dev))
}

fn C.SDL_UnlockAudio()

// unlock_audio is a legacy means of unlocking the audio device.
//
// New programs might want to use SDL_UnlockAudioDevice() instead. This
// function is equivalent to calling...
//
// ```c
// SDL_UnlockAudioDevice(1);
// ```
//
// ...and is only useful if you used the legacy SDL_OpenAudio() function.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LockAudio
// See also: SDL_UnlockAudioDevice
pub fn unlock_audio() {
	C.SDL_UnlockAudio()
}

fn C.SDL_UnlockAudioDevice(dev C.SDL_AudioDeviceID)

// unlock_audio_device unlocks the audio callback function for a specified
// device.
//
// This function should be paired with a previous SDL_LockAudioDevice() call.
//
// `dev` the ID of the device to be unlocked
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LockAudioDevice
pub fn unlock_audio_device(dev AudioDeviceID) {
	C.SDL_UnlockAudioDevice(C.SDL_AudioDeviceID(dev))
}

fn C.SDL_CloseAudio()

// close_audio is legacy means of closing the audio device.
//
// This function is equivalent to calling...
//
/*
```c
 SDL_CloseAudioDevice(1);
```
*/
//
// ...and is only useful if you used the legacy SDL_OpenAudio() function.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_OpenAudio
pub fn close_audio() {
	C.SDL_CloseAudio()
}

fn C.SDL_CloseAudioDevice(dev C.SDL_AudioDeviceID)

// close_audio_device uses this function to shut down audio processing and close the audio device.
//
// The application should close open audio devices once they are no longer
// needed. Calling this function will wait until the device's audio callback
// is not running, release the audio hardware and then clean up internal
// state. No further audio will play from this device once this function
// returns.
//
// This function may block briefly while pending audio data is played by the
// hardware, so that applications don't drop the last buffer of data they
// supplied.
//
// The device ID is invalid as soon as the device is closed, and is eligible
// for reuse in a new SDL_OpenAudioDevice() call immediately.
//
// `dev` an audio device previously opened with SDL_OpenAudioDevice()
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_OpenAudioDevice
pub fn close_audio_device(dev AudioDeviceID) {
	C.SDL_CloseAudioDevice(C.SDL_AudioDeviceID(dev))
}
