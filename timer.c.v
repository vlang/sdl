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
// This function is not recommended as of SDL 2.0.18; use SDL_GetTicks64()
// instead, where the value doesn't wrap every ~49 days. There are places in
// SDL where we provide a 32-bit timestamp that can not change without
// breaking binary compatibility, though, so this function isn't officially
// deprecated.
//
// returns an unsigned 32-bit value representing the number of milliseconds
//          since the SDL library initialized.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_TICKS_PASSED
pub fn get_ticks() u32 {
	return C.SDL_GetTicks()
}

fn C.SDL_GetTicks64() u64

// get_ticks64 gets the number of milliseconds since SDL library initialization.
//
// Note that you should not use the SDL_TICKS_PASSED macro with values
// returned by this function, as that macro does clever math to compensate for
// the 32-bit overflow every ~49 days that SDL_GetTicks() suffers from. 64-bit
// values from this function can be safely compared directly.
//
// For example, if you want to wait 100 ms, you could do this:
//
// ```c
// const Uint64 timeout = SDL_GetTicks64() + 100;
// while (SDL_GetTicks64() < timeout) {
//     // ... do work until timeout has elapsed
// }
// ```
//
// returns an unsigned 64-bit value representing the number of milliseconds
//          since the SDL library initialized.
//
// NOTE This function is available since SDL 2.0.18.
pub fn get_ticks64() u64 {
	return C.SDL_GetTicks64()
}

fn C.SDL_TICKS_PASSED(a u32, b u32) bool

// ticks_passed compares 32-bit SDL tick values, and return true if `A` has passed `B`.
//
// This should be used with results from SDL_GetTicks(), as this macro
// attempts to deal with the 32-bit counter wrapping back to zero every ~49
// days, but should _not_ be used with SDL_GetTicks64(), which does not have
// that problem.
//
// For example, with SDL_GetTicks(), if you want to wait 100 ms, you could
// do this:
//
/*
```c
 const Uint32 timeout = SDL_GetTicks() + 100;
 while (!SDL_TICKS_PASSED(SDL_GetTicks(), timeout)) {
 // ... do work until timeout has elapsed
}
```
*/
//
// Note that this does not handle tick differences greater
// than 2^31 so take care when using the above kind of code
// with large timeout delays (tens of days).
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
// NOTE This function is available since SDL 2.0.0.
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
// NOTE This function is available since SDL 2.0.0.
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
// NOTE This function is available since SDL 2.0.0.
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
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AddTimer
pub fn remove_timer(id TimerID) bool {
	return C.SDL_RemoveTimer(C.SDL_TimerID(id))
}
