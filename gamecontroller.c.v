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

// GameControllerType is C.SDL_GameControllerType
pub enum GameControllerType {
	unknown = C.SDL_CONTROLLER_TYPE_UNKNOWN // 0
	xbox360 = C.SDL_CONTROLLER_TYPE_XBOX360
	xboxone = C.SDL_CONTROLLER_TYPE_XBOXONE
	ps3 = C.SDL_CONTROLLER_TYPE_PS3
	ps4 = C.SDL_CONTROLLER_TYPE_PS4
	nintendo_switch_pro = C.SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_PRO
	virtual = C.SDL_CONTROLLER_TYPE_VIRTUAL
	ps5 = C.SDL_CONTROLLER_TYPE_PS5
	amazon_luna = C.SDL_CONTROLLER_TYPE_AMAZON_LUNA
	google_stadia = C.SDL_CONTROLLER_TYPE_GOOGLE_STADIA
}

// GameControllerBindType is C.SDL_GameControllerBindType
pub enum GameControllerBindType {
	@none = C.SDL_CONTROLLER_BINDTYPE_NONE // 0
	button = C.SDL_CONTROLLER_BINDTYPE_BUTTON
	axis = C.SDL_CONTROLLER_BINDTYPE_AXIS
	hat = C.SDL_CONTROLLER_BINDTYPE_HAT
}

pub union Value {
pub:
	button int
	axis   int
}

pub struct Hat {
pub:
	hat      int
	hat_mask int
}

[typedef]
struct C.SDL_GameControllerButtonBind {
pub:
	bindType GameControllerBindType // C.SDL_GameControllerBindType
	value    Value
	hat      Hat
}

pub type GameControllerButtonBind = C.SDL_GameControllerButtonBind

// To count the number of game controllers in the system for the following:
/*
```c
 int nJoysticks = SDL_NumJoysticks();
 int nGameControllers = 0;
 for (int i = 0; i < nJoysticks; i++) {
     if (SDL_IsGameController(i)) {
         nGameControllers++;
     }
 }
```
*/
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
/*
```c
 "03000000341a00003608000000000000,PS3 Controller,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,back:b8,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftshoulder:b4,rightshoulder:b5,leftstick:b10,rightstick:b11,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7",
```
*/
//

fn C.SDL_GameControllerAddMappingsFromRW(rw &C.SDL_RWops, freerw int) int

// game_controller_add_mappings_from_rw loads a set of Game Controller mappings from a seekable SDL data stream.
//
// You can call this function several times, if needed, to load different
// database files.
//
// If a new mapping is loaded for an already known controller GUID, the later
// version will overwrite the one currently loaded.
//
// Mappings not belonging to the current platform or with no platform field
// specified will be ignored (i.e. mappings for Linux will be ignored in
// Windows, etc).
//
// This function will load the text database entirely in memory before
// processing it, so take this into consideration if you are in a memory
// constrained environment.
//
// `rw` the data stream for the mappings to be added
// `freerw` non-zero to close the stream after being read
// returns the number of mappings added or -1 on error; call SDL_GetError()
//          for more information.
//
// NOTE This function is available since SDL 2.0.2.
//
// See also: SDL_GameControllerAddMapping
// See also: SDL_GameControllerAddMappingsFromFile
// See also: SDL_GameControllerMappingForGUID
pub fn game_controller_add_mappings_from_rw(rw &RWops, freerw int) int {
	return C.SDL_GameControllerAddMappingsFromRW(rw, freerw)
}

fn C.SDL_GameControllerAddMappingsFromFile(file &char) int

// game_controller_add_mappings_from_file loads a set of mappings from a file, filtered by the current SDL_GetPlatform()
//
// Convenience macro.
pub fn game_controller_add_mappings_from_file(file &char) int {
	return C.SDL_GameControllerAddMappingsFromFile(file)
}

fn C.SDL_GameControllerAddMapping(mapping_string &char) int

// game_controller_add_mapping adds support for controllers that SDL is unaware of or to cause an existing
// controller to have a different binding.
//
// The mapping string has the format "GUID,name,mapping", where GUID is the
// string value from SDL_JoystickGetGUIDString(), name is the human readable
// string for the device and mappings are controller mappings to joystick
// ones. Under Windows there is a reserved GUID of "xinput" that covers all
// XInput devices. The mapping format for joystick is: {| |bX |a joystick
// button, index X |- |hX.Y |hat X with value Y |- |aX |axis X of the joystick
// |} Buttons can be used as a controller axes and vice versa.
//
// This string shows an example of a valid mapping for a controller:
//
/*
```c
 "341a3608000000000000504944564944,Afterglow PS3 Controller,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,back:b8,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftshoulder:b4,rightshoulder:b5,leftstick:b10,rightstick:b11,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7"
```
*/
//
// `mappingString` the mapping string
// returns 1 if a new mapping is added, 0 if an existing mapping is updated,
//          -1 on error; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerMapping
// See also: SDL_GameControllerMappingForGUID
pub fn game_controller_add_mapping(mapping_string &char) int {
	return C.SDL_GameControllerAddMapping(mapping_string)
}

