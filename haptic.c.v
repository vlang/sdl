// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_haptic.h
//

// The SDL haptic subsystem manages haptic (force feedback) devices.
//
// The basic usage is as follows:
//
// - Initialize the subsystem (SDL_INIT_HAPTIC).
// - Open a haptic device.
// - SDL_OpenHaptic() to open from index.
// - SDL_OpenHapticFromJoystick() to open from an existing joystick.
// - Create an effect (SDL_HapticEffect).
// - Upload the effect with SDL_CreateHapticEffect().
// - Run the effect with SDL_RunHapticEffect().
// - (optional) Free the effect with SDL_DestroyHapticEffect().
// - Close the haptic device with SDL_CloseHaptic().
//
// Simple rumble example:
//
// ```c
//    SDL_Haptic *haptic = NULL;
//
//    // Open the device
//    SDL_HapticID *haptics = SDL_GetHaptics(NULL);
//    if (haptics) {
//        haptic = SDL_OpenHaptic(haptics[0]);
//        SDL_free(haptics);
//    }
//    if (haptic == NULL)
//       return;
//
//    // Initialize simple rumble
//    if (!SDL_InitHapticRumble(haptic))
//       return;
//
//    // Play effect at 50% strength for 2 seconds
//    if (!SDL_PlayHapticRumble(haptic, 0.5, 2000))
//       return;
//    SDL_Delay(2000);
//
//    // Clean up
//    SDL_CloseHaptic(haptic);
// ```
//
// Complete example:
//
// ```c
// bool test_haptic(SDL_Joystick *joystick)
// {
//    SDL_Haptic *haptic;
//    SDL_HapticEffect effect;
//    int effect_id;
//
//    // Open the device
//    haptic = SDL_OpenHapticFromJoystick(joystick);
//    if (haptic == NULL) return false; // Most likely joystick isn't haptic
//
//    // See if it can do sine waves
//    if ((SDL_GetHapticFeatures(haptic) & SDL_HAPTIC_SINE)==0) {
//       SDL_CloseHaptic(haptic); // No sine effect
//       return false;
//    }
//
//    // Create the effect
//    SDL_memset(&effect, 0, sizeof(SDL_HapticEffect)); // 0 is safe default
//    effect.type = SDL_HAPTIC_SINE;
//    effect.periodic.direction.type = SDL_HAPTIC_POLAR; // Polar coordinates
//    effect.periodic.direction.dir[0] = 18000; // Force comes from south
//    effect.periodic.period = 1000; // 1000 ms
//    effect.periodic.magnitude = 20000; // 20000/32767 strength
//    effect.periodic.length = 5000; // 5 seconds long
//    effect.periodic.attack_length = 1000; // Takes 1 second to get max strength
//    effect.periodic.fade_length = 1000; // Takes 1 second to fade away
//
//    // Upload the effect
//    effect_id = SDL_CreateHapticEffect(haptic, &effect);
//
//    // Test the effect
//    SDL_RunHapticEffect(haptic, effect_id, 1);
//    SDL_Delay(5000); // Wait for the effect to finish
//
//    // We destroy the effect, although closing the device also does this
//    SDL_DestroyHapticEffect(haptic, effect_id);
//
//    // Close the device
//    SDL_CloseHaptic(haptic);
//
//    return true; // Success
// }
// ```
//
// Note that the SDL haptic subsystem is not thread-safe.

// This is a unique ID for a haptic device for the time it is connected to the
// system, and is never reused for the lifetime of the application.
//
// If the haptic device is disconnected and reconnected, it will get a new ID.
//
// The value 0 is an invalid ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type HapticID = u32

@[noinit; typedef]
pub struct C.SDL_Haptic {
	// NOTE: Opaque type
}

pub type Haptic = C.SDL_Haptic

pub const haptic_constant = C.SDL_HAPTIC_CONSTANT // (1u<<0)

pub const haptic_sine = C.SDL_HAPTIC_SINE // (1u<<1)

pub const haptic_square = C.SDL_HAPTIC_SQUARE // (1u<<2)

pub const haptic_triangle = C.SDL_HAPTIC_TRIANGLE // (1u<<3)

pub const haptic_sawtoothup = C.SDL_HAPTIC_SAWTOOTHUP // (1u<<4)

pub const haptic_sawtoothdown = C.SDL_HAPTIC_SAWTOOTHDOWN // (1u<<5)

pub const haptic_ramp = C.SDL_HAPTIC_RAMP // (1u<<6)

pub const haptic_spring = C.SDL_HAPTIC_SPRING // (1u<<7)

pub const haptic_damper = C.SDL_HAPTIC_DAMPER // (1u<<8)

pub const haptic_inertia = C.SDL_HAPTIC_INERTIA // (1u<<9)

