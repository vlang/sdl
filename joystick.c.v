// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_joystick.h
//

// SDL joystick support.
//
// This is the lower-level joystick handling. If you want the simpler option,
// where what each button does is well-defined, you should use the gamepad API
// instead.
//
// The term "instance_id" is the current instantiation of a joystick device in
// the system, if the joystick is removed and then re-inserted then it will
// get a new instance_id, instance_id's are monotonically increasing
// identifiers of a joystick plugged in.
//
// The term "player_index" is the number assigned to a player on a specific
// controller. For XInput controllers this returns the XInput user index. Many
// joysticks will not be able to supply this information.
//
// SDL_GUID is used as a stable 128-bit identifier for a joystick device that
// does not change over time. It identifies class of the device (a X360 wired
// controller for example). This identifier is platform dependent.
//
// In order to use these functions, SDL_Init() must have been called with the
// SDL_INIT_JOYSTICK flag. This causes SDL to scan the system for joysticks,
// and load appropriate drivers.
//
// If you would like to receive joystick updates while the application is in
// the background, you should set the following hint before calling
// SDL_Init(): SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS

// This is a unique ID for a joystick for the time it is connected to the
// system, and is never reused for the lifetime of the application.
//
// If the joystick is disconnected and reconnected, it will get a new ID.
//
// The value 0 is an invalid ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type JoystickID = u32

@[noinit; typedef]
pub struct C.SDL_Joystick {
	// NOTE: Opaque type
}

pub type Joystick = C.SDL_Joystick

// JoystickType is C.SDL_JoystickType
pub enum JoystickType {
	unknown      = C.SDL_JOYSTICK_TYPE_UNKNOWN
	gamepad      = C.SDL_JOYSTICK_TYPE_GAMEPAD
	wheel        = C.SDL_JOYSTICK_TYPE_WHEEL
	arcade_stick = C.SDL_JOYSTICK_TYPE_ARCADE_STICK
	flight_stick = C.SDL_JOYSTICK_TYPE_FLIGHT_STICK
	dance_pad    = C.SDL_JOYSTICK_TYPE_DANCE_PAD
	guitar       = C.SDL_JOYSTICK_TYPE_GUITAR
	drum_kit     = C.SDL_JOYSTICK_TYPE_DRUM_KIT
	arcade_pad   = C.SDL_JOYSTICK_TYPE_ARCADE_PAD
	throttle     = C.SDL_JOYSTICK_TYPE_THROTTLE
	count        = C.SDL_JOYSTICK_TYPE_COUNT
}

// JoystickConnectionState is C.SDL_JoystickConnectionState
pub enum JoystickConnectionState {
	invalid  = C.SDL_JOYSTICK_CONNECTION_INVALID // -1,
	unknown  = C.SDL_JOYSTICK_CONNECTION_UNKNOWN
	wired    = C.SDL_JOYSTICK_CONNECTION_WIRED
	wireless = C.SDL_JOYSTICK_CONNECTION_WIRELESS
}

// The largest value an SDL_Joystick's axis can report.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_JOYSTICK_AXIS_MIN
pub const joystick_axis_max = C.SDL_JOYSTICK_AXIS_MAX // 32767

// The smallest value an SDL_Joystick's axis can report.
//
// This is a negative number!
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_JOYSTICK_AXIS_MAX
pub const joystick_axis_min = C.SDL_JOYSTICK_AXIS_MIN // -32768

// C.SDL_LockJoysticks [official documentation](https://wiki.libsdl.org/SDL3/SDL_LockJoysticks)
fn C.SDL_LockJoysticks() // TODO: HAS ... ARGS

// lock_joysticks lockings for atomic access to the joystick API.
//
// The SDL joystick functions are thread-safe, however you can lock the
// joysticks while processing to guarantee that the joystick list won't change
// and joystick and gamepad events will not be delivered.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn lock_joysticks() {
	// TODO: HAS ... ARGS
	C.SDL_LockJoysticks() // TODO: fixme HAS ARGS
}

// C.SDL_UnlockJoysticks [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnlockJoysticks)
fn C.SDL_UnlockJoysticks() // TODO: HAS ... ARGS

// unlock_joysticks unlockings for atomic access to the joystick API.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn unlock_joysticks() {
	// TODO: HAS ... ARGS
	C.SDL_UnlockJoysticks() // TODO: fixme HAS ARGS
}

// C.SDL_HasJoystick [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasJoystick)
fn C.SDL_HasJoystick() bool

// has_joystick returns whether a joystick is currently connected.
//
// returns true if a joystick is connected, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joysticks (SDL_GetJoysticks)
pub fn has_joystick() bool {
	return C.SDL_HasJoystick()
}

// C.SDL_GetJoysticks [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoysticks)
fn C.SDL_GetJoysticks(count &int) JoystickID

// get_joysticks gets a list of currently connected joysticks.
//
// `count` count a pointer filled in with the number of joysticks returned, may
//              be NULL.
// returns a 0 terminated array of joystick instance IDs or NULL on failure;
//          call SDL_GetError() for more information. This should be freed
//          with SDL_free() when it is no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_joystick (SDL_HasJoystick)
// See also: open_joystick (SDL_OpenJoystick)
pub fn get_joysticks(count &int) JoystickID {
	return C.SDL_GetJoysticks(count)
}

// C.SDL_GetJoystickNameForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickNameForID)
fn C.SDL_GetJoystickNameForID(instance_id JoystickID) &char

// get_joystick_name_for_id gets the implementation dependent name of a joystick.
//
// This can be called before any joysticks are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the name of the selected joystick. If no name can be found, this
//          function returns NULL; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_name (SDL_GetJoystickName)
// See also: get_joysticks (SDL_GetJoysticks)
pub fn get_joystick_name_for_id(instance_id JoystickID) &char {
	return C.SDL_GetJoystickNameForID(instance_id)
}

// C.SDL_GetJoystickPathForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickPathForID)
fn C.SDL_GetJoystickPathForID(instance_id JoystickID) &char