fn C.SDL_GameControllerNumMappings() int

// game_controller_num_mappings gets the number of mappings installed
//
// returns the number of mappings
//
// NOTE This function is available since SDL 2.0.6.
pub fn game_controller_num_mappings() int {
	return C.SDL_GameControllerNumMappings()
}

fn C.SDL_GameControllerMappingForIndex(mapping_index int) &char

// game_controller_mapping_for_index gets the mapping at a particular index.
//
// returns the mapping string. Must be freed with SDL_free(). Returns NULL if
//         the index is out of range.
//
// NOTE This function is available since SDL 2.0.6.
pub fn game_controller_mapping_for_index(mapping_index int) &char {
	return C.SDL_GameControllerMappingForIndex(mapping_index)
}

fn C.SDL_GameControllerMappingForGUID(guid C.SDL_JoystickGUID) &char

// game_controller_mapping_for_guid gets the game controller mapping string for a given GUID.
//
// The returned string must be freed with SDL_free().
//
// `guid` a structure containing the GUID for which a mapping is desired
// returns a mapping string or NULL on error; call SDL_GetError() for more
//          information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_JoystickGetDeviceGUID
// See also: SDL_JoystickGetGUID
pub fn game_controller_mapping_for_guid(guid JoystickGUID) &char {
	return C.SDL_GameControllerMappingForGUID(guid)
}

fn C.SDL_GameControllerMapping(gamecontroller &C.SDL_GameController) &char

// game_controller_mapping gets the current mapping of a Game Controller.
//
// The returned string must be freed with SDL_free().
//
// Details about mappings are discussed with SDL_GameControllerAddMapping().
//
// `gamecontroller` the game controller you want to get the current
//                       mapping for
// returns a string that has the controller's mapping or NULL if no mapping
//          is available; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerAddMapping
// See also: SDL_GameControllerMappingForGUID
pub fn game_controller_mapping(gamecontroller &GameController) &char {
	return C.SDL_GameControllerMapping(gamecontroller)
}

fn C.SDL_IsGameController(joystick_index int) bool

// is_game_controller checks if the given joystick is supported by the game controller interface.
//
// `joystick_index` is the same as the `device_index` passed to
// SDL_JoystickOpen().
//
// `joystick_index` the device_index of a device, up to
//                       SDL_NumJoysticks()
// returns SDL_TRUE if the given joystick is supported by the game controller
//          interface, SDL_FALSE if it isn't or it's an invalid index.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerNameForIndex
// See also: SDL_GameControllerOpen
pub fn is_game_controller(joystick_index int) bool {
	return C.SDL_IsGameController(joystick_index)
}

fn C.SDL_GameControllerNameForIndex(joystick_index int) &char

// game_controller_name_for_index gets the implementation dependent name for the game controller.
//
// This function can be called before any controllers are opened.
//
// `joystick_index` is the same as the `device_index` passed to
// SDL_JoystickOpen().
//
// `joystick_index` the device_index of a device, from zero to
//                       SDL_NumJoysticks()-1
// returns the implementation-dependent name for the game controller, or NULL
//          if there is no name or the index is invalid.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerName
// See also: SDL_GameControllerOpen
// See also: SDL_IsGameController
pub fn game_controller_name_for_index(joystick_index int) &char {
	return C.SDL_GameControllerNameForIndex(joystick_index)
}

fn C.SDL_GameControllerTypeForIndex(joystick_index int) C.SDL_GameControllerType

// game_controller_type_for_index gets the type of a game controller.
//
// This can be called before any controllers are opened.
//
// `joystick_index` the device_index of a device, from zero to
//                       SDL_NumJoysticks()-1
// returns the controller type.
//
// NOTE This function is available since SDL 2.0.12.
pub fn game_controller_type_for_index(joystick_index int) GameControllerType {
	return GameControllerType(int(C.SDL_GameControllerTypeForIndex(joystick_index)))
}

fn C.SDL_GameControllerMappingForDeviceIndex(joystick_index int) &char

// game_controller_mapping_for_device_index gets the mapping of a game controller.
//
// This can be called before any controllers are opened.
//
// `joystick_index` the device_index of a device, from zero to
//                       SDL_NumJoysticks()-1
// returns the mapping string. Must be freed with SDL_free(). Returns NULL if
//          no mapping is available.
//
// NOTE This function is available since SDL 2.0.9.
pub fn game_controller_mapping_for_device_index(joystick_index int) &char {
	return C.SDL_GameControllerMappingForDeviceIndex(joystick_index)
}

