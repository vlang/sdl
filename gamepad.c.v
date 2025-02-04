// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_gamepad.h
//

// SDL provides a low-level joystick API, which just treats joysticks as an
// arbitrary pile of buttons, axes, and hat switches. If you're planning to
// write your own control configuration screen, this can give you a lot of
// flexibility, but that's a lot of work, and most things that we consider
// "joysticks" now are actually console-style gamepads. So SDL provides the
// gamepad API on top of the lower-level joystick functionality.
//
// The difference between a joystick and a gamepad is that a gamepad tells you
// _where_ a button or axis is on the device. You don't speak to gamepads in
// terms of arbitrary numbers like "button 3" or "axis 2" but in standard
// locations: the d-pad, the shoulder buttons, triggers, A/B/X/Y (or
// X/O/Square/Triangle, if you will).
//
// One turns a joystick into a gamepad by providing a magic configuration
// string, which tells SDL the details of a specific device: when you see this
// specific hardware, if button 2 gets pressed, this is actually D-Pad Up,
// etc.
//
// SDL has many popular controllers configured out of the box, and users can
// add their own controller details through an environment variable if it's
// otherwise unknown to SDL.
//
// In order to use these functions, SDL_Init() must have been called with the
// SDL_INIT_GAMEPAD flag. This causes SDL to scan the system for gamepads, and
// load appropriate drivers.
//
// If you would like to receive gamepad updates while the application is in
// the background, you should set the following hint before calling
// SDL_Init(): SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS
//
// Gamepads support various optional features such as rumble, color LEDs,
// touchpad, gyro, etc. The support for these features varies depending on the
// controller and OS support available. You can check for LED and rumble
// capabilities at runtime by calling SDL_GetGamepadProperties() and checking
// the various capability properties. You can check for touchpad by calling
// SDL_GetNumGamepadTouchpads() and check for gyro and accelerometer by
// calling SDL_GamepadHasSensor().
//
// By default SDL will try to use the most capable driver available, but you
// can tune which OS drivers to use with the various joystick hints in
// SDL_hints.h.
//
// Your application should always support gamepad hotplugging. On some
// platforms like Xbox, Steam Deck, etc., this is a requirement for
// certification. On other platforms, like macOS and Windows when using
// Windows.Gaming.Input, controllers may not be available at startup and will
// come in at some point after you've started processing events.

@[noinit; typedef]
pub struct C.SDL_Gamepad {
	// NOTE: Opaque type
}

pub type Gamepad = C.SDL_Gamepad

// GamepadType is C.SDL_GamepadType
pub enum GamepadType {
	unknown                      = C.SDL_GAMEPAD_TYPE_UNKNOWN // 0,
	standard                     = C.SDL_GAMEPAD_TYPE_STANDARD
	xbox360                      = C.SDL_GAMEPAD_TYPE_XBOX360
	xboxone                      = C.SDL_GAMEPAD_TYPE_XBOXONE
	ps3                          = C.SDL_GAMEPAD_TYPE_PS3
	ps4                          = C.SDL_GAMEPAD_TYPE_PS4
	ps5                          = C.SDL_GAMEPAD_TYPE_PS5
	nintendo_switch_pro          = C.SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_PRO
	nintendo_switch_joycon_left  = C.SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_LEFT
	nintendo_switch_joycon_right = C.SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT
	nintendo_switch_joycon_pair  = C.SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_PAIR
	count                        = C.SDL_GAMEPAD_TYPE_COUNT
}

// GamepadButton is C.SDL_GamepadButton
pub enum GamepadButton {
	invalid        = C.SDL_GAMEPAD_BUTTON_INVALID // -1,
	south          = C.SDL_GAMEPAD_BUTTON_SOUTH   // `south` Bottom face button (e.g. Xbox A button)
	east           = C.SDL_GAMEPAD_BUTTON_EAST    // `east` Right face button (e.g. Xbox B button)
	west           = C.SDL_GAMEPAD_BUTTON_WEST    // `west` Left face button (e.g. Xbox X button)
	north          = C.SDL_GAMEPAD_BUTTON_NORTH   // `north` Top face button (e.g. Xbox Y button)
	back           = C.SDL_GAMEPAD_BUTTON_BACK
	guide          = C.SDL_GAMEPAD_BUTTON_GUIDE
	start          = C.SDL_GAMEPAD_BUTTON_START
	left_stick     = C.SDL_GAMEPAD_BUTTON_LEFT_STICK
	right_stick    = C.SDL_GAMEPAD_BUTTON_RIGHT_STICK
	left_shoulder  = C.SDL_GAMEPAD_BUTTON_LEFT_SHOULDER
	right_shoulder = C.SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER
	dpad_up        = C.SDL_GAMEPAD_BUTTON_DPAD_UP
	dpad_down      = C.SDL_GAMEPAD_BUTTON_DPAD_DOWN
	dpad_left      = C.SDL_GAMEPAD_BUTTON_DPAD_LEFT
	dpad_right     = C.SDL_GAMEPAD_BUTTON_DPAD_RIGHT
	misc1          = C.SDL_GAMEPAD_BUTTON_MISC1         // `misc1` Additional button (e.g. Xbox Series X share button, PS5 microphone button, Nintendo Switch Pro capture button, Amazon Luna microphone button, Google Stadia capture button)
	right_paddle1  = C.SDL_GAMEPAD_BUTTON_RIGHT_PADDLE1 // `right_paddle1` Upper or primary paddle, under your right hand (e.g. Xbox Elite paddle P1)
	left_paddle1   = C.SDL_GAMEPAD_BUTTON_LEFT_PADDLE1  // `left_paddle1` Upper or primary paddle, under your left hand (e.g. Xbox Elite paddle P3)
	right_paddle2  = C.SDL_GAMEPAD_BUTTON_RIGHT_PADDLE2 // `right_paddle2` Lower or secondary paddle, under your right hand (e.g. Xbox Elite paddle P2)
	left_paddle2   = C.SDL_GAMEPAD_BUTTON_LEFT_PADDLE2  // `left_paddle2` Lower or secondary paddle, under your left hand (e.g. Xbox Elite paddle P4)
	touchpad       = C.SDL_GAMEPAD_BUTTON_TOUCHPAD      // `touchpad` PS4/PS5 touchpad button
	misc2          = C.SDL_GAMEPAD_BUTTON_MISC2         // `misc2` Additional button
	misc3          = C.SDL_GAMEPAD_BUTTON_MISC3         // `misc3` Additional button
	misc4          = C.SDL_GAMEPAD_BUTTON_MISC4         // `misc4` Additional button
	misc5          = C.SDL_GAMEPAD_BUTTON_MISC5         // `misc5` Additional button
	misc6          = C.SDL_GAMEPAD_BUTTON_MISC6         // `misc6` Additional button
	count          = C.SDL_GAMEPAD_BUTTON_COUNT
}

// GamepadButtonLabel is C.SDL_GamepadButtonLabel
pub enum GamepadButtonLabel {
	unknown  = C.SDL_GAMEPAD_BUTTON_LABEL_UNKNOWN
	a        = C.SDL_GAMEPAD_BUTTON_LABEL_A
	b        = C.SDL_GAMEPAD_BUTTON_LABEL_B
	x        = C.SDL_GAMEPAD_BUTTON_LABEL_X
	y        = C.SDL_GAMEPAD_BUTTON_LABEL_Y
	cross    = C.SDL_GAMEPAD_BUTTON_LABEL_CROSS
	circle   = C.SDL_GAMEPAD_BUTTON_LABEL_CIRCLE
	square   = C.SDL_GAMEPAD_BUTTON_LABEL_SQUARE
	triangle = C.SDL_GAMEPAD_BUTTON_LABEL_TRIANGLE
}

// GamepadAxis is C.SDL_GamepadAxis
pub enum GamepadAxis {
	invalid       = C.SDL_GAMEPAD_AXIS_INVALID // -1,
	leftx         = C.SDL_GAMEPAD_AXIS_LEFTX
	lefty         = C.SDL_GAMEPAD_AXIS_LEFTY
	rightx        = C.SDL_GAMEPAD_AXIS_RIGHTX
	righty        = C.SDL_GAMEPAD_AXIS_RIGHTY
	left_trigger  = C.SDL_GAMEPAD_AXIS_LEFT_TRIGGER
	right_trigger = C.SDL_GAMEPAD_AXIS_RIGHT_TRIGGER
	count         = C.SDL_GAMEPAD_AXIS_COUNT
}