// get_joystick_path_for_id gets the implementation dependent path of a joystick.
//
// This can be called before any joysticks are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the path of the selected joystick. If no path can be found, this
//          function returns NULL; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_path (SDL_GetJoystickPath)
// See also: get_joysticks (SDL_GetJoysticks)
pub fn get_joystick_path_for_id(instance_id JoystickID) &char {
	return C.SDL_GetJoystickPathForID(instance_id)
}

// C.SDL_GetJoystickPlayerIndexForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickPlayerIndexForID)
fn C.SDL_GetJoystickPlayerIndexForID(instance_id JoystickID) int

// get_joystick_player_index_for_id gets the player index of a joystick.
//
// This can be called before any joysticks are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the player index of a joystick, or -1 if it's not available.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_player_index (SDL_GetJoystickPlayerIndex)
// See also: get_joysticks (SDL_GetJoysticks)
pub fn get_joystick_player_index_for_id(instance_id JoystickID) int {
	return C.SDL_GetJoystickPlayerIndexForID(instance_id)
}

// C.SDL_GetJoystickGUIDForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickGUIDForID)
fn C.SDL_GetJoystickGUIDForID(instance_id JoystickID) GUID

// get_joystick_guid_for_id gets the implementation-dependent GUID of a joystick.
//
// This can be called before any joysticks are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the GUID of the selected joystick. If called with an invalid
//          instance_id, this function returns a zero GUID.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_guid (SDL_GetJoystickGUID)
// See also: guid_to_string (SDL_GUIDToString)
pub fn get_joystick_guid_for_id(instance_id JoystickID) GUID {
	return C.SDL_GetJoystickGUIDForID(instance_id)
}

// C.SDL_GetJoystickVendorForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickVendorForID)
fn C.SDL_GetJoystickVendorForID(instance_id JoystickID) u16

// get_joystick_vendor_for_id gets the USB vendor ID of a joystick, if available.
//
// This can be called before any joysticks are opened. If the vendor ID isn't
// available this function returns 0.
//
// `instance_id` instance_id the joystick instance ID.
// returns the USB vendor ID of the selected joystick. If called with an
//          invalid instance_id, this function returns 0.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_vendor (SDL_GetJoystickVendor)
// See also: get_joysticks (SDL_GetJoysticks)
pub fn get_joystick_vendor_for_id(instance_id JoystickID) u16 {
	return C.SDL_GetJoystickVendorForID(instance_id)
}

// C.SDL_GetJoystickProductForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickProductForID)
fn C.SDL_GetJoystickProductForID(instance_id JoystickID) u16

// get_joystick_product_for_id gets the USB product ID of a joystick, if available.
//
// This can be called before any joysticks are opened. If the product ID isn't
// available this function returns 0.
//
// `instance_id` instance_id the joystick instance ID.
// returns the USB product ID of the selected joystick. If called with an
//          invalid instance_id, this function returns 0.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_product (SDL_GetJoystickProduct)
// See also: get_joysticks (SDL_GetJoysticks)
pub fn get_joystick_product_for_id(instance_id JoystickID) u16 {
	return C.SDL_GetJoystickProductForID(instance_id)
}

// C.SDL_GetJoystickProductVersionForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickProductVersionForID)
fn C.SDL_GetJoystickProductVersionForID(instance_id JoystickID) u16

// get_joystick_product_version_for_id gets the product version of a joystick, if available.
//
// This can be called before any joysticks are opened. If the product version
// isn't available this function returns 0.
//
// `instance_id` instance_id the joystick instance ID.
// returns the product version of the selected joystick. If called with an
//          invalid instance_id, this function returns 0.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_product_version (SDL_GetJoystickProductVersion)
// See also: get_joysticks (SDL_GetJoysticks)
pub fn get_joystick_product_version_for_id(instance_id JoystickID) u16 {
	return C.SDL_GetJoystickProductVersionForID(instance_id)
}

// C.SDL_GetJoystickTypeForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickTypeForID)
fn C.SDL_GetJoystickTypeForID(instance_id JoystickID) JoystickType

// get_joystick_type_for_id gets the type of a joystick, if available.
//
// This can be called before any joysticks are opened.
//
// `instance_id` instance_id the joystick instance ID.
// returns the SDL_JoystickType of the selected joystick. If called with an
//          invalid instance_id, this function returns
//          `SDL_JOYSTICK_TYPE_UNKNOWN`.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_type (SDL_GetJoystickType)
// See also: get_joysticks (SDL_GetJoysticks)
pub fn get_joystick_type_for_id(instance_id JoystickID) JoystickType {
	return C.SDL_GetJoystickTypeForID(instance_id)
}

// C.SDL_OpenJoystick [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenJoystick)
fn C.SDL_OpenJoystick(instance_id JoystickID) &Joystick

// open_joystick opens a joystick for use.
//
// The joystick subsystem must be initialized before a joystick can be opened
// for use.
//
// `instance_id` instance_id the joystick instance ID.
// returns a joystick identifier or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_joystick (SDL_CloseJoystick)
pub fn open_joystick(instance_id JoystickID) &Joystick {
	return C.SDL_OpenJoystick(instance_id)
}

// C.SDL_GetJoystickFromID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickFromID)
fn C.SDL_GetJoystickFromID(instance_id JoystickID) &Joystick

// get_joystick_from_id gets the SDL_Joystick associated with an instance ID, if it has been opened.
//
// `instance_id` instance_id the instance ID to get the SDL_Joystick for.
// returns an SDL_Joystick on success or NULL on failure or if it hasn't been
//          opened yet; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_joystick_from_id(instance_id JoystickID) &Joystick {
	return C.SDL_GetJoystickFromID(instance_id)
}

// C.SDL_GetJoystickFromPlayerIndex [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickFromPlayerIndex)
fn C.SDL_GetJoystickFromPlayerIndex(player_index int) &Joystick

// get_joystick_from_player_index gets the SDL_Joystick associated with a player index.
//
// `player_index` player_index the player index to get the SDL_Joystick for.
// returns an SDL_Joystick on success or NULL on failure; call SDL_GetError()
//          for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_player_index (SDL_GetJoystickPlayerIndex)
// See also: set_joystick_player_index (SDL_SetJoystickPlayerIndex)
pub fn get_joystick_from_player_index(player_index int) &Joystick {
	return C.SDL_GetJoystickFromPlayerIndex(player_index)
}

