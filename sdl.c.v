// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL.h
//

pub const (
	null = voidptr(0)
)

// These are the flags which may be passed to SDL_Init().  You should
// specify the subsystems which you will be using in your application.
pub const (
	init_timer          = u32(C.SDL_INIT_TIMER) // 0x00000001u
	init_audio          = u32(C.SDL_INIT_AUDIO) // 0x00000010u
	init_video          = u32(C.SDL_INIT_VIDEO) // 0x00000020u SDL_INIT_VIDEO implies SDL_INIT_EVENTS
	init_joystick       = u32(C.SDL_INIT_JOYSTICK) // 0x00000200u SDL_INIT_JOYSTICK implies SDL_INIT_EVENTS
	init_haptic         = u32(C.SDL_INIT_HAPTIC) // 0x00001000u
	init_gamecontroller = u32(C.SDL_INIT_GAMECONTROLLER) // 0x00002000u SDL_INIT_GAMECONTROLLER implies SDL_INIT_JOYSTICK
	init_events         = u32(C.SDL_INIT_EVENTS) // 0x00004000u
	init_sensor         = u32(C.SDL_INIT_SENSOR) // 0x00008000u
	init_noparachute    = u32(C.SDL_INIT_NOPARACHUTE) // 0x00100000u compatibility; this flag is ignored.
	init_everything     = u32(C.SDL_INIT_EVERYTHING) // ( SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | INIT_GAMECONTROLLER | SDL_INIT_SENSOR )
)

fn C.SDL_Init(flags u32) int

// init initializes the SDL library.
//
// SDL_Init() simply forwards to calling SDL_InitSubSystem(). Therefore, the
// two may be used interchangeably. Though for readability of your code
// SDL_InitSubSystem() might be preferred.
//
// The file I/O (for example: SDL_RWFromFile) and threading (SDL_CreateThread)
// subsystems are initialized by default. Message boxes
// (SDL_ShowSimpleMessageBox) also attempt to work without initializing the
// video subsystem, in hopes of being useful in showing an error dialog when
// SDL_Init fails. You must specifically initialize other subsystems if you
// use them in your application.
//
// Logging (such as SDL_Log) works without initialization, too.
//
// `flags` may be any of the following OR'd together:
//
// - `SDL_INIT_TIMER`: timer subsystem
// - `SDL_INIT_AUDIO`: audio subsystem
// - `SDL_INIT_VIDEO`: video subsystem; automatically initializes the events
//   subsystem
// - `SDL_INIT_JOYSTICK`: joystick subsystem; automatically initializes the
//   events subsystem
// - `SDL_INIT_HAPTIC`: haptic (force feedback) subsystem
// - `SDL_INIT_GAMECONTROLLER`: controller subsystem; automatically
//   initializes the joystick subsystem
// - `SDL_INIT_EVENTS`: events subsystem
// - `SDL_INIT_EVERYTHING`: all of the above subsystems
// - `SDL_INIT_NOPARACHUTE`: compatibility; this flag is ignored
//
// Subsystem initialization is ref-counted, you must call SDL_QuitSubSystem()
// for each SDL_InitSubSystem() to correctly shutdown a subsystem manually (or
// call SDL_Quit() to force shutdown). If a subsystem is already loaded then
// this call will increase the ref-count and return.
//
// `flags` subsystem initialization flags
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_InitSubSystem
// See also: SDL_Quit
// See also: SDL_SetMainReady
// See also: SDL_WasInit
pub fn init(flags u32) int {
	return C.SDL_Init(flags)
}

fn C.SDL_InitSubSystem(flags u32) int

// init_sub_system is a compatibility function to initialize the SDL library.
//
// In SDL2, this function and SDL_Init() are interchangeable.
//
// `flags` any of the flags used by SDL_Init(); see SDL_Init for details.
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Init
// See also: SDL_Quit
// See also: SDL_QuitSubSystem
pub fn init_sub_system(flags u32) int {
	return C.SDL_InitSubSystem(flags)
}

fn C.SDL_QuitSubSystem(flags u32)

// quit_sub_system shuts down specific SDL subsystems.
//
// If you start a subsystem using a call to that subsystem's init function
// (for example SDL_VideoInit()) instead of SDL_Init() or SDL_InitSubSystem(),
// SDL_QuitSubSystem() and SDL_WasInit() will not work. You will need to use
// that subsystem's quit function (SDL_VideoQuit()) directly instead. But
// generally, you should not be using those functions directly anyhow; use
// SDL_Init() instead.
//
// You still need to call SDL_Quit() even if you close all open subsystems
// with SDL_QuitSubSystem().
//
// `flags` any of the flags used by SDL_Init(); see SDL_Init for details.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_InitSubSystem
// See also: SDL_Quit
pub fn quit_sub_system(flags u32) {
	C.SDL_QuitSubSystem(flags)
}

fn C.SDL_WasInit(flags u32) u32

// was_init gets a mask of the specified subsystems which are currently initialized.
//
// `flags` any of the flags used by SDL_Init(); see SDL_Init for details.
// returns a mask of all initialized subsystems if `flags` is 0, otherwise it
//          returns the initialization status of the specified subsystems.
//
//          The return value does not include SDL_INIT_NOPARACHUTE.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Init
// See also: SDL_InitSubSystem
pub fn was_init(flags u32) u32 {
	return C.SDL_WasInit(flags)
}

fn C.SDL_Quit()

// quit cleans up all initialized subsystems.
//
// You should call this function even if you have already shutdown each
// initialized subsystem with SDL_QuitSubSystem(). It is safe to call this
// function even in the case of errors in initialization.
//
// If you start a subsystem using a call to that subsystem's init function
// (for example SDL_VideoInit()) instead of SDL_Init() or SDL_InitSubSystem(),
// then you must use that subsystem's quit function (SDL_VideoQuit()) to shut
// it down before calling SDL_Quit(). But generally, you should not be using
// those functions directly anyhow; use SDL_Init() instead.
//
// You can use this function with atexit() to ensure that it is run when your
// application is shutdown, but it is not wise to do this from a library or
// other dynamically loaded code.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Init
// See also: SDL_QuitSubSystem
pub fn quit() {
	C.SDL_Quit()
}
