// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_events.h
//

pub const released = C.SDL_RELEASED // 0

pub const pressed = C.SDL_PRESSED // 1

pub const textinputevent_text_size = C.SDL_TEXTINPUTEVENT_TEXT_SIZE // (32)

pub const texteditingevent_text_size = C.SDL_TEXTEDITINGEVENT_TEXT_SIZE // (32)

pub const query = C.SDL_QUERY // -1

pub const ignore = C.SDL_IGNORE // 0

pub const disable = C.SDL_DISABLE // 0

pub const enable = C.SDL_ENABLE // 1

// EventFilter is a function pointer used for callbacks that watch the event queue.
//
// `userdata` what was passed as `userdata` to SDL_SetEventFilter()
//            or SDL_AddEventWatch, etc
// `event` the event that triggered the callback
// returns 1 to permit event to be added to the queue, and 0 to disallow
//          it. When used with SDL_AddEventWatch, the return value is ignored.
//
// See also: SDL_SetEventFilter
// See also: SDL_AddEventWatch
//
// EventFilter is equivalent to the SDL C callback:
// `typedef int (SDLCALL * SDL_EventFilter) (void *userdata, SDL_Event * event);`
pub type EventFilter = fn (userdata voidptr, event &Event)

// EventType is C.SDL_EventType
pub enum EventType {
	firstevent               = C.SDL_FIRSTEVENT // Unused (do not remove)
	quit                     = C.SDL_QUIT // 0x100 User-requested quit
	// These application events have special meaning on iOS, see README-ios.md in SDL for details
	// The application is being terminated by the OS
	// Called on iOS in applicationWillTerminate()
	// Called on Android in onDestroy()
	app_terminating          = C.SDL_APP_TERMINATING
	// The application is low on memory, free memory if possible.
	// Called on iOS in applicationDidReceiveMemoryWarning()
	// Called on Android in onLowMemory()
	app_lowmemory            = C.SDL_APP_LOWMEMORY
	// The application is about to enter the background
	// Called on iOS in applicationWillResignActive()
	// Called on Android in onPause()
	app_willenterbackground  = C.SDL_APP_WILLENTERBACKGROUND
	// The application did enter the background and may not get CPU for some time
	// Called on iOS in applicationDidEnterBackground()
	// Called on Android in onPause()
	app_didenterbackground   = C.SDL_APP_DIDENTERBACKGROUND
	// The application is about to enter the foreground
	// Called on iOS in applicationWillEnterForeground()
	// Called on Android in onResume()
	app_willenterforeground  = C.SDL_APP_WILLENTERFOREGROUND
	// The application is now interactive
	// Called on iOS in applicationDidBecomeActive()
	// Called on Android in onResume()
	app_didenterforeground   = C.SDL_APP_DIDENTERFOREGROUND
	localechanged            = C.SDL_LOCALECHANGED // The user's locale preferences have changed.
	// Display events
	displayevent             = C.SDL_DISPLAYEVENT // 0x150 Display state change
	// Window events
	windowevent              = C.SDL_WINDOWEVENT // 0x200 Window state change
	syswmevent               = C.SDL_SYSWMEVENT
	// Keyboard events
	keydown                  = C.SDL_KEYDOWN // 0x300, Key pressed
	keyup                    = C.SDL_KEYUP // Key released
	textediting              = C.SDL_TEXTEDITING // Keyboard text editing (composition)
	textinput                = C.SDL_TEXTINPUT // Keyboard text input
	keymapchanged            = C.SDL_KEYMAPCHANGED // Keymap changed due to a system event such as an input language or keyboard layout change.
	textediting_ext          = C.SDL_TEXTEDITING_EXT // Extended keyboard text editing (composition)
	// Mouse events
	mousemotion              = C.SDL_MOUSEMOTION // 0x400, Mouse moved
	mousebuttondown          = C.SDL_MOUSEBUTTONDOWN // Mouse button pressed
	mousebuttonup            = C.SDL_MOUSEBUTTONUP // Mouse button released
	mousewheel               = C.SDL_MOUSEWHEEL // Mouse wheel motion
	// Joystick events
	joyaxismotion            = C.SDL_JOYAXISMOTION // 0x600, Joystick axis motion
	joyballmotion            = C.SDL_JOYBALLMOTION // Joystick trackball motion
	joyhatmotion             = C.SDL_JOYHATMOTION // Joystick hat position change
	joybuttondown            = C.SDL_JOYBUTTONDOWN // Joystick button pressed
	joybuttonup              = C.SDL_JOYBUTTONUP // Joystick button released
	joydeviceadded           = C.SDL_JOYDEVICEADDED // A new joystick has been inserted into the system
	joydeviceremoved         = C.SDL_JOYDEVICEREMOVED // An opened joystick has been removed
	// Game controller events
	controlleraxismotion     = C.SDL_CONTROLLERAXISMOTION // 0x650, Game controller axis motion
	controllerbuttondown     = C.SDL_CONTROLLERBUTTONDOWN // Game controller button pressed
	controllerbuttonup       = C.SDL_CONTROLLERBUTTONUP // Game controller button released
	controllerdeviceadded    = C.SDL_CONTROLLERDEVICEADDED // A new Game controller has been inserted into the system
	controllerdeviceremoved  = C.SDL_CONTROLLERDEVICEREMOVED // An opened Game controller has been removed
	controllerdeviceremapped = C.SDL_CONTROLLERDEVICEREMAPPED // The controller mapping was updated
	controllertouchpaddown   = C.SDL_CONTROLLERTOUCHPADDOWN // Game controller touchpad was touched
	controllertouchpadmotion = C.SDL_CONTROLLERTOUCHPADMOTION // Game controller touchpad finger was moved
	controllertouchpadup     = C.SDL_CONTROLLERTOUCHPADUP // Game controller touchpad finger was lifted
	controllersensorupdate   = C.SDL_CONTROLLERSENSORUPDATE // Game controller sensor was updated
	// Touch events
	fingerdown               = C.SDL_FINGERDOWN // 0x700
	fingerup                 = C.SDL_FINGERUP
	fingermotion             = C.SDL_FINGERMOTION
	// Gesture events
	dollargesture            = C.SDL_DOLLARGESTURE // 0x800
	dollarrecord             = C.SDL_DOLLARRECORD
	multigesture             = C.SDL_MULTIGESTURE
	// Clipboard events
	clipboardupdate          = C.SDL_CLIPBOARDUPDATE // 0x900 The clipboard changed
	// Drag and drop events
	dropfile                 = C.SDL_DROPFILE // 0x1000 The system requests a file open
	droptext                 = C.SDL_DROPTEXT // text/plain drag-and-drop event
	dropbegin                = C.SDL_DROPBEGIN // A new set of drops is beginning (NULL filename)
	dropcomplete             = C.SDL_DROPCOMPLETE // Current set of drops is now complete (NULL filename)
	// Audio hotplug events
	audiodeviceadded         = C.SDL_AUDIODEVICEADDED // 0x1100 A new audio device is available
	audiodeviceremoved       = C.SDL_AUDIODEVICEREMOVED // An audio device has been removed.
	// Sensor events
	sensorupdate             = C.SDL_SENSORUPDATE // 0x1200 A sensor was updated
	// Render events
	render_targets_reset     = C.SDL_RENDER_TARGETS_RESET // 0x2000 The render targets have been reset and their contents need to be updated
	render_device_reset      = C.SDL_RENDER_DEVICE_RESET // The device has been reset and all textures need to be recreated
	// Internal events
	pollsentinel             = C.SDL_POLLSENTINEL // 0x7F00, Signals the end of an event poll cycle
	// Events ::SDL_USEREVENT through ::SDL_LASTEVENT are for your use, and should be allocated with SDL_RegisterEvents()
	userevent                = C.SDL_USEREVENT
	// This last event is only for bounding internal arrays
	lastevent                = C.SDL_LASTEVENT // 0xFFFF
}

