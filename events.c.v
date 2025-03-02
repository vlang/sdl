// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_events.h
//

// Event queue management.
//
// It's extremely common--often required--that an app deal with SDL's event
// queue. Almost all useful information about interactions with the real world
// flow through here: the user interacting with the computer and app, hardware
// coming and going, the system changing in some way, etc.
//
// An app generally takes a moment, perhaps at the start of a new frame, to
// examine any events that have occured since the last time and process or
// ignore them. This is generally done by calling SDL_PollEvent() in a loop
// until it returns false (or, if using the main callbacks, events are
// provided one at a time in calls to SDL_AppEvent() before the next call to
// SDL_AppIterate(); in this scenario, the app does not call SDL_PollEvent()
// at all).
//
// There is other forms of control, too: SDL_PeepEvents() has more
// functionality at the cost of more complexity, and SDL_WaitEvent() can block
// the process until something interesting happens, which might be beneficial
// for certain types of programs on low-power hardware. One may also call
// SDL_AddEventWatch() to set a callback when new events arrive.
//
// The app is free to generate their own events, too: SDL_PushEvent allows the
// app to put events onto the queue for later retrieval; SDL_RegisterEvents
// can guarantee that these events have a type that isn't in use by other
// parts of the system.

// EventType is C.SDL_EventType
pub enum EventType {
	first       = C.SDL_EVENT_FIRST       // 0, Unused (do not remove)
	quit        = C.SDL_EVENT_QUIT        // 0x100, User-requested quit
	terminating = C.SDL_EVENT_TERMINATING // `terminating` The application is being terminated by the OS. This event must be handled in a callback set with SDL_AddEventWatch().
	// Called on iOS in applicationWillTerminate()
	// Called on Android in onDestroy()
	//
	low_memory = C.SDL_EVENT_LOW_MEMORY // `low_memory` The application is low on memory, free memory if possible. This event must be handled in a callback set with SDL_AddEventWatch().
	// Called on iOS in applicationDidReceiveMemoryWarning()
	// Called on Android in onTrimMemory()
	//
	will_enter_background = C.SDL_EVENT_WILL_ENTER_BACKGROUND // `will_enter_background` The application is about to enter the background. This event must be handled in a callback set with SDL_AddEventWatch().
	// Called on iOS in applicationWillResignActive()
	// Called on Android in onPause()
	//
	did_enter_background = C.SDL_EVENT_DID_ENTER_BACKGROUND // `did_enter_background` The application did enter the background and may not get CPU for some time. This event must be handled in a callback set with SDL_AddEventWatch().
	// Called on iOS in applicationDidEnterBackground()
	// Called on Android in onPause()
	//
	will_enter_foreground = C.SDL_EVENT_WILL_ENTER_FOREGROUND // `will_enter_foreground` The application is about to enter the foreground. This event must be handled in a callback set with SDL_AddEventWatch().
	// Called on iOS in applicationWillEnterForeground()
	// Called on Android in onResume()
	//
	did_enter_foreground = C.SDL_EVENT_DID_ENTER_FOREGROUND // `did_enter_foreground` The application is now interactive. This event must be handled in a callback set with SDL_AddEventWatch().
	// Called on iOS in applicationDidBecomeActive()
	// Called on Android in onResume()
	//
	locale_changed                = C.SDL_EVENT_LOCALE_CHANGED                // `locale_changed` The user's locale preferences have changed.
	system_theme_changed          = C.SDL_EVENT_SYSTEM_THEME_CHANGED          // `system_theme_changed` The system theme changed
	display_orientation           = C.SDL_EVENT_DISPLAY_ORIENTATION           // 0x151, Display orientation has changed to data1
	display_added                 = C.SDL_EVENT_DISPLAY_ADDED                 // `display_added` Display has been added to the system
	display_removed               = C.SDL_EVENT_DISPLAY_REMOVED               // `display_removed` Display has been removed from the system
	display_moved                 = C.SDL_EVENT_DISPLAY_MOVED                 // `display_moved` Display has changed position
	display_desktop_mode_changed  = C.SDL_EVENT_DISPLAY_DESKTOP_MODE_CHANGED  // `display_desktop_mode_changed` Display has changed desktop mode
	display_current_mode_changed  = C.SDL_EVENT_DISPLAY_CURRENT_MODE_CHANGED  // `display_current_mode_changed` Display has changed current mode
	display_content_scale_changed = C.SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED // `display_content_scale_changed` Display has changed content scale
	// TODO: these trigger C compile errors: `error: duplicate case value`
	// display_first                 = C.SDL_EVENT_DISPLAY_FIRST                 // SDL_EVENT_DISPLAY_ORIENTATION,
	// display_last                  = C.SDL_EVENT_DISPLAY_LAST                  // SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED,
	window_shown                 = C.SDL_EVENT_WINDOW_SHOWN                 // 0x202, Window has been shown
	window_hidden                = C.SDL_EVENT_WINDOW_HIDDEN                // `window_hidden` Window has been hidden
	window_exposed               = C.SDL_EVENT_WINDOW_EXPOSED               // `window_exposed` Window has been exposed and should be redrawn, and can be redrawn directly from event watchers for this event
	window_moved                 = C.SDL_EVENT_WINDOW_MOVED                 // `window_moved` Window has been moved to data1, data2
	window_resized               = C.SDL_EVENT_WINDOW_RESIZED               // `window_resized` Window has been resized to data1xdata2
	window_pixel_size_changed    = C.SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED    // `window_pixel_size_changed` The pixel size of the window has changed to data1xdata2
	window_metal_view_resized    = C.SDL_EVENT_WINDOW_METAL_VIEW_RESIZED    // `window_metal_view_resized` The pixel size of a Metal view associated with the window has changed
	window_minimized             = C.SDL_EVENT_WINDOW_MINIMIZED             // `window_minimized` Window has been minimized
	window_maximized             = C.SDL_EVENT_WINDOW_MAXIMIZED             // `window_maximized` Window has been maximized
	window_restored              = C.SDL_EVENT_WINDOW_RESTORED              // `window_restored` Window has been restored to normal size and position
	window_mouse_enter           = C.SDL_EVENT_WINDOW_MOUSE_ENTER           // `window_mouse_enter` Window has gained mouse focus
	window_mouse_leave           = C.SDL_EVENT_WINDOW_MOUSE_LEAVE           // `window_mouse_leave` Window has lost mouse focus
	window_focus_gained          = C.SDL_EVENT_WINDOW_FOCUS_GAINED          // `window_focus_gained` Window has gained keyboard focus
	window_focus_lost            = C.SDL_EVENT_WINDOW_FOCUS_LOST            // `window_focus_lost` Window has lost keyboard focus
	window_close_requested       = C.SDL_EVENT_WINDOW_CLOSE_REQUESTED       // `window_close_requested` The window manager requests that the window be closed
	window_hit_test              = C.SDL_EVENT_WINDOW_HIT_TEST              // `window_hit_test` Window had a hit test that wasn't SDL_HITTEST_NORMAL
	window_iccprof_changed       = C.SDL_EVENT_WINDOW_ICCPROF_CHANGED       // `window_iccprof_changed` The ICC profile of the window's display has changed
	window_display_changed       = C.SDL_EVENT_WINDOW_DISPLAY_CHANGED       // `window_display_changed` Window has been moved to display data1
	window_display_scale_changed = C.SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED // `window_display_scale_changed` Window display scale has been changed
	window_safe_area_changed     = C.SDL_EVENT_WINDOW_SAFE_AREA_CHANGED     // `window_safe_area_changed` The window safe area has been changed
	window_occluded              = C.SDL_EVENT_WINDOW_OCCLUDED              // `window_occluded` The window has been occluded
	window_enter_fullscreen      = C.SDL_EVENT_WINDOW_ENTER_FULLSCREEN      // `window_enter_fullscreen` The window has entered fullscreen mode
	window_leave_fullscreen      = C.SDL_EVENT_WINDOW_LEAVE_FULLSCREEN      // `window_leave_fullscreen` The window has left fullscreen mode
	window_destroyed             = C.SDL_EVENT_WINDOW_DESTROYED             // `window_destroyed` The window with the associated ID is being or has been destroyed. If this message is being handled
	// in an event watcher, the window handle is still valid and can still be used to retrieve any properties
	// associated with the window. Otherwise, the handle has already been destroyed and all resources
	// associated with it are invalid
	window_hdr_state_changed = C.SDL_EVENT_WINDOW_HDR_STATE_CHANGED // `window_hdr_state_changed` Window HDR properties have changed
	// TODO: these trigger C compile errors: `error: duplicate case value`
	// window_first             = C.SDL_EVENT_WINDOW_FIRST             // SDL_EVENT_WINDOW_SHOWN,
	// window_last              = C.SDL_EVENT_WINDOW_LAST              // SDL_EVENT_WINDOW_HDR_STATE_CHANGED,
	key_down       = C.SDL_EVENT_KEY_DOWN       // 0x300, Key pressed
	key_up         = C.SDL_EVENT_KEY_UP         // `key_up` Key released
	text_editing   = C.SDL_EVENT_TEXT_EDITING   // `text_editing` Keyboard text editing (composition)
	text_input     = C.SDL_EVENT_TEXT_INPUT     // `text_input` Keyboard text input
	keymap_changed = C.SDL_EVENT_KEYMAP_CHANGED // `keymap_changed` Keymap changed due to a system event such as an
	// input language or keyboard layout change.
	keyboard_added               = C.SDL_EVENT_KEYBOARD_ADDED               // `keyboard_added` A new keyboard has been inserted into the system
	keyboard_removed             = C.SDL_EVENT_KEYBOARD_REMOVED             // `keyboard_removed` A keyboard has been removed
	text_editing_candidates      = C.SDL_EVENT_TEXT_EDITING_CANDIDATES      // `text_editing_candidates` Keyboard text editing candidates
	mouse_motion                 = C.SDL_EVENT_MOUSE_MOTION                 // 0x400, Mouse moved
	mouse_button_down            = C.SDL_EVENT_MOUSE_BUTTON_DOWN            // `mouse_button_down` Mouse button pressed
	mouse_button_up              = C.SDL_EVENT_MOUSE_BUTTON_UP              // `mouse_button_up` Mouse button released
	mouse_wheel                  = C.SDL_EVENT_MOUSE_WHEEL                  // `mouse_wheel` Mouse wheel motion
	mouse_added                  = C.SDL_EVENT_MOUSE_ADDED                  // `mouse_added` A new mouse has been inserted into the system
	mouse_removed                = C.SDL_EVENT_MOUSE_REMOVED                // `mouse_removed` A mouse has been removed
	joystick_axis_motion         = C.SDL_EVENT_JOYSTICK_AXIS_MOTION         // 0x600, Joystick axis motion
	joystick_ball_motion         = C.SDL_EVENT_JOYSTICK_BALL_MOTION         // `joystick_ball_motion` Joystick trackball motion
	joystick_hat_motion          = C.SDL_EVENT_JOYSTICK_HAT_MOTION          // `joystick_hat_motion` Joystick hat position change
	joystick_button_down         = C.SDL_EVENT_JOYSTICK_BUTTON_DOWN         // `joystick_button_down` Joystick button pressed
	joystick_button_up           = C.SDL_EVENT_JOYSTICK_BUTTON_UP           // `joystick_button_up` Joystick button released
	joystick_added               = C.SDL_EVENT_JOYSTICK_ADDED               // `joystick_added` A new joystick has been inserted into the system
	joystick_removed             = C.SDL_EVENT_JOYSTICK_REMOVED             // `joystick_removed` An opened joystick has been removed
	joystick_battery_updated     = C.SDL_EVENT_JOYSTICK_BATTERY_UPDATED     // `joystick_battery_updated` Joystick battery level change
	joystick_update_complete     = C.SDL_EVENT_JOYSTICK_UPDATE_COMPLETE     // `joystick_update_complete` Joystick update is complete
	gamepad_axis_motion          = C.SDL_EVENT_GAMEPAD_AXIS_MOTION          // 0x650, Gamepad axis motion
	gamepad_button_down          = C.SDL_EVENT_GAMEPAD_BUTTON_DOWN          // `gamepad_button_down` Gamepad button pressed
	gamepad_button_up            = C.SDL_EVENT_GAMEPAD_BUTTON_UP            // `gamepad_button_up` Gamepad button released
	gamepad_added                = C.SDL_EVENT_GAMEPAD_ADDED                // `gamepad_added` A new gamepad has been inserted into the system
	gamepad_removed              = C.SDL_EVENT_GAMEPAD_REMOVED              // `gamepad_removed` A gamepad has been removed
	gamepad_remapped             = C.SDL_EVENT_GAMEPAD_REMAPPED             // `gamepad_remapped` The gamepad mapping was updated
	gamepad_touchpad_down        = C.SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN        // `gamepad_touchpad_down` Gamepad touchpad was touched
	gamepad_touchpad_motion      = C.SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION      // `gamepad_touchpad_motion` Gamepad touchpad finger was moved
	gamepad_touchpad_up          = C.SDL_EVENT_GAMEPAD_TOUCHPAD_UP          // `gamepad_touchpad_up` Gamepad touchpad finger was lifted
	gamepad_sensor_update        = C.SDL_EVENT_GAMEPAD_SENSOR_UPDATE        // `gamepad_sensor_update` Gamepad sensor was updated
	gamepad_update_complete      = C.SDL_EVENT_GAMEPAD_UPDATE_COMPLETE      // `gamepad_update_complete` Gamepad update is complete
	gamepad_steam_handle_updated = C.SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED // `gamepad_steam_handle_updated` Gamepad Steam handle has changed
	// 0x700, Touch events
	finger_down                 = C.SDL_EVENT_FINGER_DOWN
	finger_up                   = C.SDL_EVENT_FINGER_UP
	finger_motion               = C.SDL_EVENT_FINGER_MOTION
	finger_canceled             = C.SDL_EVENT_FINGER_CANCELED
	clipboard_update            = C.SDL_EVENT_CLIPBOARD_UPDATE            // 0x900, The clipboard or primary selection changed
	drop_file                   = C.SDL_EVENT_DROP_FILE                   // 0x1000, The system requests a file open
	drop_text                   = C.SDL_EVENT_DROP_TEXT                   // `drop_text` text/plain drag-and-drop event
	drop_begin                  = C.SDL_EVENT_DROP_BEGIN                  // `drop_begin` A new set of drops is beginning (NULL filename)
	drop_complete               = C.SDL_EVENT_DROP_COMPLETE               // `drop_complete` Current set of drops is now complete (NULL filename)
	drop_position               = C.SDL_EVENT_DROP_POSITION               // `drop_position` Position while moving over the window
	audio_device_added          = C.SDL_EVENT_AUDIO_DEVICE_ADDED          // 0x1100, A new audio device is available
	audio_device_removed        = C.SDL_EVENT_AUDIO_DEVICE_REMOVED        // `audio_device_removed` An audio device has been removed.
	audio_device_format_changed = C.SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED // `audio_device_format_changed` An audio device's format has been changed by the system.
	sensor_update               = C.SDL_EVENT_SENSOR_UPDATE               // 0x1200, A sensor was updated
	pen_proximity_in            = C.SDL_EVENT_PEN_PROXIMITY_IN            // 0x1300, Pressure-sensitive pen has become available
	pen_proximity_out           = C.SDL_EVENT_PEN_PROXIMITY_OUT           // `pen_proximity_out` Pressure-sensitive pen has become unavailable
	pen_down                    = C.SDL_EVENT_PEN_DOWN                    // `pen_down` Pressure-sensitive pen touched drawing surface
	pen_up                      = C.SDL_EVENT_PEN_UP                      // `pen_up` Pressure-sensitive pen stopped touching drawing surface
	pen_button_down             = C.SDL_EVENT_PEN_BUTTON_DOWN             // `pen_button_down` Pressure-sensitive pen button pressed
	pen_button_up               = C.SDL_EVENT_PEN_BUTTON_UP               // `pen_button_up` Pressure-sensitive pen button released
	pen_motion                  = C.SDL_EVENT_PEN_MOTION                  // `pen_motion` Pressure-sensitive pen is moving on the tablet
	pen_axis                    = C.SDL_EVENT_PEN_AXIS                    // `pen_axis` Pressure-sensitive pen angle/pressure/etc changed
	camera_device_added         = C.SDL_EVENT_CAMERA_DEVICE_ADDED         // 0x1400, A new camera device is available
	camera_device_removed       = C.SDL_EVENT_CAMERA_DEVICE_REMOVED       // `camera_device_removed` A camera device has been removed.
	camera_device_approved      = C.SDL_EVENT_CAMERA_DEVICE_APPROVED      // `camera_device_approved` A camera device has been approved for use by the user.
	camera_device_denied        = C.SDL_EVENT_CAMERA_DEVICE_DENIED        // `camera_device_denied` A camera device has been denied for use by the user.
	render_targets_reset        = C.SDL_EVENT_RENDER_TARGETS_RESET        // 0x2000, The render targets have been reset and their contents need to be updated
	render_device_reset         = C.SDL_EVENT_RENDER_DEVICE_RESET         // `render_device_reset` The device has been reset and all textures need to be recreated
	render_device_lost          = C.SDL_EVENT_RENDER_DEVICE_LOST          // `render_device_lost` The device has been lost and can't be recovered.
	// 0x4000, Reserved events for private platforms
	private0      = C.SDL_EVENT_PRIVATE0
	private1      = C.SDL_EVENT_PRIVATE1
	private2      = C.SDL_EVENT_PRIVATE2
	private3      = C.SDL_EVENT_PRIVATE3
	poll_sentinel = C.SDL_EVENT_POLL_SENTINEL // 0x7F00, Signals the end of an event poll cycle
	// 0x8000, * Events SDL_EVENT_USER through SDL_EVENT_LAST are for your use,
	// and should be allocated with SDL_RegisterEvents()
	//
	user = C.SDL_EVENT_USER
	// 0xFFFF, *
	// This last event is only for bounding internal arrays
	//
	last = C.SDL_EVENT_LAST
	// 0x7FFFFFFF, This just makes sure the enum is the size of Uint32
	enum_padding = C.SDL_EVENT_ENUM_PADDING
}