fn C.SDL_GameControllerOpen(joystick_index int) &C.SDL_GameController

// game_controller_open opens a game controller for use.
//
// `joystick_index` is the same as the `device_index` passed to
// SDL_JoystickOpen().
//
// The index passed as an argument refers to the N'th game controller on the
// system. This index is not the value which will identify this controller in
// future controller events. The joystick's instance id (SDL_JoystickID) will
// be used there instead.
//
// `joystick_index` the device_index of a device, up to
//                       SDL_NumJoysticks()
// returns a gamecontroller identifier or NULL if an error occurred; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerClose
// See also: SDL_GameControllerNameForIndex
// See also: SDL_IsGameController
pub fn game_controller_open(joystick_index int) &GameController {
	return C.SDL_GameControllerOpen(joystick_index)
}

fn C.SDL_GameControllerFromInstanceID(joyid JoystickID) &C.SDL_GameController

// game_controller_from_instance_id gets the SDL_GameController associated with an instance id.
//
// `joyid` the instance id to get the SDL_GameController for
// returns an SDL_GameController on success or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.4.
pub fn game_controller_from_instance_id(joyid JoystickID) &GameController {
	return C.SDL_GameControllerFromInstanceID(joyid)
}

fn C.SDL_GameControllerFromPlayerIndex(player_index int) &C.SDL_GameController

// game_controller_from_player_index gets the SDL_GameController associated with a player index.
//
// Please note that the player index is _not_ the device index, nor is it the
// instance id!
//
// `player_index` the player index, which is not the device index or the
//                     instance id!
// returns the SDL_GameController associated with a player index.
//
// NOTE This function is available since SDL 2.0.12.
//
// See also: SDL_GameControllerGetPlayerIndex
// See also: SDL_GameControllerSetPlayerIndex
pub fn game_controller_from_player_index(player_index int) &GameController {
	return C.SDL_GameControllerFromPlayerIndex(player_index)
}

fn C.SDL_GameControllerName(gamecontroller &C.SDL_GameController) &char

// game_controller_name gets the implementation-dependent name for an opened game controller.
//
// This is the same name as returned by SDL_GameControllerNameForIndex(), but
// it takes a controller identifier instead of the (unstable) device index.
//
// `gamecontroller` a game controller identifier previously returned by
//                       SDL_GameControllerOpen()
// returns the implementation dependent name for the game controller, or NULL
//          if there is no name or the identifier passed is invalid.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerNameForIndex
// See also: SDL_GameControllerOpen
pub fn game_controller_name(gamecontroller &GameController) &char {
	return C.SDL_GameControllerName(gamecontroller)
}

fn C.SDL_GameControllerGetType(gamecontroller &C.SDL_GameController) C.SDL_GameControllerType

// game_controller_get_type gets the type of this currently opened controller
//
// This is the same name as returned by SDL_GameControllerTypeForIndex(), but
// it takes a controller identifier instead of the (unstable) device index.
//
// `gamecontroller` the game controller object to query.
// returns the controller type.
//
// NOTE This function is available since SDL 2.0.12.
pub fn game_controller_get_type(gamecontroller &GameController) GameControllerType {
	return GameControllerType(int(C.SDL_GameControllerGetType(gamecontroller)))
}

fn C.SDL_GameControllerGetPlayerIndex(gamecontroller &C.SDL_GameController) int

// game_controller_get_player_index gets the player index of an opened game controller.
//
// For XInput controllers this returns the XInput user index.
//
// `gamecontroller` the game controller object to query.
// returns the player index for controller, or -1 if it's not available.
//
// NOTE This function is available since SDL 2.0.9.
pub fn game_controller_get_player_index(gamecontroller &GameController) int {
	return C.SDL_GameControllerGetPlayerIndex(gamecontroller)
}

fn C.SDL_GameControllerSetPlayerIndex(gamecontroller &C.SDL_GameController, player_index int)

// game_controller_set_player_index sets the player index of an opened game controller.
//
// `gamecontroller` the game controller object to adjust.
// `player_index` Player index to assign to this controller.
//
// NOTE This function is available since SDL 2.0.12.
pub fn game_controller_set_player_index(gamecontroller &GameController, player_index int) {
	C.SDL_GameControllerSetPlayerIndex(gamecontroller, player_index)
}

fn C.SDL_GameControllerGetVendor(gamecontroller &C.SDL_GameController) u16

// game_controller_get_vendor gets the USB vendor ID of an opened controller, if available.
//
// If the vendor ID isn't available this function returns 0.
//
// `gamecontroller` the game controller object to query.
// returns the USB vendor ID, or zero if unavailable.
//
// NOTE This function is available since SDL 2.0.6.
pub fn game_controller_get_vendor(gamecontroller &GameController) u16 {
	return C.SDL_GameControllerGetVendor(gamecontroller)
}