// CommonEvent is fields shared by every event
@[typedef]
pub struct C.SDL_CommonEvent {
pub:
	@type     EventType
	timestamp u32 // In milliseconds, populated using SDL_GetTicks()
}

pub type CommonEvent = C.SDL_CommonEvent

// DisplayEvent is display state change event data (event.display.*)
// DisplayEvent is C.SDL_DisplayEvent
@[typedef]
pub struct C.SDL_DisplayEvent {
pub:
	@type     u32 // ::SDL_DISPLAYEVENT
	timestamp u32 // In milliseconds, populated using SDL_GetTicks()
	display   u32 // The associated display index
	event     u8  // ::SDL_DisplayEventID
	padding1  u8  //
	padding2  u8  //
	padding3  u8  //
	data1     int // event dependent data
}

pub type DisplayEvent = C.SDL_DisplayEvent

// WindowEvent is window state change event data (event.window.*)
@[typedef]
pub struct C.SDL_WindowEvent {
pub:
	@type     EventType // ::SDL_WINDOWEVENT
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The associated window
	event     u8        // ::SDL_WindowEventID
	padding1  u8
	padding2  u8
	padding3  u8
	data1     int // event dependent data
	data2     int // event dependent data
}

pub type WindowEvent = C.SDL_WindowEvent

// KeyboardEvent is Keyboard button event structure (event.key.*)
@[typedef]
pub struct C.SDL_KeyboardEvent {
pub:
	@type     EventType // ::SDL_KEYDOWN or ::SDL_KEYUP
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with keyboard focus, if any
	state     u8        // ::SDL_PRESSED or ::SDL_RELEASED
	repeat    u8        // Non-zero if this is a key repeat
	padding2  u8
	padding3  u8
	keysym    Keysym // The key that was pressed or released
}

pub type KeyboardEvent = C.SDL_KeyboardEvent

// TextEditingEvent is keyboard text editing event structure (event.edit.*)
@[typedef]
pub struct C.SDL_TextEditingEvent {
pub:
	@type     EventType // ::SDL_TEXTEDITING
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with keyboard focus, if any
	text      [32]char  // text[SDL_TEXTEDITINGEVENT_TEXT_SIZE] char
	start     int       // The start cursor of selected editing text
	length    int       // The length of selected editing text
}

pub type TextEditingEvent = C.SDL_TextEditingEvent

// TextEditingExtEvent is an extended keyboard text editing event structure (event.editExt.*) when text would be
// truncated if stored in the text buffer SDL_TextEditingEvent
@[typedef]
pub struct C.SDL_TextEditingExtEvent {
	@type     u32   // ::SDL_TEXTEDITING_EXT
	timestamp u32   // In milliseconds, populated using SDL_GetTicks()
	windowID  u32   // The window with keyboard focus, if any
	text      &char // The editing text, which should be freed with SDL_free(), and will not be NULL
	start     int   // The start cursor of selected editing text
	length    int   // The length of selected editing text
}

pub type TextEditingExtEvent = C.SDL_TextEditingExtEvent

// TextInputEvent is keyboard text input event structure (event.text.*)
@[typedef]
pub struct C.SDL_TextInputEvent {
pub:
	@type     EventType // ::SDL_TEXTINPUT
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with keyboard focus, if any
	text      [32]char  // text[SDL_TEXTINPUTEVENT_TEXT_SIZE] char
}

