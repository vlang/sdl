// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_haptic.h
//

pub const (
	// Constant effect supported.
	//
	// Constant haptic effect.
	//
	// See also: SDL_HapticCondition
	haptic_constant     = C.SDL_HAPTIC_CONSTANT // (1u<<0) // u32(1) << 0
	// Sine wave effect supported.
	//
	// Periodic haptic effect that simulates sine waves.
	//
	// See also: SDL_HapticPeriodic
	haptic_sine         = C.SDL_HAPTIC_SINE // (1u<<1)
	// Left/Right effect supported.
	//
	// Haptic effect for direct control over high/low frequency motors.
	//
	// See also: SDL_HapticLeftRight
	// WARNING this value was SDL_HAPTIC_SQUARE right before 2.0.0 shipped. Sorry,
	// we ran out of bits, and this is important for XInput devices.
	haptic_leftright    = C.SDL_HAPTIC_LEFTRIGHT // (1u<<2)
	// Triangle wave effect supported.
	//
	// Periodic haptic effect that simulates triangular waves.
	//
	// See also: SDL_HapticPeriodic
	haptic_triangle     = C.SDL_HAPTIC_TRIANGLE //  (1u<<3)
	// Sawtoothup wave effect supported.
	//
	// Periodic haptic effect that simulates saw tooth up waves.
	//
	// See also: SDL_HapticPeriodic
	haptic_sawtoothup   = C.SDL_HAPTIC_SAWTOOTHUP //(1u<<4)
	// Sawtoothdown wave effect supported.
	//
	// Periodic haptic effect that simulates saw tooth down waves.
	//
	// See also: SDL_HapticPeriodic
	haptic_sawtoothdown = C.SDL_HAPTIC_SAWTOOTHDOWN //(1u<<5)
	// Ramp effect supported.
	//
	// Ramp haptic effect.
	//
	// See also: SDL_HapticRamp
	haptic_ramp         = C.SDL_HAPTIC_RAMP //     (1u<<6)
	// Spring effect supported - uses axes position.
	//
	// Condition haptic effect that simulates a spring.  Effect is based on the
	// axes position.
	//
	// See also: SDL_HapticCondition
	haptic_spring       = C.SDL_HAPTIC_SPRING //   (1u<<7)
	// Damper effect supported - uses axes velocity.
	//
	// Condition haptic effect that simulates dampening.  Effect is based on the
	// axes velocity.
	//
	// See also: SDL_HapticCondition
	haptic_damper       = C.SDL_HAPTIC_DAMPER //  (1u<<8)
	// Inertia effect supported - uses axes acceleration.
	//
	// Condition haptic effect that simulates inertia.  Effect is based on the axes
	// acceleration.
	//
	// See also: SDL_HapticCondition
	haptic_inertia      = C.SDL_HAPTIC_INERTIA //  (1u<<9)
	// Friction effect supported - uses axes movement.
	//
	// Condition haptic effect that simulates friction.  Effect is based on the
	// axes movement.
	//
	// See also: SDL_HapticCondition
	haptic_friction     = C.SDL_HAPTIC_FRICTION //  (1u<<10)
	// Custom effect is supported.
	//
	// User defined custom haptic effect.
	haptic_custom       = C.SDL_HAPTIC_CUSTOM //  (1u<<11)
	// Haptic effects
	// These last few are features the device has, not effects
	// Device can set global gain.
	//
	// Device supports setting the global gain.
	//
	// See also: SDL_HapticSetGain
	haptic_gain         = C.SDL_HAPTIC_GAIN //   (1u<<12)
	// Device can set autocenter.
	//
	// Device supports setting autocenter.
	//
	// See also: SDL_HapticSetAutocenter
	haptic_autocenter   = C.SDL_HAPTIC_AUTOCENTER //(1u<<13)
	// Device can be queried for effect status.
	//
	// Device supports querying effect status.
	//
	// See also: SDL_HapticGetEffectStatus
	haptic_status       = C.SDL_HAPTIC_STATUS //   (1u<<14)
	// Device can be paused.
	//
	// Devices supports being paused.
	//
	// See also: SDL_HapticPause
	// See also: SDL_HapticUnpause
	haptic_pause        = C.SDL_HAPTIC_PAUSE //   (1u<<15)
	// Direction encodings
	//@{
	// Uses polar coordinates for the direction.
	//
	// See also: SDL_HapticDirection
	haptic_polar        = C.SDL_HAPTIC_POLAR // 0
	// Uses cartesian coordinates for the direction.
	//
	// See also: SDL_HapticDirection
	haptic_cartesian    = C.SDL_HAPTIC_CARTESIAN // 1
	// Uses spherical coordinates for the direction.
	//
	// See also: SDL_HapticDirection
	haptic_spherical    = C.SDL_HAPTIC_SPHERICAL // 2
	// Used to play a device an infinite number of times.
	//
	// See also: SDL_HapticRunEffect
	haptic_infinity     = C.SDL_HAPTIC_INFINITY // 4294967295U
)

