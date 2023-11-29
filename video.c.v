// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_video.h
//

// DisplayMode is the structure that defines a display mode
//
// See also: SDL_GetNumDisplayModes()
// See also: SDL_GetDisplayMode()
// See also: SDL_GetDesktopDisplayMode()
// See also: SDL_GetCurrentDisplayMode()
// See also: SDL_GetClosestDisplayMode()
// See also: SDL_SetWindowDisplayMode()
// See also: SDL_GetWindowDisplayMode()
@[typedef]
pub struct C.SDL_DisplayMode {
pub:
	format       u32     // pixel format
	w            int     // width, in screen coordinates
	h            int     // height, in screen coordinates
	refresh_rate int     // refresh rate (or zero for unspecified)
	driverdata   voidptr // driver-specific data, initialize to 0
}

pub type DisplayMode = C.SDL_DisplayMode

// Window is the type used to identify a window
//
// See also: SDL_CreateWindow()
// See also: SDL_CreateWindowFrom()
// See also: SDL_DestroyWindow()
// See also: SDL_FlashWindow()
// See also: SDL_GetWindowData()
// See also: SDL_GetWindowFlags()
// See also: SDL_GetWindowGrab()
// See also: SDL_GetWindowKeyboardGrab()
// See also: SDL_GetWindowMouseGrab()
// See also: SDL_GetWindowPosition()
// See also: SDL_GetWindowSize()
// See also: SDL_GetWindowTitle()
// See also: SDL_HideWindow()
// See also: SDL_MaximizeWindow()
// See also: SDL_MinimizeWindow()
// See also: SDL_RaiseWindow()
// See also: SDL_RestoreWindow()
// See also: SDL_SetWindowData()
// See also: SDL_SetWindowFullscreen()
// See also: SDL_SetWindowGrab()
// See also: SDL_SetWindowKeyboardGrab()
// See also: SDL_SetWindowMouseGrab()
// See also: SDL_SetWindowIcon()
// See also: SDL_SetWindowPosition()
// See also: SDL_SetWindowSize()
// See also: SDL_SetWindowBordered()
// See also: SDL_SetWindowResizable()
// See also: SDL_SetWindowTitle()
// See also: SDL_ShowWindow()
//
@[typedef]
pub struct C.SDL_Window {
}

pub type Window = C.SDL_Window

// WindowFlags is the flags on a window
//
// See also: SDL_GetWindowFlags()
//
// WindowFlags is C.SDL_WindowFlags
pub enum WindowFlags {
	fullscreen         = C.SDL_WINDOW_FULLSCREEN // 0x00000001 fullscreen window
	opengl             = C.SDL_WINDOW_OPENGL // 0x00000002 window usable with OpenGL context
	shown              = C.SDL_WINDOW_SHOWN // 0x00000004 window is visible
	hidden             = C.SDL_WINDOW_HIDDEN // 0x00000008 window is not visible
	borderless         = C.SDL_WINDOW_BORDERLESS // 0x00000010 no window decoration
	resizable          = C.SDL_WINDOW_RESIZABLE // 0x00000020 window can be resized
	minimized          = C.SDL_WINDOW_MINIMIZED // 0x00000040 window is minimized
	maximized          = C.SDL_WINDOW_MAXIMIZED // 0x00000080 window is maximized
	mouse_grabbed      = C.SDL_WINDOW_MOUSE_GRABBED // 0x00000100 window has grabbed mouse input
	input_focus        = C.SDL_WINDOW_INPUT_FOCUS // 0x00000200 window has input focus
	mouse_focus        = C.SDL_WINDOW_MOUSE_FOCUS // 0x00000400 window has mouse focus
	fullscreen_desktop = C.SDL_WINDOW_FULLSCREEN_DESKTOP // ( SDL_WINDOW_FULLSCREEN | 0x00001000 )
	foreign            = C.SDL_WINDOW_FOREIGN // 0x00000800 window not created by SDL
	allow_highdpi      = C.SDL_WINDOW_ALLOW_HIGHDPI // 0x00002000 window should be created in high-DPI mode if supported. On macOS NSHighResolutionCapable must be set true in the application's Info.plist for this to have any effect.
	mouse_capture      = C.SDL_WINDOW_MOUSE_CAPTURE // 0x00004000 window has mouse captured (unrelated to MOUSE_GRABBED)
	always_on_top      = C.SDL_WINDOW_ALWAYS_ON_TOP // 0x00008000 window should always be above others
	skip_taskbar       = C.SDL_WINDOW_SKIP_TASKBAR // 0x00010000 window should not be added to the taskbar
	utility            = C.SDL_WINDOW_UTILITY // 0x00020000 window should be treated as a utility window
	tooltip            = C.SDL_WINDOW_TOOLTIP // 0x00040000 window should be treated as a tooltip
	popup_menu         = C.SDL_WINDOW_POPUP_MENU // 0x00080000 window should be treated as a popup menu
	vulkan             = C.SDL_WINDOW_VULKAN // 0x10000000 window usable for Vulkan surface
	metal              = C.SDL_WINDOW_METAL // 0x20000000 window usable for Metal view
	//
	input_grabbed      = C.SDL_WINDOW_MOUSE_GRABBED // equivalent to SDL_WINDOW_MOUSE_GRABBED for compatibility
}

// Used to indicate that you don't care what the window position is.
pub const windowpos_undefined_mask = C.SDL_WINDOWPOS_UNDEFINED_MASK //   0x1FFF0000u

pub const windowpos_undefined = C.SDL_WINDOWPOS_UNDEFINED //

fn C.SDL_WINDOWPOS_ISUNDEFINED(x u32) bool
pub fn windowpos_isundefined(x u32) bool {
	return C.SDL_WINDOWPOS_ISUNDEFINED(x)
}

fn C.SDL_WINDOWPOS_UNDEFINED_DISPLAY(x u32) u32
pub fn windowpos_undefined_display(x u32) u32 {
	return C.SDL_WINDOWPOS_UNDEFINED_DISPLAY(x)
}

// Used to indicate that the window position should be centered.
pub const windowpos_centered_mask = C.SDL_WINDOWPOS_CENTERED_MASK // 0x2FFF0000u

pub const windowpos_centered = C.SDL_WINDOWPOS_CENTERED

fn C.SDL_WINDOWPOS_CENTERED_DISPLAY(x u32) u32
pub fn windowpos_centered_display(x u32) u32 {
	return C.SDL_WINDOWPOS_CENTERED_DISPLAY(x)
}

fn C.SDL_WINDOWPOS_ISCENTERED(x u32) bool
pub fn windowpos_iscentered(x u32) bool {
	return C.SDL_WINDOWPOS_ISCENTERED(x)
}

// WindowEventID is an event subtype for window events
//
// WindowEventID is C.SDL_WindowEventID
pub enum WindowEventID {
	@none           = C.SDL_WINDOWEVENT_NONE // Never used
	shown           = C.SDL_WINDOWEVENT_SHOWN // Window has been shown
	hidden          = C.SDL_WINDOWEVENT_HIDDEN // Window has been hidden
	exposed         = C.SDL_WINDOWEVENT_EXPOSED // Window has been exposed and should be redrawn
	moved           = C.SDL_WINDOWEVENT_MOVED // Window has been moved to data1, data2
	resized         = C.SDL_WINDOWEVENT_RESIZED // Window has been resized to data1xdata2
	size_changed    = C.SDL_WINDOWEVENT_SIZE_CHANGED // The window size has changed, either as a result of an API call or through the system or user changing the window size.
	minimized       = C.SDL_WINDOWEVENT_MINIMIZED // Window has been minimized
	maximized       = C.SDL_WINDOWEVENT_MAXIMIZED // Window has been maximized
	restored        = C.SDL_WINDOWEVENT_RESTORED // Window has been restored to normal size and position
	enter           = C.SDL_WINDOWEVENT_ENTER // Window has gained mouse focus
	leave           = C.SDL_WINDOWEVENT_LEAVE // Window has lost mouse focus
	focus_gained    = C.SDL_WINDOWEVENT_FOCUS_GAINED // Window has gained keyboard focus
	focus_lost      = C.SDL_WINDOWEVENT_FOCUS_LOST // Window has lost keyboard focus
	close           = C.SDL_WINDOWEVENT_CLOSE // The window manager requests that the window be closed
	take_focus      = C.SDL_WINDOWEVENT_TAKE_FOCUS // Window is being offered a focus (should SetWindowInputFocus() on itself or a subwindow, or ignore)
	hit_test        = C.SDL_WINDOWEVENT_HIT_TEST // Window had a hit test that wasn't SDL_HITTEST_NORMAL.
	iccprof_changed = C.SDL_WINDOWEVENT_ICCPROF_CHANGED // The ICC profile of the window's display has changed.
	display_changed = C.SDL_WINDOWEVENT_DISPLAY_CHANGED // Window has been moved to display data1.
}

// DisplayEventID is an event subtype for display events
// DisplayEventID is C.SDL_DisplayEventID
pub enum DisplayEventID {
	@none        = C.SDL_DISPLAYEVENT_NONE // Never used
	orientation  = C.SDL_DISPLAYEVENT_ORIENTATION // Display orientation has changed to data1
	connected    = C.SDL_DISPLAYEVENT_CONNECTED // Display has been added to the system
	disconnected = C.SDL_DISPLAYEVENT_DISCONNECTED // Display has been removed from the system
}

