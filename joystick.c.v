// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_joystick.h
//

pub const joystick_axis_max = C.SDL_JOYSTICK_AXIS_MAX // 32767

pub const joystick_axis_min = C.SDL_JOYSTICK_AXIS_MIN // -32768

// Hat positions
pub const hat_centered = C.SDL_HAT_CENTERED // 0x00

pub const hat_up = C.SDL_HAT_UP // 0x01

pub const hat_right = C.SDL_HAT_RIGHT // 0x02

pub const hat_down = C.SDL_HAT_DOWN // 0x04

pub const hat_left = C.SDL_HAT_LEFT // 0x08

pub const hat_rightup = C.SDL_HAT_RIGHTUP // hat_right | hat_up

pub const hat_rightdown = C.SDL_HAT_RIGHTDOWN // hat_right | hat_down

pub const hat_leftup = C.SDL_HAT_LEFTUP // hat_left | hat_up

pub const hat_leftdown = C.SDL_HAT_LEFTDOWN // hat_left | hat_down

@[typedef]
pub struct C.SDL_Joystick {
}

pub type Joystick = C.SDL_Joystick

@[typedef]
pub struct C.SDL_JoystickGUID {
pub:
	data [16]u8
}

pub type JoystickGUID = C.SDL_JoystickGUID

// JoystickType is C.SDL_JoystickType
pub enum JoystickType {
	unknown
	gamecontroller
	wheel
	arcade_stick
	flight_stick
	dance_pad
	guitar
	drum_kit
	arcade_pad
	throttle
}

// C.SDL_JoystickID // Sint32
pub type JoystickID = i32

// JoystickPowerLevel is C.SDL_JoystickPowerLevel
pub enum JoystickPowerLevel {
	unknown = -1
	empty  // <= 5%
	low    // <= 20%
	medium // <= 70%
	full   // <= 100%
	wired
	max
}

// Set max recognized G-force from accelerometer
// See src/joystick/uikit/SDL_sysjoystick.m for notes on why this is needed
pub const iphone_max_gforce = C.SDL_IPHONE_MAX_GFORCE

// 5.0

fn C.SDL_LockJoysticks()

// lock_joysticks provides locking for multi-threaded access to the joystick API
//
// If you are using the joystick API or handling events from multiple threads
// you should use these locking functions to protect access to the joysticks.
//
// In particular, you are guaranteed that the joystick list won't change, so
// the API functions that take a joystick index will be valid, and joystick
// and game controller events will not be delivered.
pub fn lock_joysticks() {
	C.SDL_LockJoysticks()
}

fn C.SDL_UnlockJoysticks()

pub fn unlock_joysticks() {
	C.SDL_UnlockJoysticks()
}

fn C.SDL_NumJoysticks() int

// num_joysticks counts the number of joysticks attached to the system right now
pub fn num_joysticks() int {
	return C.SDL_NumJoysticks()
}

fn C.SDL_JoystickNameForIndex(device_index int) &char

// joystick_name_for_index gets the implementation dependent name of a joystick.
// This can be called before any joysticks are opened.
// If no name can be found, this function returns NULL.
pub fn joystick_name_for_index(device_index int) &char {
	return C.SDL_JoystickNameForIndex(device_index)
}

fn C.SDL_JoystickGetDevicePlayerIndex(device_index int) int

// joystick_get_device_player_index gets the player index of a joystick, or -1 if it's not available
// This can be called before any joysticks are opened.
pub fn joystick_get_device_player_index(device_index int) int {
	return C.SDL_JoystickGetDevicePlayerIndex(device_index)
}

fn C.SDL_JoystickGetDeviceGUID(device_index int) C.SDL_JoystickGUID

// joystick_get_device_gui returns the GUID for the joystick at this index
// This can be called before any joysticks are opened.
pub fn joystick_get_device_guid(device_index int) JoystickGUID {
	return C.SDL_JoystickGetDeviceGUID(device_index)
}

fn C.SDL_JoystickGetDeviceVendor(device_index int) u16

// joystick_get_device_vendor gets the USB vendor ID of a joystick, if available.
// This can be called before any joysticks are opened.
// If the vendor ID isn't available this function returns 0.
pub fn joystick_get_device_vendor(device_index int) u16 {
	return C.SDL_JoystickGetDeviceVendor(device_index)
}

fn C.SDL_JoystickGetDeviceProduct(device_index int) u16

// joystick_get_device_produc gets the USB product ID of a joystick, if available.
// This can be called before any joysticks are opened.
// If the product ID isn't available this function returns 0.
pub fn joystick_get_device_product(device_index int) u16 {
	return C.SDL_JoystickGetDeviceProduct(device_index)
}

