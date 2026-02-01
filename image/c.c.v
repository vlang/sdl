module image

$if !windows {
	// SDL libs are loaded dynamically from Java on Android
	$if !android || termux {
		// sdl_no_compile_flags allow users to provide
		// custom flags (e.g. via CFLAGS/LDFLAGS) for the compiler.
		// This is especially useful when building/linking against a
		// custom compiled version of the libs on *nix.
		$if !sdl_no_compile_flags ? {
			#flag -lSDL3_image
		}
	}
}

$if x64 {
	#flag windows -L @VMODROOT/thirdparty/SDL3_image-3.4.0/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL3_image-3.4.0/lib/x86
}
#flag windows -I @VMODROOT/thirdparty/SDL3_image-3.4.0/include
#flag windows -lSDL3_image

#include <SDL3_image/SDL_image.h>
