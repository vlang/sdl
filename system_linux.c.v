// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//
@[typedef]
pub struct C.XEvent {}

pub type XEvent = C.XEvent

// X11EventHook as callback to be used with SDL_SetX11EventHook.
//
// This callback may modify the event, and should return true if the event
// should continue to be processed, or false to prevent further processing.
//
// As this is processing an event directly from the X11 event loop, this
// callback should do the minimum required work and return quickly.
//
// `userdata` userdata the app-defined pointer provided to SDL_SetX11EventHook.
// `xevent` xevent a pointer to an Xlib XEvent union to process.
// returns true to let event continue on, false to drop it.
//
// NOTE: (thread safety) This may only be called (by SDL) from the thread handling the
//               X11 event loop.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: set_x11_event_hook (SDL_SetX11EventHook)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_X11EventHook)
pub type X11EventHook = fn (userdata voidptr, xevent &XEvent) bool

// C.SDL_SetX11EventHook [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetX11EventHook)
fn C.SDL_SetX11EventHook(callback X11EventHook, userdata voidptr)

// set_x11_event_hook sets a callback for every X11 event.
//
// The callback may modify the event, and should return true if the event
// should continue to be processed, or false to prevent further processing.
//
// `callback` callback the SDL_X11EventHook function to call.
// `userdata` userdata a pointer to pass to every iteration of `callback`.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_x11_event_hook(callback X11EventHook, userdata voidptr) {
	C.SDL_SetX11EventHook(callback, userdata)
}

// C.SDL_SetLinuxThreadPriority [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetLinuxThreadPriority)
fn C.SDL_SetLinuxThreadPriority(thread_id i64, priority int) bool

// set_linux_thread_priority sets the UNIX nice value for a thread.
//
// This uses setpriority() if possible, and RealtimeKit if available.
//
// `thread_id` threadID the Unix thread ID to change priority of.
// `priority` priority the new, Unix-specific, priority value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_linux_thread_priority(thread_id i64, priority int) bool {
	return C.SDL_SetLinuxThreadPriority(thread_id, priority)
}

// C.SDL_SetLinuxThreadPriorityAndPolicy [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetLinuxThreadPriorityAndPolicy)
fn C.SDL_SetLinuxThreadPriorityAndPolicy(thread_id i64, sdl_priority int, sched_policy int) bool

// set_linux_thread_priority_and_policy sets the priority (not nice level) and scheduling policy for a thread.
//
// This uses setpriority() if possible, and RealtimeKit if available.
//
// `thread_id` threadID the Unix thread ID to change priority of.
// `sdl_priority` sdlPriority the new SDL_ThreadPriority value.
// `sched_policy` schedPolicy the new scheduling policy (SCHED_FIFO, SCHED_RR,
//                    SCHED_OTHER, etc...).
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_linux_thread_priority_and_policy(thread_id i64, sdl_priority int, sched_policy int) bool {
	return C.SDL_SetLinuxThreadPriorityAndPolicy(thread_id, sdl_priority, sched_policy)
}
