// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module vulkan

import sdl

//
// SDL_vulkan.h
//

/*
TODO
[typedef]
// C.VkInstance
pub struct C.SDL_vulkanInstance {
}
// C.VkSurfaceKHR
[typedef]
pub struct C.SDL_vulkanSurface {
	// for compatibility with Tizen
}*/

fn C.SDL_Vulkan_LoadLibrary(path &char) int

// vulkan_load_library dynamically loads the Vulkan loader library.
//
// This should be called after initializing the video driver, but before
// creating any Vulkan windows. If no Vulkan loader library is loaded, the
// default library will be loaded upon creation of the first Vulkan window.
//
// It is fairly common for Vulkan applications to link with libvulkan instead
// of explicitly loading it at run time. This will work with SDL provided the
// application links to a dynamic library and both it and SDL use the same
// search path.
//
// If you specify a non-NULL `path`, an application should retrieve all of the
// Vulkan functions it uses from the dynamic library using
// SDL_Vulkan_GetVkGetInstanceProcAddr unless you can guarantee `path` points
// to the same vulkan loader library the application linked to.
//
// On Apple devices, if `path` is NULL, SDL will attempt to find the
// `vkGetInstanceProcAddr` address within all the Mach-O images of the current
// process. This is because it is fairly common for Vulkan applications to
// link with libvulkan (and historically MoltenVK was provided as a static
// library). If it is not found, on macOS, SDL will attempt to load
// `vulkan.framework/vulkan`, `libvulkan.1.dylib`,
// `MoltenVK.framework/MoltenVK`, and `libMoltenVK.dylib`, in that order. On
// iOS, SDL will attempt to load `libMoltenVK.dylib`. Applications using a
// dynamic framework or .dylib must ensure it is included in its application
// bundle.
//
// On non-Apple devices, application linking with a static libvulkan is not
// supported. Either do not link to the Vulkan loader or link to a dynamic
// library version.
//
// `path` The platform dependent Vulkan loader library name or NULL
// returns 0 on success or -1 if the library couldn't be loaded; call
//          SDL_GetError() for more information.
//
// NOTE This function is available in SDL 2.0.8
//
// See also: SDL_Vulkan_GetVkInstanceProcAddr
// See also: SDL_Vulkan_UnloadLibrary
pub fn vulkan_load_library(path &char) int {
	return C.SDL_Vulkan_LoadLibrary(path)
}

fn C.SDL_Vulkan_GetVkGetInstanceProcAddr() voidptr

// vulkan_get_vk_get_instance_proc_addr gets the address of the `vkGetInstanceProcAddr` function.
//
// This should be called after either calling SDL_Vulkan_LoadLibrary() or
// creating an SDL_Window with the `SDL_WINDOW_VULKAN` flag.
//
// returns the function pointer for `vkGetInstanceProcAddr` or NULL on error.
pub fn vulkan_get_vk_get_instance_proc_addr() voidptr {
	return C.SDL_Vulkan_GetVkGetInstanceProcAddr()
}

fn C.SDL_Vulkan_UnloadLibrary()

// vulkan_unload_library unloads the Vulkan library previously loaded by SDL_Vulkan_LoadLibrary()
//
// NOTE This function is available in SDL 2.0.8
//
// See also: SDL_Vulkan_LoadLibrary
pub fn vulkan_unload_library() {
	C.SDL_Vulkan_UnloadLibrary()
}

fn C.SDL_Vulkan_GetInstanceExtensions(window &C.SDL_Window, p_count &u32, p_names &&char) bool

// vulkan_get_instance_extensions gets the names of the Vulkan instance extensions needed to create a surface
// with SDL_Vulkan_CreateSurface.
//
// If `pNames` is NULL, then the number of required Vulkan instance extensions
// is returned in `pCount`. Otherwise, `pCount` must point to a variable set
// to the number of elements in the `pNames` array, and on return the variable
// is overwritten with the number of names actually written to `pNames`. If
// `pCount` is less than the number of required extensions, at most `pCount`
// structures will be written. If `pCount` is smaller than the number of
// required extensions, SDL_FALSE will be returned instead of SDL_TRUE, to
// indicate that not all the required extensions were returned.
//
// The `window` parameter is currently needed to be valid as of SDL 2.0.8,
// however, this parameter will likely be removed in future releases
//
// `window` A window for which the required Vulkan instance extensions
//               should be retrieved (will be deprecated in a future release)
// `pCount` A pointer to an unsigned int corresponding to the number of
//               extensions to be returned
// `pNames` NULL or a pointer to an array to be filled with required
//               Vulkan instance extensions
// returns SDL_TRUE on success, SDL_FALSE on error.
//
// NOTE This function is available in SDL 2.0.8
//
// See also: SDL_Vulkan_CreateSurface
pub fn vulkan_get_instance_extensions(window &sdl.Window, p_count &u32, p_names &&char) bool {
	return C.SDL_Vulkan_GetInstanceExtensions(window, p_count, p_names)
}

// vulkan_create_surface creates a Vulkan rendering surface for a window.
//
// The `window` must have been created with the `SDL_WINDOW_VULKAN` flag and
// `instance` must have been created with extensions returned by
// SDL_Vulkan_GetInstanceExtensions() enabled.
//
// `window` The window to which to attach the Vulkan surface
// `instance` The Vulkan instance handle
// `surface` A pointer to a VkSurfaceKHR handle to output the newly
//                created surface
// returns SDL_TRUE on success, SDL_FALSE on error.
//
// NOTE This function is available in SDL 2.0.8
//
// See also: SDL_Vulkan_GetInstanceExtensions
// See also: SDL_Vulkan_GetDrawableSize
/*
TODO
fn C.SDL_Vulkan_CreateSurface(window &C.SDL_Window, instance C.VkInstance, surface &C.VkSurfaceKHR) bool
pub fn vulkan_create_surface(window &Window, instance C.VkInstance, surface &C.VkSurfaceKHR) bool{
	return C.SDL_Vulkan_CreateSurface(window, instance, surface)
}
*/

fn C.SDL_Vulkan_GetDrawableSize(window &C.SDL_Window, w &int, h &int)

// vulkan_get_drawable_size gets the size of the window's underlying drawable dimensions in pixels.
//
// This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
// drawable, i.e. the window was created with `SDL_WINDOW_ALLOW_HIGHDPI` on a
// platform with high-DPI support (Apple calls this "Retina"), and not
// disabled by the `SDL_HINT_VIDEO_HIGHDPI_DISABLED` hint.
//
// `window` an SDL_Window for which the size is to be queried
// `w` Pointer to the variable to write the width to or NULL
// `h` Pointer to the variable to write the height to or NULL
//
// NOTE This function is available in SDL 2.0.8
//
// See also: SDL_GetWindowSize
// See also: SDL_CreateWindow
// See also: SDL_Vulkan_CreateSurface
pub fn vulkan_get_drawable_size(window &sdl.Window, w &int, h &int) {
	C.SDL_Vulkan_GetDrawableSize(window, w, h)
}
