// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_timer.h
// (/usr/include/SDL2/SDL_timer.h)
//

/**
 *  Function prototype for the timer callback function.
 *
 *  The callback function is passed the current timer interval and returns
 *  the next timer interval.  If the returned value is the same as the one
 *  passed in, the periodic alarm continues, otherwise a new alarm is
 *  scheduled.  If the callback returns 0, the periodic alarm is cancelled.
*/
// TODO typedef Uint32 (SDLCALL * SDL_TimerCallback) (Uint32 interval, void *param);
type TimerCallback = fn (u32, voidptr) u32

/**
 * Definition of the timer ID type.
*/
type TimerID = int // typedef int SDL_TimerID;

/**
 * \brief Get the number of milliseconds since the SDL library initialization.
 *
 * \note This value wraps if the program runs for more than ~49 days.
*/
fn C.SDL_GetTicks() u32
pub fn get_ticks() u32 {
	return C.SDL_GetTicks()
}

/**
 * \brief Compare SDL ticks values, and return true if A has passed B
 *
 * e.g. if you want to wait 100 ms, you could do this:
 *  Uint32 timeout = SDL_GetTicks() + 100;
 *  while (!SDL_TICKS_PASSED(SDL_GetTicks(), timeout)) {
 *      ... do work until timeout has elapsed
 *  }
*/
fn C.SDL_TICKS_PASSED(a u32, b u32) bool
pub fn ticks_passed(a u32, b u32) bool {
	return C.SDL_TICKS_PASSED(a, b)
}

/**
 * \brief Get the current value of the high resolution counter
*/
fn C.SDL_GetPerformanceCounter() u64
pub fn get_performance_counter() u64 {
	return C.SDL_GetPerformanceCounter()
}

/**
 * \brief Get the count per second of the high resolution counter
*/
fn C.SDL_GetPerformanceFrequency() u64
pub fn get_performance_frequency() u64 {
	return C.SDL_GetPerformanceFrequency()
}

/**
 * \brief Wait a specified number of milliseconds before returning.
*/
fn C.SDL_Delay(ms u32)
pub fn delay(ms u32) {
	C.SDL_Delay(ms)
}

/**
 * \brief Add a new timer to the pool of timers already running.
 *
 * \return A timer ID, or 0 when an error occurs.
*/
fn C.SDL_AddTimer(interval u32, callback C.SDL_TimerCallback, param voidptr) C.SDL_TimerID
pub fn add_timer(interval u32, callback TimerCallback, param voidptr) TimerID {
	return int(C.SDL_AddTimer(interval, C.SDL_TimerCallback(callback), param))
}

/**
 * \brief Remove a timer knowing its ID.
 *
 * \return A boolean value indicating success or failure.
 *
 * \warning It is not safe to remove a timer multiple times.
*/
fn C.SDL_RemoveTimer(id C.SDL_TimerID) bool
pub fn remove_timer(id TimerID) bool {
	return C.SDL_RemoveTimer(C.SDL_TimerID(id))
}
