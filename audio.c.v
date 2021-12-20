// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_audio.h
//

/**
 *  \brief Audio format flags.
 *
 *  These are what the 16 bits in SDL_AudioFormat currently mean...
 *  (Unspecified bits are always zero).
 *
 *  \verbatim
    ++-----------------------sample is signed if set
    ||
    ||       ++-----------sample is bigendian if set
    ||       ||
    ||       ||          ++---sample is float if set
    ||       ||          ||
    ||       ||          || +---sample bit size---+
    ||       ||          || |                     |
    15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
    \endverbatim
 *
 *  There are macros in SDL 2.0 and later to query these bits.
*/
// typedef Uint16 SDL_AudioFormat;
type AudioFormat = u16

/**
 *  \name Audio flags
*/
const (
	audio_mask_bitsize  = C.SDL_AUDIO_MASK_BITSIZE
	audio_mask_datatype = C.SDL_AUDIO_MASK_DATATYPE
	audio_mask_endian   = C.SDL_AUDIO_MASK_ENDIAN
	audio_mask_signed   = C.SDL_AUDIO_MASK_SIGNED
		/*
		audio_bitsize           = C.SDL_AUDIO_BITSIZE(x)
audio_isfloat           = C.SDL_AUDIO_ISFLOAT(x)
audio_isbigendian           = C.SDL_AUDIO_ISBIGENDIAN(x)
audio_issigned           = C.SDL_AUDIO_ISSIGNED(x)
audio_isint           = C.SDL_AUDIO_ISINT(x)
audio_islittleendian           = C.SDL_AUDIO_ISLITTLEENDIAN(x)
audio_isunsigned           = C.SDL_AUDIO_ISUNSIGNED(x)
		*/
)

/**
 *  \name Audio format flags
 *
 *  Defaults to LSB byte order.
*/
const (
	audio_u8     = C.AUDIO_U8 // 0x0008, Unsigned 8-bit samples */
	audio_s8     = C.AUDIO_S8 // 0x8008, Signed 8-bit samples */
	audio_u16lsb = C.AUDIO_U16LSB // 0x0010, Unsigned 16-bit samples */
	audio_s16lsb = C.AUDIO_S16LSB // 0x8010, Signed 16-bit samples */
	audio_u16msb = C.AUDIO_U16MSB // 0x1010, As above, but big-endian byte order */
	audio_s16msb = C.AUDIO_S16MSB // 0x9010, As above, but big-endian byte order */
	audio_u16    = C.AUDIO_U16 // AUDIO_U16LSB
	audio_s16    = C.AUDIO_S16 // AUDIO_S16LSB
)

/**
 *  \name int32 support
*/
const (
	audio_s32lsb = C.AUDIO_S32LSB // 0x8020, 32-bit integer samples */
	audio_s32msb = C.AUDIO_S32MSB // 0x9020, As above, but big-endian byte order */
	audio_s32    = C.AUDIO_S32 // AUDIO_S32LSB
)

/**
 *  \name float32 support
*/
const (
	audio_f32lsb = C.AUDIO_F32LSB // 0x8120, 32-bit floating point samples */
	audio_f32msb = C.AUDIO_F32MSB // 0x9120, As above, but big-endian byte order */
	audio_f32    = C.AUDIO_F32
)

/**
 *  \name Native audio byte ordering
*/
const (
	audio_u16sys = C.AUDIO_U16SYS
	audio_s16sys = C.AUDIO_S16SYS
	audio_s32sys = C.AUDIO_S32SYS
	audio_f32sys = C.AUDIO_F32SYS
)

/**
 *  \name Allow change flags
 *
 *  Which audio format changes are allowed when opening a device.
*/
const (
	audio_allow_frequency_change = C.SDL_AUDIO_ALLOW_FREQUENCY_CHANGE // 0x00000001
	audio_allow_format_change    = C.SDL_AUDIO_ALLOW_FORMAT_CHANGE // 0x00000002
	audio_allow_channels_change  = C.SDL_AUDIO_ALLOW_CHANNELS_CHANGE // 0x00000004
	audio_allow_any_change       = C.SDL_AUDIO_ALLOW_ANY_CHANGE
)