// Display orientation
// DisplayOrientation is C.SDL_DisplayOrientation
pub enum DisplayOrientation {
	unknown           = C.SDL_ORIENTATION_UNKNOWN // The display orientation can't be determined
	landscape         = C.SDL_ORIENTATION_LANDSCAPE // The display is in landscape mode, with the right side up, relative to portrait mode
	landscape_flipped = C.SDL_ORIENTATION_LANDSCAPE_FLIPPED // The display is in landscape mode, with the left side up, relative to portrait mode
	portrait          = C.SDL_ORIENTATION_PORTRAIT // The display is in portrait mode
	portrait_flipped  = C.SDL_ORIENTATION_PORTRAIT_FLIPPED // The display is in portrait mode, upside down
}

// Window flash operation
// FlashOperation is SDL_FlashOperation
pub enum FlashOperation {
	cancel        = C.SDL_FLASH_CANCEL // Cancel any window flash state
	briefly       = C.SDL_FLASH_BRIEFLY // Flash the window briefly to get attention
	until_focused = C.SDL_FLASH_UNTIL_FOCUSED // Flash the window until it gets focus
}

// typedef void *SDL_GLContext;
// type C.SDL_GLContext = voidptr // <- We can't do this in V  0.2.4 54b0a2a
// GLContext is an opaque handle to an OpenGL context.
// GLContext is C.SDL_GLContext
pub type GLContext = voidptr

// GLattr is OpenGL configuration attributes
// GLattr is C.SDL_GLattr
pub enum GLattr {
	red_size                   = C.SDL_GL_RED_SIZE
	green_size                 = C.SDL_GL_GREEN_SIZE
	blue_size                  = C.SDL_GL_BLUE_SIZE
	alpha_size                 = C.SDL_GL_ALPHA_SIZE
	buffer_size                = C.SDL_GL_BUFFER_SIZE
	doublebuffer               = C.SDL_GL_DOUBLEBUFFER
	depth_size                 = C.SDL_GL_DEPTH_SIZE
	stencil_size               = C.SDL_GL_STENCIL_SIZE
	accum_red_size             = C.SDL_GL_ACCUM_RED_SIZE
	accum_green_size           = C.SDL_GL_ACCUM_GREEN_SIZE
	accum_blue_size            = C.SDL_GL_ACCUM_BLUE_SIZE
	accum_alpha_size           = C.SDL_GL_ACCUM_ALPHA_SIZE
	stereo                     = C.SDL_GL_STEREO
	multisamplebuffers         = C.SDL_GL_MULTISAMPLEBUFFERS
	multisamplesamples         = C.SDL_GL_MULTISAMPLESAMPLES
	accelerated_visual         = C.SDL_GL_ACCELERATED_VISUAL
	retained_backing           = C.SDL_GL_RETAINED_BACKING
	context_major_version      = C.SDL_GL_CONTEXT_MAJOR_VERSION
	context_minor_version      = C.SDL_GL_CONTEXT_MINOR_VERSION
	context_egl                = C.SDL_GL_CONTEXT_EGL
	context_flags              = C.SDL_GL_CONTEXT_FLAGS
	context_profile_mask       = C.SDL_GL_CONTEXT_PROFILE_MASK
	share_with_current_context = C.SDL_GL_SHARE_WITH_CURRENT_CONTEXT
	framebuffer_srgb_capable   = C.SDL_GL_FRAMEBUFFER_SRGB_CAPABLE
	context_release_behavior   = C.SDL_GL_CONTEXT_RELEASE_BEHAVIOR
	context_reset_notification = C.SDL_GL_CONTEXT_RESET_NOTIFICATION
	context_no_error           = C.SDL_GL_CONTEXT_NO_ERROR
	floatbuffers               = C.SDL_GL_FLOATBUFFERS
}

// GLprofile is C.SDL_GLprofile
pub enum GLprofile {
	core          = C.SDL_GL_CONTEXT_PROFILE_CORE // 0x0001
	compatibility = C.SDL_GL_CONTEXT_PROFILE_COMPATIBILITY // 0x0002
	es            = C.SDL_GL_CONTEXT_PROFILE_ES // 0x0004,  GLX_CONTEXT_ES2_PROFILE_BIT_EXT
}

// GLcontextFlag is C.SDL_GLcontextFlag
pub enum GLcontextFlag {
	debug_flag              = C.SDL_GL_CONTEXT_DEBUG_FLAG // 0x0001
	forward_compatible_flag = C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG // 0x0002
	robust_access_flag      = C.SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG // 0x0004
	reset_isolation_flag    = C.SDL_GL_CONTEXT_RESET_ISOLATION_FLAG // 0x0008
}

// GLcontextReleaseFlag is C.SDL_GLcontextReleaseFlag
pub enum GLcontextReleaseFlag {
	@none = C.SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE // 0x0000
	flush = C.SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH // 0x0001
}

// GLContextResetNotification is C.SDL_GLContextResetNotification
pub enum GLContextResetNotification {
	no_notification = C.SDL_GL_CONTEXT_RESET_NO_NOTIFICATION // 0x0000
	lose_context    = C.SDL_GL_CONTEXT_RESET_LOSE_CONTEXT // 0x0001
}

// HitTestResult are possible return values from the SDL_HitTest callback.
//
// See also: SDL_HitTest
//
// HitTestResult is C.SDL_HitTestResult
pub enum HitTestResult {
	normal             = C.SDL_HITTEST_NORMAL // Region is normal. No special properties.
	draggable          = C.SDL_HITTEST_DRAGGABLE // Region can drag entire window.
	resize_topleft     = C.SDL_HITTEST_RESIZE_TOPLEFT
	resize_top         = C.SDL_HITTEST_RESIZE_TOP
	resize_topright    = C.SDL_HITTEST_RESIZE_TOPRIGHT
	resize_right       = C.SDL_HITTEST_RESIZE_RIGHT
	resize_bottomright = C.SDL_HITTEST_RESIZE_BOTTOMRIGHT
	resize_bottom      = C.SDL_HITTEST_RESIZE_BOTTOM
	resize_bottomleft  = C.SDL_HITTEST_RESIZE_BOTTOMLEFT
	resize_left        = C.SDL_HITTEST_RESIZE_LEFT
}

// `typedef SDL_HitTestResult (SDLCALL *SDL_HitTest)(SDL_Window *win, const SDL_Point *area, void *data)`
// fn C.SDL_HitTest(win &C.SDL_Window, const_area &C.SDL_Point, data voidptr) C.SDL_HitTestResult

// Callback used for hit-testing.
//
// `win` the SDL_Window where hit-testing was set on
// `area` an SDL_Point which should be hit-tested
// `data` what was passed as `callback_data` to SDL_SetWindowHitTest()
// returns an SDL_HitTestResult value.
//
// See also: SDL_SetWindowHitTest
//
// `typedef SDL_HitTestResult (SDLCALL *SDL_HitTest)(SDL_Window *win, const SDL_Point *area, void *data)`
pub type HitTest = fn (win &Window, const_area &Point, data voidptr) HitTestResult

fn C.SDL_GetNumVideoDrivers() int

// get_num_video_drivers gets the number of video drivers compiled into SDL.
//
// returns a number >= 1 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetVideoDriver
pub fn get_num_video_drivers() int {
	return C.SDL_GetNumVideoDrivers()
}

fn C.SDL_GetVideoDriver(index int) &char

// get_video_driver gets the name of a built in video driver.
//
// The video drivers are presented in the order in which they are normally
// checked during initialization.
//
// `index` the index of a video driver
// returns the name of the video driver with the given **index**.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetNumVideoDrivers
pub fn get_video_driver(index int) &char {
	return C.SDL_GetVideoDriver(index)
}

fn C.SDL_VideoInit(driver_name &char) int

// video_init initializes the video subsystem, optionally specifying a video driver.
//
// This function initializes the video subsystem, setting up a connection to
// the window manager, etc, and determines the available display modes and
// pixel formats, but does not initialize a window or graphics mode.
//
// If you use this function and you haven't used the SDL_INIT_VIDEO flag with
// either SDL_Init() or SDL_InitSubSystem(), you should call SDL_VideoQuit()
// before calling SDL_Quit().
//
// It is safe to call this function multiple times. SDL_VideoInit() will call
// SDL_VideoQuit() itself if the video subsystem has already been initialized.
//
// You can use SDL_GetNumVideoDrivers() and SDL_GetVideoDriver() to find a
// specific `driver_name`.
//
// `driver_name` the name of a video driver to initialize, or NULL for
//                    the default driver
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetNumVideoDrivers
// See also: SDL_GetVideoDriver
// See also: SDL_InitSubSystem
// See also: SDL_VideoQuit
pub fn video_init(driver_name &char) int {
	return C.SDL_VideoInit(driver_name)
}

fn C.SDL_VideoQuit()

// video_quit shuts down the video subsystem, if initialized with SDL_VideoInit().
//
// This function closes all windows, and restores the original video mode.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_VideoInit
pub fn video_quit() {
	C.SDL_VideoQuit()
}

fn C.SDL_GetCurrentVideoDriver() &char

// get_current_video_driver gets the name of the currently initialized video driver.
//
// returns the name of the current video driver or NULL if no driver has been
//          initialized.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetNumVideoDrivers
// See also: SDL_GetVideoDriver
pub fn get_current_video_driver() &char {
	return C.SDL_GetCurrentVideoDriver()
}

fn C.SDL_GetNumVideoDisplays() int

