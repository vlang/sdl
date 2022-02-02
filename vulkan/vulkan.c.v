// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_vulkan.h
//

/*
TODO
[typedef]
// C.VkInstance
struct C.SDL_vulkanInstance {
}
// C.VkSurfaceKHR
[typedef]
struct C.SDL_vulkanSurface {
	// for compatibility with Tizen
}*/

fn C.SDL_Vulkan_LoadLibrary(path &char) int

// vulkan_load_library dynamically load a Vulkan loader library.
//
// `path` [in] The platform dependent Vulkan loader library name, or
// `NULL`.
//
// returns `0` on success, or `-1` if the library couldn't be loaded.
//
// If `path` is NULL SDL will use the value of the environment variable
// `SDL_VULKAN_LIBRARY`, if set, otherwise it loads the default Vulkan
// loader library.
//
// This should be called after initializing the video driver, but before
// creating any Vulkan windows. If no Vulkan loader library is loaded, the
// default library will be loaded upon creation of the first Vulkan window.
//
// NOTE It is fairly common for Vulkan applications to link with `libvulkan`
//   instead of explicitly loading it at run time. This will work with
//   SDL provided the application links to a dynamic library and both it
//   and SDL use the same search path.
//
// NOTE If you specify a non-NULL `path`, an application should retrieve all
//   of the Vulkan functions it uses from the dynamic library using
//   `SDL_Vulkan_GetVkGetInstanceProcAddr`() unless you can guarantee
//   `path` points to the same vulkan loader library the application
//   linked to.
//
// NOTE On Apple devices, if `path` is NULL, SDL will attempt to find
//   the vkGetInstanceProcAddr address within all the mach-o images of
//   the current process. This is because it is fairly common for Vulkan
//   applications to link with libvulkan (and historically MoltenVK was
//   provided as a static library). If it is not found then, on macOS, SDL
//   will attempt to load `vulkan.framework/vulkan`, `libvulkan.1.dylib`,
//   `MoltenVK.framework/MoltenVK` and `libMoltenVK.dylib` in that order.
//   On iOS SDL will attempt to load `libMoltenVK.dylib`. Applications
//   using a dynamic framework or .dylib must ensure it is included in its
//   application bundle.
//
// NOTE On non-Apple devices, application linking with a static libvulkan is
//   not supported. Either do not link to the Vulkan loader or link to a
//   dynamic library version.
//
// NOTE This function will fail if there are no working Vulkan drivers
//   installed.
//
// See also: SDL_Vulkan_GetVkGetInstanceProcAddr()
// See also: SDL_Vulkan_UnloadLibrary()
pub fn vulkan_load_library(path &char) int {
	return C.SDL_Vulkan_LoadLibrary(path)
}

fn C.SDL_Vulkan_GetVkGetInstanceProcAddr() voidptr

// vulkan_get_vk_get_instance_proc_addr gets the address of the `vkGetInstanceProcAddr` function.
//
// NOTE This should be called after either calling SDL_Vulkan_LoadLibrary
// or creating an SDL_Window with the SDL_WINDOW_VULKAN flag.
pub fn vulkan_get_vk_get_instance_proc_addr() voidptr {
	return C.SDL_Vulkan_GetVkGetInstanceProcAddr()
}

fn C.SDL_Vulkan_UnloadLibrary()

// vulkan_unload_library unload the Vulkan loader library previously loaded by
// `SDL_Vulkan_LoadLibrary`().
//
// See also: SDL_Vulkan_LoadLibrary()
pub fn vulkan_unload_library() {
	C.SDL_Vulkan_UnloadLibrary()
}

fn C.SDL_Vulkan_GetInstanceExtensions(window &C.SDL_Window, p_count &u32, p_names &&char) bool

