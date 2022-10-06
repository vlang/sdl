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
			#pkgconfig --cflags --libs sdl2
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
	#flag windows -L @VMODROOT/thirdparty/SDL2-2.0.12/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL2-2.0.12/lib/x86
}
#flag windows -I @VMODROOT/thirdparty/SDL2-2.0.12/include
#flag windows -Dmain=SDL_main
#flag windows -lSDL2main -lSDL2

$if gcboehm ? {
	#define SDL_malloc GC_MALLOC
	#define SDL_calloc(n,m) V_GC_SDL_calloc(n, m)
	#define SDL_realloc GC_REALLOC
	#define SDL_free GC_FREE
	#insert "@VMODROOT/c/v_gc_sdl_boehm.c"
}

#include <SDL.h>