@[typedef]
pub struct C.SDL_CommonEvent {
pub mut:
	type      u32 // Event type, shared with all events, Uint32 to cover user events which are not in the SDL_EventType enumeration
	reserved  u32
	timestamp u64 // In nanoseconds, populated using SDL_GetTicksNS()
}

pub type CommonEvent = C.SDL_CommonEvent

@[typedef]
pub struct C.SDL_DisplayEvent {
pub mut:
	type      EventType // SDL_DISPLAYEVENT_*
	reserved  u32
	timestamp u64       // In nanoseconds, populated using SDL_GetTicksNS()
	displayID DisplayID // The associated display
	data1     i32       // event dependent data
	data2     i32       // event dependent data
}

pub type DisplayEvent = C.SDL_DisplayEvent

@[typedef]
pub struct C.SDL_WindowEvent {
pub mut:
	type      EventType // SDL_EVENT_WINDOW_*
	reserved  u32
	timestamp u64      // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID // The associated window
	data1     i32      // event dependent data
	data2     i32      // event dependent data
}

pub type WindowEvent = C.SDL_WindowEvent

@[typedef]
pub struct C.SDL_KeyboardDeviceEvent {
pub mut:
	type      EventType // SDL_EVENT_KEYBOARD_ADDED or SDL_EVENT_KEYBOARD_REMOVED
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     KeyboardID // The keyboard instance id
}