@[typedef]
pub struct C.SDL_VirtualJoystickTouchpadDesc {
pub mut:
	nfingers u16 // the number of simultaneous fingers on this touchpad
	// TODO 	padding [3]u16
}

pub type VirtualJoystickTouchpadDesc = C.SDL_VirtualJoystickTouchpadDesc

@[typedef]
pub struct C.SDL_VirtualJoystickSensorDesc {
pub mut:
	type SensorType // the type of this sensor
	rate f32        // the update frequency of this sensor, may be 0.0f
}

pub type VirtualJoystickSensorDesc = C.SDL_VirtualJoystickSensorDesc

@[typedef]
pub struct C.SDL_VirtualJoystickDesc {
pub mut:
	version    u32 // the version of this interface
	type       u16 // `SDL_JoystickType`
	padding    u16 // unused
	vendor_id  u16 // the USB vendor ID of this joystick
	product_id u16 // the USB product ID of this joystick
	naxes      u16 // the number of axes on this joystick
	nbuttons   u16 // the number of buttons on this joystick
	nballs     u16 // the number of balls on this joystick
	nhats      u16 // the number of hats on this joystick
	ntouchpads u16 // the number of touchpads on this joystick, requires `touchpads` to point at valid descriptions
	nsensors   u16 // the number of sensors on this joystick, requires `sensors` to point at valid descriptions
	// TODO 	padding2 [2]u16 // unused
	button_mask       u32 // A mask of which buttons are valid for this controller e.g. (1 << SDL_GAMEPAD_BUTTON_SOUTH)
	axis_mask         u32 // A mask of which axes are valid for this controller e.g. (1 << SDL_GAMEPAD_AXIS_LEFTX)
	name              &char                        = unsafe { nil } // the name of the joystick
	touchpads         &VirtualJoystickTouchpadDesc = unsafe { nil } // A pointer to an array of touchpad descriptions, required if `ntouchpads` is > 0
	sensors           &VirtualJoystickSensorDesc   = unsafe { nil } // A pointer to an array of sensor descriptions, required if `nsensors` is > 0
	userdata          voidptr                                 // User data pointer passed to callbacks
	Update            fn (userdata voidptr)                   // Update)(void* Called when the joystick state should be updated
	SetPlayerIndex    fn (userdata voidptr, player_index int) // SetPlayerIndex)(void* Called when the player index is set
	Rumble            fn (userdata voidptr, low_frequency_rumble u16, high_frequency_rumble u16) bool // Rumble)(void* Implements SDL_RumbleJoystick()
	RumbleTriggers    fn (userdata voidptr, left_rumble u16, right_rumble u16) bool                   // RumbleTriggers)(void* Implements SDL_RumbleJoystickTriggers()
	SetLED            fn (userdata voidptr, red u8, green u8, blue u8) bool    // SetLED)(void* Implements SDL_SetJoystickLED()
	SendEffect        fn (userdata voidptr, const_data voidptr, size int) bool // SendEffect)(void* Implements SDL_SendJoystickEffect()
	SetSensorsEnabled fn (userdata voidptr, enabled bool) bool                 // SetSensorsEnabled)(void* Implements SDL_SetGamepadSensorEnabled()
	Cleanup           fn (userdata voidptr) // Cleanup)(void* Cleans up the userdata when the joystick is detached
}

pub type VirtualJoystickDesc = C.SDL_VirtualJoystickDesc

// C.SDL_AttachVirtualJoystick [official documentation](https://wiki.libsdl.org/SDL3/SDL_AttachVirtualJoystick)
fn C.SDL_AttachVirtualJoystick(const_desc &VirtualJoystickDesc) JoystickID

// attach_virtual_joystick attachs a new virtual joystick.
//
// `desc` desc joystick description, initialized using SDL_INIT_INTERFACE().
// returns the joystick instance ID, or 0 on failure; call SDL_GetError() for
//          more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: detach_virtual_joystick (SDL_DetachVirtualJoystick)
pub fn attach_virtual_joystick(const_desc &VirtualJoystickDesc) JoystickID {
	return C.SDL_AttachVirtualJoystick(const_desc)
}

// C.SDL_DetachVirtualJoystick [official documentation](https://wiki.libsdl.org/SDL3/SDL_DetachVirtualJoystick)
fn C.SDL_DetachVirtualJoystick(instance_id JoystickID) bool

// detach_virtual_joystick detachs a virtual joystick.
//
// `instance_id` instance_id the joystick instance ID, previously returned from
//                    SDL_AttachVirtualJoystick().
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: attach_virtual_joystick (SDL_AttachVirtualJoystick)
pub fn detach_virtual_joystick(instance_id JoystickID) bool {
	return C.SDL_DetachVirtualJoystick(instance_id)
}

// C.SDL_IsJoystickVirtual [official documentation](https://wiki.libsdl.org/SDL3/SDL_IsJoystickVirtual)
fn C.SDL_IsJoystickVirtual(instance_id JoystickID) bool

// is_joystick_virtual querys whether or not a joystick is virtual.
//
// `instance_id` instance_id the joystick instance ID.
// returns true if the joystick is virtual, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn is_joystick_virtual(instance_id JoystickID) bool {
	return C.SDL_IsJoystickVirtual(instance_id)
}

// C.SDL_SetJoystickVirtualAxis [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetJoystickVirtualAxis)
fn C.SDL_SetJoystickVirtualAxis(joystick &Joystick, axis int, value i16) bool

// set_joystick_virtual_axis sets the state of an axis on an opened virtual joystick.
//
// Please note that values set here will not be applied until the next call to
// SDL_UpdateJoysticks, which can either be called directly, or can be called
// indirectly through various other SDL APIs, including, but not limited to
// the following: SDL_PollEvent, SDL_PumpEvents, SDL_WaitEventTimeout,
// SDL_WaitEvent.
//
// Note that when sending trigger axes, you should scale the value to the full
// range of Sint16. For example, a trigger at rest would have the value of
// `SDL_JOYSTICK_AXIS_MIN`.
//
// `joystick` joystick the virtual joystick on which to set state.
// `axis` axis the index of the axis on the virtual joystick to update.
// `value` value the new value for the specified axis.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_joystick_virtual_axis(joystick &Joystick, axis int, value i16) bool {
	return C.SDL_SetJoystickVirtualAxis(joystick, axis, value)
}