// vulkan_get_instance_extensions gets the names of the Vulkan instance extensions needed to create
// a surface with `SDL_Vulkan_CreateSurface()`.
//
// `window` [in] Window for which the required Vulkan instance
// extensions should be retrieved
// `count` [in,out] pointer to an `unsigned` related to the number of
// required Vulkan instance extensions
// `names` [out] `NULL` or a pointer to an array to be filled with the
// required Vulkan instance extensions
//
// returns `SDL_TRUE` on success, `SDL_FALSE` on error.
//
// If `pNames` is `NULL`, then the number of required Vulkan instance
// extensions is returned in pCount. Otherwise, `pCount` must point to a
// variable set to the number of elements in the `pNames` array, and on
// return the variable is overwritten with the number of names actually
// written to `pNames`. If `pCount` is less than the number of required
// extensions, at most `pCount` structures will be written. If `pCount`
// is smaller than the number of required extensions, `SDL_FALSE` will be
// returned instead of `SDL_TRUE`, to indicate that not all the required
// extensions were returned.
//
// NOTE The returned list of extensions will contain `VK_KHR_surface`
// and zero or more platform specific extensions
//
// NOTE The extension names queried here must be enabled when calling
// VkCreateInstance, otherwise surface creation will fail.
//
// NOTE `window` should have been created with the `SDL_WINDOW_VULKAN` flag.
//
/*
```
 unsigned int count;
 // get count of required extensions
 if(!SDL_Vulkan_GetInstanceExtensions(window, &count, NULL))
   handle_error();

 static const char *const additionalExtensions[] =
 {
   VK_EXT_DEBUG_REPORT_EXTENSION_NAME, // example additional extension
 };
 size_t additionalExtensionsCount = sizeof(additionalExtensions) / sizeof(additionalExtensions[0]);
 size_t extensionCount = count + additionalExtensionsCount;
 const char **names = malloc(sizeof(const char *) * extensionCount);
 if(!names)
   handle_error();

 // get names of required extensions
 if(!SDL_Vulkan_GetInstanceExtensions(window, &count, names))
   handle_error();

 // copy additional extensions after required extensions
 for(size_t i = 0; i < additionalExtensionsCount; i++)
   names[i + count] = additionalExtensions[i];

 VkInstanceCreateInfo instanceCreateInfo = {};
 instanceCreateInfo.enabledExtensionCount = extensionCount;
 instanceCreateInfo.ppEnabledExtensionNames = names;
 // fill in rest of instanceCreateInfo

 VkInstance instance;
 // create the Vulkan instance
 VkResult result = vkCreateInstance(&instanceCreateInfo, NULL, &instance);
 free(names);
```
*/
//
// See also: SDL_Vulkan_CreateSurface()
pub fn vulkan_get_instance_extensions(window &Window, p_count &u32, p_names &&char) bool {
	return C.SDL_Vulkan_GetInstanceExtensions(window, p_count, p_names)
}

// vulkan_create_surface creates a Vulkan rendering surface for a window.
//
// `window` [in]   SDL_Window to which to attach the rendering surface.
// `instance` [in] handle to the Vulkan instance to use.
// `surface` [out]  pointer to a VkSurfaceKHR handle to receive the
// handle of the newly created surface.
//
// returns `SDL_TRUE` on success, `SDL_FALSE` on error.
//
// \code
// VkInstance instance;
// SDL_Window *window;
//
// // create instance and window
//
// // create the Vulkan surface
// VkSurfaceKHR surface;
// if(!SDL_Vulkan_CreateSurface(window, instance, &surface))
// handle_error();
// \endcode
//
// NOTE `window` should have been created with the `SDL_WINDOW_VULKAN` flag.
//
// NOTE `instance` should have been created with the extensions returned
// by `SDL_Vulkan_CreateSurface`() enabled.
//
// See also: SDL_Vulkan_GetInstanceExtensions()
/*
TODO
fn C.SDL_Vulkan_CreateSurface(window &C.SDL_Window, instance C.VkInstance, surface &C.VkSurfaceKHR) bool
pub fn vulkan_create_surface(window &Window, instance C.VkInstance, surface &C.VkSurfaceKHR) bool{
	return C.SDL_Vulkan_CreateSurface(window, instance, surface)
}
*/

fn C.SDL_Vulkan_GetDrawableSize(window &C.SDL_Window, w &int, h &int)

// vulkan_get_drawable_size gets the size of a window's underlying drawable in pixels (for use
// with setting viewport, scissor & etc).
//
// `window`   SDL_Window from which the drawable size should be queried
// `w`        Pointer to variable for storing the width in pixels, may be NULL
// `h`        Pointer to variable for storing the height in pixels, may be NULL
//
// This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
// drawable, i.e. the window was created with SDL_WINDOW_ALLOW_HIGHDPI on a
// platform with high-DPI support (Apple calls this "Retina"), and not disabled
// by the `SDL_HINT_VIDEO_HIGHDPI_DISABLED` hint.
//
// NOTE On macOS high-DPI support must be enabled for an application by
// setting NSHighResolutionCapable to true in its Info.plist.
//
// See also: SDL_GetWindowSize()
// See also: SDL_CreateWindow()
pub fn vulkan_get_drawable_size(window &Window, w &int, h &int) {
	C.SDL_Vulkan_GetDrawableSize(window, w, h)
}
