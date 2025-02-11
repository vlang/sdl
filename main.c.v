// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_main.h
//

// Redefine main() if necessary so that it is called by SDL.
//
// In order to make this consistent on all platforms, the application's main()
// should look like this:
//
// ```c
// int main(int argc, char *argv[])
// {
// }
// ```
//
// SDL will take care of platform specific details on how it gets called.
//
// This is also where an app can be configured to use the main callbacks, via
// the SDL_MAIN_USE_CALLBACKS macro.
//
// This is a "single-header library," which is to say that including this
// header inserts code into your program, and you should only include it once
// in most cases. SDL.h does not include this header automatically.
//
// For more information, see:
//
// https://wiki.libsdl.org/SDL3/README/main-functions

// Inform SDL that the app is providing an entry point instead of SDL.
//
// SDL does not define this macro, but will check if it is defined when
// including `SDL_main.h`. If defined, SDL will expect the app to provide the
// proper entry point for the platform, and all the other magic details
// needed, like manually calling SDL_SetMainReady.
//
// Please see [README/main-functions](README/main-functions), (or
// docs/README-main-functions.md in the source tree) for a more detailed
// explanation.
//
// NOTE: This macro is used by the headers since SDL 3.2.0.
// pub const main_handled = C.SDL_MAIN_HANDLED // 1

// Inform SDL to use the main callbacks instead of main.
//
// SDL does not define this macro, but will check if it is defined when
// including `SDL_main.h`. If defined, SDL will expect the app to provide
// several functions: SDL_AppInit, SDL_AppEvent, SDL_AppIterate, and
// SDL_AppQuit. The app should not provide a `main` function in this case, and
// doing so will likely cause the build to fail.
//
// Please see [README/main-functions](README/main-functions), (or
// docs/README-main-functions.md in the source tree) for a more detailed
// explanation.
//
// NOTE: This macro is used by the headers since SDL 3.2.0.
//
// See also: SDL_AppInit
// See also: SDL_AppEvent
// See also: SDL_AppIterate
// See also: SDL_AppQuit
// pub const main_use_callbacks = C.SDL_MAIN_USE_CALLBACKS // 1

// You can (optionally!) define SDL_MAIN_USE_CALLBACKS before including
// SDL_main.h, and then your application will _not_ have a standard
// "main" entry point. Instead, it will operate as a collection of
// functions that are called as necessary by the system. On some
// platforms, this is just a layer where SDL drives your program
// instead of your program driving SDL, on other platforms this might
// hook into the OS to manage the lifecycle. Programs on most platforms
// can use whichever approach they prefer, but the decision boils down
// to:
//
// - Using a standard "main" function: this works like it always has for
//   the past 50+ years in C programming, and your app is in control.
// - Using the callback functions: this might clean up some code,
//   avoid some #ifdef blocks in your program for some platforms, be more
//   resource-friendly to the system, and possibly be the primary way to
//   access some future platforms (but none require this at the moment).
//
// This is up to the app; both approaches are considered valid and supported
// ways to write SDL apps.
//
// If using the callbacks, don't define a "main" function. Instead, implement
// the functions listed below in your program.

// $if sdl_use_main_callbacks {

// App-implemented initial entry point for SDL_MAIN_USE_CALLBACKS apps.
//
// Apps implement this function when using SDL_MAIN_USE_CALLBACKS. If using a
// standard "main" function, you should not supply this.
//
// This function is called by SDL once, at startup. The function should
// initialize whatever is necessary, possibly create windows and open audio
// devices, etc. The `argc` and `argv` parameters work like they would with a
// standard "main" function.
//
// This function should not go into an infinite mainloop; it should do any
// one-time setup it requires and then return.
//
// The app may optionally assign a pointer to `*appstate`. This pointer will
// be provided on every future call to the other entry points, to allow
// application state to be preserved between functions without the app needing
// to use a global variable. If this isn't set, the pointer will be NULL in
// future entry points.
//
// If this function returns SDL_APP_CONTINUE, the app will proceed to normal
// operation, and will begin receiving repeated calls to SDL_AppIterate and
// SDL_AppEvent for the life of the program. If this function returns
// SDL_APP_FAILURE, SDL will call SDL_AppQuit and terminate the process with
// an exit code that reports an error to the platform. If it returns
// SDL_APP_SUCCESS, SDL calls SDL_AppQuit and terminates with an exit code
// that reports success to the platform.
//
// This function is called by SDL on the main thread.
//
// `appstate` a place where the app can optionally store a pointer for
//                 future use.
// `argc` the standard ANSI C main's argc; number of elements in `argv`.
// `param` argv the standard ANSI C main's argv; array of command line
//             arguments.
// returns SDL_APP_FAILURE to terminate with an error, SDL_APP_SUCCESS to
//          terminate with success, SDL_APP_CONTINUE to continue.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: SDL_AppIterate
// See also: SDL_AppEvent
// See also: SDL_AppQuit
// extern SDLMAIN_DECLSPEC SDL_AppResult SDLCALL SDL_AppInit(void **appstate, int argc, char *argv[]);

