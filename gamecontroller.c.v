// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_gamecontroller.h
//

// In order to use these functions, SDL_Init() must have been called
// with the ::SDL_INIT_GAMECONTROLLER flag.  This causes SDL to scan the system
// for game controllers, and load appropriate drivers.
//
// If you would like to receive controller updates while the application
// is in the background, you should set the following hint before calling
// SDL_Init(): SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS
//

// GameController is the gamecontroller structure used to identify an SDL game controller
[typedef]
struct C.SDL_GameController {
}

pub type GameController = C.SDL_GameController

// GameControllerBindType is C.SDL_GameControllerBindType
pub enum GameControllerBindType {
	@none = C.SDL_CONTROLLER_BINDTYPE_NONE // 0
	button = C.SDL_CONTROLLER_BINDTYPE_BUTTON
	axis = C.SDL_CONTROLLER_BINDTYPE_AXIS
	hat = C.SDL_CONTROLLER_BINDTYPE_HAT
}

pub union Value {
	button int
	axis   int
}

pub struct Hat {
	hat      int
	hat_mask int
}

[typedef]
struct C.SDL_GameControllerButtonBind {
pub mut:
	bindType GameControllerBindType // C.SDL_GameControllerBindType
	value    Value
	hat      Hat
}

pub type GameControllerButtonBind = C.SDL_GameControllerButtonBind

// To count the number of game controllers in the system for the following:
// int nJoysticks = SDL_NumJoysticks();
// int nGameControllers = 0;
// for (int i = 0; i < nJoysticks; i++) {
//     if (SDL_IsGameController(i)) {
//         nGameControllers++;
//     }
// }
//
// Using the SDL_HINT_GAMECONTROLLERCONFIG hint or the SDL_GameControllerAddMapping() you can add support for controllers SDL is unaware of or cause an existing controller to have a different binding. The format is:
// guid,name,mappings
//
// Where GUID is the string value from SDL_JoystickGetGUIDString(), name is the human readable string for the device and mappings are controller mappings to joystick ones.
// Under Windows there is a reserved GUID of "xinput" that covers any XInput devices.
// The mapping format for joystick is:
//     bX - a joystick button, index X
//     hX.Y - hat X with value Y
//     aX - axis X of the joystick
// Buttons can be used as a controller axis and vice versa.
//
// This string shows an example of a valid mapping for a controller
// "03000000341a00003608000000000000,PS3 Controller,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,back:b8,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftshoulder:b4,rightshoulder:b5,leftstick:b10,rightstick:b11,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7",
//
///

fn C.SDL_GameControllerAddMappingsFromRW(rw &C.SDL_RWops, freerw int) int

// game_controller_add_mappings_from_rw loads a set of mappings from a seekable SDL data stream (memory or file), filtered by the current SDL_GetPlatform()
// A community sourced database of controllers is available at https://raw.github.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt
//
// If `freerw` is non-zero, the stream will be closed after being read.
//
// returns number of mappings added, -1 on error
pub fn game_controller_add_mappings_from_rw(rw &RWops, freerw int) int {
	return C.SDL_GameControllerAddMappingsFromRW(rw, freerw)
}

fn C.SDL_GameControllerAddMappingsFromFile(file &char) int

// game_controller_add_mappings_from_file loads a set of mappings from a file, filtered by the current SDL_GetPlatform()
//
// Convenience macro.
pub fn game_controller_add_mappings_from_file(file string) int {
	return C.SDL_GameControllerAddMappingsFromFile(file.str)
}

fn C.SDL_GameControllerAddMapping(mapping_string &char) int

// game_controller_add_mapping adds or updates an existing mapping configuration
//
// returns 1 if mapping is added, 0 if updated, -1 on error
pub fn game_controller_add_mapping(mapping_string string) int {
	return C.SDL_GameControllerAddMapping(mapping_string.str)
}

fn C.SDL_GameControllerNumMappings() int

// game_controller_num_mappings gets the number of mappings installed
//
// returns the number of mappings
pub fn game_controller_num_mappings() int {
	return C.SDL_GameControllerNumMappings()
}

fn C.SDL_GameControllerMappingForIndex(mapping_index int) &char

// game_controller_mapping_for_index gets the mapping at a particular index.
//
// returns the mapping string.  Must be freed with SDL_free().  Returns NULL if the index is out of range.
pub fn game_controller_mapping_for_index(mapping_index int) string {
	cstr := C.SDL_GameControllerMappingForIndex(mapping_index)
	mut vstr := ''
	if !isnil(cstr) {
		vstr = unsafe { cstring_to_vstring(cstr) }
		unsafe { free(cstr) }
	}
	return vstr
}

fn C.SDL_GameControllerMappingForGUID(guid C.SDL_JoystickGUID) &char

