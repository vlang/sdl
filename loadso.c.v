// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_loadso.h
//

// System-dependent library loading routines.
//
// Shared objects are code that is programmatically loadable at runtime.
// Windows calls these "DLLs", Linux calls them "shared libraries", etc.
//
// To use them, build such a library, then call SDL_LoadObject() on it. Once
// loaded, you can use SDL_LoadFunction() on that object to find the address
// of its exported symbols. When done with the object, call SDL_UnloadObject()
// to dispose of it.
//
// Some things to keep in mind:
//
// - These functions only work on C function names. Other languages may have
//   name mangling and intrinsic language support that varies from compiler to
//   compiler.
// - Make sure you declare your function pointers with the same calling
//   convention as the actual library function. Your code will crash
//   mysteriously if you do not do this.
// - Avoid namespace collisions. If you load a symbol from the library, it is
//   not defined whether or not it goes into the global symbol namespace for
//   the application. If it does and it conflicts with symbols in your code or
//   other shared libraries, you will not get the results you expect. :)
// - Once a library is unloaded, all pointers into it obtained through
//   SDL_LoadFunction() become invalid, even if the library is later reloaded.
//   Don't unload a library if you plan to use these pointers in the future.
//   Notably: beware of giving one of these pointers to atexit(), since it may
//   call that pointer after the library unloads.

@[noinit; typedef]
pub struct C.SDL_SharedObject {
	// NOTE: Opaque type
}

pub type SharedObject = C.SDL_SharedObject

// C.SDL_LoadObject [official documentation](https://wiki.libsdl.org/SDL3/SDL_LoadObject)
fn C.SDL_LoadObject(const_sofile &char) &SharedObject

// load_object dynamicallys load a shared object.
//
// `sofile` sofile a system-dependent name of the object file.
// returns an opaque pointer to the object handle or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: load_function (SDL_LoadFunction)
// See also: unload_object (SDL_UnloadObject)
pub fn load_object(const_sofile &char) &SharedObject {
	return C.SDL_LoadObject(const_sofile)
}

// C.SDL_LoadFunction [official documentation](https://wiki.libsdl.org/SDL3/SDL_LoadFunction)
fn C.SDL_LoadFunction(handle &SharedObject, const_name &char) FunctionPointer

// load_function looks up the address of the named function in a shared object.
//
// This function pointer is no longer valid after calling SDL_UnloadObject().
//
// This function can only look up C function names. Other languages may have
// name mangling and intrinsic language support that varies from compiler to
// compiler.
//
// Make sure you declare your function pointers with the same calling
// convention as the actual library function. Your code will crash
// mysteriously if you do not do this.
//
// If the requested function doesn't exist, NULL is returned.
//
// `handle` handle a valid shared object handle returned by SDL_LoadObject().
// `name` name the name of the function to look up.
// returns a pointer to the function or NULL on failure; call SDL_GetError()
//          for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: load_object (SDL_LoadObject)
pub fn load_function(handle &SharedObject, const_name &char) FunctionPointer {
	return C.SDL_LoadFunction(handle, const_name)
}

// C.SDL_UnloadObject [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnloadObject)
fn C.SDL_UnloadObject(handle &SharedObject)

// unload_object unloads a shared object from memory.
//
// Note that any pointers from this object looked up through
// SDL_LoadFunction() will no longer be valid.
//
// `handle` handle a valid shared object handle returned by SDL_LoadObject().
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: load_object (SDL_LoadObject)
pub fn unload_object(handle &SharedObject) {
	C.SDL_UnloadObject(handle)
}