// GamepadBindingType is C.SDL_GamepadBindingType
pub enum GamepadBindingType {
	@none  = C.SDL_GAMEPAD_BINDTYPE_NONE // 0,
	button = C.SDL_GAMEPAD_BINDTYPE_BUTTON
	axis   = C.SDL_GAMEPAD_BINDTYPE_AXIS
	hat    = C.SDL_GAMEPAD_BINDTYPE_HAT
}

@[typedef]
pub struct C.SDL_GamepadBinding {
pub mut:
	input_type GamepadBindingType

	// TODO// union {
	//  int button; struct {
	//  int axis; int axis_min; int axis_max; } axis
	// TODO// struct {
	//  int hat; int hat_mask; } hat; } input
	output_type GamepadBindingType
}

// TODO: BELONGS ABOVE // union {
//  SDL_GamepadButton button; struct {
//  SDL_GamepadAxis axis; int axis_min; int axis_max; } axis; } output

pub type GamepadBinding = C.SDL_GamepadBinding

// C.SDL_AddGamepadMapping [official documentation](https://wiki.libsdl.org/SDL3/SDL_AddGamepadMapping)
fn C.SDL_AddGamepadMapping(const_mapping &char) int

// add_gamepad_mapping adds support for gamepads that SDL is unaware of or change the binding of an
// existing gamepad.
//
// The mapping string has the format "GUID,name,mapping", where GUID is the
// string value from SDL_GUIDToString(), name is the human readable string for
// the device and mappings are gamepad mappings to joystick ones. Under
// Windows there is a reserved GUID of "xinput" that covers all XInput
// devices. The mapping format for joystick is:
//
// - `bX`: a joystick button, index X
// - `hX.Y`: hat X with value Y
// - `aX`: axis X of the joystick
//
// Buttons can be used as a gamepad axes and vice versa.
//
// If a device with this GUID is already plugged in, SDL will generate an
// SDL_EVENT_GAMEPAD_ADDED event.
//
// This string shows an example of a valid mapping for a gamepad:
//
// ```c
// "341a3608000000000000504944564944,Afterglow PS3 Controller,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,back:b8,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftshoulder:b4,rightshoulder:b5,leftstick:b10,rightstick:b11,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7"
// ```
//
// `mapping` mapping the mapping string.
// returns 1 if a new mapping is added, 0 if an existing mapping is updated,
//          -1 on failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_gamepad_mappings_from_file (SDL_AddGamepadMappingsFromFile)
// See also: add_gamepad_mappings_from_io (SDL_AddGamepadMappingsFromIO)
// See also: get_gamepad_mapping (SDL_GetGamepadMapping)
// See also: get_gamepad_mapping_for_guid (SDL_GetGamepadMappingForGUID)
// See also: hintgamecontrollerconfig (SDL_HINT_GAMECONTROLLERCONFIG)
// See also: hintgamecontrollerconfigfile (SDL_HINT_GAMECONTROLLERCONFIG_FILE)
// See also: eventgamepadadded (SDL_EVENT_GAMEPAD_ADDED)
pub fn add_gamepad_mapping(const_mapping &char) int {
	return C.SDL_AddGamepadMapping(const_mapping)
}

// C.SDL_AddGamepadMappingsFromIO [official documentation](https://wiki.libsdl.org/SDL3/SDL_AddGamepadMappingsFromIO)
fn C.SDL_AddGamepadMappingsFromIO(src &IOStream, closeio bool) int

// add_gamepad_mappings_from_io loads a set of gamepad mappings from an SDL_IOStream.
//
// You can call this function several times, if needed, to load different
// database files.
//
// If a new mapping is loaded for an already known gamepad GUID, the later
// version will overwrite the one currently loaded.
//
// Any new mappings for already plugged in controllers will generate
// SDL_EVENT_GAMEPAD_ADDED events.
//
// Mappings not belonging to the current platform or with no platform field
// specified will be ignored (i.e. mappings for Linux will be ignored in
// Windows, etc).
//
// This function will load the text database entirely in memory before
// processing it, so take this into consideration if you are in a memory
// constrained environment.
//
// `src` src the data stream for the mappings to be added.
// `closeio` closeio if true, calls SDL_CloseIO() on `src` before returning, even
//                in the case of an error.
// returns the number of mappings added or -1 on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_gamepad_mapping (SDL_AddGamepadMapping)
// See also: add_gamepad_mappings_from_file (SDL_AddGamepadMappingsFromFile)
// See also: get_gamepad_mapping (SDL_GetGamepadMapping)
// See also: get_gamepad_mapping_for_guid (SDL_GetGamepadMappingForGUID)
// See also: hintgamecontrollerconfig (SDL_HINT_GAMECONTROLLERCONFIG)
// See also: hintgamecontrollerconfigfile (SDL_HINT_GAMECONTROLLERCONFIG_FILE)
// See also: eventgamepadadded (SDL_EVENT_GAMEPAD_ADDED)
pub fn add_gamepad_mappings_from_io(src &IOStream, closeio bool) int {
	return C.SDL_AddGamepadMappingsFromIO(src, closeio)
}

// C.SDL_AddGamepadMappingsFromFile [official documentation](https://wiki.libsdl.org/SDL3/SDL_AddGamepadMappingsFromFile)
fn C.SDL_AddGamepadMappingsFromFile(const_file &char) int

// add_gamepad_mappings_from_file loads a set of gamepad mappings from a file.
//
// You can call this function several times, if needed, to load different
// database files.
//
// If a new mapping is loaded for an already known gamepad GUID, the later
// version will overwrite the one currently loaded.
//
// Any new mappings for already plugged in controllers will generate
// SDL_EVENT_GAMEPAD_ADDED events.
//
// Mappings not belonging to the current platform or with no platform field
// specified will be ignored (i.e. mappings for Linux will be ignored in
// Windows, etc).
//
// `file` file the mappings file to load.
// returns the number of mappings added or -1 on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_gamepad_mapping (SDL_AddGamepadMapping)
// See also: add_gamepad_mappings_from_io (SDL_AddGamepadMappingsFromIO)
// See also: get_gamepad_mapping (SDL_GetGamepadMapping)
// See also: get_gamepad_mapping_for_guid (SDL_GetGamepadMappingForGUID)
// See also: hintgamecontrollerconfig (SDL_HINT_GAMECONTROLLERCONFIG)
// See also: hintgamecontrollerconfigfile (SDL_HINT_GAMECONTROLLERCONFIG_FILE)
// See also: eventgamepadadded (SDL_EVENT_GAMEPAD_ADDED)
pub fn add_gamepad_mappings_from_file(const_file &char) int {
	return C.SDL_AddGamepadMappingsFromFile(const_file)
}

// C.SDL_ReloadGamepadMappings [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReloadGamepadMappings)
fn C.SDL_ReloadGamepadMappings() bool

// reload_gamepad_mappings reinitializes the SDL mapping database to its initial state.
//
// This will generate gamepad events as needed if device mappings change.
//
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn reload_gamepad_mappings() bool {
	return C.SDL_ReloadGamepadMappings()
}

// C.SDL_GetGamepadMappings [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadMappings)
fn C.SDL_GetGamepadMappings(count &int) &&char

// get_gamepad_mappings gets the current gamepad mappings.
//
// `count` count a pointer filled in with the number of mappings returned, can
//              be NULL.
// returns an array of the mapping strings, NULL-terminated, or NULL on
//          failure; call SDL_GetError() for more information. This is a
//          single allocation that should be freed with SDL_free() when it is
//          no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_mappings(count &int) &&char {
	return C.SDL_GetGamepadMappings(count)
}

// C.SDL_GetGamepadMappingForGUID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadMappingForGUID)
fn C.SDL_GetGamepadMappingForGUID(guid GUID) &char

