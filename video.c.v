// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_video.h
//

// SDL's video subsystem is largely interested in abstracting window
// management from the underlying operating system. You can create windows,
// manage them in various ways, set them fullscreen, and get events when
// interesting things happen with them, such as the mouse or keyboard
// interacting with a window.
//
// The video subsystem is also interested in abstracting away some
// platform-specific differences in OpenGL: context creation, swapping
// buffers, etc. This may be crucial to your app, but also you are not
// required to use OpenGL at all. In fact, SDL can provide rendering to those
// windows as well, either with an easy-to-use
// [2D API](https://wiki.libsdl.org/SDL3/CategoryRender)
// or with a more-powerful
// [GPU API](https://wiki.libsdl.org/SDL3/CategoryGPU)
// . Of course, it can simply get out of your way and give you the window
// handles you need to use Vulkan, Direct3D, Metal, or whatever else you like
// directly, too.
//
// The video subsystem covers a lot of functionality, out of necessity, so it
// is worth perusing the list of functions just to see what's available, but
// most apps can get by with simply creating a window and listening for
// events, so start with SDL_CreateWindow() and SDL_PollEvent().

// This is a unique ID for a display for the time it is connected to the
// system, and is never reused for the lifetime of the application.
//
// If the display is disconnected and reconnected, it will get a new ID.
//
// The value 0 is an invalid ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type DisplayID = u32

// This is a unique ID for a window.
//
// The value 0 is an invalid ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type WindowID = u32

// The flags on a window.
//
// These cover a lot of true/false, or on/off, window state. Some of it is
// immutable after being set through SDL_CreateWindow(), some of it can be
// changed on existing windows by the app, and some of it might be altered by
// the user or system outside of the app's control.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: get_window_flags (SDL_GetWindowFlags)
pub type WindowFlags = u64

// Opaque type for an EGL display.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type EGLDisplay = voidptr

// Opaque type for an EGL config.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type EGLConfig = voidptr

// Opaque type for an EGL surface.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type EGLSurface = voidptr

// An EGL attribute, used when creating an EGL context.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type EGLAttrib = voidptr

// An EGL integer attribute, used when creating an EGL surface.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type EgLint = int

// Possible values to be set for the SDL_GL_CONTEXT_PROFILE_MASK attribute.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type GlProfile = u32

// Opaque type for an GL context.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type GLContext = voidptr

// Possible flags to be set for the SDL_GL_CONTEXT_FLAGS attribute.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type GLContextFlag = u32

// Possible values to be set for the SDL_GL_CONTEXT_RELEASE_BEHAVIOR
// attribute.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type GLContextReleaseFlag = u32

// Possible values to be set SDL_GL_CONTEXT_RESET_NOTIFICATION attribute.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type GLContextResetNotification = u32

// The pointer to the global `wl_display` object used by the Wayland video
// backend.
//
// Can be set before the video subsystem is initialized to import an external
// `wl_display` object from an application or toolkit for use in SDL, or read
// after initialization to export the `wl_display` used by the Wayland video
// backend. Setting this property after the video subsystem has been
// initialized has no effect, and reading it when the video subsystem is
// uninitialized will either return the user provided value, if one was set
// prior to initialization, or NULL. See docs/README-wayland.md for more
// information.
pub const prop_global_video_wayland_wl_display_pointer = &char(C.SDL_PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER) // 'SDL.video.wayland.wl_display'

// SystemTheme is C.SDL_SystemTheme
pub enum SystemTheme {
	unknown = C.SDL_SYSTEM_THEME_UNKNOWN // `unknown` Unknown system theme
	light   = C.SDL_SYSTEM_THEME_LIGHT   // `light` Light colored system theme
	dark    = C.SDL_SYSTEM_THEME_DARK    // `dark` Dark colored system theme
}

@[noinit; typedef]
pub struct C.SDL_DisplayModeData {
	// NOTE: Opaque type
}

pub type DisplayModeData = C.SDL_DisplayModeData

@[typedef]
pub struct C.SDL_DisplayMode {
pub mut:
	displayID                DisplayID   // the display this mode is associated with
	format                   PixelFormat // pixel format
	w                        int         // width
	h                        int         // height
	pixel_density            f32         // scale converting size to pixels (e.g. a 1920x1080 mode with 2.0 scale would have 3840x2160 pixels)
	refresh_rate             f32         // refresh rate (or 0.0f for unspecified)
	refresh_rate_numerator   int         // precise refresh rate numerator (or 0 for unspecified)
	refresh_rate_denominator int         // precise refresh rate denominator
	internal                 &DisplayModeData = unsafe { nil } // Private
}

pub type DisplayMode = C.SDL_DisplayMode

// DisplayOrientation is C.SDL_DisplayOrientation
pub enum DisplayOrientation {
	unknown           = C.SDL_ORIENTATION_UNKNOWN           // `unknown` The display orientation can't be determined
	landscape         = C.SDL_ORIENTATION_LANDSCAPE         // `landscape` The display is in landscape mode, with the right side up, relative to portrait mode
	landscape_flipped = C.SDL_ORIENTATION_LANDSCAPE_FLIPPED // `landscape_flipped` The display is in landscape mode, with the left side up, relative to portrait mode
	portrait          = C.SDL_ORIENTATION_PORTRAIT          // `portrait` The display is in portrait mode
	portrait_flipped  = C.SDL_ORIENTATION_PORTRAIT_FLIPPED  // `portrait_flipped` The display is in portrait mode, upside down
}

@[noinit; typedef]
pub struct C.SDL_Window {
	// NOTE: Opaque type
}

pub type Window = C.SDL_Window

// WindowFlags are defined here

pub const window_fullscreen = u64(C.SDL_WINDOW_FULLSCREEN) // SDL_UINT64_C(0x0000000000000001)

pub const window_opengl = u64(C.SDL_WINDOW_OPENGL) // SDL_UINT64_C(0x0000000000000002)

pub const window_occluded = u64(C.SDL_WINDOW_OCCLUDED) // SDL_UINT64_C(0x0000000000000004)

pub const window_hidden = u64(C.SDL_WINDOW_HIDDEN) // SDL_UINT64_C(0x0000000000000008)

pub const window_borderless = u64(C.SDL_WINDOW_BORDERLESS) // SDL_UINT64_C(0x0000000000000010)

pub const window_resizable = u64(C.SDL_WINDOW_RESIZABLE) // SDL_UINT64_C(0x0000000000000020)

pub const window_minimized = u64(C.SDL_WINDOW_MINIMIZED) // SDL_UINT64_C(0x0000000000000040)

pub const window_maximized = u64(C.SDL_WINDOW_MAXIMIZED) // SDL_UINT64_C(0x0000000000000080)

pub const window_mouse_grabbed = u64(C.SDL_WINDOW_MOUSE_GRABBED) // SDL_UINT64_C(0x0000000000000100)

pub const window_input_focus = u64(C.SDL_WINDOW_INPUT_FOCUS) // SDL_UINT64_C(0x0000000000000200)

pub const window_mouse_focus = u64(C.SDL_WINDOW_MOUSE_FOCUS) // SDL_UINT64_C(0x0000000000000400)

pub const window_external = u64(C.SDL_WINDOW_EXTERNAL) // SDL_UINT64_C(0x0000000000000800)

pub const window_modal = u64(C.SDL_WINDOW_MODAL) // SDL_UINT64_C(0x0000000000001000)

pub const window_high_pixel_density = u64(C.SDL_WINDOW_HIGH_PIXEL_DENSITY) // SDL_UINT64_C(0x0000000000002000)

pub const window_mouse_capture = u64(C.SDL_WINDOW_MOUSE_CAPTURE) // SDL_UINT64_C(0x0000000000004000)

pub const window_mouse_relative_mode = u64(C.SDL_WINDOW_MOUSE_RELATIVE_MODE) // SDL_UINT64_C(0x0000000000008000)

pub const window_always_on_top = u64(C.SDL_WINDOW_ALWAYS_ON_TOP) // SDL_UINT64_C(0x0000000000010000)

pub const window_utility = u64(C.SDL_WINDOW_UTILITY) // SDL_UINT64_C(0x0000000000020000)

pub const window_tooltip = u64(C.SDL_WINDOW_TOOLTIP) // SDL_UINT64_C(0x0000000000040000)

pub const window_popup_menu = u64(C.SDL_WINDOW_POPUP_MENU) // SDL_UINT64_C(0x0000000000080000)

pub const window_keyboard_grabbed = u64(C.SDL_WINDOW_KEYBOARD_GRABBED) // SDL_UINT64_C(0x0000000000100000)

pub const window_vulkan = u64(C.SDL_WINDOW_VULKAN) // SDL_UINT64_C(0x0000000010000000)

pub const window_metal = u64(C.SDL_WINDOW_METAL) // SDL_UINT64_C(0x0000000020000000)

pub const window_transparent = u64(C.SDL_WINDOW_TRANSPARENT) // SDL_UINT64_C(0x0000000040000000)

pub const window_not_focusable = u64(C.SDL_WINDOW_NOT_FOCUSABLE) // SDL_UINT64_C(0x0000000080000000)

pub const windowpos_undefined_mask = C.SDL_WINDOWPOS_UNDEFINED_MASK // 0x1FFF0000u

// TODO: Function: #define SDL_WINDOWPOS_UNDEFINED_DISPLAY(X)  (SDL_WINDOWPOS_UNDEFINED_MASK|(X))

pub const windowpos_undefined = C.SDL_WINDOWPOS_UNDEFINED // SDL_WINDOWPOS_UNDEFINED_DISPLAY(0)

// TODO: Function: #define SDL_WINDOWPOS_ISUNDEFINED(X)    (((X)&0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK)

pub const windowpos_centered_mask = C.SDL_WINDOWPOS_CENTERED_MASK // 0x2FFF0000u

// TODO: Function: #define SDL_WINDOWPOS_CENTERED_DISPLAY(X)  (SDL_WINDOWPOS_CENTERED_MASK|(X))

pub const windowpos_centered = C.SDL_WINDOWPOS_CENTERED // SDL_WINDOWPOS_CENTERED_DISPLAY(0)

// TODO: Non-numerical: #define SDL_WINDOWPOS_ISCENTERED(X)    \

// FlashOperation is C.SDL_FlashOperation
pub enum FlashOperation {
	cancel        = C.SDL_FLASH_CANCEL        // `cancel` Cancel any window flash state
	briefly       = C.SDL_FLASH_BRIEFLY       // `briefly` Flash the window briefly to get attention
	until_focused = C.SDL_FLASH_UNTIL_FOCUSED // `until_focused` Flash the window until it gets focus
}

// EGLAttribArrayCallback egls platform attribute initialization callback.
//
// This is called when SDL is attempting to create an EGL context, to let the
// app add extra attributes to its eglGetPlatformDisplay() call.
//
// The callback should return a pointer to an EGL attribute array terminated
// with `EGL_NONE`. If this function returns NULL, the SDL_CreateWindow
// process will fail gracefully.
//
// The returned pointer should be allocated with SDL_malloc() and will be
// passed to SDL_free().
//
// The arrays returned by each callback will be appended to the existing
// attribute arrays defined by SDL.
//
// `userdata` userdata an app-controlled pointer that is passed to the callback.
// returns a newly-allocated array of attributes, terminated with `EGL_NONE`.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: egl_set_attribute_callbacks (SDL_EGL_SetAttributeCallbacks)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_EGLAttribArrayCallback)
pub type EGLAttribArrayCallback = fn (userdata voidptr) EGLAttrib

// EGLIntArrayCallback egls surface/context attribute initialization callback types.
//
// This is called when SDL is attempting to create an EGL surface, to let the
// app add extra attributes to its eglCreateWindowSurface() or
// eglCreateContext calls.
//
// For convenience, the EGLDisplay and EGLConfig to use are provided to the
// callback.
//
// The callback should return a pointer to an EGL attribute array terminated
// with `EGL_NONE`. If this function returns NULL, the SDL_CreateWindow
// process will fail gracefully.
//
// The returned pointer should be allocated with SDL_malloc() and will be
// passed to SDL_free().
//
// The arrays returned by each callback will be appended to the existing
// attribute arrays defined by SDL.
//
// `userdata` userdata an app-controlled pointer that is passed to the callback.
// `display` display the EGL display to be used.
// `config` config the EGL config to be used.
// returns a newly-allocated array of attributes, terminated with `EGL_NONE`.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: egl_set_attribute_callbacks (SDL_EGL_SetAttributeCallbacks)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_EGLIntArrayCallback)
pub type EGLIntArrayCallback = fn (userdata voidptr, display EGLDisplay, config EGLConfig) &int

// GLAttr is C.SDL_GLAttr
pub enum GLAttr {
	red_size                   = C.SDL_GL_RED_SIZE                   // `red_size` the minimum number of bits for the red channel of the color buffer; defaults to 3.
	green_size                 = C.SDL_GL_GREEN_SIZE                 // `green_size` the minimum number of bits for the green channel of the color buffer; defaults to 3.
	blue_size                  = C.SDL_GL_BLUE_SIZE                  // `blue_size` the minimum number of bits for the blue channel of the color buffer; defaults to 2.
	alpha_size                 = C.SDL_GL_ALPHA_SIZE                 // `alpha_size` the minimum number of bits for the alpha channel of the color buffer; defaults to 0.
	buffer_size                = C.SDL_GL_BUFFER_SIZE                // `buffer_size` the minimum number of bits for frame buffer size; defaults to 0.
	doublebuffer               = C.SDL_GL_DOUBLEBUFFER               // `doublebuffer` whether the output is single or double buffered; defaults to double buffering on.
	depth_size                 = C.SDL_GL_DEPTH_SIZE                 // `depth_size` the minimum number of bits in the depth buffer; defaults to 16.
	stencil_size               = C.SDL_GL_STENCIL_SIZE               // `stencil_size` the minimum number of bits in the stencil buffer; defaults to 0.
	accum_red_size             = C.SDL_GL_ACCUM_RED_SIZE             // `accum_red_size` the minimum number of bits for the red channel of the accumulation buffer; defaults to 0.
	accum_green_size           = C.SDL_GL_ACCUM_GREEN_SIZE           // `accum_green_size` the minimum number of bits for the green channel of the accumulation buffer; defaults to 0.
	accum_blue_size            = C.SDL_GL_ACCUM_BLUE_SIZE            // `accum_blue_size` the minimum number of bits for the blue channel of the accumulation buffer; defaults to 0.
	accum_alpha_size           = C.SDL_GL_ACCUM_ALPHA_SIZE           // `accum_alpha_size` the minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0.
	stereo                     = C.SDL_GL_STEREO                     // `stereo` whether the output is stereo 3D; defaults to off.
	multisamplebuffers         = C.SDL_GL_MULTISAMPLEBUFFERS         // `multisamplebuffers` the number of buffers used for multisample anti-aliasing; defaults to 0.
	multisamplesamples         = C.SDL_GL_MULTISAMPLESAMPLES         // `multisamplesamples` the number of samples used around the current pixel used for multisample anti-aliasing.
	accelerated_visual         = C.SDL_GL_ACCELERATED_VISUAL         // `accelerated_visual` set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either.
	retained_backing           = C.SDL_GL_RETAINED_BACKING           // `retained_backing` not used (deprecated).
	context_major_version      = C.SDL_GL_CONTEXT_MAJOR_VERSION      // `context_major_version` OpenGL context major version.
	context_minor_version      = C.SDL_GL_CONTEXT_MINOR_VERSION      // `context_minor_version` OpenGL context minor version.
	context_flags              = C.SDL_GL_CONTEXT_FLAGS              // `context_flags` some combination of 0 or more of elements of the SDL_GLContextFlag enumeration; defaults to 0.
	context_profile_mask       = C.SDL_GL_CONTEXT_PROFILE_MASK       // `context_profile_mask` type of GL context (Core, Compatibility, ES). See SDL_GLProfile; default value depends on platform.
	share_with_current_context = C.SDL_GL_SHARE_WITH_CURRENT_CONTEXT // `share_with_current_context` OpenGL context sharing; defaults to 0.
	framebuffer_srgb_capable   = C.SDL_GL_FRAMEBUFFER_SRGB_CAPABLE   // `framebuffer_srgb_capable` requests sRGB capable visual; defaults to 0.
	context_release_behavior   = C.SDL_GL_CONTEXT_RELEASE_BEHAVIOR   // `context_release_behavior` sets context the release behavior. See SDL_GLContextReleaseFlag; defaults to FLUSH.
	context_reset_notification = C.SDL_GL_CONTEXT_RESET_NOTIFICATION // `context_reset_notification` set context reset notification. See SDL_GLContextResetNotification; defaults to NO_NOTIFICATION.
	context_no_error           = C.SDL_GL_CONTEXT_NO_ERROR
	floatbuffers               = C.SDL_GL_FLOATBUFFERS
	egl_platform               = C.SDL_GL_EGL_PLATFORM
}