fn C.SDL_GameControllerGetProduct(gamecontroller &C.SDL_GameController) u16

// game_controller_get_product gets the USB product ID of an opened controller, if available.
//
// If the product ID isn't available this function returns 0.
//
// `gamecontroller` the game controller object to query.
// returns the USB product ID, or zero if unavailable.
//
// NOTE This function is available since SDL 2.0.6.
pub fn game_controller_get_product(gamecontroller &GameController) u16 {
	return C.SDL_GameControllerGetProduct(gamecontroller)
}

fn C.SDL_GameControllerGetProductVersion(gamecontroller &C.SDL_GameController) u16

// game_controller_get_product_version gets the product version of an opened controller, if available.
//
// If the product version isn't available this function returns 0.
//
// `gamecontroller` the game controller object to query.
// returns the USB product version, or zero if unavailable.
//
// NOTE This function is available since SDL 2.0.6.
pub fn game_controller_get_product_version(gamecontroller &GameController) u16 {
	return C.SDL_GameControllerGetProductVersion(gamecontroller)
}

fn C.SDL_GameControllerGetSerial(gamecontroller &C.SDL_GameController) &char

// game_controller_get_serial gets the serial number of an opened controller, if available.
//
// Returns the serial number of the controller, or NULL if it is not
// available.
//
// `gamecontroller` the game controller object to query.
// returns the serial number, or NULL if unavailable.
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_get_serial(gamecontroller &GameController) &char {
	return C.SDL_GameControllerGetSerial(gamecontroller)
}

fn C.SDL_GameControllerGetAttached(gamecontroller &C.SDL_GameController) bool

// game_controller_get_attached checks if a controller has been opened and is currently connected.
//
// `gamecontroller` a game controller identifier previously returned by
//                       SDL_GameControllerOpen()
// returns SDL_TRUE if the controller has been opened and is currently
//          connected, or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerClose
// See also: SDL_GameControllerOpen
pub fn game_controller_get_attached(gamecontroller &GameController) bool {
	return C.SDL_GameControllerGetAttached(gamecontroller)
}

fn C.SDL_GameControllerGetJoystick(gamecontroller &C.SDL_GameController) &C.SDL_Joystick

// game_controller_get_joystick gets the Joystick ID from a Game Controller.
//
// This function will give you a SDL_Joystick object, which allows you to use
// the SDL_Joystick functions with a SDL_GameController object. This would be
// useful for getting a joystick's position at any given time, even if it
// hasn't moved (moving it would produce an event, which would have the axis'
// value).
//
// The pointer returned is owned by the SDL_GameController. You should not
// call SDL_JoystickClose() on it, for example, since doing so will likely
// cause SDL to crash.
//
// `gamecontroller` the game controller object that you want to get a
//                       joystick from
// returns a SDL_Joystick object; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
pub fn game_controller_get_joystick(gamecontroller &GameController) &Joystick {
	return C.SDL_GameControllerGetJoystick(gamecontroller)
}

fn C.SDL_GameControllerEventState(state int) int

// game_controller_event_state queries or change current state of Game Controller events.
//
// If controller events are disabled, you must call SDL_GameControllerUpdate()
// yourself and check the state of the controller when you want controller
// information.
//
// Any number can be passed to SDL_GameControllerEventState(), but only -1, 0,
// and 1 will have any effect. Other numbers will just be returned.
//
// `state` can be one of `SDL_QUERY`, `SDL_IGNORE`, or `SDL_ENABLE`
// returns the same value passed to the function, with exception to -1
//          (SDL_QUERY), which will return the current state.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_JoystickEventState
pub fn game_controller_event_state(state int) int {
	return C.SDL_GameControllerEventState(state)
}

fn C.SDL_GameControllerUpdate()

// game_controller_update manually pump game controller updates if not using the loop.
//
// This function is called automatically by the event loop if events are
// enabled. Under such circumstances, it will not be necessary to call this
// function.
//
// NOTE This function is available since SDL 2.0.0.
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

fn C.SDL_GameControllerGetAxisFromString(const_str &char) C.SDL_GameControllerAxis

// game_controller_get_axis_from_string converts a string into SDL_GameControllerAxis enum.
//
// This function is called internally to translate SDL_GameController mapping
// strings for the underlying joystick device into the consistent
// SDL_GameController mapping. You do not normally need to call this function
// unless you are parsing SDL_GameController mappings in your own code.
//
// Note specially that "righttrigger" and "lefttrigger" map to
// `SDL_CONTROLLER_AXIS_TRIGGERRIGHT` and `SDL_CONTROLLER_AXIS_TRIGGERLEFT`,
// respectively.
//
// `str` string representing a SDL_GameController axis
// returns the SDL_GameControllerAxis enum corresponding to the input string,
//          or `SDL_CONTROLLER_AXIS_INVALID` if no match was found.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerGetStringForAxis
pub fn game_controller_get_axis_from_string(const_str &char) GameControllerAxis {
	return GameControllerAxis(C.SDL_GameControllerGetAxisFromString(const_str))
}

