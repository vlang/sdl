// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_joystick.h
//

pub const (
	joystick_axis_max = 32767
	joystick_axis_min = -32768
)

pub const (
	hat_centered  = 0x00
	hat_up        = 0x01
	hat_right     = 0x02
	hat_down      = 0x04
	hat_left      = 0x08
	hat_rightup   = hat_right | hat_up
	hat_rightdown = hat_right | hat_down
	hat_leftup    = hat_left | hat_up
	hat_leftdown  = hat_left | hat_down
)

[typedef]
struct C.SDL_Joystick {
}

pub type Joystick = C.SDL_Joystick

[typedef]
struct C.SDL_JoystickGUID {
	data [16]byte
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

pub type JoystickID = int // C.SDL_JoystickID // Sint32 / int

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

/**
 * Locking for multi-threaded access to the joystick API
 *
 * If you are using the joystick API or handling events from multiple threads
 * you should use these locking functions to protect access to the joysticks.
 *
 * In particular, you are guaranteed that the joystick list won't change, so
 * the API functions that take a joystick index will be valid, and joystick
 * and game controller events will not be delivered.
*/
fn C.SDL_LockJoysticks()
pub fn lock_joysticks() {
	C.SDL_LockJoysticks()
}

fn C.SDL_UnlockJoysticks()
pub fn unlock_joysticks() {
	C.SDL_UnlockJoysticks()
}

/**
 *  Count the number of joysticks attached to the system right now
*/
fn C.SDL_NumJoysticks() int
pub fn num_joysticks() int {
	return C.SDL_NumJoysticks()
}

/**
 *  Get the implementation dependent name of a joystick.
 *  This can be called before any joysticks are opened.
 *  If no name can be found, this function returns NULL.
*/
fn C.SDL_JoystickNameForIndex(device_index int) &char
pub fn joystick_name_for_index(device_index int) &char {
	return C.SDL_JoystickNameForIndex(device_index)
}

/**
 *  Return the GUID for the joystick at this index
 *  This can be called before any joysticks are opened.
*/
fn C.SDL_JoystickGetDeviceGUID(device_index int) C.SDL_JoystickGUID
pub fn joystick_get_device_guid(device_index int) JoystickGUID {
	return C.SDL_JoystickGetDeviceGUID(device_index)
}

/**
 *  Get the USB vendor ID of a joystick, if available.
 *  This can be called before any joysticks are opened.
 *  If the vendor ID isn't available this function returns 0.
*/
fn C.SDL_JoystickGetDeviceVendor(device_index int) u16
pub fn joystick_get_device_vendor(device_index int) u16 {
	return C.SDL_JoystickGetDeviceVendor(device_index)
}

/**
 *  Get the USB product ID of a joystick, if available.
 *  This can be called before any joysticks are opened.
 *  If the product ID isn't available this function returns 0.
*/
fn C.SDL_JoystickGetDeviceProduct(device_index int) u16
pub fn joystick_get_device_product(device_index int) u16 {
	return C.SDL_JoystickGetDeviceProduct(device_index)
}

/**
 *  Get the product version of a joystick, if available.
 *  This can be called before any joysticks are opened.
 *  If the product version isn't available this function returns 0.
*/
fn C.SDL_JoystickGetDeviceProductVersion(device_index int) u16
pub fn joystick_get_device_product_version(device_index int) u16 {
	return C.SDL_JoystickGetDeviceProductVersion(device_index)
}

/**
 *  Get the type of a joystick, if available.
 *  This can be called before any joysticks are opened.
*/
fn C.SDL_JoystickGetDeviceType(device_index int) C.SDL_JoystickType
pub fn joystick_get_device_type(device_index int) JoystickType {
	return JoystickType(int(C.SDL_JoystickGetDeviceType(device_index)))
}

/**
 *  Get the instance ID of a joystick.
 *  This can be called before any joysticks are opened.
 *  If the index is out of range, this function will return -1.
*/
fn C.SDL_JoystickGetDeviceInstanceID(device_index int) C.SDL_JoystickID
pub fn joystick_get_device_instance_id(device_index int) JoystickID {
	return int(C.SDL_JoystickGetDeviceInstanceID(device_index))
}

/**
 *  Open a joystick for use.
 *  The index passed as an argument refers to the N'th joystick on the system.
 *  This index is not the value which will identify this joystick in future
 *  joystick events.  The joystick's instance id (::SDL_JoystickID) will be used
 *  there instead.
 *
 *  \return A joystick identifier, or NULL if an error occurred.
*/
fn C.SDL_JoystickOpen(device_index int) &C.SDL_Joystick
pub fn joystick_open(device_index int) &Joystick {
	return C.SDL_JoystickOpen(device_index)
}

/**
 * Return the SDL_Joystick associated with an instance id.
*/
fn C.SDL_JoystickFromInstanceID(joyid C.SDL_JoystickID) &C.SDL_Joystick
pub fn joystick_from_instance_id(joyid JoystickID) &Joystick {
	return C.SDL_JoystickFromInstanceID(C.SDL_JoystickID(joyid))
}

/**
 *  Return the name for this currently opened joystick.
 *  If no name can be found, this function returns NULL.
*/
fn C.SDL_JoystickName(joystick &C.SDL_Joystick) &char
pub fn joystick_name(joystick &Joystick) string {
	return unsafe { cstring_to_vstring(C.SDL_JoystickName(joystick)) }
}

/**
 *  Return the GUID for this opened joystick
*/
fn C.SDL_JoystickGetGUID(joystick &C.SDL_Joystick) C.SDL_JoystickGUID
pub fn joystick_get_guid(joystick &Joystick) JoystickGUID {
	return C.SDL_JoystickGetGUID(joystick)
}

/**
 *  Get the USB vendor ID of an opened joystick, if available.
 *  If the vendor ID isn't available this function returns 0.
*/
fn C.SDL_JoystickGetVendor(joystick &C.SDL_Joystick) u16
pub fn joystick_get_vendor(joystick &Joystick) u16 {
	return C.SDL_JoystickGetVendor(joystick)
}

/**
 *  Get the USB product ID of an opened joystick, if available.
 *  If the product ID isn't available this function returns 0.
*/
fn C.SDL_JoystickGetProduct(joystick &C.SDL_Joystick) u16
pub fn joystick_get_product(joystick &Joystick) u16 {
	return C.SDL_JoystickGetProduct(joystick)
}

/**
 *  Get the product version of an opened joystick, if available.
 *  If the product version isn't available this function returns 0.
*/
fn C.SDL_JoystickGetProductVersion(joystick &C.SDL_Joystick) u16
pub fn joystick_get_product_version(joystick &Joystick) u16 {
	return C.SDL_JoystickGetProductVersion(joystick)
}

/**
 *  Get the type of an opened joystick.
*/
fn C.SDL_JoystickGetType(joystick &C.SDL_Joystick) C.SDL_JoystickType
pub fn joystick_get_type(joystick &Joystick) JoystickType {
	return JoystickType(int(C.SDL_JoystickGetType(joystick)))
}

/**
 *  Return a string representation for this guid. pszGUID must point to at least 33 bytes
 *  (32 for the string plus a NULL terminator).
*/
fn C.SDL_JoystickGetGUIDString(guid C.SDL_JoystickGUID, psz_guid &char, cb_guid int)
pub fn joystick_get_guid_string(guid JoystickGUID, psz_guid &char, cb_guid int) {
	C.SDL_JoystickGetGUIDString(guid, psz_guid, cb_guid)
}

/**
 *  Convert a string into a joystick guid
*/
fn C.SDL_JoystickGetGUIDFromString(pch_guid &char) C.SDL_JoystickGUID
pub fn joystick_get_guid_from_string(pch_guid &char) C.SDL_JoystickGUID {
	return C.SDL_JoystickGetGUIDFromString(pch_guid)
}

/**
 *  Returns SDL_TRUE if the joystick has been opened and currently connected, or SDL_FALSE if it has not.
*/
fn C.SDL_JoystickGetAttached(joystick &C.SDL_Joystick) bool
pub fn joystick_get_attached(joystick &Joystick) bool {
	return C.SDL_JoystickGetAttached(joystick)
}

/**
 *  Get the instance ID of an opened joystick or -1 if the joystick is invalid.
*/
fn C.SDL_JoystickInstanceID(joystick &C.SDL_Joystick) C.SDL_JoystickID
pub fn joystick_instance_id(joystick &Joystick) C.SDL_JoystickID {
	return C.SDL_JoystickInstanceID(joystick)
}

/**
 *  Get the number of general axis controls on a joystick.
*/
fn C.SDL_JoystickNumAxes(joystick &C.SDL_Joystick) int
pub fn joystick_num_axes(joystick &Joystick) int {
	return C.SDL_JoystickNumAxes(joystick)
}

/**
 *  Get the number of trackballs on a joystick.
 *
 *  Joystick trackballs have only relative motion events associated
 *  with them and their state cannot be polled.
*/
fn C.SDL_JoystickNumBalls(joystick &C.SDL_Joystick) int
pub fn joystick_num_balls(joystick &Joystick) int {
	return C.SDL_JoystickNumBalls(joystick)
}

/**
 *  Get the number of POV hats on a joystick.
*/
fn C.SDL_JoystickNumHats(joystick &C.SDL_Joystick) int
pub fn joystick_num_hats(joystick &Joystick) int {
	return C.SDL_JoystickNumHats(joystick)
}

/**
 *  Get the number of buttons on a joystick.
*/
fn C.SDL_JoystickNumButtons(joystick &C.SDL_Joystick) int
pub fn joystick_num_buttons(joystick &Joystick) int {
	return C.SDL_JoystickNumButtons(joystick)
}

/**
 *  Update the current state of the open joysticks.
 *
 *  This is called automatically by the event loop if any joystick
 *  events are enabled.
*/
fn C.SDL_JoystickUpdate()
pub fn joystick_update() {
	C.SDL_JoystickUpdate()
}

/**
 *  Enable/disable joystick event polling.
 *
 *  If joystick events are disabled, you must call SDL_JoystickUpdate()
 *  yourself and check the state of the joystick when you want joystick
 *  information.
 *
 *  The state can be one of ::SDL_QUERY, ::SDL_ENABLE or ::SDL_IGNORE.
*/
fn C.SDL_JoystickEventState(state int) int
pub fn joystick_event_state(state int) int {
	return C.SDL_JoystickEventState(state)
}

/**
 *  Get the current state of an axis control on a joystick.
 *
 *  The state is a value ranging from -32768 to 32767.
 *
 *  The axis indices start at index 0.
*/
fn C.SDL_JoystickGetAxis(joystick &C.SDL_Joystick, axis int) i16
pub fn joystick_get_axis(joystick &Joystick, axis int) i16 {
	return C.SDL_JoystickGetAxis(joystick, axis)
}

/**
 *  Get the initial state of an axis control on a joystick.
 *
 *  The state is a value ranging from -32768 to 32767.
 *
 *  The axis indices start at index 0.
 *
 *  \return SDL_TRUE if this axis has any initial value, or SDL_FALSE if not.
*/
fn C.SDL_JoystickGetAxisInitialState(joystick &C.SDL_Joystick, axis int, state &i16) bool
pub fn joystick_get_axis_initial_state(joystick &Joystick, axis int, state &i16) bool {
	return C.SDL_JoystickGetAxisInitialState(joystick, axis, state)
}

/**
 *  Get the current state of a POV hat on a joystick.
 *
 *  The hat indices start at index 0.
 *
 *  \return The return value is one of the following positions:
 *           - ::SDL_HAT_CENTERED
 *           - ::SDL_HAT_UP
 *           - ::SDL_HAT_RIGHT
 *           - ::SDL_HAT_DOWN
 *           - ::SDL_HAT_LEFT
 *           - ::SDL_HAT_RIGHTUP
 *           - ::SDL_HAT_RIGHTDOWN
 *           - ::SDL_HAT_LEFTUP
 *           - ::SDL_HAT_LEFTDOWN
*/
fn C.SDL_JoystickGetHat(joystick &C.SDL_Joystick, hat int) byte
pub fn joystick_get_hat(joystick &Joystick, hat int) byte {
	return C.SDL_JoystickGetHat(joystick, hat)
}

/**
 *  Get the ball axis change since the last poll.
 *
 *  \return 0, or -1 if you passed it invalid parameters.
 *
 *  The ball indices start at index 0.
*/
fn C.SDL_JoystickGetBall(joystick &C.SDL_Joystick, ball int, dx &int, dy &int) int
pub fn joystick_get_ball(joystick &Joystick, ball int, dx &int, dy &int) int {
	return C.SDL_JoystickGetBall(joystick, ball, dx, dy)
}

/**
 *  Get the current state of a button on a joystick.
 *
 *  The button indices start at index 0.
*/
fn C.SDL_JoystickGetButton(joystick &C.SDL_Joystick, button int) byte
pub fn joystick_get_button(joystick &Joystick, button int) byte {
	return C.SDL_JoystickGetButton(joystick, button)
}

/**
 *  Close a joystick previously opened with SDL_JoystickOpen().
*/
fn C.SDL_JoystickClose(joystick &C.SDL_Joystick)
pub fn joystick_close(joystick &Joystick) {
	C.SDL_JoystickClose(joystick)
}

/**
 *  Return the battery level of this joystick
*/
fn C.SDL_JoystickCurrentPowerLevel(joystick &C.SDL_Joystick) C.SDL_JoystickPowerLevel
pub fn joystick_current_power_level(joystick &Joystick) JoystickPowerLevel {
	return JoystickPowerLevel(int(C.SDL_JoystickCurrentPowerLevel(joystick)))
}