// get_gamepad_mapping_for_guid gets the gamepad mapping string for a given GUID.
//
// `guid` guid a structure containing the GUID for which a mapping is desired.
// returns a mapping string or NULL on failure; call SDL_GetError() for more
//          information. This should be freed with SDL_free() when it is no
//          longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_guid_for_id (SDL_GetJoystickGUIDForID)
// See also: get_joystick_guid (SDL_GetJoystickGUID)
pub fn get_gamepad_mapping_for_guid(guid GUID) &char {
	return C.SDL_GetGamepadMappingForGUID(guid)
}

// C.SDL_GetGamepadMapping [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadMapping)
fn C.SDL_GetGamepadMapping(gamepad &Gamepad) &char

// get_gamepad_mapping gets the current mapping of a gamepad.
//
// Details about mappings are discussed with SDL_AddGamepadMapping().
//
// `gamepad` gamepad the gamepad you want to get the current mapping for.
// returns a string that has the gamepad's mapping or NULL if no mapping is
//          available; call SDL_GetError() for more information. This should
//          be freed with SDL_free() when it is no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_gamepad_mapping (SDL_AddGamepadMapping)
// See also: get_gamepad_mapping_for_id (SDL_GetGamepadMappingForID)
// See also: get_gamepad_mapping_for_guid (SDL_GetGamepadMappingForGUID)
// See also: set_gamepad_mapping (SDL_SetGamepadMapping)
pub fn get_gamepad_mapping(gamepad &Gamepad) &char {
	return C.SDL_GetGamepadMapping(gamepad)
}

// C.SDL_SetGamepadMapping [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGamepadMapping)
fn C.SDL_SetGamepadMapping(instance_id JoystickID, const_mapping &char) bool

// set_gamepad_mapping sets the current mapping of a joystick or gamepad.
//
// Details about mappings are discussed with SDL_AddGamepadMapping().
//
// `instance_id` instance_id the joystick instance ID.
// `mapping` mapping the mapping to use for this device, or NULL to clear the
//                mapping.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_gamepad_mapping (SDL_AddGamepadMapping)
// See also: get_gamepad_mapping (SDL_GetGamepadMapping)
pub fn set_gamepad_mapping(instance_id JoystickID, const_mapping &char) bool {
	return C.SDL_SetGamepadMapping(instance_id, const_mapping)
}

// C.SDL_HasGamepad [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasGamepad)
fn C.SDL_HasGamepad() bool

// has_gamepad returns whether a gamepad is currently connected.
//
// returns true if a gamepad is connected, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepads (SDL_GetGamepads)
pub fn has_gamepad() bool {
	return C.SDL_HasGamepad()
}

// C.SDL_GetGamepads [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepads)
fn C.SDL_GetGamepads(count &int) JoystickID

// get_gamepads gets a list of currently connected gamepads.
//
// `count` count a pointer filled in with the number of gamepads returned, may
//              be NULL.
// returns a 0 terminated array of joystick instance IDs or NULL on failure;
//          call SDL_GetError() for more information. This should be freed
//          with SDL_free() when it is no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_gamepad (SDL_HasGamepad)
// See also: open_gamepad (SDL_OpenGamepad)
pub fn get_gamepads(count &int) JoystickID {
	return C.SDL_GetGamepads(count)
}

// C.SDL_IsGamepad [official documentation](https://wiki.libsdl.org/SDL3/SDL_IsGamepad)
fn C.SDL_IsGamepad(instance_id JoystickID) bool

// is_gamepad checks if the given joystick is supported by the gamepad interface.
//
// `instance_id` instance_id the joystick instance ID.
// returns true if the given joystick is supported by the gamepad interface,
//          false if it isn't or it's an invalid index.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joysticks (SDL_GetJoysticks)
// See also: open_gamepad (SDL_OpenGamepad)
pub fn is_gamepad(instance_id JoystickID) bool {
	return C.SDL_IsGamepad(instance_id)
}

// C.SDL_GetGamepadNameForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadNameForID)
fn C.SDL_GetGamepadNameForID(instance_id JoystickID) &char

// get_gamepad_name_for_id gets the implementation dependent name of a gamepad.
//
// This can be called before any gamepads are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the name of the selected gamepad. If no name can be found, this
//          function returns NULL; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_name (SDL_GetGamepadName)
// See also: get_gamepads (SDL_GetGamepads)
pub fn get_gamepad_name_for_id(instance_id JoystickID) &char {
	return C.SDL_GetGamepadNameForID(instance_id)
}

// C.SDL_GetGamepadPathForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadPathForID)
fn C.SDL_GetGamepadPathForID(instance_id JoystickID) &char

// get_gamepad_path_for_id gets the implementation dependent path of a gamepad.
//
// This can be called before any gamepads are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the path of the selected gamepad. If no path can be found, this
//          function returns NULL; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_path (SDL_GetGamepadPath)
// See also: get_gamepads (SDL_GetGamepads)
pub fn get_gamepad_path_for_id(instance_id JoystickID) &char {
	return C.SDL_GetGamepadPathForID(instance_id)
}

// C.SDL_GetGamepadPlayerIndexForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadPlayerIndexForID)
fn C.SDL_GetGamepadPlayerIndexForID(instance_id JoystickID) int

// get_gamepad_player_index_for_id gets the player index of a gamepad.
//
// This can be called before any gamepads are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the player index of a gamepad, or -1 if it's not available.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_player_index (SDL_GetGamepadPlayerIndex)
// See also: get_gamepads (SDL_GetGamepads)
pub fn get_gamepad_player_index_for_id(instance_id JoystickID) int {
	return C.SDL_GetGamepadPlayerIndexForID(instance_id)
}

// C.SDL_GetGamepadGUIDForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadGUIDForID)
fn C.SDL_GetGamepadGUIDForID(instance_id JoystickID) GUID

// get_gamepad_guid_for_id gets the implementation-dependent GUID of a gamepad.
//
// This can be called before any gamepads are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the GUID of the selected gamepad. If called on an invalid index,
//          this function returns a zero GUID.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: guid_to_string (SDL_GUIDToString)
// See also: get_gamepads (SDL_GetGamepads)
pub fn get_gamepad_guid_for_id(instance_id JoystickID) GUID {
	return C.SDL_GetGamepadGUIDForID(instance_id)
}

// C.SDL_GetGamepadVendorForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadVendorForID)
fn C.SDL_GetGamepadVendorForID(instance_id JoystickID) u16

// get_gamepad_vendor_for_id gets the USB vendor ID of a gamepad, if available.
//
// This can be called before any gamepads are opened. If the vendor ID isn't
// available this function returns 0.
//
// `instance_id` instance_id the joystick instance ID.
// returns the USB vendor ID of the selected gamepad. If called on an invalid
//          index, this function returns zero.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_vendor (SDL_GetGamepadVendor)
// See also: get_gamepads (SDL_GetGamepads)
pub fn get_gamepad_vendor_for_id(instance_id JoystickID) u16 {
	return C.SDL_GetGamepadVendorForID(instance_id)
}

// C.SDL_GetGamepadProductForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadProductForID)
fn C.SDL_GetGamepadProductForID(instance_id JoystickID) u16

// get_gamepad_product_for_id gets the USB product ID of a gamepad, if available.
//
// This can be called before any gamepads are opened. If the product ID isn't
// available this function returns 0.
//
// `instance_id` instance_id the joystick instance ID.
// returns the USB product ID of the selected gamepad. If called on an
//          invalid index, this function returns zero.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_product (SDL_GetGamepadProduct)
// See also: get_gamepads (SDL_GetGamepads)
pub fn get_gamepad_product_for_id(instance_id JoystickID) u16 {
	return C.SDL_GetGamepadProductForID(instance_id)
}

// C.SDL_GetGamepadProductVersionForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadProductVersionForID)
fn C.SDL_GetGamepadProductVersionForID(instance_id JoystickID) u16

// get_gamepad_product_version_for_id gets the product version of a gamepad, if available.
//
// This can be called before any gamepads are opened. If the product version
// isn't available this function returns 0.
//
// `instance_id` instance_id the joystick instance ID.
// returns the product version of the selected gamepad. If called on an
//          invalid index, this function returns zero.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_product_version (SDL_GetGamepadProductVersion)
// See also: get_gamepads (SDL_GetGamepads)
pub fn get_gamepad_product_version_for_id(instance_id JoystickID) u16 {
	return C.SDL_GetGamepadProductVersionForID(instance_id)
}

