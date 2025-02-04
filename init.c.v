// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_init.h
//

// All SDL programs need to initialize the library before starting to work
// with it.
//
// Almost everything can simply call SDL_Init() near startup, with a handful
// of flags to specify subsystems to touch. These are here to make sure SDL
// does not even attempt to touch low-level pieces of the operating system
// that you don't intend to use. For example, you might be using SDL for video
// and input but chose an external library for audio, and in this case you
// would just need to leave off the `SDL_INIT_AUDIO` flag to make sure that
// external library has complete control.
//
// Most apps, when terminating, should call SDL_Quit(). This will clean up
// (nearly) everything that SDL might have allocated, and crucially, it'll
// make sure that the display's resolution is back to what the user expects if
// you had previously changed it for your game.
//
// SDL3 apps are strongly encouraged to call SDL_SetAppMetadata() at startup
// to fill in details about the program. This is completely optional, but it
// helps in small ways (we can provide an About dialog box for the macOS menu,
// we can name the app in the system's audio mixer, etc). Those that want to
// provide a _lot_ of information should look at the more-detailed
// SDL_SetAppMetadataProperty().

// Initialization flags for SDL_Init and/or SDL_InitSubSystem
//
// These are the flags which may be passed to SDL_Init(). You should specify
// the subsystems which you will be using in your application.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: init (SDL_Init)
// See also: quit (SDL_Quit)
// See also: init_sub_system (SDL_InitSubSystem)
// See also: quit_sub_system (SDL_QuitSubSystem)
// See also: was_init (SDL_WasInit)
pub type InitFlags = u32

pub const init_audio = u32(C.SDL_INIT_AUDIO) // 0x00000010u

pub const init_video = u32(C.SDL_INIT_VIDEO) // 0x00000020u

pub const init_joystick = u32(C.SDL_INIT_JOYSTICK) // 0x00000200u

pub const init_haptic = u32(C.SDL_INIT_HAPTIC) // 0x00001000u

pub const init_gamepad = u32(C.SDL_INIT_GAMEPAD) // 0x00002000u

pub const init_events = u32(C.SDL_INIT_EVENTS) // 0x00004000u

pub const init_sensor = u32(C.SDL_INIT_SENSOR) // 0x00008000u

pub const init_camera = u32(C.SDL_INIT_CAMERA) // 0x00010000u

// AppResult is C.SDL_AppResult
pub enum AppResult {
	continue = C.SDL_APP_CONTINUE // `continue` Value that requests that the app continue from the main callbacks.
	success  = C.SDL_APP_SUCCESS  // `success` Value that requests termination with success from the main callbacks.
	failure  = C.SDL_APP_FAILURE  // `failure` Value that requests termination with error from the main callbacks.
}

// AppInitFunc functions pointer typedef for SDL_AppInit.
//
// These are used by SDL_EnterAppMainCallbacks. This mechanism operates behind
// the scenes for apps using the optional main callbacks. Apps that want to
// use this should just implement SDL_AppInit directly.
//
// `appstate` appstate a place where the app can optionally store a pointer for
//                 future use.
// `argc` argc the standard ANSI C main's argc; number of elements in `argv`.
// `argv` argv the standard ANSI C main's argv; array of command line
//             arguments.
// returns SDL_APP_FAILURE to terminate with an error, SDL_APP_SUCCESS to
//          terminate with success, SDL_APP_CONTINUE to continue.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_AppInitFunc)
pub type AppInitFunc = fn (appstate &voidptr, argc int, argv &&char) AppResult

// AppIterateFunc functions pointer typedef for SDL_AppIterate.
//
// These are used by SDL_EnterAppMainCallbacks. This mechanism operates behind
// the scenes for apps using the optional main callbacks. Apps that want to
// use this should just implement SDL_AppIterate directly.
//
// `appstate` appstate an optional pointer, provided by the app in SDL_AppInit.
// returns SDL_APP_FAILURE to terminate with an error, SDL_APP_SUCCESS to
//          terminate with success, SDL_APP_CONTINUE to continue.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_AppIterateFunc)
pub type AppIterateFunc = fn (appstate voidptr) AppResult

// AppEventFunc functions pointer typedef for SDL_AppEvent.
//
// These are used by SDL_EnterAppMainCallbacks. This mechanism operates behind
// the scenes for apps using the optional main callbacks. Apps that want to
// use this should just implement SDL_AppEvent directly.
//
// `appstate` appstate an optional pointer, provided by the app in SDL_AppInit.
// `event` event the new event for the app to examine.
// returns SDL_APP_FAILURE to terminate with an error, SDL_APP_SUCCESS to
//          terminate with success, SDL_APP_CONTINUE to continue.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_AppEventFunc)
pub type AppEventFunc = fn (appstate voidptr, event &Event) AppResult

