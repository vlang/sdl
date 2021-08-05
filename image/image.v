module image

import sdl

#flag linux -lSDL2_image

#flag windows -I @VROOT/thirdparty/SDL2_image/include
#flag windows -L @VROOT/thirdparty/SDL2_image/lib/x64
#flag windows -lSDL2_image

#include <SDL_image.h>

//////////////////////////////////////////////////////////
// SDL_Image.h
//////////////////////////////////////////////////////////
pub const (
	img_init_jpg  = 0x00000001
	img_init_png  = 0x00000002
	img_init_tif  = 0x00000004
	img_init_webp = 0x00000008
)

fn C.IMG_Init(flags int) int
fn C.IMG_Quit()

// Load an image from an SDL data source. The 'type' may be one of: "BMP", "GIF", "PNG", etc.
fn C.IMG_LoadTyped_RW(src &SDL_RWops, freesrc int, _type &byte) &SDL_Surface
fn C.IMG_Load(file &byte) &SDL_Surface
fn C.IMG_Load_RW(src &SDL_RWops, freesrc int) &SDL_Surface

// Load an image directly into a render texture.
fn C.IMG_LoadTexture(renderer &SDL_Renderer, file &byte) &SDL_Texture
fn C.IMG_LoadTexture_RW(renderer &SDL_Renderer, src &SDL_RWops, freesrc int) &SDL_Texture
fn C.IMG_LoadTextureTyped_RW(renderer &SDL_Renderer, src &SDL_RWops, freesrc int, _type &byte) &SDL_Texture

// Functions to detect a file type, given a seekable source
fn C.IMG_isPNG(src &SDL_RWops) int
fn C.IMG_isBMP(src &SDL_RWops) int
fn C.IMG_isJPG(src &SDL_RWops) int
fn C.IMG_isWEBP(src &SDL_RWops) int

// Individual loading functions
fn C.IMG_LoadPNG_RW(src &SDL_RWops) &SDL_Surface
fn C.IMG_LoadBMP_RW(src &SDL_RWops) &SDL_Surface
fn C.IMG_LoadJPG_RW(src &SDL_RWops) &SDL_Surface
fn C.IMG_LoadWEBP_RW(src &SDL_RWops) &SDL_Surface

// Individual saving functions
fn C.IMG_SavePNG(surface voidptr, file &byte) int
fn C.IMG_SavePNG_RW(surface voidptr, dst &SDL_RWops, freedst int) int
fn C.IMG_SaveJPG(surface voidptr, file &byte) int
fn C.IMG_SaveJPG_RW(surface voidptr, dst &SDL_RWops, freedst int) int

pub fn img_init(flags int) int {
	return C.IMG_Init(flags)
}

pub fn quit() {
	C.IMG_Quit()
}

pub fn load(file string) &SDL_Surface {
	res := C.IMG_Load(file.str)
	return res
}

pub const (
	version = sdl.version // TODO: remove this hack to mark sdl as used; avoids warning
)