// Get a mapping string for a GUID
//
// returns the mapping string.  Must be freed with SDL_free().  Returns NULL if no mapping is available
pub fn game_controller_mapping_for_guid(guid JoystickGUID) string {
	cstr := C.SDL_GameControllerMappingForGUID(guid)
	mut vstr := ''
	if !isnil(cstr) {
		vstr = unsafe { cstring_to_vstring(cstr) }
		unsafe { free(cstr) }
	}
	return vstr
}

fn C.SDL_GameControllerMapping(gamecontroller &C.SDL_GameController) &char

// game_controller_mapping gets a mapping string for an open GameController
//
// returns the mapping string.  Must be freed with SDL_free().  Returns NULL if no mapping is available
pub fn game_controller_mapping(gamecontroller &GameController) string {
	cstr := C.SDL_GameControllerMapping(gamecontroller)
	mut vstr := ''
	if !isnil(cstr) {
		vstr = unsafe { cstring_to_vstring(cstr) }
		unsafe { free(cstr) }
	}
	return vstr
}

fn C.SDL_IsGameController(joystick_index int) bool

// is_game_controller returns whether the joystick on this index supported by the game controller interface?
pub fn is_game_controller(joystick_index int) bool {
	return C.SDL_IsGameController(joystick_index)
}

fn C.SDL_GameControllerNameForIndex(joystick_index int) &char

// game_controller_name_for_index gets the implementation dependent name of a game controller.
// This can be called before any controllers are opened.
// If no name can be found, this function returns NULL.
pub fn game_controller_name_for_index(joystick_index int) string {
	cstr := C.SDL_GameControllerNameForIndex(joystick_index)
	mut vstr := ''
	if !isnil(cstr) {
		vstr = unsafe { cstring_to_vstring(cstr) }
		// unsafe { free(cstr) }
	}
	return vstr
}

fn C.SDL_GameControllerMappingForDeviceIndex(joystick_index int) &char

// game_controller_mapping_for_device_index gets the mapping of a game controller.
// This can be called before any controllers are opened.
//
// returns the mapping string. Must be freed with SDL_free(). Returns NULL if no mapping is available
pub fn game_controller_mapping_for_device_index(joystick_index int) string {
	cstr := C.SDL_GameControllerMappingForDeviceIndex(joystick_index)
	mut vstr := ''
	if !isnil(cstr) {
		vstr = unsafe { cstring_to_vstring(cstr) }
		unsafe { free(cstr) }
	}
	return vstr
}

fn C.SDL_GameControllerOpen(joystick_index int) &C.SDL_GameController

// game_controller_open opens a game controller for use.
// The index passed as an argument refers to the N'th game controller on the system.
// This index is not the value which will identify this controller in future
// controller events.  The joystick's instance id (::SDL_JoystickID) will be
// used there instead.
//
// returns A controller identifier, or NULL if an error occurred.
pub fn game_controller_open(joystick_index int) &GameController {
	return C.SDL_GameControllerOpen(joystick_index)
}

fn C.SDL_GameControllerFromInstanceID(joyid JoystickID) &C.SDL_GameController

// game_controller_from_instance_id returns the SDL_GameController associated with an instance id.
pub fn game_controller_from_instance_id(joyid JoystickID) &GameController {
	return C.SDL_GameControllerFromInstanceID(joyid)
}

fn C.SDL_GameControllerName(gamecontroller &C.SDL_GameController) &char

// game_controller_name returns the name for this currently opened controller
pub fn game_controller_name(gamecontroller &GameController) string {
	return unsafe { cstring_to_vstring(C.SDL_GameControllerName(gamecontroller)) }
}

fn C.SDL_GameControllerGetPlayerIndex(gamecontroller &C.SDL_GameController) int

// game_controller_get_player_index gets the player index of an opened game controller, or -1 if it's not available
//
// For XInput controllers this returns the XInput user index.
pub fn game_controller_get_player_index(gamecontroller &GameController) int {
	return C.SDL_GameControllerGetPlayerIndex(gamecontroller)
}

fn C.SDL_GameControllerGetVendor(gamecontroller &C.SDL_GameController) u16

// game_controller_get_vendor gets the USB vendor ID of an opened controller, if available.
// If the vendor ID isn't available this function returns 0.
pub fn game_controller_get_vendor(gamecontroller &GameController) u16 {
	return C.SDL_GameControllerGetVendor(gamecontroller)
}

fn C.SDL_GameControllerGetProduct(gamecontroller &C.SDL_GameController) u16

// game_controller_get_product gets the USB product ID of an opened controller, if available.
// If the product ID isn't available this function returns 0.
pub fn game_controller_get_product(gamecontroller &GameController) u16 {
	return C.SDL_GameControllerGetProduct(gamecontroller)
}