/**
 *  This function is called when the audio device needs more data.
 *
 *  \param userdata An application-specific parameter saved in
 *                  the SDL_AudioSpec structure
 *  \param stream A pointer to the audio data buffer.
 *  \param len    The length of that buffer in bytes.
 *
 *  Once the callback returns, the buffer will no longer be valid.
 *  Stereo samples are stored in a LRLRLR ordering.
 *
 *  You can choose to avoid callbacks and use SDL_QueueAudio() instead, if
 *  you like. Just open your audio device with a NULL callback.
*/
// typedef void (SDLCALL * SDL_AudioCallback) (void *userdata, Uint8 * stream,
type AudioCallback = fn (userdata voidptr, stream &byte)

/**
 *  The calculated values in this structure are calculated by SDL_OpenAudio().
 *
 *  For multi-channel audio, the default SDL channel mapping is:
 *  2:  FL FR                       (stereo)
 *  3:  FL FR LFE                   (2.1 surround)
 *  4:  FL FR BL BR                 (quad)
 *  5:  FL FR FC BL BR              (quad + center)
 *  6:  FL FR FC LFE SL SR          (5.1 surround - last two can also be BL BR)
 *  7:  FL FR FC LFE BC SL SR       (6.1 surround)
 *  8:  FL FR FC LFE BL BR SL SR    (7.1 surround)
*/
[typedef]
struct C.SDL_AudioSpec {
	freq     int // DSP frequency -- samples per second
	format   AudioFormat // C.SDL_AudioFormat Audio data format
	channels byte        // Number of channels: 1 mono, 2 stereo
	silence  byte        // Audio buffer silence value (calculated)
	samples  u16 // Audio buffer size in sample FRAMES (total samples divided by channel count)
	padding  u16 // Necessary for some compile environments
	size     u32 // Audio buffer size in bytes (calculated)
	callback AudioCallback // C.SDL_AudioCallback // Callback that feeds the audio device (NULL to use SDL_QueueAudio()).
	userdata voidptr       // Userdata passed to callback (ignored for NULL callbacks).
}

pub type AudioSpec = C.SDL_AudioSpec

// typedef void (SDLCALL * SDL_AudioFilter) (struct SDL_AudioCVT * cvt, SDL_AudioFormat format);
type AudioFilter = fn (cvt &AudioCVT, format AudioFormat)

/**
 *  \brief Upper limit of filters in SDL_AudioCVT
 *
 *  The maximum number of SDL_AudioFilter functions in SDL_AudioCVT is
 *  currently limited to 9. The SDL_AudioCVT.filters array has 10 pointers,
 *  one of which is the terminating NULL pointer.
*/
const audiocvt_max_filters = C.SDL_AUDIOCVT_MAX_FILTERS

// 9

/*
[typedef]
struct C.SDL_AUDIOCVT_PACKEDSDL_AudioCVT {
	needed int // Set to 1 if conversion possible
	src_format AudioFormat //C.SDL_AudioFormat, Source audio format
	dst_format AudioFormat //C.SDL_AudioFormat, Target audio format
	rate_incr f64 // Rate conversion increment
	buf &byte // Buffer to hold entire audio data
	len int // Length of original audio buffer
	len_cvt int // Length of converted audio buffer
	len_mult int // buffer must be len*len_mult big
	len_ratio f64 // Given len, final size is len*len_ratio
	filters[9]AudioFilter // C.SDL_AudioFilter
	filter_index int // Current audio conversion function
}
pub type AudioCVTPackedSDLAudioCVT = C.SDL_AUDIOCVT_PACKEDSDL_AudioCVT
*/