// C.SDL_GetGamepadTypeForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadTypeForID)
fn C.SDL_GetGamepadTypeForID(instance_id JoystickID) GamepadType

// get_gamepad_type_for_id gets the type of a gamepad.
//
// This can be called before any gamepads are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the gamepad type.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_type (SDL_GetGamepadType)
// See also: get_gamepads (SDL_GetGamepads)
// See also: get_real_gamepad_type_for_id (SDL_GetRealGamepadTypeForID)
pub fn get_gamepad_type_for_id(instance_id JoystickID) GamepadType {
	return C.SDL_GetGamepadTypeForID(instance_id)
}

// C.SDL_GetRealGamepadTypeForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRealGamepadTypeForID)
fn C.SDL_GetRealGamepadTypeForID(instance_id JoystickID) GamepadType

// get_real_gamepad_type_for_id gets the type of a gamepad, ignoring any mapping override.
//
// This can be called before any gamepads are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the gamepad type.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_type_for_id (SDL_GetGamepadTypeForID)
// See also: get_gamepads (SDL_GetGamepads)
// See also: get_real_gamepad_type (SDL_GetRealGamepadType)
pub fn get_real_gamepad_type_for_id(instance_id JoystickID) GamepadType {
	return C.SDL_GetRealGamepadTypeForID(instance_id)
}

// C.SDL_GetGamepadMappingForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadMappingForID)
fn C.SDL_GetGamepadMappingForID(instance_id JoystickID) &char

// get_gamepad_mapping_for_id gets the mapping of a gamepad.
//
// This can be called before any gamepads are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the mapping string. Returns NULL if no mapping is available. This
//          should be freed with SDL_free() when it is no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepads (SDL_GetGamepads)
// See also: get_gamepad_mapping (SDL_GetGamepadMapping)
pub fn get_gamepad_mapping_for_id(instance_id JoystickID) &char {
	return C.SDL_GetGamepadMappingForID(instance_id)
}

// C.SDL_OpenGamepad [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenGamepad)
fn C.SDL_OpenGamepad(instance_id JoystickID) &Gamepad

// open_gamepad opens a gamepad for use.
//
// `instance_id` instance_id the joystick instance ID.
// returns a gamepad identifier or NULL if an error occurred; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_gamepad (SDL_CloseGamepad)
// See also: is_gamepad (SDL_IsGamepad)
pub fn open_gamepad(instance_id JoystickID) &Gamepad {
	return C.SDL_OpenGamepad(instance_id)
}

// C.SDL_GetGamepadFromID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadFromID)
fn C.SDL_GetGamepadFromID(instance_id JoystickID) &Gamepad

// get_gamepad_from_id gets the SDL_Gamepad associated with a joystick instance ID, if it has been
// opened.
//
// `instance_id` instance_id the joystick instance ID of the gamepad.
// returns an SDL_Gamepad on success or NULL on failure or if it hasn't been
//          opened yet; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_from_id(instance_id JoystickID) &Gamepad {
	return C.SDL_GetGamepadFromID(instance_id)
}

// C.SDL_GetGamepadFromPlayerIndex [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadFromPlayerIndex)
fn C.SDL_GetGamepadFromPlayerIndex(player_index int) &Gamepad

// get_gamepad_from_player_index gets the SDL_Gamepad associated with a player index.
//
// `player_index` player_index the player index, which different from the instance ID.
// returns the SDL_Gamepad associated with a player index.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_player_index (SDL_GetGamepadPlayerIndex)
// See also: set_gamepad_player_index (SDL_SetGamepadPlayerIndex)
pub fn get_gamepad_from_player_index(player_index int) &Gamepad {
	return C.SDL_GetGamepadFromPlayerIndex(player_index)
}

// C.SDL_GetGamepadProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadProperties)
fn C.SDL_GetGamepadProperties(gamepad &Gamepad) PropertiesID

// get_gamepad_properties gets the properties associated with an opened gamepad.
//
// These properties are shared with the underlying joystick object.
//
// The following read-only properties are provided by SDL:
//
// - `SDL_PROP_GAMEPAD_CAP_MONO_LED_BOOLEAN`: true if this gamepad has an LED
//   that has adjustable brightness
// - `SDL_PROP_GAMEPAD_CAP_RGB_LED_BOOLEAN`: true if this gamepad has an LED
//   that has adjustable color
// - `SDL_PROP_GAMEPAD_CAP_PLAYER_LED_BOOLEAN`: true if this gamepad has a
//   player LED
// - `SDL_PROP_GAMEPAD_CAP_RUMBLE_BOOLEAN`: true if this gamepad has
//   left/right rumble
// - `SDL_PROP_GAMEPAD_CAP_TRIGGER_RUMBLE_BOOLEAN`: true if this gamepad has
//   simple trigger rumble
//
// `gamepad` gamepad a gamepad identifier previously returned by
//                SDL_OpenGamepad().
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_properties(gamepad &Gamepad) PropertiesID {
	return C.SDL_GetGamepadProperties(gamepad)
}

pub const prop_gamepad_cap_mono_led_boolean = C.SDL_PROP_GAMEPAD_CAP_MONO_LED_BOOLEAN // SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN

pub const prop_gamepad_cap_rgb_led_boolean = C.SDL_PROP_GAMEPAD_CAP_RGB_LED_BOOLEAN // SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN

pub const prop_gamepad_cap_player_led_boolean = C.SDL_PROP_GAMEPAD_CAP_PLAYER_LED_BOOLEAN // SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN

pub const prop_gamepad_cap_rumble_boolean = C.SDL_PROP_GAMEPAD_CAP_RUMBLE_BOOLEAN // SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN

pub const prop_gamepad_cap_trigger_rumble_boolean = C.SDL_PROP_GAMEPAD_CAP_TRIGGER_RUMBLE_BOOLEAN // SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN

// C.SDL_GetGamepadID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadID)
fn C.SDL_GetGamepadID(gamepad &Gamepad) JoystickID

// get_gamepad_id gets the instance ID of an opened gamepad.
//
// `gamepad` gamepad a gamepad identifier previously returned by
//                SDL_OpenGamepad().
// returns the instance ID of the specified gamepad on success or 0 on
//          failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_id(gamepad &Gamepad) JoystickID {
	return C.SDL_GetGamepadID(gamepad)
}

// C.SDL_GetGamepadName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadName)
fn C.SDL_GetGamepadName(gamepad &Gamepad) &char

// get_gamepad_name gets the implementation-dependent name for an opened gamepad.
//
// `gamepad` gamepad a gamepad identifier previously returned by
//                SDL_OpenGamepad().
// returns the implementation dependent name for the gamepad, or NULL if
//          there is no name or the identifier passed is invalid.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_name_for_id (SDL_GetGamepadNameForID)
pub fn get_gamepad_name(gamepad &Gamepad) &char {
	return C.SDL_GetGamepadName(gamepad)
}

// C.SDL_GetGamepadPath [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadPath)
fn C.SDL_GetGamepadPath(gamepad &Gamepad) &char

// get_gamepad_path gets the implementation-dependent path for an opened gamepad.
//
// `gamepad` gamepad a gamepad identifier previously returned by
//                SDL_OpenGamepad().
// returns the implementation dependent path for the gamepad, or NULL if
//          there is no path or the identifier passed is invalid.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_path_for_id (SDL_GetGamepadPathForID)
pub fn get_gamepad_path(gamepad &Gamepad) &char {
	return C.SDL_GetGamepadPath(gamepad)
}

// C.SDL_GetGamepadType [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadType)
fn C.SDL_GetGamepadType(gamepad &Gamepad) GamepadType

// get_gamepad_type gets the type of an opened gamepad.
//
// `gamepad` gamepad the gamepad object to query.
// returns the gamepad type, or SDL_GAMEPAD_TYPE_UNKNOWN if it's not
//          available.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_type_for_id (SDL_GetGamepadTypeForID)
pub fn get_gamepad_type(gamepad &Gamepad) GamepadType {
	return C.SDL_GetGamepadType(gamepad)
}

// C.SDL_GetRealGamepadType [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRealGamepadType)
fn C.SDL_GetRealGamepadType(gamepad &Gamepad) GamepadType