[typedef]
struct C.SDL_Haptic {
}

pub type Haptic = C.SDL_Haptic

// Structure that represents a haptic direction.
//
// This is the direction where the force comes from,
// instead of the direction in which the force is exerted.
//
// Directions can be specified by:
// - ::SDL_HAPTIC_POLAR : Specified by polar coordinates.
// - ::SDL_HAPTIC_CARTESIAN : Specified by cartesian coordinates.
// - ::SDL_HAPTIC_SPHERICAL : Specified by spherical coordinates.
//
// Cardinal directions of the haptic device are relative to the positioning
// of the device.  North is considered to be away from the user.
//
// The following diagram represents the cardinal directions:
//
/*
```
                 .--.
                 |__| .-------.
                 |=.| |.-----.|
                 |--| ||     ||
                 |  | |'-----'|
                 |__|~')_____('
                   [ COMPUTER ]


                     North (0,-1)
                         ^
                         |
                         |
   (-1,0)  West <----[ HAPTIC ]----> East (1,0)
                         |
                         |
                         v
                      South (0,1)


                      [ USER ]
                        \|||/
                        (o o)
                  ---ooO-(_)-Ooo---
```
*/
//
// If type is ::SDL_HAPTIC_POLAR, direction is encoded by hundredths of a
// degree starting north and turning clockwise.  ::SDL_HAPTIC_POLAR only uses
// the first `dir` parameter.  The cardinal directions would be:
// - North: 0 (0 degrees)
// - East: 9000 (90 degrees)
// - South: 18000 (180 degrees)
// - West: 27000 (270 degrees)
//
// If type is ::SDL_HAPTIC_CARTESIAN, direction is encoded by three positions
// (X axis, Y axis and Z axis (with 3 axes)).  ::SDL_HAPTIC_CARTESIAN uses
// the first three `dir` parameters.  The cardinal directions would be:
// - North:  0,-1, 0
// - East:   1, 0, 0
// - South:  0, 1, 0
// - West:  -1, 0, 0
//
// The Z axis represents the height of the effect if supported, otherwise
// it's unused.  In cartesian encoding (1, 2) would be the same as (2, 4), you
// can use any multiple you want, only the direction matters.
//
// If type is ::SDL_HAPTIC_SPHERICAL, direction is encoded by two rotations.
// The first two `dir` parameters are used.  The `dir` parameters are as
// follows (all values are in hundredths of degrees):
// - Degrees from (1, 0) rotated towards (0, 1).
// - Degrees towards (0, 0, 1) (device needs at least 3 axes).
//
//
// Example of force coming from the south with all encodings (force coming
// from the south means the user will have to pull the stick to counteract):
/*
```
SDL_HapticDirection direction;
// Cartesian directions
direction.type = SDL_HAPTIC_CARTESIAN; // Using cartesian direction encoding.
direction.dir[0] = 0; // X position
direction.dir[1] = 1; // Y position
// Assuming the device has 2 axes, we don't need to specify third parameter.

// Polar directions
direction.type = SDL_HAPTIC_POLAR; // We'll be using polar direction encoding.
direction.dir[0] = 18000; // Polar only uses first parameter

// Spherical coordinates
direction.type = SDL_HAPTIC_SPHERICAL; // Spherical encoding
direction.dir[0] = 9000; // Since we only have two axes we don't need more parameters.
```
*/
//
// See also: SDL_HAPTIC_POLAR
// See also: SDL_HAPTIC_CARTESIAN
// See also: SDL_HAPTIC_SPHERICAL
// See also: SDL_HapticEffect
// See also: SDL_HapticNumAxes

[typedef]
struct C.SDL_HapticDirection {
pub mut:
	@type byte // The type of encoding
	dir   [3]int
}

pub type HapticDirection = C.SDL_HapticDirection

// A structure containing a template for a Constant effect.
//
// This struct is exclusively for the ::SDL_HAPTIC_CONSTANT effect.
//
// A constant effect applies a constant force in the specified direction
// to the joystick.
//
// See also: SDL_HAPTIC_CONSTANT
// See also: SDL_HapticEffect
[typedef]
struct C.SDL_HapticConstant {
pub mut:
	@type         u16 // ::SDL_HAPTIC_CONSTANT
	direction     HapticDirection // Direction of the effect.
	length        u32 // Duration of the effect.
	delay         u16 // Delay before starting the effect.
	button        u16 // Button that triggers the effect.
	interval      u16 // How soon it can be triggered again after button.
	level         i16 // Strength of the constant effect.
	attack_length u16 // Duration of the attack.
	attack_level  u16 // Level at the start of the attack.
	fade_length   u16 // Duration of the fade.
	fade_level    u16 // Level at the end of the fade.
}