pub type TextInputEvent = C.SDL_TextInputEvent

// MouseMotionEvent is mouse motion event structure (event.motion.*)
@[typedef]
pub struct C.SDL_MouseMotionEvent {
pub:
	@type     EventType // ::SDL_MOUSEMOTION
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with mouse focus, if any
	which     u32       // The mouse instance id, or SDL_TOUCH_MOUSEID
	state     u32       // The current button state
	x         int       // X coordinate, relative to window
	y         int       // Y coordinate, relative to window
	xrel      int       // The relative motion in the X direction
	yrel      int       // The relative motion in the Y direction
}

pub type MouseMotionEvent = C.SDL_MouseMotionEvent

// MouseButtonEvent is mouse button event structure (event.button.*)
@[typedef]
pub struct C.SDL_MouseButtonEvent {
pub:
	@type     EventType // ::SDL_MOUSEBUTTONDOWN or ::SDL_MOUSEBUTTONUP
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with mouse focus, if any
	which     u32       // The mouse instance id, or SDL_TOUCH_MOUSEID
	button    u8        // The mouse button index
	state     u8        // ::SDL_PRESSED or ::SDL_RELEASED
	clicks    u8        // 1 for single-click, 2 for double-click, etc.
	padding1  u8
	x         int // X coordinate, relative to window
	y         int // Y coordinate, relative to window
}

pub type MouseButtonEvent = C.SDL_MouseButtonEvent

// MouseWheelEvent is mouse wheel event structure (event.wheel.*)
@[typedef]
pub struct C.SDL_MouseWheelEvent {
pub:
	@type     EventType // ::SDL_MOUSEWHEEL
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with mouse focus, if any
	which     u32       // The mouse instance id, or SDL_TOUCH_MOUSEID
	x         int       // The amount scrolled horizontally, positive to the right and negative to the left
	y         int       // The amount scrolled vertically, positive away from the user and negative toward the user
	direction u32       // Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back
	preciseX  f32       // The amount scrolled horizontally, positive to the right and negative to the left, with float precision (added in 2.0.18)
	preciseY  f32       // The amount scrolled vertically, positive away from the user and negative toward the user, with float precision (added in 2.0.18)
}

pub type MouseWheelEvent = C.SDL_MouseWheelEvent

// JoyAxisEvent is joystick axis motion event structure (event.jaxis.*)
@[typedef]
pub struct C.SDL_JoyAxisEvent {
pub:
	@type     EventType  // ::SDL_JOYAXISMOTION
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // The joystick instance id
	axis      u8 // The joystick axis index
	padding1  u8
	padding2  u8
	padding3  u8
	value     i16 // The axis value (range: -32768 to 32767)
	padding4  u16
}

pub type JoyAxisEvent = C.SDL_JoyAxisEvent

// JoyBallEvent is joystick trackball motion event structure (event.jball.*)
@[typedef]
pub struct C.SDL_JoyBallEvent {
pub:
	@type     EventType  // ::SDL_JOYBALLMOTION
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // C.SDL_JoystickID // The joystick instance id
	ball      u8 // The joystick trackball index
	padding1  u8
	padding2  u8
	padding3  u8
	xrel      i16 // The relative motion in the X direction
	yrel      i16 // The relative motion in the Y direction
}

pub type JoyBallEvent = C.SDL_JoyBallEvent

// JoyHatEvent is joystick hat position change event structure (event.jhat.*)
@[typedef]
pub struct C.SDL_JoyHatEvent {
pub:
	@type     EventType  // ::SDL_JOYHATMOTION
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // C.SDL_JoystickID // The joystick instance id
	hat       u8 // The joystick hat index
	value     u8 // The hat position value.
	// See also: ::SDL_HAT_LEFTUP ::SDL_HAT_UP ::SDL_HAT_RIGHTUP
	// See also: ::SDL_HAT_LEFT ::SDL_HAT_CENTERED ::SDL_HAT_RIGHT
	// See also: ::SDL_HAT_LEFTDOWN ::SDL_HAT_DOWN ::SDL_HAT_RIGHTDOWN
	// Note that zero means the POV is centered.
	padding1 u8
	padding2 u8
}

pub type JoyHatEvent = C.SDL_JoyHatEvent

// JoyButtonEvent is joystick button event structure (event.jbutton.*)
@[typedef]
pub struct C.SDL_JoyButtonEvent {
pub:
	@type     EventType  // ::SDL_JOYBUTTONDOWN or ::SDL_JOYBUTTONUP
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // C.SDL_JoystickID // The joystick instance id
	button    u8 // The joystick button index
	state     u8 // ::SDL_PRESSED or ::SDL_RELEASED
	padding1  u8
	padding2  u8
}

pub type JoyButtonEvent = C.SDL_JoyButtonEvent

// JoyDeviceEvent is joystick device event structure (event.jdevice.*)
@[typedef]
pub struct C.SDL_JoyDeviceEvent {
pub:
	@type     EventType // ::SDL_JOYDEVICEADDED or ::SDL_JOYDEVICEREMOVED
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	which     int       // The joystick device index for the ADDED event, instance id for the REMOVED event
}

pub type JoyDeviceEvent = C.SDL_JoyDeviceEvent

// ControllerAxisEvent is game controller axis motion event structure (event.caxis.*)
@[typedef]
pub struct C.SDL_ControllerAxisEvent {
pub:
	@type     EventType  // ::SDL_CONTROLLERAXISMOTION
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // C.SDL_JoystickID // The joystick instance id
	axis      u8 // The controller axis (SDL_GameControllerAxis)
	padding1  u8
	padding2  u8
	padding3  u8
	value     i16 // The axis value (range: -32768 to 32767)
	padding4  u16
}