// get_real_gamepad_type gets the type of an opened gamepad, ignoring any mapping override.
//
// `gamepad` gamepad the gamepad object to query.
// returns the gamepad type, or SDL_GAMEPAD_TYPE_UNKNOWN if it's not
//          available.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_real_gamepad_type_for_id (SDL_GetRealGamepadTypeForID)
pub fn get_real_gamepad_type(gamepad &Gamepad) GamepadType {
	return C.SDL_GetRealGamepadType(gamepad)
}

// C.SDL_GetGamepadPlayerIndex [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadPlayerIndex)
fn C.SDL_GetGamepadPlayerIndex(gamepad &Gamepad) int

// get_gamepad_player_index gets the player index of an opened gamepad.
//
// For XInput gamepads this returns the XInput user index.
//
// `gamepad` gamepad the gamepad object to query.
// returns the player index for gamepad, or -1 if it's not available.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_gamepad_player_index (SDL_SetGamepadPlayerIndex)
pub fn get_gamepad_player_index(gamepad &Gamepad) int {
	return C.SDL_GetGamepadPlayerIndex(gamepad)
}

// C.SDL_SetGamepadPlayerIndex [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGamepadPlayerIndex)
fn C.SDL_SetGamepadPlayerIndex(gamepad &Gamepad, player_index int) bool

// set_gamepad_player_index sets the player index of an opened gamepad.
//
// `gamepad` gamepad the gamepad object to adjust.
// `player_index` player_index player index to assign to this gamepad, or -1 to clear
//                     the player index and turn off player LEDs.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_player_index (SDL_GetGamepadPlayerIndex)
pub fn set_gamepad_player_index(gamepad &Gamepad, player_index int) bool {
	return C.SDL_SetGamepadPlayerIndex(gamepad, player_index)
}

// C.SDL_GetGamepadVendor [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadVendor)
fn C.SDL_GetGamepadVendor(gamepad &Gamepad) u16

// get_gamepad_vendor gets the USB vendor ID of an opened gamepad, if available.
//
// If the vendor ID isn't available this function returns 0.
//
// `gamepad` gamepad the gamepad object to query.
// returns the USB vendor ID, or zero if unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_vendor_for_id (SDL_GetGamepadVendorForID)
pub fn get_gamepad_vendor(gamepad &Gamepad) u16 {
	return C.SDL_GetGamepadVendor(gamepad)
}

// C.SDL_GetGamepadProduct [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadProduct)
fn C.SDL_GetGamepadProduct(gamepad &Gamepad) u16

// get_gamepad_product gets the USB product ID of an opened gamepad, if available.
//
// If the product ID isn't available this function returns 0.
//
// `gamepad` gamepad the gamepad object to query.
// returns the USB product ID, or zero if unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_product_for_id (SDL_GetGamepadProductForID)
pub fn get_gamepad_product(gamepad &Gamepad) u16 {
	return C.SDL_GetGamepadProduct(gamepad)
}

// C.SDL_GetGamepadProductVersion [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadProductVersion)
fn C.SDL_GetGamepadProductVersion(gamepad &Gamepad) u16

// get_gamepad_product_version gets the product version of an opened gamepad, if available.
//
// If the product version isn't available this function returns 0.
//
// `gamepad` gamepad the gamepad object to query.
// returns the USB product version, or zero if unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_product_version_for_id (SDL_GetGamepadProductVersionForID)
pub fn get_gamepad_product_version(gamepad &Gamepad) u16 {
	return C.SDL_GetGamepadProductVersion(gamepad)
}

// C.SDL_GetGamepadFirmwareVersion [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadFirmwareVersion)
fn C.SDL_GetGamepadFirmwareVersion(gamepad &Gamepad) u16

// get_gamepad_firmware_version gets the firmware version of an opened gamepad, if available.
//
// If the firmware version isn't available this function returns 0.
//
// `gamepad` gamepad the gamepad object to query.
// returns the gamepad firmware version, or zero if unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_firmware_version(gamepad &Gamepad) u16 {
	return C.SDL_GetGamepadFirmwareVersion(gamepad)
}

// C.SDL_GetGamepadSerial [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadSerial)
fn C.SDL_GetGamepadSerial(gamepad &Gamepad) &char

// get_gamepad_serial gets the serial number of an opened gamepad, if available.
//
// Returns the serial number of the gamepad, or NULL if it is not available.
//
// `gamepad` gamepad the gamepad object to query.
// returns the serial number, or NULL if unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_serial(gamepad &Gamepad) &char {
	return C.SDL_GetGamepadSerial(gamepad)
}

// C.SDL_GetGamepadSteamHandle [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadSteamHandle)
fn C.SDL_GetGamepadSteamHandle(gamepad &Gamepad) u64

// get_gamepad_steam_handle gets the Steam Input handle of an opened gamepad, if available.
//
// Returns an InputHandle_t for the gamepad that can be used with Steam Input
// API: https://partner.steamgames.com/doc/api/ISteamInput
//
// `gamepad` gamepad the gamepad object to query.
// returns the gamepad handle, or 0 if unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_steam_handle(gamepad &Gamepad) u64 {
	return C.SDL_GetGamepadSteamHandle(gamepad)
}

// C.SDL_GetGamepadConnectionState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadConnectionState)
fn C.SDL_GetGamepadConnectionState(gamepad &Gamepad) JoystickConnectionState

// get_gamepad_connection_state gets the connection state of a gamepad.
//
// `gamepad` gamepad the gamepad object to query.
// returns the connection state on success or
//          `SDL_JOYSTICK_CONNECTION_INVALID` on failure; call SDL_GetError()
//          for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_connection_state(gamepad &Gamepad) JoystickConnectionState {
	return C.SDL_GetGamepadConnectionState(gamepad)
}

// C.SDL_GetGamepadPowerInfo [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadPowerInfo)
fn C.SDL_GetGamepadPowerInfo(gamepad &Gamepad, percent &int) PowerState

// get_gamepad_power_info gets the battery state of a gamepad.
//
// You should never take a battery status as absolute truth. Batteries
// (especially failing batteries) are delicate hardware, and the values
// reported here are best estimates based on what that hardware reports. It's
// not uncommon for older batteries to lose stored power much faster than it
// reports, or completely drain when reporting it has 20 percent left, etc.
//
// `gamepad` gamepad the gamepad object to query.
// `percent` percent a pointer filled in with the percentage of battery life
//                left, between 0 and 100, or NULL to ignore. This will be
//                filled in with -1 we can't determine a value or there is no
//                battery.
// returns the current battery state.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_power_info(gamepad &Gamepad, percent &int) PowerState {
	return C.SDL_GetGamepadPowerInfo(gamepad, percent)
}

// C.SDL_GamepadConnected [official documentation](https://wiki.libsdl.org/SDL3/SDL_GamepadConnected)
fn C.SDL_GamepadConnected(gamepad &Gamepad) bool

// gamepad_connected checks if a gamepad has been opened and is currently connected.
//
// `gamepad` gamepad a gamepad identifier previously returned by
//                SDL_OpenGamepad().
// returns true if the gamepad has been opened and is currently connected, or
//          false if not.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn gamepad_connected(gamepad &Gamepad) bool {
	return C.SDL_GamepadConnected(gamepad)
}

// C.SDL_GetGamepadJoystick [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadJoystick)
fn C.SDL_GetGamepadJoystick(gamepad &Gamepad) &Joystick

// get_gamepad_joystick gets the underlying joystick from a gamepad.
//
// This function will give you a SDL_Joystick object, which allows you to use
// the SDL_Joystick functions with a SDL_Gamepad object. This would be useful
// for getting a joystick's position at any given time, even if it hasn't
// moved (moving it would produce an event, which would have the axis' value).
//
// The pointer returned is owned by the SDL_Gamepad. You should not call
// SDL_CloseJoystick() on it, for example, since doing so will likely cause
// SDL to crash.
//
// `gamepad` gamepad the gamepad object that you want to get a joystick from.
// returns an SDL_Joystick object, or NULL on failure; call SDL_GetError()
//          for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_joystick(gamepad &Gamepad) &Joystick {
	return C.SDL_GetGamepadJoystick(gamepad)
}

// C.SDL_SetGamepadEventsEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGamepadEventsEnabled)
fn C.SDL_SetGamepadEventsEnabled(enabled bool)