/**
 *  \struct SDL_AudioCVT
 *  \brief A structure to hold a set of audio conversion filters and buffers.
 *
 *  Note that various parts of the conversion pipeline can take advantage
 *  of SIMD operations (like SSE2, for example). SDL_AudioCVT doesn't require
 *  you to pass it aligned data, but can possibly run much faster if you
 *  set both its (buf) field to a pointer that is aligned to 16 bytes, and its
 *  (len) field to something that's a multiple of 16, if possible.
*/
[typedef]
struct C.SDL_AudioCVT {
	needed       int // Set to 1 if conversion possible
	src_format   AudioFormat // C.SDL_AudioFormat, Source audio format
	dst_format   AudioFormat // C.SDL_AudioFormat, Target audio format
	rate_incr    f64   // Rate conversion increment
	buf          &byte // Buffer to hold entire audio data
	len          int   // Length of original audio buffer
	len_cvt      int   // Length of converted audio buffer
	len_mult     int   // buffer must be len*len_mult big
	len_ratio    f64   // Given len, final size is len*len_ratio
	filters      [10]AudioFilter // C.SDL_AudioFilter NULL-terminated list of filter functions
	filter_index int // Current audio conversion function
}

pub type AudioCVT = C.SDL_AudioCVT

// extern DECLSPEC int SDLCALL SDL_GetNumAudioDrivers(void)
fn C.SDL_GetNumAudioDrivers() int
pub fn get_num_audio_drivers() int {
	return C.SDL_GetNumAudioDrivers()
}

// extern DECLSPEC const char *SDLCALL SDL_GetAudioDriver(int index)
fn C.SDL_GetAudioDriver(index int) &char
pub fn get_audio_driver(index int) &char {
	return C.SDL_GetAudioDriver(index)
}

// extern DECLSPEC int SDLCALL SDL_AudioInit(const char *driver_name)
fn C.SDL_AudioInit(driver_name &char) int
pub fn audio_init(driver_name &char) int {
	return C.SDL_AudioInit(driver_name)
}

// extern DECLSPEC void SDLCALL SDL_AudioQuit(void)
fn C.SDL_AudioQuit()
pub fn audio_quit() {
	C.SDL_AudioQuit()
}

// extern DECLSPEC const char *SDLCALL SDL_GetCurrentAudioDriver(void)
fn C.SDL_GetCurrentAudioDriver() &char
pub fn get_current_audio_driver() &char {
	return C.SDL_GetCurrentAudioDriver()
}

// extern DECLSPEC int SDLCALL SDL_OpenAudio(SDL_AudioSpec * desired,                                          SDL_AudioSpec * obtained)
fn C.SDL_OpenAudio(desired &C.SDL_AudioSpec, obtained &C.SDL_AudioSpec) int
pub fn open_audio(desired &AudioSpec, obtained &AudioSpec) int {
	return C.SDL_OpenAudio(desired, obtained)
}

/**
 *  SDL Audio Device IDs.
 *
 *  A successful call to SDL_OpenAudio() is always device id 1, and legacy
 *  SDL audio APIs assume you want this device ID. SDL_OpenAudioDevice() calls
 *  always returns devices >= 2 on success. The legacy calls are good both
 *  for backwards compatibility and when you don't care about multiple,
 *  specific, or capture devices.
*/
// typedef Uint32 SDL_AudioDeviceID;
type AudioDeviceID = u32

// extern DECLSPEC int SDLCALL SDL_GetNumAudioDevices(int iscapture)
fn C.SDL_GetNumAudioDevices(iscapture int) int
pub fn get_num_audio_devices(iscapture int) int {
	return C.SDL_GetNumAudioDevices(iscapture)
}

// extern DECLSPEC const char *SDLCALL SDL_GetAudioDeviceName(int index,                                                           int iscapture)
fn C.SDL_GetAudioDeviceName(index int, iscapture int) &char
pub fn get_audio_device_name(index int, iscapture int) &char {
	return C.SDL_GetAudioDeviceName(index, iscapture)
}

