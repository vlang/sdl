// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module image

//
// SDL_image.h
//
import sdl

pub const (
	major_version = C.SDL_IMAGE_MAJOR_VERSION // 2
	minor_version = C.SDL_IMAGE_MINOR_VERSION // 0
	patchlevel    = C.SDL_IMAGE_PATCHLEVEL // 5
)

fn C.SDL_IMAGE_VERSION(v &sdl.Version)

// image_version macro can be used to fill a version structure with the compile-time
// version of the SDL_image library.
pub fn image_version(v &sdl.Version) {
	C.SDL_IMAGE_VERSION(v)
}

// This is the version number macro for the current SDL_image version.
pub fn C.SDL_IMAGE_COMPILEDVERSION() int

// compiledversion is the version number macro for the current SDL_image version.
pub fn compiledversion() int {
	return C.SDL_VERSIONNUM(image.major_version, image.minor_version, image.patchlevel)
}

// This macro will evaluate to true if compiled with SDL_image at least X.Y.Z.
pub fn C.SDL_IMAGE_VERSION_ATLEAST(x int, y int, z int) bool

// extern DECLSPEC const SDL_version * SDLCALL IMG_Linked_Version(void)
fn C.IMG_Linked_Version() &C.SDL_version
pub fn linked_version() &sdl.Version {
	return C.IMG_Linked_Version()
}

// InitFlags isC.IMG_InitFlags
pub enum InitFlags {
	jpg = C.IMG_INIT_JPG // 0x00000001
	png = C.IMG_INIT_PNG // 0x00000002
	tif = C.IMG_INIT_TIF // 0x00000004
	webp = C.IMG_INIT_WEBP // 0x00000008
}

fn C.IMG_Init(flags int) int

// init loads dynamic libraries and prepares them for use.  Flags should be
// one or more flags from IMG_InitFlags OR'd together.
// It returns the flags successfully initialized, or 0 on failure.
pub fn init(flags int) int {
	return C.IMG_Init(flags)
}

fn C.IMG_Quit()

// quit unloads libraries loaded with IMG_Init
pub fn quit() {
	C.IMG_Quit()
}

fn C.IMG_LoadTyped_RW(src &C.SDL_RWops, freesrc int, const_type &char) &C.SDL_Surface

// load_typed_rw loads an image from an SDL data source.
// The 'type' may be one of: "BMP", "GIF", "PNG", etc.
//
// If the image format supports a transparent pixel, SDL will set the
// colorkey for the surface.  You can enable RLE acceleration on the
// surface afterwards by calling:
// SDL_SetColorKey(image, SDL_RLEACCEL, image->format->colorkey);
pub fn load_typed_rw(src &sdl.RWops, freesrc int, const_type &char) &sdl.Surface {
	return C.IMG_LoadTyped_RW(src, freesrc, const_type)
}

// Convenience functions
fn C.IMG_Load(file &char) &C.SDL_Surface
pub fn load(file &char) &sdl.Surface {
	return C.IMG_Load(file)
}

fn C.IMG_Load_RW(src &C.SDL_RWops, freesrc int) &C.SDL_Surface
pub fn load_rw(src &sdl.RWops, freesrc int) &sdl.Surface {
	return C.IMG_Load_RW(src, freesrc)
}

fn C.IMG_LoadTexture(renderer &C.SDL_Renderer, const_file &char) &C.SDL_Texture

// load_texture loads an image directly into a render texture.
pub fn load_texture(renderer &sdl.Renderer, const_file &char) &sdl.Texture {
	return C.IMG_LoadTexture(renderer, const_file)
}

fn C.IMG_LoadTexture_RW(renderer &C.SDL_Renderer, src &C.SDL_RWops, freesrc int) &C.SDL_Texture
pub fn load_texture_rw(renderer &sdl.Renderer, src &sdl.RWops, freesrc int) &sdl.Texture {
	return C.IMG_LoadTexture_RW(renderer, src, freesrc)
}

fn C.IMG_LoadTextureTyped_RW(renderer &C.SDL_Renderer, src &C.SDL_RWops, freesrc int, const_type &char) &C.SDL_Texture
pub fn load_texture_typed_rw(renderer &sdl.Renderer, src &sdl.RWops, freesrc int, const_type &char) &sdl.Texture {
	return C.IMG_LoadTextureTyped_RW(renderer, src, freesrc, const_type)
}

// Functions to detect a file type, given a seekable source
fn C.IMG_isICO(src &C.SDL_RWops) int
pub fn is_ico(src &sdl.RWops) int {
	return C.IMG_isICO(src)
}

fn C.IMG_isCUR(src &C.SDL_RWops) int
pub fn is_cur(src &sdl.RWops) int {
	return C.IMG_isCUR(src)
}

fn C.IMG_isBMP(src &C.SDL_RWops) int
pub fn is_bmp(src &sdl.RWops) int {
	return C.IMG_isBMP(src)
}

