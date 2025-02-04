// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module vulkan

import sdl

//
// SDL_vulkan.h
//

// Functions for creating Vulkan surfaces on SDL windows.
//
// For the most part, Vulkan operates independent of SDL, but it benefits from
// a little support during setup.
//
// Use SDL_Vulkan_GetInstanceExtensions() to get platform-specific bits for
// creating a VkInstance, then SDL_Vulkan_GetVkGetInstanceProcAddr() to get
// the appropriate function for querying Vulkan entry points. Then
// SDL_Vulkan_CreateSurface() will get you the final pieces you need to
// prepare for rendering into an SDL_Window with Vulkan.
//
// Unlike OpenGL, most of the details of "context" creation and window buffer
// swapping are handled by the Vulkan API directly, so SDL doesn't provide
// Vulkan equivalents of SDL_GL_SwapWindow(), etc; they aren't necessary.

@[noinit; typedef]
pub struct C.VkInstance {}

pub type VkInstance = C.VkInstance

@[noinit; typedef]
pub struct C.VkSurfaceKHR {}

pub type VkSurfaceKHR = C.VkSurfaceKHR

@[noinit; typedef]
pub struct C.VkPhysicalDevice {}

pub type VkPhysicalDevice = C.VkPhysicalDevice

@[noinit; typedef]
pub struct C.VkAllocationCallbacks {}

pub type VkAllocationCallbacks = C.VkAllocationCallbacks

// TODO Non-numerical: #define NO_SDL_VULKAN_TYPEDEFS

// TODO Non-numerical: #define VK_DEFINE_HANDLE(object) typedef struct object##_T* object;

// TODO Non-numerical: #define VK_DEFINE_NON_DISPATCHABLE_HANDLE(object) typedef struct object##_T *object;

// TODO Non-numerical: #define VK_DEFINE_NON_DISPATCHABLE_HANDLE(object) typedef uint64_t object;

// C.SDL_Vulkan_LoadLibrary [official documentation](https://wiki.libsdl.org/SDL3/SDL_Vulkan_LoadLibrary)
fn C.SDL_Vulkan_LoadLibrary(const_path &char) bool

// vulkan_load_library dynamicallys load the Vulkan loader library.
//
// This should be called after initializing the video driver, but before
// creating any Vulkan windows. If no Vulkan loader library is loaded, the
// default library will be loaded upon creation of the first Vulkan window.
//
// SDL keeps a counter of how many times this function has been successfully
// called, so it is safe to call this function multiple times, so long as it
// is eventually paired with an equivalent number of calls to
// SDL_Vulkan_UnloadLibrary. The `path` argument is ignored unless there is no
// library currently loaded, and and the library isn't actually unloaded until
// there have been an equivalent number of calls to SDL_Vulkan_UnloadLibrary.
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
// `path` path the platform dependent Vulkan loader library name or NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: vulkan_get_vk_get_instance_proc_addr (SDL_Vulkan_GetVkGetInstanceProcAddr)
// See also: vulkan_unload_library (SDL_Vulkan_UnloadLibrary)
pub fn vulkan_load_library(const_path &char) bool {
	return C.SDL_Vulkan_LoadLibrary(const_path)
}

// C.SDL_Vulkan_GetVkGetInstanceProcAddr [official documentation](https://wiki.libsdl.org/SDL3/SDL_Vulkan_GetVkGetInstanceProcAddr)
fn C.SDL_Vulkan_GetVkGetInstanceProcAddr() sdl.FunctionPointer

// vulkan_get_vk_get_instance_proc_addr gets the address of the `vkGetInstanceProcAddr` function.
//
// This should be called after either calling SDL_Vulkan_LoadLibrary() or
// creating an SDL_Window with the `SDL_WINDOW_VULKAN` flag.
//
// The actual type of the returned function pointer is
// PFN_vkGetInstanceProcAddr, but that isn't available because the Vulkan
// headers are not included here. You should cast the return value of this
// function to that type, e.g.
//
// `vkGetInstanceProcAddr =
// (PFN_vkGetInstanceProcAddr)SDL_Vulkan_GetVkGetInstanceProcAddr();`
//
// returns the function pointer for `vkGetInstanceProcAddr` or NULL on
//          failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn vulkan_get_vk_get_instance_proc_addr() sdl.FunctionPointer {
	return C.SDL_Vulkan_GetVkGetInstanceProcAddr()
}

// C.SDL_Vulkan_UnloadLibrary [official documentation](https://wiki.libsdl.org/SDL3/SDL_Vulkan_UnloadLibrary)
fn C.SDL_Vulkan_UnloadLibrary()

// vulkan_unload_library unloads the Vulkan library previously loaded by SDL_Vulkan_LoadLibrary().
//
// SDL keeps a counter of how many times this function has been called, so it
// is safe to call this function multiple times, so long as it is paired with
// an equivalent number of calls to SDL_Vulkan_LoadLibrary. The library isn't
// actually unloaded until there have been an equivalent number of calls to
// SDL_Vulkan_UnloadLibrary.
//
// Once the library has actually been unloaded, if any Vulkan instances
// remain, they will likely crash the program. Clean up any existing Vulkan
// resources, and destroy appropriate windows, renderers and GPU devices
// before calling this function.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: vulkan_load_library (SDL_Vulkan_LoadLibrary)
pub fn vulkan_unload_library() {
	C.SDL_Vulkan_UnloadLibrary()
}