pub const haptic_friction = C.SDL_HAPTIC_FRICTION // (1u<<10)

pub const haptic_leftright = C.SDL_HAPTIC_LEFTRIGHT // (1u<<11)

pub const haptic_reserved1 = C.SDL_HAPTIC_RESERVED1 // (1u<<12)

pub const haptic_reserved2 = C.SDL_HAPTIC_RESERVED2 // (1u<<13)

pub const haptic_reserved3 = C.SDL_HAPTIC_RESERVED3 // (1u<<14)

pub const haptic_custom = C.SDL_HAPTIC_CUSTOM // (1u<<15)

pub const haptic_gain = C.SDL_HAPTIC_GAIN // (1u<<16)

pub const haptic_autocenter = C.SDL_HAPTIC_AUTOCENTER // (1u<<17)

pub const haptic_status = C.SDL_HAPTIC_STATUS // (1u<<18)

pub const haptic_pause = C.SDL_HAPTIC_PAUSE // (1u<<19)

// Uses polar coordinates for the direction.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_HapticDirection
pub const haptic_polar = C.SDL_HAPTIC_POLAR // 0

// Uses cartesian coordinates for the direction.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_HapticDirection
pub const haptic_cartesian = C.SDL_HAPTIC_CARTESIAN // 1

// Uses spherical coordinates for the direction.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_HapticDirection
pub const haptic_spherical = C.SDL_HAPTIC_SPHERICAL // 2

// Use this value to play an effect on the steering wheel axis.
//
// This provides better compatibility across platforms and devices as SDL will
// guess the correct axis.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_HapticDirection
pub const haptic_steering_axis = C.SDL_HAPTIC_STEERING_AXIS // 3

pub const haptic_infinity = C.SDL_HAPTIC_INFINITY // 4294967295U

@[typedef]
pub struct C.SDL_HapticDirection {
pub mut:
	type u8     // The type of encoding.
	dir  [3]i32 // The encoded direction.
}

pub type HapticDirection = C.SDL_HapticDirection

// C.SDL_HapticConstant [official documentation](https://wiki.libsdl.org/SDL3/SDL_HapticConstant)
@[typedef]
pub struct C.SDL_HapticConstant {
pub mut:
	// Header
	type      u16             // SDL_HAPTIC_CONSTANT
	direction HapticDirection // Direction of the effect.
	// Replay
	length u32 // Duration of the effect.
	delay  u16 // Delay before starting the effect.
	// Trigger
	button   u16 // Button that triggers the effect.
	interval u16 // How soon it can be triggered again after button.
	// Constant
	level i16 // Strength of the constant effect.
	// Envelope
	attack_length u16 // Duration of the attack.
	attack_level  u16 // Level at the start of the attack.
	fade_length   u16 // Duration of the fade.
	fade_level    u16 // Level at the end of the fade.
}

// A structure containing a template for a Constant effect.
//
// This struct is exclusively for the SDL_HAPTIC_CONSTANT effect.
//
// A constant effect applies a constant force in the specified direction to
// the joystick.
//
// NOTE: This struct is available since SDL 3.2.0.
//
// See also: SDL_HAPTIC_CONSTANT
// See also: SDL_HapticEffect
pub type HapticConstant = C.SDL_HapticConstant

// C.SDL_HapticPeriodic [official documentation](https://wiki.libsdl.org/SDL3/SDL_HapticPeriodic)
@[typedef]
pub struct C.SDL_HapticPeriodic {
pub mut:
	// Header
	type      u16             // SDL_HAPTIC_SINE, SDL_HAPTIC_SQUARE SDL_HAPTIC_TRIANGLE, SDL_HAPTIC_SAWTOOTHUP or SDL_HAPTIC_SAWTOOTHDOWN
	direction HapticDirection // Direction of the effect.
	// Replay
	length u32 // Duration of the effect.
	delay  u16 // Delay before starting the effect.
	// Trigger
	button   u16 // Button that triggers the effect.
	interval u16 // How soon it can be triggered again after button.
	// Periodic
	period    u16 // Period of the wave.
	magnitude i16 // Peak value
	offset    i16 // Mean value of the wave.
	// Envelope
	attack_length u16 // Duration of the attack.
	attack_level  u16 // Level at the start of the attack.
	fade_length   u16 // Duration of the fade.
	fade_level    u16 // Level at the end of the fade.
}