fn C.IMG_isGIF(src &C.SDL_RWops) int
pub fn is_gif(src &sdl.RWops) int {
	return C.IMG_isGIF(src)
}

fn C.IMG_isJPG(src &C.SDL_RWops) int
pub fn is_jpg(src &sdl.RWops) int {
	return C.IMG_isJPG(src)
}

fn C.IMG_isLBM(src &C.SDL_RWops) int
pub fn is_lbm(src &sdl.RWops) int {
	return C.IMG_isLBM(src)
}

fn C.IMG_isPCX(src &C.SDL_RWops) int
pub fn is_pcx(src &sdl.RWops) int {
	return C.IMG_isPCX(src)
}

fn C.IMG_isPNG(src &C.SDL_RWops) int
pub fn is_png(src &sdl.RWops) int {
	return C.IMG_isPNG(src)
}

fn C.IMG_isPNM(src &C.SDL_RWops) int
pub fn is_pnm(src &sdl.RWops) int {
	return C.IMG_isPNM(src)
}

fn C.IMG_isSVG(src &C.SDL_RWops) int
pub fn is_svg(src &sdl.RWops) int {
	return C.IMG_isSVG(src)
}

fn C.IMG_isTIF(src &C.SDL_RWops) int
pub fn is_tif(src &sdl.RWops) int {
	return C.IMG_isTIF(src)
}

fn C.IMG_isXCF(src &C.SDL_RWops) int
pub fn is_xcf(src &sdl.RWops) int {
	return C.IMG_isXCF(src)
}

fn C.IMG_isXPM(src &C.SDL_RWops) int
pub fn is_xpm(src &sdl.RWops) int {
	return C.IMG_isXPM(src)
}

fn C.IMG_isXV(src &C.SDL_RWops) int
pub fn is_xv(src &sdl.RWops) int {
	return C.IMG_isXV(src)
}

fn C.IMG_isWEBP(src &C.SDL_RWops) int
pub fn is_webp(src &sdl.RWops) int {
	return C.IMG_isWEBP(src)
}

// Individual loading functions
fn C.IMG_LoadICO_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_ico_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadICO_RW(src)
}

fn C.IMG_LoadCUR_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_cur_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadCUR_RW(src)
}

fn C.IMG_LoadBMP_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_bmp_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadBMP_RW(src)
}

fn C.IMG_LoadGIF_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_gif_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadGIF_RW(src)
}

fn C.IMG_LoadJPG_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_jpg_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadJPG_RW(src)
}

fn C.IMG_LoadLBM_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_lbm_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadLBM_RW(src)
}

fn C.IMG_LoadPCX_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_pcx_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadPCX_RW(src)
}

fn C.IMG_LoadPNG_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_png_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadPNG_RW(src)
}

fn C.IMG_LoadPNM_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_pnm_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadPNM_RW(src)
}

fn C.IMG_LoadSVG_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_svg_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadSVG_RW(src)
}

fn C.IMG_LoadTGA_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_tga_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadTGA_RW(src)
}

fn C.IMG_LoadTIF_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_tif_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadTIF_RW(src)
}

fn C.IMG_LoadXCF_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_xcf_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadXCF_RW(src)
}

fn C.IMG_LoadXPM_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_xpm_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadXPM_RW(src)
}

fn C.IMG_LoadXV_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_xv_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadXV_RW(src)
}

fn C.IMG_LoadWEBP_RW(src &C.SDL_RWops) &C.SDL_Surface
pub fn load_webp_rw(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadWEBP_RW(src)
}

fn C.IMG_ReadXPMFromArray(xpm &&char) &C.SDL_Surface
pub fn read_xpm_from_array(xpm &&char) &sdl.Surface {
	return C.IMG_ReadXPMFromArray(xpm)
}

// Individual saving functions
fn C.IMG_SavePNG(surface &C.SDL_Surface, const_file &char) int
pub fn save_png(surface &sdl.Surface, const_file &char) int {
	return C.IMG_SavePNG(surface, const_file)
}

fn C.IMG_SavePNG_RW(surface &C.SDL_Surface, dst &C.SDL_RWops, freedst int) int
pub fn save_png_rw(surface &sdl.Surface, dst &sdl.RWops, freedst int) int {
	return C.IMG_SavePNG_RW(surface, dst, freedst)
}

fn C.IMG_SaveJPG(surface &C.SDL_Surface, const_file &char, quality int) int
pub fn save_jpg(surface &sdl.Surface, const_file &char, quality int) int {
	return C.IMG_SaveJPG(surface, const_file, quality)
}

fn C.IMG_SaveJPG_RW(surface &C.SDL_Surface, dst &C.SDL_RWops, freedst int, quality int) int
pub fn save_jpg_rw(surface &sdl.Surface, dst &sdl.RWops, freedst int, quality int) int {
	return C.IMG_SaveJPG_RW(surface, dst, freedst, quality)
}
