// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_events.h
//

pub const (
	released = C.SDL_RELEASED // 0
	pressed  = C.SDL_PRESSED // 1
)

pub const (
	textinputevent_text_size   = C.SDL_TEXTINPUTEVENT_TEXT_SIZE // (32)
	texteditingevent_text_size = C.SDL_TEXTEDITINGEVENT_TEXT_SIZE // (32)
)

pub const (
	query   = C.SDL_QUERY // -1
	ignore  = C.SDL_IGNORE // 0
	disable = C.SDL_DISABLE // 0
	enable  = C.SDL_ENABLE // 1
)

// EventFilter is equivalent to the SDL C callback:
// `typedef int (SDLCALL * SDL_EventFilter) (void *userdata, SDL_Event * event);`
pub type EventFilter = fn (userdata voidptr, event &Event)

// EventType is C.SDL_EventType
pub enum EventType {
	firstevent = C.SDL_FIRSTEVENT // Unused (do not remove)
	quit = C.SDL_QUIT // 0x100 User-requested quit
	// These application events have special meaning on iOS, see README-ios.md in SDL for details
	// The application is being terminated by the OS
	// Called on iOS in applicationWillTerminate()
	// Called on Android in onDestroy()
	app_terminating = C.SDL_APP_TERMINATING
	// The application is low on memory, free memory if possible.
	// Called on iOS in applicationDidReceiveMemoryWarning()
	// Called on Android in onLowMemory()
	app_lowmemory = C.SDL_APP_LOWMEMORY
	// The application is about to enter the background
	// Called on iOS in applicationWillResignActive()
	// Called on Android in onPause()
	app_willenterbackground = C.SDL_APP_WILLENTERBACKGROUND
	// The application did enter the background and may not get CPU for some time
	// Called on iOS in applicationDidEnterBackground()
	// Called on Android in onPause()
	app_didenterbackground = C.SDL_APP_DIDENTERBACKGROUND
	// The application is about to enter the foreground
	// Called on iOS in applicationWillEnterForeground()
	// Called on Android in onResume()
	app_willenterforeground = C.SDL_APP_WILLENTERFOREGROUND
	// The application is now interactive
	// Called on iOS in applicationDidBecomeActive()
	// Called on Android in onResume()
	app_didenterforeground = C.SDL_APP_DIDENTERFOREGROUND
	localechanged = C.SDL_LOCALECHANGED // The user's locale preferences have changed.
	// Display events
	displayevent = C.SDL_DISPLAYEVENT // 0x150 Display state change
	// Window events
	windowevent = C.SDL_WINDOWEVENT // 0x200 Window state change
	syswmevent = C.SDL_SYSWMEVENT
	// Keyboard events
	keydown = C.SDL_KEYDOWN // 0x300, Key pressed
	keyup = C.SDL_KEYUP // Key released
	textediting = C.SDL_TEXTEDITING // Keyboard text editing (composition)
	textinput = C.SDL_TEXTINPUT // Keyboard text input
	keymapchanged = C.SDL_KEYMAPCHANGED // Keymap changed due to a system event such as an input language or keyboard layout change.
	// Mouse events
	mousemotion = C.SDL_MOUSEMOTION // 0x400, Mouse moved
	mousebuttondown = C.SDL_MOUSEBUTTONDOWN // Mouse button pressed
	mousebuttonup = C.SDL_MOUSEBUTTONUP // Mouse button released
	mousewheel = C.SDL_MOUSEWHEEL // Mouse wheel motion
	// Joystick events
	joyaxismotion = C.SDL_JOYAXISMOTION // 0x600, Joystick axis motion
	joyballmotion = C.SDL_JOYBALLMOTION // Joystick trackball motion
	joyhatmotion = C.SDL_JOYHATMOTION // Joystick hat position change
	joybuttondown = C.SDL_JOYBUTTONDOWN // Joystick button pressed
	joybuttonup = C.SDL_JOYBUTTONUP // Joystick button released
	joydeviceadded = C.SDL_JOYDEVICEADDED // A new joystick has been inserted into the system
	joydeviceremoved = C.SDL_JOYDEVICEREMOVED // An opened joystick has been removed
	// Game controller events
	controlleraxismotion = C.SDL_CONTROLLERAXISMOTION // 0x650, Game controller axis motion
	controllerbuttondown = C.SDL_CONTROLLERBUTTONDOWN // Game controller button pressed
	controllerbuttonup = C.SDL_CONTROLLERBUTTONUP // Game controller button released
	controllerdeviceadded = C.SDL_CONTROLLERDEVICEADDED // A new Game controller has been inserted into the system
	controllerdeviceremoved = C.SDL_CONTROLLERDEVICEREMOVED // An opened Game controller has been removed
	controllerdeviceremapped = C.SDL_CONTROLLERDEVICEREMAPPED // The controller mapping was updated
	controllertouchpaddown = C.SDL_CONTROLLERTOUCHPADDOWN // Game controller touchpad was touched
	controllertouchpadmotion = C.SDL_CONTROLLERTOUCHPADMOTION // Game controller touchpad finger was moved
	controllertouchpadup = C.SDL_CONTROLLERTOUCHPADUP // Game controller touchpad finger was lifted
	controllersensorupdate = C.SDL_CONTROLLERSENSORUPDATE // Game controller sensor was updated
	// Touch events
	fingerdown = C.SDL_FINGERDOWN // 0x700
	fingerup = C.SDL_FINGERUP
	fingermotion = C.SDL_FINGERMOTION
	// Gesture events
	dollargesture = C.SDL_DOLLARGESTURE // 0x800
	dollarrecord = C.SDL_DOLLARRECORD
	multigesture = C.SDL_MULTIGESTURE
	// Clipboard events
	clipboardupdate = C.SDL_CLIPBOARDUPDATE // 0x900 The clipboard changed
	// Drag and drop events
	dropfile = C.SDL_DROPFILE // 0x1000 The system requests a file open
	droptext = C.SDL_DROPTEXT // text/plain drag-and-drop event
	dropbegin = C.SDL_DROPBEGIN // A new set of drops is beginning (NULL filename)
	dropcomplete = C.SDL_DROPCOMPLETE // Current set of drops is now complete (NULL filename)
	// Audio hotplug events
	audiodeviceadded = C.SDL_AUDIODEVICEADDED // 0x1100 A new audio device is available
	audiodeviceremoved = C.SDL_AUDIODEVICEREMOVED // An audio device has been removed.
	// Sensor events
	sensorupdate = C.SDL_SENSORUPDATE // 0x1200 A sensor was updated
	// Render events
	render_targets_reset = C.SDL_RENDER_TARGETS_RESET // 0x2000 The render targets have been reset and their contents need to be updated
	render_device_reset = C.SDL_RENDER_DEVICE_RESET /// The device has been reset and all textures need to be recreated
	userevent = C.SDL_USEREVENT // Events ::SDL_USEREVENT through ::SDL_LASTEVENT are for your use, and should be allocated with SDL_RegisterEvents()
	// This last event is only for bounding internal arrays
	lastevent = C.SDL_LASTEVENT // 0xFFFF
}