fn C.SDL_JoystickGetDeviceProductVersion(device_index int) u16

// joystick_get_device_product_version gets the product version of a joystick, if available.
// This can be called before any joysticks are opened.
// If the product version isn't available this function returns 0.
pub fn joystick_get_device_product_version(device_index int) u16 {
	return C.SDL_JoystickGetDeviceProductVersion(device_index)
}

fn C.SDL_JoystickGetDeviceType(device_index int) JoystickType

// joystick_get_device_type gets the type of a joystick, if available.
// This can be called before any joysticks are opened.
pub fn joystick_get_device_type(device_index int) JoystickType {
	return unsafe { JoystickType(int(C.SDL_JoystickGetDeviceType(device_index))) }
}

fn C.SDL_JoystickGetDeviceInstanceID(device_index int) JoystickID

// joystick_get_device_instance_id gets the instance ID of a joystick.
// This can be called before any joysticks are opened.
// If the index is out of range, this function will return -1.
pub fn joystick_get_device_instance_id(device_index int) JoystickID {
	return unsafe { int(C.SDL_JoystickGetDeviceInstanceID(device_index)) }
}

fn C.SDL_JoystickOpen(device_index int) &C.SDL_Joystick

// joystick_open opens a joystick for use.
// The index passed as an argument refers to the N'th joystick on the system.
// This index is not the value which will identify this joystick in future
// joystick events.  The joystick's instance id (::SDL_JoystickID) will be used
// there instead.
//
// returns A joystick identifier, or NULL if an error occurred.
pub fn joystick_open(device_index int) &Joystick {
	return C.SDL_JoystickOpen(device_index)
}

fn C.SDL_JoystickFromInstanceID(instance_id C.SDL_JoystickID) &C.SDL_Joystick

// joystick_from_instance_id returns the SDL_Joystick associated with an instance id.
pub fn joystick_from_instance_id(instance_id JoystickID) &Joystick {
	return C.SDL_JoystickFromInstanceID(C.SDL_JoystickID(instance_id))
}

fn C.SDL_JoystickFromPlayerIndex(player_index int) &C.SDL_Joystick

// joystick_from_player_index returns the SDL_Joystick associated with a player index.
pub fn joystick_from_player_index(player_index int) &Joystick {
	return C.SDL_JoystickFromPlayerIndex(player_index)
}

fn C.SDL_JoystickAttachVirtual(@type C.SDL_JoystickType, naxes int, nbuttons int, nhats int) int

// joystick_attach_virtual attaches a new virtual joystick.
// Returns the joystick's device index, or -1 if an error occurred.
pub fn joystick_attach_virtual(@type JoystickType, naxes int, nbuttons int, nhats int) int {
	return C.SDL_JoystickAttachVirtual(C.SDL_JoystickType(@type), naxes, nbuttons, nhats)
}

fn C.SDL_JoystickDetachVirtual(device_index int) int

// joystick_detach_virtual detaches a virtual joystick
// Returns 0 on success, or -1 if an error occurred.
pub fn joystick_detach_virtual(device_index int) int {
	return C.SDL_JoystickDetachVirtual(device_index)
}

fn C.SDL_JoystickIsVirtual(device_index int) bool

// joystick_is_virtual indicates whether or not a virtual-joystick is at a given device index.
pub fn joystick_is_virtual(device_index int) bool {
	return C.SDL_JoystickIsVirtual(device_index)
}

fn C.SDL_JoystickSetVirtualAxis(joystick &C.SDL_Joystick, axis int, value i16) int

// joystick_set_virtual_axis sets values on an opened, virtual-joystick's controls.
// Please note that values set here will not be applied until the next
// call to SDL_JoystickUpdate, which can either be called directly,
// or can be called indirectly through various other SDL APIS,
// including, but not limited to the following: SDL_PollEvent,
// SDL_PumpEvents, SDL_WaitEventTimeout, SDL_WaitEvent.
//
// Returns 0 on success, -1 on error.
pub fn joystick_set_virtual_axis(joystick &Joystick, axis int, value i16) int {
	return C.SDL_JoystickSetVirtualAxis(joystick, axis, value)
}

fn C.SDL_JoystickSetVirtualButton(joystick &C.SDL_Joystick, button int, value u8) int