pub type HapticConstant = C.SDL_HapticConstant

// A structure containing a template for a Periodic effect.
//
// The struct handles the following effects:
// - ::SDL_HAPTIC_SINE
// - ::SDL_HAPTIC_LEFTRIGHT
// - ::SDL_HAPTIC_TRIANGLE
// - ::SDL_HAPTIC_SAWTOOTHUP
// - ::SDL_HAPTIC_SAWTOOTHDOWN
//
// A periodic effect consists in a wave-shaped effect that repeats itself
// over time.  The type determines the shape of the wave and the parameters
// determine the dimensions of the wave.
//
// Phase is given by hundredth of a degree meaning that giving the phase a value
// of 9000 will displace it 25% of its period.  Here are sample values:
// -     0: No phase displacement.
// -  9000: Displaced 25% of its period.
// - 18000: Displaced 50% of its period.
// - 27000: Displaced 75% of its period.
// - 36000: Displaced 100% of its period, same as 0, but 0 is preferred.
//
// Examples:
/*
```
    SDL_HAPTIC_SINE
      __      __      __      __
     /  \    /  \    /  \    /
    /    \__/    \__/    \__/

    SDL_HAPTIC_SQUARE
     __    __    __    __    __
    |  |  |  |  |  |  |  |  |  |
    |  |__|  |__|  |__|  |__|  |

    SDL_HAPTIC_TRIANGLE
      /\    /\    /\    /\    /\
     /  \  /  \  /  \  /  \  /
    /    \/    \/    \/    \/

    SDL_HAPTIC_SAWTOOTHUP
      /|  /|  /|  /|  /|  /|  /|
     / | / | / | / | / | / | / |
    /  |/  |/  |/  |/  |/  |/  |

    SDL_HAPTIC_SAWTOOTHDOWN
    \  |\  |\  |\  |\  |\  |\  |
     \ | \ | \ | \ | \ | \ | \ |
      \|  \|  \|  \|  \|  \|  \|
```
*/
//
// See also: SDL_HAPTIC_SINE
// See also: SDL_HAPTIC_LEFTRIGHT
// See also: SDL_HAPTIC_TRIANGLE
// See also: SDL_HAPTIC_SAWTOOTHUP
// See also: SDL_HAPTIC_SAWTOOTHDOWN
// See also: SDL_HapticEffect

[typedef]
struct C.SDL_HapticPeriodic {
pub mut:
	@type         u16 // ::SDL_HAPTIC_SINE, ::SDL_HAPTIC_LEFTRIGHT, ::SDL_HAPTIC_TRIANGLE, ::SDL_HAPTIC_SAWTOOTHUP or ::SDL_HAPTIC_SAWTOOTHDOWN
	direction     HapticDirection // Direction of the effect.
	length        u32 // Duration of the effect.
	delay         u16 // Delay before starting the effect.
	button        u16 // Button that triggers the effect.
	interval      u16 // How soon it can be triggered again after button.
	period        u16 // Period of the wave.
	magnitude     i16 // Peak value; if negative, equivalent to 180 degrees extra phase shift.
	offset        i16 // Mean value of the wave.
	phase         u16 // Positive phase shift given by hundredth of a degree.
	attack_length u16 // Duration of the attack.
	attack_level  u16 // Level at the start of the attack.
	fade_length   u16 // Duration of the fade.
	fade_level    u16 // Level at the end of the fade.
}

pub type HapticPeriodic = C.SDL_HapticPeriodic

// A structure containing a template for a Condition effect.
//
// The struct handles the following effects:
// - ::SDL_HAPTIC_SPRING: Effect based on axes position.
// - ::SDL_HAPTIC_DAMPER: Effect based on axes velocity.
// - ::SDL_HAPTIC_INERTIA: Effect based on axes acceleration.
// - ::SDL_HAPTIC_FRICTION: Effect based on axes movement.
//
// Direction is handled by condition internals instead of a direction member.
// The condition effect specific members have three parameters.  The first
// refers to the X axis, the second refers to the Y axis and the third
// refers to the Z axis.  The right terms refer to the positive side of the
// axis and the left terms refer to the negative side of the axis.  Please
// refer to the ::SDL_HapticDirection diagram for which side is positive and
// which is negative.
//
// See also: SDL_HapticDirection
// See also: SDL_HAPTIC_SPRING
// See also: SDL_HAPTIC_DAMPER
// See also: SDL_HAPTIC_INERTIA
// See also: SDL_HAPTIC_FRICTION
// See also: SDL_HapticEffect
[typedef]
struct C.SDL_HapticCondition {
pub mut:
	@type       u16 // ::SDL_HAPTIC_SPRING, ::SDL_HAPTIC_DAMPER,                                  ::SDL_HAPTIC_INERTIA or ::SDL_HAPTIC_FRICTION
	direction   HapticDirection // Direction of the effect - Not used ATM.
	length      u32    // Duration of the effect.
	delay       u16    // Delay before starting the effect.
	button      u16    // Button that triggers the effect.
	interval    u16    // How soon it can be triggered again after button.
	right_sat   [3]u16 // Level when joystick is to the positive side; max 0xFFFF.
	left_sat    [3]u16 // Level when joystick is to the negative side; max 0xFFFF.
	right_coeff [3]i16 // How fast to increase the force towards the positive side.
	left_coeff  [3]i16 // How fast to increase the force towards the negative side.
	deadband    [3]u16 // Size of the dead zone; max 0xFFFF: whole axis-range when 0-centered.
	center      [3]i16 // Position of the dead zone.
}