// C.SDL_Vulkan_GetInstanceExtensions [official documentation](https://wiki.libsdl.org/SDL3/SDL_Vulkan_GetInstanceExtensions)
fn C.SDL_Vulkan_GetInstanceExtensions(count &u32) &&char

// vulkan_get_instance_extensions gets the Vulkan instance extensions needed for vkCreateInstance.
//
// This should be called after either calling SDL_Vulkan_LoadLibrary() or
// creating an SDL_Window with the `SDL_WINDOW_VULKAN` flag.
//
// On return, the variable pointed to by `count` will be set to the number of
// elements returned, suitable for using with
// VkInstanceCreateInfo::enabledExtensionCount, and the returned array can be
// used with VkInstanceCreateInfo::ppEnabledExtensionNames, for calling
// Vulkan's vkCreateInstance API.
//
// You should not free the returned array; it is owned by SDL.
//
// `count` count a pointer filled in with the number of extensions returned.
// returns an array of extension name strings on success, NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: vulkan_create_surface (SDL_Vulkan_CreateSurface)
pub fn vulkan_get_instance_extensions(count &u32) &&char {
	return C.SDL_Vulkan_GetInstanceExtensions(count)
}

// C.SDL_Vulkan_CreateSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_Vulkan_CreateSurface)
fn C.SDL_Vulkan_CreateSurface(window &Window, instance VkInstance, const_allocator VkAllocationCallbacks, surface &VkSurfaceKHR) bool

// vulkan_create_surface creates a Vulkan rendering surface for a window.
//
// The `window` must have been created with the `SDL_WINDOW_VULKAN` flag and
// `instance` must have been created with extensions returned by
// SDL_Vulkan_GetInstanceExtensions() enabled.
//
// If `allocator` is NULL, Vulkan will use the system default allocator. This
// argument is passed directly to Vulkan and isn't used by SDL itself.
//
// `window` window the window to which to attach the Vulkan surface.
// `instance` instance the Vulkan instance handle.
// `allocator` allocator a VkAllocationCallbacks struct, which lets the app set the
//                  allocator that creates the surface. Can be NULL.
// `surface` surface a pointer to a VkSurfaceKHR handle to output the newly
//                created surface.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: vulkan_get_instance_extensions (SDL_Vulkan_GetInstanceExtensions)
// See also: vulkan_destroy_surface (SDL_Vulkan_DestroySurface)
pub fn vulkan_create_surface(window &Window, instance VkInstance, const_allocator VkAllocationCallbacks, surface &VkSurfaceKHR) bool {
	return C.SDL_Vulkan_CreateSurface(window, instance, const_allocator, surface)
}

// C.SDL_Vulkan_DestroySurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_Vulkan_DestroySurface)
fn C.SDL_Vulkan_DestroySurface(instance VkInstance, surface VkSurfaceKHR, const_allocator VkAllocationCallbacks)

// vulkan_destroy_surface destroys the Vulkan rendering surface of a window.
//
// This should be called before SDL_DestroyWindow, if SDL_Vulkan_CreateSurface
// was called after SDL_CreateWindow.
//
// The `instance` must have been created with extensions returned by
// SDL_Vulkan_GetInstanceExtensions() enabled and `surface` must have been
// created successfully by an SDL_Vulkan_CreateSurface() call.
//
// If `allocator` is NULL, Vulkan will use the system default allocator. This
// argument is passed directly to Vulkan and isn't used by SDL itself.
//
// `instance` instance the Vulkan instance handle.
// `surface` surface vkSurfaceKHR handle to destroy.
// `allocator` allocator a VkAllocationCallbacks struct, which lets the app set the
//                  allocator that destroys the surface. Can be NULL.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: vulkan_get_instance_extensions (SDL_Vulkan_GetInstanceExtensions)
// See also: vulkan_create_surface (SDL_Vulkan_CreateSurface)
pub fn vulkan_destroy_surface(instance VkInstance, surface VkSurfaceKHR, const_allocator VkAllocationCallbacks) {
	C.SDL_Vulkan_DestroySurface(instance, surface, const_allocator)
}

// C.SDL_Vulkan_GetPresentationSupport [official documentation](https://wiki.libsdl.org/SDL3/SDL_Vulkan_GetPresentationSupport)
fn C.SDL_Vulkan_GetPresentationSupport(instance VkInstance, physical_device VkPhysicalDevice, queue_family_index u32) bool

// vulkan_get_presentation_support querys support for presentation via a given physical device and queue
// family.
//
// The `instance` must have been created with extensions returned by
// SDL_Vulkan_GetInstanceExtensions() enabled.
//
// `instance` instance the Vulkan instance handle.
// `physical_device` physicalDevice a valid Vulkan physical device handle.
// `queue_family_index` queueFamilyIndex a valid queue family index for the given physical
//                         device.
// returns true if supported, false if unsupported or an error occurred.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: vulkan_get_instance_extensions (SDL_Vulkan_GetInstanceExtensions)
pub fn vulkan_get_presentation_support(instance VkInstance, physical_device VkPhysicalDevice, queue_family_index u32) bool {
	return C.SDL_Vulkan_GetPresentationSupport(instance, physical_device, queue_family_index)
}