// < OpenGL Core Profile context
pub const gl_context_profile_core = C.SDL_GL_CONTEXT_PROFILE_CORE // 0x0001

// < OpenGL Compatibility Profile context
pub const gl_context_profile_compatibility = C.SDL_GL_CONTEXT_PROFILE_COMPATIBILITY // 0x0002

// < GLX_CONTEXT_ES2_PROFILE_BIT_EXT
pub const gl_context_profile_es = C.SDL_GL_CONTEXT_PROFILE_ES // 0x0004

pub const gl_context_debug_flag = C.SDL_GL_CONTEXT_DEBUG_FLAG // 0x0001

pub const gl_context_forward_compatible_flag = C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG // 0x0002

pub const gl_context_robust_access_flag = C.SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG // 0x0004

pub const gl_context_reset_isolation_flag = C.SDL_GL_CONTEXT_RESET_ISOLATION_FLAG // 0x0008

pub const gl_context_release_behavior_none = C.SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE // 0x0000

pub const gl_context_release_behavior_flush = C.SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH // 0x0001

pub const gl_context_reset_no_notification = C.SDL_GL_CONTEXT_RESET_NO_NOTIFICATION // 0x0000

pub const gl_context_reset_lose_context = C.SDL_GL_CONTEXT_RESET_LOSE_CONTEXT // 0x0001

// C.SDL_GetNumVideoDrivers [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumVideoDrivers)
fn C.SDL_GetNumVideoDrivers() int

// get_num_video_drivers gets the number of video drivers compiled into SDL.
//
// returns the number of built in video drivers.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_video_driver (SDL_GetVideoDriver)
pub fn get_num_video_drivers() int {
	return C.SDL_GetNumVideoDrivers()
}

// C.SDL_GetVideoDriver [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetVideoDriver)
fn C.SDL_GetVideoDriver(index int) &char

// get_video_driver gets the name of a built in video driver.
//
// The video drivers are presented in the order in which they are normally
// checked during initialization.
//
// The names of drivers are all simple, low-ASCII identifiers, like "cocoa",
// "x11" or "windows". These never have Unicode characters, and are not meant
// to be proper names.
//
// `index` index the index of a video driver.
// returns the name of the video driver with the given **index**.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_video_drivers (SDL_GetNumVideoDrivers)
pub fn get_video_driver(index int) &char {
	return &char(C.SDL_GetVideoDriver(index))
}

// C.SDL_GetCurrentVideoDriver [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCurrentVideoDriver)
fn C.SDL_GetCurrentVideoDriver() &char

// get_current_video_driver gets the name of the currently initialized video driver.
//
// The names of drivers are all simple, low-ASCII identifiers, like "cocoa",
// "x11" or "windows". These never have Unicode characters, and are not meant
// to be proper names.
//
// returns the name of the current video driver or NULL if no driver has been
//          initialized.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_num_video_drivers (SDL_GetNumVideoDrivers)
// See also: get_video_driver (SDL_GetVideoDriver)
pub fn get_current_video_driver() &char {
	return &char(C.SDL_GetCurrentVideoDriver())
}

// C.SDL_GetSystemTheme [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSystemTheme)
fn C.SDL_GetSystemTheme() SystemTheme

// get_system_theme gets the current system theme.
//
// returns the current system theme, light, dark, or unknown.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_system_theme() SystemTheme {
	return C.SDL_GetSystemTheme()
}

// C.SDL_GetDisplays [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDisplays)
fn C.SDL_GetDisplays(count &int) &DisplayID

// get_displays gets a list of currently connected displays.
//
// `count` count a pointer filled in with the number of displays returned, may
//              be NULL.
// returns a 0 terminated array of display instance IDs or NULL on failure;
//          call SDL_GetError() for more information. This should be freed
//          with SDL_free() when it is no longer needed.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_displays(count &int) &DisplayID {
	return C.SDL_GetDisplays(count)
}

// C.SDL_GetPrimaryDisplay [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPrimaryDisplay)
fn C.SDL_GetPrimaryDisplay() DisplayID

// get_primary_display returns the primary display.
//
// returns the instance ID of the primary display on success or 0 on failure;
//          call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_displays (SDL_GetDisplays)
pub fn get_primary_display() DisplayID {
	return C.SDL_GetPrimaryDisplay()
}

// C.SDL_GetDisplayProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDisplayProperties)
fn C.SDL_GetDisplayProperties(display_id DisplayID) PropertiesID

// get_display_properties gets the properties associated with a display.
//
// The following read-only properties are provided by SDL:
//
// - `SDL_PROP_DISPLAY_HDR_ENABLED_BOOLEAN`: true if the display has HDR
//   headroom above the SDR white point. This is for informational and
//   diagnostic purposes only, as not all platforms provide this information
//   at the display level.
//
// On KMS/DRM:
//
// - `SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER`: the "panel
//   orientation" property for the display in degrees of clockwise rotation.
//   Note that this is provided only as a hint, and the application is
//   responsible for any coordinate transformations needed to conform to the
//   requested display orientation.
//
// `display_id` displayID the instance ID of the display to query.
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_display_properties(display_id DisplayID) PropertiesID {
	return C.SDL_GetDisplayProperties(display_id)
}

pub const prop_display_hdr_enabled_boolean = &char(C.SDL_PROP_DISPLAY_HDR_ENABLED_BOOLEAN) // 'SDL.display.HDR_enabled'

pub const prop_display_kmsdrm_panel_orientation_number = &char(C.SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER) // 'SDL.display.KMSDRM.panel_orientation'

// C.SDL_GetDisplayName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDisplayName)
fn C.SDL_GetDisplayName(display_id DisplayID) &char

// get_display_name gets the name of a display in UTF-8 encoding.
//
// `display_id` displayID the instance ID of the display to query.
// returns the name of a display or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_displays (SDL_GetDisplays)
pub fn get_display_name(display_id DisplayID) &char {
	return &char(C.SDL_GetDisplayName(display_id))
}

// C.SDL_GetDisplayBounds [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDisplayBounds)
fn C.SDL_GetDisplayBounds(display_id DisplayID, rect &Rect) bool

// get_display_bounds gets the desktop area represented by a display.
//
// The primary display is often located at (0,0), but may be placed at a
// different location depending on monitor layout.
//
// `display_id` displayID the instance ID of the display to query.
// `rect` rect the SDL_Rect structure filled in with the display bounds.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_display_usable_bounds (SDL_GetDisplayUsableBounds)
// See also: get_displays (SDL_GetDisplays)
pub fn get_display_bounds(display_id DisplayID, rect &Rect) bool {
	return C.SDL_GetDisplayBounds(display_id, rect)
}

// C.SDL_GetDisplayUsableBounds [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDisplayUsableBounds)
fn C.SDL_GetDisplayUsableBounds(display_id DisplayID, rect &Rect) bool

// get_display_usable_bounds gets the usable desktop area represented by a display, in screen
// coordinates.
//
// This is the same area as SDL_GetDisplayBounds() reports, but with portions
// reserved by the system removed. For example, on Apple's macOS, this
// subtracts the area occupied by the menu bar and dock.
//
// Setting a window to be fullscreen generally bypasses these unusable areas,
// so these are good guidelines for the maximum space available to a
// non-fullscreen window.
//
// `display_id` displayID the instance ID of the display to query.
// `rect` rect the SDL_Rect structure filled in with the display bounds.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_display_bounds (SDL_GetDisplayBounds)
// See also: get_displays (SDL_GetDisplays)
pub fn get_display_usable_bounds(display_id DisplayID, rect &Rect) bool {
	return C.SDL_GetDisplayUsableBounds(display_id, rect)
}

// C.SDL_GetNaturalDisplayOrientation [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNaturalDisplayOrientation)
fn C.SDL_GetNaturalDisplayOrientation(display_id DisplayID) DisplayOrientation

// get_natural_display_orientation gets the orientation of a display when it is unrotated.
//
// `display_id` displayID the instance ID of the display to query.
// returns the SDL_DisplayOrientation enum value of the display, or
//          `SDL_ORIENTATION_UNKNOWN` if it isn't available.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_displays (SDL_GetDisplays)
pub fn get_natural_display_orientation(display_id DisplayID) DisplayOrientation {
	return C.SDL_GetNaturalDisplayOrientation(display_id)
}

// C.SDL_GetCurrentDisplayOrientation [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCurrentDisplayOrientation)
fn C.SDL_GetCurrentDisplayOrientation(display_id DisplayID) DisplayOrientation

// get_current_display_orientation gets the orientation of a display.
//
// `display_id` displayID the instance ID of the display to query.
// returns the SDL_DisplayOrientation enum value of the display, or
//          `SDL_ORIENTATION_UNKNOWN` if it isn't available.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_displays (SDL_GetDisplays)
pub fn get_current_display_orientation(display_id DisplayID) DisplayOrientation {
	return C.SDL_GetCurrentDisplayOrientation(display_id)
}

// C.SDL_GetDisplayContentScale [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDisplayContentScale)
fn C.SDL_GetDisplayContentScale(display_id DisplayID) f32

// get_display_content_scale gets the content scale of a display.
//
// The content scale is the expected scale for content based on the DPI
// settings of the display. For example, a 4K display might have a 2.0 (200%)
// display scale, which means that the user expects UI elements to be twice as
// big on this display, to aid in readability.
//
// After window creation, SDL_GetWindowDisplayScale() should be used to query
// the content scale factor for individual windows instead of querying the
// display for a window and calling this function, as the per-window content
// scale factor may differ from the base value of the display it is on,
// particularly on high-DPI and/or multi-monitor desktop configurations.
//
// `display_id` displayID the instance ID of the display to query.
// returns the content scale of the display, or 0.0f on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_display_scale (SDL_GetWindowDisplayScale)
// See also: get_displays (SDL_GetDisplays)
pub fn get_display_content_scale(display_id DisplayID) f32 {
	return C.SDL_GetDisplayContentScale(display_id)
}

// C.SDL_GetFullscreenDisplayModes [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetFullscreenDisplayModes)
fn C.SDL_GetFullscreenDisplayModes(display_id DisplayID, count &int) &&C.SDL_DisplayMode

// get_fullscreen_display_modes gets a list of fullscreen display modes available on a display.
//
// The display modes are sorted in this priority:
//
// - w -> largest to smallest
// - h -> largest to smallest
// - bits per pixel -> more colors to fewer colors
// - packed pixel layout -> largest to smallest
// - refresh rate -> highest to lowest
// - pixel density -> lowest to highest
//
// `display_id` displayID the instance ID of the display to query.
// `count` count a pointer filled in with the number of display modes returned,
//              may be NULL.
// returns a NULL terminated array of display mode pointers or NULL on
//          failure; call SDL_GetError() for more information. This is a
//          single allocation that should be freed with SDL_free() when it is
//          no longer needed.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_displays (SDL_GetDisplays)
pub fn get_fullscreen_display_modes(display_id DisplayID, count &int) &&C.SDL_DisplayMode {
	return C.SDL_GetFullscreenDisplayModes(display_id, count)
}

// C.SDL_GetClosestFullscreenDisplayMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetClosestFullscreenDisplayMode)
fn C.SDL_GetClosestFullscreenDisplayMode(display_id DisplayID, w int, h int, refresh_rate f32, include_high_density_modes bool, closest &DisplayMode) bool

// get_closest_fullscreen_display_mode gets the closest match to the requested display mode.
//
// The available display modes are scanned and `closest` is filled in with the
// closest mode matching the requested mode and returned. The mode format and
// refresh rate default to the desktop mode if they are set to 0. The modes
// are scanned with size being first priority, format being second priority,
// and finally checking the refresh rate. If all the available modes are too
// small, then false is returned.
//
// `display_id` displayID the instance ID of the display to query.
// `w` w the width in pixels of the desired display mode.
// `h` h the height in pixels of the desired display mode.
// `refresh_rate` refresh_rate the refresh rate of the desired display mode, or 0.0f
//                     for the desktop refresh rate.
// `include_high_density_modes` include_high_density_modes boolean to include high density modes in
//                                   the search.
// `closest` closest a pointer filled in with the closest display mode equal to
//                or larger than the desired mode.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_displays (SDL_GetDisplays)
// See also: get_fullscreen_display_modes (SDL_GetFullscreenDisplayModes)
pub fn get_closest_fullscreen_display_mode(display_id DisplayID, w int, h int, refresh_rate f32, include_high_density_modes bool, closest &DisplayMode) bool {
	return C.SDL_GetClosestFullscreenDisplayMode(display_id, w, h, refresh_rate, include_high_density_modes,
		closest)
}

// C.SDL_GetDesktopDisplayMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDesktopDisplayMode)
fn C.SDL_GetDesktopDisplayMode(display_id DisplayID) &DisplayMode

// get_desktop_display_mode gets information about the desktop's display mode.
//
// There's a difference between this function and SDL_GetCurrentDisplayMode()
// when SDL runs fullscreen and has changed the resolution. In that case this
// function will return the previous native display mode, and not the current
// display mode.
//
// `display_id` displayID the instance ID of the display to query.
// returns a pointer to the desktop display mode or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_current_display_mode (SDL_GetCurrentDisplayMode)
// See also: get_displays (SDL_GetDisplays)
pub fn get_desktop_display_mode(display_id DisplayID) &DisplayMode {
	return C.SDL_GetDesktopDisplayMode(display_id)
}

// C.SDL_GetCurrentDisplayMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCurrentDisplayMode)
fn C.SDL_GetCurrentDisplayMode(display_id DisplayID) &DisplayMode

// get_current_display_mode gets information about the current display mode.
//
// There's a difference between this function and SDL_GetDesktopDisplayMode()
// when SDL runs fullscreen and has changed the resolution. In that case this
// function will return the current display mode, and not the previous native
// display mode.
//
// `display_id` displayID the instance ID of the display to query.
// returns a pointer to the desktop display mode or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_desktop_display_mode (SDL_GetDesktopDisplayMode)
// See also: get_displays (SDL_GetDisplays)
pub fn get_current_display_mode(display_id DisplayID) &DisplayMode {
	return C.SDL_GetCurrentDisplayMode(display_id)
}

// C.SDL_GetDisplayForPoint [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDisplayForPoint)
fn C.SDL_GetDisplayForPoint(const_point &Point) DisplayID

// get_display_for_point gets the display containing a point.
//
// `point` point the point to query.
// returns the instance ID of the display containing the point or 0 on
//          failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_display_bounds (SDL_GetDisplayBounds)
// See also: get_displays (SDL_GetDisplays)
pub fn get_display_for_point(const_point &Point) DisplayID {
	return C.SDL_GetDisplayForPoint(const_point)
}

// C.SDL_GetDisplayForRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDisplayForRect)
fn C.SDL_GetDisplayForRect(const_rect &Rect) DisplayID

// get_display_for_rect gets the display primarily containing a rect.
//
// `rect` rect the rect to query.
// returns the instance ID of the display entirely containing the rect or
//          closest to the center of the rect on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_display_bounds (SDL_GetDisplayBounds)
// See also: get_displays (SDL_GetDisplays)
pub fn get_display_for_rect(const_rect &Rect) DisplayID {
	return C.SDL_GetDisplayForRect(const_rect)
}

// C.SDL_GetDisplayForWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDisplayForWindow)
fn C.SDL_GetDisplayForWindow(window &Window) DisplayID

