// Setup this way to make emscripten builds work with `-no-skip-unused`
module sdl

//
// SDL_system.h
//

// C.SDL_OnApplicationDidChangeStatusBarOrientation [official documentation](https://wiki.libsdl.org/SDL3/SDL_OnApplicationDidChangeStatusBarOrientation)
fn C.SDL_OnApplicationDidChangeStatusBarOrientation()

// on_application_did_change_status_bar_orientation lets iOS apps with external event handling report
// onApplicationDidChangeStatusBarOrientation.
//
// This functions allows iOS apps that have their own event handling to hook
// into SDL to generate SDL events. This maps directly to an iOS-specific
// event, but since it doesn't do anything iOS-specific internally, it is
// available on all platforms, in case it might be useful for some specific
// paradigm. Most apps do not need to use this directly; SDL's internal event
// code will handle all this for windows created by SDL_CreateWindow!
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn on_application_did_change_status_bar_orientation() {
	C.SDL_OnApplicationDidChangeStatusBarOrientation()
}