pub type ControllerAxisEvent = C.SDL_ControllerAxisEvent

// ControllerButtonEvent is game controller button event structure (event.cbutton.*)
@[typedef]
pub struct C.SDL_ControllerButtonEvent {
pub:
	@type     EventType  // ::SDL_CONTROLLERBUTTONDOWN or ::SDL_CONTROLLERBUTTONUP
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // C.SDL_JoystickID // The joystick instance id
	button    u8 // The controller button (SDL_GameControllerButton)
	state     u8 // ::SDL_PRESSED or ::SDL_RELEASED
	padding1  u8
	padding2  u8
}

pub type ControllerButtonEvent = C.SDL_ControllerButtonEvent

// ControllerDeviceEvent is controller device event structure (event.cdevice.*)
@[typedef]
pub struct C.SDL_ControllerDeviceEvent {
pub:
	@type     EventType // ::SDL_CONTROLLERDEVICEADDED, ::SDL_CONTROLLERDEVICEREMOVED, or ::SDL_CONTROLLERDEVICEREMAPPED
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	which     int       // The joystick device index for the ADDED event, instance id for the REMOVED or REMAPPED event
}

pub type ControllerDeviceEvent = C.SDL_ControllerDeviceEvent

// ControllerTouchpadEvent is game controller touchpad event structure (event.ctouchpad.*)
@[typedef]
pub struct C.SDL_ControllerTouchpadEvent {
pub:
	@type     u32        // ::SDL_CONTROLLERTOUCHPADDOWN or ::SDL_CONTROLLERTOUCHPADMOTION or ::SDL_CONTROLLERTOUCHPADUP
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // The joystick instance id
	touchpad  int        // The index of the touchpad
	finger    int        // The index of the finger on the touchpad
	x         f32        // Normalized in the range 0...1 with 0 being on the left
	y         f32        // Normalized in the range 0...1 with 0 being at the top
	pressure  f32        // Normalized in the range 0...1
}

pub type ControllerTouchpadEvent = C.SDL_ControllerTouchpadEvent

@[typedef]
pub struct C.SDL_ControllerSensorEvent {
pub:
	@type     u32        // ::SDL_CONTROLLERSENSORUPDATE
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // The joystick instance id
	sensor    int        // The type of the sensor, one of the values of ::SDL_SensorType
	data      [3]f32     // Up to 3 values from the sensor, as defined in SDL_sensor.h
}

pub type ControllerSensorEvent = C.SDL_ControllerSensorEvent

// AudioDeviceEvent is audio device event structure (event.adevice.*)
@[typedef]
pub struct C.SDL_AudioDeviceEvent {
pub:
	@type     EventType // ::SDL_AUDIODEVICEADDED, or ::SDL_AUDIODEVICEREMOVED
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	which     u32       // The audio device index for the ADDED event (valid until next SDL_GetNumAudioDevices() call), SDL_AudioDeviceID for the REMOVED event
	iscapture u8        // zero if an output device, non-zero if a capture device.
	padding1  u8
	padding2  u8
	padding3  u8
}

pub type AudioDeviceEvent = C.SDL_AudioDeviceEvent

// TouchFingerEvent is touch finger event structure (event.tfinger.*)
@[typedef]
pub struct C.SDL_TouchFingerEvent {
pub:
	@type     EventType // ::SDL_FINGERMOTION or ::SDL_FINGERDOWN or ::SDL_FINGERUP
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	touchId   TouchID   // The touch device id
	fingerId  FingerID
	x         f32 // Normalized in the range 0...1
	y         f32 // Normalized in the range 0...1
	dx        f32 // Normalized in the range -1...1
	dy        f32 // Normalized in the range -1...1
	pressure  f32 // Normalized in the range 0...1
	windowID  u32 // The window underneath the finger, if any
}

pub type TouchFingerEvent = C.SDL_TouchFingerEvent

// MultiGestureEvent is Multiple Finger Gesture Event (event.mgesture.*)
@[typedef]
pub struct C.SDL_MultiGestureEvent {
pub:
	@type      EventType // ::SDL_MULTIGESTURE
	timestamp  u32       // In milliseconds, populated using SDL_GetTicks()
	touchId    TouchID   // The touch device id
	dTheta     f32
	dDist      f32
	x          f32
	y          f32
	numFingers u16
	padding    u16
}

pub type MultiGestureEvent = C.SDL_MultiGestureEvent

// DollarGestureEvent is Dollar Gesture Event (event.dgesture.*)
@[typedef]
pub struct C.SDL_DollarGestureEvent {
pub:
	@type      EventType // ::SDL_DOLLARGESTURE or ::SDL_DOLLARRECORD
	timestamp  u32       // In milliseconds, populated using SDL_GetTicks()
	touchId    TouchID   // The touch device id
	gestureId  GestureID
	numFingers u32
	error      f32
	x          f32 // Normalized center of gesture
	y          f32 // Normalized center of gesture
}

pub type DollarGestureEvent = C.SDL_DollarGestureEvent

// DropEvent is an event used to request a file open by the system (event.drop.*)
// This event is enabled by default, you can disable it with SDL_EventState().
// NOTE If this event is enabled, you must free the filename in the event.