// get_display_for_window gets the display associated with a window.
//
// `window` window the window to query.
// returns the instance ID of the display containing the center of the window
//          on success or 0 on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_display_bounds (SDL_GetDisplayBounds)
// See also: get_displays (SDL_GetDisplays)
pub fn get_display_for_window(window &Window) DisplayID {
	return C.SDL_GetDisplayForWindow(window)
}

// C.SDL_GetWindowPixelDensity [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowPixelDensity)
fn C.SDL_GetWindowPixelDensity(window &Window) f32

// get_window_pixel_density gets the pixel density of a window.
//
// This is a ratio of pixel size to window size. For example, if the window is
// 1920x1080 and it has a high density back buffer of 3840x2160 pixels, it
// would have a pixel density of 2.0.
//
// `window` window the window to query.
// returns the pixel density or 0.0f on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_display_scale (SDL_GetWindowDisplayScale)
pub fn get_window_pixel_density(window &Window) f32 {
	return C.SDL_GetWindowPixelDensity(window)
}

// C.SDL_GetWindowDisplayScale [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowDisplayScale)
fn C.SDL_GetWindowDisplayScale(window &Window) f32

// get_window_display_scale gets the content display scale relative to a window's pixel size.
//
// This is a combination of the window pixel density and the display content
// scale, and is the expected scale for displaying content in this window. For
// example, if a 3840x2160 window had a display scale of 2.0, the user expects
// the content to take twice as many pixels and be the same physical size as
// if it were being displayed in a 1920x1080 window with a display scale of
// 1.0.
//
// Conceptually this value corresponds to the scale display setting, and is
// updated when that setting is changed, or the window moves to a display with
// a different scale setting.
//
// `window` window the window to query.
// returns the display scale, or 0.0f on failure; call SDL_GetError() for
//          more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_window_display_scale(window &Window) f32 {
	return C.SDL_GetWindowDisplayScale(window)
}

// C.SDL_SetWindowFullscreenMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowFullscreenMode)
fn C.SDL_SetWindowFullscreenMode(window &Window, const_mode &DisplayMode) bool

// set_window_fullscreen_mode sets the display mode to use when a window is visible and fullscreen.
//
// This only affects the display mode used when the window is fullscreen. To
// change the window size when the window is not fullscreen, use
// SDL_SetWindowSize().
//
// If the window is currently in the fullscreen state, this request is
// asynchronous on some windowing systems and the new mode dimensions may not
// be applied immediately upon the return of this function. If an immediate
// change is required, call SDL_SyncWindow() to block until the changes have
// taken effect.
//
// When the new mode takes effect, an SDL_EVENT_WINDOW_RESIZED and/or an
// SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED event will be emitted with the new mode
// dimensions.
//
// `window` window the window to affect.
// `mode` mode a pointer to the display mode to use, which can be NULL for
//             borderless fullscreen desktop mode, or one of the fullscreen
//             modes returned by SDL_GetFullscreenDisplayModes() to set an
//             exclusive fullscreen mode.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_fullscreen_mode (SDL_GetWindowFullscreenMode)
// See also: set_window_fullscreen (SDL_SetWindowFullscreen)
// See also: sync_window (SDL_SyncWindow)
pub fn set_window_fullscreen_mode(window &Window, const_mode &DisplayMode) bool {
	return C.SDL_SetWindowFullscreenMode(window, const_mode)
}

// C.SDL_GetWindowFullscreenMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowFullscreenMode)
fn C.SDL_GetWindowFullscreenMode(window &Window) &DisplayMode

// get_window_fullscreen_mode querys the display mode to use when a window is visible at fullscreen.
//
// `window` window the window to query.
// returns a pointer to the exclusive fullscreen mode to use or NULL for
//          borderless fullscreen desktop mode.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_fullscreen_mode (SDL_SetWindowFullscreenMode)
// See also: set_window_fullscreen (SDL_SetWindowFullscreen)
pub fn get_window_fullscreen_mode(window &Window) &DisplayMode {
	return C.SDL_GetWindowFullscreenMode(window)
}

// C.SDL_GetWindowICCProfile [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowICCProfile)
fn C.SDL_GetWindowICCProfile(window &Window, size &usize) voidptr

// get_window_icc_profile gets the raw ICC profile data for the screen the window is currently on.
//
// `window` window the window to query.
// `size` size the size of the ICC profile.
// returns the raw ICC profile data on success or NULL on failure; call
//          SDL_GetError() for more information. This should be freed with
//          SDL_free() when it is no longer needed.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_window_icc_profile(window &Window, size &usize) voidptr {
	return C.SDL_GetWindowICCProfile(window, size)
}

// C.SDL_GetWindowPixelFormat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowPixelFormat)
fn C.SDL_GetWindowPixelFormat(window &Window) PixelFormat

// get_window_pixel_format gets the pixel format associated with the window.
//
// `window` window the window to query.
// returns the pixel format of the window on success or
//          SDL_PIXELFORMAT_UNKNOWN on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_window_pixel_format(window &Window) PixelFormat {
	return C.SDL_GetWindowPixelFormat(window)
}

// C.SDL_GetWindows [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindows)
fn C.SDL_GetWindows(count &int) &&C.SDL_Window

// get_windows gets a list of valid windows.
//
// `count` count a pointer filled in with the number of windows returned, may
//              be NULL.
// returns a NULL terminated array of SDL_Window pointers or NULL on failure;
//          call SDL_GetError() for more information. This is a single
//          allocation that should be freed with SDL_free() when it is no
//          longer needed.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_windows(count &int) &&C.SDL_Window {
	return C.SDL_GetWindows(count)
}

// C.SDL_CreateWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateWindow)
fn C.SDL_CreateWindow(const_title &char, w int, h int, flags WindowFlags) &Window

// create_window creates a window with the specified dimensions and flags.
//
// `flags` may be any of the following OR'd together:
//
// - `SDL_WINDOW_FULLSCREEN`: fullscreen window at desktop resolution
// - `SDL_WINDOW_OPENGL`: window usable with an OpenGL context
// - `SDL_WINDOW_OCCLUDED`: window partially or completely obscured by another
//   window
// - `SDL_WINDOW_HIDDEN`: window is not visible
// - `SDL_WINDOW_BORDERLESS`: no window decoration
// - `SDL_WINDOW_RESIZABLE`: window can be resized
// - `SDL_WINDOW_MINIMIZED`: window is minimized
// - `SDL_WINDOW_MAXIMIZED`: window is maximized
// - `SDL_WINDOW_MOUSE_GRABBED`: window has grabbed mouse focus
// - `SDL_WINDOW_INPUT_FOCUS`: window has input focus
// - `SDL_WINDOW_MOUSE_FOCUS`: window has mouse focus
// - `SDL_WINDOW_EXTERNAL`: window not created by SDL
// - `SDL_WINDOW_MODAL`: window is modal
// - `SDL_WINDOW_HIGH_PIXEL_DENSITY`: window uses high pixel density back
//   buffer if possible
// - `SDL_WINDOW_MOUSE_CAPTURE`: window has mouse captured (unrelated to
//   MOUSE_GRABBED)
// - `SDL_WINDOW_ALWAYS_ON_TOP`: window should always be above others
// - `SDL_WINDOW_UTILITY`: window should be treated as a utility window, not
//   showing in the task bar and window list
// - `SDL_WINDOW_TOOLTIP`: window should be treated as a tooltip and does not
//   get mouse or keyboard focus, requires a parent window
// - `SDL_WINDOW_POPUP_MENU`: window should be treated as a popup menu,
//   requires a parent window
// - `SDL_WINDOW_KEYBOARD_GRABBED`: window has grabbed keyboard input
// - `SDL_WINDOW_VULKAN`: window usable with a Vulkan instance
// - `SDL_WINDOW_METAL`: window usable with a Metal instance
// - `SDL_WINDOW_TRANSPARENT`: window with transparent buffer
// - `SDL_WINDOW_NOT_FOCUSABLE`: window should not be focusable
//
// The SDL_Window is implicitly shown if SDL_WINDOW_HIDDEN is not set.
//
// On Apple's macOS, you **must** set the NSHighResolutionCapable Info.plist
// property to YES, otherwise you will not receive a High-DPI OpenGL canvas.
//
// The window pixel size may differ from its window coordinate size if the
// window is on a high pixel density display. Use SDL_GetWindowSize() to query
// the client area's size in window coordinates, and
// SDL_GetWindowSizeInPixels() or SDL_GetRenderOutputSize() to query the
// drawable size in pixels. Note that the drawable size can vary after the
// window is created and should be queried again if you get an
// SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED event.
//
// If the window is created with any of the SDL_WINDOW_OPENGL or
// SDL_WINDOW_VULKAN flags, then the corresponding LoadLibrary function
// (SDL_GL_LoadLibrary or SDL_Vulkan_LoadLibrary) is called and the
// corresponding UnloadLibrary function is called by SDL_DestroyWindow().
//
// If SDL_WINDOW_VULKAN is specified and there isn't a working Vulkan driver,
// SDL_CreateWindow() will fail, because SDL_Vulkan_LoadLibrary() will fail.
//
// If SDL_WINDOW_METAL is specified on an OS that does not support Metal,
// SDL_CreateWindow() will fail.
//
// If you intend to use this window with an SDL_Renderer, you should use
// SDL_CreateWindowAndRenderer() instead of this function, to avoid window
// flicker.
//
// On non-Apple devices, SDL requires you to either not link to the Vulkan
// loader or link to a dynamic library version. This limitation may be removed
// in a future version of SDL.
//
// `title` title the title of the window, in UTF-8 encoding.
// `w` w the width of the window.
// `h` h the height of the window.
// `flags` flags 0, or one or more SDL_WindowFlags OR'd together.
// returns the window that was created or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_window_and_renderer (SDL_CreateWindowAndRenderer)
// See also: create_popup_window (SDL_CreatePopupWindow)
// See also: create_window_with_properties (SDL_CreateWindowWithProperties)
// See also: destroy_window (SDL_DestroyWindow)
pub fn create_window(const_title &char, w int, h int, flags WindowFlags) &Window {
	return C.SDL_CreateWindow(const_title, w, h, flags)
}

// C.SDL_CreatePopupWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreatePopupWindow)
fn C.SDL_CreatePopupWindow(parent &Window, offset_x int, offset_y int, w int, h int, flags WindowFlags) &Window

// create_popup_window creates a child popup window of the specified parent window.
//
// The flags parameter **must** contain at least one of the following:
//
// - `SDL_WINDOW_TOOLTIP`: The popup window is a tooltip and will not pass any
//   input events.
// - `SDL_WINDOW_POPUP_MENU`: The popup window is a popup menu. The topmost
//   popup menu will implicitly gain the keyboard focus.
//
// The following flags are not relevant to popup window creation and will be
// ignored:
//
// - `SDL_WINDOW_MINIMIZED`
// - `SDL_WINDOW_MAXIMIZED`
// - `SDL_WINDOW_FULLSCREEN`
// - `SDL_WINDOW_BORDERLESS`
//
// The following flags are incompatible with popup window creation and will
// cause it to fail:
//
// - `SDL_WINDOW_UTILITY`
// - `SDL_WINDOW_MODAL`
//
// The parent parameter **must** be non-null and a valid window. The parent of
// a popup window can be either a regular, toplevel window, or another popup
// window.
//
// Popup windows cannot be minimized, maximized, made fullscreen, raised,
// flash, be made a modal window, be the parent of a toplevel window, or grab
// the mouse and/or keyboard. Attempts to do so will fail.
//
// Popup windows implicitly do not have a border/decorations and do not appear
// on the taskbar/dock or in lists of windows such as alt-tab menus.
//
// If a parent window is hidden or destroyed, any child popup windows will be
// recursively hidden or destroyed as well. Child popup windows not explicitly
// hidden will be restored when the parent is shown.
//
// `parent` parent the parent of the window, must not be NULL.
// `offset_x` offset_x the x position of the popup window relative to the origin
//                 of the parent.
// `offset_y` offset_y the y position of the popup window relative to the origin
//                 of the parent window.
// `w` w the width of the window.
// `h` h the height of the window.
// `flags` flags SDL_WINDOW_TOOLTIP or SDL_WINDOW_POPUP_MENU, and zero or more
//              additional SDL_WindowFlags OR'd together.
// returns the window that was created or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_window (SDL_CreateWindow)
// See also: create_window_with_properties (SDL_CreateWindowWithProperties)
// See also: destroy_window (SDL_DestroyWindow)
// See also: get_window_parent (SDL_GetWindowParent)
pub fn create_popup_window(parent &Window, offset_x int, offset_y int, w int, h int, flags WindowFlags) &Window {
	return C.SDL_CreatePopupWindow(parent, offset_x, offset_y, w, h, flags)
}

// C.SDL_CreateWindowWithProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateWindowWithProperties)
fn C.SDL_CreateWindowWithProperties(props PropertiesID) &Window

// create_window_with_properties creates a window with the specified properties.
//
// These are the supported properties:
//
// - `SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN`: true if the window should
//   be always on top
// - `SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN`: true if the window has no
//   window decoration
// - `SDL_PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN`: true if the
//   window will be used with an externally managed graphics context.
// - `SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN`: true if the window should
//   accept keyboard input (defaults true)
// - `SDL_PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN`: true if the window should
//   start in fullscreen mode at desktop resolution
// - `SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER`: the height of the window
// - `SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN`: true if the window should start
//   hidden
// - `SDL_PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN`: true if the window
//   uses a high pixel density buffer if possible
// - `SDL_PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN`: true if the window should
//   start maximized
// - `SDL_PROP_WINDOW_CREATE_MENU_BOOLEAN`: true if the window is a popup menu
// - `SDL_PROP_WINDOW_CREATE_METAL_BOOLEAN`: true if the window will be used
//   with Metal rendering
// - `SDL_PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN`: true if the window should
//   start minimized
// - `SDL_PROP_WINDOW_CREATE_MODAL_BOOLEAN`: true if the window is modal to
//   its parent
// - `SDL_PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN`: true if the window starts
//   with grabbed mouse focus
// - `SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN`: true if the window will be used
//   with OpenGL rendering
// - `SDL_PROP_WINDOW_CREATE_PARENT_POINTER`: an SDL_Window that will be the
//   parent of this window, required for windows with the "tooltip", "menu",
//   and "modal" properties
// - `SDL_PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN`: true if the window should be
//   resizable
// - `SDL_PROP_WINDOW_CREATE_TITLE_STRING`: the title of the window, in UTF-8
//   encoding
// - `SDL_PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN`: true if the window show
//   transparent in the areas with alpha of 0
// - `SDL_PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN`: true if the window is a tooltip
// - `SDL_PROP_WINDOW_CREATE_UTILITY_BOOLEAN`: true if the window is a utility
//   window, not showing in the task bar and window list
// - `SDL_PROP_WINDOW_CREATE_VULKAN_BOOLEAN`: true if the window will be used
//   with Vulkan rendering
// - `SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER`: the width of the window
// - `SDL_PROP_WINDOW_CREATE_X_NUMBER`: the x position of the window, or
//   `SDL_WINDOWPOS_CENTERED`, defaults to `SDL_WINDOWPOS_UNDEFINED`. This is
//   relative to the parent for windows with the "tooltip" or "menu" property
//   set.
// - `SDL_PROP_WINDOW_CREATE_Y_NUMBER`: the y position of the window, or
//   `SDL_WINDOWPOS_CENTERED`, defaults to `SDL_WINDOWPOS_UNDEFINED`. This is
//   relative to the parent for windows with the "tooltip" or "menu" property
//   set.
//
// These are additional supported properties on macOS:
//
// - `SDL_PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER`: the
//   `(__unsafe_unretained)` NSWindow associated with the window, if you want
//   to wrap an existing window.
// - `SDL_PROP_WINDOW_CREATE_COCOA_VIEW_POINTER`: the `(__unsafe_unretained)`
//   NSView associated with the window, defaults to `[window contentView]`
//
// These are additional supported properties on Wayland:
//
// - `SDL_PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN` - true if
//   the application wants to use the Wayland surface for a custom role and
//   does not want it attached to an XDG toplevel window. See
//   [README/wayland](README/wayland) for more information on using custom
//   surfaces.
// - `SDL_PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN` - true if the
//   application wants an associated `wl_egl_window` object to be created and
//   attached to the window, even if the window does not have the OpenGL
//   property or `SDL_WINDOW_OPENGL` flag set.
// - `SDL_PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER` - the wl_surface
//   associated with the window, if you want to wrap an existing window. See
//   [README/wayland](README/wayland) for more information.
//
// These are additional supported properties on Windows:
//
// - `SDL_PROP_WINDOW_CREATE_WIN32_HWND_POINTER`: the HWND associated with the
//   window, if you want to wrap an existing window.
// - `SDL_PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER`: optional,
//   another window to share pixel format with, useful for OpenGL windows
//
// These are additional supported properties with X11:
//
// - `SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER`: the X11 Window associated
//   with the window, if you want to wrap an existing window.
//
// The window is implicitly shown if the "hidden" property is not set.
//
// Windows with the "tooltip" and "menu" properties are popup windows and have
// the behaviors and guidelines outlined in SDL_CreatePopupWindow().
//
// If this window is being created to be used with an SDL_Renderer, you should
// not add a graphics API specific property
// (`SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN`, etc), as SDL will handle that
// internally when it chooses a renderer. However, SDL might need to recreate
// your window at that point, which may cause the window to appear briefly,
// and then flicker as it is recreated. The correct approach to this is to
// create the window with the `SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN` property
// set to true, then create the renderer, then show the window with
// SDL_ShowWindow().
//
// `props` props the properties to use.
// returns the window that was created or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_properties (SDL_CreateProperties)
// See also: create_window (SDL_CreateWindow)
// See also: destroy_window (SDL_DestroyWindow)
pub fn create_window_with_properties(props PropertiesID) &Window {
	return C.SDL_CreateWindowWithProperties(props)
}

