// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module ttf

#flag windows -I @VMODROOT/thirdparty/SDL2_ttf/include
#flag windows -L @VMODROOT/thirdparty/SDL2_ttf/lib/x64
#flag windows -lSDL2_ttf

#include <SDL_ttf.h>