// set_gamepad_events_enabled sets the state of gamepad event processing.
//
// If gamepad events are disabled, you must call SDL_UpdateGamepads() yourself
// and check the state of the gamepad when you want gamepad information.
//
// `enabled` enabled whether to process gamepad events or not.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gamepad_events_enabled (SDL_GamepadEventsEnabled)
// See also: update_gamepads (SDL_UpdateGamepads)
pub fn set_gamepad_events_enabled(enabled bool) {
	C.SDL_SetGamepadEventsEnabled(enabled)
}

// C.SDL_GamepadEventsEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_GamepadEventsEnabled)
fn C.SDL_GamepadEventsEnabled() bool

// gamepad_events_enabled querys the state of gamepad event processing.
//
// If gamepad events are disabled, you must call SDL_UpdateGamepads() yourself
// and check the state of the gamepad when you want gamepad information.
//
// returns true if gamepad events are being processed, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_gamepad_events_enabled (SDL_SetGamepadEventsEnabled)
pub fn gamepad_events_enabled() bool {
	return C.SDL_GamepadEventsEnabled()
}

// C.SDL_GetGamepadBindings [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadBindings)
fn C.SDL_GetGamepadBindings(gamepad &Gamepad, count &int) &&C.SDL_GamepadBinding

// get_gamepad_bindings gets the SDL joystick layer bindings for a gamepad.
//
// `gamepad` gamepad a gamepad.
// `count` count a pointer filled in with the number of bindings returned.
// returns a NULL terminated array of pointers to bindings or NULL on
//          failure; call SDL_GetError() for more information. This is a
//          single allocation that should be freed with SDL_free() when it is
//          no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_bindings(gamepad &Gamepad, count &int) &&C.SDL_GamepadBinding {
	return C.SDL_GetGamepadBindings(gamepad, count)
}

// C.SDL_UpdateGamepads [official documentation](https://wiki.libsdl.org/SDL3/SDL_UpdateGamepads)
fn C.SDL_UpdateGamepads()

// update_gamepads manuallys pump gamepad updates if not using the loop.
//
// This function is called automatically by the event loop if events are
// enabled. Under such circumstances, it will not be necessary to call this
// function.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn update_gamepads() {
	C.SDL_UpdateGamepads()
}

// C.SDL_GetGamepadTypeFromString [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadTypeFromString)
fn C.SDL_GetGamepadTypeFromString(const_str &char) GamepadType

// get_gamepad_type_from_string converts a string into SDL_GamepadType enum.
//
// This function is called internally to translate SDL_Gamepad mapping strings
// for the underlying joystick device into the consistent SDL_Gamepad mapping.
// You do not normally need to call this function unless you are parsing
// SDL_Gamepad mappings in your own code.
//
// `str` str string representing a SDL_GamepadType type.
// returns the SDL_GamepadType enum corresponding to the input string, or
//          `SDL_GAMEPAD_TYPE_UNKNOWN` if no match was found.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_string_for_type (SDL_GetGamepadStringForType)
pub fn get_gamepad_type_from_string(const_str &char) GamepadType {
	return C.SDL_GetGamepadTypeFromString(const_str)
}

// C.SDL_GetGamepadStringForType [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadStringForType)
fn C.SDL_GetGamepadStringForType(typ GamepadType) &char

// get_gamepad_string_for_type converts from an SDL_GamepadType enum to a string.
//
// `type` type an enum value for a given SDL_GamepadType.
// returns a string for the given type, or NULL if an invalid type is
//          specified. The string returned is of the format used by
//          SDL_Gamepad mapping strings.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_type_from_string (SDL_GetGamepadTypeFromString)
pub fn get_gamepad_string_for_type(typ GamepadType) &char {
	return C.SDL_GetGamepadStringForType(typ)
}

// C.SDL_GetGamepadAxisFromString [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadAxisFromString)
fn C.SDL_GetGamepadAxisFromString(const_str &char) GamepadAxis

// get_gamepad_axis_from_string converts a string into SDL_GamepadAxis enum.
//
// This function is called internally to translate SDL_Gamepad mapping strings
// for the underlying joystick device into the consistent SDL_Gamepad mapping.
// You do not normally need to call this function unless you are parsing
// SDL_Gamepad mappings in your own code.
//
// Note specially that "righttrigger" and "lefttrigger" map to
// `SDL_GAMEPAD_AXIS_RIGHT_TRIGGER` and `SDL_GAMEPAD_AXIS_LEFT_TRIGGER`,
// respectively.
//
// `str` str string representing a SDL_Gamepad axis.
// returns the SDL_GamepadAxis enum corresponding to the input string, or
//          `SDL_GAMEPAD_AXIS_INVALID` if no match was found.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_string_for_axis (SDL_GetGamepadStringForAxis)
pub fn get_gamepad_axis_from_string(const_str &char) GamepadAxis {
	return C.SDL_GetGamepadAxisFromString(const_str)
}

// C.SDL_GetGamepadStringForAxis [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadStringForAxis)
fn C.SDL_GetGamepadStringForAxis(axis GamepadAxis) &char

// get_gamepad_string_for_axis converts from an SDL_GamepadAxis enum to a string.
//
// `axis` axis an enum value for a given SDL_GamepadAxis.
// returns a string for the given axis, or NULL if an invalid axis is
//          specified. The string returned is of the format used by
//          SDL_Gamepad mapping strings.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_axis_from_string (SDL_GetGamepadAxisFromString)
pub fn get_gamepad_string_for_axis(axis GamepadAxis) &char {
	return C.SDL_GetGamepadStringForAxis(axis)
}

// C.SDL_GamepadHasAxis [official documentation](https://wiki.libsdl.org/SDL3/SDL_GamepadHasAxis)
fn C.SDL_GamepadHasAxis(gamepad &Gamepad, axis GamepadAxis) bool

// gamepad_has_axis querys whether a gamepad has a given axis.
//
// This merely reports whether the gamepad's mapping defined this axis, as
// that is all the information SDL has about the physical device.
//
// `gamepad` gamepad a gamepad.
// `axis` axis an axis enum value (an SDL_GamepadAxis value).
// returns true if the gamepad has this axis, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gamepad_has_button (SDL_GamepadHasButton)
// See also: get_gamepad_axis (SDL_GetGamepadAxis)
pub fn gamepad_has_axis(gamepad &Gamepad, axis GamepadAxis) bool {
	return C.SDL_GamepadHasAxis(gamepad, axis)
}

// C.SDL_GetGamepadAxis [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadAxis)
fn C.SDL_GetGamepadAxis(gamepad &Gamepad, axis GamepadAxis) i16

// get_gamepad_axis gets the current state of an axis control on a gamepad.
//
// The axis indices start at index 0.
//
// For thumbsticks, the state is a value ranging from -32768 (up/left) to
// 32767 (down/right).
//
// Triggers range from 0 when released to 32767 when fully pressed, and never
// return a negative value. Note that this differs from the value reported by
// the lower-level SDL_GetJoystickAxis(), which normally uses the full range.
//
// `gamepad` gamepad a gamepad.
// `axis` axis an axis index (one of the SDL_GamepadAxis values).
// returns axis state (including 0) on success or 0 (also) on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gamepad_has_axis (SDL_GamepadHasAxis)
// See also: get_gamepad_button (SDL_GetGamepadButton)
pub fn get_gamepad_axis(gamepad &Gamepad, axis GamepadAxis) i16 {
	return C.SDL_GetGamepadAxis(gamepad, axis)
}

// C.SDL_GetGamepadButtonFromString [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadButtonFromString)
fn C.SDL_GetGamepadButtonFromString(const_str &char) GamepadButton

// get_gamepad_button_from_string converts a string into an SDL_GamepadButton enum.
//
// This function is called internally to translate SDL_Gamepad mapping strings
// for the underlying joystick device into the consistent SDL_Gamepad mapping.
// You do not normally need to call this function unless you are parsing
// SDL_Gamepad mappings in your own code.
//
// `str` str string representing a SDL_Gamepad axis.
// returns the SDL_GamepadButton enum corresponding to the input string, or
//          `SDL_GAMEPAD_BUTTON_INVALID` if no match was found.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_string_for_button (SDL_GetGamepadStringForButton)
pub fn get_gamepad_button_from_string(const_str &char) GamepadButton {
	return C.SDL_GetGamepadButtonFromString(const_str)
}