// A structure containing a template for a Periodic effect.
//
// The struct handles the following effects:
//
// - SDL_HAPTIC_SINE
// - SDL_HAPTIC_SQUARE
// - SDL_HAPTIC_TRIANGLE
// - SDL_HAPTIC_SAWTOOTHUP
// - SDL_HAPTIC_SAWTOOTHDOWN
//
// A periodic effect consists in a wave-shaped effect that repeats itself over
// time. The type determines the shape of the wave and the parameters
// determine the dimensions of the wave.
//
// Phase is given by hundredth of a degree meaning that giving the phase a
// value of 9000 will displace it 25% of its period. Here are sample values:
//
// - 0: No phase displacement.
// - 9000: Displaced 25% of its period.
// - 18000: Displaced 50% of its period.
// - 27000: Displaced 75% of its period.
// - 36000: Displaced 100% of its period, same as 0, but 0 is preferred.
//
// Examples:
//
// ```
//   SDL_HAPTIC_SINE
//     __      __      __      __
//    /  \    /  \    /  \    /
//   /    \__/    \__/    \__/
//
//   SDL_HAPTIC_SQUARE
//    __    __    __    __    __
//   |  |  |  |  |  |  |  |  |  |
//   |  |__|  |__|  |__|  |__|  |
//
//   SDL_HAPTIC_TRIANGLE
//     /\    /\    /\    /\    /\
//    /  \  /  \  /  \  /  \  /
//   /    \/    \/    \/    \/
//
//   SDL_HAPTIC_SAWTOOTHUP
//     /|  /|  /|  /|  /|  /|  /|
//    / | / | / | / | / | / | / |
//   /  |/  |/  |/  |/  |/  |/  |
//
//   SDL_HAPTIC_SAWTOOTHDOWN
//   \  |\  |\  |\  |\  |\  |\  |
//    \ | \ | \ | \ | \ | \ | \ |
//     \|  \|  \|  \|  \|  \|  \|
// ```
//
// NOTE: This struct is available since SDL 3.2.0.
//
// See also: SDL_HAPTIC_SINE
// See also: SDL_HAPTIC_SQUARE
// See also: SDL_HAPTIC_TRIANGLE
// See also: SDL_HAPTIC_SAWTOOTHUP
// See also: SDL_HAPTIC_SAWTOOTHDOWN
// See also: SDL_HapticEffect
pub type HapticPeriodic = C.SDL_HapticPeriodic

// C.SDL_HapticCondition [official documentation](https://wiki.libsdl.org/SDL3/SDL_HapticCondition)
@[typedef]
pub struct C.SDL_HapticCondition {
pub mut:
	// Header
	type      u16             // SDL_HAPTIC_SPRING, SDL_HAPTIC_DAMPER, SDL_HAPTIC_INERTIA or SDL_HAPTIC_FRICTION
	direction HapticDirection // Direction of the effect.
	// Replay
	length u32 // Duration of the effect.
	delay  u16 // Delay before starting the effect.
	// Trigger
	button   u16 // Button that triggers the effect.
	interval u16 // How soon it can be triggered again after button.
	// Condition
	right_sat   [3]u16 // Level when joystick is to the positive side; max 0xFFFF.
	left_sat    [3]u16 // Level when joystick is to the negative side; max 0xFFFF.
	right_coeff [3]i16 // How fast to increase the force towards the positive side.
	left_coeff  [3]i16 // How fast to increase the force towards the negative side.
	deadband    [3]u16 // Size of the dead zone; max 0xFFFF: whole axis-range when 0-centered.
	center      [3]i16 // Position of the dead zone.
}

// A structure containing a template for a Condition effect.
//
// The struct handles the following effects:
//
// - SDL_HAPTIC_SPRING: Effect based on axes position.
// - SDL_HAPTIC_DAMPER: Effect based on axes velocity.
// - SDL_HAPTIC_INERTIA: Effect based on axes acceleration.
// - SDL_HAPTIC_FRICTION: Effect based on axes movement.
//
// Direction is handled by condition internals instead of a direction member.
// The condition effect specific members have three parameters. The first
// refers to the X axis, the second refers to the Y axis and the third refers
// to the Z axis. The right terms refer to the positive side of the axis and
// the left terms refer to the negative side of the axis. Please refer to the
// SDL_HapticDirection diagram for which side is positive and which is
// negative.
//
// NOTE: This struct is available since SDL 3.2.0.
//
// See also: SDL_HapticDirection
// See also: SDL_HAPTIC_SPRING
// See also: SDL_HAPTIC_DAMPER
// See also: SDL_HAPTIC_INERTIA
// See also: SDL_HAPTIC_FRICTION
// See also: SDL_HapticEffect
pub type HapticCondition = C.SDL_HapticCondition

@[typedef]
pub struct C.SDL_HapticRamp {
pub mut:
	// Header
	type      u16             // SDL_HAPTIC_RAMP
	direction HapticDirection // Direction of the effect.
	// Replay

	length u32 // Duration of the effect.
	delay  u16 // Delay before starting the effect.
	// Trigger

	button   u16 // Button that triggers the effect.
	interval u16 // How soon it can be triggered again after button.
	// Ramp