// get_num_video_displays gets the number of available video displays.
//
// returns a number >= 1 or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetDisplayBounds
pub fn get_num_video_displays() int {
	return C.SDL_GetNumVideoDisplays()
}

fn C.SDL_GetDisplayName(display_index int) &char

// get_display_name gets the name of a display in UTF-8 encoding.
//
// `displayIndex` the index of display from which the name should be
//                     queried
// returns the name of a display or NULL for an invalid display index or
//          failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetNumVideoDisplays
pub fn get_display_name(display_index int) &char {
	return C.SDL_GetDisplayName(display_index)
}

fn C.SDL_GetDisplayBounds(display_index int, rect &C.SDL_Rect) int

// get_display_bounds gets the desktop area represented by a display.
//
// The primary display (`displayIndex` zero) is always located at 0,0.
//
// `displayIndex` the index of the display to query
// `rect` the SDL_Rect structure filled in with the display bounds
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetNumVideoDisplays
pub fn get_display_bounds(display_index int, rect &Rect) int {
	return C.SDL_GetDisplayBounds(display_index, rect)
}

fn C.SDL_GetDisplayUsableBounds(display_index int, rect &C.SDL_Rect) int

// get_display_usable_bounds gets the usable desktop area represented by a display.
//
// The primary display (`displayIndex` zero) is always located at 0,0.
//
// This is the same area as SDL_GetDisplayBounds() reports, but with portions
// reserved by the system removed. For example, on Apple's macOS, this
// subtracts the area occupied by the menu bar and dock.
//
// Setting a window to be fullscreen generally bypasses these unusable areas,
// so these are good guidelines for the maximum space available to a
// non-fullscreen window.
//
// The parameter `rect` is ignored if it is NULL.
//
// This function also returns -1 if the parameter `displayIndex` is out of
// range.
//
// `displayIndex` the index of the display to query the usable bounds
//                     from
// `rect` the SDL_Rect structure filled in with the display bounds
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_GetDisplayBounds
// See also: SDL_GetNumVideoDisplays
pub fn get_display_usable_bounds(display_index int, rect &Rect) int {
	return C.SDL_GetDisplayUsableBounds(display_index, rect)
}

fn C.SDL_GetDisplayDPI(display_index int, ddpi &f32, hdpi &f32, vdpi &f32) int

// get_display_dpi gets the dots/pixels-per-inch for a display.
//
// Diagonal, horizontal and vertical DPI can all be optionally returned if the
// appropriate parameter is non-NULL.
//
// A failure of this function usually means that either no DPI information is
// available or the `displayIndex` is out of range.
//
// **WARNING**: This reports the DPI that the hardware reports, and it is not
// always reliable! It is almost always better to use SDL_GetWindowSize() to
// find the window size, which might be in logical points instead of pixels,
// and then SDL_GL_GetDrawableSize(), SDL_Vulkan_GetDrawableSize(),
// SDL_Metal_GetDrawableSize(), or SDL_GetRendererOutputSize(), and compare
// the two values to get an actual scaling value between the two. We will be
// rethinking how high-dpi details should be managed in SDL3 to make things
// more consistent, reliable, and clear.
//
// `displayIndex` the index of the display from which DPI information
//                     should be queried
// `ddpi` a pointer filled in with the diagonal DPI of the display; may
//             be NULL
// `hdpi` a pointer filled in with the horizontal DPI of the display; may
//             be NULL
// `vdpi` a pointer filled in with the vertical DPI of the display; may
//             be NULL
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.4.
//
// See also: SDL_GetNumVideoDisplays
pub fn get_display_dpi(display_index int, ddpi &f32, hdpi &f32, vdpi &f32) int {
	return C.SDL_GetDisplayDPI(display_index, ddpi, hdpi, vdpi)
}

fn C.SDL_GetDisplayOrientation(display_index int) DisplayOrientation

// get_display_orientation gets the orientation of a display.
//
// `displayIndex` the index of the display to query
// returns The SDL_DisplayOrientation enum value of the display, or
//          `SDL_ORIENTATION_UNKNOWN` if it isn't available.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetNumVideoDisplays
pub fn get_display_orientation(display_index int) DisplayOrientation {
	return DisplayOrientation(C.SDL_GetDisplayOrientation(display_index))
}

fn C.SDL_GetNumDisplayModes(display_index int) int

// get_num_display_modes gets the number of available display modes.
//
// The `displayIndex` needs to be in the range from 0 to
// SDL_GetNumVideoDisplays() - 1.
//
// `displayIndex` the index of the display to query
// returns a number >= 1 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetDisplayMode
// See also: SDL_GetNumVideoDisplays
pub fn get_num_display_modes(display_index int) int {
	return C.SDL_GetNumDisplayModes(display_index)
}

fn C.SDL_GetDisplayMode(display_index int, mode_index int, mode &C.SDL_DisplayMode) int

// get_display_mode gets information about a specific display mode.
//
// The display modes are sorted in this priority:
//
// - width -> largest to smallest
// - height -> largest to smallest
// - bits per pixel -> more colors to fewer colors
// - packed pixel layout -> largest to smallest
// - refresh rate -> highest to lowest
//
// `displayIndex` the index of the display to query
// `modeIndex` the index of the display mode to query
// `mode` an SDL_DisplayMode structure filled in with the mode at
//             `modeIndex`
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetNumDisplayModes
pub fn get_display_mode(display_index int, mode_index int, mode &DisplayMode) int {
	return C.SDL_GetDisplayMode(display_index, mode_index, mode)
}

fn C.SDL_GetDesktopDisplayMode(display_index int, mode &C.SDL_DisplayMode) int

// get_desktop_display_mode gets information about the desktop's display mode.
//
// There's a difference between this function and SDL_GetCurrentDisplayMode()
// when SDL runs fullscreen and has changed the resolution. In that case this
// function will return the previous native display mode, and not the current
// display mode.
//
// `displayIndex` the index of the display to query
// `mode` an SDL_DisplayMode structure filled in with the current display
//             mode
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetCurrentDisplayMode
// See also: SDL_GetDisplayMode
// See also: SDL_SetWindowDisplayMode
pub fn get_desktop_display_mode(display_index int, mode &DisplayMode) int {
	return C.SDL_GetDesktopDisplayMode(display_index, mode)
}

fn C.SDL_GetCurrentDisplayMode(display_index int, mode &C.SDL_DisplayMode) int

// get_current_display_mode gets information about the current display mode.
//
// There's a difference between this function and SDL_GetDesktopDisplayMode()
// when SDL runs fullscreen and has changed the resolution. In that case this
// function will return the current display mode, and not the previous native
// display mode.
//
// `displayIndex` the index of the display to query
// `mode` an SDL_DisplayMode structure filled in with the current display
//             mode
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetDesktopDisplayMode
// See also: SDL_GetDisplayMode
// See also: SDL_GetNumVideoDisplays
// See also: SDL_SetWindowDisplayMode
pub fn get_current_display_mode(display_index int, mode &DisplayMode) int {
	return C.SDL_GetCurrentDisplayMode(display_index, mode)
}

fn C.SDL_GetClosestDisplayMode(display_index int, const_mode &C.SDL_DisplayMode, closest &C.SDL_DisplayMode) &C.SDL_DisplayMode

// get_closest_display_mode gets the closest match to the requested display mode.
//
// The available display modes are scanned and `closest` is filled in with the
// closest mode matching the requested mode and returned. The mode format and
// refresh rate default to the desktop mode if they are set to 0. The modes
// are scanned with size being first priority, format being second priority,
// and finally checking the refresh rate. If all the available modes are too
// small, then NULL is returned.
//
// `displayIndex` the index of the display to query
// `mode` an SDL_DisplayMode structure containing the desired display
//             mode
// `closest` an SDL_DisplayMode structure filled in with the closest
//                match of the available display modes
// returns the passed in value `closest` or NULL if no matching video mode
//          was available; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetDisplayMode
// See also: SDL_GetNumDisplayModes
pub fn get_closest_display_mode(display_index int, const_mode &DisplayMode, closest &DisplayMode) &DisplayMode {
	return C.SDL_GetClosestDisplayMode(display_index, const_mode, closest)
}

fn C.SDL_GetPointDisplayIndex(const_point &C.SDL_Point) int

// get_point_display_index gets the index of the display containing a point
//
// `point` the point to query
// returns the index of the display containing the point or a negative error
//          code on failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.24.0.
//
// See also: SDL_GetDisplayBounds
// See also: SDL_GetNumVideoDisplays
pub fn get_point_display_index(const_point &Point) int {
	return C.SDL_GetPointDisplayIndex(const_point)
}

fn C.SDL_GetRectDisplayIndex(const_rect &C.SDL_Rect) int

// get_rect_display_index gets the index of the display primarily containing a rect
//
// `rect` the rect to query
// returns the index of the display entirely containing the rect or closest
//          to the center of the rect on success or a negative error code on
//          failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.24.0.
//
// See also: SDL_GetDisplayBounds
// See also: SDL_GetNumVideoDisplays
pub fn get_rect_display_index(const_rect &Rect) int {
	return C.SDL_GetRectDisplayIndex(const_rect)
}

fn C.SDL_GetWindowDisplayIndex(window &C.SDL_Window) int

// get_window_display_index gets the index of the display associated with a window.
//
// `window` the window to query
// returns the index of the display containing the center of the window on
//          success or a negative error code on failure; call SDL_GetError()
//          for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetDisplayBounds
// See also: SDL_GetNumVideoDisplays
pub fn get_window_display_index(window &Window) int {
	return C.SDL_GetWindowDisplayIndex(window)
}

