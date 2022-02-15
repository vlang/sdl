module image

#flag linux -lSDL2_image

$if x64 {
	#flag windows -L @VMODROOT/thirdparty/SDL2_image-2.0.5/lib/x64
} $else {
	#flag windows -L @VMODROOT/thirdparty/SDL2_image-2.0.5/lib/x86
}
#flag windows -I @VMODROOT/thirdparty/SDL2_image-2.0.5/include
#flag windows -lSDL2_image

#include <SDL_image.h>