	start i16 // Beginning strength level.
	end   i16 // Ending strength level.
	// Envelope

	attack_length u16 // Duration of the attack.
	attack_level  u16 // Level at the start of the attack.
	fade_length   u16 // Duration of the fade.
	fade_level    u16 // Level at the end of the fade.
}

pub type HapticRamp = C.SDL_HapticRamp

@[typedef]
pub struct C.SDL_HapticLeftRight {
pub mut:
	// Header
	type u16 // SDL_HAPTIC_LEFTRIGHT
	// Replay

	length u32 // Duration of the effect in milliseconds.
	// Rumble

	large_magnitude u16 // Control of the large controller motor.
	small_magnitude u16 // Control of the small controller motor.
}

pub type HapticLeftRight = C.SDL_HapticLeftRight

@[typedef]
pub struct C.SDL_HapticCustom {
pub mut:
	// Header
	type      u16             // SDL_HAPTIC_CUSTOM
	direction HapticDirection // Direction of the effect.
	// Replay

	length u32 // Duration of the effect.
	delay  u16 // Delay before starting the effect.
	// Trigger

	button   u16 // Button that triggers the effect.
	interval u16 // How soon it can be triggered again after button.
	// Custom

	channels u8  // Axes to use, minimum of one.
	period   u16 // Sample periods.
	samples  u16 // Amount of samples.
	data     &u16 = unsafe { nil } // Should contain channels*samples items.
	// Envelope

	attack_length u16 // Duration of the attack.
	attack_level  u16 // Level at the start of the attack.
	fade_length   u16 // Duration of the fade.
	fade_level    u16 // Level at the end of the fade.
}

pub type HapticCustom = C.SDL_HapticCustom

@[typedef]
pub union C.SDL_HapticEffect {
pub mut:
	// Common for all force feedback effects
	type      u16             // Effect type.
	constant  HapticConstant  // Constant effect.
	periodic  HapticPeriodic  // Periodic effect.
	condition HapticCondition // Condition effect.
	ramp      HapticRamp      // Ramp effect.
	leftright HapticLeftRight // Left/Right effect.
	custom    HapticCustom    // Custom effect.
}

pub type HapticEffect = C.SDL_HapticEffect

// C.SDL_GetHaptics [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetHaptics)
fn C.SDL_GetHaptics(count &int) HapticID

// get_haptics gets a list of currently connected haptic devices.
//
// `count` count a pointer filled in with the number of haptic devices
//              returned, may be NULL.
// returns a 0 terminated array of haptic device instance IDs or NULL on
//          failure; call SDL_GetError() for more information. This should be
//          freed with SDL_free() when it is no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_haptic (SDL_OpenHaptic)
pub fn get_haptics(count &int) HapticID {
	return C.SDL_GetHaptics(count)
}

// C.SDL_GetHapticNameForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetHapticNameForID)
fn C.SDL_GetHapticNameForID(instance_id HapticID) &char

// get_haptic_name_for_id gets the implementation dependent name of a haptic device.
//
// This can be called before any haptic devices are opened.
//
// `instance_id` instance_id the haptic device instance ID.
// returns the name of the selected haptic device. If no name can be found,
//          this function returns NULL; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_haptic_name (SDL_GetHapticName)
// See also: open_haptic (SDL_OpenHaptic)
pub fn get_haptic_name_for_id(instance_id HapticID) &char {
	return C.SDL_GetHapticNameForID(instance_id)
}

// C.SDL_OpenHaptic [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenHaptic)
fn C.SDL_OpenHaptic(instance_id HapticID) &Haptic

// open_haptic opens a haptic device for use.
//
// The index passed as an argument refers to the N'th haptic device on this
// system.
//
// When opening a haptic device, its gain will be set to maximum and
// autocenter will be disabled. To modify these values use SDL_SetHapticGain()
// and SDL_SetHapticAutocenter().
//
// `instance_id` instance_id the haptic device instance ID.
// returns the device identifier or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_haptic (SDL_CloseHaptic)
// See also: get_haptics (SDL_GetHaptics)
// See also: open_haptic_from_joystick (SDL_OpenHapticFromJoystick)
// See also: open_haptic_from_mouse (SDL_OpenHapticFromMouse)
// See also: set_haptic_autocenter (SDL_SetHapticAutocenter)
// See also: set_haptic_gain (SDL_SetHapticGain)
pub fn open_haptic(instance_id HapticID) &Haptic {
	return C.SDL_OpenHaptic(instance_id)
}

// C.SDL_GetHapticFromID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetHapticFromID)
fn C.SDL_GetHapticFromID(instance_id HapticID) &Haptic