fn C.SDL_GameControllerGetStringForAxis(axis C.SDL_GameControllerAxis) &char

// game_controller_get_string_for_axis converts from an SDL_GameControllerAxis enum to a string.
//
// The caller should not SDL_free() the returned string.
//
// `axis` an enum value for a given SDL_GameControllerAxis
// returns a string for the given axis, or NULL if an invalid axis is
//          specified. The string returned is of the format used by
//          SDL_GameController mapping strings.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerGetAxisFromString
pub fn game_controller_get_string_for_axis(axis GameControllerAxis) &char {
	return C.SDL_GameControllerGetStringForAxis(C.SDL_GameControllerAxis(axis))
}

fn C.SDL_GameControllerGetBindForAxis(gamecontroller &C.SDL_GameController, axis C.SDL_GameControllerAxis) C.SDL_GameControllerButtonBind

// game_controller_get_bind_for_axis gets the SDL joystick layer binding for a controller axis mapping.
//
// `gamecontroller` a game controller
// `axis` an axis enum value (one of the SDL_GameControllerAxis values)
// returns a SDL_GameControllerButtonBind describing the bind. On failure
//          (like the given Controller axis doesn't exist on the device), its
//          `.bindType` will be `SDL_CONTROLLER_BINDTYPE_NONE`.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerGetBindForButton
pub fn game_controller_get_bind_for_axis(gamecontroller &GameController, axis GameControllerAxis) GameControllerButtonBind {
	return C.SDL_GameControllerGetBindForAxis(gamecontroller, C.SDL_GameControllerAxis(axis))
}

fn C.SDL_GameControllerHasAxis(gamecontroller &C.SDL_GameController, axis C.SDL_GameControllerAxis) bool

// game_controller_has_axis queries whether a game controller has a given axis.
//
// This merely reports whether the controller's mapping defined this axis, as
// that is all the information SDL has about the physical device.
//
// `gamecontroller` a game controller
// `axis` an axis enum value (an SDL_GameControllerAxis value)
// returns SDL_TRUE if the controller has this axis, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_has_axis(gamecontroller &GameController, axis GameControllerAxis) bool {
	return C.SDL_GameControllerHasAxis(gamecontroller, C.SDL_GameControllerAxis(axis))
}

fn C.SDL_GameControllerGetAxis(gamecontroller &C.SDL_GameController, axis C.SDL_GameControllerAxis) i16

// game_controller_get_axis gets the current state of an axis control on a game controller.
//
// The axis indices start at index 0.
//
// The state is a value ranging from -32768 to 32767. Triggers, however, range
// from 0 to 32767 (they never return a negative value).
//
// `gamecontroller` a game controller
// `axis` an axis index (one of the SDL_GameControllerAxis values)
// returns axis state (including 0) on success or 0 (also) on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerGetButton
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
	misc1 = C.SDL_CONTROLLER_BUTTON_MISC1 // Xbox Series X share button, PS5 microphone button, Nintendo Switch Pro capture button, Amazon Luna microphone button
	paddle1 = C.SDL_CONTROLLER_BUTTON_PADDLE1 // Xbox Elite paddle P1
	paddle2 = C.SDL_CONTROLLER_BUTTON_PADDLE2 // Xbox Elite paddle P3
	paddle3 = C.SDL_CONTROLLER_BUTTON_PADDLE3 // Xbox Elite paddle P2
	paddle4 = C.SDL_CONTROLLER_BUTTON_PADDLE4 // Xbox Elite paddle P4
	touchpad = C.SDL_CONTROLLER_BUTTON_TOUCHPAD // PS4/PS5 touchpad button
	max = C.SDL_CONTROLLER_BUTTON_MAX
}

fn C.SDL_GameControllerGetButtonFromString(const_str &char) C.SDL_GameControllerButton

// game_controller_get_button_from_string converts a string into an SDL_GameControllerButton enum.
//
// This function is called internally to translate SDL_GameController mapping
// strings for the underlying joystick device into the consistent
// SDL_GameController mapping. You do not normally need to call this function
// unless you are parsing SDL_GameController mappings in your own code.
//
// `str` string representing a SDL_GameController axis
// returns the SDL_GameControllerButton enum corresponding to the input
//          string, or `SDL_CONTROLLER_AXIS_INVALID` if no match was found.
//
// NOTE This function is available since SDL 2.0.0.
pub fn game_controller_get_button_from_string(const_str &char) GameControllerButton {
	return GameControllerButton(C.SDL_GameControllerGetButtonFromString(const_str))
}