pub type HapticCondition = C.SDL_HapticCondition

// A structure containing a template for a Ramp effect.
//
// This struct is exclusively for the ::SDL_HAPTIC_RAMP effect.
//
// The ramp effect starts at start strength and ends at end strength.
// It augments in linear fashion.  If you use attack and fade with a ramp
// the effects get added to the ramp effect making the effect become
// quadratic instead of linear.
//
// See also: SDL_HAPTIC_RAMP
// See also: SDL_HapticEffect
[typedef]
struct C.SDL_HapticRamp {
pub mut:
	@type         u16 // ::SDL_HAPTIC_RAMP
	direction     HapticDirection // Direction of the effect.
	length        u32 // Duration of the effect.
	delay         u16 // Delay before starting the effect.
	button        u16 // Button that triggers the effect.
	interval      u16 // How soon it can be triggered again after button.
	start         i16 // Beginning strength level.
	end           i16 // Ending strength level.
	attack_length u16 // Duration of the attack.
	attack_level  u16 // Level at the start of the attack.
	fade_length   u16 // Duration of the fade.
	fade_level    u16 // Level at the end of the fade.
}

pub type HapticRamp = C.SDL_HapticRamp

// A structure containing a template for a Left/Right effect.
//
// This struct is exclusively for the ::SDL_HAPTIC_LEFTRIGHT effect.
//
// The Left/Right effect is used to explicitly control the large and small
// motors, commonly found in modern game controllers. One motor is high
// frequency, the other is low frequency.
//
// See also: SDL_HAPTIC_LEFTRIGHT
// See also: SDL_HapticEffect
[typedef]
struct C.SDL_HapticLeftRight {
pub mut:
	@type           u16 // ::SDL_HAPTIC_LEFTRIGHT
	length          u32 // Duration of the effect.
	large_magnitude u16 // Control of the large controller motor.
	small_magnitude u16 // Control of the small controller motor.
}

pub type HapticLeftRight = C.SDL_HapticLeftRight

// A structure containing a template for the ::SDL_HAPTIC_CUSTOM effect.
//
// This struct is exclusively for the ::SDL_HAPTIC_CUSTOM effect.
//
// A custom force feedback effect is much like a periodic effect, where the
// application can define its exact shape.  You will have to allocate the
// data yourself.  Data should consist of channels * samples Uint16 samples.
//
// If channels is one, the effect is rotated using the defined direction.
// Otherwise it uses the samples in data for the different axes.
//
// See also: SDL_HAPTIC_CUSTOM
// See also: SDL_HapticEffect
[typedef]
struct C.SDL_HapticCustom {
pub mut:
	@type         u16 // ::SDL_HAPTIC_CUSTOM
	direction     HapticDirection // Direction of the effect.
	length        u32  // Duration of the effect.
	delay         u16  // Delay before starting the effect.
	button        u16  // Button that triggers the effect.
	interval      u16  // How soon it can be triggered again after button.
	channels      byte // Axes to use, minimum of one.
	period        u16  // Sample periods.
	samples       u16  // Amount of samples.
	data          &u16 // Should contain channels*samples items.
	attack_length u16  // Duration of the attack.
	attack_level  u16  // Level at the start of the attack.
	fade_length   u16  // Duration of the fade.
	fade_level    u16  // Level at the end of the fade.
}

pub type HapticCustom = C.SDL_HapticCustom

