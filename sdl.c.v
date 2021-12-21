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
	init_noparachute    = u32(C.SDL_INIT_NOPARACHUTE) // 0x00100000u compatibility; this flag is ignored.
	init_everything     = u32(C.SDL_INIT_EVERYTHING) // ( SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | INIT_GAMECONTROLLER )
)


// init initializes the subsystems specified by `flags`
pub fn init(flags u32) int {
	return C.SDL_Init(flags)
}
fn C.SDL_Init(flags u32) int

// init_sub_system initializes specific SDL subsystems
//
// Subsystem initialization is ref-counted, you must call
// SDL_QuitSubSystem() for each SDL_InitSubSystem() to correctly
// shutdown a subsystem manually (or call SDL_Quit() to force shutdown).
// If a subsystem is already loaded then this call will
// increase the ref-count and return.
pub fn init_sub_system(flags u32) int {
	return C.SDL_InitSubSystem(flags)
}
fn C.SDL_InitSubSystem(flags u32) int

// quit_sub_system cleans up specific SDL subsystems
pub fn quit_sub_system(flags u32) {
	C.SDL_QuitSubSystem(flags)
}
fn C.SDL_QuitSubSystem(flags u32)

// was_init returns a mask of the specified subsystems which have
// previously been initialized.
//
// If `flags` is 0, it returns a mask of all initialized subsystems.
pub fn was_init(flags u32) u32 {
	return C.SDL_WasInit(flags)
}
fn C.SDL_WasInit(flags u32) u32

// quit cleans up all initialized subsystems. You should
// call it upon all exit conditions.
fn C.SDL_Quit()
pub fn quit() {
	C.SDL_Quit()
}