// CommonEvent is fields shared by every event
[typedef]
struct C.SDL_CommonEvent {
pub:
	@type     EventType
	timestamp u32 // In milliseconds, populated using SDL_GetTicks()
}

pub type CommonEvent = C.SDL_CommonEvent

// DisplayEvent is display state change event data (event.display.*)
// DisplayEvent is C.SDL_DisplayEvent
[typedef]
struct C.SDL_DisplayEvent {
	@type     u32  // ::SDL_DISPLAYEVENT
	timestamp u32  // In milliseconds, populated using SDL_GetTicks()
	display   u32  // The associated display index
	event     byte // ::SDL_DisplayEventID
	padding1  byte //
	padding2  byte //
	padding3  byte //
	data1     int  // event dependent data
}

pub type DisplayEvent = C.SDL_DisplayEvent

// WindowEvent is window state change event data (event.window.*)
[typedef]
struct C.SDL_WindowEvent {
pub:
	@type     EventType // ::SDL_WINDOWEVENT
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The associated window
	event     byte      // ::SDL_WindowEventID
	padding1  byte
	padding2  byte
	padding3  byte
	data1     int // event dependent data
	data2     int // event dependent data
}

pub type WindowEvent = C.SDL_WindowEvent

// KeyboardEvent is Keyboard button event structure (event.key.*)
[typedef]
struct C.SDL_KeyboardEvent {
pub:
	@type     EventType // ::SDL_KEYDOWN or ::SDL_KEYUP
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with keyboard focus, if any
	state     byte      // ::SDL_PRESSED or ::SDL_RELEASED
	repeat    byte      // Non-zero if this is a key repeat
	padding2  byte
	padding3  byte
	keysym    Keysym // The key that was pressed or released
}

