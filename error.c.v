// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_error.h
//

// Simple error message routines for SDL.
//
// Most apps will interface with these APIs in exactly one function: when
// almost any SDL function call reports failure, you can get a human-readable
// string of the problem from SDL_GetError().
//
// These strings are maintained per-thread, and apps are welcome to set their
// own errors, which is popular when building libraries on top of SDL for
// other apps to consume. These strings are set by calling SDL_SetError().
//
// A common usage pattern is to have a function that returns true for success
// and false for failure, and do this when something fails:
//
// ```c
// if (something_went_wrong) {
//    return SDL_SetError("The thing broke in this specific way: %d", errcode);
// }
// ```
//
// It's also common to just return `false` in this case if the failing thing
// is known to call SDL_SetError(), so errors simply propagate through.

// TODO: extern SDL_DECLSPEC bool SDLCALL SDL_SetError(SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(1);

// set_error sets the SDL error message for the current thread.
//
// Calling this function will replace any previous error message that was set.
//
// This function always returns false, since SDL frequently uses false to
// signify a failing result, leading to this idiom:
//
// ```c
// if (error_code) {
//     return SDL_SetError("This operation has failed: %d", error_code);
// }
// ```
//
// `fmt` fmt a printf()-style message format string.
// `...` ... additional parameters matching % tokens in the `fmt` string, if
//            any.
// returns false.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: clear_error (SDL_ClearError)
// See also: get_error (SDL_GetError)
// See also: set_error_v (SDL_SetErrorV)
//
// TODO: set_error(const_fmt &char, ...) bool {}

// TODO: extern SDL_DECLSPEC bool SDLCALL SDL_SetErrorV(SDL_PRINTF_FORMAT_STRING const char *fmt, va_list ap) SDL_PRINTF_VARARG_FUNCV(1);

// set_error_v sets the SDL error message for the current thread.
//
// Calling this function will replace any previous error message that was set.
//
// `fmt` fmt a printf()-style message format string.
// `ap` ap a variable argument list.
// returns false.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: clear_error (SDL_ClearError)
// See also: get_error (SDL_GetError)
// See also: set_error (SDL_SetError)
//
// TODO: set_error_v(const_fmt &char, ap C.va_list) bool {}

// C.SDL_OutOfMemory [official documentation](https://wiki.libsdl.org/SDL3/SDL_OutOfMemory)
fn C.SDL_OutOfMemory() bool

// out_of_memory sets an error indicating that memory allocation failed.
//
// This function does not do any memory allocation.
//
// returns false.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn out_of_memory() bool {
	return C.SDL_OutOfMemory()
}

// C.SDL_GetError [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetError)
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
// The returned value is a thread-local string which will remain valid until
// the current thread's error string is changed. The caller should make a copy
// if the value is needed after the next SDL API call.
//
// returns a message with information about the specific error that occurred,
//          or an empty string if there hasn't been an error message set since
//          the last call to SDL_ClearError().
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: clear_error (SDL_ClearError)
// See also: set_error (SDL_SetError)
pub fn get_error() &char {
	return C.SDL_GetError()
}

// C.SDL_ClearError [official documentation](https://wiki.libsdl.org/SDL3/SDL_ClearError)
fn C.SDL_ClearError() bool

// clear_error clears any previous error message for this thread.
//
// returns true.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_error (SDL_GetError)
// See also: set_error (SDL_SetError)
pub fn clear_error() bool {
	return C.SDL_ClearError()
}

// A macro to standardize error reporting on unsupported operations.
//
// This simply calls SDL_SetError() with a standardized error string, for
// convenience, consistency, and clarity.
//
// NOTE: (thread safety) It is safe to call this macro from any thread.
//
// NOTE: This macro is available since SDL 3.2.0.
// TODO: pub const unsupported() = SDL_SetError('That operation is not supported')

// A macro to standardize error reporting on unsupported operations.
//
// This simply calls SDL_SetError() with a standardized error string, for
// convenience, consistency, and clarity.
//
// A common usage pattern inside SDL is this:
//
// ```c
// bool MyFunction(const char *str) {
// if (!str) {
// return SDL_InvalidParamError("str");  // returns false.
// }
// DoSomething(str);
// return true;
// }
// ```
//
// NOTE: (thread safety) It is safe to call this macro from any thread.
//
// NOTE: This macro is available since SDL 3.2.0.
// TODO: pub const invalidparamerror(param) = SDL_SetError('Parameter '%s' is invalid', (param))
