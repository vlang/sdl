module image

$if !windows {
	// SDL libs are loaded dynamically from Java on Android
	$if !android || termux {
		// sdl_no_compile_flags allow users to provide
		// custom flags (e.g. via CFLAGS/LDFLAGS) for the compiler.
		// This is especially useful when building/linking against a
		// custom compiled version of the libs on *nix.
		$if !sdl_no_compile_flags ? {
			#flag -lSDL2_image
		}
	}
}

$if x64 {
	#flag windows -L @VMODROOT/thirdparty/SDL2_image-2.0.3/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL2_image-2.0.3/lib/x86
}
#flag windows -I @VMODROOT/thirdparty/SDL2_image-2.0.3/include
#flag windows -lSDL2_image

#include <SDL_image.h>
