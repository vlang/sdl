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

// record_gesture begins recording a gesture on the specified touch, or all touches (-1)
pub fn record_gesture(touch_id TouchID) int {
	return C.SDL_RecordGesture(C.SDL_TouchID(touch_id))
}

fn C.SDL_SaveAllDollarTemplates(dst &C.SDL_RWops) int

// save_all_dollar_templates saves all currently loaded Dollar Gesture templates
pub fn save_all_dollar_templates(dst &RWops) int {
	return C.SDL_SaveAllDollarTemplates(dst)
}

fn C.SDL_SaveDollarTemplate(gesture_id C.SDL_GestureID, dst &C.SDL_RWops) int

// save_dollar_template saves a currently loaded Dollar Gesture template
pub fn save_dollar_template(gesture_id GestureID, dst &RWops) int {
	return C.SDL_SaveDollarTemplate(C.SDL_GestureID(gesture_id), dst)
}

fn C.SDL_LoadDollarTemplates(touch_id C.SDL_TouchID, src &C.SDL_RWops) int

// load_dollar_templates loads Dollar Gesture templates from a file
pub fn load_dollar_templates(touch_id TouchID, src &RWops) int {
	return C.SDL_LoadDollarTemplates(C.SDL_TouchID(touch_id), src)
}