pub const prop_window_create_always_on_top_boolean = &char(C.SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN) // 'SDL.window.create.always_on_top'

pub const prop_window_create_borderless_boolean = &char(C.SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN) // 'SDL.window.create.borderless'

pub const prop_window_create_focusable_boolean = &char(C.SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN) // 'SDL.window.create.focusable'

pub const prop_window_create_external_graphics_context_boolean = &char(C.SDL_PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN) // 'SDL.window.create.external_graphics_context'

pub const prop_window_create_flags_number = &char(C.SDL_PROP_WINDOW_CREATE_FLAGS_NUMBER) // 'SDL.window.create.flags'

pub const prop_window_create_fullscreen_boolean = &char(C.SDL_PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN) // 'SDL.window.create.fullscreen'

pub const prop_window_create_height_number = &char(C.SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER) // 'SDL.window.create.height'

pub const prop_window_create_hidden_boolean = &char(C.SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN) // 'SDL.window.create.hidden'

pub const prop_window_create_high_pixel_density_boolean = &char(C.SDL_PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN) // 'SDL.window.create.high_pixel_density'

pub const prop_window_create_maximized_boolean = &char(C.SDL_PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN) // 'SDL.window.create.maximized'

pub const prop_window_create_menu_boolean = &char(C.SDL_PROP_WINDOW_CREATE_MENU_BOOLEAN) // 'SDL.window.create.menu'

pub const prop_window_create_metal_boolean = &char(C.SDL_PROP_WINDOW_CREATE_METAL_BOOLEAN) // 'SDL.window.create.metal'

pub const prop_window_create_minimized_boolean = &char(C.SDL_PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN) // 'SDL.window.create.minimized'

pub const prop_window_create_modal_boolean = &char(C.SDL_PROP_WINDOW_CREATE_MODAL_BOOLEAN) // 'SDL.window.create.modal'

pub const prop_window_create_mouse_grabbed_boolean = &char(C.SDL_PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN) // 'SDL.window.create.mouse_grabbed'

pub const prop_window_create_opengl_boolean = &char(C.SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN) // 'SDL.window.create.opengl'

pub const prop_window_create_parent_pointer = &char(C.SDL_PROP_WINDOW_CREATE_PARENT_POINTER) // 'SDL.window.create.parent'

pub const prop_window_create_resizable_boolean = &char(C.SDL_PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN) // 'SDL.window.create.resizable'

pub const prop_window_create_title_string = &char(C.SDL_PROP_WINDOW_CREATE_TITLE_STRING) // 'SDL.window.create.title'

pub const prop_window_create_transparent_boolean = &char(C.SDL_PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN) // 'SDL.window.create.transparent'

pub const prop_window_create_tooltip_boolean = &char(C.SDL_PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN) // 'SDL.window.create.tooltip'

pub const prop_window_create_utility_boolean = &char(C.SDL_PROP_WINDOW_CREATE_UTILITY_BOOLEAN) // 'SDL.window.create.utility'

pub const prop_window_create_vulkan_boolean = &char(C.SDL_PROP_WINDOW_CREATE_VULKAN_BOOLEAN) // 'SDL.window.create.vulkan'

pub const prop_window_create_width_number = &char(C.SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER) // 'SDL.window.create.width'

pub const prop_window_create_x_number = &char(C.SDL_PROP_WINDOW_CREATE_X_NUMBER) // 'SDL.window.create.x'

pub const prop_window_create_y_number = &char(C.SDL_PROP_WINDOW_CREATE_Y_NUMBER) // 'SDL.window.create.y'

pub const prop_window_create_cocoa_window_pointer = &char(C.SDL_PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER) // 'SDL.window.create.cocoa.window'

pub const prop_window_create_cocoa_view_pointer = &char(C.SDL_PROP_WINDOW_CREATE_COCOA_VIEW_POINTER) // 'SDL.window.create.cocoa.view'

pub const prop_window_create_wayland_surface_role_custom_boolean = &char(C.SDL_PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN) // 'SDL.window.create.wayland.surface_role_custom'

pub const prop_window_create_wayland_create_egl_window_boolean = &char(C.SDL_PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN) // 'SDL.window.create.wayland.create_egl_window'

pub const prop_window_create_wayland_wl_surface_pointer = &char(C.SDL_PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER) // 'SDL.window.create.wayland.wl_surface'

pub const prop_window_create_win32_hwnd_pointer = &char(C.SDL_PROP_WINDOW_CREATE_WIN32_HWND_POINTER) // 'SDL.window.create.win32.hwnd'

pub const prop_window_create_win32_pixel_format_hwnd_pointer = &char(C.SDL_PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER) // 'SDL.window.create.win32.pixel_format_hwnd'

pub const prop_window_create_x11_window_number = &char(C.SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER) // 'SDL.window.create.x11.window'

// C.SDL_GetWindowID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowID)
fn C.SDL_GetWindowID(window &Window) WindowID

// get_window_id gets the numeric ID of a window.
//
// The numeric ID is what SDL_WindowEvent references, and is necessary to map
// these events to specific SDL_Window objects.
//
// `window` window the window to query.
// returns the ID of the window on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_from_id (SDL_GetWindowFromID)
pub fn get_window_id(window &Window) WindowID {
	return C.SDL_GetWindowID(window)
}

// C.SDL_GetWindowFromID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowFromID)
fn C.SDL_GetWindowFromID(id WindowID) &Window

// get_window_from_id gets a window from a stored ID.
//
// The numeric ID is what SDL_WindowEvent references, and is necessary to map
// these events to specific SDL_Window objects.
//
// `id` id the ID of the window.
// returns the window associated with `id` or NULL if it doesn't exist; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_id (SDL_GetWindowID)
pub fn get_window_from_id(id WindowID) &Window {
	return C.SDL_GetWindowFromID(id)
}

// C.SDL_GetWindowParent [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowParent)
fn C.SDL_GetWindowParent(window &Window) &Window

// get_window_parent gets parent of a window.
//
// `window` window the window to query.
// returns the parent of the window on success or NULL if the window has no
//          parent.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_popup_window (SDL_CreatePopupWindow)
pub fn get_window_parent(window &Window) &Window {
	return C.SDL_GetWindowParent(window)
}

// C.SDL_GetWindowProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowProperties)
fn C.SDL_GetWindowProperties(window &Window) PropertiesID

// get_window_properties gets the properties associated with a window.
//
// The following read-only properties are provided by SDL:
//
// - `SDL_PROP_WINDOW_SHAPE_POINTER`: the surface associated with a shaped
//   window
// - `SDL_PROP_WINDOW_HDR_ENABLED_BOOLEAN`: true if the window has HDR
//   headroom above the SDR white point. This property can change dynamically
//   when SDL_EVENT_WINDOW_HDR_STATE_CHANGED is sent.
// - `SDL_PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT`: the value of SDR white in the
//   SDL_COLORSPACE_SRGB_LINEAR colorspace. On Windows this corresponds to the
//   SDR white level in scRGB colorspace, and on Apple platforms this is
//   always 1.0 for EDR content. This property can change dynamically when
//   SDL_EVENT_WINDOW_HDR_STATE_CHANGED is sent.
// - `SDL_PROP_WINDOW_HDR_HEADROOM_FLOAT`: the additional high dynamic range
//   that can be displayed, in terms of the SDR white point. When HDR is not
//   enabled, this will be 1.0. This property can change dynamically when
//   SDL_EVENT_WINDOW_HDR_STATE_CHANGED is sent.
//
// On Android:
//
// - `SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER`: the ANativeWindow associated
//   with the window
// - `SDL_PROP_WINDOW_ANDROID_SURFACE_POINTER`: the EGLSurface associated with
//   the window
//
// On iOS:
//
// - `SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER`: the `(__unsafe_unretained)`
//   UIWindow associated with the window
// - `SDL_PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER`: the NSInteger tag
//   associated with metal views on the window
// - `SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER`: the OpenGL view's
//   framebuffer object. It must be bound when rendering to the screen using
//   OpenGL.
// - `SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER`: the OpenGL view's
//   renderbuffer object. It must be bound when SDL_GL_SwapWindow is called.
// - `SDL_PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER`: the OpenGL
//   view's resolve framebuffer, when MSAA is used.
//
// On KMS/DRM:
//
// - `SDL_PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER`: the device index associated
//   with the window (e.g. the X in /dev/dri/cardX)
// - `SDL_PROP_WINDOW_KMSDRM_DRM_FD_NUMBER`: the DRM FD associated with the
//   window
// - `SDL_PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER`: the GBM device associated
//   with the window
//
// On macOS:
//
// - `SDL_PROP_WINDOW_COCOA_WINDOW_POINTER`: the `(__unsafe_unretained)`
//   NSWindow associated with the window
// - `SDL_PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER`: the NSInteger tag
//   assocated with metal views on the window
//
// On OpenVR:
//
// - `SDL_PROP_WINDOW_OPENVR_OVERLAY_ID`: the OpenVR Overlay Handle ID for the
//   associated overlay window.
//
// On Vivante:
//
// - `SDL_PROP_WINDOW_VIVANTE_DISPLAY_POINTER`: the EGLNativeDisplayType
//   associated with the window
// - `SDL_PROP_WINDOW_VIVANTE_WINDOW_POINTER`: the EGLNativeWindowType
//   associated with the window
// - `SDL_PROP_WINDOW_VIVANTE_SURFACE_POINTER`: the EGLSurface associated with
//   the window
//
// On Windows:
//
// - `SDL_PROP_WINDOW_WIN32_HWND_POINTER`: the HWND associated with the window
// - `SDL_PROP_WINDOW_WIN32_HDC_POINTER`: the HDC associated with the window
// - `SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER`: the HINSTANCE associated with
//   the window
//
// On Wayland:
//
// Note: The `xdg_*` window objects do not internally persist across window
// show/hide calls. They will be null if the window is hidden and must be
// queried each time it is shown.
//
// - `SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER`: the wl_display associated with
//   the window
// - `SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER`: the wl_surface associated with
//   the window
// - `SDL_PROP_WINDOW_WAYLAND_VIEWPORT_POINTER`: the wp_viewport associated
//   with the window
// - `SDL_PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER`: the wl_egl_window
//   associated with the window
// - `SDL_PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER`: the xdg_surface associated
//   with the window
// - `SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER`: the xdg_toplevel role
//   associated with the window
// - 'SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING': the export
//   handle associated with the window
// - `SDL_PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER`: the xdg_popup role
//   associated with the window
// - `SDL_PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER`: the xdg_positioner
//   associated with the window, in popup mode
//
// On X11:
//
// - `SDL_PROP_WINDOW_X11_DISPLAY_POINTER`: the X11 Display associated with
//   the window
// - `SDL_PROP_WINDOW_X11_SCREEN_NUMBER`: the screen number associated with
//   the window
// - `SDL_PROP_WINDOW_X11_WINDOW_NUMBER`: the X11 Window associated with the
//   window
//
// `window` window the window to query.
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_window_properties(window &Window) PropertiesID {
	return C.SDL_GetWindowProperties(window)
}

pub const prop_window_shape_pointer = &char(C.SDL_PROP_WINDOW_SHAPE_POINTER) // 'SDL.window.shape'

pub const prop_window_hdr_enabled_boolean = &char(C.SDL_PROP_WINDOW_HDR_ENABLED_BOOLEAN) // 'SDL.window.HDR_enabled'

pub const prop_window_sdr_white_level_float = &char(C.SDL_PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT) // 'SDL.window.SDR_white_level'

pub const prop_window_hdr_headroom_float = &char(C.SDL_PROP_WINDOW_HDR_HEADROOM_FLOAT) // 'SDL.window.HDR_headroom'

pub const prop_window_android_window_pointer = &char(C.SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER) // 'SDL.window.android.window'

pub const prop_window_android_surface_pointer = &char(C.SDL_PROP_WINDOW_ANDROID_SURFACE_POINTER) // 'SDL.window.android.surface'

pub const prop_window_uikit_window_pointer = &char(C.SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER) // 'SDL.window.uikit.window'

pub const prop_window_uikit_metal_view_tag_number = &char(C.SDL_PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER) // 'SDL.window.uikit.metal_view_tag'

pub const prop_window_uikit_opengl_framebuffer_number = &char(C.SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER) // 'SDL.window.uikit.opengl.framebuffer'

pub const prop_window_uikit_opengl_renderbuffer_number = &char(C.SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER) // 'SDL.window.uikit.opengl.renderbuffer'

pub const prop_window_uikit_opengl_resolve_framebuffer_number = &char(C.SDL_PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER) // 'SDL.window.uikit.opengl.resolve_framebuffer'

pub const prop_window_kmsdrm_device_index_number = &char(C.SDL_PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER) // 'SDL.window.kmsdrm.dev_index'

pub const prop_window_kmsdrm_drm_fd_number = &char(C.SDL_PROP_WINDOW_KMSDRM_DRM_FD_NUMBER) // 'SDL.window.kmsdrm.drm_fd'

pub const prop_window_kmsdrm_gbm_device_pointer = &char(C.SDL_PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER) // 'SDL.window.kmsdrm.gbm_dev'

pub const prop_window_cocoa_window_pointer = &char(C.SDL_PROP_WINDOW_COCOA_WINDOW_POINTER) // 'SDL.window.cocoa.window'

pub const prop_window_cocoa_metal_view_tag_number = &char(C.SDL_PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER) // 'SDL.window.cocoa.metal_view_tag'

pub const prop_window_openvr_overlay_id = &char(C.SDL_PROP_WINDOW_OPENVR_OVERLAY_ID) // 'SDL.window.openvr.overlay_id'

pub const prop_window_vivante_display_pointer = &char(C.SDL_PROP_WINDOW_VIVANTE_DISPLAY_POINTER) // 'SDL.window.vivante.display'

pub const prop_window_vivante_window_pointer = &char(C.SDL_PROP_WINDOW_VIVANTE_WINDOW_POINTER) // 'SDL.window.vivante.window'

pub const prop_window_vivante_surface_pointer = &char(C.SDL_PROP_WINDOW_VIVANTE_SURFACE_POINTER) // 'SDL.window.vivante.surface'