// App-implemented iteration entry point for SDL_MAIN_USE_CALLBACKS apps.
//
// Apps implement this function when using SDL_MAIN_USE_CALLBACKS. If using a
// standard "main" function, you should not supply this.
//
// This function is called repeatedly by SDL after SDL_AppInit returns 0. The
// function should operate as a single iteration the program's primary loop;
// it should update whatever state it needs and draw a new frame of video,
// usually.
//
// On some platforms, this function will be called at the refresh rate of the
// display (which might change during the life of your app!). There are no
// promises made about what frequency this function might run at. You should
// use SDL's timer functions if you need to see how much time has passed since
// the last iteration.
//
// There is no need to process the SDL event queue during this function; SDL
// will send events as they arrive in SDL_AppEvent, and in most cases the
// event queue will be empty when this function runs anyhow.
//
// This function should not go into an infinite mainloop; it should do one
// iteration of whatever the program does and return.
//
// The `appstate` parameter is an optional pointer provided by the app during
// SDL_AppInit(). If the app never provided a pointer, this will be NULL.
//
// If this function returns SDL_APP_CONTINUE, the app will continue normal
// operation, receiving repeated calls to SDL_AppIterate and SDL_AppEvent for
// the life of the program. If this function returns SDL_APP_FAILURE, SDL will
// call SDL_AppQuit and terminate the process with an exit code that reports
// an error to the platform. If it returns SDL_APP_SUCCESS, SDL calls
// SDL_AppQuit and terminates with an exit code that reports success to the
// platform.
//
// This function is called by SDL on the main thread.
//
// `appstate` an optional pointer, provided by the app in SDL_AppInit.
// returns SDL_APP_FAILURE to terminate with an error, SDL_APP_SUCCESS to
//          terminate with success, SDL_APP_CONTINUE to continue.
//
// NOTE: (thread safety) This function may get called concurrently with SDL_AppEvent()
//               for events not pushed on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: SDL_AppInit
// See also: SDL_AppEvent
// extern SDLMAIN_DECLSPEC SDL_AppResult SDLCALL SDL_AppIterate(void *appstate);

// App-implemented event entry point for SDL_MAIN_USE_CALLBACKS apps.
//
// Apps implement this function when using SDL_MAIN_USE_CALLBACKS. If using a
// standard "main" function, you should not supply this.
//
// This function is called as needed by SDL after SDL_AppInit returns
// SDL_APP_CONTINUE. It is called once for each new event.
//
// There is (currently) no guarantee about what thread this will be called
// from; whatever thread pushes an event onto SDL's queue will trigger this
// function. SDL is responsible for pumping the event queue between each call
// to SDL_AppIterate, so in normal operation one should only get events in a
// serial fashion, but be careful if you have a thread that explicitly calls
// SDL_PushEvent. SDL itself will push events to the queue on the main thread.
//
// Events sent to this function are not owned by the app; if you need to save
// the data, you should copy it.
//
// This function should not go into an infinite mainloop; it should handle the
// provided event appropriately and return.
//
// The `appstate` parameter is an optional pointer provided by the app during
// SDL_AppInit(). If the app never provided a pointer, this will be NULL.
//
// If this function returns SDL_APP_CONTINUE, the app will continue normal
// operation, receiving repeated calls to SDL_AppIterate and SDL_AppEvent for
// the life of the program. If this function returns SDL_APP_FAILURE, SDL will
// call SDL_AppQuit and terminate the process with an exit code that reports
// an error to the platform. If it returns SDL_APP_SUCCESS, SDL calls
// SDL_AppQuit and terminates with an exit code that reports success to the
// platform.
//
// `appstate` an optional pointer, provided by the app in SDL_AppInit.
// `event` the new event for the app to examine.
// returns SDL_APP_FAILURE to terminate with an error, SDL_APP_SUCCESS to
//          terminate with success, SDL_APP_CONTINUE to continue.
//
// NOTE: (thread safety) This function may get called concurrently with
//               SDL_AppIterate() or SDL_AppQuit() for events not pushed from
//               the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: SDL_AppInit
// See also: SDL_AppIterate
// extern SDLMAIN_DECLSPEC SDL_AppResult SDLCALL SDL_AppEvent(void *appstate, SDL_Event *event);

// C.SDL_AppQuit [official documentation](https://wiki.libsdl.org/SDL3/SDL_AppQuit)
// fn C.SDL_AppQuit(appstate voidptr, result AppResult)