fn C.SDL_SetWindowDisplayMode(window &C.SDL_Window, const_mode &C.SDL_DisplayMode) int

// set_window_display_mode sets the display mode to use when a window is visible at fullscreen.
//
// This only affects the display mode used when the window is fullscreen. To
// change the window size when the window is not fullscreen, use
// SDL_SetWindowSize().
//
// `window` the window to affect
// `mode` the SDL_DisplayMode structure representing the mode to use, or
//             NULL to use the window's dimensions and the desktop's format
//             and refresh rate
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowDisplayMode
// See also: SDL_SetWindowFullscreen
pub fn set_window_display_mode(window &Window, const_mode &DisplayMode) int {
	return C.SDL_SetWindowDisplayMode(window, const_mode)
}

fn C.SDL_GetWindowDisplayMode(window &C.SDL_Window, mode &C.SDL_DisplayMode) int

// get_window_display_mode queries the display mode to use when a window is visible at fullscreen.
//
// `window` the window to query
// `mode` an SDL_DisplayMode structure filled in with the fullscreen
//             display mode
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetWindowDisplayMode
// See also: SDL_SetWindowFullscreen
pub fn get_window_display_mode(window &Window, mode &DisplayMode) int {
	return C.SDL_GetWindowDisplayMode(window, mode)
}

fn C.SDL_GetWindowICCProfile(window &C.SDL_Window, size &usize) voidptr

// get_window_icc_profile gets the raw ICC profile data for the screen the window is currently on.
//
// Data returned should be freed with SDL_free.
//
// `window` the window to query
// `size` the size of the ICC profile
// returns the raw ICC profile data on success or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.18.
pub fn get_window_icc_profile(window &Window, size &usize) voidptr {
	return C.SDL_GetWindowICCProfile(window, size)
}

fn C.SDL_GetWindowPixelFormat(window &C.SDL_Window) u32

// get_window_pixel_format gets the pixel format associated with the window.
//
// `window` the window to query
// returns the pixel format of the window on success or
//          SDL_PIXELFORMAT_UNKNOWN on failure; call SDL_GetError() for more
//          information.
//
// NOTE This function is available since SDL 2.0.0.
pub fn get_window_pixel_format(window &Window) u32 {
	return C.SDL_GetWindowPixelFormat(window)
}

fn C.SDL_CreateWindow(title &char, x int, y int, w int, h int, flags u32) &C.SDL_Window

// create_window creates a window with the specified position, dimensions, and flags.
//
// `flags` may be any of the following OR'd together:
//
// - `SDL_WINDOW_FULLSCREEN`: fullscreen window
// - `SDL_WINDOW_FULLSCREEN_DESKTOP`: fullscreen window at desktop resolution
// - `SDL_WINDOW_OPENGL`: window usable with an OpenGL context
// - `SDL_WINDOW_VULKAN`: window usable with a Vulkan instance
// - `SDL_WINDOW_METAL`: window usable with a Metal instance
// - `SDL_WINDOW_HIDDEN`: window is not visible
// - `SDL_WINDOW_BORDERLESS`: no window decoration
// - `SDL_WINDOW_RESIZABLE`: window can be resized
// - `SDL_WINDOW_MINIMIZED`: window is minimized
// - `SDL_WINDOW_MAXIMIZED`: window is maximized
// - `SDL_WINDOW_INPUT_GRABBED`: window has grabbed input focus
// - `SDL_WINDOW_ALLOW_HIGHDPI`: window should be created in high-DPI mode if
//   supported (>= SDL 2.0.1)
//
// `SDL_WINDOW_SHOWN` is ignored by SDL_CreateWindow(). The SDL_Window is
// implicitly shown if SDL_WINDOW_HIDDEN is not set. `SDL_WINDOW_SHOWN` may be
// queried later using SDL_GetWindowFlags().
//
// On Apple's macOS, you **must** set the NSHighResolutionCapable Info.plist
// property to YES, otherwise you will not receive a High-DPI OpenGL canvas.
//
// If the window is created with the `SDL_WINDOW_ALLOW_HIGHDPI` flag, its size
// in pixels may differ from its size in screen coordinates on platforms with
// high-DPI support (e.g. iOS and macOS). Use SDL_GetWindowSize() to query the
// client area's size in screen coordinates, and SDL_GL_GetDrawableSize() or
// SDL_GetRendererOutputSize() to query the drawable size in pixels. Note that
// when this flag is set, the drawable size can vary after the window is
// created and should be queried after major window events such as when the
// window is resized or moved between displays.
//
// If the window is set fullscreen, the width and height parameters `w` and
// `h` will not be used. However, invalid size parameters (e.g. too large) may
// still fail. Window size is actually limited to 16384 x 16384 for all
// platforms at window creation.
//
// If the window is created with any of the SDL_WINDOW_OPENGL or
// SDL_WINDOW_VULKAN flags, then the corresponding LoadLibrary function
// (SDL_GL_LoadLibrary or SDL_Vulkan_LoadLibrary) is called and the
// corresponding UnloadLibrary function is called by SDL_DestroyWindow().
//
// If SDL_WINDOW_VULKAN is specified and there isn't a working Vulkan driver,
// SDL_CreateWindow() will fail because SDL_Vulkan_LoadLibrary() will fail.
//
// If SDL_WINDOW_METAL is specified on an OS that does not support Metal,
// SDL_CreateWindow() will fail.
//
// On non-Apple devices, SDL requires you to either not link to the Vulkan
// loader or link to a dynamic library version. This limitation may be removed
// in a future version of SDL.
//
// `title` the title of the window, in UTF-8 encoding
// `x` the x position of the window, `SDL_WINDOWPOS_CENTERED`, or
//          `SDL_WINDOWPOS_UNDEFINED`
// `y` the y position of the window, `SDL_WINDOWPOS_CENTERED`, or
//          `SDL_WINDOWPOS_UNDEFINED`
// `w` the width of the window, in screen coordinates
// `h` the height of the window, in screen coordinates
// `flags` 0, or one or more SDL_WindowFlags OR'd together
// returns the window that was created or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateWindowFrom
// See also: SDL_DestroyWindow
pub fn create_window(title &char, x int, y int, w int, h int, flags u32) &Window {
	return C.SDL_CreateWindow(title, x, y, w, h, flags)
}

fn C.SDL_CreateWindowFrom(data voidptr) &C.SDL_Window

// create_window_from creates an SDL window from an existing native window.
//
// In some cases (e.g. OpenGL) and on some platforms (e.g. Microsoft Windows)
// the hint `SDL_HINT_VIDEO_WINDOW_SHARE_PIXEL_FORMAT` needs to be configured
// before using SDL_CreateWindowFrom().
//
// `data` a pointer to driver-dependent window creation data, typically
//             your native window cast to a void*
// returns the window that was created or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateWindow
// See also: SDL_DestroyWindow
pub fn create_window_from(data voidptr) &Window {
	return C.SDL_CreateWindowFrom(data)
}

fn C.SDL_GetWindowID(window &C.SDL_Window) u32

// get_window_id gets the numeric ID of a window.
//
// The numeric ID is what SDL_WindowEvent references, and is necessary to map
// these events to specific SDL_Window objects.
//
// `window` the window to query
// returns the ID of the window on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowFromID
pub fn get_window_id(window &Window) u32 {
	return C.SDL_GetWindowID(window)
}

fn C.SDL_GetWindowFromID(id u32) &C.SDL_Window

// get_window_from_id gets a window from a stored ID.
//
// The numeric ID is what SDL_WindowEvent references, and is necessary to map
// these events to specific SDL_Window objects.
//
// `id` the ID of the window
// returns the window associated with `id` or NULL if it doesn't exist; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowID
pub fn get_window_from_id(id u32) &Window {
	return C.SDL_GetWindowFromID(id)
}

fn C.SDL_GetWindowFlags(window &C.SDL_Window) u32

// get_window_flags gets the window flags.
//
// `window` the window to query
// returns a mask of the SDL_WindowFlags associated with `window`
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateWindow
// See also: SDL_HideWindow
// See also: SDL_MaximizeWindow
// See also: SDL_MinimizeWindow
// See also: SDL_SetWindowFullscreen
// See also: SDL_SetWindowGrab
// See also: SDL_ShowWindow
pub fn get_window_flags(window &Window) u32 {
	return C.SDL_GetWindowFlags(window)
}

fn C.SDL_SetWindowTitle(window &C.SDL_Window, const_title &char)

// set_window_title sets the title of a window.
//
// This string is expected to be in UTF-8 encoding.
//
// `window` the window to change
// `title` the desired window title in UTF-8 format
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowTitle
pub fn set_window_title(window &Window, const_title &char) {
	C.SDL_SetWindowTitle(window, const_title)
}

fn C.SDL_GetWindowTitle(window &C.SDL_Window) &char

// get_window_title gets the title of a window.
//
// `window` the window to query
// returns the title of the window in UTF-8 format or "" if there is no
//          title.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetWindowTitle
pub fn get_window_title(window &Window) &char {
	return C.SDL_GetWindowTitle(window)
}

fn C.SDL_SetWindowIcon(window &C.SDL_Window, icon &C.SDL_Surface)

// set_window_icon sets the icon for a window.
//
// `window` the window to change
// `icon` an SDL_Surface structure containing the icon for the window
//
// NOTE This function is available since SDL 2.0.0.
pub fn set_window_icon(window &Window, icon &Surface) {
	C.SDL_SetWindowIcon(window, icon)
}