pub const prop_window_win32_hwnd_pointer = &char(C.SDL_PROP_WINDOW_WIN32_HWND_POINTER) // 'SDL.window.win32.hwnd'

pub const prop_window_win32_hdc_pointer = &char(C.SDL_PROP_WINDOW_WIN32_HDC_POINTER) // 'SDL.window.win32.hdc'

pub const prop_window_win32_instance_pointer = &char(C.SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER) // 'SDL.window.win32.instance'

pub const prop_window_wayland_display_pointer = &char(C.SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER) // 'SDL.window.wayland.display'

pub const prop_window_wayland_surface_pointer = &char(C.SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER) // 'SDL.window.wayland.surface'

pub const prop_window_wayland_viewport_pointer = &char(C.SDL_PROP_WINDOW_WAYLAND_VIEWPORT_POINTER) // 'SDL.window.wayland.viewport'

pub const prop_window_wayland_egl_window_pointer = &char(C.SDL_PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER) // 'SDL.window.wayland.egl_window'

pub const prop_window_wayland_xdg_surface_pointer = &char(C.SDL_PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER) // 'SDL.window.wayland.xdg_surface'

pub const prop_window_wayland_xdg_toplevel_pointer = &char(C.SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER) // 'SDL.window.wayland.xdg_toplevel'

pub const prop_window_wayland_xdg_toplevel_export_handle_string = &char(C.SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING) // 'SDL.window.wayland.xdg_toplevel_export_handle'

pub const prop_window_wayland_xdg_popup_pointer = &char(C.SDL_PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER) // 'SDL.window.wayland.xdg_popup'

pub const prop_window_wayland_xdg_positioner_pointer = &char(C.SDL_PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER) // 'SDL.window.wayland.xdg_positioner'

pub const prop_window_x11_display_pointer = &char(C.SDL_PROP_WINDOW_X11_DISPLAY_POINTER) // 'SDL.window.x11.display'

pub const prop_window_x11_screen_number = &char(C.SDL_PROP_WINDOW_X11_SCREEN_NUMBER) // 'SDL.window.x11.screen'

pub const prop_window_x11_window_number = &char(C.SDL_PROP_WINDOW_X11_WINDOW_NUMBER) // 'SDL.window.x11.window'

// C.SDL_GetWindowFlags [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowFlags)
fn C.SDL_GetWindowFlags(window &Window) WindowFlags

// get_window_flags gets the window flags.
//
// `window` window the window to query.
// returns a mask of the SDL_WindowFlags associated with `window`.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_window (SDL_CreateWindow)
// See also: hide_window (SDL_HideWindow)
// See also: maximize_window (SDL_MaximizeWindow)
// See also: minimize_window (SDL_MinimizeWindow)
// See also: set_window_fullscreen (SDL_SetWindowFullscreen)
// See also: set_window_mouse_grab (SDL_SetWindowMouseGrab)
// See also: show_window (SDL_ShowWindow)
pub fn get_window_flags(window &Window) WindowFlags {
	return C.SDL_GetWindowFlags(window)
}

// C.SDL_SetWindowTitle [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowTitle)
fn C.SDL_SetWindowTitle(window &Window, const_title &char) bool

// set_window_title sets the title of a window.
//
// This string is expected to be in UTF-8 encoding.
//
// `window` window the window to change.
// `title` title the desired window title in UTF-8 format.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_title (SDL_GetWindowTitle)
pub fn set_window_title(window &Window, const_title &char) bool {
	return C.SDL_SetWindowTitle(window, const_title)
}

// C.SDL_GetWindowTitle [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowTitle)
fn C.SDL_GetWindowTitle(window &Window) &char

// get_window_title gets the title of a window.
//
// `window` window the window to query.
// returns the title of the window in UTF-8 format or "" if there is no
//          title.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_title (SDL_SetWindowTitle)
pub fn get_window_title(window &Window) &char {
	return &char(C.SDL_GetWindowTitle(window))
}

// C.SDL_SetWindowIcon [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowIcon)
fn C.SDL_SetWindowIcon(window &Window, icon &Surface) bool

// set_window_icon sets the icon for a window.
//
// If this function is passed a surface with alternate representations, the
// surface will be interpreted as the content to be used for 100% display
// scale, and the alternate representations will be used for high DPI
// situations. For example, if the original surface is 32x32, then on a 2x
// macOS display or 200% display scale on Windows, a 64x64 version of the
// image will be used, if available. If a matching version of the image isn't
// available, the closest larger size image will be downscaled to the
// appropriate size and be used instead, if available. Otherwise, the closest
// smaller image will be upscaled and be used instead.
//
// `window` window the window to change.
// `icon` icon an SDL_Surface structure containing the icon for the window.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_window_icon(window &Window, icon &Surface) bool {
	return C.SDL_SetWindowIcon(window, icon)
}

// C.SDL_SetWindowPosition [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowPosition)
fn C.SDL_SetWindowPosition(window &Window, x int, y int) bool

// set_window_position requests that the window's position be set.
//
// If the window is in an exclusive fullscreen or maximized state, this
// request has no effect.
//
// This can be used to reposition fullscreen-desktop windows onto a different
// display, however, as exclusive fullscreen windows are locked to a specific
// display, they can only be repositioned programmatically via
// SDL_SetWindowFullscreenMode().
//
// On some windowing systems this request is asynchronous and the new
// coordinates may not have have been applied immediately upon the return of
// this function. If an immediate change is required, call SDL_SyncWindow() to
// block until the changes have taken effect.
//
// When the window position changes, an SDL_EVENT_WINDOW_MOVED event will be
// emitted with the window's new coordinates. Note that the new coordinates
// may not match the exact coordinates requested, as some windowing systems
// can restrict the position of the window in certain scenarios (e.g.
// constraining the position so the window is always within desktop bounds).
// Additionally, as this is just a request, it can be denied by the windowing
// system.
//
// `window` window the window to reposition.
// `x` x the x coordinate of the window, or `SDL_WINDOWPOS_CENTERED` or
//          `SDL_WINDOWPOS_UNDEFINED`.
// `y` y the y coordinate of the window, or `SDL_WINDOWPOS_CENTERED` or
//          `SDL_WINDOWPOS_UNDEFINED`.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_position (SDL_GetWindowPosition)
// See also: sync_window (SDL_SyncWindow)
pub fn set_window_position(window &Window, x int, y int) bool {
	return C.SDL_SetWindowPosition(window, x, y)
}

// C.SDL_GetWindowPosition [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowPosition)
fn C.SDL_GetWindowPosition(window &Window, x &int, y &int) bool

// get_window_position gets the position of a window.
//
// This is the current position of the window as last reported by the
// windowing system.
//
// If you do not need the value for one of the positions a NULL may be passed
// in the `x` or `y` parameter.
//
// `window` window the window to query.
// `x` x a pointer filled in with the x position of the window, may be
//          NULL.
// `y` y a pointer filled in with the y position of the window, may be
//          NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_position (SDL_SetWindowPosition)
pub fn get_window_position(window &Window, x &int, y &int) bool {
	return C.SDL_GetWindowPosition(window, x, y)
}

// C.SDL_SetWindowSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowSize)
fn C.SDL_SetWindowSize(window &Window, w int, h int) bool

// set_window_size requests that the size of a window's client area be set.
//
// If the window is in a fullscreen or maximized state, this request has no
// effect.
//
// To change the exclusive fullscreen mode of a window, use
// SDL_SetWindowFullscreenMode().
//
// On some windowing systems, this request is asynchronous and the new window
// size may not have have been applied immediately upon the return of this
// function. If an immediate change is required, call SDL_SyncWindow() to
// block until the changes have taken effect.
//
// When the window size changes, an SDL_EVENT_WINDOW_RESIZED event will be
// emitted with the new window dimensions. Note that the new dimensions may
// not match the exact size requested, as some windowing systems can restrict
// the window size in certain scenarios (e.g. constraining the size of the
// content area to remain within the usable desktop bounds). Additionally, as
// this is just a request, it can be denied by the windowing system.
//
// `window` window the window to change.
// `w` w the width of the window, must be > 0.
// `h` h the height of the window, must be > 0.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_size (SDL_GetWindowSize)
// See also: set_window_fullscreen_mode (SDL_SetWindowFullscreenMode)
// See also: sync_window (SDL_SyncWindow)
pub fn set_window_size(window &Window, w int, h int) bool {
	return C.SDL_SetWindowSize(window, w, h)
}

// C.SDL_GetWindowSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowSize)
fn C.SDL_GetWindowSize(window &Window, w &int, h &int) bool

// get_window_size gets the size of a window's client area.
//
// The window pixel size may differ from its window coordinate size if the
// window is on a high pixel density display. Use SDL_GetWindowSizeInPixels()
// or SDL_GetRenderOutputSize() to get the real client area size in pixels.
//
// `window` window the window to query the width and height from.
// `w` w a pointer filled in with the width of the window, may be NULL.
// `h` h a pointer filled in with the height of the window, may be NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_render_output_size (SDL_GetRenderOutputSize)
// See also: get_window_size_in_pixels (SDL_GetWindowSizeInPixels)
// See also: set_window_size (SDL_SetWindowSize)
pub fn get_window_size(window &Window, w &int, h &int) bool {
	return C.SDL_GetWindowSize(window, w, h)
}

// C.SDL_GetWindowSafeArea [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowSafeArea)
fn C.SDL_GetWindowSafeArea(window &Window, rect &Rect) bool

// get_window_safe_area gets the safe area for this window.
//
// Some devices have portions of the screen which are partially obscured or
// not interactive, possibly due to on-screen controls, curved edges, camera
// notches, TV overscan, etc. This function provides the area of the window
// which is safe to have interactable content. You should continue rendering
// into the rest of the window, but it should not contain visually important
// or interactible content.
//
// `window` window the window to query.
// `rect` rect a pointer filled in with the client area that is safe for
//             interactive content.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_window_safe_area(window &Window, rect &Rect) bool {
	return C.SDL_GetWindowSafeArea(window, rect)
}

// C.SDL_SetWindowAspectRatio [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowAspectRatio)
fn C.SDL_SetWindowAspectRatio(window &Window, min_aspect f32, max_aspect f32) bool

// set_window_aspect_ratio requests that the aspect ratio of a window's client area be set.
//
// The aspect ratio is the ratio of width divided by height, e.g. 2560x1600
// would be 1.6. Larger aspect ratios are wider and smaller aspect ratios are
// narrower.
//
// If, at the time of this request, the window in a fixed-size state, such as
// maximized or fullscreen, the request will be deferred until the window
// exits this state and becomes resizable again.
//
// On some windowing systems, this request is asynchronous and the new window
// aspect ratio may not have have been applied immediately upon the return of
// this function. If an immediate change is required, call SDL_SyncWindow() to
// block until the changes have taken effect.
//
// When the window size changes, an SDL_EVENT_WINDOW_RESIZED event will be
// emitted with the new window dimensions. Note that the new dimensions may
// not match the exact aspect ratio requested, as some windowing systems can
// restrict the window size in certain scenarios (e.g. constraining the size
// of the content area to remain within the usable desktop bounds).
// Additionally, as this is just a request, it can be denied by the windowing
// system.
//
// `window` window the window to change.
// `min_aspect` min_aspect the minimum aspect ratio of the window, or 0.0f for no
//                   limit.
// `max_aspect` max_aspect the maximum aspect ratio of the window, or 0.0f for no
//                   limit.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_aspect_ratio (SDL_GetWindowAspectRatio)
// See also: sync_window (SDL_SyncWindow)
pub fn set_window_aspect_ratio(window &Window, min_aspect f32, max_aspect f32) bool {
	return C.SDL_SetWindowAspectRatio(window, min_aspect, max_aspect)
}

// C.SDL_GetWindowAspectRatio [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowAspectRatio)
fn C.SDL_GetWindowAspectRatio(window &Window, min_aspect &f32, max_aspect &f32) bool

// get_window_aspect_ratio gets the size of a window's client area.
//
// `window` window the window to query the width and height from.
// `min_aspect` min_aspect a pointer filled in with the minimum aspect ratio of the
//                   window, may be NULL.
// `max_aspect` max_aspect a pointer filled in with the maximum aspect ratio of the
//                   window, may be NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_aspect_ratio (SDL_SetWindowAspectRatio)
pub fn get_window_aspect_ratio(window &Window, min_aspect &f32, max_aspect &f32) bool {
	return C.SDL_GetWindowAspectRatio(window, min_aspect, max_aspect)
}

// C.SDL_GetWindowBordersSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowBordersSize)
fn C.SDL_GetWindowBordersSize(window &Window, top &int, left &int, bottom &int, right &int) bool

// get_window_borders_size gets the size of a window's borders (decorations) around the client area.
//
// Note: If this function fails (returns false), the size values will be
// initialized to 0, 0, 0, 0 (if a non-NULL pointer is provided), as if the
// window in question was borderless.
//
// Note: This function may fail on systems where the window has not yet been
// decorated by the display server (for example, immediately after calling
// SDL_CreateWindow). It is recommended that you wait at least until the
// window has been presented and composited, so that the window system has a
// chance to decorate the window and provide the border dimensions to SDL.
//
// This function also returns false if getting the information is not
// supported.
//
// `window` window the window to query the size values of the border
//               (decorations) from.
// `top` top pointer to variable for storing the size of the top border; NULL
//            is permitted.
// `left` left pointer to variable for storing the size of the left border;
//             NULL is permitted.
// `bottom` bottom pointer to variable for storing the size of the bottom
//               border; NULL is permitted.
// `right` right pointer to variable for storing the size of the right border;
//              NULL is permitted.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_size (SDL_GetWindowSize)
pub fn get_window_borders_size(window &Window, top &int, left &int, bottom &int, right &int) bool {
	return C.SDL_GetWindowBordersSize(window, top, left, bottom, right)
}

// C.SDL_GetWindowSizeInPixels [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowSizeInPixels)
fn C.SDL_GetWindowSizeInPixels(window &Window, w &int, h &int) bool

// get_window_size_in_pixels gets the size of a window's client area, in pixels.
//
// `window` window the window from which the drawable size should be queried.
// `w` w a pointer to variable for storing the width in pixels, may be
//          NULL.
// `h` h a pointer to variable for storing the height in pixels, may be
//          NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_window (SDL_CreateWindow)
// See also: get_window_size (SDL_GetWindowSize)
pub fn get_window_size_in_pixels(window &Window, w &int, h &int) bool {
	return C.SDL_GetWindowSizeInPixels(window, w, h)
}

// C.SDL_SetWindowMinimumSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowMinimumSize)
fn C.SDL_SetWindowMinimumSize(window &Window, min_w int, min_h int) bool

// set_window_minimum_size sets the minimum size of a window's client area.
//
// `window` window the window to change.
// `min_w` min_w the minimum width of the window, or 0 for no limit.
// `min_h` min_h the minimum height of the window, or 0 for no limit.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_minimum_size (SDL_GetWindowMinimumSize)
// See also: set_window_maximum_size (SDL_SetWindowMaximumSize)
pub fn set_window_minimum_size(window &Window, min_w int, min_h int) bool {
	return C.SDL_SetWindowMinimumSize(window, min_w, min_h)
}

// C.SDL_GetWindowMinimumSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowMinimumSize)
fn C.SDL_GetWindowMinimumSize(window &Window, w &int, h &int) bool

// get_window_minimum_size gets the minimum size of a window's client area.
//
// `window` window the window to query.
// `w` w a pointer filled in with the minimum width of the window, may be
//          NULL.
// `h` h a pointer filled in with the minimum height of the window, may be
//          NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_maximum_size (SDL_GetWindowMaximumSize)
// See also: set_window_minimum_size (SDL_SetWindowMinimumSize)
pub fn get_window_minimum_size(window &Window, w &int, h &int) bool {
	return C.SDL_GetWindowMinimumSize(window, w, h)
}

// C.SDL_SetWindowMaximumSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowMaximumSize)
fn C.SDL_SetWindowMaximumSize(window &Window, max_w int, max_h int) bool

