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
	unknown    = C.SDL_POWERSTATE_UNKNOWN    // cannot determine power status
	on_battery = C.SDL_POWERSTATE_ON_BATTERY // Not plugged in, running on the battery
	no_battery = C.SDL_POWERSTATE_NO_BATTERY // Plugged in, no battery available
	charging   = C.SDL_POWERSTATE_CHARGING   // Plugged in, charging battery
	charged    = C.SDL_POWERSTATE_CHARGED    // Plugged in, battery charged
}

fn C.SDL_GetPowerInfo(secs &int, pct &int) PowerState

// get_power_info gets the current power supply details.
//
// `secs` Seconds of battery life left. You can pass a NULL here if
//             you don't care. Will return -1 if we can't determine a
//             value, or we're not running on a battery.
//
// `pct` Percentage of battery life left, between 0 and 100. You can
//             pass a NULL here if you don't care. Will return -1 if we
//             can't determine a value, or we're not running on a battery.
//
// returns The state of the battery (if any).
pub fn get_power_info(secs &int, pct &int) PowerState {
	return PowerState(C.SDL_GetPowerInfo(secs, pct))
}
