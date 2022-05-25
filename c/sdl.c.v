// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module c

pub const used_import = 1

$if !windows {
	#pkgconfig --cflags --libs sdl2
	#flag -lSDL2_ttf -lSDL2_mixer -lSDL2_image
} $else {
	$if tinyc {
		#define _STDINT_H_
		#flag -L @VMODROOT/thirdparty
	}
}

#flag -DSDL_DISABLE_IMMINTRIN_H

$if x64 {
	#flag windows -L @VMODROOT/thirdparty/SDL2-2.0.22/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL2-2.0.22/lib/x86
}
#flag windows -I @VMODROOT/thirdparty/SDL2-2.0.22/include
#flag windows -Dmain=SDL_main
#flag windows -lSDL2main -lSDL2

#include <SDL.h>
