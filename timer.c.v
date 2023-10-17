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

// get_ticks gets the number of milliseconds since SDL library initialization.
//
// This value wraps if the program runs for more than ~49 days.
//
// returns an unsigned 32-bit value representing the number of milliseconds
//          since the SDL library initialized.
//
// See also: SDL_TICKS_PASSED
pub fn get_ticks() u32 {
	return C.SDL_GetTicks()
}

fn C.SDL_TICKS_PASSED(a u32, b u32) bool

// ticks_passed compares SDL ticks values, and return true if `A` has passed `B`.
//
// For example, if you want to wait 100 ms, you could do this:
//
/*
```c++
Uint32 timeout = SDL_GetTicks() + 100;
while (!SDL_TICKS_PASSED(SDL_GetTicks(), timeout)) {
    // ... do work until timeout has elapsed
}
```
*/
pub fn ticks_passed(a u32, b u32) bool {
	return C.SDL_TICKS_PASSED(a, b)
}

fn C.SDL_GetPerformanceCounter() u64

// get_performance_counter gets the current value of the high resolution counter.
//
// This function is typically used for profiling.
//
// The counter values are only meaningful relative to each other. Differences
// between values can be converted to times by using
// SDL_GetPerformanceFrequency().
//
// returns the current counter value.
//
// See also: SDL_GetPerformanceFrequency
pub fn get_performance_counter() u64 {
	return C.SDL_GetPerformanceCounter()
}

fn C.SDL_GetPerformanceFrequency() u64

// get_performance_frequency gets the count per second of the high resolution counter.
//
// returns a platform-specific count per second.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetPerformanceCounter
pub fn get_performance_frequency() u64 {
	return C.SDL_GetPerformanceFrequency()
}

fn C.SDL_Delay(ms u32)

// delay waits a specified number of milliseconds before returning.
//
// This function waits a specified number of milliseconds before returning. It
// waits at least the specified time, but possibly longer due to OS
// scheduling.
//
// `ms` the number of milliseconds to delay
pub fn delay(ms u32) {
	C.SDL_Delay(ms)
}

fn C.SDL_AddTimer(interval u32, callback C.SDL_TimerCallback, param voidptr) TimerID

// add_timer calls a callback function at a future time.
//
// If you use this function, you must pass `SDL_INIT_TIMER` to SDL_Init().
//
// The callback function is passed the current timer interval and the user
// supplied parameter from the SDL_AddTimer() call and should return the next
// timer interval. If the value returned from the callback is 0, the timer is
// canceled.
//
// The callback is run on a separate thread.
//
// Timers take into account the amount of time it took to execute the
// callback. For example, if the callback took 250 ms to execute and returned
// 1000 (ms), the timer would only wait another 750 ms before its next
// iteration.
//
// Timing may be inexact due to OS scheduling. Be sure to note the current
// time with SDL_GetTicks() or SDL_GetPerformanceCounter() in case your
// callback needs to adjust for variances.
//
// `interval` the timer delay, in milliseconds, passed to `callback`
// `callback` the SDL_TimerCallback function to call when the specified
//                 `interval` elapses
// `param` a pointer that is passed to `callback`
// returns a timer ID or 0 if an error occurs; call SDL_GetError() for more
//          information.
//
// See also: SDL_RemoveTimer
pub fn add_timer(interval u32, callback TimerCallback, param voidptr) TimerID {
	return int(C.SDL_AddTimer(interval, C.SDL_TimerCallback(callback), param))
}

fn C.SDL_RemoveTimer(id C.SDL_TimerID) bool

// remove_timer removes a timer created with SDL_AddTimer().
//
// `id` the ID of the timer to remove
// returns SDL_TRUE if the timer is removed or SDL_FALSE if the timer wasn't
//          found.
//
// See also: SDL_AddTimer
pub fn remove_timer(id TimerID) bool {
	return C.SDL_RemoveTimer(C.SDL_TimerID(id))
}