// get_haptic_from_id gets the SDL_Haptic associated with an instance ID, if it has been opened.
//
// `instance_id` instance_id the instance ID to get the SDL_Haptic for.
// returns an SDL_Haptic on success or NULL on failure or if it hasn't been
//          opened yet; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_haptic_from_id(instance_id HapticID) &Haptic {
	return C.SDL_GetHapticFromID(instance_id)
}

// C.SDL_GetHapticID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetHapticID)
fn C.SDL_GetHapticID(haptic &Haptic) HapticID

// get_haptic_id gets the instance ID of an opened haptic device.
//
// `haptic` haptic the SDL_Haptic device to query.
// returns the instance ID of the specified haptic device on success or 0 on
//          failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_haptic_id(haptic &Haptic) HapticID {
	return C.SDL_GetHapticID(haptic)
}

// C.SDL_GetHapticName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetHapticName)
fn C.SDL_GetHapticName(haptic &Haptic) &char

// get_haptic_name gets the implementation dependent name of a haptic device.
//
// `haptic` haptic the SDL_Haptic obtained from SDL_OpenJoystick().
// returns the name of the selected haptic device. If no name can be found,
//          this function returns NULL; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_haptic_name_for_id (SDL_GetHapticNameForID)
pub fn get_haptic_name(haptic &Haptic) &char {
	return C.SDL_GetHapticName(haptic)
}

// C.SDL_IsMouseHaptic [official documentation](https://wiki.libsdl.org/SDL3/SDL_IsMouseHaptic)
fn C.SDL_IsMouseHaptic() bool

// is_mouse_haptic querys whether or not the current mouse has haptic capabilities.
//
// returns true if the mouse is haptic or false if it isn't.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_haptic_from_mouse (SDL_OpenHapticFromMouse)
pub fn is_mouse_haptic() bool {
	return C.SDL_IsMouseHaptic()
}

// C.SDL_OpenHapticFromMouse [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenHapticFromMouse)
fn C.SDL_OpenHapticFromMouse() &Haptic

// open_haptic_from_mouse trys to open a haptic device from the current mouse.
//
// returns the haptic device identifier or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_haptic (SDL_CloseHaptic)
// See also: is_mouse_haptic (SDL_IsMouseHaptic)
pub fn open_haptic_from_mouse() &Haptic {
	return C.SDL_OpenHapticFromMouse()
}

// C.SDL_IsJoystickHaptic [official documentation](https://wiki.libsdl.org/SDL3/SDL_IsJoystickHaptic)
fn C.SDL_IsJoystickHaptic(joystick &Joystick) bool

// is_joystick_haptic querys if a joystick has haptic features.
//
// `joystick` joystick the SDL_Joystick to test for haptic capabilities.
// returns true if the joystick is haptic or false if it isn't.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_haptic_from_joystick (SDL_OpenHapticFromJoystick)
pub fn is_joystick_haptic(joystick &Joystick) bool {
	return C.SDL_IsJoystickHaptic(joystick)
}

// C.SDL_OpenHapticFromJoystick [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenHapticFromJoystick)
fn C.SDL_OpenHapticFromJoystick(joystick &Joystick) &Haptic

// open_haptic_from_joystick opens a haptic device for use from a joystick device.
//
// You must still close the haptic device separately. It will not be closed
// with the joystick.
//
// When opened from a joystick you should first close the haptic device before
// closing the joystick device. If not, on some implementations the haptic
// device will also get unallocated and you'll be unable to use force feedback
// on that device.
//
// `joystick` joystick the SDL_Joystick to create a haptic device from.
// returns a valid haptic device identifier on success or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: close_haptic (SDL_CloseHaptic)
// See also: is_joystick_haptic (SDL_IsJoystickHaptic)
pub fn open_haptic_from_joystick(joystick &Joystick) &Haptic {
	return C.SDL_OpenHapticFromJoystick(joystick)
}

// C.SDL_CloseHaptic [official documentation](https://wiki.libsdl.org/SDL3/SDL_CloseHaptic)
fn C.SDL_CloseHaptic(haptic &Haptic)

// close_haptic closes a haptic device previously opened with SDL_OpenHaptic().
//
// `haptic` haptic the SDL_Haptic device to close.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: open_haptic (SDL_OpenHaptic)
pub fn close_haptic(haptic &Haptic) {
	C.SDL_CloseHaptic(haptic)
}

// C.SDL_GetMaxHapticEffects [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetMaxHapticEffects)
fn C.SDL_GetMaxHapticEffects(haptic &Haptic) int

// get_max_haptic_effects gets the number of effects a haptic device can store.
//
// On some platforms this isn't fully supported, and therefore is an
// approximation. Always check to see if your created effect was actually
// created and do not rely solely on SDL_GetMaxHapticEffects().
//
// `haptic` haptic the SDL_Haptic device to query.
// returns the number of effects the haptic device can store or a negative
//          error code on failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_max_haptic_effects_playing (SDL_GetMaxHapticEffectsPlaying)
// See also: get_haptic_features (SDL_GetHapticFeatures)
pub fn get_max_haptic_effects(haptic &Haptic) int {
	return C.SDL_GetMaxHapticEffects(haptic)
}