// AppQuitFunc functions pointer typedef for SDL_AppQuit.
//
// These are used by SDL_EnterAppMainCallbacks. This mechanism operates behind
// the scenes for apps using the optional main callbacks. Apps that want to
// use this should just implement SDL_AppEvent directly.
//
// `appstate` appstate an optional pointer, provided by the app in SDL_AppInit.
// `result` result the result code that terminated the app (success or failure).
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_AppQuitFunc)
pub type AppQuitFunc = fn (appstate voidptr, result AppResult)

// C.SDL_Init [official documentation](https://wiki.libsdl.org/SDL3/SDL_Init)
fn C.SDL_Init(flags InitFlags) bool

// init initializes the SDL library.
//
// SDL_Init() simply forwards to calling SDL_InitSubSystem(). Therefore, the
// two may be used interchangeably. Though for readability of your code
// SDL_InitSubSystem() might be preferred.
//
// The file I/O (for example: SDL_IOFromFile) and threading (SDL_CreateThread)
// subsystems are initialized by default. Message boxes
// (SDL_ShowSimpleMessageBox) also attempt to work without initializing the
// video subsystem, in hopes of being useful in showing an error dialog when
// SDL_Init fails. You must specifically initialize other subsystems if you
// use them in your application.
//
// Logging (such as SDL_Log) works without initialization, too.
//
// `flags` may be any of the following OR'd together:
//
// - `SDL_INIT_AUDIO`: audio subsystem; automatically initializes the events
//   subsystem
// - `SDL_INIT_VIDEO`: video subsystem; automatically initializes the events
//   subsystem, should be initialized on the main thread.
// - `SDL_INIT_JOYSTICK`: joystick subsystem; automatically initializes the
//   events subsystem
// - `SDL_INIT_HAPTIC`: haptic (force feedback) subsystem
// - `SDL_INIT_GAMEPAD`: gamepad subsystem; automatically initializes the
//   joystick subsystem
// - `SDL_INIT_EVENTS`: events subsystem
// - `SDL_INIT_SENSOR`: sensor subsystem; automatically initializes the events
//   subsystem
// - `SDL_INIT_CAMERA`: camera subsystem; automatically initializes the events
//   subsystem
//
// Subsystem initialization is ref-counted, you must call SDL_QuitSubSystem()
// for each SDL_InitSubSystem() to correctly shutdown a subsystem manually (or
// call SDL_Quit() to force shutdown). If a subsystem is already loaded then
// this call will increase the ref-count and return.
//
// Consider reporting some basic metadata about your application before
// calling SDL_Init, using either SDL_SetAppMetadata() or
// SDL_SetAppMetadataProperty().
//
// `flags` flags subsystem initialization flags.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_app_metadata (SDL_SetAppMetadata)
// See also: set_app_metadata_property (SDL_SetAppMetadataProperty)
// See also: init_sub_system (SDL_InitSubSystem)
// See also: quit (SDL_Quit)
// See also: set_main_ready (SDL_SetMainReady)
// See also: was_init (SDL_WasInit)
pub fn init(flags InitFlags) bool {
	return C.SDL_Init(flags)
}

// C.SDL_InitSubSystem [official documentation](https://wiki.libsdl.org/SDL3/SDL_InitSubSystem)
fn C.SDL_InitSubSystem(flags InitFlags) bool

// init_sub_system compatibilitys function to initialize the SDL library.
//
// This function and SDL_Init() are interchangeable.
//
// `flags` flags any of the flags used by SDL_Init(); see SDL_Init for details.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: init (SDL_Init)
// See also: quit (SDL_Quit)
// See also: quit_sub_system (SDL_QuitSubSystem)
pub fn init_sub_system(flags InitFlags) bool {
	return C.SDL_InitSubSystem(flags)
}

// C.SDL_QuitSubSystem [official documentation](https://wiki.libsdl.org/SDL3/SDL_QuitSubSystem)
fn C.SDL_QuitSubSystem(flags InitFlags)

// quit_sub_system shuts down specific SDL subsystems.
//
// You still need to call SDL_Quit() even if you close all open subsystems
// with SDL_QuitSubSystem().
//
// `flags` flags any of the flags used by SDL_Init(); see SDL_Init for details.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: init_sub_system (SDL_InitSubSystem)
// See also: quit (SDL_Quit)
pub fn quit_sub_system(flags InitFlags) {
	C.SDL_QuitSubSystem(flags)
}

// C.SDL_WasInit [official documentation](https://wiki.libsdl.org/SDL3/SDL_WasInit)
fn C.SDL_WasInit(flags InitFlags) InitFlags

// was_init gets a mask of the specified subsystems which are currently initialized.
//
// `flags` flags any of the flags used by SDL_Init(); see SDL_Init for details.
// returns a mask of all initialized subsystems if `flags` is 0, otherwise it
//          returns the initialization status of the specified subsystems.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: init (SDL_Init)
// See also: init_sub_system (SDL_InitSubSystem)
pub fn was_init(flags InitFlags) InitFlags {
	return C.SDL_WasInit(flags)
}

