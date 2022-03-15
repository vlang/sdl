// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

// Platform specific functions for Linux

fn C.SDL_LinuxSetThreadPriority(thread_id i64, priority int) int

// linux_set_thread_priority sets the UNIX nice value for a thread.
//
// This uses setpriority() if possible, and RealtimeKit if available.
//
// `threadID` the Unix thread ID to change priority of.
// `priority` The new, Unix-specific, priority value.
// returns 0 on success, or -1 on error.
pub fn linux_set_thread_priority(thread_id i64, priority int) int {
	return C.SDL_LinuxSetThreadPriority(thread_id, priority)
}
