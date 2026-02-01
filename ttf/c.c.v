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
			#flag -lSDL3_ttf
		}
	}
}

$if x64 {
	#flag windows -L @VMODROOT/thirdparty/SDL3_ttf-3.2.2/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL3_ttf-3.2.2/lib/x86
}

#flag windows -I @VMODROOT/thirdparty/SDL3_ttf-3.2.2/include
#flag windows -lSDL3_ttf

#include <SDL3_ttf/SDL_ttf.h>
