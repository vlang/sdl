// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_joystick.h
//

pub const (
	joystick_axis_max = C.SDL_JOYSTICK_AXIS_MAX // 32767
	joystick_axis_min = C.SDL_JOYSTICK_AXIS_MIN // -32768
)

// Hat positions
pub const (
	hat_centered  = C.SDL_HAT_CENTERED // 0x00
	hat_up        = C.SDL_HAT_UP // 0x01
	hat_right     = C.SDL_HAT_RIGHT // 0x02
	hat_down      = C.SDL_HAT_DOWN // 0x04
	hat_left      = C.SDL_HAT_LEFT // 0x08
	hat_rightup   = C.SDL_HAT_RIGHTUP // hat_right | hat_up
	hat_rightdown = C.SDL_HAT_RIGHTDOWN // hat_right | hat_down
	hat_leftup    = C.SDL_HAT_LEFTUP // hat_left | hat_up
	hat_leftdown  = C.SDL_HAT_LEFTDOWN // hat_left | hat_down
)

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
	empty
	low
	medium
	full
	wired
	max
}

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

fn C.SDL_JoystickFromInstanceID(joyid C.SDL_JoystickID) &C.SDL_Joystick

// joystick_from_instance_id returns the SDL_Joystick associated with an instance id.
pub fn joystick_from_instance_id(joyid JoystickID) &Joystick {
	return C.SDL_JoystickFromInstanceID(C.SDL_JoystickID(joyid))
}

fn C.SDL_JoystickName(joystick &C.SDL_Joystick) &char

// joystick_name returns the name for this currently opened joystick.
// If no name can be found, this function returns NULL.
pub fn joystick_name(joystick &Joystick) &char {
	return C.SDL_JoystickName(joystick)
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
