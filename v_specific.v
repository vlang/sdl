module sdl

// get_error_v returns a V string, with a description of the last SDL error.
// See also: get_error (SDL_GetError).
pub fn get_error_v() string {
	return unsafe { cstring_to_vstring(get_error()) }
}