pub type KeyboardDeviceEvent = C.SDL_KeyboardDeviceEvent

@[typedef]
pub struct C.SDL_KeyboardEvent {
pub mut:
	type      EventType // SDL_EVENT_KEY_DOWN or SDL_EVENT_KEY_UP
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID   // The window with keyboard focus, if any
	which     KeyboardID // The keyboard instance id, or 0 if unknown or virtual
	scancode  Scancode   // SDL physical key code
	key       Keycode    // SDL virtual key code
	mod       Keymod     // current key modifiers
	raw       u16        // The platform dependent scancode for this event
	down      bool       // true if the key is pressed
	repeat    bool       // true if this is a key repeat
}

pub type KeyboardEvent = C.SDL_KeyboardEvent

@[typedef]
pub struct C.SDL_TextEditingEvent {
pub mut:
	type      EventType // SDL_EVENT_TEXT_EDITING
	reserved  u32
	timestamp u64      // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID // The window with keyboard focus, if any
	text      &char = unsafe { nil } // The editing text
	start     i32 // The start cursor of selected editing text, or -1 if not set
	length    i32 // The length of selected editing text, or -1 if not set
}

pub type TextEditingEvent = C.SDL_TextEditingEvent

@[typedef]
pub struct C.SDL_TextEditingCandidatesEvent {
pub mut:
	type               EventType // SDL_EVENT_TEXT_EDITING_CANDIDATES
	reserved           u32
	timestamp          u64      // In nanoseconds, populated using SDL_GetTicksNS()
	windowID           WindowID // The window with keyboard focus, if any
	candidates         &&char = unsafe { nil } // candidates The list of candidates, or NULL if there are no candidates available
	num_candidates     i32  // The number of strings in `candidates`
	selected_candidate i32  // The index of the selected candidate, or -1 if no candidate is selected
	horizontal         bool // true if the list is horizontal, false if it's vertical
	padding1           u8
	padding2           u8
	padding3           u8
}

pub type TextEditingCandidatesEvent = C.SDL_TextEditingCandidatesEvent