// C.SDL_GetMaxHapticEffectsPlaying [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetMaxHapticEffectsPlaying)
fn C.SDL_GetMaxHapticEffectsPlaying(haptic &Haptic) int

// get_max_haptic_effects_playing gets the number of effects a haptic device can play at the same time.
//
// This is not supported on all platforms, but will always return a value.
//
// `haptic` haptic the SDL_Haptic device to query maximum playing effects.
// returns the number of effects the haptic device can play at the same time
//          or -1 on failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_max_haptic_effects (SDL_GetMaxHapticEffects)
// See also: get_haptic_features (SDL_GetHapticFeatures)
pub fn get_max_haptic_effects_playing(haptic &Haptic) int {
	return C.SDL_GetMaxHapticEffectsPlaying(haptic)
}

// C.SDL_GetHapticFeatures [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetHapticFeatures)
fn C.SDL_GetHapticFeatures(haptic &Haptic) u32

// get_haptic_features gets the haptic device's supported features in bitwise manner.
//
// `haptic` haptic the SDL_Haptic device to query.
// returns a list of supported haptic features in bitwise manner (OR'd), or 0
//          on failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: haptic_effect_supported (SDL_HapticEffectSupported)
// See also: get_max_haptic_effects (SDL_GetMaxHapticEffects)
pub fn get_haptic_features(haptic &Haptic) u32 {
	return C.SDL_GetHapticFeatures(haptic)
}

// C.SDL_GetNumHapticAxes [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumHapticAxes)
fn C.SDL_GetNumHapticAxes(haptic &Haptic) int

// get_num_haptic_axes gets the number of haptic axes the device has.
//
// The number of haptic axes might be useful if working with the
// SDL_HapticDirection effect.
//
// `haptic` haptic the SDL_Haptic device to query.
// returns the number of axes on success or -1 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_num_haptic_axes(haptic &Haptic) int {
	return C.SDL_GetNumHapticAxes(haptic)
}

// C.SDL_HapticEffectSupported [official documentation](https://wiki.libsdl.org/SDL3/SDL_HapticEffectSupported)
fn C.SDL_HapticEffectSupported(haptic &Haptic, const_effect &HapticEffect) bool

// haptic_effect_supported checks to see if an effect is supported by a haptic device.
//
// `haptic` haptic the SDL_Haptic device to query.
// `effect` effect the desired effect to query.
// returns true if the effect is supported or false if it isn't.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_haptic_effect (SDL_CreateHapticEffect)
// See also: get_haptic_features (SDL_GetHapticFeatures)
pub fn haptic_effect_supported(haptic &Haptic, const_effect &HapticEffect) bool {
	return C.SDL_HapticEffectSupported(haptic, const_effect)
}

// C.SDL_CreateHapticEffect [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateHapticEffect)
fn C.SDL_CreateHapticEffect(haptic &Haptic, const_effect &HapticEffect) int

// create_haptic_effect creates a new haptic effect on a specified device.
//
// `haptic` haptic an SDL_Haptic device to create the effect on.
// `effect` effect an SDL_HapticEffect structure containing the properties of
//               the effect to create.
// returns the ID of the effect on success or -1 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_haptic_effect (SDL_DestroyHapticEffect)
// See also: run_haptic_effect (SDL_RunHapticEffect)
// See also: update_haptic_effect (SDL_UpdateHapticEffect)
pub fn create_haptic_effect(haptic &Haptic, const_effect &HapticEffect) int {
	return C.SDL_CreateHapticEffect(haptic, const_effect)
}

// C.SDL_UpdateHapticEffect [official documentation](https://wiki.libsdl.org/SDL3/SDL_UpdateHapticEffect)
fn C.SDL_UpdateHapticEffect(haptic &Haptic, effect int, const_data &HapticEffect) bool

// update_haptic_effect updates the properties of an effect.
//
// Can be used dynamically, although behavior when dynamically changing
// direction may be strange. Specifically the effect may re-upload itself and
// start playing from the start. You also cannot change the type either when
// running SDL_UpdateHapticEffect().
//
// `haptic` haptic the SDL_Haptic device that has the effect.
// `effect` effect the identifier of the effect to update.
// `data` data an SDL_HapticEffect structure containing the new effect
//             properties to use.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_haptic_effect (SDL_CreateHapticEffect)
// See also: run_haptic_effect (SDL_RunHapticEffect)
pub fn update_haptic_effect(haptic &Haptic, effect int, const_data &HapticEffect) bool {
	return C.SDL_UpdateHapticEffect(haptic, effect, const_data)
}

