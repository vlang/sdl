// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_power.h
//

// PowerState is the basic state for the system's power supply.
// PowerState is C.SDL_PowerState
pub enum PowerState {
	unknown    = C.SDL_POWERSTATE_UNKNOWN // cannot determine power status
	on_battery = C.SDL_POWERSTATE_ON_BATTERY // Not plugged in, running on the battery
	no_battery = C.SDL_POWERSTATE_NO_BATTERY // Plugged in, no battery available
	charging   = C.SDL_POWERSTATE_CHARGING // Plugged in, charging battery
	charged    = C.SDL_POWERSTATE_CHARGED // Plugged in, battery charged
}

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
// `seconds` seconds of battery life left, you can pass a NULL here if
//           you don't care, will return -1 if we can't determine a
//           value, or we're not running on a battery
// `percent` percentage of battery life left, between 0 and 100, you can
//           pass a NULL here if you don't care, will return -1 if we
//           can't determine a value, or we're not running on a battery
// returns an SDL_PowerState enum representing the current battery state.
//
// NOTE This function is available since SDL 2.0.0.
pub fn get_power_info(seconds &int, percent &int) PowerState {
	return PowerState(C.SDL_GetPowerInfo(seconds, percent))
}