// C.SDL_SetJoystickVirtualBall [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetJoystickVirtualBall)
fn C.SDL_SetJoystickVirtualBall(joystick &Joystick, ball int, xrel i16, yrel i16) bool

// set_joystick_virtual_ball generates ball motion on an opened virtual joystick.
//
// Please note that values set here will not be applied until the next call to
// SDL_UpdateJoysticks, which can either be called directly, or can be called
// indirectly through various other SDL APIs, including, but not limited to
// the following: SDL_PollEvent, SDL_PumpEvents, SDL_WaitEventTimeout,
// SDL_WaitEvent.
//
// `joystick` joystick the virtual joystick on which to set state.
// `ball` ball the index of the ball on the virtual joystick to update.
// `xrel` xrel the relative motion on the X axis.
// `yrel` yrel the relative motion on the Y axis.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_joystick_virtual_ball(joystick &Joystick, ball int, xrel i16, yrel i16) bool {
	return C.SDL_SetJoystickVirtualBall(joystick, ball, xrel, yrel)
}

// C.SDL_SetJoystickVirtualButton [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetJoystickVirtualButton)
fn C.SDL_SetJoystickVirtualButton(joystick &Joystick, button int, down bool) bool

// set_joystick_virtual_button sets the state of a button on an opened virtual joystick.
//
// Please note that values set here will not be applied until the next call to
// SDL_UpdateJoysticks, which can either be called directly, or can be called
// indirectly through various other SDL APIs, including, but not limited to
// the following: SDL_PollEvent, SDL_PumpEvents, SDL_WaitEventTimeout,
// SDL_WaitEvent.
//
// `joystick` joystick the virtual joystick on which to set state.
// `button` button the index of the button on the virtual joystick to update.
// `down` down true if the button is pressed, false otherwise.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_joystick_virtual_button(joystick &Joystick, button int, down bool) bool {
	return C.SDL_SetJoystickVirtualButton(joystick, button, down)
}

// C.SDL_SetJoystickVirtualHat [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetJoystickVirtualHat)
fn C.SDL_SetJoystickVirtualHat(joystick &Joystick, hat int, value u8) bool

// set_joystick_virtual_hat sets the state of a hat on an opened virtual joystick.
//
// Please note that values set here will not be applied until the next call to
// SDL_UpdateJoysticks, which can either be called directly, or can be called
// indirectly through various other SDL APIs, including, but not limited to
// the following: SDL_PollEvent, SDL_PumpEvents, SDL_WaitEventTimeout,
// SDL_WaitEvent.
//
// `joystick` joystick the virtual joystick on which to set state.
// `hat` hat the index of the hat on the virtual joystick to update.
// `value` value the new value for the specified hat.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_joystick_virtual_hat(joystick &Joystick, hat int, value u8) bool {
	return C.SDL_SetJoystickVirtualHat(joystick, hat, value)
}

// C.SDL_SetJoystickVirtualTouchpad [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetJoystickVirtualTouchpad)
fn C.SDL_SetJoystickVirtualTouchpad(joystick &Joystick, touchpad int, finger int, down bool, x f32, y f32, pressure f32) bool

// set_joystick_virtual_touchpad sets touchpad finger state on an opened virtual joystick.
//
// Please note that values set here will not be applied until the next call to
// SDL_UpdateJoysticks, which can either be called directly, or can be called
// indirectly through various other SDL APIs, including, but not limited to
// the following: SDL_PollEvent, SDL_PumpEvents, SDL_WaitEventTimeout,
// SDL_WaitEvent.
//
// `joystick` joystick the virtual joystick on which to set state.
// `touchpad` touchpad the index of the touchpad on the virtual joystick to
//                 update.
// `finger` finger the index of the finger on the touchpad to set.
// `down` down true if the finger is pressed, false if the finger is released.
// `x` x the x coordinate of the finger on the touchpad, normalized 0 to 1,
//          with the origin in the upper left.
// `y` y the y coordinate of the finger on the touchpad, normalized 0 to 1,
//          with the origin in the upper left.
// `pressure` pressure the pressure of the finger.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_joystick_virtual_touchpad(joystick &Joystick, touchpad int, finger int, down bool, x f32, y f32, pressure f32) bool {
	return C.SDL_SetJoystickVirtualTouchpad(joystick, touchpad, finger, down, x, y, pressure)
}

// C.SDL_SendJoystickVirtualSensorData [official documentation](https://wiki.libsdl.org/SDL3/SDL_SendJoystickVirtualSensorData)
fn C.SDL_SendJoystickVirtualSensorData(joystick &Joystick, typ SensorType, sensor_timestamp u64, const_data &f32, num_values int) bool

// send_joystick_virtual_sensor_data sends a sensor update for an opened virtual joystick.
//
// Please note that values set here will not be applied until the next call to
// SDL_UpdateJoysticks, which can either be called directly, or can be called
// indirectly through various other SDL APIs, including, but not limited to
// the following: SDL_PollEvent, SDL_PumpEvents, SDL_WaitEventTimeout,
// SDL_WaitEvent.
//
// `joystick` joystick the virtual joystick on which to set state.
// `type` type the type of the sensor on the virtual joystick to update.
// `sensor_timestamp` sensor_timestamp a 64-bit timestamp in nanoseconds associated with
//                         the sensor reading.
// `data` data the data associated with the sensor reading.
// `num_values` num_values the number of values pointed to by `data`.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn send_joystick_virtual_sensor_data(joystick &Joystick, typ SensorType, sensor_timestamp u64, const_data &f32, num_values int) bool {
	return C.SDL_SendJoystickVirtualSensorData(joystick, typ, sensor_timestamp, const_data,
		num_values)
}

// C.SDL_GetJoystickProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickProperties)
fn C.SDL_GetJoystickProperties(joystick &Joystick) PropertiesID