// extern DECLSPEC SDL_AudioDeviceID SDLCALL SDL_OpenAudioDevice(const char                                                              *device,                                                              int iscapture,                                                              const                                                              SDL_AudioSpec *                                                              desired,                                                              SDL_AudioSpec *                                                              obtained,                                                              int                                                              allowed_changes)
fn C.SDL_OpenAudioDevice(device &char, iscapture int, desired &C.SDL_AudioSpec, obtained &C.SDL_AudioSpec, allowed_changes int) C.SDL_AudioDeviceID
pub fn open_audio_device(device &char, iscapture int, desired &AudioSpec, obtained &AudioSpec, allowed_changes int) AudioDeviceID {
	return u32(C.SDL_OpenAudioDevice(device, iscapture, desired, obtained, allowed_changes))
}

/**
 *  \name Audio state
 *
 *  Get the current audio state.
*/
// AudioStatus is C.SDL_AudioStatus
pub enum AudioStatus {
	audio_stopped = C.SDL_AUDIO_STOPPED // 0
	audio_playing = C.SDL_AUDIO_PLAYING
	audio_paused = C.SDL_AUDIO_PAUSED
}

// extern DECLSPEC SDL_AudioStatus SDLCALL SDL_GetAudioStatus(void)
fn C.SDL_GetAudioStatus() C.SDL_AudioStatus
pub fn get_audio_status() AudioStatus {
	return AudioStatus(C.SDL_GetAudioStatus())
}

// extern DECLSPEC SDL_AudioStatus SDLCALLSDL_GetAudioDeviceStatus(SDL_AudioDeviceID dev)
fn C.SDL_GetAudioDeviceStatus(dev C.SDL_AudioDeviceID) C.SDL_AudioStatus
pub fn get_audio_device_status(dev C.SDL_AudioDeviceID) AudioStatus {
	return AudioStatus(C.SDL_GetAudioDeviceStatus(C.SDL_AudioDeviceID(dev)))
}

// extern DECLSPEC void SDLCALL SDL_PauseAudio(int pause_on)
fn C.SDL_PauseAudio(pause_on int)
pub fn pause_audio(pause_on int) {
	C.SDL_PauseAudio(pause_on)
}

// extern DECLSPEC void SDLCALL SDL_PauseAudioDevice(SDL_AudioDeviceID dev,                                                  int pause_on)
fn C.SDL_PauseAudioDevice(dev C.SDL_AudioDeviceID, pause_on int)
pub fn pause_audio_device(dev AudioDeviceID, pause_on int) {
	C.SDL_PauseAudioDevice(C.SDL_AudioDeviceID(dev), pause_on)
}

// extern DECLSPEC SDL_AudioSpec *SDLCALL SDL_LoadWAV_RW(SDL_RWops * src,                                                      int freesrc,                                                      SDL_AudioSpec * spec,                                                      Uint8 ** audio_buf,                                                      Uint32 * audio_len)
fn C.SDL_LoadWAV_RW(src &C.SDL_RWops, freesrc int, spec &C.SDL_AudioSpec, audio_buf &&byte, audio_len &u32) &C.SDL_AudioSpec
pub fn load_wav_rw(src &RWops, freesrc int, spec &AudioSpec, audio_buf &&byte, audio_len &u32) &AudioSpec {
	return C.SDL_LoadWAV_RW(src, freesrc, spec, audio_buf, audio_len)
}

// extern DECLSPEC void SDLCALL SDL_FreeWAV(Uint8 * audio_buf)
fn C.SDL_FreeWAV(audio_buf &byte)
pub fn free_wav(audio_buf &byte) {
	C.SDL_FreeWAV(audio_buf)
}

// extern DECLSPEC int SDLCALL SDL_BuildAudioCVT(SDL_AudioCVT * cvt,                                              SDL_AudioFormat src_format,                                              Uint8 src_channels,                                              int src_rate,                                              SDL_AudioFormat dst_format,                                              Uint8 dst_channels,                                              int dst_rate)
fn C.SDL_BuildAudioCVT(cvt &C.SDL_AudioCVT, src_format C.SDL_AudioFormat, src_channels byte, src_rate int, dst_format C.SDL_AudioFormat, dst_channels byte, dst_rate int) int
pub fn build_audio_cvt(cvt &AudioCVT, src_format AudioFormat, src_channels byte, src_rate int, dst_format AudioFormat, dst_channels byte, dst_rate int) int {
	return C.SDL_BuildAudioCVT(cvt, C.SDL_AudioFormat(src_format), src_channels, src_rate,
		C.SDL_AudioFormat(dst_format), dst_channels, dst_rate)
}