fn C.SDL_GameControllerGetStringForButton(button C.SDL_GameControllerButton) &char

// game_controller_get_string_for_button converts from an SDL_GameControllerButton enum to a string.
//
// The caller should not SDL_free() the returned string.
//
// `button` an enum value for a given SDL_GameControllerButton
// returns a string for the given button, or NULL if an invalid axis is
//          specified. The string returned is of the format used by
//          SDL_GameController mapping strings.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerGetButtonFromString
pub fn game_controller_get_string_for_button(button GameControllerButton) &char {
	return C.SDL_GameControllerGetStringForButton(C.SDL_GameControllerButton(button))
}

fn C.SDL_GameControllerGetBindForButton(gamecontroller &C.SDL_GameController, button C.SDL_GameControllerButton) C.SDL_GameControllerButtonBind

// game_controller_get_bind_for_button gets the SDL joystick layer binding for a controller button mapping.
//
// `gamecontroller` a game controller
// `button` an button enum value (an SDL_GameControllerButton value)
// returns a SDL_GameControllerButtonBind describing the bind. On failure
//          (like the given Controller button doesn't exist on the device),
//          its `.bindType` will be `SDL_CONTROLLER_BINDTYPE_NONE`.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerGetBindForAxis
pub fn game_controller_get_bind_for_button(gamecontroller &GameController, button GameControllerButton) GameControllerButtonBind {
	return C.SDL_GameControllerGetBindForButton(gamecontroller, C.SDL_GameControllerButton(button))
}

fn C.SDL_GameControllerHasButton(gamecontroller &C.SDL_GameController, button C.SDL_GameControllerButton) bool

// game_controller_has_button queries whether a game controller has a given button.
//
// This merely reports whether the controller's mapping defined this button,
// as that is all the information SDL has about the physical device.
//
// `gamecontroller` a game controller
// `button` a button enum value (an SDL_GameControllerButton value)
// returns SDL_TRUE if the controller has this button, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_has_button(gamecontroller &GameController, button GameControllerButton) bool {
	return C.SDL_GameControllerHasButton(gamecontroller, C.SDL_GameControllerButton(button))
}

fn C.SDL_GameControllerGetButton(gamecontroller &C.SDL_GameController, button C.SDL_GameControllerButton) byte

// game_controller_get_button gets the current state of a button on a game controller.
//
// `gamecontroller` a game controller
// `button` a button index (one of the SDL_GameControllerButton values)
// returns 1 for pressed state or 0 for not pressed state or error; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerGetAxis
pub fn game_controller_get_button(gamecontroller &GameController, button GameControllerButton) byte {
	return C.SDL_GameControllerGetButton(gamecontroller, C.SDL_GameControllerButton(button))
}

fn C.SDL_GameControllerGetNumTouchpads(gamecontroller &C.SDL_GameController) int

// game_controller_get_num_touchpads gets the number of touchpads on a game controller.
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_get_num_touchpads(gamecontroller &GameController) int {
	return C.SDL_GameControllerGetNumTouchpads(gamecontroller)
}

fn C.SDL_GameControllerGetNumTouchpadFingers(gamecontroller &C.SDL_GameController, touchpad int) int

// game_controller_get_num_touchpad_fingers gets the number of supported simultaneous fingers on a touchpad on a game
// controller.
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_get_num_touchpad_fingers(gamecontroller &GameController, touchpad int) int {
	return C.SDL_GameControllerGetNumTouchpadFingers(gamecontroller, touchpad)
}

fn C.SDL_GameControllerGetTouchpadFinger(gamecontroller &GameController, touchpad int, finger int, state &byte, x &f32, y &f32, pressure &f32) int

// game_controller_get_touchpad_finger gets the current state of a finger on a touchpad on a game controller.
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_get_touchpad_finger(gamecontroller &GameController, touchpad int, finger int, state &byte, x &f32, y &f32, pressure &f32) int {
	return C.SDL_GameControllerGetTouchpadFinger(gamecontroller, touchpad, finger, state,
		x, y, pressure)
}

fn C.SDL_GameControllerHasSensor(gamecontroller &C.SDL_GameController, @type C.SDL_SensorType) bool

// game_controller_has_sensor returns whether a game controller has a particular sensor.
//
// `gamecontroller` The controller to query
// `type` The type of sensor to query
// returns SDL_TRUE if the sensor exists, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_has_sensor(gamecontroller &GameController, @type SensorType) bool {
	return C.SDL_GameControllerHasSensor(gamecontroller, C.SDL_SensorType(@type))
}

fn C.SDL_GameControllerSetSensorEnabled(gamecontroller &C.SDL_GameController, @type C.SDL_SensorType, enabled bool) int