// get_joystick_properties gets the properties associated with a joystick.
//
// The following read-only properties are provided by SDL:
//
// - `SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN`: true if this joystick has an
//   LED that has adjustable brightness
// - `SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN`: true if this joystick has an LED
//   that has adjustable color
// - `SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN`: true if this joystick has a
//   player LED
// - `SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN`: true if this joystick has
//   left/right rumble
// - `SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN`: true if this joystick has
//   simple trigger rumble
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_joystick_properties(joystick &Joystick) PropertiesID {
	return C.SDL_GetJoystickProperties(joystick)
}

pub const prop_joystick_cap_mono_led_boolean = C.SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN // 'SDL.joystick.cap.mono_led'

pub const prop_joystick_cap_rgb_led_boolean = C.SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN // 'SDL.joystick.cap.rgb_led'

pub const prop_joystick_cap_player_led_boolean = C.SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN // 'SDL.joystick.cap.player_led'

pub const prop_joystick_cap_rumble_boolean = C.SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN // 'SDL.joystick.cap.rumble'

pub const prop_joystick_cap_trigger_rumble_boolean = C.SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN // 'SDL.joystick.cap.trigger_rumble'

// C.SDL_GetJoystickName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickName)
fn C.SDL_GetJoystickName(joystick &Joystick) &char

// get_joystick_name gets the implementation dependent name of a joystick.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns the name of the selected joystick. If no name can be found, this
//          function returns NULL; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_name_for_id (SDL_GetJoystickNameForID)
pub fn get_joystick_name(joystick &Joystick) &char {
	return C.SDL_GetJoystickName(joystick)
}

// C.SDL_GetJoystickPath [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickPath)
fn C.SDL_GetJoystickPath(joystick &Joystick) &char

// get_joystick_path gets the implementation dependent path of a joystick.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns the path of the selected joystick. If no path can be found, this
//          function returns NULL; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_path_for_id (SDL_GetJoystickPathForID)
pub fn get_joystick_path(joystick &Joystick) &char {
	return C.SDL_GetJoystickPath(joystick)
}

// C.SDL_GetJoystickPlayerIndex [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickPlayerIndex)
fn C.SDL_GetJoystickPlayerIndex(joystick &Joystick) int

// get_joystick_player_index gets the player index of an opened joystick.
//
// For XInput controllers this returns the XInput user index. Many joysticks
// will not be able to supply this information.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns the player index, or -1 if it's not available.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_joystick_player_index (SDL_SetJoystickPlayerIndex)
pub fn get_joystick_player_index(joystick &Joystick) int {
	return C.SDL_GetJoystickPlayerIndex(joystick)
}

// C.SDL_SetJoystickPlayerIndex [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetJoystickPlayerIndex)
fn C.SDL_SetJoystickPlayerIndex(joystick &Joystick, player_index int) bool

// set_joystick_player_index sets the player index of an opened joystick.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// `player_index` player_index player index to assign to this joystick, or -1 to clear
//                     the player index and turn off player LEDs.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_player_index (SDL_GetJoystickPlayerIndex)
pub fn set_joystick_player_index(joystick &Joystick, player_index int) bool {
	return C.SDL_SetJoystickPlayerIndex(joystick, player_index)
}

// C.SDL_GetJoystickGUID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickGUID)
fn C.SDL_GetJoystickGUID(joystick &Joystick) GUID

// get_joystick_guid gets the implementation-dependent GUID for the joystick.
//
// This function requires an open joystick.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns the GUID of the given joystick. If called on an invalid index,
//          this function returns a zero GUID; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_guid_for_id (SDL_GetJoystickGUIDForID)
// See also: guid_to_string (SDL_GUIDToString)
pub fn get_joystick_guid(joystick &Joystick) GUID {
	return C.SDL_GetJoystickGUID(joystick)
}

// C.SDL_GetJoystickVendor [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickVendor)
fn C.SDL_GetJoystickVendor(joystick &Joystick) u16

// get_joystick_vendor gets the USB vendor ID of an opened joystick, if available.
//
// If the vendor ID isn't available this function returns 0.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns the USB vendor ID of the selected joystick, or 0 if unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_vendor_for_id (SDL_GetJoystickVendorForID)
pub fn get_joystick_vendor(joystick &Joystick) u16 {
	return C.SDL_GetJoystickVendor(joystick)
}

// C.SDL_GetJoystickProduct [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickProduct)
fn C.SDL_GetJoystickProduct(joystick &Joystick) u16

// get_joystick_product gets the USB product ID of an opened joystick, if available.
//
// If the product ID isn't available this function returns 0.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns the USB product ID of the selected joystick, or 0 if unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_product_for_id (SDL_GetJoystickProductForID)
pub fn get_joystick_product(joystick &Joystick) u16 {
	return C.SDL_GetJoystickProduct(joystick)
}

// C.SDL_GetJoystickProductVersion [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickProductVersion)
fn C.SDL_GetJoystickProductVersion(joystick &Joystick) u16

// get_joystick_product_version gets the product version of an opened joystick, if available.
//
// If the product version isn't available this function returns 0.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns the product version of the selected joystick, or 0 if unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_product_version_for_id (SDL_GetJoystickProductVersionForID)
pub fn get_joystick_product_version(joystick &Joystick) u16 {
	return C.SDL_GetJoystickProductVersion(joystick)
}

// C.SDL_GetJoystickFirmwareVersion [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickFirmwareVersion)
fn C.SDL_GetJoystickFirmwareVersion(joystick &Joystick) u16

// get_joystick_firmware_version gets the firmware version of an opened joystick, if available.
//
// If the firmware version isn't available this function returns 0.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns the firmware version of the selected joystick, or 0 if
//          unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_joystick_firmware_version(joystick &Joystick) u16 {
	return C.SDL_GetJoystickFirmwareVersion(joystick)
}

// C.SDL_GetJoystickSerial [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickSerial)
fn C.SDL_GetJoystickSerial(joystick &Joystick) &char