// C.SDL_RunHapticEffect [official documentation](https://wiki.libsdl.org/SDL3/SDL_RunHapticEffect)
fn C.SDL_RunHapticEffect(haptic &Haptic, effect int, iterations u32) bool

// run_haptic_effect runs the haptic effect on its associated haptic device.
//
// To repeat the effect over and over indefinitely, set `iterations` to
// `SDL_HAPTIC_INFINITY`. (Repeats the envelope - attack and fade.) To make
// one instance of the effect last indefinitely (so the effect does not fade),
// set the effect's `length` in its structure/union to `SDL_HAPTIC_INFINITY`
// instead.
//
// `haptic` haptic the SDL_Haptic device to run the effect on.
// `effect` effect the ID of the haptic effect to run.
// `iterations` iterations the number of iterations to run the effect; use
//                   `SDL_HAPTIC_INFINITY` to repeat forever.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_haptic_effect_status (SDL_GetHapticEffectStatus)
// See also: stop_haptic_effect (SDL_StopHapticEffect)
// See also: stop_haptic_effects (SDL_StopHapticEffects)
pub fn run_haptic_effect(haptic &Haptic, effect int, iterations u32) bool {
	return C.SDL_RunHapticEffect(haptic, effect, iterations)
}

// C.SDL_StopHapticEffect [official documentation](https://wiki.libsdl.org/SDL3/SDL_StopHapticEffect)
fn C.SDL_StopHapticEffect(haptic &Haptic, effect int) bool

// stop_haptic_effect stops the haptic effect on its associated haptic device.
//
// `haptic` haptic the SDL_Haptic device to stop the effect on.
// `effect` effect the ID of the haptic effect to stop.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: run_haptic_effect (SDL_RunHapticEffect)
// See also: stop_haptic_effects (SDL_StopHapticEffects)
pub fn stop_haptic_effect(haptic &Haptic, effect int) bool {
	return C.SDL_StopHapticEffect(haptic, effect)
}

// C.SDL_DestroyHapticEffect [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyHapticEffect)
fn C.SDL_DestroyHapticEffect(haptic &Haptic, effect int)

// destroy_haptic_effect destroys a haptic effect on the device.
//
// This will stop the effect if it's running. Effects are automatically
// destroyed when the device is closed.
//
// `haptic` haptic the SDL_Haptic device to destroy the effect on.
// `effect` effect the ID of the haptic effect to destroy.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_haptic_effect (SDL_CreateHapticEffect)
pub fn destroy_haptic_effect(haptic &Haptic, effect int) {
	C.SDL_DestroyHapticEffect(haptic, effect)
}

// C.SDL_GetHapticEffectStatus [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetHapticEffectStatus)
fn C.SDL_GetHapticEffectStatus(haptic &Haptic, effect int) bool

// get_haptic_effect_status gets the status of the current effect on the specified haptic device.
//
// Device must support the SDL_HAPTIC_STATUS feature.
//
// `haptic` haptic the SDL_Haptic device to query for the effect status on.
// `effect` effect the ID of the haptic effect to query its status.
// returns true if it is playing, false if it isn't playing or haptic status
//          isn't supported.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_haptic_features (SDL_GetHapticFeatures)
pub fn get_haptic_effect_status(haptic &Haptic, effect int) bool {
	return C.SDL_GetHapticEffectStatus(haptic, effect)
}

// C.SDL_SetHapticGain [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetHapticGain)
fn C.SDL_SetHapticGain(haptic &Haptic, gain int) bool

// set_haptic_gain sets the global gain of the specified haptic device.
//
// Device must support the SDL_HAPTIC_GAIN feature.
//
// The user may specify the maximum gain by setting the environment variable
// `SDL_HAPTIC_GAIN_MAX` which should be between 0 and 100. All calls to
// SDL_SetHapticGain() will scale linearly using `SDL_HAPTIC_GAIN_MAX` as the
// maximum.
//
// `haptic` haptic the SDL_Haptic device to set the gain on.
// `gain` gain value to set the gain to, should be between 0 and 100 (0 -
//             100).
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_haptic_features (SDL_GetHapticFeatures)
pub fn set_haptic_gain(haptic &Haptic, gain int) bool {
	return C.SDL_SetHapticGain(haptic, gain)
}

// C.SDL_SetHapticAutocenter [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetHapticAutocenter)
fn C.SDL_SetHapticAutocenter(haptic &Haptic, autocenter int) bool

// set_haptic_autocenter sets the global autocenter of the device.
//
// Autocenter should be between 0 and 100. Setting it to 0 will disable
// autocentering.
//
// Device must support the SDL_HAPTIC_AUTOCENTER feature.
//
// `haptic` haptic the SDL_Haptic device to set autocentering on.
// `autocenter` autocenter value to set autocenter to (0-100).
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_haptic_features (SDL_GetHapticFeatures)
pub fn set_haptic_autocenter(haptic &Haptic, autocenter int) bool {
	return C.SDL_SetHapticAutocenter(haptic, autocenter)
}

