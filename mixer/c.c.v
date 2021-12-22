// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module mixer

#flag windows -I @VMODROOT/thirdparty/SDL2_mixer/include
#flag windows -L @VMODROOT/thirdparty/SDL2_mixer/lib/x64
#flag windows -lSDL2_mixer

#include <SDL_mixer.h>