// get_joystick_serial gets the serial number of an opened joystick, if available.
//
// Returns the serial number of the joystick, or NULL if it is not available.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns the serial number of the selected joystick, or NULL if
//          unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_joystick_serial(joystick &Joystick) &char {
	return C.SDL_GetJoystickSerial(joystick)
}

// C.SDL_GetJoystickType [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickType)
fn C.SDL_GetJoystickType(joystick &Joystick) JoystickType

// get_joystick_type gets the type of an opened joystick.
//
// `joystick` joystick the SDL_Joystick obtained from SDL_OpenJoystick().
// returns the SDL_JoystickType of the selected joystick.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_type_for_id (SDL_GetJoystickTypeForID)
pub fn get_joystick_type(joystick &Joystick) JoystickType {
	return C.SDL_GetJoystickType(joystick)
}

// C.SDL_GetJoystickGUIDInfo [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickGUIDInfo)
fn C.SDL_GetJoystickGUIDInfo(guid GUID, vendor &u16, product &u16, version &u16, crc16 &u16)

// get_joystick_guid_info gets the device information encoded in a SDL_GUID structure.
//
// `guid` guid the SDL_GUID you wish to get info about.
// `vendor` vendor a pointer filled in with the device VID, or 0 if not
//               available.
// `product` product a pointer filled in with the device PID, or 0 if not
//                available.
// `version` version a pointer filled in with the device version, or 0 if not
//                available.
// `crc16` crc16 a pointer filled in with a CRC used to distinguish different
//              products with the same VID/PID, or 0 if not available.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_guid_for_id (SDL_GetJoystickGUIDForID)
pub fn get_joystick_guid_info(guid GUID, vendor &u16, product &u16, version &u16, crc16 &u16) {
	C.SDL_GetJoystickGUIDInfo(guid, vendor, product, version, crc16)
}

// C.SDL_JoystickConnected [official documentation](https://wiki.libsdl.org/SDL3/SDL_JoystickConnected)
fn C.SDL_JoystickConnected(joystick &Joystick) bool

// joystick_connected gets the status of a specified joystick.
//
// `joystick` joystick the joystick to query.
// returns true if the joystick has been opened, false if it has not; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn joystick_connected(joystick &Joystick) bool {
	return C.SDL_JoystickConnected(joystick)
}

// C.SDL_GetJoystickID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickID)
fn C.SDL_GetJoystickID(joystick &Joystick) JoystickID

// get_joystick_id gets the instance ID of an opened joystick.
//
// `joystick` joystick an SDL_Joystick structure containing joystick information.
// returns the instance ID of the specified joystick on success or 0 on
//          failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_joystick_id(joystick &Joystick) JoystickID {
	return C.SDL_GetJoystickID(joystick)
}

// C.SDL_GetNumJoystickAxes [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumJoystickAxes)
fn C.SDL_GetNumJoystickAxes(joystick &Joystick) int

// get_num_joystick_axes gets the number of general axis controls on a joystick.
//
// Often, the directional pad on a game controller will either look like 4
// separate buttons or a POV hat, and not axes, but all of this is up to the
// device and platform.
//
// `joystick` joystick an SDL_Joystick structure containing joystick information.
// returns the number of axis controls/number of axes on success or -1 on
//          failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_axis (SDL_GetJoystickAxis)
// See also: get_num_joystick_balls (SDL_GetNumJoystickBalls)
// See also: get_num_joystick_buttons (SDL_GetNumJoystickButtons)
// See also: get_num_joystick_hats (SDL_GetNumJoystickHats)
pub fn get_num_joystick_axes(joystick &Joystick) int {
	return C.SDL_GetNumJoystickAxes(joystick)
}

// C.SDL_GetNumJoystickBalls [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumJoystickBalls)
fn C.SDL_GetNumJoystickBalls(joystick &Joystick) int

// get_num_joystick_balls gets the number of trackballs on a joystick.
//
// Joystick trackballs have only relative motion events associated with them
// and their state cannot be polled.
//
// Most joysticks do not have trackballs.
//
// `joystick` joystick an SDL_Joystick structure containing joystick information.
// returns the number of trackballs on success or -1 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_ball (SDL_GetJoystickBall)
// See also: get_num_joystick_axes (SDL_GetNumJoystickAxes)
// See also: get_num_joystick_buttons (SDL_GetNumJoystickButtons)
// See also: get_num_joystick_hats (SDL_GetNumJoystickHats)
pub fn get_num_joystick_balls(joystick &Joystick) int {
	return C.SDL_GetNumJoystickBalls(joystick)
}

// C.SDL_GetNumJoystickHats [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumJoystickHats)
fn C.SDL_GetNumJoystickHats(joystick &Joystick) int

// get_num_joystick_hats gets the number of POV hats on a joystick.
//
// `joystick` joystick an SDL_Joystick structure containing joystick information.
// returns the number of POV hats on success or -1 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_hat (SDL_GetJoystickHat)
// See also: get_num_joystick_axes (SDL_GetNumJoystickAxes)
// See also: get_num_joystick_balls (SDL_GetNumJoystickBalls)
// See also: get_num_joystick_buttons (SDL_GetNumJoystickButtons)
pub fn get_num_joystick_hats(joystick &Joystick) int {
	return C.SDL_GetNumJoystickHats(joystick)
}

// C.SDL_GetNumJoystickButtons [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumJoystickButtons)
fn C.SDL_GetNumJoystickButtons(joystick &Joystick) int

// get_num_joystick_buttons gets the number of buttons on a joystick.
//
// `joystick` joystick an SDL_Joystick structure containing joystick information.
// returns the number of buttons on success or -1 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_joystick_button (SDL_GetJoystickButton)
// See also: get_num_joystick_axes (SDL_GetNumJoystickAxes)
// See also: get_num_joystick_balls (SDL_GetNumJoystickBalls)
// See also: get_num_joystick_hats (SDL_GetNumJoystickHats)
pub fn get_num_joystick_buttons(joystick &Joystick) int {
	return C.SDL_GetNumJoystickButtons(joystick)
}

// C.SDL_SetJoystickEventsEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetJoystickEventsEnabled)
fn C.SDL_SetJoystickEventsEnabled(enabled bool)