// App-implemented deinit entry point for SDL_MAIN_USE_CALLBACKS apps.
//
// Apps implement this function when using SDL_MAIN_USE_CALLBACKS. If using a
// standard "main" function, you should not supply this.
//
// This function is called once by SDL before terminating the program.
//
// This function will be called no matter what, even if SDL_AppInit requests
// termination.
//
// This function should not go into an infinite mainloop; it should
// deinitialize any resources necessary, perform whatever shutdown activities,
// and return.
//
// You do not need to call SDL_Quit() in this function, as SDL will call it
// after this function returns and before the process terminates, but it is
// safe to do so.
//
// The `appstate` parameter is an optional pointer provided by the app during
// SDL_AppInit(). If the app never provided a pointer, this will be NULL. This
// function call is the last time this pointer will be provided, so any
// resources to it should be cleaned up here.
//
// This function is called by SDL on the main thread.
//
// `appstate` an optional pointer, provided by the app in SDL_AppInit.
// `result` the result code that terminated the app (success or failure).
//
// NOTE: (thread safety) SDL_AppEvent() may get called concurrently with this function
//               if other threads that push events are still active.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: SDL_AppInit
// extern SDLMAIN_DECLSPEC void SDLCALL SDL_AppQuit(void *appstate, SDL_AppResult result);

// } // $if sdl_use_main_callbacks

// MainFunc thes prototype for the application's main() function
//
// `argc` argc an ANSI-C style main function's argc.
// `argv` argv an ANSI-C style main function's argv.
// returns an ANSI-C main return code; generally 0 is considered successful
//          program completion, and small non-zero values are considered
//          errors.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_MainFunc)
pub type MainFunc = fn (argc int, argv &&char) int

// C.SDL_SetMainReady [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetMainReady)
fn C.SDL_SetMainReady()

// set_main_ready circumvents failure of SDL_Init() when not using SDL_main() as an entry
// point.
//
// This function is defined in SDL_main.h, along with the preprocessor rule to
// redefine main() as SDL_main(). Thus to ensure that your main() function
// will not be changed it is necessary to define SDL_MAIN_HANDLED before
// including SDL.h.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: init (SDL_Init)
pub fn set_main_ready() {
	C.SDL_SetMainReady()
}

// C.SDL_RunApp [official documentation](https://wiki.libsdl.org/SDL3/SDL_RunApp)
fn C.SDL_RunApp(argc int, argv voidptr, main_function MainFunc, reserved voidptr) int

// run_app initializes and launches an SDL application, by doing platform-specific
// initialization before calling your mainFunction and cleanups after it
// returns, if that is needed for a specific platform, otherwise it just calls
// mainFunction.
//
// You can use this if you want to use your own main() implementation without
// using SDL_main (like when using SDL_MAIN_HANDLED). When using this, you do
// *not* need SDL_SetMainReady().
//
// `argc` argc the argc parameter from the application's main() function, or 0
//             if the platform's main-equivalent has no argc.
// `argv` argv the argv parameter from the application's main() function, or
//             NULL if the platform's main-equivalent has no argv.
// `main_function` mainFunction your SDL app's C-style main(). NOT the function you're
//                     calling this from! Its name doesn't matter; it doesn't
//                     literally have to be `main`.
// `reserved` reserved should be NULL (reserved for future use, will probably be
//                 platform-specific then).
// returns the return value from mainFunction: 0 on success, otherwise
//          failure; SDL_GetError() might have more information on the
//          failure.
//
// NOTE: (thread safety) Generally this is called once, near startup, from the
//               process's initial thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn run_app(argc int, argv &&char, main_function MainFunc, reserved voidptr) int {
	return C.SDL_RunApp(argc, argv, main_function, reserved)
}

// C.SDL_EnterAppMainCallbacks [official documentation](https://wiki.libsdl.org/SDL3/SDL_EnterAppMainCallbacks)
// fn C.SDL_EnterAppMainCallbacks(argc int, argv voidptr, appinit AppInitFunc, appiter AppIterateFunc, appevent AppEventFunc, appquit AppQuitFunc) int

// enter_app_main_callbacks an entry point for SDL's use in SDL_MAIN_USE_CALLBACKS.
//
// Generally, you should not call this function directly. This only exists to
// hand off work into SDL as soon as possible, where it has a lot more control
// and functionality available, and make the inline code in SDL_main.h as
// small as possible.
//
// Not all platforms use this, it's actual use is hidden in a magic
// header-only library, and you should not call this directly unless you
// _really_ know what you're doing.
//
// `argc` argc standard Unix main argc.
// `argv` argv standard Unix main argv.
// `appinit` appinit the application's SDL_AppInit function.
// `appiter` appiter the application's SDL_AppIterate function.
// `appevent` appevent the application's SDL_AppEvent function.
// `appquit` appquit the application's SDL_AppQuit function.
// returns standard Unix main return value.
//
// NOTE: (thread safety) It is not safe to call this anywhere except as the only
//               function call in SDL_main.
//
// NOTE: This function is available since SDL 3.2.0.
// pub fn enter_app_main_callbacks(argc int, argv &&char, appinit AppInitFunc, appiter AppIterateFunc, appevent AppEventFunc, appquit AppQuitFunc) int {
// 	return C.SDL_EnterAppMainCallbacks(argc, argv, appinit, appiter, appevent, appquit)
// }