// set_window_maximum_size sets the maximum size of a window's client area.
//
// `window` window the window to change.
// `max_w` max_w the maximum width of the window, or 0 for no limit.
// `max_h` max_h the maximum height of the window, or 0 for no limit.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_maximum_size (SDL_GetWindowMaximumSize)
// See also: set_window_minimum_size (SDL_SetWindowMinimumSize)
pub fn set_window_maximum_size(window &Window, max_w int, max_h int) bool {
	return C.SDL_SetWindowMaximumSize(window, max_w, max_h)
}

// C.SDL_GetWindowMaximumSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowMaximumSize)
fn C.SDL_GetWindowMaximumSize(window &Window, w &int, h &int) bool

// get_window_maximum_size gets the maximum size of a window's client area.
//
// `window` window the window to query.
// `w` w a pointer filled in with the maximum width of the window, may be
//          NULL.
// `h` h a pointer filled in with the maximum height of the window, may be
//          NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_minimum_size (SDL_GetWindowMinimumSize)
// See also: set_window_maximum_size (SDL_SetWindowMaximumSize)
pub fn get_window_maximum_size(window &Window, w &int, h &int) bool {
	return C.SDL_GetWindowMaximumSize(window, w, h)
}

// C.SDL_SetWindowBordered [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowBordered)
fn C.SDL_SetWindowBordered(window &Window, bordered bool) bool

// set_window_bordered sets the border state of a window.
//
// This will add or remove the window's `SDL_WINDOW_BORDERLESS` flag and add
// or remove the border from the actual window. This is a no-op if the
// window's border already matches the requested state.
//
// You can't change the border state of a fullscreen window.
//
// `window` window the window of which to change the border state.
// `bordered` bordered false to remove border, true to add border.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_flags (SDL_GetWindowFlags)
pub fn set_window_bordered(window &Window, bordered bool) bool {
	return C.SDL_SetWindowBordered(window, bordered)
}

// C.SDL_SetWindowResizable [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowResizable)
fn C.SDL_SetWindowResizable(window &Window, resizable bool) bool

// set_window_resizable sets the user-resizable state of a window.
//
// This will add or remove the window's `SDL_WINDOW_RESIZABLE` flag and
// allow/disallow user resizing of the window. This is a no-op if the window's
// resizable state already matches the requested state.
//
// You can't change the resizable state of a fullscreen window.
//
// `window` window the window of which to change the resizable state.
// `resizable` resizable true to allow resizing, false to disallow.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_flags (SDL_GetWindowFlags)
pub fn set_window_resizable(window &Window, resizable bool) bool {
	return C.SDL_SetWindowResizable(window, resizable)
}

// C.SDL_SetWindowAlwaysOnTop [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowAlwaysOnTop)
fn C.SDL_SetWindowAlwaysOnTop(window &Window, on_top bool) bool

// set_window_always_on_top sets the window to always be above the others.
//
// This will add or remove the window's `SDL_WINDOW_ALWAYS_ON_TOP` flag. This
// will bring the window to the front and keep the window above the rest.
//
// `window` window the window of which to change the always on top state.
// `on_top` on_top true to set the window always on top, false to disable.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_flags (SDL_GetWindowFlags)
pub fn set_window_always_on_top(window &Window, on_top bool) bool {
	return C.SDL_SetWindowAlwaysOnTop(window, on_top)
}

// C.SDL_ShowWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShowWindow)
fn C.SDL_ShowWindow(window &Window) bool

// show_window shows a window.
//
// `window` window the window to show.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: hide_window (SDL_HideWindow)
// See also: raise_window (SDL_RaiseWindow)
pub fn show_window(window &Window) bool {
	return C.SDL_ShowWindow(window)
}

// C.SDL_HideWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_HideWindow)
fn C.SDL_HideWindow(window &Window) bool

// hide_window hides a window.
//
// `window` window the window to hide.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: show_window (SDL_ShowWindow)
// See also: windowhidden (SDL_WINDOW_HIDDEN)
pub fn hide_window(window &Window) bool {
	return C.SDL_HideWindow(window)
}

// C.SDL_RaiseWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_RaiseWindow)
fn C.SDL_RaiseWindow(window &Window) bool

// raise_window requests that a window be raised above other windows and gain the input
// focus.
//
// The result of this request is subject to desktop window manager policy,
// particularly if raising the requested window would result in stealing focus
// from another application. If the window is successfully raised and gains
// input focus, an SDL_EVENT_WINDOW_FOCUS_GAINED event will be emitted, and
// the window will have the SDL_WINDOW_INPUT_FOCUS flag set.
//
// `window` window the window to raise.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn raise_window(window &Window) bool {
	return C.SDL_RaiseWindow(window)
}

// C.SDL_MaximizeWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_MaximizeWindow)
fn C.SDL_MaximizeWindow(window &Window) bool

// maximize_window requests that the window be made as large as possible.
//
// Non-resizable windows can't be maximized. The window must have the
// SDL_WINDOW_RESIZABLE flag set, or this will have no effect.
//
// On some windowing systems this request is asynchronous and the new window
// state may not have have been applied immediately upon the return of this
// function. If an immediate change is required, call SDL_SyncWindow() to
// block until the changes have taken effect.
//
// When the window state changes, an SDL_EVENT_WINDOW_MAXIMIZED event will be
// emitted. Note that, as this is just a request, the windowing system can
// deny the state change.
//
// When maximizing a window, whether the constraints set via
// SDL_SetWindowMaximumSize() are honored depends on the policy of the window
// manager. Win32 and macOS enforce the constraints when maximizing, while X11
// and Wayland window managers may vary.
//
// `window` window the window to maximize.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: minimize_window (SDL_MinimizeWindow)
// See also: restore_window (SDL_RestoreWindow)
// See also: sync_window (SDL_SyncWindow)
pub fn maximize_window(window &Window) bool {
	return C.SDL_MaximizeWindow(window)
}

// C.SDL_MinimizeWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_MinimizeWindow)
fn C.SDL_MinimizeWindow(window &Window) bool

// minimize_window requests that the window be minimized to an iconic representation.
//
// If the window is in a fullscreen state, this request has no direct effect.
// It may alter the state the window is returned to when leaving fullscreen.
//
// On some windowing systems this request is asynchronous and the new window
// state may not have been applied immediately upon the return of this
// function. If an immediate change is required, call SDL_SyncWindow() to
// block until the changes have taken effect.
//
// When the window state changes, an SDL_EVENT_WINDOW_MINIMIZED event will be
// emitted. Note that, as this is just a request, the windowing system can
// deny the state change.
//
// `window` window the window to minimize.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: maximize_window (SDL_MaximizeWindow)
// See also: restore_window (SDL_RestoreWindow)
// See also: sync_window (SDL_SyncWindow)
pub fn minimize_window(window &Window) bool {
	return C.SDL_MinimizeWindow(window)
}

// C.SDL_RestoreWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_RestoreWindow)
fn C.SDL_RestoreWindow(window &Window) bool

// restore_window requests that the size and position of a minimized or maximized window be
// restored.
//
// If the window is in a fullscreen state, this request has no direct effect.
// It may alter the state the window is returned to when leaving fullscreen.
//
// On some windowing systems this request is asynchronous and the new window
// state may not have have been applied immediately upon the return of this
// function. If an immediate change is required, call SDL_SyncWindow() to
// block until the changes have taken effect.
//
// When the window state changes, an SDL_EVENT_WINDOW_RESTORED event will be
// emitted. Note that, as this is just a request, the windowing system can
// deny the state change.
//
// `window` window the window to restore.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: maximize_window (SDL_MaximizeWindow)
// See also: minimize_window (SDL_MinimizeWindow)
// See also: sync_window (SDL_SyncWindow)
pub fn restore_window(window &Window) bool {
	return C.SDL_RestoreWindow(window)
}

// C.SDL_SetWindowFullscreen [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowFullscreen)
fn C.SDL_SetWindowFullscreen(window &Window, fullscreen bool) bool

// set_window_fullscreen requests that the window's fullscreen state be changed.
//
// By default a window in fullscreen state uses borderless fullscreen desktop
// mode, but a specific exclusive display mode can be set using
// SDL_SetWindowFullscreenMode().
//
// On some windowing systems this request is asynchronous and the new
// fullscreen state may not have have been applied immediately upon the return
// of this function. If an immediate change is required, call SDL_SyncWindow()
// to block until the changes have taken effect.
//
// When the window state changes, an SDL_EVENT_WINDOW_ENTER_FULLSCREEN or
// SDL_EVENT_WINDOW_LEAVE_FULLSCREEN event will be emitted. Note that, as this
// is just a request, it can be denied by the windowing system.
//
// `window` window the window to change.
// `fullscreen` fullscreen true for fullscreen mode, false for windowed mode.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_fullscreen_mode (SDL_GetWindowFullscreenMode)
// See also: set_window_fullscreen_mode (SDL_SetWindowFullscreenMode)
// See also: sync_window (SDL_SyncWindow)
// See also: windowfullscreen (SDL_WINDOW_FULLSCREEN)
pub fn set_window_fullscreen(window &Window, fullscreen bool) bool {
	return C.SDL_SetWindowFullscreen(window, fullscreen)
}

// C.SDL_SyncWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_SyncWindow)
fn C.SDL_SyncWindow(window &Window) bool

// sync_window blocks until any pending window state is finalized.
//
// On asynchronous windowing systems, this acts as a synchronization barrier
// for pending window state. It will attempt to wait until any pending window
// state has been applied and is guaranteed to return within finite time. Note
// that for how long it can potentially block depends on the underlying window
// system, as window state changes may involve somewhat lengthy animations
// that must complete before the window is in its final requested state.
//
// On windowing systems where changes are immediate, this does nothing.
//
// `window` window the window for which to wait for the pending state to be
//               applied.
// returns true on success or false if the operation timed out before the
//          window was in the requested state.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_size (SDL_SetWindowSize)
// See also: set_window_position (SDL_SetWindowPosition)
// See also: set_window_fullscreen (SDL_SetWindowFullscreen)
// See also: minimize_window (SDL_MinimizeWindow)
// See also: maximize_window (SDL_MaximizeWindow)
// See also: restore_window (SDL_RestoreWindow)
// See also: hintvideosyncwindowoperations (SDL_HINT_VIDEO_SYNC_WINDOW_OPERATIONS)
pub fn sync_window(window &Window) bool {
	return C.SDL_SyncWindow(window)
}

// C.SDL_WindowHasSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_WindowHasSurface)
fn C.SDL_WindowHasSurface(window &Window) bool

// window_has_surface returns whether the window has a surface associated with it.
//
// `window` window the window to query.
// returns true if there is a surface associated with the window, or false
//          otherwise.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_surface (SDL_GetWindowSurface)
pub fn window_has_surface(window &Window) bool {
	return C.SDL_WindowHasSurface(window)
}

// C.SDL_GetWindowSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowSurface)
fn C.SDL_GetWindowSurface(window &Window) &Surface

// get_window_surface gets the SDL surface associated with the window.
//
// A new surface will be created with the optimal format for the window, if
// necessary. This surface will be freed when the window is destroyed. Do not
// free this surface.
//
// This surface will be invalidated if the window is resized. After resizing a
// window this function must be called again to return a valid surface.
//
// You may not combine this with 3D or the rendering API on this window.
//
// This function is affected by `SDL_HINT_FRAMEBUFFER_ACCELERATION`.
//
// `window` window the window to query.
// returns the surface associated with the window, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_window_surface (SDL_DestroyWindowSurface)
// See also: window_has_surface (SDL_WindowHasSurface)
// See also: update_window_surface (SDL_UpdateWindowSurface)
// See also: update_window_surface_rects (SDL_UpdateWindowSurfaceRects)
pub fn get_window_surface(window &Window) &Surface {
	return C.SDL_GetWindowSurface(window)
}

// C.SDL_SetWindowSurfaceVSync [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowSurfaceVSync)
fn C.SDL_SetWindowSurfaceVSync(window &Window, vsync int) bool

// set_window_surface_v_sync toggles VSync for the window surface.
//
// When a window surface is created, vsync defaults to
// SDL_WINDOW_SURFACE_VSYNC_DISABLED.
//
// The `vsync` parameter can be 1 to synchronize present with every vertical
// refresh, 2 to synchronize present with every second vertical refresh, etc.,
// SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE for late swap tearing (adaptive vsync),
// or SDL_WINDOW_SURFACE_VSYNC_DISABLED to disable. Not every value is
// supported by every driver, so you should check the return value to see
// whether the requested setting is supported.
//
// `window` window the window.
// `vsync` vsync the vertical refresh sync interval.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_surface_v_sync (SDL_GetWindowSurfaceVSync)
pub fn set_window_surface_v_sync(window &Window, vsync int) bool {
	return C.SDL_SetWindowSurfaceVSync(window, vsync)
}

pub const window_surface_vsync_disabled = C.SDL_WINDOW_SURFACE_VSYNC_DISABLED // 0

pub const window_surface_vsync_adaptive = C.SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE // (-1)

// C.SDL_GetWindowSurfaceVSync [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowSurfaceVSync)
fn C.SDL_GetWindowSurfaceVSync(window &Window, vsync &int) bool

// get_window_surface_v_sync gets VSync for the window surface.
//
// `window` window the window to query.
// `vsync` vsync an int filled with the current vertical refresh sync interval.
//              See SDL_SetWindowSurfaceVSync() for the meaning of the value.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_surface_v_sync (SDL_SetWindowSurfaceVSync)
pub fn get_window_surface_v_sync(window &Window, vsync &int) bool {
	return C.SDL_GetWindowSurfaceVSync(window, vsync)
}

// C.SDL_UpdateWindowSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_UpdateWindowSurface)
fn C.SDL_UpdateWindowSurface(window &Window) bool

// update_window_surface copys the window surface to the screen.
//
// This is the function you use to reflect any changes to the surface on the
// screen.
//
// This function is equivalent to the SDL 1.2 API SDL_Flip().
//
// `window` window the window to update.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_surface (SDL_GetWindowSurface)
// See also: update_window_surface_rects (SDL_UpdateWindowSurfaceRects)
pub fn update_window_surface(window &Window) bool {
	return C.SDL_UpdateWindowSurface(window)
}

// C.SDL_UpdateWindowSurfaceRects [official documentation](https://wiki.libsdl.org/SDL3/SDL_UpdateWindowSurfaceRects)
fn C.SDL_UpdateWindowSurfaceRects(window &Window, const_rects &Rect, numrects int) bool

// update_window_surface_rects copys areas of the window surface to the screen.
//
// This is the function you use to reflect changes to portions of the surface
// on the screen.
//
// This function is equivalent to the SDL 1.2 API SDL_UpdateRects().
//
// Note that this function will update _at least_ the rectangles specified,
// but this is only intended as an optimization; in practice, this might
// update more of the screen (or all of the screen!), depending on what method
// SDL uses to send pixels to the system.
//
// `window` window the window to update.
// `rects` rects an array of SDL_Rect structures representing areas of the
//              surface to copy, in pixels.
// `numrects` numrects the number of rectangles.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_surface (SDL_GetWindowSurface)
// See also: update_window_surface (SDL_UpdateWindowSurface)
pub fn update_window_surface_rects(window &Window, const_rects &Rect, numrects int) bool {
	return C.SDL_UpdateWindowSurfaceRects(window, const_rects, numrects)
}

// C.SDL_DestroyWindowSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyWindowSurface)
fn C.SDL_DestroyWindowSurface(window &Window) bool

// destroy_window_surface destroys the surface associated with the window.
//
// `window` window the window to update.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_surface (SDL_GetWindowSurface)
// See also: window_has_surface (SDL_WindowHasSurface)
pub fn destroy_window_surface(window &Window) bool {
	return C.SDL_DestroyWindowSurface(window)
}

// C.SDL_SetWindowKeyboardGrab [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowKeyboardGrab)
fn C.SDL_SetWindowKeyboardGrab(window &Window, grabbed bool) bool