@[typedef]
pub struct C.SDL_TextInputEvent {
pub mut:
	type      EventType // SDL_EVENT_TEXT_INPUT
	reserved  u32
	timestamp u64      // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID // The window with keyboard focus, if any
	text      &char = unsafe { nil } // The input text, UTF-8 encoded
}

pub type TextInputEvent = C.SDL_TextInputEvent

@[typedef]
pub struct C.SDL_MouseDeviceEvent {
pub mut:
	type      EventType // SDL_EVENT_MOUSE_ADDED or SDL_EVENT_MOUSE_REMOVED
	reserved  u32
	timestamp u64     // In nanoseconds, populated using SDL_GetTicksNS()
	which     MouseID // The mouse instance id
}

pub type MouseDeviceEvent = C.SDL_MouseDeviceEvent

@[typedef]
pub struct C.SDL_MouseMotionEvent {
pub mut:
	type      EventType // SDL_EVENT_MOUSE_MOTION
	reserved  u32
	timestamp u64              // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID         // The window with mouse focus, if any
	which     MouseID          // The mouse instance id in relative mode, SDL_TOUCH_MOUSEID for touch events, or 0
	state     MouseButtonFlags // The current button state
	x         f32              // X coordinate, relative to window
	y         f32              // Y coordinate, relative to window
	xrel      f32              // The relative motion in the X direction
	yrel      f32              // The relative motion in the Y direction
}

pub type MouseMotionEvent = C.SDL_MouseMotionEvent

@[typedef]
pub struct C.SDL_MouseButtonEvent {
pub mut:
	type      EventType // SDL_EVENT_MOUSE_BUTTON_DOWN or SDL_EVENT_MOUSE_BUTTON_UP
	reserved  u32
	timestamp u64      // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID // The window with mouse focus, if any
	which     MouseID  // The mouse instance id in relative mode, SDL_TOUCH_MOUSEID for touch events, or 0
	button    u8       // The mouse button index
	down      bool     // true if the button is pressed
	clicks    u8       // 1 for single-click, 2 for double-click, etc.
	padding   u8
	x         f32 // X coordinate, relative to window
	y         f32 // Y coordinate, relative to window
}

pub type MouseButtonEvent = C.SDL_MouseButtonEvent

@[typedef]
pub struct C.SDL_MouseWheelEvent {
pub mut:
	type      EventType // SDL_EVENT_MOUSE_WHEEL
	reserved  u32
	timestamp u64                 // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID            // The window with mouse focus, if any
	which     MouseID             // The mouse instance id in relative mode or 0
	x         f32                 // The amount scrolled horizontally, positive to the right and negative to the left
	y         f32                 // The amount scrolled vertically, positive away from the user and negative toward the user
	direction MouseWheelDirection // Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back
	mouse_x   f32                 // X coordinate, relative to window
	mouse_y   f32                 // Y coordinate, relative to window
}

pub type MouseWheelEvent = C.SDL_MouseWheelEvent

@[typedef]
pub struct C.SDL_JoyAxisEvent {
pub mut:
	type      EventType // SDL_EVENT_JOYSTICK_AXIS_MOTION
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     JoystickID // The joystick instance id
	axis      u8         // The joystick axis index
	padding1  u8
	padding2  u8
	padding3  u8
	value     i16 // The axis value (range: -32768 to 32767)
	padding4  u16
}

pub type JoyAxisEvent = C.SDL_JoyAxisEvent

@[typedef]
pub struct C.SDL_JoyBallEvent {
pub mut:
	type      EventType // SDL_EVENT_JOYSTICK_BALL_MOTION
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     JoystickID // The joystick instance id
	ball      u8         // The joystick trackball index
	padding1  u8
	padding2  u8
	padding3  u8
	xrel      i16 // The relative motion in the X direction
	yrel      i16 // The relative motion in the Y direction
}

pub type JoyBallEvent = C.SDL_JoyBallEvent

@[typedef]
pub struct C.SDL_JoyHatEvent {
pub mut:
	type      EventType // SDL_EVENT_JOYSTICK_HAT_MOTION
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     JoystickID // The joystick instance id
	hat       u8         // The joystick hat index
	value     u8         // The hat position value. * \sa SDL_HAT_LEFTUP SDL_HAT_UP SDL_HAT_RIGHTUP * \sa SDL_HAT_LEFT SDL_HAT_CENTERED SDL_HAT_RIGHT * \sa SDL_HAT_LEFTDOWN SDL_HAT_DOWN SDL_HAT_RIGHTDOWN * * Note that zero means the POV is centered.
	padding1  u8
	padding2  u8
}

pub type JoyHatEvent = C.SDL_JoyHatEvent

@[typedef]
pub struct C.SDL_JoyButtonEvent {
pub mut:
	type      EventType // SDL_EVENT_JOYSTICK_BUTTON_DOWN or SDL_EVENT_JOYSTICK_BUTTON_UP
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     JoystickID // The joystick instance id
	button    u8         // The joystick button index
	down      bool       // true if the button is pressed
	padding1  u8
	padding2  u8
}

pub type JoyButtonEvent = C.SDL_JoyButtonEvent

@[typedef]
pub struct C.SDL_JoyDeviceEvent {
pub mut:
	type      EventType // SDL_EVENT_JOYSTICK_ADDED or SDL_EVENT_JOYSTICK_REMOVED or SDL_EVENT_JOYSTICK_UPDATE_COMPLETE
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     JoystickID // The joystick instance id
}

pub type JoyDeviceEvent = C.SDL_JoyDeviceEvent

@[typedef]
pub struct C.SDL_JoyBatteryEvent {
pub mut:
	type      EventType // SDL_EVENT_JOYSTICK_BATTERY_UPDATED
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     JoystickID // The joystick instance id
	state     PowerState // The joystick battery state
	percent   int        // The joystick battery percent charge remaining
}

pub type JoyBatteryEvent = C.SDL_JoyBatteryEvent

@[typedef]
pub struct C.SDL_GamepadAxisEvent {
pub mut:
	type      EventType // SDL_EVENT_GAMEPAD_AXIS_MOTION
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     JoystickID // The joystick instance id
	axis      u8         // The gamepad axis (SDL_GamepadAxis)
	padding1  u8
	padding2  u8
	padding3  u8
	value     i16 // The axis value (range: -32768 to 32767)
	padding4  u16
}

pub type GamepadAxisEvent = C.SDL_GamepadAxisEvent

@[typedef]
pub struct C.SDL_GamepadButtonEvent {
pub mut:
	type      EventType // SDL_EVENT_GAMEPAD_BUTTON_DOWN or SDL_EVENT_GAMEPAD_BUTTON_UP
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     JoystickID // The joystick instance id
	button    u8         // The gamepad button (SDL_GamepadButton)
	down      bool       // true if the button is pressed
	padding1  u8
	padding2  u8
}

pub type GamepadButtonEvent = C.SDL_GamepadButtonEvent

@[typedef]
pub struct C.SDL_GamepadDeviceEvent {
pub mut:
	type      EventType // SDL_EVENT_GAMEPAD_ADDED, SDL_EVENT_GAMEPAD_REMOVED, or SDL_EVENT_GAMEPAD_REMAPPED, SDL_EVENT_GAMEPAD_UPDATE_COMPLETE or SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     JoystickID // The joystick instance id
}

pub type GamepadDeviceEvent = C.SDL_GamepadDeviceEvent