// game_controller_set_sensor_enabled sets whether data reporting for a game controller sensor is enabled.
//
// `gamecontroller` The controller to update
// `type` The type of sensor to enable/disable
// `enabled` Whether data reporting should be enabled
// returns 0 or -1 if an error occurred.
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_set_sensor_enabled(gamecontroller &GameController, @type SensorType, enabled bool) int {
	return C.SDL_GameControllerSetSensorEnabled(gamecontroller, C.SDL_SensorType(@type),
		enabled)
}

fn C.SDL_GameControllerIsSensorEnabled(gamecontroller &C.SDL_GameController, @type C.SDL_SensorType) bool

// game_controller_is_sensor_enabled query whether sensor data reporting is enabled for a game controller.
//
// `gamecontroller` The controller to query
// `type` The type of sensor to query
// returns SDL_TRUE if the sensor is enabled, SDL_FALSE otherwise.
pub fn game_controller_is_sensor_enabled(gamecontroller &GameController, @type SensorType) bool {
	return C.SDL_GameControllerIsSensorEnabled(gamecontroller, C.SDL_SensorType(@type))
}

fn C.SDL_GameControllerGetSensorDataRate(gamecontroller &C.SDL_GameController, @type C.SDL_SensorType) f32

// game_controller_get_sensor_data_rate gets the data rate (number of events per second) of a game controller
// sensor.
//
// `gamecontroller` The controller to query
// `type` The type of sensor to query
// returns the data rate, or 0.0f if the data rate is not available.
//
// NOTE This function is available since SDL 2.0.16.
pub fn game_controller_get_sensor_data_rate(gamecontroller &GameController, @type SensorType) f32 {
	return C.SDL_GameControllerGetSensorDataRate(gamecontroller, C.SDL_SensorType(@type))
}

fn C.SDL_GameControllerGetSensorData(gamecontroller &C.SDL_GameController, @type C.SDL_SensorType, data &f32, num_values int) int

// game_controller_get_sensor_data gets the current state of a game controller sensor.
//
// The number of values and interpretation of the data is sensor dependent.
// See SDL_sensor.h for the details for each type of sensor.
//
// `gamecontroller` The controller to query
// `type` The type of sensor to query
// `data` A pointer filled with the current sensor state
// `num_values` The number of values to write to data
// returns 0 or -1 if an error occurred.
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_get_sensor_data(gamecontroller &GameController, @type SensorType, data &f32, num_values int) int {
	return C.SDL_GameControllerGetSensorData(gamecontroller, C.SDL_SensorType(@type),
		data, num_values)
}

fn C.SDL_GameControllerRumble(gamecontroller &C.SDL_GameController, low_frequency_rumble u16, high_frequency_rumble u16, duration_ms u32) int

// game_controller_rumble starts a rumble effect on a game controller.
//
// Each call to this function cancels any previous rumble effect, and calling
// it with 0 intensity stops any rumbling.
//
// `gamecontroller` The controller to vibrate
// `low_frequency_rumble` The intensity of the low frequency (left)
//                             rumble motor, from 0 to 0xFFFF
// `high_frequency_rumble` The intensity of the high frequency (right)
//                              rumble motor, from 0 to 0xFFFF
// `duration_ms` The duration of the rumble effect, in milliseconds
// returns 0, or -1 if rumble isn't supported on this controller
//
// NOTE This function is available since SDL 2.0.9.
//
// See also: SDL_GameControllerHasRumble
pub fn game_controller_rumble(gamecontroller &GameController, low_frequency_rumble u16, high_frequency_rumble u16, duration_ms u32) int {
	return C.SDL_GameControllerRumble(gamecontroller, low_frequency_rumble, high_frequency_rumble,
		duration_ms)
}

fn C.SDL_GameControllerRumbleTriggers(gamecontroller &C.SDL_GameController, left_rumble u16, right_rumble u16, duration_ms u32) int

// game_controller_rumble_triggers starts a rumble effect in the game controller's triggers.
//
// Each call to this function cancels any previous trigger rumble effect, and
// calling it with 0 intensity stops any rumbling.
//
// Note that this is rumbling of the _triggers_ and not the game controller as
// a whole. The first controller to offer this feature was the PlayStation 5's
// DualShock 5.
//
// `gamecontroller` The controller to vibrate
// `left_rumble` The intensity of the left trigger rumble motor, from 0
//                    to 0xFFFF
// `right_rumble` The intensity of the right trigger rumble motor, from 0
//                     to 0xFFFF
// `duration_ms` The duration of the rumble effect, in milliseconds
// returns 0, or -1 if trigger rumble isn't supported on this controller
//
// NOTE This function is available since SDL 2.0.14.
//
// See also: SDL_GameControllerHasRumbleTriggers
pub fn game_controller_rumble_triggers(gamecontroller &GameController, left_rumble u16, right_rumble u16, duration_ms u32) int {
	return C.SDL_GameControllerRumbleTriggers(gamecontroller, left_rumble, right_rumble,
		duration_ms)
}