@[typedef]
pub struct C.SDL_DropEvent {
pub:
	@type     EventType // ::SDL_DROPBEGIN or ::SDL_DROPFILE or ::SDL_DROPTEXT or ::SDL_DROPCOMPLETE
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	file      &char     // The file name, which should be freed with SDL_free(), is NULL on begin/complete
	windowID  u32       // The window that was dropped on, if any
}

pub type DropEvent = C.SDL_DropEvent

// SensorEvent is sensor event structure (event.sensor.*)
// SensorEvent is C.SDL_SensorEvent
@[typedef]
pub struct C.SDL_SensorEvent {
pub:
	@type     u32    // ::SDL_SENSORUPDATE
	timestamp u32    // In milliseconds, populated using SDL_GetTicks()
	which     int    // The instance ID of the sensor
	data      [6]f32 // Up to 6 values from the sensor - additional values can be queried using SDL_SensorGetData()
}

pub type SensorEvent = C.SDL_SensorEvent

// QuitEvent is the "quit requested" event
@[typedef]
pub struct C.SDL_QuitEvent {
pub:
	@type     EventType // ::SDL_QUIT
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
}

pub type QuitEvent = C.SDL_QuitEvent

// OSEvent is an OS Specific event
@[typedef]
pub struct C.SDL_OSEvent {
pub:
	@type     EventType // ::SDL_QUIT
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
}

pub type OSEvent = C.SDL_OSEvent

// UserEvent is an user-defined event type (event.user.*)
@[typedef]
pub struct C.SDL_UserEvent {
pub:
	@type     EventType // ::SDL_USEREVENT through ::SDL_LASTEVENT-1
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The associated window if any
	code      int       // User defined event code
	data1     voidptr   // User defined data pointer
	data2     voidptr   // User defined data pointer
}

pub type UserEvent = C.SDL_UserEvent

// SysWMmsg is a video driver dependent system event (event.syswm.*)
// This event is disabled by default, you can enable it with SDL_EventState()
//
// NOTE If you want to use this event, you should include SDL_syswm.h.
@[typedef]
pub struct C.SDL_SysWMmsg {
}

pub type SysWMmsg = C.SDL_SysWMmsg

@[typedef]
pub struct C.SDL_SysWMEvent {
pub:
	@type     EventType // ::SDL_SYSWMEVENT
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	msg       &SysWMmsg // driver dependent data, defined in SDL_syswm.h
}

pub type SysWMEvent = C.SDL_SysWMEvent

/*
TODO
const v_event_padding_size = v_get_event_padding_size()

fn v_get_event_padding_size() int {
	if sizeof(voidptr) <= 8 {
		return 56
	} else if sizeof(voidptr) == 16 {
		return 64
	}
	return 3 * sizeof(voidptr)
}
*/

// Event is a general event structure.
@[typedef]
pub union C.SDL_Event {
pub:
	@type EventType // Event type, shared with all events
	//
	common    CommonEvent         // C.SDL_CommonEvent             // Common event data
	display   DisplayEvent        // C.SDL_DisplayEvent            // Display event data
	window    WindowEvent         // C.SDL_WindowEvent             // Window event data
	key       KeyboardEvent       // C.SDL_KeyboardEvent           // Keyboard event data
	edit      TextEditingEvent    // C.SDL_TextEditingEvent        // Text editing event data
	editExt   TextEditingExtEvent // C.SDL_TextEditingExtEvent     // Extended text editing event data
	text      TextInputEvent      // C.SDL_TextInputEvent          // Text input event data
	motion    MouseMotionEvent    // C.SDL_MouseMotionEvent        // Mouse motion event data
	button    MouseButtonEvent    // C.SDL_MouseButtonEvent        // Mouse button event data
	wheel     MouseWheelEvent     // C.SDL_MouseWheelEvent         // Mouse wheel event data
	jaxis     JoyAxisEvent        // C.SDL_JoyAxisEvent            // Joystick axis event data
	jball     JoyBallEvent        // C.SDL_JoyBallEvent            // Joystick ball event data
	jhat      JoyHatEvent             // C.SDL_JoyHatEvent             // Joystick hat event data
	jbutton   JoyButtonEvent          // C.SDL_JoyButtonEvent          // Joystick button event data
	jdevice   JoyDeviceEvent          // C.SDL_JoyDeviceEvent          // Joystick device change event data
	caxis     ControllerAxisEvent     // C.SDL_ControllerAxisEvent     // Game Controller axis event data
	cbutton   ControllerButtonEvent   // C.SDL_ControllerButtonEvent   // Game Controller button event data
	cdevice   ControllerDeviceEvent   // C.SDL_ControllerDeviceEvent   // Game Controller device event data
	ctouchpad ControllerTouchpadEvent // C.SDL_ControllerTouchpadEvent // Game Controller touchpad event data
	csensor   ControllerSensorEvent   // C.SDL_ControllerSensorEvent   // Game Controller sensor event data
	adevice   AudioDeviceEvent        // C.SDL_AudioDeviceEvent        // Audio device event data
	sensor    SensorEvent // C.SDL_SensorEvent             // Sensor event data
	//

