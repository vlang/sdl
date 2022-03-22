// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_loadso.h
//
fn C.SDL_LoadObject(sofile &char) voidptr

// load_object dynamicallys load a shared object.
//
// `sofile` a system-dependent name of the object file
// returns an opaque pointer to the object handle or NULL if there was an
//          error; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LoadFunction
// See also: SDL_UnloadObject
pub fn load_object(sofile &char) voidptr {
	return C.SDL_LoadObject(sofile)
}

fn C.SDL_LoadFunction(handle voidptr, const_name &char) voidptr

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
// `handle` a valid shared object handle returned by SDL_LoadObject()
// `name` the name of the function to look up
// returns a pointer to the function or NULL if there was an error; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LoadObject
// See also: SDL_UnloadObject
pub fn load_function(handle voidptr, const_name &char) voidptr {
	return C.SDL_LoadFunction(handle, const_name)
}

fn C.SDL_UnloadObject(handle voidptr)

// unload_object unloads a shared object from memory.
//
// `handle` a valid shared object handle returned by SDL_LoadObject()
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_LoadFunction
// See also: SDL_LoadObject
pub fn unload_object(handle voidptr) {
	C.SDL_UnloadObject(handle)
}
