// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module ttf

$if x64 {
	#flag windows -L @VMODROOT/thirdparty/SDL2_ttf-2.0.15/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL2_ttf-2.0.15/lib/x86
}

#flag windows -I @VMODROOT/thirdparty/SDL2_ttf-2.0.15/include
#flag windows -lSDL2_ttf

#include <SDL_ttf.h>