	quit     QuitEvent          // C.SDL_QuitEvent          // Quit request event data
	user     UserEvent          // C.SDL_UserEvent          // Custom event data
	syswm    SysWMEvent         // C.SDL_SysWMEvent         // System dependent window event data
	tfinger  TouchFingerEvent   // C.SDL_TouchFingerEvent   // Touch finger event data
	mgesture MultiGestureEvent  // C.SDL_MultiGestureEvent  // Gesture event data
	dgesture DollarGestureEvent // C.SDL_DollarGestureEvent // Gesture event data
	drop     DropEvent // C.SDL_DropEvent // Drag and drop event data
	// This is necessary for ABI compatibility between Visual C++ and GCC.
	// Visual C++ will respect the push pack pragma and use 52 bytes (size of
	// SDL_TextEditingEvent, the largest structure for 32-bit and 64-bit
	// architectures) for this union, and GCC will use the alignment of the
	// largest datatype within the union, which is 8 bytes on 64-bit
	// architectures.
	//
	// So... we'll add padding to force the size to be 56 bytes for both.
	//
	// On architectures where pointers are 16 bytes, this needs rounding up to
	// the next multiple of 16, 64, and on architectures where pointers are
	// even larger the size of SDL_UserEvent will dominate as being 3 pointers.
	padding [56]u8 // TODO v_event_padding_size??
	// Uint8 padding[sizeof(void *) <= 8 ? 56 : sizeof(void *) == 16 ? 64 : 3 * sizeof(void *)];
}

pub type Event = C.SDL_Event

fn C.SDL_PumpEvents()

// pump_events pumps the event loop, gathering events from the input devices.
//
// This function updates the event queue and internal input device state.
//
// **WARNING**: This should only be run in the thread that initialized the
// video subsystem, and for extra safety, you should consider only doing those
// things on the main thread in any case.
//
// SDL_PumpEvents() gathers all the pending input information from devices and
// places it in the event queue. Without calls to SDL_PumpEvents() no events
// would ever be placed on the queue. Often the need for calls to
// SDL_PumpEvents() is hidden from the user since SDL_PollEvent() and
// SDL_WaitEvent() implicitly call SDL_PumpEvents(). However, if you are not
// polling or waiting for events (e.g. you are filtering them), then you must
// call SDL_PumpEvents() to force an event queue update.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_PollEvent
// See also: SDL_WaitEvent
pub fn pump_events() {
	C.SDL_PumpEvents()
}

// EventAction is C.SDL_eventaction
pub enum EventAction {
	addevent  = C.SDL_ADDEVENT
	peekevent = C.SDL_PEEKEVENT
	getevent  = C.SDL_GETEVENT
}

fn C.SDL_PeepEvents(events &C.SDL_Event, numevents int, action C.SDL_eventaction, min_type u32, max_type u32) int

// peep_events checks the event queue for messages and optionally returns them.
//
// `action` may be any of the following:
//
// - `SDL_ADDEVENT`: up to `numevents` events will be added to the back of the
//   event queue.
// - `SDL_PEEKEVENT`: `numevents` events at the front of the event queue,
//   within the specified minimum and maximum type, will be returned to the
//   caller and will _not_ be removed from the queue.
// - `SDL_GETEVENT`: up to `numevents` events at the front of the event queue,
//   within the specified minimum and maximum type, will be returned to the
//   caller and will be removed from the queue.the back of the event queue.
//
// You may have to call SDL_PumpEvents() before calling this function.
// Otherwise, the events may not be ready to be filtered when you call
// SDL_PeepEvents().
//
// This function is thread-safe.
//
// `events` destination buffer for the retrieved events
// `numevents` if action is SDL_ADDEVENT, the number of events to add
//             back to the event queue; if action is SDL_PEEKEVENT or
//             SDL_GETEVENT, the maximum number of events to retrieve
// `action` action to take; see [[#action|Remarks]] for details
// `minType` minimum value of the event type to be considered;
//           SDL_FIRSTEVENT is a safe choice
// `maxType` maximum value of the event type to be considered;
//           SDL_LASTEVENT is a safe choice
// returns the number of events actually stored or a negative error code on
//         failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_PollEvent
// See also: SDL_PumpEvents
// See also: SDL_PushEvent
pub fn peep_events(events &Event, numevents int, action EventAction, min_type u32, max_type u32) int {
	return C.SDL_PeepEvents(unsafe { &C.SDL_Event(events) }, numevents, unsafe { C.SDL_eventaction(action) },
		min_type, max_type)
}

fn C.SDL_HasEvent(@type u32) bool

// has_event checks for the existence of a certain event type in the event queue.
//
// If you need to check for a range of event types, use SDL_HasEvents()
// instead.
//
// `type` the type of event to be queried; see SDL_EventType for details
// returns SDL_TRUE if events matching `type` are present, or SDL_FALSE if
//          events matching `type` are not present.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_HasEvents
pub fn has_event(@type EventType) bool {
	return C.SDL_HasEvent(u32(@type))
}

fn C.SDL_HasEvents(min_type u32, max_type u32) bool

// has_events checks for the existence of certain event types in the event queue.
//
// If you need to check for a single event type, use SDL_HasEvent() instead.
//
// `minType` the low end of event type to be queried, inclusive; see
//           SDL_EventType for details
// `maxType` the high end of event type to be queried, inclusive; see
//           SDL_EventType for details
// returns SDL_TRUE if events with type >= `minType` and <= `maxType` are
//         present, or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_HasEvent
pub fn has_events(min_type u32, max_type u32) bool {
	return C.SDL_HasEvents(min_type, max_type)
}

fn C.SDL_FlushEvent(@type u32)

// flush_event clears events of a specific type from the event queue.
//
// This will unconditionally remove any events from the queue that match
// `type`. If you need to remove a range of event types, use SDL_FlushEvents()
// instead.
//
// It's also normal to just ignore events you don't care about in your event
// loop without calling this function.
//
// This function only affects currently queued events. If you want to make
// sure that all pending OS events are flushed, you can call SDL_PumpEvents()
// on the main thread immediately before the flush call.
//
// `type` the type of event to be cleared; see SDL_EventType for details
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_FlushEvents
pub fn flush_event(@type u32) {
	C.SDL_FlushEvent(@type)
}