// The generic template for any haptic effect.
//
// All values max at 32767 (0x7FFF).  Signed values also can be negative.
// Time values unless specified otherwise are in milliseconds.
//
// You can also pass ::SDL_HAPTIC_INFINITY to length instead of a 0-32767
// value.  Neither delay, interval, attack_length nor fade_length support
// ::SDL_HAPTIC_INFINITY.  Fade will also not be used since effect never ends.
//
// Additionally, the ::SDL_HAPTIC_RAMP effect does not support a duration of
// ::SDL_HAPTIC_INFINITY.
//
// Button triggers may not be supported on all devices, it is advised to not
// use them if possible.  Buttons start at index 1 instead of index 0 like
// the joystick.
//
// If both attack_length and fade_level are 0, the envelope is not used,
// otherwise both values are used.
//
// Common parts:
/*
```
// Replay - All effects have this
Uint32 length;        // Duration of effect (ms).
Uint16 delay;         // Delay before starting effect.

// Trigger - All effects have this
Uint16 button;        // Button that triggers effect.
Uint16 interval;      // How soon before effect can be triggered again.

// Envelope - All effects except condition effects have this
Uint16 attack_length; // Duration of the attack (ms).
Uint16 attack_level;  // Level at the start of the attack.
Uint16 fade_length;   // Duration of the fade out (ms).
Uint16 fade_level;    // Level at the end of the fade.
```
*/
//
//
// Here we have an example of a constant effect evolution in time:
//
/*
```
    Strength
    ^
    |
    |    effect level -->  _________________
    |                     /                 \
    |                    /                   \
    |                   /                     \
    |                  /                       \
    | attack_level --> |                        \
    |                  |                        |  <---  fade_level
    |
    +--------------------------------------------------> Time
                       [--]                 [---]
                       attack_length        fade_length

    [------------------][-----------------------]
    delay               length
```
*/
//
// Note either the attack_level or the fade_level may be above the actual
// effect level.
//
// See also: SDL_HapticConstant
// See also: SDL_HapticPeriodic
// See also: SDL_HapticCondition
// See also: SDL_HapticRamp
// See also: SDL_HapticLeftRight
// See also: SDL_HapticCustom

[typedef]
union C.SDL_HapticEffect {
pub mut:
	// Common for all force feedback effects
	@type     u16 // Effect type.
	constant  HapticConstant  // Constant effect.
	periodic  HapticPeriodic  // Periodic effect.
	condition HapticCondition // Condition effect.
	ramp      HapticRamp      // Ramp effect.
	leftright HapticLeftRight // Left/Right effect.
	custom    HapticCustom    // Custom effect.
}

pub type HapticEffect = C.SDL_HapticEffect

fn C.SDL_NumHaptics() int

// num_haptics counts the number of haptic devices attached to the system.
//
// returns Number of haptic devices detected on the system.
pub fn num_haptics() int {
	return C.SDL_NumHaptics()
}

fn C.SDL_HapticName(device_index int) &char

// haptic_name gets the implementation dependent name of a haptic device.
//
// This can be called before any joysticks are opened.
// If no name can be found, this function returns NULL.
//
// `device_index` Index of the device to get its name.
// returns Name of the device or NULL on error.
//
// See also: SDL_NumHaptics
pub fn haptic_name(device_index int) &char {
	return C.SDL_HapticName(device_index)
}

fn C.SDL_HapticOpen(device_index int) &C.SDL_Haptic

// haptic_open opens a haptic device for use.
//
// The index passed as an argument refers to the N'th haptic device on this
// system.
//
// When opening a haptic device, its gain will be set to maximum and
// autocenter will be disabled.  To modify these values use
// SDL_HapticSetGain() and SDL_HapticSetAutocenter().
//
// `device_index` Index of the device to open.
// returns Device identifier or NULL on error.
//
// See also: SDL_HapticIndex
// See also: SDL_HapticOpenFromMouse
// See also: SDL_HapticOpenFromJoystick
// See also: SDL_HapticClose
// See also: SDL_HapticSetGain
// See also: SDL_HapticSetAutocenter
// See also: SDL_HapticPause
// See also: SDL_HapticStopAll
pub fn haptic_open(device_index int) &Haptic {
	return C.SDL_HapticOpen(device_index)
}

fn C.SDL_HapticOpened(device_index int) int

// haptic_opened checks if the haptic device at index has been opened.
//
// `device_index` Index to check to see if it has been opened.
// returns 1 if it has been opened or 0 if it hasn't.
//
// See also: SDL_HapticOpen
// See also: SDL_HapticIndex
pub fn haptic_opened(device_index int) int {
	return C.SDL_HapticOpened(device_index)
}

fn C.SDL_HapticIndex(haptic &C.SDL_Haptic) int

// haptic_index gets the index of a haptic device.
//
// `haptic` Haptic device to get the index of.
// returns The index of the haptic device or -1 on error.
//
// See also: SDL_HapticOpen
// See also: SDL_HapticOpened
pub fn haptic_index(haptic &Haptic) int {
	return C.SDL_HapticIndex(haptic)
}

fn C.SDL_MouseIsHaptic() int

// mouse_is_haptic gets whether or not the current mouse has haptic capabilities.
//
// returns SDL_TRUE if the mouse is haptic, SDL_FALSE if it isn't.
//
// See also: SDL_HapticOpenFromMouse
pub fn mouse_is_haptic() int {
	return C.SDL_MouseIsHaptic()
}