fn C.SDL_GameControllerGetProductVersion(gamecontroller &C.SDL_GameController) u16

// game_controller_get_product_version gets the product version of an opened controller, if available.
// If the product version isn't available this function returns 0.
pub fn game_controller_get_product_version(gamecontroller &GameController) u16 {
	return C.SDL_GameControllerGetProductVersion(gamecontroller)
}

fn C.SDL_GameControllerGetAttached(gamecontroller &C.SDL_GameController) bool

// game_controller_get_attached returns SDL_TRUE if the controller has been opened and currently connected,
// or SDL_FALSE if it has not.
pub fn game_controller_get_attached(gamecontroller &GameController) bool {
	return C.SDL_GameControllerGetAttached(gamecontroller)
}

fn C.SDL_GameControllerGetJoystick(gamecontroller &C.SDL_GameController) &C.SDL_Joystick

// game_controller_get_joystick gets the underlying joystick object used by a controller
pub fn game_controller_get_joystick(gamecontroller &GameController) &Joystick {
	return C.SDL_GameControllerGetJoystick(gamecontroller)
}

fn C.SDL_GameControllerEventState(state int) int

// game_controller_event_state enables/disables controller event polling.
//
// If controller events are disabled, you must call SDL_GameControllerUpdate()
// yourself and check the state of the controller when you want controller
// information.
//
// The state can be one of ::SDL_QUERY, ::SDL_ENABLE or ::SDL_IGNORE.
pub fn game_controller_event_state(state int) int {
	return C.SDL_GameControllerEventState(state)
}

fn C.SDL_GameControllerUpdate()

// game_controller_update updates the current state of the open game controllers.
//
// This is called automatically by the event loop if any game controller
// events are enabled.
pub fn game_controller_update() {
	C.SDL_GameControllerUpdate()
}

// GameControllerAxis is the list of axes available from a controller
//
// Thumbstick axis values range from SDL_JOYSTICK_AXIS_MIN to SDL_JOYSTICK_AXIS_MAX,
// and are centered within ~8000 of zero, though advanced UI will allow users to set
// or autodetect the dead zone, which varies between controllers.
//
// Trigger axis values range from 0 to SDL_JOYSTICK_AXIS_MAX.
//
// GameControllerAxis is C.SDL_GameControllerAxis
pub enum GameControllerAxis {
	invalid = C.SDL_CONTROLLER_AXIS_INVALID // -1
	leftx = C.SDL_CONTROLLER_AXIS_LEFTX
	lefty = C.SDL_CONTROLLER_AXIS_LEFTY
	rightx = C.SDL_CONTROLLER_AXIS_RIGHTX
	righty = C.SDL_CONTROLLER_AXIS_RIGHTY
	triggerleft = C.SDL_CONTROLLER_AXIS_TRIGGERLEFT
	triggerright = C.SDL_CONTROLLER_AXIS_TRIGGERRIGHT
	max = C.SDL_CONTROLLER_AXIS_MAX
}

fn C.SDL_GameControllerGetAxisFromString(pch_string &char) C.SDL_GameControllerAxis

// game_controller_get_axis_from_string turns the string into an axis mapping
pub fn game_controller_get_axis_from_string(pch_string string) GameControllerAxis {
	return GameControllerAxis(C.SDL_GameControllerGetAxisFromString(pch_string.str))
}

// game_controller_get_string_for_axis turns the axis enum into a string mapping
///
fn C.SDL_GameControllerGetStringForAxis(axis C.SDL_GameControllerAxis) &char
pub fn game_controller_get_string_for_axis(axis GameControllerAxis) string {
	cstr := C.SDL_GameControllerGetStringForAxis(C.SDL_GameControllerAxis(axis))
	mut vstr := ''
	if !isnil(cstr) {
		vstr = unsafe { cstring_to_vstring(cstr) }
		// unsafe { free(cstr) }
	}
	return vstr
}

fn C.SDL_GameControllerGetBindForAxis(gamecontroller &C.SDL_GameController, axis C.SDL_GameControllerAxis) C.SDL_GameControllerButtonBind

// Get the SDL joystick layer binding for this controller button mapping
pub fn game_controller_get_bind_for_axis(gamecontroller &GameController, axis GameControllerAxis) GameControllerButtonBind {
	return C.SDL_GameControllerGetBindForAxis(gamecontroller, C.SDL_GameControllerAxis(axis))
}

fn C.SDL_GameControllerGetAxis(gamecontroller &C.SDL_GameController, axis C.SDL_GameControllerAxis) i16

// Get the current state of an axis control on a game controller.
//
// The state is a value ranging from -32768 to 32767 (except for the triggers,
// which range from 0 to 32767).
//
// The axis indices start at index 0.
pub fn game_controller_get_axis(gamecontroller &GameController, axis GameControllerAxis) i16 {
	return C.SDL_GameControllerGetAxis(gamecontroller, C.SDL_GameControllerAxis(axis))
}

