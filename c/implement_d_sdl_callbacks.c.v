module c

// This is part of a shim to make it possible to use SDL3's version
// of the main-loop control inversion that more and more
// platforms promote and use
// (callbacks for program init,loop,event/block,quit).
//
// NOTE: Read more about the setup and reasons
// for this in `examples/ports/README.md`.
$if windows {
	#define UNICODE 1 // Fix: `fatal error C1017: invalid integer constant expression`
}
#define SDL_MAIN_USE_CALLBACKS
#include <SDL3/SDL.h>

@[use_once]
#include <SDL3/SDL_main.h>