fn C.SDL_HapticOpenFromMouse() &C.SDL_Haptic

// haptic_open_from_mouse tries to open a haptic device from the current mouse.
//
// returns The haptic device identifier or NULL on error.
//
// See also: SDL_MouseIsHaptic
// See also: SDL_HapticOpen
pub fn haptic_open_from_mouse() &Haptic {
	return C.SDL_HapticOpenFromMouse()
}

fn C.SDL_JoystickIsHaptic(joystick &C.SDL_Joystick) int

// joystick_is_haptic checks to see if a joystick has haptic features.
//
// `joystick` Joystick to test for haptic capabilities.
// returns SDL_TRUE if the joystick is haptic, SDL_FALSE if it isn't
// or -1 if an error occurred.
//
// See also: SDL_HapticOpenFromJoystick
pub fn joystick_is_haptic(joystick &Joystick) int {
	return C.SDL_JoystickIsHaptic(joystick)
}

fn C.SDL_HapticOpenFromJoystick(joystick &C.SDL_Joystick) &C.SDL_Haptic

// haptic_open_from_joystick opens a haptic device for use from a joystick device.
//
// You must still close the haptic device separately.  It will not be closed
// with the joystick.
//
// When opening from a joystick you should first close the haptic device before
// closing the joystick device.  If not, on some implementations the haptic
// device will also get unallocated and you'll be unable to use force feedback
// on that device.
//
// `joystick` Joystick to create a haptic device from.
// returns A valid haptic device identifier on success or NULL on error.
//
// See also: SDL_HapticOpen
// See also: SDL_HapticClose
pub fn haptic_open_from_joystick(joystick &Joystick) &Haptic {
	return C.SDL_HapticOpenFromJoystick(joystick)
}

fn C.SDL_HapticClose(haptic &C.SDL_Haptic)

// haptic_close closes a haptic device previously opened with SDL_HapticOpen().
//
// `haptic` Haptic device to close.
pub fn haptic_close(haptic &Haptic) {
	C.SDL_HapticClose(haptic)
}

fn C.SDL_HapticNumEffects(haptic &C.SDL_Haptic) int

// haptic_num_effects returns the number of effects a haptic device can store.
//
// On some platforms this isn't fully supported, and therefore is an
// approximation.  Always check to see if your created effect was actually
// created and do not rely solely on SDL_HapticNumEffects().
//
// `haptic` The haptic device to query effect max.
// returns The number of effects the haptic device can store or
// -1 on error.
//
// See also: SDL_HapticNumEffectsPlaying
// See also: SDL_HapticQuery
pub fn haptic_num_effects(haptic &Haptic) int {
	return C.SDL_HapticNumEffects(haptic)
}

fn C.SDL_HapticNumEffectsPlaying(haptic &C.SDL_Haptic) int

// haptic_num_effects_playing returns the number of effects a haptic device can play at the same
// time.
//
// This is not supported on all platforms, but will always return a value.
// Added here for the sake of completeness.
//
// `haptic` The haptic device to query maximum playing effects.
// returns The number of effects the haptic device can play at the same time
// or -1 on error.
//
// See also: SDL_HapticNumEffects
// See also: SDL_HapticQuery
pub fn haptic_num_effects_playing(haptic &Haptic) int {
	return C.SDL_HapticNumEffectsPlaying(haptic)
}

fn C.SDL_HapticQuery(haptic &C.SDL_Haptic) u32

// haptic_query gets the haptic device's supported features in bitwise manner.
//
// Example:
/*
```
 if (SDL_HapticQuery(haptic) & SDL_HAPTIC_CONSTANT) {
 printf("We have constant haptic effect!\n");
}
```
*/
//
// `haptic` The haptic device to query.
// returns Haptic features in bitwise manner (OR'd).
//
// See also: SDL_HapticNumEffects
// See also: SDL_HapticEffectSupported
pub fn haptic_query(haptic &Haptic) u32 {
	return C.SDL_HapticQuery(haptic)
}

fn C.SDL_HapticNumAxes(haptic &C.SDL_Haptic) int

// haptic_num_axes gets the number of haptic axes the device has.
//
// See also: SDL_HapticDirection
pub fn haptic_num_axes(haptic &Haptic) int {
	return C.SDL_HapticNumAxes(haptic)
}

fn C.SDL_HapticEffectSupported(haptic &C.SDL_Haptic, effect &C.SDL_HapticEffect) int

// haptic_effect_supported checks to see if effect is supported by haptic.
//
// `haptic` Haptic device to check on.
// `effect` Effect to check to see if it is supported.
// returns SDL_TRUE if effect is supported, SDL_FALSE if it isn't or -1 on error.
//
// See also: SDL_HapticQuery
// See also: SDL_HapticNewEffect
pub fn haptic_effect_supported(haptic &Haptic, effect &HapticEffect) int {
	return C.SDL_HapticEffectSupported(haptic, effect)
}

