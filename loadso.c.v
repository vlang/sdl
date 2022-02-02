// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_loadso.h
//
fn C.SDL_LoadObject(sofile &char) voidptr

// load_object dynamically loads a shared object and returns a pointer
// to the object handle (or NULL if there was an error).
// The 'sofile' parameter is a system dependent name of the object file.
pub fn load_object(sofile &char) voidptr {
	return C.SDL_LoadObject(sofile)
}

fn C.SDL_LoadFunction(handle voidptr, name &char) voidptr

// load_function, given an object handle, looks up the address of the
// named function in the shared object and returns it.  This address
// is no longer valid after calling SDL_UnloadObject().
pub fn load_function(handle voidptr, name &char) voidptr {
	return C.SDL_LoadFunction(handle, name)
}

fn C.SDL_UnloadObject(handle voidptr)

// unload_object unloads a shared object from memory.
pub fn unload_object(handle voidptr) {
	C.SDL_UnloadObject(handle)
}