fn C.SDL_FlushEvents(min_type u32, max_type u32)

// Clear events of a range of types from the event queue.
//
// This will unconditionally remove any events from the queue that are in the
// range of `minType` to `maxType`, inclusive. If you need to remove a single
// event type, use SDL_FlushEvent() instead.
//
// It's also normal to just ignore events you don't care about in your event
// loop without calling this function.
//
// This function only affects currently queued events. If you want to make
// sure that all pending OS events are flushed, you can call SDL_PumpEvents()
// on the main thread immediately before the flush call.
//
// `minType` the low end of event type to be cleared, inclusive; see
//                SDL_EventType for details
// `maxType` the high end of event type to be cleared, inclusive; see
//                SDL_EventType for details
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_FlushEvent
pub fn flush_events(min_type u32, max_type u32) {
	C.SDL_FlushEvents(min_type, max_type)
}

fn C.SDL_PollEvent(event &C.SDL_Event) int

// poll_event polls for currently pending events.
//
// If `event` is not NULL, the next event is removed from the queue and stored
// in the SDL_Event structure pointed to by `event`. The 1 returned refers to
// this event, immediately stored in the SDL Event structure -- not an event
// to follow.
//
// If `event` is NULL, it simply returns 1 if there is an event in the queue,
// but will not remove it from the queue.
//
// As this function may implicitly call SDL_PumpEvents(), you can only call
// this function in the thread that set the video mode.
//
// SDL_PollEvent() is the favored way of receiving system events since it can
// be done from the main loop and does not suspend the main loop while waiting
// on an event to be posted.
//
// The common practice is to fully process the event queue once every frame,
// usually as a first step before updating the game's state:
//
/*
```c
 while (game_is_still_running) {
     SDL_Event event;
     while (SDL_PollEvent(&event)) {  // poll until all events are handled!
         // decide what to do with this event.
     }

     // update game state, draw the current frame
 }
```
*/
//
// `event` the SDL_Event structure to be filled with the next event from
//         the queue, or NULL
// returns 1 if there is a pending event or 0 if there are none available.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetEventFilter
// See also: SDL_PeepEvents
// See also: SDL_PushEvent
// See also: SDL_SetEventFilter
// See also: SDL_WaitEvent
// See also: SDL_WaitEventTimeout
pub fn poll_event(event &Event) int {
	return C.SDL_PollEvent(event)
}

fn C.SDL_WaitEvent(event &C.SDL_Event) int

// wait_event waits indefinitely for the next available event.
//
// If `event` is not NULL, the next event is removed from the queue and stored
// in the SDL_Event structure pointed to by `event`.
//        stored in that area.
// As this function may implicitly call SDL_PumpEvents(), you can only call
// this function in the thread that initialized the video subsystem.
//
// `event` the SDL_Event structure to be filled in with the next event
//         from the queue, or NULL
// returns 1 on success or 0 if there was an error while waiting for events;
//         call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_PollEvent
// See also: SDL_PumpEvents
// See also: SDL_WaitEventTimeout
pub fn wait_event(event &Event) int {
	return C.SDL_WaitEvent(event)
}

fn C.SDL_WaitEventTimeout(event &C.SDL_Event, timeout int) int

// wait_event_timeout waits until the specified timeout (in milliseconds) for the next available
// event.
//
// If `event` is not NULL, the next event is removed from the queue and stored
// in the SDL_Event structure pointed to by `event`.
//
// As this function may implicitly call SDL_PumpEvents(), you can only call
// this function in the thread that initialized the video subsystem.
//
// `event` the SDL_Event structure to be filled in with the next event
//         from the queue, or NULL
// `timeout` the maximum number of milliseconds to wait for the next
//           available event
// returns 1 on success or 0 if there was an error while waiting for events;
//         call SDL_GetError() for more information. This also returns 0 if
//         the timeout elapsed without an event arriving.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_PollEvent
// See also: SDL_PumpEvents
// See also: SDL_WaitEvent
pub fn wait_event_timeout(event &Event, timeout int) int {
	return C.SDL_WaitEventTimeout(event, timeout)
}

fn C.SDL_PushEvent(event &C.SDL_Event) int

// push_event adds an event to the event queue.
//
// The event queue can actually be used as a two way communication channel.
// Not only can events be read from the queue, but the user can also push
// their own events onto it. `event` is a pointer to the event structure you
// wish to push onto the queue. The event is copied into the queue, and the
// caller may dispose of the memory pointed to after SDL_PushEvent() returns.
//
// NOTE Pushing device input events onto the queue doesn't modify the state
// of the device within SDL.
//
// This function is thread-safe, and can be called from other threads safely.
//
// NOTE Events pushed onto the queue with SDL_PushEvent() get passed through
// the event filter but events added with SDL_PeepEvents() do not.
//
// For pushing application-specific events, please use SDL_RegisterEvents() to
// get an event type that does not conflict with other code that also wants
// its own custom event types.
//
// `event` the SDL_Event to be added to the queue
// returns 1 on success, 0 if the event was filtered, or a negative error
//         code on failure; call SDL_GetError() for more information. A
//         common reason for error is the event queue being full.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_PeepEvents
// See also: SDL_PollEvent
// See also: SDL_RegisterEvents
pub fn push_event(event &Event) int {
	return C.SDL_PushEvent(event)
}

fn C.SDL_SetEventFilter(filter EventFilter, userdata voidptr)