fn C.SDL_SetWindowData(window &C.SDL_Window, const_name &char, userdata voidptr) voidptr

// set_window_data associates an arbitrary named pointer with a window.
//
// `name` is case-sensitive.
//
// `window` the window to associate with the pointer
// `name` the name of the pointer
// `userdata` the associated pointer
// returns the previous value associated with `name`.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowData
pub fn set_window_data(window &Window, const_name &char, userdata voidptr) voidptr {
	return C.SDL_SetWindowData(window, const_name, userdata)
}

fn C.SDL_GetWindowData(window &C.SDL_Window, const_name &char) voidptr

// get_window_data retrieves the data pointer associated with a window.
//
// `window` the window to query
// `name` the name of the pointer
// returns the value associated with `name`.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetWindowData
pub fn get_window_data(window &Window, const_name &char) voidptr {
	return C.SDL_GetWindowData(window, const_name)
}

fn C.SDL_SetWindowPosition(window &C.SDL_Window, x int, y int)

// set_window_position sets the position of a window.
//
// The window coordinate origin is the upper left of the display.
//
// `window` the window to reposition
// `x` the x coordinate of the window in screen coordinates, or
//          `SDL_WINDOWPOS_CENTERED` or `SDL_WINDOWPOS_UNDEFINED`
// `y` the y coordinate of the window in screen coordinates, or
//          `SDL_WINDOWPOS_CENTERED` or `SDL_WINDOWPOS_UNDEFINED`
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowPosition
pub fn set_window_position(window &Window, x int, y int) {
	C.SDL_SetWindowPosition(window, x, y)
}

fn C.SDL_GetWindowPosition(window &C.SDL_Window, x &int, y &int)

// get_window_position gets the position of a window.
//
// If you do not need the value for one of the positions a NULL may be passed
// in the `x` or `y` parameter.
//
// `window` the window to query
// `x` a pointer filled in with the x position of the window, in screen
//          coordinates, may be NULL
// `y` a pointer filled in with the y position of the window, in screen
//          coordinates, may be NULL
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetWindowPosition
pub fn get_window_position(window &Window, x &int, y &int) {
	C.SDL_GetWindowPosition(window, x, y)
}

fn C.SDL_SetWindowSize(window &C.SDL_Window, w int, h int)

// set_window_size sets the size of a window's client area.
//
// The window size in screen coordinates may differ from the size in pixels,
// if the window was created with `SDL_WINDOW_ALLOW_HIGHDPI` on a platform
// with high-dpi support (e.g. iOS or macOS). Use SDL_GL_GetDrawableSize() or
// SDL_GetRendererOutputSize() to get the real client area size in pixels.
//
// Fullscreen windows automatically match the size of the display mode, and
// you should use SDL_SetWindowDisplayMode() to change their size.
//
// `window` the window to change
// `w` the width of the window in pixels, in screen coordinates, must be
//          > 0
// `h` the height of the window in pixels, in screen coordinates, must be
//          > 0
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowSize
// See also: SDL_SetWindowDisplayMode
pub fn set_window_size(window &Window, w int, h int) {
	C.SDL_SetWindowSize(window, w, h)
}

fn C.SDL_GetWindowSize(window &C.SDL_Window, w &int, h &int)

// get_window_size gets the size of a window's client area.
//
// NULL can safely be passed as the `w` or `h` parameter if the width or
// height value is not desired.
//
// The window size in screen coordinates may differ from the size in pixels,
// if the window was created with `SDL_WINDOW_ALLOW_HIGHDPI` on a platform
// with high-dpi support (e.g. iOS or macOS). Use SDL_GL_GetDrawableSize(),
// SDL_Vulkan_GetDrawableSize(), or SDL_GetRendererOutputSize() to get the
// real client area size in pixels.
//
// `window` the window to query the width and height from
// `w` a pointer filled in with the width of the window, in screen
//          coordinates, may be NULL
// `h` a pointer filled in with the height of the window, in screen
//          coordinates, may be NULL
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_GetDrawableSize
// See also: SDL_Vulkan_GetDrawableSize
// See also: SDL_SetWindowSize
pub fn get_window_size(window &Window, w &int, h &int) {
	C.SDL_GetWindowSize(window, w, h)
}

fn C.SDL_GetWindowBordersSize(window &C.SDL_Window, top &int, left &int, bottom &int, right &int) int

// get_window_borders_size gets the size of a window's borders (decorations) around the client area.
//
// Note: If this function fails (returns -1), the size values will be
// initialized to 0, 0, 0, 0 (if a non-NULL pointer is provided), as if the
// window in question was borderless.
//
// Note: This function may fail on systems where the window has not yet been
// decorated by the display server (for example, immediately after calling
// SDL_CreateWindow). It is recommended that you wait at least until the
// window has been presented and composited, so that the window system has a
// chance to decorate the window and provide the border dimensions to SDL.
//
// This function also returns -1 if getting the information is not supported.
//
// `window` the window to query the size values of the border
//               (decorations) from
// `top` pointer to variable for storing the size of the top border; NULL
//            is permitted
// `left` pointer to variable for storing the size of the left border;
//             NULL is permitted
// `bottom` pointer to variable for storing the size of the bottom
//               border; NULL is permitted
// `right` pointer to variable for storing the size of the right border;
//              NULL is permitted
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_GetWindowSize
pub fn get_window_borders_size(window &Window, top &int, left &int, bottom &int, right &int) int {
	return C.SDL_GetWindowBordersSize(window, top, left, bottom, right)
}

fn C.SDL_GetWindowSizeInPixels(window &C.SDL_Window, w &int, h &int)

// get_window_size_in_pixels gets the size of a window in pixels.
//
// This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
// drawable, i.e. the window was created with `SDL_WINDOW_ALLOW_HIGHDPI` on a
// platform with high-DPI support (Apple calls this "Retina"), and not
// disabled by the `SDL_HINT_VIDEO_HIGHDPI_DISABLED` hint.
//
// `window` the window from which the drawable size should be queried
// `w` a pointer to variable for storing the width in pixels, may be NULL
// `h` a pointer to variable for storing the height in pixels, may be
//          NULL
//
// NOTE This function is available since SDL 2.26.0.
//
// See also: SDL_CreateWindow
// See also: SDL_GetWindowSize
pub fn get_window_size_in_pixels(window &Window, w &int, h &int) {
	C.SDL_GetWindowSizeInPixels(window, w, h)
}

fn C.SDL_SetWindowMinimumSize(window &C.SDL_Window, min_w int, min_h int)

// set_window_minimum_size sets the minimum size of a window's client area.
//
// `window` the window to change
// `min_w` the minimum width of the window in pixels
// `min_h` the minimum height of the window in pixels
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowMinimumSize
// See also: SDL_SetWindowMaximumSize
pub fn set_window_minimum_size(window &Window, min_w int, min_h int) {
	C.SDL_SetWindowMinimumSize(window, min_w, min_h)
}

fn C.SDL_GetWindowMinimumSize(window &C.SDL_Window, w &int, h &int)

// get_window_minimum_size gets the minimum size of a window's client area.
//
// `window` the window to query
// `w` a pointer filled in with the minimum width of the window, may be
//          NULL
// `h` a pointer filled in with the minimum height of the window, may be
//          NULL
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowMaximumSize
// See also: SDL_SetWindowMinimumSize
pub fn get_window_minimum_size(window &Window, w &int, h &int) {
	C.SDL_GetWindowMinimumSize(window, w, h)
}

fn C.SDL_SetWindowMaximumSize(window &C.SDL_Window, max_w int, max_h int)

// set_window_maximum_size sets the maximum size of a window's client area.
//
// `window` the window to change
// `max_w` the maximum width of the window in pixels
// `max_h` the maximum height of the window in pixels
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowMaximumSize
// See also: SDL_SetWindowMinimumSize
pub fn set_window_maximum_size(window &Window, max_w int, max_h int) {
	C.SDL_SetWindowMaximumSize(window, max_w, max_h)
}

fn C.SDL_GetWindowMaximumSize(window &C.SDL_Window, w &int, h &int)

// get_window_maximum_size gets the maximum size of a window's client area.
//
// `window` the window to query
// `w` a pointer filled in with the maximum width of the window, may be
//          NULL
// `h` a pointer filled in with the maximum height of the window, may be
//          NULL
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowMinimumSize
// See also: SDL_SetWindowMaximumSize
pub fn get_window_maximum_size(window &Window, w &int, h &int) {
	C.SDL_GetWindowMaximumSize(window, w, h)
}

fn C.SDL_SetWindowBordered(window &C.SDL_Window, bordered bool)

// set_window_bordered sets the border state of a window.
//
// This will add or remove the window's `SDL_WINDOW_BORDERLESS` flag and add
// or remove the border from the actual window. This is a no-op if the
// window's border already matches the requested state.
//
// You can't change the border state of a fullscreen window.
//
// `window` the window of which to change the border state
// `bordered` SDL_FALSE to remove border, SDL_TRUE to add border
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowFlags
pub fn set_window_bordered(window &Window, bordered bool) {
	C.SDL_SetWindowBordered(window, bordered)
}

fn C.SDL_SetWindowResizable(window &C.SDL_Window, resizable bool)

