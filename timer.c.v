// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_timer.h
//

// SDL provides time management functionality. It is useful for dealing with
// (usually) small durations of time.
//
// This is not to be confused with _calendar time_ management, which is
// provided by [CategoryTime](CategoryTime).
//
// This category covers measuring time elapsed (SDL_GetTicks(),
// SDL_GetPerformanceCounter()), putting a thread to sleep for a certain
// amount of time (SDL_Delay(), SDL_DelayNS(), SDL_DelayPrecise()), and firing
// a callback function after a certain amount of time has elasped
// (SDL_AddTimer(), etc).
//
// There are also useful macros to convert between time units, like
// SDL_SECONDS_TO_NS() and such.

// Definition of the timer ID type.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type TimerID = u32

// Number of milliseconds in a second.
//
// This is always 1000.
//
// NOTE: This macro is available since SDL 3.2.0.
pub const ms_per_second = C.SDL_MS_PER_SECOND // 1000

// Number of microseconds in a second.
//
// This is always 1000000.
//
// NOTE: This macro is available since SDL 3.2.0.
pub const us_per_second = C.SDL_US_PER_SECOND // 1000000

pub const ns_per_second = C.SDL_NS_PER_SECOND // 1000000000LL

// Number of nanoseconds in a millisecond.
//
// This is always 1000000.
//
// NOTE: This macro is available since SDL 3.2.0.
pub const ns_per_ms = C.SDL_NS_PER_MS // 1000000

// Number of nanoseconds in a microsecond.
//
// This is always 1000.
//
// NOTE: This macro is available since SDL 3.2.0.
pub const ns_per_us = C.SDL_NS_PER_US // 1000

// TODO: Function: #define SDL_SECONDS_TO_NS(S)    (((Uint64)(S)) * SDL_NS_PER_SECOND)

// TODO: Function: #define SDL_NS_TO_SECONDS(NS)   ((NS) / SDL_NS_PER_SECOND)

// TODO: Function: #define SDL_MS_TO_NS(MS)        (((Uint64)(MS)) * SDL_NS_PER_MS)

// TODO: Function: #define SDL_NS_TO_MS(NS)        ((NS) / SDL_NS_PER_MS)

// TODO: Function: #define SDL_US_TO_NS(US)        (((Uint64)(US)) * SDL_NS_PER_US)

// TODO: Function: #define SDL_NS_TO_US(NS)        ((NS) / SDL_NS_PER_US)

// C.SDL_GetTicks [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTicks)
fn C.SDL_GetTicks() u64

// get_ticks gets the number of milliseconds since SDL library initialization.
//
// returns an unsigned 64-bit value representing the number of milliseconds
//          since the SDL library initialized.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_ticks() u64 {
	return C.SDL_GetTicks()
}

// C.SDL_GetTicksNS [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTicksNS)
fn C.SDL_GetTicksNS() u64

// get_ticks_ns gets the number of nanoseconds since SDL library initialization.
//
// returns an unsigned 64-bit value representing the number of nanoseconds
//          since the SDL library initialized.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_ticks_ns() u64 {
	return C.SDL_GetTicksNS()
}

// C.SDL_GetPerformanceCounter [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPerformanceCounter)
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
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_performance_frequency (SDL_GetPerformanceFrequency)
pub fn get_performance_counter() u64 {
	return C.SDL_GetPerformanceCounter()
}

// C.SDL_GetPerformanceFrequency [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPerformanceFrequency)
fn C.SDL_GetPerformanceFrequency() u64

// get_performance_frequency gets the count per second of the high resolution counter.
//
// returns a platform-specific count per second.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_performance_counter (SDL_GetPerformanceCounter)
pub fn get_performance_frequency() u64 {
	return C.SDL_GetPerformanceFrequency()
}

// C.SDL_Delay [official documentation](https://wiki.libsdl.org/SDL3/SDL_Delay)
fn C.SDL_Delay(ms u32)

// delay waits a specified number of milliseconds before returning.
//
// This function waits a specified number of milliseconds before returning. It
// waits at least the specified time, but possibly longer due to OS
// scheduling.
//
// `ms` ms the number of milliseconds to delay.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: delay_ns (SDL_DelayNS)
// See also: delay_precise (SDL_DelayPrecise)
pub fn delay(ms u32) {
	C.SDL_Delay(ms)
}

// C.SDL_DelayNS [official documentation](https://wiki.libsdl.org/SDL3/SDL_DelayNS)
fn C.SDL_DelayNS(ns u64)

// delay_ns waits a specified number of nanoseconds before returning.
//
// This function waits a specified number of nanoseconds before returning. It
// waits at least the specified time, but possibly longer due to OS
// scheduling.
//
// `ns` ns the number of nanoseconds to delay.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: delay (SDL_Delay)
// See also: delay_precise (SDL_DelayPrecise)
pub fn delay_ns(ns u64) {
	C.SDL_DelayNS(ns)
}

// C.SDL_DelayPrecise [official documentation](https://wiki.libsdl.org/SDL3/SDL_DelayPrecise)
fn C.SDL_DelayPrecise(ns u64)

// delay_precise waits a specified number of nanoseconds before returning.
//
// This function waits a specified number of nanoseconds before returning. It
// will attempt to wait as close to the requested time as possible, busy
// waiting if necessary, but could return later due to OS scheduling.
//
// `ns` ns the number of nanoseconds to delay.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: delay (SDL_Delay)
// See also: delay_ns (SDL_DelayNS)
pub fn delay_precise(ns u64) {
	C.SDL_DelayPrecise(ns)
}