// joystick_set_virtual_button sets values on an opened, virtual-joystick's controls.
// Please note that values set here will not be applied until the next
// call to SDL_JoystickUpdate, which can either be called directly,
// or can be called indirectly through various other SDL APIS,
// including, but not limited to the following: SDL_PollEvent,
// SDL_PumpEvents, SDL_WaitEventTimeout, SDL_WaitEvent.
//
// Returns 0 on success, -1 on error.
pub fn joystick_set_virtual_button(joystick &Joystick, button int, value u8) int {
	return C.SDL_JoystickSetVirtualButton(joystick, button, value)
}

fn C.SDL_JoystickSetVirtualHat(joystick &C.SDL_Joystick, hat int, value u8) int

// joystick_set_virtual_hat sets values on an opened, virtual-joystick's controls.
// Please note that values set here will not be applied until the next
// call to SDL_JoystickUpdate, which can either be called directly,
// or can be called indirectly through various other SDL APIS,
// including, but not limited to the following: SDL_PollEvent,
// SDL_PumpEvents, SDL_WaitEventTimeout, SDL_WaitEvent.
//
// Returns 0 on success, -1 on error.
pub fn joystick_set_virtual_hat(joystick &C.SDL_Joystick, hat int, value u8) int {
	return C.SDL_JoystickSetVirtualHat(joystick, hat, value)
}

fn C.SDL_JoystickName(joystick &C.SDL_Joystick) &char

// joystick_name returns the name for this currently opened joystick.
// If no name can be found, this function returns NULL.
pub fn joystick_name(joystick &Joystick) &char {
	return C.SDL_JoystickName(joystick)
}

fn C.SDL_JoystickGetPlayerIndex(joystick &C.SDL_Joystick) int

// joystick_get_player_index gets the player index of an opened joystick, or -1 if it's not available
//
// For XInput controllers this returns the XInput user index.
pub fn joystick_get_player_index(joystick &Joystick) int {
	return C.SDL_JoystickGetPlayerIndex(joystick)
}

fn C.SDL_JoystickSetPlayerIndex(joystick &C.SDL_Joystick, player_index int)

// joystick_set_player_index sets the player index of an opened joystick
pub fn joystick_set_player_index(joystick &Joystick, player_index int) {
	C.SDL_JoystickSetPlayerIndex(joystick, player_index)
}

fn C.SDL_JoystickGetGUID(joystick &C.SDL_Joystick) C.SDL_JoystickGUID

// joystick_get_guid returns the GUID for this opened joystick
pub fn joystick_get_guid(joystick &Joystick) JoystickGUID {
	return C.SDL_JoystickGetGUID(joystick)
}

fn C.SDL_JoystickGetVendor(joystick &C.SDL_Joystick) u16

// joystick_get_vendor gets the USB vendor ID of an opened joystick, if available.
// If the vendor ID isn't available this function returns 0.
pub fn joystick_get_vendor(joystick &Joystick) u16 {
	return C.SDL_JoystickGetVendor(joystick)
}

fn C.SDL_JoystickGetProduct(joystick &C.SDL_Joystick) u16

// joystick_get_product gets the USB product ID of an opened joystick, if available.
// If the product ID isn't available this function returns 0.
pub fn joystick_get_product(joystick &Joystick) u16 {
	return C.SDL_JoystickGetProduct(joystick)
}

fn C.SDL_JoystickGetProductVersion(joystick &C.SDL_Joystick) u16

// joystick_get_product_version gets the product version of an opened joystick, if available.
// If the product version isn't available this function returns 0.
pub fn joystick_get_product_version(joystick &Joystick) u16 {
	return C.SDL_JoystickGetProductVersion(joystick)
}

fn C.SDL_JoystickGetSerial(joystick &C.SDL_Joystick) &char

// joystick_get_serial gets the serial number of an opened joystick, if available.
//
// Returns the serial number of the joystick, or NULL if it is not available.
pub fn joystick_get_serial(joystick &Joystick) &char {
	return C.SDL_JoystickGetSerial(joystick)
}

fn C.SDL_JoystickGetType(joystick &C.SDL_Joystick) JoystickType

// joystick_get_type gets the type of an opened joystick.
pub fn joystick_get_type(joystick &Joystick) JoystickType {
	return unsafe { JoystickType(int(C.SDL_JoystickGetType(joystick))) }
}

fn C.SDL_JoystickGetGUIDString(guid C.SDL_JoystickGUID, psz_guid &char, cb_guid int)

// joystick_get_guid_string returns a string representation for this guid. pszGUID must point to at least 33 bytes
// (32 for the string plus a NULL terminator).
pub fn joystick_get_guid_string(guid JoystickGUID, psz_guid &char, cb_guid int) {
	C.SDL_JoystickGetGUIDString(guid, psz_guid, cb_guid)
}