// set_window_resizable sets the user-resizable state of a window.
//
// This will add or remove the window's `SDL_WINDOW_RESIZABLE` flag and
// allow/disallow user resizing of the window. This is a no-op if the window's
// resizable state already matches the requested state.
//
// You can't change the resizable state of a fullscreen window.
//
// `window` the window of which to change the resizable state
// `resizable` SDL_TRUE to allow resizing, SDL_FALSE to disallow
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_GetWindowFlags
pub fn set_window_resizable(window &Window, resizable bool) {
	C.SDL_SetWindowResizable(window, resizable)
}

fn C.SDL_SetWindowAlwaysOnTop(window &C.SDL_Window, on_top bool)

// set_window_always_on_top sets the window to always be above the others.
//
// This will add or remove the window's `SDL_WINDOW_ALWAYS_ON_TOP` flag. This
// will bring the window to the front and keep the window above the rest.
//
// `window` The window of which to change the always on top state
// `on_top` SDL_TRUE to set the window always on top, SDL_FALSE to
//               disable
//
// NOTE This function is available since SDL 2.0.16.
//
// See also: SDL_GetWindowFlags
pub fn set_window_always_on_top(window &C.SDL_Window, on_top bool) {
	C.SDL_SetWindowAlwaysOnTop(window, on_top)
}

fn C.SDL_ShowWindow(window &C.SDL_Window)

// show_window shows a window.
//
// `window` the window to show
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_HideWindow
// See also: SDL_RaiseWindow
pub fn show_window(window &Window) {
	C.SDL_ShowWindow(window)
}

fn C.SDL_HideWindow(window &C.SDL_Window)

// hide_window hides a window.
//
// `window` the window to hide
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_ShowWindow
pub fn hide_window(window &Window) {
	C.SDL_HideWindow(window)
}

fn C.SDL_RaiseWindow(window &C.SDL_Window)

// raise_window raises a window above other windows and set the input focus.
//
// NOTE This function is available since SDL 2.0.0.
//
// `window` the window to raise
pub fn raise_window(window &Window) {
	C.SDL_RaiseWindow(window)
}

fn C.SDL_MaximizeWindow(window &C.SDL_Window)

// maximize_window makes a window as large as possible.
//
// `window` the window to maximize
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_MinimizeWindow
// See also: SDL_RestoreWindow
pub fn maximize_window(window &Window) {
	C.SDL_MaximizeWindow(window)
}

fn C.SDL_MinimizeWindow(window &C.SDL_Window)

// minimize_window minimizes a window to an iconic representation.
//
// `window` the window to minimize
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_MaximizeWindow
// See also: SDL_RestoreWindow
pub fn minimize_window(window &Window) {
	C.SDL_MinimizeWindow(window)
}

fn C.SDL_RestoreWindow(window &C.SDL_Window)

// restore_window restores the size and position of a minimized or maximized window.
//
// `window` the window to restore
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_MaximizeWindow
// See also: SDL_MinimizeWindow
pub fn restore_window(window &Window) {
	C.SDL_RestoreWindow(window)
}

fn C.SDL_SetWindowFullscreen(window &C.SDL_Window, flags u32) int

// set_window_fullscreen sets a window's fullscreen state.
//
// `flags` may be `SDL_WINDOW_FULLSCREEN`, for "real" fullscreen with a
// videomode change; `SDL_WINDOW_FULLSCREEN_DESKTOP` for "fake" fullscreen
// that takes the size of the desktop; and 0 for windowed mode.
//
// `window` the window to change
// `flags` `SDL_WINDOW_FULLSCREEN`, `SDL_WINDOW_FULLSCREEN_DESKTOP` or 0
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowDisplayMode
// See also: SDL_SetWindowDisplayMode
pub fn set_window_fullscreen(window &Window, flags u32) int {
	return C.SDL_SetWindowFullscreen(window, flags)
}

fn C.SDL_GetWindowSurface(window &C.SDL_Window) &C.SDL_Surface

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
// `window` the window to query
// returns the surface associated with the window, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_UpdateWindowSurface
// See also: SDL_UpdateWindowSurfaceRects
pub fn get_window_surface(window &Window) &Surface {
	return C.SDL_GetWindowSurface(window)
}

fn C.SDL_UpdateWindowSurface(window &C.SDL_Window) int

// update_window_surface copies the window surface to the screen.
//
// This is the function you use to reflect any changes to the surface on the
// screen.
//
// This function is equivalent to the SDL 1.2 API SDL_Flip().
//
// `window` the window to update
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowSurface
// See also: SDL_UpdateWindowSurfaceRects
pub fn update_window_surface(window &Window) int {
	return C.SDL_UpdateWindowSurface(window)
}

fn C.SDL_UpdateWindowSurfaceRects(window &C.SDL_Window, const_rects &C.SDL_Rect, numconst_rects int) int

// update_window_surface_rects copies areas of the window surface to the screen.
//
// This is the function you use to reflect changes to portions of the surface
// on the screen.
//
// This function is equivalent to the SDL 1.2 API SDL_UpdateRects().
//
// `window` the window to update
// `rects` an array of SDL_Rect structures representing areas of the
//              surface to copy
// `numrects` the number of rectangles
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowSurface
// See also: SDL_UpdateWindowSurface
pub fn update_window_surface_rects(window &Window, const_rects &Rect, numconst_rects int) int {
	return C.SDL_UpdateWindowSurfaceRects(window, const_rects, numconst_rects)
}

fn C.SDL_SetWindowGrab(window &C.SDL_Window, grabbed bool)

// set_window_grab sets a window's input grab mode.
//
// When input is grabbed, the mouse is confined to the window. This function
// will also grab the keyboard if `SDL_HINT_GRAB_KEYBOARD` is set. To grab the
// keyboard without also grabbing the mouse, use SDL_SetWindowKeyboardGrab().
//
// If the caller enables a grab while another window is currently grabbed, the
// other window loses its grab in favor of the caller's window.
//
// `window` the window for which the input grab mode should be set
// `grabbed` SDL_TRUE to grab input or SDL_FALSE to release input
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetGrabbedWindow
// See also: SDL_GetWindowGrab
pub fn set_window_grab(window &Window, grabbed bool) {
	C.SDL_SetWindowGrab(window, grabbed)
}

fn C.SDL_SetWindowKeyboardGrab(window &C.SDL_Window, grabbed bool)

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
// `window` The window for which the keyboard grab mode should be set.
// `grabbed` This is SDL_TRUE to grab keyboard, and SDL_FALSE to release.
//
// NOTE This function is available since SDL 2.0.16.
//
// See also: SDL_GetWindowKeyboardGrab
// See also: SDL_SetWindowMouseGrab
// See also: SDL_SetWindowGrab
pub fn set_window_keyboard_grab(window &Window, grabbed bool) {
	C.SDL_SetWindowKeyboardGrab(window, grabbed)
}

fn C.SDL_SetWindowMouseGrab(window &C.SDL_Window, grabbed bool)

// set_window_mouse_grab sets a window's mouse grab mode.
//
// Mouse grab confines the mouse cursor to the window.
//
// `window` The window for which the mouse grab mode should be set.
// `grabbed` This is SDL_TRUE to grab mouse, and SDL_FALSE to release.
//
// NOTE This function is available since SDL 2.0.16.
//
// See also: SDL_GetWindowMouseGrab
// See also: SDL_SetWindowKeyboardGrab
// See also: SDL_SetWindowGrab
pub fn set_window_mouse_grab(window &Window, grabbed bool) {
	C.SDL_SetWindowMouseGrab(window, grabbed)
}

fn C.SDL_GetWindowGrab(window &C.SDL_Window) bool

// get_window_grab gets a window's input grab mode.
//
// `window` the window to query
// returns SDL_TRUE if input is grabbed, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetWindowGrab
pub fn get_window_grab(window &Window) bool {
	return C.SDL_GetWindowGrab(window)
}

fn C.SDL_GetWindowKeyboardGrab(window &C.SDL_Window) bool

// get_window_keyboard_grab gets a window's keyboard grab mode.
//
// `window` the window to query
// returns SDL_TRUE if keyboard is grabbed, and SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.16.
//
// See also: SDL_SetWindowKeyboardGrab
// See also: SDL_GetWindowGrab
pub fn get_window_keyboard_grab(window &Window) bool {
	return C.SDL_GetWindowKeyboardGrab(window)
}

fn C.SDL_GetWindowMouseGrab(window &C.SDL_Window) bool

// get_window_mouse_grab gets a window's mouse grab mode.
//
// `window` the window to query
// returns SDL_TRUE if mouse is grabbed, and SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.16.
//
// See also: SDL_SetWindowKeyboardGrab
// See also: SDL_GetWindowGrab
pub fn get_window_mouse_grab(window &Window) bool {
	return C.SDL_GetWindowMouseGrab(window)
}

fn C.SDL_GetGrabbedWindow() &C.SDL_Window

// get_grabbed_window gets the window that currently has an input grab enabled.
//
// returns the window if input is grabbed or NULL otherwise.
//
// NOTE This function is available since SDL 2.0.4.
//
// See also: SDL_GetWindowGrab
// See also: SDL_SetWindowGrab
pub fn get_grabbed_window() &Window {
	return C.SDL_GetGrabbedWindow()
}

fn C.SDL_SetWindowMouseRect(window &C.SDL_Window, const_rect &C.SDL_Rect) int

