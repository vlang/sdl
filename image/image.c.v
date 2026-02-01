// Copyright(C) 2026 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module image

//
// SDL_image.h
//
import sdl

pub const major_version = C.SDL_IMAGE_MAJOR_VERSION // 3

pub const minor_version = C.SDL_IMAGE_MINOR_VERSION // 4

pub const micro_version = C.SDL_IMAGE_MICRO_VERSION // 0
pub const patchlevel = micro_version

// compiledversion is the version number macro for the current SDL_image version.
pub fn compiledversion() int {
	return C.SDL_VERSIONNUM(major_version, minor_version, micro_version)
}

// This macro will evaluate to true if compiled with SDL_image at least X.Y.Z.
fn C.SDL_IMAGE_VERSION_ATLEAST(x int, y int, z int) bool

// version_atleast evaluates to true if compiled with SDL_image at least X.Y.Z.
pub fn version_atleast(x int, y int, z int) bool {
	return C.SDL_IMAGE_VERSION_ATLEAST(x, y, z)
}

fn C.IMG_LoadTyped_IO(src &C.SDL_IOStream, closeio bool, const_type &char) &C.SDL_Surface

// load_typed_io loads an image from an SDL data source.
// The 'type' may be one of: "BMP", "GIF", "PNG", etc.
//
// If the image format supports a transparent pixel, SDL will set the
// colorkey for the surface.  You can enable RLE acceleration on the
// surface afterwards by calling:
// SDL_SetColorKey(image, SDL_RLEACCEL, image->format->colorkey);
pub fn load_typed_io(src &sdl.RWops, closeio bool, const_type &char) &sdl.Surface {
	return C.IMG_LoadTyped_IO(src, closeio, const_type)
}

// Convenience functions
fn C.IMG_Load(file &char) &C.SDL_Surface
pub fn load(file &char) &sdl.Surface {
	return C.IMG_Load(file)
}

fn C.IMG_Load_IO(src &C.SDL_IOStream, closeio bool) &C.SDL_Surface
pub fn load_io(src &sdl.RWops, closeio bool) &sdl.Surface {
	return C.IMG_Load_IO(src, closeio)
}

fn C.IMG_LoadTexture(renderer &C.SDL_Renderer, const_file &char) &C.SDL_Texture

// load_texture loads an image directly into a render texture.
pub fn load_texture(renderer &sdl.Renderer, const_file &char) &sdl.Texture {
	return C.IMG_LoadTexture(renderer, const_file)
}

fn C.IMG_LoadTexture_IO(renderer &C.SDL_Renderer, src &C.SDL_IOStream, closeio bool) &C.SDL_Texture
pub fn load_texture_io(renderer &sdl.Renderer, src &sdl.RWops, closeio bool) &sdl.Texture {
	return C.IMG_LoadTexture_IO(renderer, src, closeio)
}

fn C.IMG_LoadTextureTyped_IO(renderer &C.SDL_Renderer, src &C.SDL_IOStream, closeio bool, const_type &char) &C.SDL_Texture
pub fn load_texture_typed_io(renderer &sdl.Renderer, src &sdl.RWops, closeio bool, const_type &char) &sdl.Texture {
	return C.IMG_LoadTextureTyped_IO(renderer, src, closeio, const_type)
}

// Functions to detect a file type, given a seekable source
fn C.IMG_isICO(src &C.SDL_IOStream) bool
pub fn is_ico(src &sdl.RWops) bool {
	return C.IMG_isICO(src)
}

fn C.IMG_isCUR(src &C.SDL_IOStream) bool
pub fn is_cur(src &sdl.RWops) bool {
	return C.IMG_isCUR(src)
}

fn C.IMG_isBMP(src &C.SDL_IOStream) bool
pub fn is_bmp(src &sdl.RWops) bool {
	return C.IMG_isBMP(src)
}

fn C.IMG_isGIF(src &C.SDL_IOStream) bool
pub fn is_gif(src &sdl.RWops) bool {
	return C.IMG_isGIF(src)
}

fn C.IMG_isJPG(src &C.SDL_IOStream) bool
pub fn is_jpg(src &sdl.RWops) bool {
	return C.IMG_isJPG(src)
}

fn C.IMG_isLBM(src &C.SDL_IOStream) bool
pub fn is_lbm(src &sdl.RWops) bool {
	return C.IMG_isLBM(src)
}

fn C.IMG_isPCX(src &C.SDL_IOStream) bool
pub fn is_pcx(src &sdl.RWops) bool {
	return C.IMG_isPCX(src)
}

