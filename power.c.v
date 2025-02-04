// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_power.h
//

// SDL power management routines.
//
// There is a single function in this category: SDL_GetPowerInfo().
//
// This function is useful for games on the go. This allows an app to know if
// it's running on a draining battery, which can be useful if the app wants to
// reduce processing, or perhaps framerate, to extend the duration of the
// battery's charge. Perhaps the app just wants to show a battery meter when
// fullscreen, or alert the user when the power is getting extremely low, so
// they can save their game.

// PowerState is C.SDL_PowerState
pub enum PowerState {
	error      = C.SDL_POWERSTATE_ERROR      // -1, error determining power status
	unknown    = C.SDL_POWERSTATE_UNKNOWN    // `unknown` cannot determine power status
	on_battery = C.SDL_POWERSTATE_ON_BATTERY // `on_battery` Not plugged in, running on the battery
	no_battery = C.SDL_POWERSTATE_NO_BATTERY // `no_battery` Plugged in, no battery available
	charging   = C.SDL_POWERSTATE_CHARGING   // `charging` Plugged in, charging battery
	charged    = C.SDL_POWERSTATE_CHARGED    // `charged` Plugged in, battery charged
}

// C.SDL_GetPowerInfo [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPowerInfo)
fn C.SDL_GetPowerInfo(seconds &int, percent &int) PowerState

// get_power_info gets the current power supply details.
//
// You should never take a battery status as absolute truth. Batteries
// (especially failing batteries) are delicate hardware, and the values
// reported here are best estimates based on what that hardware reports. It's
// not uncommon for older batteries to lose stored power much faster than it
// reports, or completely drain when reporting it has 20 percent left, etc.
//
// Battery status can change at any time; if you are concerned with power
// state, you should call this function frequently, and perhaps ignore changes
// until they seem to be stable for a few seconds.
//
// It's possible a platform can only report battery percentage or time left
// but not both.
//
// `seconds` seconds a pointer filled in with the seconds of battery life left,
//                or NULL to ignore. This will be filled in with -1 if we
//                can't determine a value or there is no battery.
// `percent` percent a pointer filled in with the percentage of battery life
//                left, between 0 and 100, or NULL to ignore. This will be
//                filled in with -1 we can't determine a value or there is no
//                battery.
// returns the current battery state or `SDL_POWERSTATE_ERROR` on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_power_info(seconds &int, percent &int) PowerState {
	return C.SDL_GetPowerInfo(seconds, percent)
}