// C.SDL_Quit [official documentation](https://wiki.libsdl.org/SDL3/SDL_Quit)
fn C.SDL_Quit()

// quit cleans up all initialized subsystems.
//
// You should call this function even if you have already shutdown each
// initialized subsystem with SDL_QuitSubSystem(). It is safe to call this
// function even in the case of errors in initialization.
//
// You can use this function with atexit() to ensure that it is run when your
// application is shutdown, but it is not wise to do this from a library or
// other dynamically loaded code.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: init (SDL_Init)
// See also: quit_sub_system (SDL_QuitSubSystem)
pub fn quit() {
	C.SDL_Quit()
}

// C.SDL_IsMainThread [official documentation](https://wiki.libsdl.org/SDL3/SDL_IsMainThread)
fn C.SDL_IsMainThread() bool

// is_main_thread returns whether this is the main thread.
//
// On Apple platforms, the main thread is the thread that runs your program's
// main() entry point. On other platforms, the main thread is the one that
// calls SDL_Init(SDL_INIT_VIDEO), which should usually be the one that runs
// your program's main() entry point. If you are using the main callbacks,
// SDL_AppInit(), SDL_AppIterate(), and SDL_AppQuit() are all called on the
// main thread.
//
// returns true if this thread is the main thread, or false otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: run_on_main_thread (SDL_RunOnMainThread)
pub fn is_main_thread() bool {
	return C.SDL_IsMainThread()
}

// MainThreadCallback callbacks run on the main thread.
//
// `userdata` userdata an app-controlled pointer that is passed to the callback.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: run_on_main_thread (SDL_RunOnMainThread)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_MainThreadCallback)
pub type MainThreadCallback = fn (userdata voidptr)

// C.SDL_RunOnMainThread [official documentation](https://wiki.libsdl.org/SDL3/SDL_RunOnMainThread)
fn C.SDL_RunOnMainThread(callback MainThreadCallback, userdata voidptr, wait_complete bool) bool

// run_on_main_thread calls a function on the main thread during event processing.
//
// If this is called on the main thread, the callback is executed immediately.
// If this is called on another thread, this callback is queued for execution
// on the main thread during event processing.
//
// Be careful of deadlocks when using this functionality. You should not have
// the main thread wait for the current thread while this function is being
// called with `wait_complete` true.
//
// `callback` callback the callback to call on the main thread.
// `userdata` userdata a pointer that is passed to `callback`.
// `wait_complete` wait_complete true to wait for the callback to complete, false to
//                      return immediately.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: is_main_thread (SDL_IsMainThread)
pub fn run_on_main_thread(callback MainThreadCallback, userdata voidptr, wait_complete bool) bool {
	return C.SDL_RunOnMainThread(callback, userdata, wait_complete)
}

// C.SDL_SetAppMetadata [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetAppMetadata)
fn C.SDL_SetAppMetadata(const_appname &char, const_appversion &char, const_appidentifier &char) bool

// set_app_metadata specifys basic metadata about your app.
//
// You can optionally provide metadata about your app to SDL. This is not
// required, but strongly encouraged.
//
// There are several locations where SDL can make use of metadata (an "About"
// box in the macOS menu bar, the name of the app can be shown on some audio
// mixers, etc). Any piece of metadata can be left as NULL, if a specific
// detail doesn't make sense for the app.
//
// This function should be called as early as possible, before SDL_Init.
// Multiple calls to this function are allowed, but various state might not
// change once it has been set up with a previous call to this function.
//
// Passing a NULL removes any previous metadata.
//
// This is a simplified interface for the most important information. You can
// supply significantly more detailed metadata with
// SDL_SetAppMetadataProperty().
//
// `appname` appname The name of the application ("My Game 2: Bad Guy's
//                Revenge!").
// `appversion` appversion The version of the application ("1.0.0beta5" or a git
//                   hash, or whatever makes sense).
// `appidentifier` appidentifier A unique string in reverse-domain format that
//                      identifies this app ("com.example.mygame2").
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_app_metadata_property (SDL_SetAppMetadataProperty)
pub fn set_app_metadata(const_appname &char, const_appversion &char, const_appidentifier &char) bool {
	return C.SDL_SetAppMetadata(const_appname, const_appversion, const_appidentifier)
}

// C.SDL_SetAppMetadataProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetAppMetadataProperty)
fn C.SDL_SetAppMetadataProperty(const_name &char, const_value &char) bool