// set_event_filter sets up a filter to process all events before they change
// internal state and are posted to the internal event queue.
//
// If the filter function returns 1 when called, then the event will be added
// to the internal queue. If it returns 0, then the event will be dropped from
// the queue, but the internal state will still be updated. This allows
// selective filtering of dynamically arriving events.
//
// **WARNING**: Be very careful of what you do in the event filter function,
// as it may run in a different thread!
//
// On platforms that support it, if the quit event is generated by an
// interrupt signal (e.g. pressing Ctrl-C), it will be delivered to the
// application at the next event poll.
//
// There is one caveat when dealing with the ::SDL_QuitEvent event type. The
// event filter is only called when the window manager desires to close the
// application window. If the event filter returns 1, then the window will be
// closed, otherwise the window will remain open if possible.
//
// Note: Disabled events never make it to the event filter function; see
// SDL_EventState().
//
// Note: If you just want to inspect events without filtering, you should use
// SDL_AddEventWatch() instead.
//
// Note: Events pushed onto the queue with SDL_PushEvent() get passed through
// the event filter, but events pushed onto the queue with SDL_PeepEvents() do
// not.
//
// `filter` An SDL_EventFilter function to call when an event happens
// `userdata` a pointer that is passed to `filter`
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AddEventWatch
// See also: SDL_EventState
// See also: SDL_GetEventFilter
// See also: SDL_PeepEvents
// See also: SDL_PushEvent
pub fn set_event_filter(filter EventFilter, userdata voidptr) {
	C.SDL_SetEventFilter(filter, userdata)
}

fn C.SDL_GetEventFilter(filter &EventFilter, userdata voidptr) bool

// get_event_filter queries the current event filter.
//
// This function can be used to "chain" filters, by saving the existing filter
// before replacing it with a function that will call that saved filter.
//
// `filter` the current callback function will be stored here
// `userdata` the pointer that is passed to the current event filter will
//            be stored here
// returns SDL_TRUE on success or SDL_FALSE if there is no event filter set.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetEventFilter
pub fn get_event_filter(filter &EventFilter, userdata voidptr) bool {
	return C.SDL_GetEventFilter(filter, userdata)
}

fn C.SDL_AddEventWatch(filter EventFilter, userdata voidptr)

// add_event_watch adds a callback to be triggered when an event is added to the event queue.
//
// `filter` will be called when an event happens, and its return value is
// ignored.
//
// **WARNING**: Be very careful of what you do in the event filter function,
// as it may run in a different thread!
//
// If the quit event is generated by a signal (e.g. SIGINT), it will bypass
// the internal queue and be delivered to the watch callback immediately, and
// arrive at the next event poll.
//
// NOTE the callback is called for events posted by the user through
// SDL_PushEvent(), but not for disabled events, nor for events by a filter
// callback set with SDL_SetEventFilter(), nor for events posted by the user
// through SDL_PeepEvents().
//
// `filter` an SDL_EventFilter function to call when an event happens.
// `userdata` a pointer that is passed to `filter`
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_DelEventWatch
// See also: SDL_SetEventFilter
pub fn add_event_watch(filter EventFilter, userdata voidptr) {
	C.SDL_AddEventWatch(filter, userdata)
}

fn C.SDL_DelEventWatch(filter EventFilter, userdata voidptr)

// del_event_watch removes an event watch callback added with SDL_AddEventWatch().
//
// This function takes the same input as SDL_AddEventWatch() to identify and
// delete the corresponding callback.
//
// `filter` the function originally passed to SDL_AddEventWatch()
// `userdata` the pointer originally passed to SDL_AddEventWatch()
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AddEventWatch
pub fn del_event_watch(filter EventFilter, userdata voidptr) {
	C.SDL_DelEventWatch(filter, userdata)
}

fn C.SDL_FilterEvents(filter EventFilter, userdata voidptr)

// filter_events runs a specific filter function on the current event queue, removing any
// events for which the filter returns 0.
//
// See SDL_SetEventFilter() for more information. Unlike SDL_SetEventFilter(),
// this function does not change the filter permanently, it only uses the
// supplied filter until this function returns.
//
// `filter` the SDL_EventFilter function to call when an event happens
// `userdata` a pointer that is passed to `filter`
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetEventFilter
// See also: SDL_SetEventFilter
pub fn filter_events(filter EventFilter, userdata voidptr) {
	C.SDL_FilterEvents(filter, userdata)
}

fn C.SDL_EventState(@type u32, state int) u8

// Set the state of processing events by type.
//
// `state` may be any of the following:
//
// - `SDL_QUERY`: returns the current processing state of the specified event
// - `SDL_IGNORE` (aka `SDL_DISABLE`): the event will automatically be dropped
//   from the event queue and will not be filtered
// - `SDL_ENABLE`: the event will be processed normally
//
// `type` the type of event; see SDL_EventType for details
// `state` how to process the event
// returns `SDL_DISABLE` or `SDL_ENABLE`, representing the processing state
//          of the event before this function makes any changes to it.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetEventState
pub fn event_state(@type u32, state int) u8 {
	return C.SDL_EventState(@type, state)
}

fn C.SDL_RegisterEvents(numevents int) u32

// Allocate a set of user-defined events, and return the beginning event
// number for that set of events.
//
// Calling this function with `numevents` <= 0 is an error and will return
// (Uint32)-1.
//
// Note, (Uint32)-1 means the maximum unsigned 32-bit integer value (or
// 0xFFFFFFFF), but is clearer to write.
//
// `numevents` the number of events to be allocated
// returns the beginning event number, or (Uint32)-1 if there are not enough
//         user-defined events left.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_PushEvent
pub fn register_events(numevents int) u32 {
	return C.SDL_RegisterEvents(numevents)
}
