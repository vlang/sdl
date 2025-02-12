// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module c

$if !windows {
	// SDL libs are loaded dynamically from Java on Android
	$if !android || termux {
		// sdl_no_compile_flags allow users to provide
		// custom flags (e.g. via CFLAGS/LDFLAGS) for the compiler.
		// This is especially useful when building/linking against a
		// custom compiled version of the libs on *nix.
		$if !sdl_no_compile_flags ? {
			#pkgconfig --cflags --libs sdl3
		}
	}
} $else {
	$if tinyc {
		#flag -L @VMODROOT/thirdparty
	}
}

$if x64 {
	#flag windows -L @VMODROOT/thirdparty/SDL3-3.2.0/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL3-3.2.0/lib/x86
}

#flag windows -I @VMODROOT/thirdparty/SDL3-3.2.0/include
#flag windows -lSDL3

// NOTE::
// See the files:
// ./implement_d_sdl_callbacks.c.v
// ./implement_notd_sdl_callbacks.c.v
// ./sdl_main_use_callbacks_shim.h
// ./../examples/ports/README.md
// ... for V's support of SDL3's *main-loop control inversion*.