// set_window_mouse_rect confines the cursor to the specified area of a window.
//
// Note that this does NOT grab the cursor, it only defines the area a cursor
// is restricted to when the window has mouse focus.
//
// `window` The window that will be associated with the barrier.
// `rect` A rectangle area in window-relative coordinates. If NULL the
//             barrier for the specified window will be destroyed.
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_GetWindowMouseRect
// See also: SDL_SetWindowMouseGrab
pub fn set_window_mouse_rect(window &Window, const_rect &Rect) int {
	return C.SDL_SetWindowMouseRect(window, const_rect)
}

fn C.SDL_GetWindowMouseRect(window &C.SDL_Window) &C.SDL_Rect

// get_window_mouse_rect gets the mouse confinement rectangle of a window.
//
// `window` The window to query
// returns A pointer to the mouse confinement rectangle of a window, or NULL
//          if there isn't one.
//
// NOTE This function is available since SDL 2.0.18.
//
// See also: SDL_SetWindowMouseRect
pub fn get_window_mouse_rect(window &Window) &Rect {
	return C.SDL_GetWindowMouseRect(window)
}

fn C.SDL_SetWindowBrightness(window &C.SDL_Window, brightness f32) int

// set_window_brightness sets the brightness (gamma multiplier) for a given window's display.
//
// Despite the name and signature, this method sets the brightness of the
// entire display, not an individual window. A window is considered to be
// owned by the display that contains the window's center pixel. (The index of
// this display can be retrieved using SDL_GetWindowDisplayIndex().) The
// brightness set will not follow the window if it is moved to another
// display.
//
// Many platforms will refuse to set the display brightness in modern times.
// You are better off using a shader to adjust gamma during rendering, or
// something similar.
//
// `window` the window used to select the display whose brightness will
//               be changed
// `brightness` the brightness (gamma multiplier) value to set where 0.0
//                   is completely dark and 1.0 is normal brightness
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowBrightness
// See also: SDL_SetWindowGammaRamp
pub fn set_window_brightness(window &Window, brightness f32) int {
	return C.SDL_SetWindowBrightness(window, brightness)
}

fn C.SDL_GetWindowBrightness(window &C.SDL_Window) f32

// get_window_brightness gets the brightness (gamma multiplier) for a given window's display.
//
// Despite the name and signature, this method retrieves the brightness of the
// entire display, not an individual window. A window is considered to be
// owned by the display that contains the window's center pixel. (The index of
// this display can be retrieved using SDL_GetWindowDisplayIndex().)
//
// `window` the window used to select the display whose brightness will
//               be queried
// returns the brightness for the display where 0.0 is completely dark and
//          1.0 is normal brightness.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetWindowBrightness
pub fn get_window_brightness(window &Window) f32 {
	return C.SDL_GetWindowBrightness(window)
}

fn C.SDL_SetWindowOpacity(window &C.SDL_Window, opacity f32) int

// set_window_opacity sets the opacity for a window.
//
// The parameter `opacity` will be clamped internally between 0.0f
// (transparent) and 1.0f (opaque).
//
// This function also returns -1 if setting the opacity isn't supported.
//
// `window` the window which will be made transparent or opaque
// `opacity` the opacity value (0.0f - transparent, 1.0f - opaque)
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_GetWindowOpacity
pub fn set_window_opacity(window &Window, opacity f32) int {
	return C.SDL_SetWindowOpacity(window, opacity)
}

fn C.SDL_GetWindowOpacity(window &C.SDL_Window, out_opacity &f32) int

// get_window_opacity gets the opacity of a window.
//
// If transparency isn't supported on this platform, opacity will be reported
// as 1.0f without error.
//
// The parameter `opacity` is ignored if it is NULL.
//
// This function also returns -1 if an invalid window was provided.
//
// `window` the window to get the current opacity value from
// `out_opacity` the float filled in (0.0f - transparent, 1.0f - opaque)
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_SetWindowOpacity
pub fn get_window_opacity(window &Window, out_opacity &f32) int {
	return C.SDL_GetWindowOpacity(window, out_opacity)
}

fn C.SDL_SetWindowModalFor(modal_window &C.SDL_Window, parent_window &C.SDL_Window) int

// set_window_modal_for sets the window as a modal for another window.
//
// `modal_window` the window that should be set modal
// `parent_window` the parent window for the modal window
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
pub fn set_window_modal_for(modal_window &Window, parent_window &Window) int {
	return C.SDL_SetWindowModalFor(modal_window, parent_window)
}

fn C.SDL_SetWindowInputFocus(window &C.SDL_Window) int

// set_window_input_focus explicitlys set input focus to the window.
//
// You almost certainly want SDL_RaiseWindow() instead of this function. Use
// this with caution, as you might give focus to a window that is completely
// obscured by other windows.
//
// `window` the window that should get the input focus
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.5.
//
// See also: SDL_RaiseWindow
pub fn set_window_input_focus(window &Window) int {
	return C.SDL_SetWindowInputFocus(window)
}

fn C.SDL_SetWindowGammaRamp(window &C.SDL_Window, const_red &u16, const_green &u16, const_blue &u16) int

// set_window_gamma_ramp sets the gamma ramp for the display that owns a given window.
//
// Set the gamma translation table for the red, green, and blue channels of
// the video hardware. Each table is an array of 256 16-bit quantities,
// representing a mapping between the input and output for that channel. The
// input is the index into the array, and the output is the 16-bit gamma value
// at that index, scaled to the output color precision.
//
// Despite the name and signature, this method sets the gamma ramp of the
// entire display, not an individual window. A window is considered to be
// owned by the display that contains the window's center pixel. (The index of
// this display can be retrieved using SDL_GetWindowDisplayIndex().) The gamma
// ramp set will not follow the window if it is moved to another display.
//
// `window` the window used to select the display whose gamma ramp will
//               be changed
// `red` a 256 element array of 16-bit quantities representing the
//            translation table for the red channel, or NULL
// `green` a 256 element array of 16-bit quantities representing the
//              translation table for the green channel, or NULL
// `blue` a 256 element array of 16-bit quantities representing the
//             translation table for the blue channel, or NULL
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GetWindowGammaRamp
pub fn set_window_gamma_ramp(window &Window, const_red &u16, const_green &u16, const_blue &u16) int {
	return C.SDL_SetWindowGammaRamp(window, const_red, const_green, const_blue)
}

fn C.SDL_GetWindowGammaRamp(window &C.SDL_Window, red &u16, green &u16, blue &u16) int

// get_window_gamma_ramp gets the gamma ramp for a given window's display.
//
// Despite the name and signature, this method retrieves the gamma ramp of the
// entire display, not an individual window. A window is considered to be
// owned by the display that contains the window's center pixel. (The index of
// this display can be retrieved using SDL_GetWindowDisplayIndex().)
//
// `window` the window used to select the display whose gamma ramp will
//               be queried
// `red` a 256 element array of 16-bit quantities filled in with the
//            translation table for the red channel, or NULL
// `green` a 256 element array of 16-bit quantities filled in with the
//              translation table for the green channel, or NULL
// `blue` a 256 element array of 16-bit quantities filled in with the
//             translation table for the blue channel, or NULL
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_SetWindowGammaRamp
pub fn get_window_gamma_ramp(window &Window, red &u16, green &u16, blue &u16) int {
	return C.SDL_GetWindowGammaRamp(window, red, green, blue)
}

fn C.SDL_SetWindowHitTest(window &C.SDL_Window, callback C.SDL_HitTest, callback_data voidptr) int

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
// Platforms that don't support this functionality will return -1
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
// `window` the window to set hit-testing on
// `callback` the function to call when doing a hit-test
// `callback_data` an app-defined void pointer passed to **callback**
// returns 0 on success or -1 on error (including unsupported); call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.4.
pub fn set_window_hit_test(window &Window, callback HitTest, callback_data voidptr) int {
	return C.SDL_SetWindowHitTest(window, C.SDL_HitTest(callback), callback_data)
}

fn C.SDL_FlashWindow(window &C.SDL_Window, operation C.SDL_FlashOperation) int

// flash_window requests a window to demand attention from the user.
//
// `window` the window to be flashed
// `operation` the flash operation
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.16.
pub fn flash_window(window &Window, operation FlashOperation) int {
	return C.SDL_FlashWindow(window, C.SDL_FlashOperation(operation))
}

fn C.SDL_DestroyWindow(window &C.SDL_Window)

// destroy_window destroys a window.
//
// If `window` is NULL, this function will return immediately after setting
// the SDL error message to "Invalid window". See SDL_GetError().
//
// `window` the window to destroy
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateWindow
// See also: SDL_CreateWindowFrom
pub fn destroy_window(window &Window) {
	C.SDL_DestroyWindow(window)
}

fn C.SDL_IsScreenSaverEnabled() bool

// is_screen_saver_enabled checks whether the screensaver is currently enabled.
//
// The screensaver is disabled by default since SDL 2.0.2. Before SDL 2.0.2
// the screensaver was enabled by default.
//
// The default can also be changed using `SDL_HINT_VIDEO_ALLOW_SCREENSAVER`.
//
// returns SDL_TRUE if the screensaver is enabled, SDL_FALSE if it is
//          disabled.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_DisableScreenSaver
// See also: SDL_EnableScreenSaver
pub fn is_screen_saver_enabled() bool {
	return C.SDL_IsScreenSaverEnabled()
}

fn C.SDL_EnableScreenSaver()

// enable_screen_saver allows the screen to be blanked by a screen saver.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_DisableScreenSaver
// See also: SDL_IsScreenSaverEnabled
pub fn enable_screen_saver() {
	C.SDL_EnableScreenSaver()
}

