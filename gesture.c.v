// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_gesture.h
//

// `typedef Sint64 SDL_GestureID;`
// GestureID can be cast to C.SDL_GestureID
pub type GestureID = i64

fn C.SDL_RecordGesture(touch_id C.SDL_TouchID) int

// record_gesture begins recording a gesture on a specified touch device or all touch devices.
//
// If the parameter `touchId` is -1 (i.e., all devices), this function will
// always return 1, regardless of whether there actually are any devices.
//
// `touchId` the touch device id, or -1 for all touch devices.
// returns 1 on success or 0 if the specified device could not be found.
//
// NOTE: This function is available since SDL 2.0.0.
//
// See also: SDL_GetTouchDevice
pub fn record_gesture(touch_id TouchID) int {
	return C.SDL_RecordGesture(C.SDL_TouchID(touch_id))
}

fn C.SDL_SaveAllDollarTemplates(dst &C.SDL_RWops) int

// save_all_dollar_templates saves all currently loaded Dollar Gesture templates.
//
// `dst` a SDL_RWops to save to.
// returns the number of saved templates on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 2.0.0.
//
// See also: SDL_LoadDollarTemplates
// See also: SDL_SaveDollarTemplate
pub fn save_all_dollar_templates(dst &RWops) int {
	return C.SDL_SaveAllDollarTemplates(dst)
}

fn C.SDL_SaveDollarTemplate(gesture_id C.SDL_GestureID, dst &C.SDL_RWops) int

// save_dollar_template saves a currently loaded Dollar Gesture template.
//
// `gestureId` a gesture id.
// `dst` a SDL_RWops to save to.
// returns 1 on success or 0 on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 2.0.0.
//
// See also: SDL_LoadDollarTemplates
// See also: SDL_SaveAllDollarTemplates
pub fn save_dollar_template(gesture_id GestureID, dst &RWops) int {
	return C.SDL_SaveDollarTemplate(C.SDL_GestureID(gesture_id), dst)
}

fn C.SDL_LoadDollarTemplates(touch_id C.SDL_TouchID, src &C.SDL_RWops) int

// load_dollar_templates loads Dollar Gesture templates from a file.
//
// `touchId` a touch id.
// `src` a SDL_RWops to load from.
// returns the number of loaded templates on success or a negative error code
//          (or 0) on failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 2.0.0.
//
// See also: SDL_SaveAllDollarTemplates
// See also: SDL_SaveDollarTemplate
pub fn load_dollar_templates(touch_id TouchID, src &RWops) int {
	return C.SDL_LoadDollarTemplates(C.SDL_TouchID(touch_id), src)
}