fn C.IMG_isPNG(src &C.SDL_IOStream) bool
pub fn is_png(src &sdl.RWops) bool {
	return C.IMG_isPNG(src)
}

fn C.IMG_isPNM(src &C.SDL_IOStream) bool
pub fn is_pnm(src &sdl.RWops) bool {
	return C.IMG_isPNM(src)
}

fn C.IMG_isSVG(src &C.SDL_IOStream) bool
pub fn is_svg(src &sdl.RWops) bool {
	return C.IMG_isSVG(src)
}

fn C.IMG_isTIF(src &C.SDL_IOStream) bool
pub fn is_tif(src &sdl.RWops) bool {
	return C.IMG_isTIF(src)
}

fn C.IMG_isXCF(src &C.SDL_IOStream) bool
pub fn is_xcf(src &sdl.RWops) bool {
	return C.IMG_isXCF(src)
}

fn C.IMG_isXPM(src &C.SDL_IOStream) bool
pub fn is_xpm(src &sdl.RWops) bool {
	return C.IMG_isXPM(src)
}

fn C.IMG_isXV(src &C.SDL_IOStream) bool
pub fn is_xv(src &sdl.RWops) bool {
	return C.IMG_isXV(src)
}

fn C.IMG_isWEBP(src &C.SDL_IOStream) bool
pub fn is_webp(src &sdl.RWops) bool {
	return C.IMG_isWEBP(src)
}

// Individual loading functions
fn C.IMG_LoadICO_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_ico_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadICO_IO(src)
}

fn C.IMG_LoadCUR_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_cur_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadCUR_IO(src)
}

fn C.IMG_LoadBMP_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_bmp_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadBMP_IO(src)
}

fn C.IMG_LoadGIF_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_gif_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadGIF_IO(src)
}

fn C.IMG_LoadJPG_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_jpg_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadJPG_IO(src)
}

fn C.IMG_LoadLBM_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_lbm_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadLBM_IO(src)
}

fn C.IMG_LoadPCX_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_pcx_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadPCX_IO(src)
}

fn C.IMG_LoadPNG_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_png_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadPNG_IO(src)
}

fn C.IMG_LoadPNM_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_pnm_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadPNM_IO(src)
}

fn C.IMG_LoadSVG_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_svg_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadSVG_IO(src)
}

fn C.IMG_LoadTGA_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_tga_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadTGA_IO(src)
}

fn C.IMG_LoadTIF_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_tif_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadTIF_IO(src)
}

fn C.IMG_LoadXCF_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_xcf_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadXCF_IO(src)
}

fn C.IMG_LoadXPM_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_xpm_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadXPM_IO(src)
}

fn C.IMG_LoadXV_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_xv_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadXV_IO(src)
}

fn C.IMG_LoadWEBP_IO(src &C.SDL_IOStream) &C.SDL_Surface
pub fn load_webp_io(src &sdl.RWops) &sdl.Surface {
	return C.IMG_LoadWEBP_IO(src)
}

fn C.IMG_ReadXPMFromArray(xpm &&char) &C.SDL_Surface
pub fn read_xpm_from_array(xpm &&char) &sdl.Surface {
	return C.IMG_ReadXPMFromArray(xpm)
}

// Individual saving functions
fn C.IMG_SavePNG(surface &C.SDL_Surface, const_file &char) bool
pub fn save_png(surface &sdl.Surface, const_file &char) bool {
	return C.IMG_SavePNG(surface, const_file)
}

fn C.IMG_SavePNG_IO(surface &C.SDL_Surface, dst &C.SDL_IOStream, closeio bool) bool
pub fn save_png_io(surface &sdl.Surface, dst &sdl.RWops, closeio bool) bool {
	return C.IMG_SavePNG_IO(surface, dst, closeio)
}

fn C.IMG_SaveJPG(surface &C.SDL_Surface, const_file &char, quality int) bool
pub fn save_jpg(surface &sdl.Surface, const_file &char, quality int) bool {
	return C.IMG_SaveJPG(surface, const_file, quality)
}

fn C.IMG_SaveJPG_IO(surface &C.SDL_Surface, dst &C.SDL_IOStream, closeio bool, quality int) bool
pub fn save_jpg_io(surface &sdl.Surface, dst &sdl.RWops, closeio bool, quality int) bool {
	return C.IMG_SaveJPG_IO(surface, dst, closeio, quality)
}
