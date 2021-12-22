// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_error.h
//

// Skipped:
/*
extern DECLSPEC int SDLCALL SDL_SetError(SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(1);
*/
fn C.SDL_GetError() &char

// get_error SDL_SetError() unconditionally returns -1.
pub fn get_error() string {
	return unsafe { cstring_to_vstring(C.SDL_GetError()) }
}

fn C.SDL_ClearError()
pub fn clear_error() {
	C.SDL_ClearError()
}

// ErrorCode is C.SDL_errorcode
pub enum ErrorCode {
	enomem = C.SDL_ENOMEM
	efread = C.SDL_EFREAD
	efwrite = C.SDL_EFWRITE
	efseek = C.SDL_EFSEEK
	unsupported = C.SDL_UNSUPPORTED
	lasterror = C.SDL_LASTERROR
}
fn C.SDL_Error(code C.SDL_errorcode) int

// error SDL_Error() unconditionally returns -1.
pub fn error(code ErrorCode) int {
	return C.SDL_Error(C.SDL_errorcode(code))
}