fn C.SDL_DisableScreenSaver()

// disable_screen_saver prevents the screen from being blanked by a screen saver.
//
// If you disable the screensaver, it is automatically re-enabled when SDL
// quits.
//
// The screensaver is disabled by default since SDL 2.0.2. Before SDL 2.0.2
// the screensaver was enabled by default.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_EnableScreenSaver
// See also: SDL_IsScreenSaverEnabled
pub fn disable_screen_saver() {
	C.SDL_DisableScreenSaver()
}

//
// OpenGL support functions
//

fn C.SDL_GL_LoadLibrary(path &char) int

// gl_load_library dynamicallys load an OpenGL library.
//
// This should be done after initializing the video driver, but before
// creating any OpenGL windows. If no OpenGL library is loaded, the default
// library will be loaded upon creation of the first OpenGL window.
//
// If you do this, you need to retrieve all of the GL functions used in your
// program from the dynamic library using SDL_GL_GetProcAddress().
//
// `path` the platform dependent OpenGL library name, or NULL to open the
//             default OpenGL library
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_GetProcAddress
// See also: SDL_GL_UnloadLibrary
pub fn gl_load_library(path &char) int {
	return C.SDL_GL_LoadLibrary(path)
}

fn C.SDL_GL_GetProcAddress(proc &char) voidptr

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
// `proc` the name of an OpenGL function
// returns a pointer to the named OpenGL function. The returned pointer
//          should be cast to the appropriate function signature.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_ExtensionSupported
// See also: SDL_GL_LoadLibrary
// See also: SDL_GL_UnloadLibrary
pub fn gl_get_proc_address(proc &char) voidptr {
	return C.SDL_GL_GetProcAddress(proc)
}

fn C.SDL_GL_UnloadLibrary()

// gl_unload_library unloads the OpenGL library previously loaded by SDL_GL_LoadLibrary().
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_LoadLibrary
pub fn gl_unload_library() {
	C.SDL_GL_UnloadLibrary()
}

fn C.SDL_GL_ExtensionSupported(extension &char) bool

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
// `extension` the name of the extension to check
// returns SDL_TRUE if the extension is supported, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.0.
pub fn gl_extension_supported(extension &char) bool {
	return C.SDL_GL_ExtensionSupported(extension)
}

fn C.SDL_GL_ResetAttributes()

// gl_reset_attributes resets all previously set OpenGL context attributes to their default values.
//
// NOTE This function is available since SDL 2.0.2.
//
// See also: SDL_GL_GetAttribute
// See also: SDL_GL_SetAttribute
pub fn gl_reset_attributes() {
	C.SDL_GL_ResetAttributes()
}

fn C.SDL_GL_SetAttribute(attr C.SDL_GLattr, value int) int

// gl_set_attribute sets an OpenGL window attribute before window creation.
//
// This function sets the OpenGL attribute `attr` to `value`. The requested
// attributes should be set before creating an OpenGL window. You should use
// SDL_GL_GetAttribute() to check the values after creating the OpenGL
// context, since the values obtained can differ from the requested ones.
//
// `attr` an SDL_GLattr enum value specifying the OpenGL attribute to set
// `value` the desired value for the attribute
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_GetAttribute
// See also: SDL_GL_ResetAttributes
pub fn gl_set_attribute(attr GLattr, value int) int {
	return C.SDL_GL_SetAttribute(C.SDL_GLattr(int(attr)), value)
}

fn C.SDL_GL_GetAttribute(attr C.SDL_GLattr, value &int) int

// gl_get_attribute gets the actual value for an attribute from the current context.
//
// `attr` an SDL_GLattr enum value specifying the OpenGL attribute to get
// `value` a pointer filled in with the current value of `attr`
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_ResetAttributes
// See also: SDL_GL_SetAttribute
pub fn gl_get_attribute(attr GLattr, value &int) int {
	return C.SDL_GL_GetAttribute(C.SDL_GLattr(int(attr)), value)
}

fn C.SDL_GL_CreateContext(window &C.SDL_Window) GLContext

// gl_create_context creates an OpenGL context for an OpenGL window, and make it current.
//
// Windows users new to OpenGL should note that, for historical reasons, GL
// functions added after OpenGL version 1.1 are not available by default.
// Those functions must be loaded at run-time, either with an OpenGL
// extension-handling library or with SDL_GL_GetProcAddress() and its related
// functions.
//
// SDL_GLContext is an alias for `void *`. It's opaque to the application.
//
// `window` the window to associate with the context
// returns the OpenGL context associated with `window` or NULL on error; call
//          SDL_GetError() for more details.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_DeleteContext
// See also: SDL_GL_MakeCurrent
pub fn gl_create_context(window &Window) GLContext {
	return GLContext(voidptr(C.SDL_GL_CreateContext(window)))
}

fn C.SDL_GL_MakeCurrent(window &C.SDL_Window, context C.SDL_GLContext) int

// gl_make_current sets up an OpenGL context for rendering into an OpenGL window.
//
// The context must have been created with a compatible window.
//
// `window` the window to associate with the context
// `context` the OpenGL context to associate with the window
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_CreateContext
pub fn gl_make_current(window &Window, context GLContext) int {
	return C.SDL_GL_MakeCurrent(window, voidptr(context))
}

fn C.SDL_GL_GetCurrentWindow() &C.SDL_Window

// gl_get_current_window gets the currently active OpenGL window.
//
// returns the currently active OpenGL window on success or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
pub fn gl_get_current_window() &Window {
	return C.SDL_GL_GetCurrentWindow()
}

fn C.SDL_GL_GetCurrentContext() GLContext

// gl_get_current_context gets the currently active OpenGL context.
//
// returns the currently active OpenGL context or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_MakeCurrent
pub fn gl_get_current_context() GLContext {
	return GLContext(voidptr(C.SDL_GL_GetCurrentContext()))
}

fn C.SDL_GL_GetDrawableSize(window &C.SDL_Window, w &int, h &int)

// gl_get_drawable_size gets the size of a window's underlying drawable in pixels.
//
// This returns info useful for calling glViewport().
//
// This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
// drawable, i.e. the window was created with `SDL_WINDOW_ALLOW_HIGHDPI` on a
// platform with high-DPI support (Apple calls this "Retina"), and not
// disabled by the `SDL_HINT_VIDEO_HIGHDPI_DISABLED` hint.
//
// `window` the window from which the drawable size should be queried
// `w` a pointer to variable for storing the width in pixels, may be NULL
// `h` a pointer to variable for storing the height in pixels, may be
//          NULL
//
// NOTE This function is available since SDL 2.0.1.
//
// See also: SDL_CreateWindow
// See also: SDL_GetWindowSize
pub fn gl_get_drawable_size(window &Window, w &int, h &int) {
	C.SDL_GL_GetDrawableSize(window, w, h)
}

fn C.SDL_GL_SetSwapInterval(interval int) int

// gl_set_swap_interval sets the swap interval for the current OpenGL context.
//
// Some systems allow specifying -1 for the interval, to enable adaptive
// vsync. Adaptive vsync works the same as vsync, but if you've already missed
// the vertical retrace for a given frame, it swaps buffers immediately, which
// might be less jarring for the user during occasional framerate drops. If an
// application requests adaptive vsync and the system does not support it,
// this function will fail and return -1. In such a case, you should probably
// retry the call with 1 for the interval.
//
// Adaptive vsync is implemented for some glX drivers with
// GLX_EXT_swap_control_tear, and for some Windows drivers with
// WGL_EXT_swap_control_tear.
//
// Read more on the Khronos wiki:
// https://www.khronos.org/opengl/wiki/Swap_Interval#Adaptive_Vsync
//
// `interval` 0 for immediate updates, 1 for updates synchronized with
//                 the vertical retrace, -1 for adaptive vsync
// returns 0 on success or -1 if setting the swap interval is not supported;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_GetSwapInterval
pub fn gl_set_swap_interval(interval int) int {
	return C.SDL_GL_SetSwapInterval(interval)
}

fn C.SDL_GL_GetSwapInterval() int

// gl_get_swap_interval gets the swap interval for the current OpenGL context.
//
// If the system can't determine the swap interval, or there isn't a valid
// current context, this function will return 0 as a safe default.
//
// returns 0 if there is no vertical retrace synchronization, 1 if the buffer
//          swap is synchronized with the vertical retrace, and -1 if late
//          swaps happen immediately instead of waiting for the next retrace;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_SetSwapInterval
pub fn gl_get_swap_interval() int {
	return C.SDL_GL_GetSwapInterval()
}

fn C.SDL_GL_SwapWindow(window &C.SDL_Window)

// gl_swap_window updates a window with OpenGL rendering.
//
// This is used with double-buffered OpenGL contexts, which are the default.
//
// On macOS, make sure you bind 0 to the draw framebuffer before swapping the
// window, otherwise nothing will happen. If you aren't using
// glBindFramebuffer(), this is the default and you won't have to do anything
// extra.
//
// `window` the window to change
//
// NOTE This function is available since SDL 2.0.0.
pub fn gl_swap_window(window &Window) {
	C.SDL_GL_SwapWindow(window)
}

fn C.SDL_GL_DeleteContext(context C.SDL_GLContext)

// gl_delete_context deletes an OpenGL context.
//
// `context` the OpenGL context to be deleted
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_GL_CreateContext
pub fn gl_delete_context(context GLContext) {
	C.SDL_GL_DeleteContext(voidptr(context))
}