// TimerCallback functions prototype for the millisecond timer callback function.
//
// The callback function is passed the current timer interval and returns the
// next timer interval, in milliseconds. If the returned value is the same as
// the one passed in, the periodic alarm continues, otherwise a new alarm is
// scheduled. If the callback returns 0, the periodic alarm is canceled and
// will be removed.
//
// `userdata` userdata an arbitrary pointer provided by the app through
//                 SDL_AddTimer, for its own use.
// `timer_id` timerID the current timer being processed.
// `interval` interval the current callback time interval.
// returns the new callback time interval, or 0 to disable further runs of
//          the callback.
//
// NOTE: (thread safety) SDL may call this callback at any time from a background
//               thread; the application is responsible for locking resources
//               the callback touches that need to be protected.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: add_timer (SDL_AddTimer)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_TimerCallback)
pub type TimerCallback = fn (userdata voidptr, timer_id TimerID, interval u32) u32

// C.SDL_AddTimer [official documentation](https://wiki.libsdl.org/SDL3/SDL_AddTimer)
fn C.SDL_AddTimer(interval u32, callback TimerCallback, userdata voidptr) TimerID

// add_timer calls a callback function at a future time.
//
// The callback function is passed the current timer interval and the user
// supplied parameter from the SDL_AddTimer() call and should return the next
// timer interval. If the value returned from the callback is 0, the timer is
// canceled and will be removed.
//
// The callback is run on a separate thread, and for short timeouts can
// potentially be called before this function returns.
//
// Timers take into account the amount of time it took to execute the
// callback. For example, if the callback took 250 ms to execute and returned
// 1000 (ms), the timer would only wait another 750 ms before its next
// iteration.
//
// Timing may be inexact due to OS scheduling. Be sure to note the current
// time with SDL_GetTicksNS() or SDL_GetPerformanceCounter() in case your
// callback needs to adjust for variances.
//
// `interval` interval the timer delay, in milliseconds, passed to `callback`.
// `callback` callback the SDL_TimerCallback function to call when the specified
//                 `interval` elapses.
// `userdata` userdata a pointer that is passed to `callback`.
// returns a timer ID or 0 on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_timer_ns (SDL_AddTimerNS)
// See also: remove_timer (SDL_RemoveTimer)
pub fn add_timer(interval u32, callback TimerCallback, userdata voidptr) TimerID {
	return C.SDL_AddTimer(interval, callback, userdata)
}

// NSTimerCallback functions prototype for the nanosecond timer callback function.
//
// The callback function is passed the current timer interval and returns the
// next timer interval, in nanoseconds. If the returned value is the same as
// the one passed in, the periodic alarm continues, otherwise a new alarm is
// scheduled. If the callback returns 0, the periodic alarm is canceled and
// will be removed.
//
// `userdata` userdata an arbitrary pointer provided by the app through
//                 SDL_AddTimer, for its own use.
// `timer_id` timerID the current timer being processed.
// `interval` interval the current callback time interval.
// returns the new callback time interval, or 0 to disable further runs of
//          the callback.
//
// NOTE: (thread safety) SDL may call this callback at any time from a background
//               thread; the application is responsible for locking resources
//               the callback touches that need to be protected.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: add_timer_ns (SDL_AddTimerNS)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_NSTimerCallback)
pub type NSTimerCallback = fn (userdata voidptr, timer_id TimerID, interval u64) u64

// C.SDL_AddTimerNS [official documentation](https://wiki.libsdl.org/SDL3/SDL_AddTimerNS)
fn C.SDL_AddTimerNS(interval u64, callback NSTimerCallback, userdata voidptr) TimerID

// add_timer_ns calls a callback function at a future time.
//
// The callback function is passed the current timer interval and the user
// supplied parameter from the SDL_AddTimerNS() call and should return the
// next timer interval. If the value returned from the callback is 0, the
// timer is canceled and will be removed.
//
// The callback is run on a separate thread, and for short timeouts can
// potentially be called before this function returns.
//
// Timers take into account the amount of time it took to execute the
// callback. For example, if the callback took 250 ns to execute and returned
// 1000 (ns), the timer would only wait another 750 ns before its next
// iteration.
//
// Timing may be inexact due to OS scheduling. Be sure to note the current
// time with SDL_GetTicksNS() or SDL_GetPerformanceCounter() in case your
// callback needs to adjust for variances.
//
// `interval` interval the timer delay, in nanoseconds, passed to `callback`.
// `callback` callback the SDL_TimerCallback function to call when the specified
//                 `interval` elapses.
// `userdata` userdata a pointer that is passed to `callback`.
// returns a timer ID or 0 on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_timer (SDL_AddTimer)
// See also: remove_timer (SDL_RemoveTimer)
pub fn add_timer_ns(interval u64, callback NSTimerCallback, userdata voidptr) TimerID {
	return C.SDL_AddTimerNS(interval, callback, userdata)
}

// C.SDL_RemoveTimer [official documentation](https://wiki.libsdl.org/SDL3/SDL_RemoveTimer)
fn C.SDL_RemoveTimer(id TimerID) bool

// remove_timer removes a timer created with SDL_AddTimer().
//
// `id` id the ID of the timer to remove.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_timer (SDL_AddTimer)
pub fn remove_timer(id TimerID) bool {
	return C.SDL_RemoveTimer(id)
}