// set_joystick_events_enabled sets the state of joystick event processing.
//
// If joystick events are disabled, you must call SDL_UpdateJoysticks()
// yourself and check the state of the joystick when you want joystick
// information.
//
// `enabled` enabled whether to process joystick events or not.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: joystick_events_enabled (SDL_JoystickEventsEnabled)
// See also: update_joysticks (SDL_UpdateJoysticks)
pub fn set_joystick_events_enabled(enabled bool) {
	C.SDL_SetJoystickEventsEnabled(enabled)
}

// C.SDL_JoystickEventsEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_JoystickEventsEnabled)
fn C.SDL_JoystickEventsEnabled() bool

// joystick_events_enabled querys the state of joystick event processing.
//
// If joystick events are disabled, you must call SDL_UpdateJoysticks()
// yourself and check the state of the joystick when you want joystick
// information.
//
// returns true if joystick events are being processed, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_joystick_events_enabled (SDL_SetJoystickEventsEnabled)
pub fn joystick_events_enabled() bool {
	return C.SDL_JoystickEventsEnabled()
}

// C.SDL_UpdateJoysticks [official documentation](https://wiki.libsdl.org/SDL3/SDL_UpdateJoysticks)
fn C.SDL_UpdateJoysticks()

// update_joysticks updates the current state of the open joysticks.
//
// This is called automatically by the event loop if any joystick events are
// enabled.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn update_joysticks() {
	C.SDL_UpdateJoysticks()
}

// C.SDL_GetJoystickAxis [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickAxis)
fn C.SDL_GetJoystickAxis(joystick &Joystick, axis int) i16

// get_joystick_axis gets the current state of an axis control on a joystick.
//
// SDL makes no promises about what part of the joystick any given axis refers
// to. Your game should have some sort of configuration UI to let users
// specify what each axis should be bound to. Alternately, SDL's higher-level
// Game Controller API makes a great effort to apply order to this lower-level
// interface, so you know that a specific axis is the "left thumb stick," etc.
//
// The value returned by SDL_GetJoystickAxis() is a signed integer (-32768 to
// 32767) representing the current position of the axis. It may be necessary
// to impose certain tolerances on these values to account for jitter.
//
// `joystick` joystick an SDL_Joystick structure containing joystick information.
// `axis` axis the axis to query; the axis indices start at index 0.
// returns a 16-bit signed integer representing the current position of the
//          axis or 0 on failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_joystick_axes (SDL_GetNumJoystickAxes)
pub fn get_joystick_axis(joystick &Joystick, axis int) i16 {
	return C.SDL_GetJoystickAxis(joystick, axis)
}

// C.SDL_GetJoystickAxisInitialState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickAxisInitialState)
fn C.SDL_GetJoystickAxisInitialState(joystick &Joystick, axis int, state &i16) bool

// get_joystick_axis_initial_state gets the initial state of an axis control on a joystick.
//
// The state is a value ranging from -32768 to 32767.
//
// The axis indices start at index 0.
//
// `joystick` joystick an SDL_Joystick structure containing joystick information.
// `axis` axis the axis to query; the axis indices start at index 0.
// `state` state upon return, the initial value is supplied here.
// returns true if this axis has any initial value, or false if not.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_joystick_axis_initial_state(joystick &Joystick, axis int, state &i16) bool {
	return C.SDL_GetJoystickAxisInitialState(joystick, axis, state)
}

// C.SDL_GetJoystickBall [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickBall)
fn C.SDL_GetJoystickBall(joystick &Joystick, ball int, dx &int, dy &int) bool

// get_joystick_ball gets the ball axis change since the last poll.
//
// Trackballs can only return relative motion since the last call to
// SDL_GetJoystickBall(), these motion deltas are placed into `dx` and `dy`.
//
// Most joysticks do not have trackballs.
//
// `joystick` joystick the SDL_Joystick to query.
// `ball` ball the ball index to query; ball indices start at index 0.
// `dx` dx stores the difference in the x axis position since the last poll.
// `dy` dy stores the difference in the y axis position since the last poll.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_joystick_balls (SDL_GetNumJoystickBalls)
pub fn get_joystick_ball(joystick &Joystick, ball int, dx &int, dy &int) bool {
	return C.SDL_GetJoystickBall(joystick, ball, dx, dy)
}

// C.SDL_GetJoystickHat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickHat)
fn C.SDL_GetJoystickHat(joystick &Joystick, hat int) u8

// get_joystick_hat gets the current state of a POV hat on a joystick.
//
// The returned value will be one of the `SDL_HAT_*` values.
//
// `joystick` joystick an SDL_Joystick structure containing joystick information.
// `hat` hat the hat index to get the state from; indices start at index 0.
// returns the current hat position.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_joystick_hats (SDL_GetNumJoystickHats)
pub fn get_joystick_hat(joystick &Joystick, hat int) u8 {
	return C.SDL_GetJoystickHat(joystick, hat)
}

pub const hat_centered = C.SDL_HAT_CENTERED // 0x00u

pub const hat_up = C.SDL_HAT_UP // 0x01u

pub const hat_right = C.SDL_HAT_RIGHT // 0x02u

pub const hat_down = C.SDL_HAT_DOWN // 0x04u

pub const hat_left = C.SDL_HAT_LEFT // 0x08u

pub const hat_rightup = C.SDL_HAT_RIGHTUP // (SDL_HAT_RIGHT|SDL_HAT_UP)

pub const hat_rightdown = C.SDL_HAT_RIGHTDOWN // (SDL_HAT_RIGHT|SDL_HAT_DOWN)

pub const hat_leftup = C.SDL_HAT_LEFTUP // (SDL_HAT_LEFT|SDL_HAT_UP)

pub const hat_leftdown = C.SDL_HAT_LEFTDOWN // (SDL_HAT_LEFT|SDL_HAT_DOWN)

// C.SDL_GetJoystickButton [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickButton)
fn C.SDL_GetJoystickButton(joystick &Joystick, button int) bool