// set_window_keyboard_grab sets a window's keyboard grab mode.
//
// Keyboard grab enables capture of system keyboard shortcuts like Alt+Tab or
// the Meta/Super key. Note that not all system keyboard shortcuts can be
// captured by applications (one example is Ctrl+Alt+Del on Windows).
//
// This is primarily intended for specialized applications such as VNC clients
// or VM frontends. Normal games should not use keyboard grab.
//
// When keyboard grab is enabled, SDL will continue to handle Alt+Tab when the
// window is full-screen to ensure the user is not trapped in your
// application. If you have a custom keyboard shortcut to exit fullscreen
// mode, you may suppress this behavior with
// `SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED`.
//
// If the caller enables a grab while another window is currently grabbed, the
// other window loses its grab in favor of the caller's window.
//
// `window` window the window for which the keyboard grab mode should be set.
// `grabbed` grabbed this is true to grab keyboard, and false to release.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_keyboard_grab (SDL_GetWindowKeyboardGrab)
// See also: set_window_mouse_grab (SDL_SetWindowMouseGrab)
pub fn set_window_keyboard_grab(window &Window, grabbed bool) bool {
	return C.SDL_SetWindowKeyboardGrab(window, grabbed)
}

// C.SDL_SetWindowMouseGrab [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowMouseGrab)
fn C.SDL_SetWindowMouseGrab(window &Window, grabbed bool) bool

// set_window_mouse_grab sets a window's mouse grab mode.
//
// Mouse grab confines the mouse cursor to the window.
//
// `window` window the window for which the mouse grab mode should be set.
// `grabbed` grabbed this is true to grab mouse, and false to release.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_mouse_rect (SDL_GetWindowMouseRect)
// See also: set_window_mouse_rect (SDL_SetWindowMouseRect)
// See also: set_window_mouse_grab (SDL_SetWindowMouseGrab)
// See also: set_window_keyboard_grab (SDL_SetWindowKeyboardGrab)
pub fn set_window_mouse_grab(window &Window, grabbed bool) bool {
	return C.SDL_SetWindowMouseGrab(window, grabbed)
}

// C.SDL_GetWindowKeyboardGrab [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowKeyboardGrab)
fn C.SDL_GetWindowKeyboardGrab(window &Window) bool

// get_window_keyboard_grab gets a window's keyboard grab mode.
//
// `window` window the window to query.
// returns true if keyboard is grabbed, and false otherwise.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_keyboard_grab (SDL_SetWindowKeyboardGrab)
pub fn get_window_keyboard_grab(window &Window) bool {
	return C.SDL_GetWindowKeyboardGrab(window)
}

// C.SDL_GetWindowMouseGrab [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowMouseGrab)
fn C.SDL_GetWindowMouseGrab(window &Window) bool

// get_window_mouse_grab gets a window's mouse grab mode.
//
// `window` window the window to query.
// returns true if mouse is grabbed, and false otherwise.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_mouse_rect (SDL_GetWindowMouseRect)
// See also: set_window_mouse_rect (SDL_SetWindowMouseRect)
// See also: set_window_mouse_grab (SDL_SetWindowMouseGrab)
// See also: set_window_keyboard_grab (SDL_SetWindowKeyboardGrab)
pub fn get_window_mouse_grab(window &Window) bool {
	return C.SDL_GetWindowMouseGrab(window)
}

// C.SDL_GetGrabbedWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGrabbedWindow)
fn C.SDL_GetGrabbedWindow() &Window

// get_grabbed_window gets the window that currently has an input grab enabled.
//
// returns the window if input is grabbed or NULL otherwise.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_mouse_grab (SDL_SetWindowMouseGrab)
// See also: set_window_keyboard_grab (SDL_SetWindowKeyboardGrab)
pub fn get_grabbed_window() &Window {
	return C.SDL_GetGrabbedWindow()
}

// C.SDL_SetWindowMouseRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowMouseRect)
fn C.SDL_SetWindowMouseRect(window &Window, const_rect &Rect) bool

// set_window_mouse_rect confines the cursor to the specified area of a window.
//
// Note that this does NOT grab the cursor, it only defines the area a cursor
// is restricted to when the window has mouse focus.
//
// `window` window the window that will be associated with the barrier.
// `rect` rect a rectangle area in window-relative coordinates. If NULL the
//             barrier for the specified window will be destroyed.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_mouse_rect (SDL_GetWindowMouseRect)
// See also: get_window_mouse_grab (SDL_GetWindowMouseGrab)
// See also: set_window_mouse_grab (SDL_SetWindowMouseGrab)
pub fn set_window_mouse_rect(window &Window, const_rect &Rect) bool {
	return C.SDL_SetWindowMouseRect(window, const_rect)
}

// C.SDL_GetWindowMouseRect [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowMouseRect)
fn C.SDL_GetWindowMouseRect(window &Window) &Rect

// get_window_mouse_rect gets the mouse confinement rectangle of a window.
//
// `window` window the window to query.
// returns a pointer to the mouse confinement rectangle of a window, or NULL
//          if there isn't one.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_mouse_rect (SDL_SetWindowMouseRect)
// See also: get_window_mouse_grab (SDL_GetWindowMouseGrab)
// See also: set_window_mouse_grab (SDL_SetWindowMouseGrab)
pub fn get_window_mouse_rect(window &Window) &Rect {
	return C.SDL_GetWindowMouseRect(window)
}

// C.SDL_SetWindowOpacity [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowOpacity)
fn C.SDL_SetWindowOpacity(window &Window, opacity f32) bool

// set_window_opacity sets the opacity for a window.
//
// The parameter `opacity` will be clamped internally between 0.0f
// (transparent) and 1.0f (opaque).
//
// This function also returns false if setting the opacity isn't supported.
//
// `window` window the window which will be made transparent or opaque.
// `opacity` opacity the opacity value (0.0f - transparent, 1.0f - opaque).
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_window_opacity (SDL_GetWindowOpacity)
pub fn set_window_opacity(window &Window, opacity f32) bool {
	return C.SDL_SetWindowOpacity(window, opacity)
}

// C.SDL_GetWindowOpacity [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetWindowOpacity)
fn C.SDL_GetWindowOpacity(window &Window) f32

// get_window_opacity gets the opacity of a window.
//
// If transparency isn't supported on this platform, opacity will be returned
// as 1.0f without error.
//
// `window` window the window to get the current opacity value from.
// returns the opacity, (0.0f - transparent, 1.0f - opaque), or -1.0f on
//          failure; call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_opacity (SDL_SetWindowOpacity)
pub fn get_window_opacity(window &Window) f32 {
	return C.SDL_GetWindowOpacity(window)
}

// C.SDL_SetWindowParent [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowParent)
fn C.SDL_SetWindowParent(window &Window, parent &Window) bool

// set_window_parent sets the window as a child of a parent window.
//
// If the window is already the child of an existing window, it will be
// reparented to the new owner. Setting the parent window to NULL unparents
// the window and removes child window status.
//
// If a parent window is hidden or destroyed, the operation will be
// recursively applied to child windows. Child windows hidden with the parent
// that did not have their hidden status explicitly set will be restored when
// the parent is shown.
//
// Attempting to set the parent of a window that is currently in the modal
// state will fail. Use SDL_SetWindowModal() to cancel the modal status before
// attempting to change the parent.
//
// Popup windows cannot change parents and attempts to do so will fail.
//
// Setting a parent window that is currently the sibling or descendent of the
// child window results in undefined behavior.
//
// `window` window the window that should become the child of a parent.
// `parent` parent the new parent window for the child window.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_modal (SDL_SetWindowModal)
pub fn set_window_parent(window &Window, parent &Window) bool {
	return C.SDL_SetWindowParent(window, parent)
}

// C.SDL_SetWindowModal [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowModal)
fn C.SDL_SetWindowModal(window &Window, modal bool) bool

// set_window_modal toggles the state of the window as modal.
//
// To enable modal status on a window, the window must currently be the child
// window of a parent, or toggling modal status on will fail.
//
// `window` window the window on which to set the modal state.
// `modal` modal true to toggle modal status on, false to toggle it off.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_window_parent (SDL_SetWindowParent)
// See also: windowmodal (SDL_WINDOW_MODAL)
pub fn set_window_modal(window &Window, modal bool) bool {
	return C.SDL_SetWindowModal(window, modal)
}

// C.SDL_SetWindowFocusable [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowFocusable)
fn C.SDL_SetWindowFocusable(window &Window, focusable bool) bool

// set_window_focusable sets whether the window may have input focus.
//
// `window` window the window to set focusable state.
// `focusable` focusable true to allow input focus, false to not allow input focus.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_window_focusable(window &Window, focusable bool) bool {
	return C.SDL_SetWindowFocusable(window, focusable)
}

// C.SDL_ShowWindowSystemMenu [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShowWindowSystemMenu)
fn C.SDL_ShowWindowSystemMenu(window &Window, x int, y int) bool

// show_window_system_menu displays the system-level window menu.
//
// This default window menu is provided by the system and on some platforms
// provides functionality for setting or changing privileged state on the
// window, such as moving it between workspaces or displays, or toggling the
// always-on-top property.
//
// On platforms or desktops where this is unsupported, this function does
// nothing.
//
// `window` window the window for which the menu will be displayed.
// `x` x the x coordinate of the menu, relative to the origin (top-left) of
//          the client area.
// `y` y the y coordinate of the menu, relative to the origin (top-left) of
//          the client area.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn show_window_system_menu(window &Window, x int, y int) bool {
	return C.SDL_ShowWindowSystemMenu(window, x, y)
}

// HitTestResult is C.SDL_HitTestResult
pub enum HitTestResult {
	normal             = C.SDL_HITTEST_NORMAL             // `normal` Region is normal. No special properties.
	draggable          = C.SDL_HITTEST_DRAGGABLE          // `draggable` Region can drag entire window.
	resize_topleft     = C.SDL_HITTEST_RESIZE_TOPLEFT     // `resize_topleft` Region is the resizable top-left corner border.
	resize_top         = C.SDL_HITTEST_RESIZE_TOP         // `resize_top` Region is the resizable top border.
	resize_topright    = C.SDL_HITTEST_RESIZE_TOPRIGHT    // `resize_topright` Region is the resizable top-right corner border.
	resize_right       = C.SDL_HITTEST_RESIZE_RIGHT       // `resize_right` Region is the resizable right border.
	resize_bottomright = C.SDL_HITTEST_RESIZE_BOTTOMRIGHT // `resize_bottomright` Region is the resizable bottom-right corner border.
	resize_bottom      = C.SDL_HITTEST_RESIZE_BOTTOM      // `resize_bottom` Region is the resizable bottom border.
	resize_bottomleft  = C.SDL_HITTEST_RESIZE_BOTTOMLEFT  // `resize_bottomleft` Region is the resizable bottom-left corner border.
	resize_left        = C.SDL_HITTEST_RESIZE_LEFT        // `resize_left` Region is the resizable left border.
}

// Callback used for hit-testing.
//
// `win` the SDL_Window where hit-testing was set on
// `area` an SDL_Point which should be hit-tested
// `data` what was passed as `callback_data` to SDL_SetWindowHitTest()
// returns an SDL_HitTestResult value.
//
// See also: SDL_SetWindowHitTest
//
// C.SDL_HitTest [official documentation](https://wiki.libsdl.org/SDL3/SDL_HitTest)
pub type HitTest = fn (win &Window, const_area &Point, data voidptr) HitTestResult

// C.SDL_SetWindowHitTest [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowHitTest)
fn C.SDL_SetWindowHitTest(window &Window, callback HitTest, callback_data voidptr) bool

// set_window_hit_test provides a callback that decides if a window region has special properties.
//
// Normally windows are dragged and resized by decorations provided by the
// system window manager (a title bar, borders, etc), but for some apps, it
// makes sense to drag them from somewhere else inside the window itself; for
// example, one might have a borderless window that wants to be draggable from
// any part, or simulate its own title bar, etc.
//
// This function lets the app provide a callback that designates pieces of a
// given window as special. This callback is run during event processing if we
// need to tell the OS to treat a region of the window specially; the use of
// this callback is known as "hit testing."
//
// Mouse input may not be delivered to your application if it is within a
// special area; the OS will often apply that input to moving the window or
// resizing the window and not deliver it to the application.
//
// Specifying NULL for a callback disables hit-testing. Hit-testing is
// disabled by default.
//
// Platforms that don't support this functionality will return false
// unconditionally, even if you're attempting to disable hit-testing.
//
// Your callback may fire at any time, and its firing does not indicate any
// specific behavior (for example, on Windows, this certainly might fire when
// the OS is deciding whether to drag your window, but it fires for lots of
// other reasons, too, some unrelated to anything you probably care about _and
// when the mouse isn't actually at the location it is testing_). Since this
// can fire at any time, you should try to keep your callback efficient,
// devoid of allocations, etc.
//
// `window` window the window to set hit-testing on.
// `callback` callback the function to call when doing a hit-test.
// `callback_data` callback_data an app-defined void pointer passed to **callback**.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_window_hit_test(window &Window, callback HitTest, callback_data voidptr) bool {
	return C.SDL_SetWindowHitTest(window, callback, callback_data)
}

// C.SDL_SetWindowShape [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetWindowShape)
fn C.SDL_SetWindowShape(window &Window, shape &Surface) bool

// set_window_shape sets the shape of a transparent window.
//
// This sets the alpha channel of a transparent window and any fully
// transparent areas are also transparent to mouse clicks. If you are using
// something besides the SDL render API, then you are responsible for drawing
// the alpha channel of the window to match the shape alpha channel to get
// consistent cross-platform results.
//
// The shape is copied inside this function, so you can free it afterwards. If
// your shape surface changes, you should call SDL_SetWindowShape() again to
// update the window. This is an expensive operation, so should be done
// sparingly.
//
// The window must have been created with the SDL_WINDOW_TRANSPARENT flag.
//
// `window` window the window.
// `shape` shape the surface representing the shape of the window, or NULL to
//              remove any current shape.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_window_shape(window &Window, shape &Surface) bool {
	return C.SDL_SetWindowShape(window, shape)
}

// C.SDL_FlashWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_FlashWindow)
fn C.SDL_FlashWindow(window &Window, operation FlashOperation) bool

// flash_window requests a window to demand attention from the user.
//
// `window` window the window to be flashed.
// `operation` operation the operation to perform.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn flash_window(window &Window, operation FlashOperation) bool {
	return C.SDL_FlashWindow(window, operation)
}

// C.SDL_DestroyWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyWindow)
fn C.SDL_DestroyWindow(window &Window)

// destroy_window destroys a window.
//
// Any child windows owned by the window will be recursively destroyed as
// well.
//
// Note that on some platforms, the visible window may not actually be removed
// from the screen until the SDL event loop is pumped again, even though the
// SDL_Window is no longer valid after this call.
//
// `window` window the window to destroy.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_popup_window (SDL_CreatePopupWindow)
// See also: create_window (SDL_CreateWindow)
// See also: create_window_with_properties (SDL_CreateWindowWithProperties)
pub fn destroy_window(window &Window) {
	C.SDL_DestroyWindow(window)
}

// C.SDL_ScreenSaverEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_ScreenSaverEnabled)
fn C.SDL_ScreenSaverEnabled() bool

// screen_saver_enabled checks whether the screensaver is currently enabled.
//
// The screensaver is disabled by default.
//
// The default can also be changed using `SDL_HINT_VIDEO_ALLOW_SCREENSAVER`.
//
// returns true if the screensaver is enabled, false if it is disabled.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: disable_screen_saver (SDL_DisableScreenSaver)
// See also: enable_screen_saver (SDL_EnableScreenSaver)
pub fn screen_saver_enabled() bool {
	return C.SDL_ScreenSaverEnabled()
}

// C.SDL_EnableScreenSaver [official documentation](https://wiki.libsdl.org/SDL3/SDL_EnableScreenSaver)
fn C.SDL_EnableScreenSaver() bool

// enable_screen_saver allows the screen to be blanked by a screen saver.
//
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: disable_screen_saver (SDL_DisableScreenSaver)
// See also: screen_saver_enabled (SDL_ScreenSaverEnabled)
pub fn enable_screen_saver() bool {
	return C.SDL_EnableScreenSaver()
}