fn C.SDL_JoystickGetGUIDFromString(pch_guid &char) C.SDL_JoystickGUID

// joystick_get_guid_from_string converts a string into a joystick guid
pub fn joystick_get_guid_from_string(pch_guid &char) C.SDL_JoystickGUID {
	return C.SDL_JoystickGetGUIDFromString(pch_guid)
}

fn C.SDL_JoystickGetAttached(joystick &C.SDL_Joystick) bool

// joystick_get_attached returns SDL_TRUE if the joystick has been opened and currently connected, or SDL_FALSE if it has not.
pub fn joystick_get_attached(joystick &Joystick) bool {
	return C.SDL_JoystickGetAttached(joystick)
}

fn C.SDL_JoystickInstanceID(joystick &C.SDL_Joystick) JoystickID

// joystick_instance_id gets the instance ID of an opened joystick or -1 if the joystick is invalid.
pub fn joystick_instance_id(joystick &Joystick) JoystickID {
	return C.SDL_JoystickInstanceID(joystick)
}

fn C.SDL_JoystickNumAxes(joystick &C.SDL_Joystick) int

// joystick_num_axes gets the number of general axis controls on a joystick.
pub fn joystick_num_axes(joystick &Joystick) int {
	return C.SDL_JoystickNumAxes(joystick)
}

fn C.SDL_JoystickNumBalls(joystick &C.SDL_Joystick) int

// joystick_num_balls gets the number of trackballs on a joystick.
//
// Joystick trackballs have only relative motion events associated
// with them and their state cannot be polled.
pub fn joystick_num_balls(joystick &Joystick) int {
	return C.SDL_JoystickNumBalls(joystick)
}

fn C.SDL_JoystickNumHats(joystick &C.SDL_Joystick) int

// joystick_num_hats gets the number of POV hats on a joystick.
pub fn joystick_num_hats(joystick &Joystick) int {
	return C.SDL_JoystickNumHats(joystick)
}

fn C.SDL_JoystickUpdate()

fn C.SDL_JoystickNumButtons(joystick &C.SDL_Joystick) int

// joystick_num_buttons gets the number of buttons on a joystick.
pub fn joystick_num_buttons(joystick &Joystick) int {
	return C.SDL_JoystickNumButtons(joystick)
}

// joystick_update updates the current state of the open joysticks.
//
// This is called automatically by the event loop if any joystick
// events are enabled.
pub fn joystick_update() {
	C.SDL_JoystickUpdate()
}

fn C.SDL_JoystickEventState(state int) int

// joystick_event_state enables/disables joystick event polling.
//
// If joystick events are disabled, you must call SDL_JoystickUpdate()
// yourself and check the state of the joystick when you want joystick
// information.
//
// The state can be one of ::SDL_QUERY, ::SDL_ENABLE or ::SDL_IGNORE.
pub fn joystick_event_state(state int) int {
	return C.SDL_JoystickEventState(state)
}

fn C.SDL_JoystickGetAxis(joystick &C.SDL_Joystick, axis int) i16

// joystick_get_axis gets the current state of an axis control on a joystick.
//
// The state is a value ranging from -32768 to 32767.
//
// The axis indices start at index 0.
pub fn joystick_get_axis(joystick &Joystick, axis int) i16 {
	return C.SDL_JoystickGetAxis(joystick, axis)
}

fn C.SDL_JoystickGetAxisInitialState(joystick &C.SDL_Joystick, axis int, state &i16) bool

// joystick_get_axis_initial_state gets the initial state of an axis control on a joystick.
//
// The state is a value ranging from -32768 to 32767.
//
// The axis indices start at index 0.
//
// returns SDL_TRUE if this axis has any initial value, or SDL_FALSE if not.
pub fn joystick_get_axis_initial_state(joystick &Joystick, axis int, state &i16) bool {
	return C.SDL_JoystickGetAxisInitialState(joystick, axis, state)
}

fn C.SDL_JoystickGetHat(joystick &C.SDL_Joystick, hat int) u8

// joystick_get_hat gets the current state of a POV hat on a joystick.
//
// The hat indices start at index 0.
//
// returns The return value is one of the following positions:
// - ::SDL_HAT_CENTERED
// - ::SDL_HAT_UP
// - ::SDL_HAT_RIGHT
// - ::SDL_HAT_DOWN
// - ::SDL_HAT_LEFT
// - ::SDL_HAT_RIGHTUP
// - ::SDL_HAT_RIGHTDOWN
// - ::SDL_HAT_LEFTUP
// - ::SDL_HAT_LEFTDOWN
pub fn joystick_get_hat(joystick &Joystick, hat int) u8 {
	return C.SDL_JoystickGetHat(joystick, hat)
}

