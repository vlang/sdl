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

/**
 *  \brief Dynamically load a Vulkan loader library.
 *
 *  \param [in] path The platform dependent Vulkan loader library name, or
 *              \c NULL.
 *
 *  \return \c 0 on success, or \c -1 if the library couldn't be loaded.
 *
 *  If \a path is NULL SDL will use the value of the environment variable
 *  \c SDL_VULKAN_LIBRARY, if set, otherwise it loads the default Vulkan
 *  loader library.
 *
 *  This should be called after initializing the video driver, but before
 *  creating any Vulkan windows. If no Vulkan loader library is loaded, the
 *  default library will be loaded upon creation of the first Vulkan window.
 *
 *  \note It is fairly common for Vulkan applications to link with \a libvulkan
 *        instead of explicitly loading it at run time. This will work with
 *        SDL provided the application links to a dynamic library and both it
 *        and SDL use the same search path.
 *
 *  \note If you specify a non-NULL \c path, an application should retrieve all
 *        of the Vulkan functions it uses from the dynamic library using
 *        \c SDL_Vulkan_GetVkGetInstanceProcAddr() unless you can guarantee
 *        \c path points to the same vulkan loader library the application
 *        linked to.
 *
 *  \note On Apple devices, if \a path is NULL, SDL will attempt to find
 *        the vkGetInstanceProcAddr address within all the mach-o images of
 *        the current process. This is because it is fairly common for Vulkan
 *        applications to link with libvulkan (and historically MoltenVK was
 *        provided as a static library). If it is not found then, on macOS, SDL
 *        will attempt to load \c vulkan.framework/vulkan, \c libvulkan.1.dylib,
 *        \c MoltenVK.framework/MoltenVK and \c libMoltenVK.dylib in that order.
 *        On iOS SDL will attempt to load \c libMoltenVK.dylib. Applications
 *        using a dynamic framework or .dylib must ensure it is included in its
 *        application bundle.
 *
 *  \note On non-Apple devices, application linking with a static libvulkan is
 *        not supported. Either do not link to the Vulkan loader or link to a
 *        dynamic library version.
 *
 *  \note This function will fail if there are no working Vulkan drivers
 *        installed.
 *
 *  \sa SDL_Vulkan_GetVkGetInstanceProcAddr()
 *  \sa SDL_Vulkan_UnloadLibrary()
*/
// extern DECLSPEC int SDLCALL SDL_Vulkan_LoadLibrary(const char *path)
fn C.SDL_Vulkan_LoadLibrary(path &char) int
pub fn vulkan_load_library(path string) int {
	return C.SDL_Vulkan_LoadLibrary(path.str)
}

/**
 *  \brief Get the address of the \c vkGetInstanceProcAddr function.
 *
 *  \note This should be called after either calling SDL_Vulkan_LoadLibrary
 *        or creating an SDL_Window with the SDL_WINDOW_VULKAN flag.
*/
fn C.SDL_Vulkan_GetVkGetInstanceProcAddr() voidptr
pub fn vulkan_get_vk_get_instance_proc_addr() voidptr {
	return C.SDL_Vulkan_GetVkGetInstanceProcAddr()
}

/**
 *  \brief Unload the Vulkan loader library previously loaded by
 *         \c SDL_Vulkan_LoadLibrary().
 *
 *  \sa SDL_Vulkan_LoadLibrary()
*/
fn C.SDL_Vulkan_UnloadLibrary()
pub fn vulkan_unload_library() {
	C.SDL_Vulkan_UnloadLibrary()
}

