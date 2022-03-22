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

// get_error retrieves a message about the last error that occurred on the current
// thread.
//
// It is possible for multiple errors to occur before calling SDL_GetError().
// Only the last error is returned.
//
// The message is only applicable when an SDL function has signaled an error.
// You must check the return values of SDL function calls to determine when to
// appropriately call SDL_GetError(). You should *not* use the results of
// SDL_GetError() to decide if an error has occurred! Sometimes SDL will set
// an error string even when reporting success.
//
// SDL will *not* clear the error string for successful API calls. You *must*
// check return values for failure cases before you can assume the error
// string applies.
//
// Error strings are set per-thread, so an error set in a different thread
// will not interfere with the current thread's operation.
//
// The returned string is internally allocated and must not be freed by the
// application.
//
// returns a message with information about the specific error that occurred,
//         or an empty string if there hasn't been an error message set since
//         the last call to SDL_ClearError(). The message is only applicable
//         when an SDL function has signaled an error. You must check the
//         return values of SDL function calls to determine when to
//         appropriately call SDL_GetError().
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_ClearError
// See also: SDL_SetError
pub fn get_error() &char {
	return C.SDL_GetError()
}

fn C.SDL_GetErrorMsg(errstr &char, maxlen int) &char

// get_error_msg gets the last error message that was set for the current thread.
//
// This allows the caller to copy the error string into a provided buffer, but
// otherwise operates exactly the same as SDL_GetError().
//
// `errstr` A buffer to fill with the last error message that was set for
//          the current thread
// `maxlen` The size of the buffer pointed to by the errstr parameter
// returns the pointer passed in as the `errstr` parameter.
//
// NOTE This function is available since SDL 2.0.14.
//
// See also: SDL_GetError
pub fn get_error_msg(errstr &char, maxlen int) &char {
	return C.SDL_GetErrorMsg(errstr, maxlen)
}

fn C.SDL_ClearError()

// clear_error clears any previous error message for this thread.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetError
// See also: SDL_SetError
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