// C.SDL_DisableScreenSaver [official documentation](https://wiki.libsdl.org/SDL3/SDL_DisableScreenSaver)
fn C.SDL_DisableScreenSaver() bool

// disable_screen_saver prevents the screen from being blanked by a screen saver.
//
// If you disable the screensaver, it is automatically re-enabled when SDL
// quits.
//
// The screensaver is disabled by default, but this may by changed by
// SDL_HINT_VIDEO_ALLOW_SCREENSAVER.
//
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: enable_screen_saver (SDL_EnableScreenSaver)
// See also: screen_saver_enabled (SDL_ScreenSaverEnabled)
pub fn disable_screen_saver() bool {
	return C.SDL_DisableScreenSaver()
}

// C.SDL_GL_LoadLibrary [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_LoadLibrary)
fn C.SDL_GL_LoadLibrary(const_path &char) bool

// gl_load_library dynamicallys load an OpenGL library.
//
// This should be done after initializing the video driver, but before
// creating any OpenGL windows. If no OpenGL library is loaded, the default
// library will be loaded upon creation of the first OpenGL window.
//
// If you do this, you need to retrieve all of the GL functions used in your
// program from the dynamic library using SDL_GL_GetProcAddress().
//
// `path` path the platform dependent OpenGL library name, or NULL to open the
//             default OpenGL library.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_get_proc_address (SDL_GL_GetProcAddress)
// See also: gl_unload_library (SDL_GL_UnloadLibrary)
pub fn gl_load_library(const_path &char) bool {
	return C.SDL_GL_LoadLibrary(const_path)
}

// C.SDL_GL_GetProcAddress [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_GetProcAddress)
fn C.SDL_GL_GetProcAddress(const_proc &char) FunctionPointer

// gl_get_proc_address gets an OpenGL function by name.
//
// If the GL library is loaded at runtime with SDL_GL_LoadLibrary(), then all
// GL functions must be retrieved this way. Usually this is used to retrieve
// function pointers to OpenGL extensions.
//
// There are some quirks to looking up OpenGL functions that require some
// extra care from the application. If you code carefully, you can handle
// these quirks without any platform-specific code, though:
//
// - On Windows, function pointers are specific to the current GL context;
//   this means you need to have created a GL context and made it current
//   before calling SDL_GL_GetProcAddress(). If you recreate your context or
//   create a second context, you should assume that any existing function
//   pointers aren't valid to use with it. This is (currently) a
//   Windows-specific limitation, and in practice lots of drivers don't suffer
//   this limitation, but it is still the way the wgl API is documented to
//   work and you should expect crashes if you don't respect it. Store a copy
//   of the function pointers that comes and goes with context lifespan.
// - On X11, function pointers returned by this function are valid for any
//   context, and can even be looked up before a context is created at all.
//   This means that, for at least some common OpenGL implementations, if you
//   look up a function that doesn't exist, you'll get a non-NULL result that
//   is _NOT_ safe to call. You must always make sure the function is actually
//   available for a given GL context before calling it, by checking for the
//   existence of the appropriate extension with SDL_GL_ExtensionSupported(),
//   or verifying that the version of OpenGL you're using offers the function
//   as core functionality.
// - Some OpenGL drivers, on all platforms, *will* return NULL if a function
//   isn't supported, but you can't count on this behavior. Check for
//   extensions you use, and if you get a NULL anyway, act as if that
//   extension wasn't available. This is probably a bug in the driver, but you
//   can code defensively for this scenario anyhow.
// - Just because you're on Linux/Unix, don't assume you'll be using X11.
//   Next-gen display servers are waiting to replace it, and may or may not
//   make the same promises about function pointers.
// - OpenGL function pointers must be declared `APIENTRY` as in the example
//   code. This will ensure the proper calling convention is followed on
//   platforms where this matters (Win32) thereby avoiding stack corruption.
//
// `proc` proc the name of an OpenGL function.
// returns a pointer to the named OpenGL function. The returned pointer
//          should be cast to the appropriate function signature.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_extension_supported (SDL_GL_ExtensionSupported)
// See also: gl_load_library (SDL_GL_LoadLibrary)
// See also: gl_unload_library (SDL_GL_UnloadLibrary)
pub fn gl_get_proc_address(const_proc &char) FunctionPointer {
	return C.SDL_GL_GetProcAddress(const_proc)
}

// C.SDL_EGL_GetProcAddress [official documentation](https://wiki.libsdl.org/SDL3/SDL_EGL_GetProcAddress)
fn C.SDL_EGL_GetProcAddress(const_proc &char) FunctionPointer

// egl_get_proc_address gets an EGL library function by name.
//
// If an EGL library is loaded, this function allows applications to get entry
// points for EGL functions. This is useful to provide to an EGL API and
// extension loader.
//
// `proc` proc the name of an EGL function.
// returns a pointer to the named EGL function. The returned pointer should
//          be cast to the appropriate function signature.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: egl_get_current_display (SDL_EGL_GetCurrentDisplay)
pub fn egl_get_proc_address(const_proc &char) FunctionPointer {
	return C.SDL_EGL_GetProcAddress(const_proc)
}

// C.SDL_GL_UnloadLibrary [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_UnloadLibrary)
fn C.SDL_GL_UnloadLibrary()

// gl_unload_library unloads the OpenGL library previously loaded by SDL_GL_LoadLibrary().
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_load_library (SDL_GL_LoadLibrary)
pub fn gl_unload_library() {
	C.SDL_GL_UnloadLibrary()
}

// C.SDL_GL_ExtensionSupported [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_ExtensionSupported)
fn C.SDL_GL_ExtensionSupported(const_extension &char) bool

// gl_extension_supported checks if an OpenGL extension is supported for the current context.
//
// This function operates on the current GL context; you must have created a
// context and it must be current before calling this function. Do not assume
// that all contexts you create will have the same set of extensions
// available, or that recreating an existing context will offer the same
// extensions again.
//
// While it's probably not a massive overhead, this function is not an O(1)
// operation. Check the extensions you care about after creating the GL
// context and save that information somewhere instead of calling the function
// every time you need to know.
//
// `extension` extension the name of the extension to check.
// returns true if the extension is supported, false otherwise.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn gl_extension_supported(const_extension &char) bool {
	return C.SDL_GL_ExtensionSupported(const_extension)
}

// C.SDL_GL_ResetAttributes [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_ResetAttributes)
fn C.SDL_GL_ResetAttributes()

// gl_reset_attributes resets all previously set OpenGL context attributes to their default values.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_get_attribute (SDL_GL_GetAttribute)
// See also: gl_set_attribute (SDL_GL_SetAttribute)
pub fn gl_reset_attributes() {
	C.SDL_GL_ResetAttributes()
}

// C.SDL_GL_SetAttribute [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_SetAttribute)
fn C.SDL_GL_SetAttribute(attr GLAttr, value int) bool

// gl_set_attribute sets an OpenGL window attribute before window creation.
//
// This function sets the OpenGL attribute `attr` to `value`. The requested
// attributes should be set before creating an OpenGL window. You should use
// SDL_GL_GetAttribute() to check the values after creating the OpenGL
// context, since the values obtained can differ from the requested ones.
//
// `attr` attr an SDL_GLAttr enum value specifying the OpenGL attribute to
//             set.
// `value` value the desired value for the attribute.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_get_attribute (SDL_GL_GetAttribute)
// See also: gl_reset_attributes (SDL_GL_ResetAttributes)
pub fn gl_set_attribute(attr GLAttr, value int) bool {
	return C.SDL_GL_SetAttribute(attr, value)
}

// C.SDL_GL_GetAttribute [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_GetAttribute)
fn C.SDL_GL_GetAttribute(attr GLAttr, value &int) bool

// gl_get_attribute gets the actual value for an attribute from the current context.
//
// `attr` attr an SDL_GLAttr enum value specifying the OpenGL attribute to
//             get.
// `value` value a pointer filled in with the current value of `attr`.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_reset_attributes (SDL_GL_ResetAttributes)
// See also: gl_set_attribute (SDL_GL_SetAttribute)
pub fn gl_get_attribute(attr GLAttr, value &int) bool {
	return C.SDL_GL_GetAttribute(attr, value)
}

// C.SDL_GL_CreateContext [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_CreateContext)
fn C.SDL_GL_CreateContext(window &Window) GLContext

// gl_create_context creates an OpenGL context for an OpenGL window, and make it current.
//
// Windows users new to OpenGL should note that, for historical reasons, GL
// functions added after OpenGL version 1.1 are not available by default.
// Those functions must be loaded at run-time, either with an OpenGL
// extension-handling library or with SDL_GL_GetProcAddress() and its related
// functions.
//
// SDL_GLContext is opaque to the application.
//
// `window` window the window to associate with the context.
// returns the OpenGL context associated with `window` or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_destroy_context (SDL_GL_DestroyContext)
// See also: gl_make_current (SDL_GL_MakeCurrent)
pub fn gl_create_context(window &Window) GLContext {
	return C.SDL_GL_CreateContext(window)
}

// C.SDL_GL_MakeCurrent [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_MakeCurrent)
fn C.SDL_GL_MakeCurrent(window &Window, context GLContext) bool

// gl_make_current sets up an OpenGL context for rendering into an OpenGL window.
//
// The context must have been created with a compatible window.
//
// `window` window the window to associate with the context.
// `context` context the OpenGL context to associate with the window.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_create_context (SDL_GL_CreateContext)
pub fn gl_make_current(window &Window, context GLContext) bool {
	return C.SDL_GL_MakeCurrent(window, context)
}

// C.SDL_GL_GetCurrentWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_GetCurrentWindow)
fn C.SDL_GL_GetCurrentWindow() &Window

// gl_get_current_window gets the currently active OpenGL window.
//
// returns the currently active OpenGL window on success or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn gl_get_current_window() &Window {
	return C.SDL_GL_GetCurrentWindow()
}

// C.SDL_GL_GetCurrentContext [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_GetCurrentContext)
fn C.SDL_GL_GetCurrentContext() GLContext

// gl_get_current_context gets the currently active OpenGL context.
//
// returns the currently active OpenGL context or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_make_current (SDL_GL_MakeCurrent)
pub fn gl_get_current_context() GLContext {
	return C.SDL_GL_GetCurrentContext()
}

// C.SDL_EGL_GetCurrentDisplay [official documentation](https://wiki.libsdl.org/SDL3/SDL_EGL_GetCurrentDisplay)
fn C.SDL_EGL_GetCurrentDisplay() EGLDisplay

// egl_get_current_display gets the currently active EGL display.
//
// returns the currently active EGL display or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn egl_get_current_display() EGLDisplay {
	return C.SDL_EGL_GetCurrentDisplay()
}

// C.SDL_EGL_GetCurrentConfig [official documentation](https://wiki.libsdl.org/SDL3/SDL_EGL_GetCurrentConfig)
fn C.SDL_EGL_GetCurrentConfig() EGLConfig

// egl_get_current_config gets the currently active EGL config.
//
// returns the currently active EGL config or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn egl_get_current_config() EGLConfig {
	return C.SDL_EGL_GetCurrentConfig()
}

// C.SDL_EGL_GetWindowSurface [official documentation](https://wiki.libsdl.org/SDL3/SDL_EGL_GetWindowSurface)
fn C.SDL_EGL_GetWindowSurface(window &Window) EGLSurface

// egl_get_window_surface gets the EGL surface associated with the window.
//
// `window` window the window to query.
// returns the EGLSurface pointer associated with the window, or NULL on
//          failure.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn egl_get_window_surface(window &Window) EGLSurface {
	return C.SDL_EGL_GetWindowSurface(window)
}

// C.SDL_EGL_SetAttributeCallbacks [official documentation](https://wiki.libsdl.org/SDL3/SDL_EGL_SetAttributeCallbacks)
fn C.SDL_EGL_SetAttributeCallbacks(platform_attrib_callback EGLAttribArrayCallback, surface_attrib_callback EGLIntArrayCallback, context_attrib_callback EGLIntArrayCallback, userdata voidptr)

// egl_set_attribute_callbacks sets the callbacks for defining custom EGLAttrib arrays for EGL
// initialization.
//
// Callbacks that aren't needed can be set to NULL.
//
// NOTE: These callback pointers will be reset after SDL_GL_ResetAttributes.
//
// `platform_attrib_callback` platformAttribCallback callback for attributes to pass to
//                               eglGetPlatformDisplay. May be NULL.
// `surface_attrib_callback` surfaceAttribCallback callback for attributes to pass to
//                              eglCreateSurface. May be NULL.
// `context_attrib_callback` contextAttribCallback callback for attributes to pass to
//                              eglCreateContext. May be NULL.
// `userdata` userdata a pointer that is passed to the callbacks.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn egl_set_attribute_callbacks(platform_attrib_callback EGLAttribArrayCallback, surface_attrib_callback EGLIntArrayCallback, context_attrib_callback EGLIntArrayCallback, userdata voidptr) {
	C.SDL_EGL_SetAttributeCallbacks(platform_attrib_callback, surface_attrib_callback,
		context_attrib_callback, userdata)
}

// C.SDL_GL_SetSwapInterval [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_SetSwapInterval)
fn C.SDL_GL_SetSwapInterval(interval int) bool

// gl_set_swap_interval sets the swap interval for the current OpenGL context.
//
// Some systems allow specifying -1 for the interval, to enable adaptive
// vsync. Adaptive vsync works the same as vsync, but if you've already missed
// the vertical retrace for a given frame, it swaps buffers immediately, which
// might be less jarring for the user during occasional framerate drops. If an
// application requests adaptive vsync and the system does not support it,
// this function will fail and return false. In such a case, you should
// probably retry the call with 1 for the interval.
//
// Adaptive vsync is implemented for some glX drivers with
// GLX_EXT_swap_control_tear, and for some Windows drivers with
// WGL_EXT_swap_control_tear.
//
// Read more on the Khronos wiki:
// https://www.khronos.org/opengl/wiki/Swap_Interval#Adaptive_Vsync
//
// `interval` interval 0 for immediate updates, 1 for updates synchronized with
//                 the vertical retrace, -1 for adaptive vsync.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_get_swap_interval (SDL_GL_GetSwapInterval)
pub fn gl_set_swap_interval(interval int) bool {
	return C.SDL_GL_SetSwapInterval(interval)
}

// C.SDL_GL_GetSwapInterval [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_GetSwapInterval)
fn C.SDL_GL_GetSwapInterval(interval &int) bool

// gl_get_swap_interval gets the swap interval for the current OpenGL context.
//
// If the system can't determine the swap interval, or there isn't a valid
// current context, this function will set *interval to 0 as a safe default.
//
// `interval` interval output interval value. 0 if there is no vertical retrace
//                 synchronization, 1 if the buffer swap is synchronized with
//                 the vertical retrace, and -1 if late swaps happen
//                 immediately instead of waiting for the next retrace.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_set_swap_interval (SDL_GL_SetSwapInterval)
pub fn gl_get_swap_interval(interval &int) bool {
	return C.SDL_GL_GetSwapInterval(interval)
}

// C.SDL_GL_SwapWindow [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_SwapWindow)
fn C.SDL_GL_SwapWindow(window &Window) bool

// gl_swap_window updates a window with OpenGL rendering.
//
// This is used with double-buffered OpenGL contexts, which are the default.
//
// On macOS, make sure you bind 0 to the draw framebuffer before swapping the
// window, otherwise nothing will happen. If you aren't using
// glBindFramebuffer(), this is the default and you won't have to do anything
// extra.
//
// `window` window the window to change.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn gl_swap_window(window &Window) bool {
	return C.SDL_GL_SwapWindow(window)
}

// C.SDL_GL_DestroyContext [official documentation](https://wiki.libsdl.org/SDL3/SDL_GL_DestroyContext)
fn C.SDL_GL_DestroyContext(context GLContext) bool

// gl_destroy_context deletes an OpenGL context.
//
// `context` context the OpenGL context to be deleted.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: gl_create_context (SDL_GL_CreateContext)
pub fn gl_destroy_context(context GLContext) bool {
	return C.SDL_GL_DestroyContext(context)
}