@[typedef]
pub struct C.SDL_GamepadTouchpadEvent {
pub mut:
	type      EventType // SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN or SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION or SDL_EVENT_GAMEPAD_TOUCHPAD_UP
	reserved  u32
	timestamp u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which     JoystickID // The joystick instance id
	touchpad  i32        // The index of the touchpad
	finger    i32        // The index of the finger on the touchpad
	x         f32        // Normalized in the range 0...1 with 0 being on the left
	y         f32        // Normalized in the range 0...1 with 0 being at the top
	pressure  f32        // Normalized in the range 0...1
}

pub type GamepadTouchpadEvent = C.SDL_GamepadTouchpadEvent

@[typedef]
pub struct C.SDL_GamepadSensorEvent {
pub mut:
	type             EventType // SDL_EVENT_GAMEPAD_SENSOR_UPDATE
	reserved         u32
	timestamp        u64        // In nanoseconds, populated using SDL_GetTicksNS()
	which            JoystickID // The joystick instance id
	sensor           i32        // The type of the sensor, one of the values of SDL_SensorType
	data             [3]f32     // Up to 3 values from the sensor, as defined in SDL_sensor.h
	sensor_timestamp u64        // The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock
}

pub type GamepadSensorEvent = C.SDL_GamepadSensorEvent

@[typedef]
pub struct C.SDL_AudioDeviceEvent {
pub mut:
	type      EventType // SDL_EVENT_AUDIO_DEVICE_ADDED, or SDL_EVENT_AUDIO_DEVICE_REMOVED, or SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED
	reserved  u32
	timestamp u64           // In nanoseconds, populated using SDL_GetTicksNS()
	which     AudioDeviceID // SDL_AudioDeviceID for the device being added or removed or changing
	recording bool          // false if a playback device, true if a recording device.
	padding1  u8
	padding2  u8
	padding3  u8
}

pub type AudioDeviceEvent = C.SDL_AudioDeviceEvent

@[typedef]
pub struct C.SDL_CameraDeviceEvent {
pub mut:
	type      EventType // SDL_EVENT_CAMERA_DEVICE_ADDED, SDL_EVENT_CAMERA_DEVICE_REMOVED, SDL_EVENT_CAMERA_DEVICE_APPROVED, SDL_EVENT_CAMERA_DEVICE_DENIED
	reserved  u32
	timestamp u64      // In nanoseconds, populated using SDL_GetTicksNS()
	which     CameraID // SDL_CameraID for the device being added or removed or changing
}

pub type CameraDeviceEvent = C.SDL_CameraDeviceEvent

@[typedef]
pub struct C.SDL_RenderEvent {
pub mut:
	type      EventType // SDL_EVENT_RENDER_TARGETS_RESET, SDL_EVENT_RENDER_DEVICE_RESET, SDL_EVENT_RENDER_DEVICE_LOST
	reserved  u32
	timestamp u64      // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID // The window containing the renderer in question.
}

pub type RenderEvent = C.SDL_RenderEvent

@[typedef]
pub struct C.SDL_TouchFingerEvent {
pub mut:
	type      EventType // SDL_EVENT_FINGER_DOWN, SDL_EVENT_FINGER_UP, SDL_EVENT_FINGER_MOTION, or SDL_EVENT_FINGER_CANCELED
	reserved  u32
	timestamp u64     // In nanoseconds, populated using SDL_GetTicksNS()
	touchID   TouchID // The touch device id
	fingerID  FingerID
	x         f32      // Normalized in the range 0...1
	y         f32      // Normalized in the range 0...1
	dx        f32      // Normalized in the range -1...1
	dy        f32      // Normalized in the range -1...1
	pressure  f32      // Normalized in the range 0...1
	windowID  WindowID // The window underneath the finger, if any
}

pub type TouchFingerEvent = C.SDL_TouchFingerEvent

@[typedef]
pub struct C.SDL_PenProximityEvent {
pub mut:
	type      EventType // SDL_EVENT_PEN_PROXIMITY_IN or SDL_EVENT_PEN_PROXIMITY_OUT
	reserved  u32
	timestamp u64      // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID // The window with pen focus, if any
	which     PenID    // The pen instance id
}

pub type PenProximityEvent = C.SDL_PenProximityEvent

@[typedef]
pub struct C.SDL_PenMotionEvent {
pub mut:
	type      EventType // SDL_EVENT_PEN_MOTION
	reserved  u32
	timestamp u64           // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID      // The window with pen focus, if any
	which     PenID         // The pen instance id
	pen_state PenInputFlags // Complete pen input state at time of event
	x         f32           // X coordinate, relative to window
	y         f32           // Y coordinate, relative to window
}

pub type PenMotionEvent = C.SDL_PenMotionEvent

@[typedef]
pub struct C.SDL_PenTouchEvent {
pub mut:
	type      EventType // SDL_EVENT_PEN_DOWN or SDL_EVENT_PEN_UP
	reserved  u32
	timestamp u64           // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID      // The window with pen focus, if any
	which     PenID         // The pen instance id
	pen_state PenInputFlags // Complete pen input state at time of event
	x         f32           // X coordinate, relative to window
	y         f32           // Y coordinate, relative to window
	eraser    bool          // true if eraser end is used (not all pens support this).
	down      bool          // true if the pen is touching or false if the pen is lifted off
}

pub type PenTouchEvent = C.SDL_PenTouchEvent

@[typedef]
pub struct C.SDL_PenButtonEvent {
pub mut:
	type      EventType // SDL_EVENT_PEN_BUTTON_DOWN or SDL_EVENT_PEN_BUTTON_UP
	reserved  u32
	timestamp u64           // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID      // The window with mouse focus, if any
	which     PenID         // The pen instance id
	pen_state PenInputFlags // Complete pen input state at time of event
	x         f32           // X coordinate, relative to window
	y         f32           // Y coordinate, relative to window
	button    u8            // The pen button index (first button is 1).
	down      bool          // true if the button is pressed
}

pub type PenButtonEvent = C.SDL_PenButtonEvent

@[typedef]
pub struct C.SDL_PenAxisEvent {
pub mut:
	type      EventType // SDL_EVENT_PEN_AXIS
	reserved  u32
	timestamp u64           // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID      // The window with pen focus, if any
	which     PenID         // The pen instance id
	pen_state PenInputFlags // Complete pen input state at time of event
	x         f32           // X coordinate, relative to window
	y         f32           // Y coordinate, relative to window
	axis      PenAxis       // Axis that has changed
	value     f32           // New value of axis
}

pub type PenAxisEvent = C.SDL_PenAxisEvent

@[typedef]
pub struct C.SDL_DropEvent {
pub mut:
	type      EventType // SDL_EVENT_DROP_BEGIN or SDL_EVENT_DROP_FILE or SDL_EVENT_DROP_TEXT or SDL_EVENT_DROP_COMPLETE or SDL_EVENT_DROP_POSITION
	reserved  u32
	timestamp u64      // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID // The window that was dropped on, if any
	x         f32      // X coordinate, relative to window (not on begin)
	y         f32      // Y coordinate, relative to window (not on begin)
	source    &char = unsafe { nil } // The source app that sent this drop event, or NULL if that isn't available
	data      &char = unsafe { nil } // The text for SDL_EVENT_DROP_TEXT and the file name for SDL_EVENT_DROP_FILE, NULL for other events
}

pub type DropEvent = C.SDL_DropEvent

