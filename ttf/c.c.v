// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module ttf

$if !windows {
	// SDL libs are loaded dynamically from Java on Android
	$if !android || termux {
		// sdl_no_compile_flags allow users to provide
		// custom flags (e.g. via CFLAGS/LDFLAGS) for the compiler.
		// This is especially useful when building/linking against a
		// custom compiled version of the libs on *nix.
		$if !sdl_no_compile_flags ? {
			#flag -lSDL2_ttf
		}
	}
}

$if x64 {
	#flag windows -L @VMODROOT/thirdparty/SDL2_ttf-2.0.14/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL2_ttf-2.0.14/lib/x86
}

#flag windows -I @VMODROOT/thirdparty/SDL2_ttf-2.0.14/include
#flag windows -lSDL2_ttf

#include <SDL_ttf.h>