// C.SDL_PauseHaptic [official documentation](https://wiki.libsdl.org/SDL3/SDL_PauseHaptic)
fn C.SDL_PauseHaptic(haptic &Haptic) bool

// pause_haptic pauses a haptic device.
//
// Device must support the `SDL_HAPTIC_PAUSE` feature. Call SDL_ResumeHaptic()
// to resume playback.
//
// Do not modify the effects nor add new ones while the device is paused. That
// can cause all sorts of weird errors.
//
// `haptic` haptic the SDL_Haptic device to pause.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: resume_haptic (SDL_ResumeHaptic)
pub fn pause_haptic(haptic &Haptic) bool {
	return C.SDL_PauseHaptic(haptic)
}

// C.SDL_ResumeHaptic [official documentation](https://wiki.libsdl.org/SDL3/SDL_ResumeHaptic)
fn C.SDL_ResumeHaptic(haptic &Haptic) bool

// resume_haptic resumes a haptic device.
//
// Call to unpause after SDL_PauseHaptic().
//
// `haptic` haptic the SDL_Haptic device to unpause.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: pause_haptic (SDL_PauseHaptic)
pub fn resume_haptic(haptic &Haptic) bool {
	return C.SDL_ResumeHaptic(haptic)
}

// C.SDL_StopHapticEffects [official documentation](https://wiki.libsdl.org/SDL3/SDL_StopHapticEffects)
fn C.SDL_StopHapticEffects(haptic &Haptic) bool

// stop_haptic_effects stops all the currently playing effects on a haptic device.
//
// `haptic` haptic the SDL_Haptic device to stop.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: run_haptic_effect (SDL_RunHapticEffect)
// See also: stop_haptic_effects (SDL_StopHapticEffects)
pub fn stop_haptic_effects(haptic &Haptic) bool {
	return C.SDL_StopHapticEffects(haptic)
}

// C.SDL_HapticRumbleSupported [official documentation](https://wiki.libsdl.org/SDL3/SDL_HapticRumbleSupported)
fn C.SDL_HapticRumbleSupported(haptic &Haptic) bool

// haptic_rumble_supported checks whether rumble is supported on a haptic device.
//
// `haptic` haptic haptic device to check for rumble support.
// returns true if the effect is supported or false if it isn't.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: init_haptic_rumble (SDL_InitHapticRumble)
pub fn haptic_rumble_supported(haptic &Haptic) bool {
	return C.SDL_HapticRumbleSupported(haptic)
}

// C.SDL_InitHapticRumble [official documentation](https://wiki.libsdl.org/SDL3/SDL_InitHapticRumble)
fn C.SDL_InitHapticRumble(haptic &Haptic) bool

// init_haptic_rumble initializes a haptic device for simple rumble playback.
//
// `haptic` haptic the haptic device to initialize for simple rumble playback.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: play_haptic_rumble (SDL_PlayHapticRumble)
// See also: stop_haptic_rumble (SDL_StopHapticRumble)
// See also: haptic_rumble_supported (SDL_HapticRumbleSupported)
pub fn init_haptic_rumble(haptic &Haptic) bool {
	return C.SDL_InitHapticRumble(haptic)
}

// C.SDL_PlayHapticRumble [official documentation](https://wiki.libsdl.org/SDL3/SDL_PlayHapticRumble)
fn C.SDL_PlayHapticRumble(haptic &Haptic, strength f32, length u32) bool

// play_haptic_rumble runs a simple rumble effect on a haptic device.
//
// `haptic` haptic the haptic device to play the rumble effect on.
// `strength` strength strength of the rumble to play as a 0-1 float value.
// `length` length length of the rumble to play in milliseconds.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: init_haptic_rumble (SDL_InitHapticRumble)
// See also: stop_haptic_rumble (SDL_StopHapticRumble)
pub fn play_haptic_rumble(haptic &Haptic, strength f32, length u32) bool {
	return C.SDL_PlayHapticRumble(haptic, strength, length)
}

// C.SDL_StopHapticRumble [official documentation](https://wiki.libsdl.org/SDL3/SDL_StopHapticRumble)
fn C.SDL_StopHapticRumble(haptic &Haptic) bool

// stop_haptic_rumble stops the simple rumble on a haptic device.
//
// `haptic` haptic the haptic device to stop the rumble effect on.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: play_haptic_rumble (SDL_PlayHapticRumble)
pub fn stop_haptic_rumble(haptic &Haptic) bool {
	return C.SDL_StopHapticRumble(haptic)
}