pub type KeyboardEvent = C.SDL_KeyboardEvent

// TextEditingEvent is keyboard text editing event structure (event.edit.*)
[typedef]
struct C.SDL_TextEditingEvent {
pub:
	@type     EventType // ::SDL_TEXTEDITING
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with keyboard focus, if any
	text      [32]char  // text[SDL_TEXTEDITINGEVENT_TEXT_SIZE] char
	start     int       // The start cursor of selected editing text
	length    int       // The length of selected editing text
}

pub type TextEditingEvent = C.SDL_TextEditingEvent

// TextInputEvent is keyboard text input event structure (event.text.*)
[typedef]
struct C.SDL_TextInputEvent {
pub:
	@type     EventType // ::SDL_TEXTINPUT
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with keyboard focus, if any
	text      [32]char  // text[SDL_TEXTINPUTEVENT_TEXT_SIZE] char
}

pub type TextInputEvent = C.SDL_TextInputEvent

// MouseMotionEvent is mouse motion event structure (event.motion.*)
[typedef]
struct C.SDL_MouseMotionEvent {
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
[typedef]
struct C.SDL_MouseButtonEvent {
pub:
	@type     EventType // ::SDL_MOUSEBUTTONDOWN or ::SDL_MOUSEBUTTONUP
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with mouse focus, if any
	which     u32       // The mouse instance id, or SDL_TOUCH_MOUSEID
	button    byte      // The mouse button index
	state     byte      // ::SDL_PRESSED or ::SDL_RELEASED
	clicks    byte      // 1 for single-click, 2 for double-click, etc.
	padding1  byte
	x         int // X coordinate, relative to window
	y         int // Y coordinate, relative to window
}

pub type MouseButtonEvent = C.SDL_MouseButtonEvent

// MouseWheelEvent is mouse wheel event structure (event.wheel.*)
[typedef]
struct C.SDL_MouseWheelEvent {
pub:
	@type     EventType // ::SDL_MOUSEWHEEL
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	windowID  u32       // The window with mouse focus, if any
	which     u32       // The mouse instance id, or SDL_TOUCH_MOUSEID
	x         int       // The amount scrolled horizontally, positive to the right and negative to the left
	y         int       // The amount scrolled vertically, positive away from the user and negative toward the user
	direction u32       // Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back
}

pub type MouseWheelEvent = C.SDL_MouseWheelEvent

// JoyAxisEvent is joystick axis motion event structure (event.jaxis.*)
[typedef]
struct C.SDL_JoyAxisEvent {
pub:
	@type     EventType  // ::SDL_JOYAXISMOTION
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // The joystick instance id
	axis      byte       // The joystick axis index
	padding1  byte
	padding2  byte
	padding3  byte
	value     i16 // The axis value (range: -32768 to 32767)
	padding4  u16
}

pub type JoyAxisEvent = C.SDL_JoyAxisEvent

// JoyBallEvent is joystick trackball motion event structure (event.jball.*)
[typedef]
struct C.SDL_JoyBallEvent {
pub:
	@type     EventType  // ::SDL_JOYBALLMOTION
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // C.SDL_JoystickID // The joystick instance id
	ball      byte       // The joystick trackball index
	padding1  byte
	padding2  byte
	padding3  byte
	xrel      i16 // The relative motion in the X direction
	yrel      i16 // The relative motion in the Y direction
}

pub type JoyBallEvent = C.SDL_JoyBallEvent

// JoyHatEvent is joystick hat position change event structure (event.jhat.*)
[typedef]
struct C.SDL_JoyHatEvent {
pub:
	@type     EventType  // ::SDL_JOYHATMOTION
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // C.SDL_JoystickID // The joystick instance id
	hat       byte       // The joystick hat index
	value     byte       // The hat position value.
	// See also: ::SDL_HAT_LEFTUP ::SDL_HAT_UP ::SDL_HAT_RIGHTUP
	// See also: ::SDL_HAT_LEFT ::SDL_HAT_CENTERED ::SDL_HAT_RIGHT
	// See also: ::SDL_HAT_LEFTDOWN ::SDL_HAT_DOWN ::SDL_HAT_RIGHTDOWN
	// Note that zero means the POV is centered.
	padding1 byte
	padding2 byte
}

pub type JoyHatEvent = C.SDL_JoyHatEvent

// JoyButtonEvent is joystick button event structure (event.jbutton.*)
[typedef]
struct C.SDL_JoyButtonEvent {
pub:
	@type     EventType  // ::SDL_JOYBUTTONDOWN or ::SDL_JOYBUTTONUP
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // C.SDL_JoystickID // The joystick instance id
	button    byte       // The joystick button index
	state     byte       // ::SDL_PRESSED or ::SDL_RELEASED
	padding1  byte
	padding2  byte
}

pub type JoyButtonEvent = C.SDL_JoyButtonEvent

// JoyDeviceEvent is joystick device event structure (event.jdevice.*)
[typedef]
struct C.SDL_JoyDeviceEvent {
pub:
	@type     EventType // ::SDL_JOYDEVICEADDED or ::SDL_JOYDEVICEREMOVED
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	which     int       // The joystick device index for the ADDED event, instance id for the REMOVED event
}

pub type JoyDeviceEvent = C.SDL_JoyDeviceEvent

// ControllerAxisEvent is game controller axis motion event structure (event.caxis.*)
[typedef]
struct C.SDL_ControllerAxisEvent {
pub:
	@type     EventType  // ::SDL_CONTROLLERAXISMOTION
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // C.SDL_JoystickID // The joystick instance id
	axis      byte       // The controller axis (SDL_GameControllerAxis)
	padding1  byte
	padding2  byte
	padding3  byte
	value     i16 // The axis value (range: -32768 to 32767)
	padding4  u16
}

pub type ControllerAxisEvent = C.SDL_ControllerAxisEvent

// ControllerButtonEvent is game controller button event structure (event.cbutton.*)
[typedef]
struct C.SDL_ControllerButtonEvent {
pub:
	@type     EventType  // ::SDL_CONTROLLERBUTTONDOWN or ::SDL_CONTROLLERBUTTONUP
	timestamp u32        // In milliseconds, populated using SDL_GetTicks()
	which     JoystickID // C.SDL_JoystickID // The joystick instance id
	button    byte       // The controller button (SDL_GameControllerButton)
	state     byte       // ::SDL_PRESSED or ::SDL_RELEASED
	padding1  byte
	padding2  byte
}

pub type ControllerButtonEvent = C.SDL_ControllerButtonEvent

// ControllerDeviceEvent is controller device event structure (event.cdevice.*)
[typedef]
struct C.SDL_ControllerDeviceEvent {
pub:
	@type     EventType // ::SDL_CONTROLLERDEVICEADDED, ::SDL_CONTROLLERDEVICEREMOVED, or ::SDL_CONTROLLERDEVICEREMAPPED
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	which     int       // The joystick device index for the ADDED event, instance id for the REMOVED or REMAPPED event
}

pub type ControllerDeviceEvent = C.SDL_ControllerDeviceEvent

// ControllerTouchpadEvent is game controller touchpad event structure (event.ctouchpad.*)
[typedef]
struct C.SDL_ControllerTouchpadEvent {
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

[typedef]
struct C.SDL_ControllerSensorEvent {
	@type     u32 // ::SDL_CONTROLLERSENSORUPDATE
	timestamp u32 // In milliseconds, populated using SDL_GetTicks()
	which     C.SDL_JoystickID // The joystick instance id
	sensor    int    // The type of the sensor, one of the values of ::SDL_SensorType
	data      [3]f32 // Up to 3 values from the sensor, as defined in SDL_sensor.h
}

pub type ControllerSensorEvent = C.SDL_ControllerSensorEvent

// AudioDeviceEvent is audio device event structure (event.adevice.*)
[typedef]
struct C.SDL_AudioDeviceEvent {
pub:
	@type     EventType // ::SDL_AUDIODEVICEADDED, or ::SDL_AUDIODEVICEREMOVED
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	which     u32       // The audio device index for the ADDED event (valid until next SDL_GetNumAudioDevices() call), SDL_AudioDeviceID for the REMOVED event
	iscapture byte      // zero if an output device, non-zero if a capture device.
	padding1  byte
	padding2  byte
	padding3  byte
}

pub type AudioDeviceEvent = C.SDL_AudioDeviceEvent

// TouchFingerEvent is touch finger event structure (event.tfinger.*)
[typedef]
struct C.SDL_TouchFingerEvent {
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
[typedef]
struct C.SDL_MultiGestureEvent {
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
[typedef]
struct C.SDL_DollarGestureEvent {
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

[typedef]
struct C.SDL_DropEvent {
pub:
	@type     EventType // ::SDL_DROPBEGIN or ::SDL_DROPFILE or ::SDL_DROPTEXT or ::SDL_DROPCOMPLETE
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	file      &char     // The file name, which should be freed with SDL_free(), is NULL on begin/complete
	windowID  u32       // The window that was dropped on, if any
}

pub type DropEvent = C.SDL_DropEvent

// SensorEvent is sensor event structure (event.sensor.*)
// SensorEvent is C.SDL_SensorEvent
[typedef]
struct C.SDL_SensorEvent {
	@type     u32    // ::SDL_SENSORUPDATE
	timestamp u32    // In milliseconds, populated using SDL_GetTicks()
	which     int    // The instance ID of the sensor
	data      [6]f32 // Up to 6 values from the sensor - additional values can be queried using SDL_SensorGetData()
}

pub type SensorEvent = C.SDL_SensorEvent

// QuitEvent is the "quit requested" event
[typedef]
struct C.SDL_QuitEvent {
pub:
	@type     EventType // ::SDL_QUIT
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
}

pub type QuitEvent = C.SDL_QuitEvent

// OSEvent is an OS Specific event
[typedef]
struct C.SDL_OSEvent {
pub:
	@type     EventType // ::SDL_QUIT
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
}

pub type OSEvent = C.SDL_OSEvent

// UserEvent is an user-defined event type (event.user.*)
[typedef]
struct C.SDL_UserEvent {
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
[typedef]
struct C.SDL_SysWMmsg {
}

pub type SysWMmsg = C.SDL_SysWMmsg

[typedef]
struct C.SDL_SysWMEvent {
pub:
	@type     EventType // ::SDL_SYSWMEVENT
	timestamp u32       // In milliseconds, populated using SDL_GetTicks()
	msg       &SysWMmsg // driver dependent data, defined in SDL_syswm.h
}

pub type SysWMEvent = C.SDL_SysWMEvent

// Event is a general event structure.
[typedef]
pub union C.SDL_Event {
pub:
	@type EventType // Event type, shared with all events
	//
	common    CommonEvent             // C.SDL_CommonEvent             // Common event data
	display   DisplayEvent            // C.SDL_DisplayEvent            // Display event data
	window    WindowEvent             // C.SDL_WindowEvent             // Window event data
	key       KeyboardEvent           // C.SDL_KeyboardEvent           // Keyboard event data
	edit      TextEditingEvent        // C.SDL_TextEditingEvent        // Text editing event data
	text      TextInputEvent          // C.SDL_TextInputEvent          // Text input event data
	motion    MouseMotionEvent        // C.SDL_MouseMotionEvent        // Mouse motion event data
	button    MouseButtonEvent        // C.SDL_MouseButtonEvent        // Mouse button event data
	wheel     MouseWheelEvent         // C.SDL_MouseWheelEvent         // Mouse wheel event data
	jaxis     JoyAxisEvent            // C.SDL_JoyAxisEvent            // Joystick axis event data
	jball     JoyBallEvent            // C.SDL_JoyBallEvent            // Joystick ball event data
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
	// This is necessary for ABI compatibility between Visual C++ and GCC
	// Visual C++ will respect the push pack pragma and use 52 bytes for
	// this structure, and GCC will use the alignment of the largest datatype
	// within the union, which is 8 bytes.
	// So... we'll add padding to force the size to be 56 bytes for both.
	padding [56]byte
}

pub type Event = C.SDL_Event

fn C.SDL_PumpEvents()

// pump_events pumps the event loop, gathering events from the input devices.
//
// This function updates the event queue and internal input device state.
//
// This should only be run in the thread that sets the video mode.
pub fn pump_events() {
	C.SDL_PumpEvents()
}

// EventAction is C.SDL_eventaction
pub enum EventAction {
	addevent = C.SDL_ADDEVENT
	peekevent = C.SDL_PEEKEVENT
	getevent = C.SDL_GETEVENT
}

fn C.SDL_PeepEvents(events &C.SDL_Event, numevents int, action C.SDL_eventaction, min_type u32, max_type u32) int

// peep_events checks the event queue for messages and optionally returns them.
//
// If `action` is ::SDL_ADDEVENT, up to `numevents` events will be added to
// the back of the event queue.
//
// If `action` is ::SDL_PEEKEVENT, up to `numevents` events at the front
// of the event queue, within the specified minimum and maximum type,
// will be returned and will not be removed from the queue.
//
// If `action` is ::SDL_GETEVENT, up to `numevents` events at the front
// of the event queue, within the specified minimum and maximum type,
// will be returned and will be removed from the queue.
//
// returns The number of events actually stored, or -1 if there was an error.
//
// This function is thread-safe.
pub fn peep_events(events &Event, numevents int, action EventAction, min_type u32, max_type u32) int {
	return C.SDL_PeepEvents(unsafe { &C.SDL_Event(events) }, numevents, unsafe { C.SDL_eventaction(action) },
		min_type, max_type)
}

fn C.SDL_HasEvent(@type u32) bool

// has_event checks to see if certain event types are in the event queue.
pub fn has_event(@type EventType) bool {
	return C.SDL_HasEvent(u32(@type))
}

fn C.SDL_HasEvents(min_type u32, max_type u32) bool
pub fn has_events(min_type u32, max_type u32) bool {
	return C.SDL_HasEvents(min_type, max_type)
}

fn C.SDL_FlushEvent(@type u32)

// flush_event clears events from the event queue
// This function only affects currently queued events. If you want to make
// sure that all pending OS events are flushed, you can call SDL_PumpEvents()
// on the main thread immediately before the flush call.
pub fn flush_event(@type u32) {
	C.SDL_FlushEvent(@type)
}

fn C.SDL_FlushEvents(min_type u32, max_type u32)
pub fn flush_events(min_type u32, max_type u32) {
	C.SDL_FlushEvents(min_type, max_type)
}

fn C.SDL_PollEvent(event &C.SDL_Event) int

// poll_event polls for currently pending events.
//
// returns 1 if there are any pending events, or 0 if there are none available.
//
// `event` If not NULL, the next event is removed from the queue and
// stored in that area.
pub fn poll_event(event &Event) int {
	return C.SDL_PollEvent(event)
}

fn C.SDL_WaitEvent(event &C.SDL_Event) int

// wait_event waits indefinitely for the next available event.
//
// returns 1, or 0 if there was an error while waiting for events.
//
// `event` If not NULL, the next event is removed from the queue and
// stored in that area.
pub fn wait_event(event &Event) int {
	return C.SDL_WaitEvent(event)
}

fn C.SDL_WaitEventTimeout(event &C.SDL_Event, timeout int) int

// wait_event_timeout waits until the specified timeout (in milliseconds) for the next
// available event.
//
// returns 1, or 0 if there was an error while waiting for events.
//
// `event` If not NULL, the next event is removed from the queue and
// stored in that area.
// `timeout` The timeout (in milliseconds) to wait for next event.
pub fn wait_event_timeout(event &Event, timeout int) int {
	return C.SDL_WaitEventTimeout(event, timeout)
}

fn C.SDL_PushEvent(event &C.SDL_Event) int

// push_event adds an event to the event queue.
//
// returns 1 on success, 0 if the event was filtered, or -1 if the event queue
// was full or there was some other error.
pub fn push_event(event &Event) int {
	return C.SDL_PushEvent(event)
}

fn C.SDL_SetEventFilter(filter EventFilter, userdata voidptr)

// set_event_filter sets up a filter to process all events before they change
// internal state and are posted to the internal event queue.
//
// The filter is prototyped as:
/*
```
int SDL_EventFilter(void *userdata, SDL_Event * event);
```
*/
//
// If the filter returns 1, then the event will be added to the internal queue.
// If it returns 0, then the event will be dropped from the queue, but the
// internal state will still be updated.  This allows selective filtering of
// dynamically arriving events.
//
// WARNING Be very careful of what you do in the event filter function, as
// it may run in a different thread!
//
// There is one caveat when dealing with the ::SDL_QuitEvent event type.  The
// event filter is only called when the window manager desires to close the
// application window.  If the event filter returns 1, then the window will
// be closed, otherwise the window will remain open if possible.
//
// If the quit event is generated by an interrupt signal, it will bypass the
// internal queue and be delivered to the application at the next event poll.
pub fn set_event_filter(filter EventFilter, userdata voidptr) {
	C.SDL_SetEventFilter(filter, userdata)
}

fn C.SDL_GetEventFilter(filter &EventFilter, userdata voidptr) bool

// get_event_filter returns the current event filter - can be used to "chain" filters.
// If there is no event filter set, this function returns SDL_FALSE.
pub fn get_event_filter(filter &EventFilter, userdata voidptr) bool {
	return C.SDL_GetEventFilter(filter, userdata)
}

fn C.SDL_AddEventWatch(filter EventFilter, userdata voidptr)

// add_event_watch add a function which is called when an event is added to the queue.
pub fn add_event_watch(filter EventFilter, userdata voidptr) {
	C.SDL_AddEventWatch(filter, userdata)
}

fn C.SDL_DelEventWatch(filter EventFilter, userdata voidptr)

// del_event_watch removes an event watch function added with SDL_AddEventWatch()
pub fn del_event_watch(filter EventFilter, userdata voidptr) {
	C.SDL_DelEventWatch(filter, userdata)
}

fn C.SDL_FilterEvents(filter EventFilter, userdata voidptr)

// filter_events runs the filter function on the current event queue, removing any
// events for which the filter returns 0.
pub fn filter_events(filter EventFilter, userdata voidptr) {
	C.SDL_FilterEvents(filter, userdata)
}

fn C.SDL_EventState(@type u32, state int) byte

// event_state allows you to set the state of processing certain events.
// - If `state` is set to ::SDL_IGNORE, that event will be automatically
// dropped from the event queue and will not be filtered.
// - If `state` is set to ::SDL_ENABLE, that event will be processed
// normally.
// - If `state` is set to ::SDL_QUERY, SDL_EventState() will return the
// current processing state of the specified event.
pub fn event_state(@type u32, state int) byte {
	return C.SDL_EventState(@type, state)
}

fn C.SDL_RegisterEvents(numevents int) u32

// register_events allocates a set of user-defined events, and returns
// the beginning event number for that set of events.
//
// If there aren't enough user-defined events left, this function
// returns (Uint32)-1
pub fn register_events(numevents int) u32 {
	return C.SDL_RegisterEvents(numevents)
}