@[typedef]
pub struct C.SDL_ClipboardEvent {
pub mut:
	type           EventType // SDL_EVENT_CLIPBOARD_UPDATE
	reserved       u32
	timestamp      u64  // In nanoseconds, populated using SDL_GetTicksNS()
	owner          bool // are we owning the clipboard (internal update)
	num_mime_types i32  // number of mime types
	mime_types     &&char = unsafe { nil } // current mime types
}

pub type ClipboardEvent = C.SDL_ClipboardEvent

@[typedef]
pub struct C.SDL_SensorEvent {
pub mut:
	type             EventType // SDL_EVENT_SENSOR_UPDATE
	reserved         u32
	timestamp        u64      // In nanoseconds, populated using SDL_GetTicksNS()
	which            SensorID // The instance ID of the sensor
	data             [6]f32   // Up to 6 values from the sensor - additional values can be queried using SDL_GetSensorData()
	sensor_timestamp u64      // The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock
}

pub type SensorEvent = C.SDL_SensorEvent

@[typedef]
pub struct C.SDL_QuitEvent {
pub mut:
	type      EventType // SDL_EVENT_QUIT
	reserved  u32
	timestamp u64 // In nanoseconds, populated using SDL_GetTicksNS()
}

pub type QuitEvent = C.SDL_QuitEvent

@[typedef]
pub struct C.SDL_UserEvent {
pub mut:
	type      u32 // SDL_EVENT_USER through SDL_EVENT_LAST-1, Uint32 because these are not in the SDL_EventType enumeration
	reserved  u32
	timestamp u64      // In nanoseconds, populated using SDL_GetTicksNS()
	windowID  WindowID // The associated window if any
	code      i32      // User defined event code
	data1     voidptr  // User defined data pointer
	data2     voidptr  // User defined data pointer
}

pub type UserEvent = C.SDL_UserEvent

@[typedef]
pub union C.SDL_Event {
pub mut:
	type            EventType                  // Event type, shared with all events, Uint32 to cover user events which are not in the SDL_EventType enumeration
	common          CommonEvent                // Common event data
	display         DisplayEvent               // Display event data
	window          WindowEvent                // Window event data
	kdevice         KeyboardDeviceEvent        // Keyboard device change event data
	key             KeyboardEvent              // Keyboard event data
	edit            TextEditingEvent           // Text editing event data
	edit_candidates TextEditingCandidatesEvent // Text editing candidates event data
	text            TextInputEvent             // Text input event data
	mdevice         MouseDeviceEvent           // Mouse device change event data
	motion          MouseMotionEvent           // Mouse motion event data
	button          MouseButtonEvent           // Mouse button event data
	wheel           MouseWheelEvent            // Mouse wheel event data
	jdevice         JoyDeviceEvent             // Joystick device change event data
	jaxis           JoyAxisEvent               // Joystick axis event data
	jball           JoyBallEvent               // Joystick ball event data
	jhat            JoyHatEvent                // Joystick hat event data
	jbutton         JoyButtonEvent             // Joystick button event data
	jbattery        JoyBatteryEvent            // Joystick battery event data
	gdevice         GamepadDeviceEvent         // Gamepad device event data
	gaxis           GamepadAxisEvent           // Gamepad axis event data
	gbutton         GamepadButtonEvent         // Gamepad button event data
	gtouchpad       GamepadTouchpadEvent       // Gamepad touchpad event data
	gsensor         GamepadSensorEvent         // Gamepad sensor event data
	adevice         AudioDeviceEvent           // Audio device event data
	cdevice         CameraDeviceEvent          // Camera device event data
	sensor          SensorEvent                // Sensor event data
	quit            QuitEvent                  // Quit request event data
	user            UserEvent                  // Custom event data
	tfinger         TouchFingerEvent           // Touch finger event data
	pproximity      PenProximityEvent          // Pen proximity event data
	ptouch          PenTouchEvent              // Pen tip touching event data
	pmotion         PenMotionEvent             // Pen motion event data
	pbutton         PenButtonEvent             // Pen button event data
	paxis           PenAxisEvent               // Pen axis event data
	render          RenderEvent                // Render event data
	drop            DropEvent                  // Drag and drop event data
	clipboard       ClipboardEvent             // Clipboard event data

	// This is necessary for ABI compatibility between Visual C++ and GCC.
	// Visual C++ will respect the push pack pragma and use 52 bytes (size of
	// SDL_TextEditingEvent, the largest structure for 32-bit and 64-bit
	// architectures) for this union, and GCC will use the alignment of the
	// largest datatype within the union, which is 8 bytes on 64-bit
	// architectures.
	//
	// So... we'll add padding to force the size to be the same for both.
	//
	// On architectures where pointers are 16 bytes, this needs rounding up to
	// the next multiple of 16, 64, and on architectures where pointers are
	// even larger the size of SDL_UserEvent will dominate as being 3 pointers.
	padding [128]u8
}

pub type Event = C.SDL_Event

// C.SDL_PumpEvents [official documentation](https://wiki.libsdl.org/SDL3/SDL_PumpEvents)
fn C.SDL_PumpEvents()

// pump_events pumps the event loop, gathering events from the input devices.
//
// This function updates the event queue and internal input device state.
//
// SDL_PumpEvents() gathers all the pending input information from devices and
// places it in the event queue. Without calls to SDL_PumpEvents() no events
// would ever be placed on the queue. Often the need for calls to
// SDL_PumpEvents() is hidden from the user since SDL_PollEvent() and
// SDL_WaitEvent() implicitly call SDL_PumpEvents(). However, if you are not
// polling or waiting for events (e.g. you are filtering them), then you must
// call SDL_PumpEvents() to force an event queue update.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: poll_event (SDL_PollEvent)
// See also: wait_event (SDL_WaitEvent)
pub fn pump_events() {
	C.SDL_PumpEvents()
}

// EventAction is C.SDL_EventAction
pub enum EventAction {
	addevent  = C.SDL_ADDEVENT  // `addevent` Add events to the back of the queue.
	peekevent = C.SDL_PEEKEVENT // `peekevent` Check but don't remove events from the queue front.
	getevent  = C.SDL_GETEVENT  // `getevent` Retrieve/remove events from the front of the queue.
}

// C.SDL_PeepEvents [official documentation](https://wiki.libsdl.org/SDL3/SDL_PeepEvents)
fn C.SDL_PeepEvents(events &Event, numevents int, action EventAction, min_type u32, max_type u32) int

// peep_events checks the event queue for messages and optionally return them.
//
// `action` may be any of the following:
//
// - `SDL_ADDEVENT`: up to `numevents` events will be added to the back of the
//   event queue.
// - `SDL_PEEKEVENT`: `numevents` events at the front of the event queue,
//   within the specified minimum and maximum type, will be returned to the
//   caller and will _not_ be removed from the queue. If you pass NULL for
//   `events`, then `numevents` is ignored and the total number of matching
//   events will be returned.
// - `SDL_GETEVENT`: up to `numevents` events at the front of the event queue,
//   within the specified minimum and maximum type, will be returned to the
//   caller and will be removed from the queue.
//
// You may have to call SDL_PumpEvents() before calling this function.
// Otherwise, the events may not be ready to be filtered when you call
// SDL_PeepEvents().
//
// `events` events destination buffer for the retrieved events, may be NULL to
//               leave the events in the queue and return the number of events
//               that would have been stored.
// `numevents` numevents if action is SDL_ADDEVENT, the number of events to add
//                  back to the event queue; if action is SDL_PEEKEVENT or
//                  SDL_GETEVENT, the maximum number of events to retrieve.
// `action` action action to take; see [[#action|Remarks]] for details.
// `min_type` minType minimum value of the event type to be considered;
//                SDL_EVENT_FIRST is a safe choice.
// `max_type` maxType maximum value of the event type to be considered;
//                SDL_EVENT_LAST is a safe choice.
// returns the number of events actually stored or -1 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: poll_event (SDL_PollEvent)
// See also: pump_events (SDL_PumpEvents)
// See also: push_event (SDL_PushEvent)
pub fn peep_events(events &Event, numevents int, action EventAction, min_type u32, max_type u32) int {
	return C.SDL_PeepEvents(events, numevents, action, min_type, max_type)
}