// set_app_metadata_property specifys metadata about your app through a set of properties.
//
// You can optionally provide metadata about your app to SDL. This is not
// required, but strongly encouraged.
//
// There are several locations where SDL can make use of metadata (an "About"
// box in the macOS menu bar, the name of the app can be shown on some audio
// mixers, etc). Any piece of metadata can be left out, if a specific detail
// doesn't make sense for the app.
//
// This function should be called as early as possible, before SDL_Init.
// Multiple calls to this function are allowed, but various state might not
// change once it has been set up with a previous call to this function.
//
// Once set, this metadata can be read using SDL_GetAppMetadataProperty().
//
// These are the supported properties:
//
// - `SDL_PROP_APP_METADATA_NAME_STRING`: The human-readable name of the
//   application, like "My Game 2: Bad Guy's Revenge!". This will show up
//   anywhere the OS shows the name of the application separately from window
//   titles, such as volume control applets, etc. This defaults to "SDL
//   Application".
// - `SDL_PROP_APP_METADATA_VERSION_STRING`: The version of the app that is
//   running; there are no rules on format, so "1.0.3beta2" and "April 22nd,
//   2024" and a git hash are all valid options. This has no default.
// - `SDL_PROP_APP_METADATA_IDENTIFIER_STRING`: A unique string that
//   identifies this app. This must be in reverse-domain format, like
//   "com.example.mygame2". This string is used by desktop compositors to
//   identify and group windows together, as well as match applications with
//   associated desktop settings and icons. If you plan to package your
//   application in a container such as Flatpak, the app ID should match the
//   name of your Flatpak container as well. This has no default.
// - `SDL_PROP_APP_METADATA_CREATOR_STRING`: The human-readable name of the
//   creator/developer/maker of this app, like "MojoWorkshop, LLC"
// - `SDL_PROP_APP_METADATA_COPYRIGHT_STRING`: The human-readable copyright
//   notice, like "Copyright (c) 2024 MojoWorkshop, LLC" or whatnot. Keep this
//   to one line, don't paste a copy of a whole software license in here. This
//   has no default.
// - `SDL_PROP_APP_METADATA_URL_STRING`: A URL to the app on the web. Maybe a
//   product page, or a storefront, or even a GitHub repository, for user's
//   further information This has no default.
// - `SDL_PROP_APP_METADATA_TYPE_STRING`: The type of application this is.
//   Currently this string can be "game" for a video game, "mediaplayer" for a
//   media player, or generically "application" if nothing else applies.
//   Future versions of SDL might add new types. This defaults to
//   "application".
//
// `name` name the name of the metadata property to set.
// `value` value the value of the property, or NULL to remove that property.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_app_metadata_property (SDL_GetAppMetadataProperty)
// See also: set_app_metadata (SDL_SetAppMetadata)
pub fn set_app_metadata_property(const_name &char, const_value &char) bool {
	return C.SDL_SetAppMetadataProperty(const_name, const_value)
}

pub const prop_app_metadata_name_string = C.SDL_PROP_APP_METADATA_NAME_STRING // 'SDL.app.metadata.name'

pub const prop_app_metadata_version_string = C.SDL_PROP_APP_METADATA_VERSION_STRING // 'SDL.app.metadata.version'

pub const prop_app_metadata_identifier_string = C.SDL_PROP_APP_METADATA_IDENTIFIER_STRING // 'SDL.app.metadata.identifier'

pub const prop_app_metadata_creator_string = C.SDL_PROP_APP_METADATA_CREATOR_STRING // 'SDL.app.metadata.creator'

pub const prop_app_metadata_copyright_string = C.SDL_PROP_APP_METADATA_COPYRIGHT_STRING // 'SDL.app.metadata.copyright'

pub const prop_app_metadata_url_string = C.SDL_PROP_APP_METADATA_URL_STRING // 'SDL.app.metadata.url'

pub const prop_app_metadata_type_string = C.SDL_PROP_APP_METADATA_TYPE_STRING // 'SDL.app.metadata.type'

// C.SDL_GetAppMetadataProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAppMetadataProperty)
fn C.SDL_GetAppMetadataProperty(const_name &char) &char

// get_app_metadata_property gets metadata about your app.
//
// This returns metadata previously set using SDL_SetAppMetadata() or
// SDL_SetAppMetadataProperty(). See SDL_SetAppMetadataProperty() for the list
// of available properties and their meanings.
//
// `name` name the name of the metadata property to get.
// returns the current value of the metadata property, or the default if it
//          is not set, NULL for properties with no default.
//
// NOTE: (thread safety) It is safe to call this function from any thread, although
//               the string returned is not protected and could potentially be
//               freed if you call SDL_SetAppMetadataProperty() to set that
//               property from another thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_app_metadata (SDL_SetAppMetadata)
// See also: set_app_metadata_property (SDL_SetAppMetadataProperty)
pub fn get_app_metadata_property(const_name &char) &char {
	return C.SDL_GetAppMetadataProperty(const_name)
}