fn C.SDL_GameControllerHasLED(gamecontroller &C.SDL_GameController) bool

// game_controller_has_led queries whether a game controller has an LED.
//
// `gamecontroller` The controller to query
// returns SDL_TRUE, or SDL_FALSE if this controller does not have a
//          modifiable LED
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_has_led(gamecontroller &GameController) bool {
	return C.SDL_GameControllerHasLED(gamecontroller)
}

fn C.SDL_GameControllerHasRumble(gamecontroller &C.SDL_GameController) bool

// game_controller_has_rumble querys whether a game controller has rumble support.
//
// `gamecontroller` The controller to query
// returns SDL_TRUE, or SDL_FALSE if this controller does not have rumble
//          support
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_GameControllerRumble
pub fn game_controller_has_rumble(gamecontroller &C.SDL_GameController) bool {
	return C.SDL_GameControllerHasRumble(gamecontroller)
}

fn C.SDL_GameControllerHasRumbleTriggers(gamecontroller &C.SDL_GameController) bool

// game_controller_has_rumble_triggers querys whether a game controller has rumble support on triggers.
//
// `gamecontroller` The controller to query
// returns SDL_TRUE, or SDL_FALSE if this controller does not have trigger
//          rumble support
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_GameControllerRumbleTriggers
pub fn game_controller_has_rumble_triggers(gamecontroller &C.SDL_GameController) bool {
	return C.SDL_GameControllerHasRumbleTriggers(gamecontroller)
}

fn C.SDL_GameControllerSetLED(gamecontroller &C.SDL_GameController, red byte, green byte, blue byte) int

// game_controller_set_led updates a game controller's LED color.
//
// `gamecontroller` The controller to update
// `red` The intensity of the red LED
// `green` The intensity of the green LED
// `blue` The intensity of the blue LED
// returns 0, or -1 if this controller does not have a modifiable LED
//
// NOTE This function is available since SDL 2.0.14.
pub fn game_controller_set_led(gamecontroller &GameController, red byte, green byte, blue byte) int {
	return C.SDL_GameControllerSetLED(gamecontroller, red, green, blue)
}

fn C.SDL_GameControllerSendEffect(gamecontroller &C.SDL_GameController, const_data voidptr, size int) int

// game_controller_send_effect sends a controller specific effect packet
//
// `gamecontroller` The controller to affect
// `data` The data to send to the controller
// `size` The size of the data to send to the controller
// returns 0, or -1 if this controller or driver doesn't support effect
//          packets
//
// NOTE This function is available since SDL 2.0.16.
pub fn game_controller_send_effect(gamecontroller &GameController, const_data voidptr, size int) int {
	return C.SDL_GameControllerSendEffect(gamecontroller, const_data, size)
}

fn C.SDL_GameControllerClose(gamecontroller &C.SDL_GameController)

// game_controller_close closes a game controller previously opened with SDL_GameControllerOpen().
//
// `gamecontroller` a game controller identifier previously returned by
//                       SDL_GameControllerOpen()
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GameControllerOpen
pub fn game_controller_close(gamecontroller &GameController) {
	C.SDL_GameControllerClose(gamecontroller)
}

fn C.SDL_GameControllerGetAppleSFSymbolsNameForButton(gamecontroller &C.SDL_GameController, button C.SDL_GameControllerButton) &char

// game_controller_get_apple_sf_symbols_name_for_button returns the sfSymbolsName for a given button on a game controller on Apple
// platforms.
//
// `gamecontroller` the controller to query
// `button` a button on the game controller
// returns the sfSymbolsName or NULL if the name can't be found
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_GameControllerGetAppleSFSymbolsNameForAxis
pub fn game_controller_get_apple_sf_symbols_name_for_button(gamecontroller &C.SDL_GameController, button C.SDL_GameControllerButton) &char {
	return C.SDL_GameControllerGetAppleSFSymbolsNameForButton(gamecontroller, button)
}

fn C.SDL_GameControllerGetAppleSFSymbolsNameForAxis(gamecontroller &C.SDL_GameController, axis C.SDL_GameControllerAxis) &char

// game_controller_get_apple_sf_symbols_name_for_axis returns the sfSymbolsName for a given axis on a game controller on Apple
// platforms.
//
// `gamecontroller` the controller to query
// `axis` an axis on the game controller
// returns the sfSymbolsName or NULL if the name can't be found
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_GameControllerGetAppleSFSymbolsNameForButton
pub fn game_controller_get_apple_sf_symbols_name_for_axis(gamecontroller &C.SDL_GameController, axis C.SDL_GameControllerAxis) &char {
	return C.SDL_GameControllerGetAppleSFSymbolsNameForAxis(gamecontroller, axis)
}
