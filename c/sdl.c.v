// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module c

pub const used_import = 1

$if linux || macos || solaris {
	#pkgconfig --cflags --libs sdl2
	#flag -lSDL2_ttf -lSDL2_mixer -lSDL2_image
}

#flag -DSDL_DISABLE_IMMINTRIN_H

#flag windows -I @VMODROOT/thirdparty/SDL2/include
#flag windows -Dmain=SDL_main
#flag windows -lSDL2main -lSDL2
#flag windows -L @VMODROOT/thirdparty/SDL2/lib/x64

#include <SDL.h>