// get_joystick_button gets the current state of a button on a joystick.
//
// `joystick` joystick an SDL_Joystick structure containing joystick information.
// `button` button the button index to get the state from; indices start at
//               index 0.
// returns true if the button is pressed, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_joystick_buttons (SDL_GetNumJoystickButtons)
pub fn get_joystick_button(joystick &Joystick, button int) bool {
	return C.SDL_GetJoystickButton(joystick, button)
}

// C.SDL_RumbleJoystick [official documentation](https://wiki.libsdl.org/SDL3/SDL_RumbleJoystick)
fn C.SDL_RumbleJoystick(joystick &Joystick, low_frequency_rumble u16, high_frequency_rumble u16, duration_ms u32) bool

// rumble_joystick starts a rumble effect.
//
// Each call to this function cancels any previous rumble effect, and calling
// it with 0 intensity stops any rumbling.
//
// This function requires you to process SDL events or call
// SDL_UpdateJoysticks() to update rumble state.
//
// `joystick` joystick the joystick to vibrate.
// `low_frequency_rumble` low_frequency_rumble the intensity of the low frequency (left)
//                             rumble motor, from 0 to 0xFFFF.
// `high_frequency_rumble` high_frequency_rumble the intensity of the high frequency (right)
//                              rumble motor, from 0 to 0xFFFF.
// `duration_ms` duration_ms the duration of the rumble effect, in milliseconds.
// returns true, or false if rumble isn't supported on this joystick.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn rumble_joystick(joystick &Joystick, low_frequency_rumble u16, high_frequency_rumble u16, duration_ms u32) bool {
	return C.SDL_RumbleJoystick(joystick, low_frequency_rumble, high_frequency_rumble,
		duration_ms)
}

// C.SDL_RumbleJoystickTriggers [official documentation](https://wiki.libsdl.org/SDL3/SDL_RumbleJoystickTriggers)
fn C.SDL_RumbleJoystickTriggers(joystick &Joystick, left_rumble u16, right_rumble u16, duration_ms u32) bool

// rumble_joystick_triggers starts a rumble effect in the joystick's triggers.
//
// Each call to this function cancels any previous trigger rumble effect, and
// calling it with 0 intensity stops any rumbling.
//
// Note that this is rumbling of the _triggers_ and not the game controller as
// a whole. This is currently only supported on Xbox One controllers. If you
// want the (more common) whole-controller rumble, use SDL_RumbleJoystick()
// instead.
//
// This function requires you to process SDL events or call
// SDL_UpdateJoysticks() to update rumble state.
//
// `joystick` joystick the joystick to vibrate.
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
// See also: rumble_joystick (SDL_RumbleJoystick)
pub fn rumble_joystick_triggers(joystick &Joystick, left_rumble u16, right_rumble u16, duration_ms u32) bool {
	return C.SDL_RumbleJoystickTriggers(joystick, left_rumble, right_rumble, duration_ms)
}

// C.SDL_SetJoystickLED [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetJoystickLED)
fn C.SDL_SetJoystickLED(joystick &Joystick, red u8, green u8, blue u8) bool

// set_joystick_led updates a joystick's LED color.
//
// An example of a joystick LED is the light on the back of a PlayStation 4's
// DualShock 4 controller.
//
// For joysticks with a single color LED, the maximum of the RGB values will
// be used as the LED brightness.
//
// `joystick` joystick the joystick to update.
// `red` red the intensity of the red LED.
// `green` green the intensity of the green LED.
// `blue` blue the intensity of the blue LED.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_joystick_led(joystick &Joystick, red u8, green u8, blue u8) bool {
	return C.SDL_SetJoystickLED(joystick, red, green, blue)
}

// C.SDL_SendJoystickEffect [official documentation](https://wiki.libsdl.org/SDL3/SDL_SendJoystickEffect)
fn C.SDL_SendJoystickEffect(joystick &Joystick, const_data voidptr, size int) bool

// send_joystick_effect sends a joystick specific effect packet.
//
// `joystick` joystick the joystick to affect.
// `data` data the data to send to the joystick.
// `size` size the size of the data to send to the joystick.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn send_joystick_effect(joystick &Joystick, const_data voidptr, size int) bool {
	return C.SDL_SendJoystickEffect(joystick, const_data, size)
}

// C.SDL_CloseJoystick [official documentation](https://wiki.libsdl.org/SDL3/SDL_CloseJoystick)
fn C.SDL_CloseJoystick(joystick &Joystick)

// close_joystick closes a joystick previously opened with SDL_OpenJoystick().
//
// `joystick` joystick the joystick device to close.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_joystick (SDL_OpenJoystick)
pub fn close_joystick(joystick &Joystick) {
	C.SDL_CloseJoystick(joystick)
}

// C.SDL_GetJoystickConnectionState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickConnectionState)
fn C.SDL_GetJoystickConnectionState(joystick &Joystick) JoystickConnectionState

// get_joystick_connection_state gets the connection state of a joystick.
//
// `joystick` joystick the joystick to query.
// returns the connection state on success or
//          `SDL_JOYSTICK_CONNECTION_INVALID` on failure; call SDL_GetError()
//          for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_joystick_connection_state(joystick &Joystick) JoystickConnectionState {
	return C.SDL_GetJoystickConnectionState(joystick)
}

// C.SDL_GetJoystickPowerInfo [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetJoystickPowerInfo)
fn C.SDL_GetJoystickPowerInfo(joystick &Joystick, percent &int) PowerState

// get_joystick_power_info gets the battery state of a joystick.
//
// You should never take a battery status as absolute truth. Batteries
// (especially failing batteries) are delicate hardware, and the values
// reported here are best estimates based on what that hardware reports. It's
// not uncommon for older batteries to lose stored power much faster than it
// reports, or completely drain when reporting it has 20 percent left, etc.
//
// `joystick` joystick the joystick to query.
// `percent` percent a pointer filled in with the percentage of battery life
//                left, between 0 and 100, or NULL to ignore. This will be
//                filled in with -1 we can't determine a value or there is no
//                battery.
// returns the current battery state or `SDL_POWERSTATE_ERROR` on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_joystick_power_info(joystick &Joystick, percent &int) PowerState {
	return C.SDL_GetJoystickPowerInfo(joystick, percent)
}