fn C.SDL_JoystickGetBall(joystick &C.SDL_Joystick, ball int, dx &int, dy &int) int

// joystick_get_ball gets the ball axis change since the last poll.
//
// returns 0, or -1 if you passed it invalid parameters.
//
// The ball indices start at index 0.
pub fn joystick_get_ball(joystick &Joystick, ball int, dx &int, dy &int) int {
	return C.SDL_JoystickGetBall(joystick, ball, dx, dy)
}

fn C.SDL_JoystickGetButton(joystick &C.SDL_Joystick, button int) u8

// joystick_get_button gets the current state of a button on a joystick.
//
// The button indices start at index 0.
pub fn joystick_get_button(joystick &Joystick, button int) u8 {
	return C.SDL_JoystickGetButton(joystick, button)
}

fn C.SDL_JoystickRumble(joystick &C.SDL_Joystick, low_frequency_rumble u16, high_frequency_rumble u16, duration_ms u32) int

// joystick_rumble starts a rumble effect
// Each call to this function cancels any previous rumble effect, and calling it with 0 intensity stops any rumbling.
//
// `joystick` The joystick to vibrate
// `low_frequency_rumble` The intensity of the low frequency (left) rumble motor, from 0 to 0xFFFF
// `high_frequency_rumble` The intensity of the high frequency (right) rumble motor, from 0 to 0xFFFF
// `duration_ms` The duration of the rumble effect, in milliseconds
//
// returns 0, or -1 if rumble isn't supported on this joystick
pub fn joystick_rumble(joystick &Joystick, low_frequency_rumble u16, high_frequency_rumble u16, duration_ms u32) int {
	return C.SDL_JoystickRumble(joystick, low_frequency_rumble, high_frequency_rumble,
		duration_ms)
}

fn C.SDL_JoystickRumbleTriggers(joystick &C.SDL_Joystick, left_rumble u16, right_rumble u16, duration_ms u32) int

// joystick_rumble_triggers starts a rumble effect in the joystick's triggers
// Each call to this function cancels any previous trigger rumble effect, and calling it with 0 intensity stops any rumbling.
//
// `joystick` The joystick to vibrate
// `left_rumble` The intensity of the left trigger rumble motor, from 0 to 0xFFFF
// `right_rumble` The intensity of the right trigger rumble motor, from 0 to 0xFFFF
// `duration_ms` The duration of the rumble effect, in milliseconds
//
// returns 0, or -1 if trigger rumble isn't supported on this joystick
pub fn joystick_rumble_triggers(joystick &Joystick, left_rumble u16, right_rumble u16, duration_ms u32) int {
	return C.SDL_JoystickRumbleTriggers(joystick, left_rumble, right_rumble, duration_ms)
}

fn C.SDL_JoystickHasLED(joystick &C.SDL_Joystick) bool

// joystick_has_led returns whether a joystick has an LED
//
// `joystick` The joystick to query
//
// returns SDL_TRUE, or SDL_FALSE if this joystick does not have a modifiable LED
pub fn joystick_has_led(joystick &Joystick) bool {
	return C.SDL_JoystickHasLED(joystick)
}

fn C.SDL_JoystickSetLED(joystick &Joystick, red u8, green u8, blue u8) int

// joystick_set_led updates a joystick's LED color.
//
// `joystick` The joystick to update
// `red` The intensity of the red LED
// `green` The intensity of the green LED
// `blue` The intensity of the blue LED
//
// returns 0, or -1 if this joystick does not have a modifiable LED
pub fn joystick_set_led(joystick &Joystick, red u8, green u8, blue u8) int {
	return C.SDL_JoystickSetLED(joystick, red, green, blue)
}

fn C.SDL_JoystickClose(joystick &C.SDL_Joystick)

// joystick_close closes a joystick previously opened with SDL_JoystickOpen().
pub fn joystick_close(joystick &Joystick) {
	C.SDL_JoystickClose(joystick)
}

fn C.SDL_JoystickCurrentPowerLevel(joystick &C.SDL_Joystick) JoystickPowerLevel

// joystick_current_power_level returns the battery level of this joystick
pub fn joystick_current_power_level(joystick &Joystick) JoystickPowerLevel {
	return unsafe { JoystickPowerLevel(int(C.SDL_JoystickCurrentPowerLevel(joystick))) }
}