/**
 *  \brief Get the names of the Vulkan instance extensions needed to create
 *         a surface with \c SDL_Vulkan_CreateSurface().
 *
 *  \param [in]     window Window for which the required Vulkan instance
 *                  extensions should be retrieved
 *  \param [in,out] count pointer to an \c unsigned related to the number of
 *                  required Vulkan instance extensions
 *  \param [out]    names \c NULL or a pointer to an array to be filled with the
 *                  required Vulkan instance extensions
 *
 *  \return \c SDL_TRUE on success, \c SDL_FALSE on error.
 *
 *  If \a pNames is \c NULL, then the number of required Vulkan instance
 *  extensions is returned in pCount. Otherwise, \a pCount must point to a
 *  variable set to the number of elements in the \a pNames array, and on
 *  return the variable is overwritten with the number of names actually
 *  written to \a pNames. If \a pCount is less than the number of required
 *  extensions, at most \a pCount structures will be written. If \a pCount
 *  is smaller than the number of required extensions, \c SDL_FALSE will be
 *  returned instead of \c SDL_TRUE, to indicate that not all the required
 *  extensions were returned.
 *
 *  \note The returned list of extensions will contain \c VK_KHR_surface
 *        and zero or more platform specific extensions
 *
 *  \note The extension names queried here must be enabled when calling
 *        VkCreateInstance, otherwise surface creation will fail.
 *
 *  \note \c window should have been created with the \c SDL_WINDOW_VULKAN flag.
 *
 *  \code
 *  unsigned int count;
 *  // get count of required extensions
 *  if(!SDL_Vulkan_GetInstanceExtensions(window, &count, NULL))
 *      handle_error();
 *
 *  static const char *const additionalExtensions[] =
 *  {
 *      VK_EXT_DEBUG_REPORT_EXTENSION_NAME, // example additional extension
 *  };
 *  size_t additionalExtensionsCount = sizeof(additionalExtensions) / sizeof(additionalExtensions[0]);
 *  size_t extensionCount = count + additionalExtensionsCount;
 *  const char **names = malloc(sizeof(const char *) * extensionCount);
 *  if(!names)
 *      handle_error();
 *
 *  // get names of required extensions
 *  if(!SDL_Vulkan_GetInstanceExtensions(window, &count, names))
 *      handle_error();
 *
 *  // copy additional extensions after required extensions
 *  for(size_t i = 0; i < additionalExtensionsCount; i++)
 *      names[i + count] = additionalExtensions[i];
 *
 *  VkInstanceCreateInfo instanceCreateInfo = {};
 *  instanceCreateInfo.enabledExtensionCount = extensionCount;
 *  instanceCreateInfo.ppEnabledExtensionNames = names;
 *  // fill in rest of instanceCreateInfo
 *
 *  VkInstance instance;
 *  // create the Vulkan instance
 *  VkResult result = vkCreateInstance(&instanceCreateInfo, NULL, &instance);
 *  free(names);
 *  \endcode
 *
 *  \sa SDL_Vulkan_CreateSurface()
*/
fn C.SDL_Vulkan_GetInstanceExtensions(window &C.SDL_Window, p_count &u32, p_names &&char) bool
pub fn vulkan_get_instance_extensions(window &Window, p_count &u32, p_names &&char) bool {
	return C.SDL_Vulkan_GetInstanceExtensions(window, p_count, p_names)
}

/**
 *  \brief Create a Vulkan rendering surface for a window.
 *
 *  \param [in]  window   SDL_Window to which to attach the rendering surface.
 *  \param [in]  instance handle to the Vulkan instance to use.
 *  \param [out] surface  pointer to a VkSurfaceKHR handle to receive the
 *                        handle of the newly created surface.
 *
 *  \return \c SDL_TRUE on success, \c SDL_FALSE on error.
 *
 *  \code
 *  VkInstance instance;
 *  SDL_Window *window;
 *
 *  // create instance and window
 *
 *  // create the Vulkan surface
 *  VkSurfaceKHR surface;
 *  if(!SDL_Vulkan_CreateSurface(window, instance, &surface))
 *      handle_error();
 *  \endcode
 *
 *  \note \a window should have been created with the \c SDL_WINDOW_VULKAN flag.
 *
 *  \note \a instance should have been created with the extensions returned
 *        by \c SDL_Vulkan_CreateSurface() enabled.
 *
 *  \sa SDL_Vulkan_GetInstanceExtensions()
*/
/*
TODO
fn C.SDL_Vulkan_CreateSurface(window &C.SDL_Window, instance C.VkInstance, surface &C.VkSurfaceKHR) bool
pub fn vulkan_create_surface(window &Window, instance C.VkInstance, surface &C.VkSurfaceKHR) bool{
	return C.SDL_Vulkan_CreateSurface(window, instance, surface)
}
*/

/**
 *  \brief Get the size of a window's underlying drawable in pixels (for use
 *         with setting viewport, scissor & etc).
 *
 *  \param window   SDL_Window from which the drawable size should be queried
 *  \param w        Pointer to variable for storing the width in pixels,
 *                  may be NULL
 *  \param h        Pointer to variable for storing the height in pixels,
 *                  may be NULL
 *
 * This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
 * drawable, i.e. the window was created with SDL_WINDOW_ALLOW_HIGHDPI on a
 * platform with high-DPI support (Apple calls this "Retina"), and not disabled
 * by the \c SDL_HINT_VIDEO_HIGHDPI_DISABLED hint.
 *
 *  \note On macOS high-DPI support must be enabled for an application by
 *        setting NSHighResolutionCapable to true in its Info.plist.
 *
 *  \sa SDL_GetWindowSize()
 *  \sa SDL_CreateWindow()
*/
fn C.SDL_Vulkan_GetDrawableSize(window &C.SDL_Window, w &int, h &int)
pub fn vulkan_get_drawable_size(window &Window, w &int, h &int) {
	C.SDL_Vulkan_GetDrawableSize(window, w, h)
}
