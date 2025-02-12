// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_quit.h
//

// An SDL_QUIT event is generated when the user tries to close the application
// window. If it is ignored or filtered out, the window will remain open. If
// it is not ignored or filtered, it is queued normally and the window is
// allowed to close. When the window is closed, screen updates will complete,
// but have no effect.
//
// SDL_Init() installs signal handlers for SIGINT (keyboard interrupt) and
// SIGTERM (system termination request), if handlers do not already exist,
// that generate SDL_QUIT events as well. There is no way to determine the
// cause of an SDL_QUIT event, but setting a signal handler in your
// application will override the default generation of quit events for that
// signal.

fn C.SDL_QuitRequested() bool

// There are no functions directly affecting the quit event
pub fn quit_requested() bool {
	return C.SDL_QuitRequested()
}