// C.SDL_HasEvent [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasEvent)
fn C.SDL_HasEvent(typ u32) bool

// has_event checks for the existence of a certain event type in the event queue.
//
// If you need to check for a range of event types, use SDL_HasEvents()
// instead.
//
// `type` type the type of event to be queried; see SDL_EventType for details.
// returns true if events matching `type` are present, or false if events
//          matching `type` are not present.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_events (SDL_HasEvents)
pub fn has_event(typ u32) bool {
	return C.SDL_HasEvent(typ)
}

// C.SDL_HasEvents [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasEvents)
fn C.SDL_HasEvents(min_type u32, max_type u32) bool

// has_events checks for the existence of certain event types in the event queue.
//
// If you need to check for a single event type, use SDL_HasEvent() instead.
//
// `min_type` minType the low end of event type to be queried, inclusive; see
//                SDL_EventType for details.
// `max_type` maxType the high end of event type to be queried, inclusive; see
//                SDL_EventType for details.
// returns true if events with type >= `minType` and <= `maxType` are
//          present, or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_events (SDL_HasEvents)
pub fn has_events(min_type u32, max_type u32) bool {
	return C.SDL_HasEvents(min_type, max_type)
}

// C.SDL_FlushEvent [official documentation](https://wiki.libsdl.org/SDL3/SDL_FlushEvent)
fn C.SDL_FlushEvent(typ u32)

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
// If you have user events with custom data that needs to be freed, you should
// use SDL_PeepEvents() to remove and clean up those events before calling
// this function.
//
// `type` type the type of event to be cleared; see SDL_EventType for details.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: flush_events (SDL_FlushEvents)
pub fn flush_event(typ u32) {
	C.SDL_FlushEvent(typ)
}

// C.SDL_FlushEvents [official documentation](https://wiki.libsdl.org/SDL3/SDL_FlushEvents)
fn C.SDL_FlushEvents(min_type u32, max_type u32)

// flush_events clears events of a range of types from the event queue.
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
// `min_type` minType the low end of event type to be cleared, inclusive; see
//                SDL_EventType for details.
// `max_type` maxType the high end of event type to be cleared, inclusive; see
//                SDL_EventType for details.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: flush_event (SDL_FlushEvent)
pub fn flush_events(min_type u32, max_type u32) {
	C.SDL_FlushEvents(min_type, max_type)
}

// C.SDL_PollEvent [official documentation](https://wiki.libsdl.org/SDL3/SDL_PollEvent)
fn C.SDL_PollEvent(event &Event) bool

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
// ```c
// while (game_is_still_running) {
//     SDL_Event event;
//     while (SDL_PollEvent(&event)) {  // poll until all events are handled!
//         // decide what to do with this event.
//     }
//
//     // update game state, draw the current frame
// }
// ```
//
// `event` event the SDL_Event structure to be filled with the next event from
//              the queue, or NULL.
// returns true if this got an event or false if there are none available.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: push_event (SDL_PushEvent)
// See also: wait_event (SDL_WaitEvent)
// See also: wait_event_timeout (SDL_WaitEventTimeout)
pub fn poll_event(event &Event) bool {
	return C.SDL_PollEvent(event)
}

// C.SDL_WaitEvent [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitEvent)
fn C.SDL_WaitEvent(event &Event) bool

// wait_event waits indefinitely for the next available event.
//
// If `event` is not NULL, the next event is removed from the queue and stored
// in the SDL_Event structure pointed to by `event`.
//
// As this function may implicitly call SDL_PumpEvents(), you can only call
// this function in the thread that initialized the video subsystem.
//
// `event` event the SDL_Event structure to be filled in with the next event
//              from the queue, or NULL.
// returns true on success or false if there was an error while waiting for
//          events; call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: poll_event (SDL_PollEvent)
// See also: push_event (SDL_PushEvent)
// See also: wait_event_timeout (SDL_WaitEventTimeout)
pub fn wait_event(event &Event) bool {
	return C.SDL_WaitEvent(event)
}

// C.SDL_WaitEventTimeout [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitEventTimeout)
fn C.SDL_WaitEventTimeout(event &Event, timeout_ms i32) bool

// wait_event_timeout waits until the specified timeout (in milliseconds) for the next available
// event.
//
// If `event` is not NULL, the next event is removed from the queue and stored
// in the SDL_Event structure pointed to by `event`.
//
// As this function may implicitly call SDL_PumpEvents(), you can only call
// this function in the thread that initialized the video subsystem.
//
// The timeout is not guaranteed, the actual wait time could be longer due to
// system scheduling.
//
// `event` event the SDL_Event structure to be filled in with the next event
//              from the queue, or NULL.
// `timeout_ms` timeoutMS the maximum number of milliseconds to wait for the next
//                  available event.
// returns true if this got an event or false if the timeout elapsed without
//          any events available.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: poll_event (SDL_PollEvent)
// See also: push_event (SDL_PushEvent)
// See also: wait_event (SDL_WaitEvent)
pub fn wait_event_timeout(event &Event, timeout_ms i32) bool {
	return C.SDL_WaitEventTimeout(event, timeout_ms)
}

// C.SDL_PushEvent [official documentation](https://wiki.libsdl.org/SDL3/SDL_PushEvent)
fn C.SDL_PushEvent(event &Event) bool

// push_event adds an event to the event queue.
//
// The event queue can actually be used as a two way communication channel.
// Not only can events be read from the queue, but the user can also push
// their own events onto it. `event` is a pointer to the event structure you
// wish to push onto the queue. The event is copied into the queue, and the
// caller may dispose of the memory pointed to after SDL_PushEvent() returns.
//
// Note: Pushing device input events onto the queue doesn't modify the state
// of the device within SDL.
//
// Note: Events pushed onto the queue with SDL_PushEvent() get passed through
// the event filter but events added with SDL_PeepEvents() do not.
//
// For pushing application-specific events, please use SDL_RegisterEvents() to
// get an event type that does not conflict with other code that also wants
// its own custom event types.
//
// `event` event the SDL_Event to be added to the queue.
// returns true on success, false if the event was filtered or on failure;
//          call SDL_GetError() for more information. A common reason for
//          error is the event queue being full.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: peep_events (SDL_PeepEvents)
// See also: poll_event (SDL_PollEvent)
// See also: register_events (SDL_RegisterEvents)
pub fn push_event(event &Event) bool {
	return C.SDL_PushEvent(event)
}