// extern DECLSPEC int SDLCALL SDL_ConvertAudio(SDL_AudioCVT * cvt)
fn C.SDL_ConvertAudio(cvt &C.SDL_AudioCVT) int
pub fn convert_audio(cvt &AudioCVT) int {
	return C.SDL_ConvertAudio(cvt)
}

[typedef]
struct C.SDL_AudioStream {
}

pub type AudioStream = C.SDL_AudioStream

// extern DECLSPEC SDL_AudioStream * SDLCALL SDL_NewAudioStream(const SDL_AudioFormat src_format,                                           const Uint8 src_channels,                                           const int src_rate,                                           const SDL_AudioFormat dst_format,                                           const Uint8 dst_channels,                                           const int dst_rate)
fn C.SDL_NewAudioStream(src_format C.SDL_AudioFormat, src_channels byte, src_rate int, dst_format C.SDL_AudioFormat, dst_channels byte, dst_rate int) &C.SDL_AudioStream
pub fn new_audio_stream(src_format AudioFormat, src_channels byte, src_rate int, dst_format AudioFormat, dst_channels byte, dst_rate int) &AudioStream {
	return C.SDL_NewAudioStream(C.SDL_AudioFormat(src_format), src_channels, src_rate,
		C.SDL_AudioFormat(dst_format), dst_channels, dst_rate)
}

// extern DECLSPEC int SDLCALL SDL_AudioStreamPut(SDL_AudioStream *stream, const void *buf, int len)
fn C.SDL_AudioStreamPut(stream &C.SDL_AudioStream, buf voidptr, len int) int
pub fn audio_stream_put(stream &AudioStream, buf voidptr, len int) int {
	return C.SDL_AudioStreamPut(stream, buf, len)
}

// extern DECLSPEC int SDLCALL SDL_AudioStreamGet(SDL_AudioStream *stream, void *buf, int len)
fn C.SDL_AudioStreamGet(stream &C.SDL_AudioStream, buf voidptr, len int) int
pub fn audio_stream_get(stream &AudioStream, buf voidptr, len int) int {
	return C.SDL_AudioStreamGet(stream, buf, len)
}

// extern DECLSPEC int SDLCALL SDL_AudioStreamAvailable(SDL_AudioStream *stream)
fn C.SDL_AudioStreamAvailable(stream &C.SDL_AudioStream) int
pub fn audio_stream_available(stream &AudioStream) int {
	return C.SDL_AudioStreamAvailable(stream)
}

// extern DECLSPEC int SDLCALL SDL_AudioStreamFlush(SDL_AudioStream *stream)
fn C.SDL_AudioStreamFlush(stream &C.SDL_AudioStream) int
pub fn audio_stream_flush(stream &AudioStream) int {
	return C.SDL_AudioStreamFlush(stream)
}

// extern DECLSPEC void SDLCALL SDL_AudioStreamClear(SDL_AudioStream *stream)
fn C.SDL_AudioStreamClear(stream &C.SDL_AudioStream)
pub fn audio_stream_clear(stream &AudioStream) {
	C.SDL_AudioStreamClear(stream)
}

// extern DECLSPEC void SDLCALL SDL_FreeAudioStream(SDL_AudioStream *stream)
fn C.SDL_FreeAudioStream(stream &C.SDL_AudioStream)
pub fn free_audio_stream(stream &AudioStream) {
	C.SDL_FreeAudioStream(stream)
}

// extern DECLSPEC void SDLCALL SDL_MixAudio(Uint8 * dst, const Uint8 * src,                                          Uint32 len, int volume)
fn C.SDL_MixAudio(dst &byte, src &byte, len u32, volume int)
pub fn mix_audio(dst &byte, src &byte, len u32, volume int) {
	C.SDL_MixAudio(dst, src, len, volume)
}

