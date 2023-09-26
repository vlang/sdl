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

// get_error gets the last error message that was set
//
// SDL API functions may set error messages and then succeed, so you should
// only use the error value if a function fails.
//
// This returns a pointer to a static buffer for convenience and should not
// be called by multiple threads simultaneously.
//
// returns a pointer to the last error message that was set
pub fn get_error() &char {
	return C.SDL_GetError()
}

fn C.SDL_GetErrorMsg(errstr &char, maxlen int) &char

// get_error_msg gets the last error message that was set for the current thread
//
// SDL API functions may set error messages and then succeed, so you should
// only use the error value if a function fails.
//
// `errstr` A buffer to fill with the last error message that was set
//          for the current thread
// `maxlen` The size of the buffer pointed to by the errstr parameter
//
// returns `errstr`
pub fn get_error_msg(errstr &char, maxlen int) &char {
	return C.SDL_GetErrorMsg(errstr, maxlen)
}

fn C.SDL_ClearError()

// clear_error clears the error message for the current thread
pub fn clear_error() {
	C.SDL_ClearError()
}

// ErrorCode is C.SDL_errorcode
pub enum ErrorCode {
	enomem      = C.SDL_ENOMEM
	efread      = C.SDL_EFREAD
	efwrite     = C.SDL_EFWRITE
	efseek      = C.SDL_EFSEEK
	unsupported = C.SDL_UNSUPPORTED
	lasterror   = C.SDL_LASTERROR
}

fn C.SDL_Error(code C.SDL_errorcode) int

// error SDL_Error() unconditionally returns -1.
pub fn error(code ErrorCode) int {
	return C.SDL_Error(C.SDL_errorcode(code))
}