fn C.SDL_HapticNewEffect(haptic &C.SDL_Haptic, effect &C.SDL_HapticEffect) int

// haptic_new_effect creates a new haptic effect on the device.
//
// `haptic` Haptic device to create the effect on.
// `effect` Properties of the effect to create.
// returns The identifier of the effect on success or -1 on error.
//
// See also: SDL_HapticUpdateEffect
// See also: SDL_HapticRunEffect
// See also: SDL_HapticDestroyEffect
pub fn haptic_new_effect(haptic &Haptic, effect &HapticEffect) int {
	return C.SDL_HapticNewEffect(haptic, effect)
}

fn C.SDL_HapticUpdateEffect(haptic &C.SDL_Haptic, effect int, data &C.SDL_HapticEffect) int

// haptic_update_effect updates the properties of an effect.
//
// Can be used dynamically, although behavior when dynamically changing
// direction may be strange.  Specifically the effect may reupload itself
// and start playing from the start.  You cannot change the type either when
// running SDL_HapticUpdateEffect().
//
// `haptic` Haptic device that has the effect.
// `effect` Identifier of the effect to update.
// `data` New effect properties to use.
// returns 0 on success or -1 on error.
//
// See also: SDL_HapticNewEffect
// See also: SDL_HapticRunEffect
// See also: SDL_HapticDestroyEffect
pub fn haptic_update_effect(haptic &Haptic, effect int, data &HapticEffect) int {
	return C.SDL_HapticUpdateEffect(haptic, effect, data)
}

fn C.SDL_HapticRunEffect(haptic &C.SDL_Haptic, effect int, iterations u32) int

// haptic_run_effect runs the haptic effect on its associated haptic device.
//
// If iterations are ::SDL_HAPTIC_INFINITY, it'll run the effect over and over
// repeating the envelope (attack and fade) every time.  If you only want the
// effect to last forever, set ::SDL_HAPTIC_INFINITY in the effect's length
// parameter.
//
// `haptic` Haptic device to run the effect on.
// `effect` Identifier of the haptic effect to run.
// `iterations` Number of iterations to run the effect. Use
// ::SDL_HAPTIC_INFINITY for infinity.
// returns 0 on success or -1 on error.
//
// See also: SDL_HapticStopEffect
// See also: SDL_HapticDestroyEffect
// See also: SDL_HapticGetEffectStatus
pub fn haptic_run_effect(haptic &Haptic, effect int, iterations u32) int {
	return C.SDL_HapticRunEffect(haptic, effect, iterations)
}

fn C.SDL_HapticStopEffect(haptic &C.SDL_Haptic, effect int) int

// haptic_stop_effect stops the haptic effect on its associated haptic device.
//
// `haptic` Haptic device to stop the effect on.
// `effect` Identifier of the effect to stop.
// returns 0 on success or -1 on error.
//
// See also: SDL_HapticRunEffect
// See also: SDL_HapticDestroyEffect
pub fn haptic_stop_effect(haptic &Haptic, effect int) int {
	return C.SDL_HapticStopEffect(haptic, effect)
}

fn C.SDL_HapticDestroyEffect(haptic &C.SDL_Haptic, effect int)

// haptic_destroy_effect destroys a haptic effect on the device.
//
// This will stop the effect if it's running.  Effects are automatically
// destroyed when the device is closed.
//
// `haptic` Device to destroy the effect on.
// `effect` Identifier of the effect to destroy.
//
// See also: SDL_HapticNewEffect
pub fn haptic_destroy_effect(haptic &Haptic, effect int) {
	C.SDL_HapticDestroyEffect(haptic, effect)
}

fn C.SDL_HapticGetEffectStatus(haptic &C.SDL_Haptic, effect int) int

// haptic_get_effect_status gets the status of the current effect on the haptic device.
//
// Device must support the ::SDL_HAPTIC_STATUS feature.
//
// `haptic` Haptic device to query the effect status on.
// `effect` Identifier of the effect to query its status.
// returns 0 if it isn't playing, 1 if it is playing or -1 on error.
//
// See also: SDL_HapticRunEffect
// See also: SDL_HapticStopEffect
pub fn haptic_get_effect_status(haptic &Haptic, effect int) int {
	return C.SDL_HapticGetEffectStatus(haptic, effect)
}

fn C.SDL_HapticSetGain(haptic &C.SDL_Haptic, gain int) int

// haptic_set_gain sets the global gain of the device.
//
// Device must support the ::SDL_HAPTIC_GAIN feature.
//
// The user may specify the maximum gain by setting the environment variable
// SDL_HAPTIC_GAIN_MAX which should be between 0 and 100.  All calls to
// SDL_HapticSetGain() will scale linearly using SDL_HAPTIC_GAIN_MAX as the
// maximum.
//
// `haptic` Haptic device to set the gain on.
// `gain` Value to set the gain to, should be between 0 and 100.
// returns 0 on success or -1 on error.
//
// See also: SDL_HapticQuery
pub fn haptic_set_gain(haptic &Haptic, gain int) int {
	return C.SDL_HapticSetGain(haptic, gain)
}