// extern DECLSPEC void SDLCALL SDL_MixAudioFormat(Uint8 * dst,                                                const Uint8 * src,                                                SDL_AudioFormat format,                                                Uint32 len, int volume)
fn C.SDL_MixAudioFormat(dst &byte, src &byte, format C.SDL_AudioFormat, len u32, volume int)
pub fn mix_audio_format(dst &byte, src &byte, format AudioFormat, len u32, volume int) {
	C.SDL_MixAudioFormat(dst, src, C.SDL_AudioFormat(format), len, volume)
}

// extern DECLSPEC int SDLCALL SDL_QueueAudio(SDL_AudioDeviceID dev, const void *data, Uint32 len)
fn C.SDL_QueueAudio(dev C.SDL_AudioDeviceID, data voidptr, len u32) int
pub fn queue_audio(dev AudioDeviceID, data voidptr, len u32) int {
	return C.SDL_QueueAudio(C.SDL_AudioDeviceID(dev), data, len)
}

// extern DECLSPEC Uint32 SDLCALL SDL_DequeueAudio(SDL_AudioDeviceID dev, void *data, Uint32 len)
fn C.SDL_DequeueAudio(dev C.SDL_AudioDeviceID, data voidptr, len u32) u32
pub fn dequeue_audio(dev AudioDeviceID, data voidptr, len u32) u32 {
	return C.SDL_DequeueAudio(C.SDL_AudioDeviceID(dev), data, len)
}

// extern DECLSPEC Uint32 SDLCALL SDL_GetQueuedAudioSize(SDL_AudioDeviceID dev)
fn C.SDL_GetQueuedAudioSize(dev C.SDL_AudioDeviceID) u32
pub fn get_queued_audio_size(dev AudioDeviceID) u32 {
	return C.SDL_GetQueuedAudioSize(C.SDL_AudioDeviceID(dev))
}

// extern DECLSPEC void SDLCALL SDL_ClearQueuedAudio(SDL_AudioDeviceID dev)
fn C.SDL_ClearQueuedAudio(dev C.SDL_AudioDeviceID)
pub fn clear_queued_audio(dev AudioDeviceID) {
	C.SDL_ClearQueuedAudio(C.SDL_AudioDeviceID(dev))
}

// extern DECLSPEC void SDLCALL SDL_LockAudio(void)
fn C.SDL_LockAudio()
pub fn lock_audio() {
	C.SDL_LockAudio()
}

// extern DECLSPEC void SDLCALL SDL_LockAudioDevice(SDL_AudioDeviceID dev)
fn C.SDL_LockAudioDevice(dev C.SDL_AudioDeviceID)
pub fn lock_audio_device(dev AudioDeviceID) {
	C.SDL_LockAudioDevice(C.SDL_AudioDeviceID(dev))
}

// extern DECLSPEC void SDLCALL SDL_UnlockAudio(void)
fn C.SDL_UnlockAudio()
pub fn unlock_audio() {
	C.SDL_UnlockAudio()
}

// extern DECLSPEC void SDLCALL SDL_UnlockAudioDevice(SDL_AudioDeviceID dev)
fn C.SDL_UnlockAudioDevice(dev C.SDL_AudioDeviceID)
pub fn unlock_audio_device(dev AudioDeviceID) {
	C.SDL_UnlockAudioDevice(C.SDL_AudioDeviceID(dev))
}

// extern DECLSPEC void SDLCALL SDL_CloseAudio(void)
fn C.SDL_CloseAudio()
pub fn close_audio() {
	C.SDL_CloseAudio()
}

// extern DECLSPEC void SDLCALL SDL_CloseAudioDevice(SDL_AudioDeviceID dev)
fn C.SDL_CloseAudioDevice(dev C.SDL_AudioDeviceID)
pub fn close_audio_device(dev AudioDeviceID) {
	C.SDL_CloseAudioDevice(C.SDL_AudioDeviceID(dev))
}