// C.SDL_GetGamepadStringForButton [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadStringForButton)
fn C.SDL_GetGamepadStringForButton(button GamepadButton) &char

// get_gamepad_string_for_button converts from an SDL_GamepadButton enum to a string.
//
// `button` button an enum value for a given SDL_GamepadButton.
// returns a string for the given button, or NULL if an invalid button is
//          specified. The string returned is of the format used by
//          SDL_Gamepad mapping strings.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_button_from_string (SDL_GetGamepadButtonFromString)
pub fn get_gamepad_string_for_button(button GamepadButton) &char {
	return C.SDL_GetGamepadStringForButton(button)
}

// C.SDL_GamepadHasButton [official documentation](https://wiki.libsdl.org/SDL3/SDL_GamepadHasButton)
fn C.SDL_GamepadHasButton(gamepad &Gamepad, button GamepadButton) bool

// gamepad_has_button querys whether a gamepad has a given button.
//
// This merely reports whether the gamepad's mapping defined this button, as
// that is all the information SDL has about the physical device.
//
// `gamepad` gamepad a gamepad.
// `button` button a button enum value (an SDL_GamepadButton value).
// returns true if the gamepad has this button, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gamepad_has_axis (SDL_GamepadHasAxis)
pub fn gamepad_has_button(gamepad &Gamepad, button GamepadButton) bool {
	return C.SDL_GamepadHasButton(gamepad, button)
}

// C.SDL_GetGamepadButton [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadButton)
fn C.SDL_GetGamepadButton(gamepad &Gamepad, button GamepadButton) bool

// get_gamepad_button gets the current state of a button on a gamepad.
//
// `gamepad` gamepad a gamepad.
// `button` button a button index (one of the SDL_GamepadButton values).
// returns true if the button is pressed, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gamepad_has_button (SDL_GamepadHasButton)
// See also: get_gamepad_axis (SDL_GetGamepadAxis)
pub fn get_gamepad_button(gamepad &Gamepad, button GamepadButton) bool {
	return C.SDL_GetGamepadButton(gamepad, button)
}

// C.SDL_GetGamepadButtonLabelForType [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadButtonLabelForType)
fn C.SDL_GetGamepadButtonLabelForType(typ GamepadType, button GamepadButton) GamepadButtonLabel

// get_gamepad_button_label_for_type gets the label of a button on a gamepad.
//
// `type` type the type of gamepad to check.
// `button` button a button index (one of the SDL_GamepadButton values).
// returns the SDL_GamepadButtonLabel enum corresponding to the button label.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_button_label (SDL_GetGamepadButtonLabel)
pub fn get_gamepad_button_label_for_type(typ GamepadType, button GamepadButton) GamepadButtonLabel {
	return C.SDL_GetGamepadButtonLabelForType(typ, button)
}

// C.SDL_GetGamepadButtonLabel [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadButtonLabel)
fn C.SDL_GetGamepadButtonLabel(gamepad &Gamepad, button GamepadButton) GamepadButtonLabel

// get_gamepad_button_label gets the label of a button on a gamepad.
//
// `gamepad` gamepad a gamepad.
// `button` button a button index (one of the SDL_GamepadButton values).
// returns the SDL_GamepadButtonLabel enum corresponding to the button label.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_button_label_for_type (SDL_GetGamepadButtonLabelForType)
pub fn get_gamepad_button_label(gamepad &Gamepad, button GamepadButton) GamepadButtonLabel {
	return C.SDL_GetGamepadButtonLabel(gamepad, button)
}

// C.SDL_GetNumGamepadTouchpads [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumGamepadTouchpads)
fn C.SDL_GetNumGamepadTouchpads(gamepad &Gamepad) int

// get_num_gamepad_touchpads gets the number of touchpads on a gamepad.
//
// `gamepad` gamepad a gamepad.
// returns number of touchpads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_gamepad_touchpad_fingers (SDL_GetNumGamepadTouchpadFingers)
pub fn get_num_gamepad_touchpads(gamepad &Gamepad) int {
	return C.SDL_GetNumGamepadTouchpads(gamepad)
}

// C.SDL_GetNumGamepadTouchpadFingers [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumGamepadTouchpadFingers)
fn C.SDL_GetNumGamepadTouchpadFingers(gamepad &Gamepad, touchpad int) int

// get_num_gamepad_touchpad_fingers gets the number of supported simultaneous fingers on a touchpad on a game
// gamepad.
//
// `gamepad` gamepad a gamepad.
// `touchpad` touchpad a touchpad.
// returns number of supported simultaneous fingers.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_touchpad_finger (SDL_GetGamepadTouchpadFinger)
// See also: get_num_gamepad_touchpads (SDL_GetNumGamepadTouchpads)
pub fn get_num_gamepad_touchpad_fingers(gamepad &Gamepad, touchpad int) int {
	return C.SDL_GetNumGamepadTouchpadFingers(gamepad, touchpad)
}

// C.SDL_GetGamepadTouchpadFinger [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadTouchpadFinger)
fn C.SDL_GetGamepadTouchpadFinger(gamepad &Gamepad, touchpad int, finger int, down &bool, x &f32, y &f32, pressure &f32) bool

// get_gamepad_touchpad_finger gets the current state of a finger on a touchpad on a gamepad.
//
// `gamepad` gamepad a gamepad.
// `touchpad` touchpad a touchpad.
// `finger` finger a finger.
// `down` down a pointer filled with true if the finger is down, false
//             otherwise, may be NULL.
// `x` x a pointer filled with the x position, normalized 0 to 1, with the
//          origin in the upper left, may be NULL.
// `y` y a pointer filled with the y position, normalized 0 to 1, with the
//          origin in the upper left, may be NULL.
// `pressure` pressure a pointer filled with pressure value, may be NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_gamepad_touchpad_fingers (SDL_GetNumGamepadTouchpadFingers)
pub fn get_gamepad_touchpad_finger(gamepad &Gamepad, touchpad int, finger int, down &bool, x &f32, y &f32, pressure &f32) bool {
	return C.SDL_GetGamepadTouchpadFinger(gamepad, touchpad, finger, down, x, y, pressure)
}

// C.SDL_GamepadHasSensor [official documentation](https://wiki.libsdl.org/SDL3/SDL_GamepadHasSensor)
fn C.SDL_GamepadHasSensor(gamepad &Gamepad, typ SensorType) bool

// gamepad_has_sensor returns whether a gamepad has a particular sensor.
//
// `gamepad` gamepad the gamepad to query.
// `type` type the type of sensor to query.
// returns true if the sensor exists, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_sensor_data (SDL_GetGamepadSensorData)
// See also: get_gamepad_sensor_data_rate (SDL_GetGamepadSensorDataRate)
// See also: set_gamepad_sensor_enabled (SDL_SetGamepadSensorEnabled)
pub fn gamepad_has_sensor(gamepad &Gamepad, typ SensorType) bool {
	return C.SDL_GamepadHasSensor(gamepad, typ)
}

// C.SDL_SetGamepadSensorEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGamepadSensorEnabled)
fn C.SDL_SetGamepadSensorEnabled(gamepad &Gamepad, typ SensorType, enabled bool) bool

// set_gamepad_sensor_enabled sets whether data reporting for a gamepad sensor is enabled.
//
// `gamepad` gamepad the gamepad to update.
// `type` type the type of sensor to enable/disable.
// `enabled` enabled whether data reporting should be enabled.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gamepad_has_sensor (SDL_GamepadHasSensor)
// See also: gamepad_sensor_enabled (SDL_GamepadSensorEnabled)
pub fn set_gamepad_sensor_enabled(gamepad &Gamepad, typ SensorType, enabled bool) bool {
	return C.SDL_SetGamepadSensorEnabled(gamepad, typ, enabled)
}

// C.SDL_GamepadSensorEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_GamepadSensorEnabled)
fn C.SDL_GamepadSensorEnabled(gamepad &Gamepad, typ SensorType) bool