// GameControllerButton is the list of buttons available from a controller
// GameControllerButton is C.SDL_GameControllerButton
pub enum GameControllerButton {
	invalid = C.SDL_CONTROLLER_BUTTON_INVALID // -1
	a = C.SDL_CONTROLLER_BUTTON_A
	b = C.SDL_CONTROLLER_BUTTON_B
	x = C.SDL_CONTROLLER_BUTTON_X
	y = C.SDL_CONTROLLER_BUTTON_Y
	back = C.SDL_CONTROLLER_BUTTON_BACK
	guide = C.SDL_CONTROLLER_BUTTON_GUIDE
	start = C.SDL_CONTROLLER_BUTTON_START
	leftstick = C.SDL_CONTROLLER_BUTTON_LEFTSTICK
	rightstick = C.SDL_CONTROLLER_BUTTON_RIGHTSTICK
	leftshoulder = C.SDL_CONTROLLER_BUTTON_LEFTSHOULDER
	rightshoulder = C.SDL_CONTROLLER_BUTTON_RIGHTSHOULDER
	dpad_up = C.SDL_CONTROLLER_BUTTON_DPAD_UP
	dpad_down = C.SDL_CONTROLLER_BUTTON_DPAD_DOWN
	dpad_left = C.SDL_CONTROLLER_BUTTON_DPAD_LEFT
	dpad_right = C.SDL_CONTROLLER_BUTTON_DPAD_RIGHT
	max = C.SDL_CONTROLLER_BUTTON_MAX
}

fn C.SDL_GameControllerGetButtonFromString(pch_string &char) C.SDL_GameControllerButton

// game_controller_get_button_from_string turns the string into a button mapping
pub fn game_controller_get_button_from_string(pch_string string) GameControllerButton {
	return GameControllerButton(C.SDL_GameControllerGetButtonFromString(pch_string.str))
}

// game_controller_get_string_for_button turns the button enum into a string mapping
///
fn C.SDL_GameControllerGetStringForButton(button C.SDL_GameControllerButton) &char
pub fn game_controller_get_string_for_button(button GameControllerButton) string {
	cstr := C.SDL_GameControllerGetStringForButton(C.SDL_GameControllerButton(button))
	mut vstr := ''
	if !isnil(cstr) {
		vstr = unsafe { cstring_to_vstring(cstr) }
		// unsafe { free(cstr) }
	}
	return vstr
}

fn C.SDL_GameControllerGetBindForButton(gamecontroller &C.SDL_GameController, button C.SDL_GameControllerButton) C.SDL_GameControllerButtonBind

// game_controller_get_bind_for_button gets the SDL joystick layer binding for this controller button mapping
pub fn game_controller_get_bind_for_button(gamecontroller &GameController, button GameControllerButton) GameControllerButtonBind {
	return C.SDL_GameControllerGetBindForButton(gamecontroller, C.SDL_GameControllerButton(button))
}

fn C.SDL_GameControllerGetButton(gamecontroller &C.SDL_GameController, button C.SDL_GameControllerButton) byte

// game_controller_get_button gets the current state of a button on a game controller.
//
// The button indices start at index 0.
pub fn game_controller_get_button(gamecontroller &GameController, button GameControllerButton) byte {
	return C.SDL_GameControllerGetButton(gamecontroller, C.SDL_GameControllerButton(button))
}

fn C.SDL_GameControllerRumble(gamecontroller &C.SDL_GameController, low_frequency_rumble u16, high_frequency_rumble u16, duration_ms u32) int

// game_controller_rumble triggers a rumble effect
// Each call to this function cancels any previous rumble effect, and calling it with 0 intensity stops any rumbling.
//
// `gamecontroller` The controller to vibrate
// `low_frequency_rumble` The intensity of the low frequency (left) rumble motor, from 0 to 0xFFFF
// `high_frequency_rumble` The intensity of the high frequency (right) rumble motor, from 0 to 0xFFFF
// `duration_ms` The duration of the rumble effect, in milliseconds
//
// returns 0, or -1 if rumble isn't supported on this joystick
pub fn game_controller_rumble(gamecontroller &GameController, low_frequency_rumble u16, high_frequency_rumble u16, duration_ms u32) int {
	return C.SDL_GameControllerRumble(gamecontroller, low_frequency_rumble, high_frequency_rumble,
		duration_ms)
}

fn C.SDL_GameControllerClose(gamecontroller &C.SDL_GameController)

// game_controller_close closes a controller previously opened with SDL_GameControllerOpen().
pub fn game_controller_close(gamecontroller &GameController) {
	C.SDL_GameControllerClose(gamecontroller)
}