// EventFilter as function pointer used for callbacks that watch the event queue.
//
// `userdata` userdata what was passed as `userdata` to SDL_SetEventFilter() or
//                 SDL_AddEventWatch, etc.
// `event` event the event that triggered the callback.
// returns true to permit event to be added to the queue, and false to
//          disallow it. When used with SDL_AddEventWatch, the return value is
//          ignored.
//
// NOTE: (thread safety) SDL may call this callback at any time from any thread; the
//               application is responsible for locking resources the callback
//               touches that need to be protected.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: set_event_filter (SDL_SetEventFilter)
// See also: add_event_watch (SDL_AddEventWatch)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_EventFilter)
pub type EventFilter = fn (userdata voidptr, event &Event) bool

// C.SDL_SetEventFilter [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetEventFilter)
fn C.SDL_SetEventFilter(filter EventFilter, userdata voidptr)

// set_event_filter sets up a filter to process all events before they are added to the internal
// event queue.
//
// If you just want to see events without modifying them or preventing them
// from being queued, you should use SDL_AddEventWatch() instead.
//
// If the filter function returns true when called, then the event will be
// added to the internal queue. If it returns false, then the event will be
// dropped from the queue, but the internal state will still be updated. This
// allows selective filtering of dynamically arriving events.
//
// **WARNING**: Be very careful of what you do in the event filter function,
// as it may run in a different thread!
//
// On platforms that support it, if the quit event is generated by an
// interrupt signal (e.g. pressing Ctrl-C), it will be delivered to the
// application at the next event poll.
//
// Note: Disabled events never make it to the event filter function; see
// SDL_SetEventEnabled().
//
// Note: Events pushed onto the queue with SDL_PushEvent() get passed through
// the event filter, but events pushed onto the queue with SDL_PeepEvents() do
// not.
//
// `filter` filter an SDL_EventFilter function to call when an event happens.
// `userdata` userdata a pointer that is passed to `filter`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_event_watch (SDL_AddEventWatch)
// See also: set_event_enabled (SDL_SetEventEnabled)
// See also: get_event_filter (SDL_GetEventFilter)
// See also: peep_events (SDL_PeepEvents)
// See also: push_event (SDL_PushEvent)
pub fn set_event_filter(filter EventFilter, userdata voidptr) {
	C.SDL_SetEventFilter(filter, userdata)
}

// C.SDL_GetEventFilter [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetEventFilter)
fn C.SDL_GetEventFilter(filter &EventFilter, userdata &voidptr) bool

// get_event_filter querys the current event filter.
//
// This function can be used to "chain" filters, by saving the existing filter
// before replacing it with a function that will call that saved filter.
//
// `filter` filter the current callback function will be stored here.
// `userdata` userdata the pointer that is passed to the current event filter will
//                 be stored here.
// returns true on success or false if there is no event filter set.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_event_filter (SDL_SetEventFilter)
pub fn get_event_filter(filter &EventFilter, userdata &voidptr) bool {
	return C.SDL_GetEventFilter(filter, userdata)
}

// C.SDL_AddEventWatch [official documentation](https://wiki.libsdl.org/SDL3/SDL_AddEventWatch)
fn C.SDL_AddEventWatch(filter EventFilter, userdata voidptr) bool

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
// Note: the callback is called for events posted by the user through
// SDL_PushEvent(), but not for disabled events, nor for events by a filter
// callback set with SDL_SetEventFilter(), nor for events posted by the user
// through SDL_PeepEvents().
//
// `filter` filter an SDL_EventFilter function to call when an event happens.
// `userdata` userdata a pointer that is passed to `filter`.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: remove_event_watch (SDL_RemoveEventWatch)
// See also: set_event_filter (SDL_SetEventFilter)
pub fn add_event_watch(filter EventFilter, userdata voidptr) bool {
	return C.SDL_AddEventWatch(filter, userdata)
}

// C.SDL_RemoveEventWatch [official documentation](https://wiki.libsdl.org/SDL3/SDL_RemoveEventWatch)
fn C.SDL_RemoveEventWatch(filter EventFilter, userdata voidptr)

// remove_event_watch removes an event watch callback added with SDL_AddEventWatch().
//
// This function takes the same input as SDL_AddEventWatch() to identify and
// delete the corresponding callback.
//
// `filter` filter the function originally passed to SDL_AddEventWatch().
// `userdata` userdata the pointer originally passed to SDL_AddEventWatch().
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: add_event_watch (SDL_AddEventWatch)
pub fn remove_event_watch(filter EventFilter, userdata voidptr) {
	C.SDL_RemoveEventWatch(filter, userdata)
}

// C.SDL_FilterEvents [official documentation](https://wiki.libsdl.org/SDL3/SDL_FilterEvents)
fn C.SDL_FilterEvents(filter EventFilter, userdata voidptr)

// filter_events runs a specific filter function on the current event queue, removing any
// events for which the filter returns false.
//
// See SDL_SetEventFilter() for more information. Unlike SDL_SetEventFilter(),
// this function does not change the filter permanently, it only uses the
// supplied filter until this function returns.
//
// `filter` filter the SDL_EventFilter function to call when an event happens.
// `userdata` userdata a pointer that is passed to `filter`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_event_filter (SDL_GetEventFilter)
// See also: set_event_filter (SDL_SetEventFilter)
pub fn filter_events(filter EventFilter, userdata voidptr) {
	C.SDL_FilterEvents(filter, userdata)
}

// C.SDL_SetEventEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetEventEnabled)
fn C.SDL_SetEventEnabled(typ u32, enabled bool)

// set_event_enabled sets the state of processing events by type.
//
// `type` type the type of event; see SDL_EventType for details.
// `enabled` enabled whether to process the event or not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: event_enabled (SDL_EventEnabled)
pub fn set_event_enabled(typ u32, enabled bool) {
	C.SDL_SetEventEnabled(typ, enabled)
}

// C.SDL_EventEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_EventEnabled)
fn C.SDL_EventEnabled(typ u32) bool

// event_enabled querys the state of processing events by type.
//
// `type` type the type of event; see SDL_EventType for details.
// returns true if the event is being processed, false otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_event_enabled (SDL_SetEventEnabled)
pub fn event_enabled(typ u32) bool {
	return C.SDL_EventEnabled(typ)
}

// C.SDL_RegisterEvents [official documentation](https://wiki.libsdl.org/SDL3/SDL_RegisterEvents)
fn C.SDL_RegisterEvents(numevents int) u32

// register_events allocates a set of user-defined events, and return the beginning event
// number for that set of events.
//
// `numevents` numevents the number of events to be allocated.
// returns the beginning event number, or 0 if numevents is invalid or if
//          there are not enough user-defined events left.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: push_event (SDL_PushEvent)
pub fn register_events(numevents int) u32 {
	return C.SDL_RegisterEvents(numevents)
}

// C.SDL_GetWindowFromEvent [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowFromEvent)
fn C.SDL_GetWindowFromEvent(const_event &Event) &Window

// get_window_from_event gets window associated with an event.
//
// `event` event an event containing a `windowID`.
// returns the associated window on success or NULL if there is none.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: poll_event (SDL_PollEvent)
// See also: wait_event (SDL_WaitEvent)
// See also: wait_event_timeout (SDL_WaitEventTimeout)
pub fn get_window_from_event(const_event &Event) &Window {
	return C.SDL_GetWindowFromEvent(const_event)
}