// gamepad_sensor_enabled querys whether sensor data reporting is enabled for a gamepad.
//
// `gamepad` gamepad the gamepad to query.
// `type` type the type of sensor to query.
// returns true if the sensor is enabled, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_gamepad_sensor_enabled (SDL_SetGamepadSensorEnabled)
pub fn gamepad_sensor_enabled(gamepad &Gamepad, typ SensorType) bool {
	return C.SDL_GamepadSensorEnabled(gamepad, typ)
}

// C.SDL_GetGamepadSensorDataRate [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadSensorDataRate)
fn C.SDL_GetGamepadSensorDataRate(gamepad &Gamepad, typ SensorType) f32

// get_gamepad_sensor_data_rate gets the data rate (number of events per second) of a gamepad sensor.
//
// `gamepad` gamepad the gamepad to query.
// `type` type the type of sensor to query.
// returns the data rate, or 0.0f if the data rate is not available.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_sensor_data_rate(gamepad &Gamepad, typ SensorType) f32 {
	return C.SDL_GetGamepadSensorDataRate(gamepad, typ)
}

// C.SDL_GetGamepadSensorData [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadSensorData)
fn C.SDL_GetGamepadSensorData(gamepad &Gamepad, typ SensorType, data &f32, num_values int) bool

// get_gamepad_sensor_data gets the current state of a gamepad sensor.
//
// The number of values and interpretation of the data is sensor dependent.
// See SDL_sensor.h for the details for each type of sensor.
//
// `gamepad` gamepad the gamepad to query.
// `type` type the type of sensor to query.
// `data` data a pointer filled with the current sensor state.
// `num_values` num_values the number of values to write to data.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_gamepad_sensor_data(gamepad &Gamepad, typ SensorType, data &f32, num_values int) bool {
	return C.SDL_GetGamepadSensorData(gamepad, typ, data, num_values)
}

// C.SDL_RumbleGamepad [official documentation](https://wiki.libsdl.org/SDL3/SDL_RumbleGamepad)
fn C.SDL_RumbleGamepad(gamepad &Gamepad, low_frequency_rumble u16, high_frequency_rumble u16, duration_ms u32) bool

// rumble_gamepad starts a rumble effect on a gamepad.
//
// Each call to this function cancels any previous rumble effect, and calling
// it with 0 intensity stops any rumbling.
//
// This function requires you to process SDL events or call
// SDL_UpdateJoysticks() to update rumble state.
//
// `gamepad` gamepad the gamepad to vibrate.
// `low_frequency_rumble` low_frequency_rumble the intensity of the low frequency (left)
//                             rumble motor, from 0 to 0xFFFF.
// `high_frequency_rumble` high_frequency_rumble the intensity of the high frequency (right)
//                              rumble motor, from 0 to 0xFFFF.
// `duration_ms` duration_ms the duration of the rumble effect, in milliseconds.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn rumble_gamepad(gamepad &Gamepad, low_frequency_rumble u16, high_frequency_rumble u16, duration_ms u32) bool {
	return C.SDL_RumbleGamepad(gamepad, low_frequency_rumble, high_frequency_rumble, duration_ms)
}

// C.SDL_RumbleGamepadTriggers [official documentation](https://wiki.libsdl.org/SDL3/SDL_RumbleGamepadTriggers)
fn C.SDL_RumbleGamepadTriggers(gamepad &Gamepad, left_rumble u16, right_rumble u16, duration_ms u32) bool

// rumble_gamepad_triggers starts a rumble effect in the gamepad's triggers.
//
// Each call to this function cancels any previous trigger rumble effect, and
// calling it with 0 intensity stops any rumbling.
//
// Note that this is rumbling of the _triggers_ and not the gamepad as a
// whole. This is currently only supported on Xbox One gamepads. If you want
// the (more common) whole-gamepad rumble, use SDL_RumbleGamepad() instead.
//
// This function requires you to process SDL events or call
// SDL_UpdateJoysticks() to update rumble state.
//
// `gamepad` gamepad the gamepad to vibrate.
// `left_rumble` left_rumble the intensity of the left trigger rumble motor, from 0
//                    to 0xFFFF.
// `right_rumble` right_rumble the intensity of the right trigger rumble motor, from 0
//                     to 0xFFFF.
// `duration_ms` duration_ms the duration of the rumble effect, in milliseconds.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: rumble_gamepad (SDL_RumbleGamepad)
pub fn rumble_gamepad_triggers(gamepad &Gamepad, left_rumble u16, right_rumble u16, duration_ms u32) bool {
	return C.SDL_RumbleGamepadTriggers(gamepad, left_rumble, right_rumble, duration_ms)
}

// C.SDL_SetGamepadLED [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetGamepadLED)
fn C.SDL_SetGamepadLED(gamepad &Gamepad, red u8, green u8, blue u8) bool

// set_gamepad_led updates a gamepad's LED color.
//
// An example of a joystick LED is the light on the back of a PlayStation 4's
// DualShock 4 controller.
//
// For gamepads with a single color LED, the maximum of the RGB values will be
// used as the LED brightness.
//
// `gamepad` gamepad the gamepad to update.
// `red` red the intensity of the red LED.
// `green` green the intensity of the green LED.
// `blue` blue the intensity of the blue LED.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_gamepad_led(gamepad &Gamepad, red u8, green u8, blue u8) bool {
	return C.SDL_SetGamepadLED(gamepad, red, green, blue)
}

// C.SDL_SendGamepadEffect [official documentation](https://wiki.libsdl.org/SDL3/SDL_SendGamepadEffect)
fn C.SDL_SendGamepadEffect(gamepad &Gamepad, const_data voidptr, size int) bool

// send_gamepad_effect sends a gamepad specific effect packet.
//
// `gamepad` gamepad the gamepad to affect.
// `data` data the data to send to the gamepad.
// `size` size the size of the data to send to the gamepad.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn send_gamepad_effect(gamepad &Gamepad, const_data voidptr, size int) bool {
	return C.SDL_SendGamepadEffect(gamepad, const_data, size)
}

// C.SDL_CloseGamepad [official documentation](https://wiki.libsdl.org/SDL3/SDL_CloseGamepad)
fn C.SDL_CloseGamepad(gamepad &Gamepad)

// close_gamepad closes a gamepad previously opened with SDL_OpenGamepad().
//
// `gamepad` gamepad a gamepad identifier previously returned by
//                SDL_OpenGamepad().
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_gamepad (SDL_OpenGamepad)
pub fn close_gamepad(gamepad &Gamepad) {
	C.SDL_CloseGamepad(gamepad)
}

// C.SDL_GetGamepadAppleSFSymbolsNameForButton [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadAppleSFSymbolsNameForButton)
fn C.SDL_GetGamepadAppleSFSymbolsNameForButton(gamepad &Gamepad, button GamepadButton) &char

// get_gamepad_apple_sf_symbols_name_for_button returns the sfSymbolsName for a given button on a gamepad on Apple
// platforms.
//
// `gamepad` gamepad the gamepad to query.
// `button` button a button on the gamepad.
// returns the sfSymbolsName or NULL if the name can't be found.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_apple_sf_symbols_name_for_axis (SDL_GetGamepadAppleSFSymbolsNameForAxis)
pub fn get_gamepad_apple_sf_symbols_name_for_button(gamepad &Gamepad, button GamepadButton) &char {
	return C.SDL_GetGamepadAppleSFSymbolsNameForButton(gamepad, button)
}

// C.SDL_GetGamepadAppleSFSymbolsNameForAxis [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGamepadAppleSFSymbolsNameForAxis)
fn C.SDL_GetGamepadAppleSFSymbolsNameForAxis(gamepad &Gamepad, axis GamepadAxis) &char

// get_gamepad_apple_sf_symbols_name_for_axis returns the sfSymbolsName for a given axis on a gamepad on Apple platforms.
//
// `gamepad` gamepad the gamepad to query.
// `axis` axis an axis on the gamepad.
// returns the sfSymbolsName or NULL if the name can't be found.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_gamepad_apple_sf_symbols_name_for_button (SDL_GetGamepadAppleSFSymbolsNameForButton)
pub fn get_gamepad_apple_sf_symbols_name_for_axis(gamepad &Gamepad, axis GamepadAxis) &char {
	return C.SDL_GetGamepadAppleSFSymbolsNameForAxis(gamepad, axis)
}