fn C.SDL_HapticSetAutocenter(haptic &C.SDL_Haptic, autocenter int) int

// haptic_set_autocenter sets the global autocenter of the device.
//
// Autocenter should be between 0 and 100.  Setting it to 0 will disable
// autocentering.
//
// Device must support the ::SDL_HAPTIC_AUTOCENTER feature.
//
// `haptic` Haptic device to set autocentering on.
// `autocenter` Value to set autocenter to, 0 disables autocentering.
// returns 0 on success or -1 on error.
//
// See also: SDL_HapticQuery
pub fn haptic_set_autocenter(haptic &Haptic, autocenter int) int {
	return C.SDL_HapticSetAutocenter(haptic, autocenter)
}

fn C.SDL_HapticPause(haptic &C.SDL_Haptic) int

// haptic_pause pauses a haptic device.
//
// Device must support the ::SDL_HAPTIC_PAUSE feature.  Call
// SDL_HapticUnpause() to resume playback.
//
// Do not modify the effects nor add new ones while the device is paused.
// That can cause all sorts of weird errors.
//
// `haptic` Haptic device to pause.
// returns 0 on success or -1 on error.
//
// See also: SDL_HapticUnpause
pub fn haptic_pause(haptic &Haptic) int {
	return C.SDL_HapticPause(haptic)
}

fn C.SDL_HapticUnpause(haptic &C.SDL_Haptic) int

// haptic_unpause unpauses a haptic device.
//
// Call to unpause after SDL_HapticPause().
//
// `haptic` Haptic device to unpause.
// returns 0 on success or -1 on error.
//
// See also: SDL_HapticPause
pub fn haptic_unpause(haptic &Haptic) int {
	return C.SDL_HapticUnpause(haptic)
}

fn C.SDL_HapticStopAll(haptic &C.SDL_Haptic) int

// haptic_stop_all stops all the currently playing effects on a haptic device.
//
// `haptic` Haptic device to stop.
// returns 0 on success or -1 on error.
pub fn haptic_stop_all(haptic &Haptic) int {
	return C.SDL_HapticStopAll(haptic)
}

fn C.SDL_HapticRumbleSupported(haptic &C.SDL_Haptic) int

// haptic_rumble_supported checks to see if rumble is supported on a haptic device.
//
// `haptic` Haptic device to check to see if it supports rumble.
// returns SDL_TRUE if effect is supported, SDL_FALSE if it isn't or -1 on error.
//
// See also: SDL_HapticRumbleInit
// See also: SDL_HapticRumblePlay
// See also: SDL_HapticRumbleStop
pub fn haptic_rumble_supported(haptic &Haptic) int {
	return C.SDL_HapticRumbleSupported(haptic)
}

fn C.SDL_HapticRumbleInit(haptic &C.SDL_Haptic) int

// haptic_rumble_init initializes the haptic device for simple rumble playback.
//
// `haptic` Haptic device to initialize for simple rumble playback.
// returns 0 on success or -1 on error.
//
// See also: SDL_HapticOpen
// See also: SDL_HapticRumbleSupported
// See also: SDL_HapticRumblePlay
// See also: SDL_HapticRumbleStop
pub fn haptic_rumble_init(haptic &Haptic) int {
	return C.SDL_HapticRumbleInit(haptic)
}

fn C.SDL_HapticRumblePlay(haptic &C.SDL_Haptic, strength f32, length u32) int

// haptic_rumble_play runs simple rumble on a haptic device
//
// `haptic` Haptic device to play rumble effect on.
// `strength` Strength of the rumble to play as a 0-1 float value.
// `length` Length of the rumble to play in milliseconds.
// returns 0 on success or -1 on error.
//
// See also: SDL_HapticRumbleSupported
// See also: SDL_HapticRumbleInit
// See also: SDL_HapticRumbleStop
pub fn haptic_rumble_play(haptic &Haptic, strength f32, length u32) int {
	return C.SDL_HapticRumblePlay(haptic, strength, length)
}

fn C.SDL_HapticRumbleStop(haptic &C.SDL_Haptic) int

// haptic_rumble_stop stops the simple rumble on a haptic device.
//
// `haptic` Haptic to stop the rumble on.
// returns 0 on success or -1 on error.
//
// See also: SDL_HapticRumbleSupported
// See also: SDL_HapticRumbleInit
// See also: SDL_HapticRumblePlay
pub fn haptic_rumble_stop(haptic &Haptic) int {
	return C.SDL_HapticRumbleStop(haptic)
}
