// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_quit.h
//

fn C.SDL_QuitRequested() bool
pub fn quit_requested() bool {
	return C.SDL_QuitRequested()
}
