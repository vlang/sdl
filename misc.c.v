// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_misc.h
//

fn C.SDL_OpenURL(url &char) int

// open_url opens a URL/URI in the browser or other appropriate external application.
//
// Open a URL in a separate, system-provided application. How this works will
// vary wildly depending on the platform. This will likely launch what makes
// sense to handle a specific URL's protocol (a web browser for `http://`,
// etc), but it might also be able to launch file managers for directories and
// other things.
//
// What happens when you open a URL varies wildly as well: your game window
// may lose focus (and may or may not lose focus if your game was fullscreen
// or grabbing input at the time). On mobile devices, your app will likely
// move to the background or your process might be paused. Any given platform
// may or may not handle a given URL.
//
// If this is unimplemented (or simply unavailable) for a platform, this will
// fail with an error. A successful result does not mean the URL loaded, just
// that we launched _something_ to handle it (or at least believe we did).
//
// All this to say: this function can be useful, but you should definitely
// test it on every platform you target.
//
// `url` A valid URL/URI to open. Use `file:///full/path/to/file` for
//            local files, if supported.
// returns 0 on success, or -1 on error; call SDL_GetError() for more
//          information.
//
// NOTE This function is available since SDL 2.0.14.
pub fn open_url(url &char) int {
	return C.SDL_OpenURL(url)
}
