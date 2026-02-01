// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module mixer

$if !windows {
	// SDL libs are loaded dynamically from Java on Android
	$if !android || termux {
		// sdl_no_compile_flags allow users to provide
		// custom flags (e.g. via CFLAGS/LDFLAGS) for the compiler.
		// This is especially useful when building/linking against a
		// custom compiled version of the libs on *nix.
		$if !sdl_no_compile_flags ? {
			#flag -lSDL3_mixer
		}
	}
}

$if x64 {
	#flag windows -L @VMODROOT/thirdparty/SDL3_mixer-3.1.2/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL3_mixer-3.1.2/lib/x86
}
#flag windows -I @VMODROOT/thirdparty/SDL3_mixer-3.1.2/include
#flag windows -lSDL3_mixer

#include <SDL3_mixer/SDL_mixer.h>
