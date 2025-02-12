// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module c

pub const used_import = 1

$if !windows {
	// SDL libs are loaded dynamically from Java on Android
	$if !android || termux {
		// sdl_no_compile_flags allow users to provide
		// custom flags (e.g. via CFLAGS/LDFLAGS) for the compiler.
		// This is especially useful when building/linking against a
		// custom compiled version of the libs on *nix.
		$if !sdl_no_compile_flags ? {
			$if sdl_compat ? {
				// Use SDL2 through SDL3 via the compatibility layer
				#pkgconfig --cflags --libs sdl2_compat
			} $else {
				#pkgconfig --cflags --libs sdl2
			}
		}
	}
} $else {
	$if tinyc {
		#define _STDINT_H_
		#flag -L @VMODROOT/thirdparty
	}
}

#flag -DSDL_DISABLE_IMMINTRIN_H

$if x64 {
	#flag windows -L @VMODROOT/thirdparty/SDL2-2.32.0/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL2-2.32.0/lib/x86
}

#flag windows -I @VMODROOT/thirdparty/SDL2-2.32.0/include
#flag windows -lSDL2

#include <SDL.h>
