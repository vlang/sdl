// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_timer.h
//

// TimerCallback is the function prototype for the timer callback function.
//
// The callback function is passed the current timer interval and returns
// the next timer interval.  If the returned value is the same as the one
// passed in, the periodic alarm continues, otherwise a new alarm is
// scheduled.  If the callback returns 0, the periodic alarm is cancelled.
pub type TimerCallback = fn (interval u32, param voidptr) u32

// `typedef Uint32 (SDLCALL * SDL_TimerCallback) (Uint32 interval, void *param);`
fn C.SDL_TimerCallback(interval u32, param voidptr) u32

// Definition of the timer ID type.
// typedef int SDL_TimerID;
pub type TimerID = int

fn C.SDL_GetTicks() u32

// get_ticks gets the number of milliseconds since the SDL library initialization.
//
// NOTE This value wraps if the program runs for more than ~49 days.
pub fn get_ticks() u32 {
	return C.SDL_GetTicks()
}

fn C.SDL_TICKS_PASSED(a u32, b u32) bool

// ticks_passed compares SDL ticks values, and return true if A has passed B
//
// e.g. if you want to wait 100 ms, you could do this:
/*
```
timeout := sdl.get_ticks() + 100
for !ticks_passed(sdl.get_ticks(), timeout) {
     ... do work until timeout has elapsed
}
```
*/
pub fn ticks_passed(a u32, b u32) bool {
	return C.SDL_TICKS_PASSED(a, b)
}

fn C.SDL_GetPerformanceCounter() u64

// get_performance_counter gets the current value of the high resolution counter
pub fn get_performance_counter() u64 {
	return C.SDL_GetPerformanceCounter()
}

fn C.SDL_GetPerformanceFrequency() u64

// get_performance_frequency gets the count per second of the high resolution counter
pub fn get_performance_frequency() u64 {
	return C.SDL_GetPerformanceFrequency()
}

fn C.SDL_Delay(ms u32)

// delay waits a specified number of milliseconds before returning.
pub fn delay(ms u32) {
	C.SDL_Delay(ms)
}

fn C.SDL_AddTimer(interval u32, callback C.SDL_TimerCallback, param voidptr) TimerID

// add_timer adds a new timer to the pool of timers already running.
//
// returns A timer ID, or 0 when an error occurs.
pub fn add_timer(interval u32, callback TimerCallback, param voidptr) TimerID {
	return int(C.SDL_AddTimer(interval, C.SDL_TimerCallback(callback), param))
}

fn C.SDL_RemoveTimer(id C.SDL_TimerID) bool

// remove_timer removes a timer knowing its ID.
//
// returns A boolean value indicating success or failure.
//
// WARNING It is not safe to remove a timer multiple times.
pub fn remove_timer(id TimerID) bool {
	return C.SDL_RemoveTimer(C.SDL_TimerID(id))
}
