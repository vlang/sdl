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
[typedef]
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
// See also: SDL_GetWindowData()
// See also: SDL_GetWindowFlags()
// See also: SDL_GetWindowGrab()
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
// See also: SDL_SetWindowIcon()
// See also: SDL_SetWindowPosition()
// See also: SDL_SetWindowSize()
// See also: SDL_SetWindowBordered()
// See also: SDL_SetWindowResizable()
// See also: SDL_SetWindowTitle()
// See also: SDL_ShowWindow()
//
[typedef]
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
	input_grabbed      = C.SDL_WINDOW_INPUT_GRABBED // 0x00000100 window has grabbed input focus
	input_focus        = C.SDL_WINDOW_INPUT_FOCUS // 0x00000200 window has input focus
	mouse_focus        = C.SDL_WINDOW_MOUSE_FOCUS // 0x00000400 window has mouse focus
	fullscreen_desktop = C.SDL_WINDOW_FULLSCREEN_DESKTOP // ( SDL_WINDOW_FULLSCREEN | 0x00001000 )
	foreign            = C.SDL_WINDOW_FOREIGN // 0x00000800 window not created by SDL
	allow_highdpi      = C.SDL_WINDOW_ALLOW_HIGHDPI // 0x00002000 window should be created in high-DPI mode if supported. On macOS NSHighResolutionCapable must be set true in the application's Info.plist for this to have any effect.
	mouse_capture      = C.SDL_WINDOW_MOUSE_CAPTURE // 0x00004000 window has mouse captured (unrelated to INPUT_GRABBED)
	always_on_top      = C.SDL_WINDOW_ALWAYS_ON_TOP // 0x00008000 window should always be above others
	skip_taskbar       = C.SDL_WINDOW_SKIP_TASKBAR // 0x00010000 window should not be added to the taskbar
	utility            = C.SDL_WINDOW_UTILITY // 0x00020000 window should be treated as a utility window
	tooltip            = C.SDL_WINDOW_TOOLTIP // 0x00040000 window should be treated as a tooltip
	popup_menu         = C.SDL_WINDOW_POPUP_MENU // 0x00080000 window should be treated as a popup menu
	vulkan             = C.SDL_WINDOW_VULKAN // 0x10000000 window usable for Vulkan surface
}

// Used to indicate that you don't care what the window position is.
pub const (
	windowpos_undefined_mask = C.SDL_WINDOWPOS_UNDEFINED_MASK //   0x1FFF0000u
	windowpos_undefined      = C.SDL_WINDOWPOS_UNDEFINED //
)

fn C.SDL_WINDOWPOS_ISUNDEFINED(x u32) bool
pub fn windowpos_isundefined(x u32) bool {
	return C.SDL_WINDOWPOS_ISUNDEFINED(x)
}

fn C.SDL_WINDOWPOS_UNDEFINED_DISPLAY(x u32) u32
pub fn windowpos_undefined_display(x u32) u32 {
	return C.SDL_WINDOWPOS_UNDEFINED_DISPLAY(x)
}

// Used to indicate that the window position should be centered.
pub const (
	windowpos_centered_mask = C.SDL_WINDOWPOS_CENTERED_MASK // 0x2FFF0000u
	windowpos_centered      = C.SDL_WINDOWPOS_CENTERED
)

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
	@none        = C.SDL_WINDOWEVENT_NONE // Never used
	shown        = C.SDL_WINDOWEVENT_SHOWN // Window has been shown
	hidden       = C.SDL_WINDOWEVENT_HIDDEN // Window has been hidden
	exposed      = C.SDL_WINDOWEVENT_EXPOSED // Window has been exposed and should be redrawn
	moved        = C.SDL_WINDOWEVENT_MOVED // Window has been moved to data1, data2
	resized      = C.SDL_WINDOWEVENT_RESIZED // Window has been resized to data1xdata2
	size_changed = C.SDL_WINDOWEVENT_SIZE_CHANGED // The window size has changed, either as a result of an API call or through the system or user changing the window size.
	minimized    = C.SDL_WINDOWEVENT_MINIMIZED // Window has been minimized
	maximized    = C.SDL_WINDOWEVENT_MAXIMIZED // Window has been maximized
	restored     = C.SDL_WINDOWEVENT_RESTORED // Window has been restored to normal size and position
	enter        = C.SDL_WINDOWEVENT_ENTER // Window has gained mouse focus
	leave        = C.SDL_WINDOWEVENT_LEAVE // Window has lost mouse focus
	focus_gained = C.SDL_WINDOWEVENT_FOCUS_GAINED // Window has gained keyboard focus
	focus_lost   = C.SDL_WINDOWEVENT_FOCUS_LOST // Window has lost keyboard focus
	close        = C.SDL_WINDOWEVENT_CLOSE // The window manager requests that the window be closed
	take_focus   = C.SDL_WINDOWEVENT_TAKE_FOCUS // Window is being offered a focus (should SetWindowInputFocus() on itself or a subwindow, or ignore)
	hit_test     = C.SDL_WINDOWEVENT_HIT_TEST // Window had a hit test that wasn't SDL_HITTEST_NORMAL.
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

// get_num_video_drivers gets the number of video drivers compiled into SDL
//
// See also: SDL_GetVideoDriver()
pub fn get_num_video_drivers() int {
	return C.SDL_GetNumVideoDrivers()
}

fn C.SDL_GetVideoDriver(index int) &char

// get_video_driver gets the name of a built in video driver.
//
// NOTE The video drivers are presented in the order in which they are
// normally checked during initialization.
//
// See also: SDL_GetNumVideoDrivers()
pub fn get_video_driver(index int) &char {
	return C.SDL_GetVideoDriver(index)
}

fn C.SDL_VideoInit(driver_name &char) int

// video_init initializes the video subsystem, optionally specifying a video driver.
//
// `driver_name` Initialize a specific driver by name, or NULL for the
// default video driver.
//
// returns 0 on success, -1 on error
//
// This function initializes the video subsystem; setting up a connection
// to the window manager, etc, and determines the available display modes
// and pixel formats, but does not initialize a window or graphics mode.
//
// See also: SDL_VideoQuit()
pub fn video_init(driver_name &char) int {
	return C.SDL_VideoInit(driver_name)
}

fn C.SDL_VideoQuit()

// video_quit shuts down the video subsystem.
//
// This function closes all windows, and restores the original video mode.
//
// See also: SDL_VideoInit()
pub fn video_quit() {
	C.SDL_VideoQuit()
}

fn C.SDL_GetCurrentVideoDriver() &char

// get_current_video_driver returns the name of the currently initialized video driver.
//
// returns The name of the current video driver or NULL if no driver
// has been initialized
//
// See also: SDL_GetNumVideoDrivers()
// See also: SDL_GetVideoDriver()
pub fn get_current_video_driver() &char {
	return C.SDL_GetCurrentVideoDriver()
}

fn C.SDL_GetNumVideoDisplays() int

// get_num_video_displays returns the number of available video displays.
//
// See also: SDL_GetDisplayBounds()
pub fn get_num_video_displays() int {
	return C.SDL_GetNumVideoDisplays()
}

fn C.SDL_GetDisplayName(display_index int) &char

// get_display_name gets the name of a display in UTF-8 encoding
//
// returns The name of a display, or NULL for an invalid display index.
//
// See also: SDL_GetNumVideoDisplays()
pub fn get_display_name(display_index int) &char {
	return C.SDL_GetDisplayName(display_index)
}

fn C.SDL_GetDisplayBounds(display_index int, rect &C.SDL_Rect) int

// get_display_bounds gets the desktop area represented by a display, with the primary
// display located at 0,0
//
// returns 0 on success, or -1 if the index is out of range.
//
// See also: SDL_GetNumVideoDisplays()
pub fn get_display_bounds(display_index int, rect &Rect) int {
	return C.SDL_GetDisplayBounds(display_index, rect)
}

fn C.SDL_GetDisplayDPI(display_index int, ddpi &f32, hdpi &f32, vdpi &f32) int

// get_display_dpi gets the dots/pixels-per-inch for a display
//
// NOTE Diagonal, horizontal and vertical DPI can all be optionally
// returned if the parameter is non-NULL.
//
// returns 0 on success, or -1 if no DPI information is available or the index is out of range.
//
// See also: SDL_GetNumVideoDisplays()
pub fn get_display_dpi(display_index int, ddpi &f32, hdpi &f32, vdpi &f32) int {
	return C.SDL_GetDisplayDPI(display_index, ddpi, hdpi, vdpi)
}

fn C.SDL_GetDisplayUsableBounds(display_index int, rect &C.SDL_Rect) int

// get_display_usable_bounds gets the usable desktop area represented by a display, with the
// primary display located at 0,0
//
// This is the same area as SDL_GetDisplayBounds() reports, but with portions
// reserved by the system removed. For example, on Mac OS X, this subtracts
// the area occupied by the menu bar and dock.
//
// Setting a window to be fullscreen generally bypasses these unusable areas,
// so these are good guidelines for the maximum space available to a
// non-fullscreen window.
//
// returns 0 on success, or -1 if the index is out of range.
//
// See also: SDL_GetDisplayBounds()
// See also: SDL_GetNumVideoDisplays()
pub fn get_display_usable_bounds(display_index int, rect &Rect) int {
	return C.SDL_GetDisplayUsableBounds(display_index, rect)
}

fn C.SDL_GetNumDisplayModes(display_index int) int

// get_num_display_modes returns the number of available display modes.
//
// See also: SDL_GetDisplayMode()
pub fn get_num_display_modes(display_index int) int {
	return C.SDL_GetNumDisplayModes(display_index)
}

fn C.SDL_GetDisplayMode(display_index int, mode_index int, mode &C.SDL_DisplayMode) int

// get_display_mode fills in information about a specific display mode.
//
// NOTE The display modes are sorted in this priority:
// * bits per pixel -> more colors to fewer colors
// * width -> largest to smallest
// * height -> largest to smallest
// * refresh rate -> highest to lowest
//
// See also: SDL_GetNumDisplayModes()
pub fn get_display_mode(display_index int, mode_index int, mode &DisplayMode) int {
	return C.SDL_GetDisplayMode(display_index, mode_index, mode)
}

fn C.SDL_GetDesktopDisplayMode(display_index int, mode &C.SDL_DisplayMode) int

// get_desktop_display_mode fills in information about the desktop display mode.
pub fn get_desktop_display_mode(display_index int, mode &DisplayMode) int {
	return C.SDL_GetDesktopDisplayMode(display_index, mode)
}

fn C.SDL_GetCurrentDisplayMode(display_index int, mode &C.SDL_DisplayMode) int

// get_current_display_mode fills in information about the current display mode.
pub fn get_current_display_mode(display_index int, mode &DisplayMode) int {
	return C.SDL_GetCurrentDisplayMode(display_index, mode)
}

fn C.SDL_GetClosestDisplayMode(display_index int, const_mode &C.SDL_DisplayMode, closest &C.SDL_DisplayMode) &C.SDL_DisplayMode

// get_closest_display_mode gets the closest match to the requested display mode.
//
// `displayIndex` The index of display from which mode should be queried.
// `mode` The desired display mode
// `closest` A pointer to a display mode to be filled in with the closest
// match of the available display modes.
//
// returns The passed in value `closest`, or NULL if no matching video mode
// was available.
//
// The available display modes are scanned, and `closest` is filled in with the
// closest mode matching the requested mode and returned.  The mode format and
// refresh_rate default to the desktop mode if they are 0.  The modes are
// scanned with size being first priority, format being second priority, and
// finally checking the refresh_rate.  If all the available modes are too
// small, then NULL is returned.
//
// See also: SDL_GetNumDisplayModes()
// See also: SDL_GetDisplayMode()
pub fn get_closest_display_mode(display_index int, const_mode &DisplayMode, closest &DisplayMode) &DisplayMode {
	return C.SDL_GetClosestDisplayMode(display_index, const_mode, closest)
}

fn C.SDL_GetWindowDisplayIndex(window &C.SDL_Window) int

// get_window_display_index gets the display index associated with a window.
//
// returns the display index of the display containing the center of the
// window, or -1 on error.
pub fn get_window_display_index(window &Window) int {
	return C.SDL_GetWindowDisplayIndex(window)
}

fn C.SDL_SetWindowDisplayMode(window &C.SDL_Window, const_mode &C.SDL_DisplayMode) int

// set_window_display_mode sets the display mode used when a fullscreen window is visible.
//
// By default the window's dimensions and the desktop format and refresh rate
// are used.
//
// `window` The window for which the display mode should be set.
// `mode` The mode to use, or NULL for the default mode.
//
// returns 0 on success, or -1 if setting the display mode failed.
//
// See also: SDL_GetWindowDisplayMode()
// See also: SDL_SetWindowFullscreen()
pub fn set_window_display_mode(window &Window, const_mode &DisplayMode) int {
	return C.SDL_SetWindowDisplayMode(window, const_mode)
}

fn C.SDL_GetWindowDisplayMode(window &C.SDL_Window, mode &C.SDL_DisplayMode) int

// get_window_display_mode fills in information about the display mode used when a fullscreen
// window is visible.
//
// See also: SDL_SetWindowDisplayMode()
// See also: SDL_SetWindowFullscreen()
pub fn get_window_display_mode(window &Window, mode &DisplayMode) int {
	return C.SDL_GetWindowDisplayMode(window, mode)
}

fn C.SDL_GetWindowPixelFormat(window &C.SDL_Window) u32

// get_window_pixel_format gets the pixel format associated with the window.
pub fn get_window_pixel_format(window &Window) u32 {
	return C.SDL_GetWindowPixelFormat(window)
}

fn C.SDL_CreateWindow(title &char, x int, y int, w int, h int, flags u32) &C.SDL_Window

// create_window creates a window with the specified position, dimensions, and flags.
//
// `title` The title of the window, in UTF-8 encoding.
// `x`     The x position of the window, ::SDL_WINDOWPOS_CENTERED, or
// ::SDL_WINDOWPOS_UNDEFINED.
// `y`     The y position of the window, ::SDL_WINDOWPOS_CENTERED, or
// ::SDL_WINDOWPOS_UNDEFINED.
// `w`     The width of the window, in screen coordinates.
// `h`     The height of the window, in screen coordinates.
// `flags` The flags for the window, a mask of any of the following:
// ::SDL_WINDOW_FULLSCREEN,    ::SDL_WINDOW_OPENGL,
// ::SDL_WINDOW_HIDDEN,        ::SDL_WINDOW_BORDERLESS,
// ::SDL_WINDOW_RESIZABLE,     ::SDL_WINDOW_MAXIMIZED,
// ::SDL_WINDOW_MINIMIZED,     ::SDL_WINDOW_INPUT_GRABBED,
// ::SDL_WINDOW_ALLOW_HIGHDPI, ::SDL_WINDOW_VULKAN.
//
// returns The created window, or NULL if window creation failed.
//
// If the window is created with the SDL_WINDOW_ALLOW_HIGHDPI flag, its size
// in pixels may differ from its size in screen coordinates on platforms with
// high-DPI support (e.g. iOS and Mac OS X). Use SDL_GetWindowSize() to query
// the client area's size in screen coordinates, and SDL_GL_GetDrawableSize(),
// SDL_Vulkan_GetDrawableSize(), or SDL_GetRendererOutputSize() to query the
// drawable size in pixels.
//
// If the window is created with any of the SDL_WINDOW_OPENGL or
// SDL_WINDOW_VULKAN flags, then the corresponding LoadLibrary function
// (SDL_GL_LoadLibrary or SDL_Vulkan_LoadLibrary) is called and the
// corresponding UnloadLibrary function is called by SDL_DestroyWindow().
//
// If SDL_WINDOW_VULKAN is specified and there isn't a working Vulkan driver,
// SDL_CreateWindow() will fail because SDL_Vulkan_LoadLibrary() will fail.
//
// NOTE On non-Apple devices, SDL requires you to either not link to the
// Vulkan loader or link to a dynamic library version. This limitation
// may be removed in a future version of SDL.
//
// See also: SDL_DestroyWindow()
// See also: SDL_GL_LoadLibrary()
// See also: SDL_Vulkan_LoadLibrary()
pub fn create_window(title &char, x int, y int, w int, h int, flags u32) &Window {
	return C.SDL_CreateWindow(title, x, y, w, h, flags)
}

fn C.SDL_CreateWindowFrom(data voidptr) &C.SDL_Window

// create_window_from creates an SDL window from an existing native window.
//
// `data` A pointer to driver-dependent window creation data
//
// returns The created window, or NULL if window creation failed.
//
// See also: SDL_DestroyWindow()
pub fn create_window_from(data voidptr) &Window {
	return C.SDL_CreateWindowFrom(data)
}

fn C.SDL_GetWindowID(window &C.SDL_Window) u32

// get_window_id gets the numeric ID of a window, for logging purposes.
pub fn get_window_id(window &Window) u32 {
	return C.SDL_GetWindowID(window)
}

fn C.SDL_GetWindowFromID(id u32) &C.SDL_Window

// get_window_from_id gets a window from a stored ID, or NULL if it doesn't exist.
pub fn get_window_from_id(id u32) &Window {
	return C.SDL_GetWindowFromID(id)
}

fn C.SDL_GetWindowFlags(window &C.SDL_Window) u32

// get_window_flags gets the window flags.
pub fn get_window_flags(window &Window) u32 {
	return C.SDL_GetWindowFlags(window)
}

fn C.SDL_SetWindowTitle(window &C.SDL_Window, const_title &char)

// set_window_title sets the title of a window, in UTF-8 format.
//
// See also: SDL_GetWindowTitle()
pub fn set_window_title(window &Window, const_title &char) {
	C.SDL_SetWindowTitle(window, const_title)
}

fn C.SDL_GetWindowTitle(window &C.SDL_Window) &char

// get_window_title gets the title of a window, in UTF-8 format.
//
// See also: SDL_SetWindowTitle()
pub fn get_window_title(window &Window) &char {
	return C.SDL_GetWindowTitle(window)
}

fn C.SDL_SetWindowIcon(window &C.SDL_Window, icon &C.SDL_Surface)

// set_window_icon sets the icon for a window.
//
// `window` The window for which the icon should be set.
// `icon` The icon for the window.
pub fn set_window_icon(window &Window, icon &Surface) {
	C.SDL_SetWindowIcon(window, icon)
}

fn C.SDL_SetWindowData(window &C.SDL_Window, const_name &char, userdata voidptr) voidptr

// set_window_data associates an arbitrary named pointer with a window.
//
// `window`   The window to associate with the pointer.
// `name`     The name of the pointer.
// `userdata` The associated pointer.
//
// returns The previous value associated with 'name'
//
// NOTE The name is case-sensitive.
//
// See also: SDL_GetWindowData()
pub fn set_window_data(window &Window, const_name &char, userdata voidptr) voidptr {
	return C.SDL_SetWindowData(window, const_name, userdata)
}

fn C.SDL_GetWindowData(window &C.SDL_Window, const_name &char) voidptr

// get_window_data retrieves the data pointer associated with a window.
//
// `window`   The window to query.
// `name`     The name of the pointer.
//
// returns The value associated with 'name'
//
// See also: SDL_SetWindowData()
pub fn get_window_data(window &Window, const_name &char) voidptr {
	return C.SDL_GetWindowData(window, const_name)
}

fn C.SDL_SetWindowPosition(window &C.SDL_Window, x int, y int)

// set_window_position sets the position of a window.
//
// `window`   The window to reposition.
// `x`        The x coordinate of the window in screen coordinates, or
// ::SDL_WINDOWPOS_CENTERED or ::SDL_WINDOWPOS_UNDEFINED.
// `y`        The y coordinate of the window in screen coordinates, or
// ::SDL_WINDOWPOS_CENTERED or ::SDL_WINDOWPOS_UNDEFINED.
//
// NOTE The window coordinate origin is the upper left of the display.
//
// See also: SDL_GetWindowPosition()
pub fn set_window_position(window &Window, x int, y int) {
	C.SDL_SetWindowPosition(window, x, y)
}

fn C.SDL_GetWindowPosition(window &C.SDL_Window, x &int, y &int)

// get_window_position gets the position of a window.
//
// `window`   The window to query.
// `x`        Pointer to variable for storing the x position, in screen
// coordinates. May be NULL.
// `y`        Pointer to variable for storing the y position, in screen
// coordinates. May be NULL.
//
// See also: SDL_SetWindowPosition()
pub fn get_window_position(window &Window, x &int, y &int) {
	C.SDL_GetWindowPosition(window, x, y)
}

fn C.SDL_SetWindowSize(window &C.SDL_Window, w int, h int)

// set_window_size sets the size of a window's client area.
//
// `window`   The window to resize.
// `w`        The width of the window, in screen coordinates. Must be >0.
// `h`        The height of the window, in screen coordinates. Must be >0.
//
// NOTE Fullscreen windows automatically match the size of the display mode,
// and you should use SDL_SetWindowDisplayMode() to change their size.
//
// The window size in screen coordinates may differ from the size in pixels, if
// the window was created with SDL_WINDOW_ALLOW_HIGHDPI on a platform with
// high-dpi support (e.g. iOS or OS X). Use SDL_GL_GetDrawableSize() or
// SDL_GetRendererOutputSize() to get the real client area size in pixels.
//
// See also: SDL_GetWindowSize()
// See also: SDL_SetWindowDisplayMode()
pub fn set_window_size(window &Window, w int, h int) {
	C.SDL_SetWindowSize(window, w, h)
}

fn C.SDL_GetWindowSize(window &C.SDL_Window, w &int, h &int)

// get_window_size gets the size of a window's client area.
//
// `window`   The window to query.
// `w`        Pointer to variable for storing the width, in screen
// coordinates. May be NULL.
// `h`        Pointer to variable for storing the height, in screen
// coordinates. May be NULL.
//
// The window size in screen coordinates may differ from the size in pixels, if
// the window was created with SDL_WINDOW_ALLOW_HIGHDPI on a platform with
// high-dpi support (e.g. iOS or OS X). Use SDL_GL_GetDrawableSize() or
// SDL_GetRendererOutputSize() to get the real client area size in pixels.
//
// See also: SDL_SetWindowSize()
pub fn get_window_size(window &Window, w &int, h &int) {
	C.SDL_GetWindowSize(window, w, h)
}

fn C.SDL_GetWindowBordersSize(window &C.SDL_Window, top &int, left &int, bottom &int, right &int) int

// get_window_borders_size gets the size of a window's borders (decorations) around the client area.
//
// `window` The window to query.
// `top` Pointer to variable for storing the size of the top border. NULL is permitted.
// `left` Pointer to variable for storing the size of the left border. NULL is permitted.
// `bottom` Pointer to variable for storing the size of the bottom border. NULL is permitted.
// `right` Pointer to variable for storing the size of the right border. NULL is permitted.
//
// returns 0 on success, or -1 if getting this information is not supported.
//
// NOTE if this function fails (returns -1), the size values will be
// initialized to 0, 0, 0, 0 (if a non-NULL pointer is provided), as
// if the window in question was borderless.
pub fn get_window_borders_size(window &Window, top &int, left &int, bottom &int, right &int) int {
	return C.SDL_GetWindowBordersSize(window, top, left, bottom, right)
}

fn C.SDL_SetWindowMinimumSize(window &C.SDL_Window, min_w int, min_h int)

// set_window_minimum_size sets the minimum size of a window's client area.
//
// `window`    The window to set a new minimum size.
// `min_w`     The minimum width of the window, must be >0
// `min_h`     The minimum height of the window, must be >0
//
// NOTE You can't change the minimum size of a fullscreen window, it
// automatically matches the size of the display mode.
//
// See also: SDL_GetWindowMinimumSize()
// See also: SDL_SetWindowMaximumSize()
pub fn set_window_minimum_size(window &Window, min_w int, min_h int) {
	C.SDL_SetWindowMinimumSize(window, min_w, min_h)
}

fn C.SDL_GetWindowMinimumSize(window &C.SDL_Window, w &int, h &int)

// get_window_minimum_size gets the minimum size of a window's client area.
//
// `window`   The window to query.
// `w`        Pointer to variable for storing the minimum width, may be NULL
// `h`        Pointer to variable for storing the minimum height, may be NULL
//
// See also: SDL_GetWindowMaximumSize()
// See also: SDL_SetWindowMinimumSize()
pub fn get_window_minimum_size(window &Window, w &int, h &int) {
	C.SDL_GetWindowMinimumSize(window, w, h)
}

fn C.SDL_SetWindowMaximumSize(window &C.SDL_Window, max_w int, max_h int)

// set_window_maximum_size sets the maximum size of a window's client area.
//
// `window`    The window to set a new maximum size.
// `max_w`     The maximum width of the window, must be >0
// `max_h`     The maximum height of the window, must be >0
//
// NOTE You can't change the maximum size of a fullscreen window, it
// automatically matches the size of the display mode.
//
// See also: SDL_GetWindowMaximumSize()
// See also: SDL_SetWindowMinimumSize()
pub fn set_window_maximum_size(window &Window, max_w int, max_h int) {
	C.SDL_SetWindowMaximumSize(window, max_w, max_h)
}

fn C.SDL_GetWindowMaximumSize(window &C.SDL_Window, w &int, h &int)

// get_window_maximum_size gets the maximum size of a window's client area.
//
// `window`   The window to query.
// `w`        Pointer to variable for storing the maximum width, may be NULL
// `h`        Pointer to variable for storing the maximum height, may be NULL
//
// See also: SDL_GetWindowMinimumSize()
// See also: SDL_SetWindowMaximumSize()
pub fn get_window_maximum_size(window &Window, w &int, h &int) {
	C.SDL_GetWindowMaximumSize(window, w, h)
}

fn C.SDL_SetWindowBordered(window &C.SDL_Window, bordered bool)

// set_window_bordered sets the border state of a window.
//
// This will add or remove the window's SDL_WINDOW_BORDERLESS flag and
// add or remove the border from the actual window. This is a no-op if the
// window's border already matches the requested state.
//
// `window` The window of which to change the border state.
// `bordered` SDL_FALSE to remove border, SDL_TRUE to add border.
//
// NOTE You can't change the border state of a fullscreen window.
//
// See also: SDL_GetWindowFlags()
pub fn set_window_bordered(window &Window, bordered bool) {
	C.SDL_SetWindowBordered(window, bordered)
}

fn C.SDL_SetWindowResizable(window &C.SDL_Window, resizable bool)

// set_window_resizable sets the user-resizable state of a window.
//
// This will add or remove the window's SDL_WINDOW_RESIZABLE flag and
// allow/disallow user resizing of the window. This is a no-op if the
// window's resizable state already matches the requested state.
//
// `window` The window of which to change the resizable state.
// `resizable` SDL_TRUE to allow resizing, SDL_FALSE to disallow.
//
// NOTE You can't change the resizable state of a fullscreen window.
//
// See also: SDL_GetWindowFlags()
pub fn set_window_resizable(window &Window, resizable bool) {
	C.SDL_SetWindowResizable(window, resizable)
}

fn C.SDL_ShowWindow(window &C.SDL_Window)

// show_window shows a window.
//
// See also: SDL_HideWindow()
pub fn show_window(window &Window) {
	C.SDL_ShowWindow(window)
}

fn C.SDL_HideWindow(window &C.SDL_Window)

// hide_window hides a window.
//
// See also: SDL_ShowWindow()
pub fn hide_window(window &Window) {
	C.SDL_HideWindow(window)
}

fn C.SDL_RaiseWindow(window &C.SDL_Window)

// raise_window raises a window above other windows and set the input focus.
pub fn raise_window(window &Window) {
	C.SDL_RaiseWindow(window)
}

fn C.SDL_MaximizeWindow(window &C.SDL_Window)

// maximize_window makes a window as large as possible.
//
// See also: SDL_RestoreWindow()
pub fn maximize_window(window &Window) {
	C.SDL_MaximizeWindow(window)
}

fn C.SDL_MinimizeWindow(window &C.SDL_Window)

// minimize_window minimizes a window to an iconic representation.
//
// See also: SDL_RestoreWindow()
pub fn minimize_window(window &Window) {
	C.SDL_MinimizeWindow(window)
}

fn C.SDL_RestoreWindow(window &C.SDL_Window)

// restore_window restores the size and position of a minimized or maximized window.
//
// See also: SDL_MaximizeWindow()
// See also: SDL_MinimizeWindow()
pub fn restore_window(window &Window) {
	C.SDL_RestoreWindow(window)
}

fn C.SDL_SetWindowFullscreen(window &C.SDL_Window, flags u32) int

// set_window_fullscreen sets a window's fullscreen state.
//
// returns 0 on success, or -1 if setting the display mode failed.
//
// See also: SDL_SetWindowDisplayMode()
// See also: SDL_GetWindowDisplayMode()
pub fn set_window_fullscreen(window &Window, flags u32) int {
	return C.SDL_SetWindowFullscreen(window, flags)
}

fn C.SDL_GetWindowSurface(window &C.SDL_Window) &C.SDL_Surface

// get_window_surface gets the SDL surface associated with the window.
//
// returns The window's framebuffer surface, or NULL on error.
//
// A new surface will be created with the optimal format for the window,
// if necessary. This surface will be freed when the window is destroyed.
//
// NOTE You may not combine this with 3D or the rendering API on this window.
//
// See also: SDL_UpdateWindowSurface()
// See also: SDL_UpdateWindowSurfaceRects()
pub fn get_window_surface(window &Window) &Surface {
	return C.SDL_GetWindowSurface(window)
}

fn C.SDL_UpdateWindowSurface(window &C.SDL_Window) int

// update_window_surface copies the window surface to the screen.
//
// returns 0 on success, or -1 on error.
//
// See also: SDL_GetWindowSurface()
// See also: SDL_UpdateWindowSurfaceRects()
pub fn update_window_surface(window &Window) int {
	return C.SDL_UpdateWindowSurface(window)
}

fn C.SDL_UpdateWindowSurfaceRects(window &C.SDL_Window, const_rects &C.SDL_Rect, numconst_rects int) int

// update_window_surface_rects copies a number of rectangles on the window surface to the screen.
//
// returns 0 on success, or -1 on error.
//
// See also: SDL_GetWindowSurface()
// See also: SDL_UpdateWindowSurface()
pub fn update_window_surface_rects(window &Window, const_rects &Rect, numconst_rects int) int {
	return C.SDL_UpdateWindowSurfaceRects(window, const_rects, numconst_rects)
}

fn C.SDL_SetWindowGrab(window &C.SDL_Window, grabbed bool)

// set_window_grab sets a window's input grab mode.
//
// `window` The window for which the input grab mode should be set.
// `grabbed` This is SDL_TRUE to grab input, and SDL_FALSE to release input.
//
// If the caller enables a grab while another window is currently grabbed,
// the other window loses its grab in favor of the caller's window.
//
// See also: SDL_GetWindowGrab()
pub fn set_window_grab(window &Window, grabbed bool) {
	C.SDL_SetWindowGrab(window, grabbed)
}

fn C.SDL_GetWindowGrab(window &C.SDL_Window) bool

// get_window_grab gets a window's input grab mode.
//
// returns This returns SDL_TRUE if input is grabbed, and SDL_FALSE otherwise.
//
// See also: SDL_SetWindowGrab()
pub fn get_window_grab(window &Window) bool {
	return C.SDL_GetWindowGrab(window)
}

fn C.SDL_GetGrabbedWindow() &C.SDL_Window

// get_grabbed_window gets the window that currently has an input grab enabled.
//
// returns This returns the window if input is grabbed, and NULL otherwise.
//
// See also: SDL_SetWindowGrab()
pub fn get_grabbed_window() &Window {
	return C.SDL_GetGrabbedWindow()
}

fn C.SDL_SetWindowBrightness(window &C.SDL_Window, brightness f32) int

// set_window_brightness sets the brightness (gamma correction) for a window.
//
// returns 0 on success, or -1 if setting the brightness isn't supported.
//
// See also: SDL_GetWindowBrightness()
// See also: SDL_SetWindowGammaRamp()
pub fn set_window_brightness(window &Window, brightness f32) int {
	return C.SDL_SetWindowBrightness(window, brightness)
}

fn C.SDL_GetWindowBrightness(window &C.SDL_Window) f32

// get_window_brightness gets the brightness (gamma correction) for a window.
//
// returns The last brightness value passed to SDL_SetWindowBrightness()
//
// See also: SDL_SetWindowBrightness()
pub fn get_window_brightness(window &Window) f32 {
	return C.SDL_GetWindowBrightness(window)
}

fn C.SDL_SetWindowOpacity(window &C.SDL_Window, opacity f32) int

// set_window_opacity sets the opacity for a window
//
// `window` The window which will be made transparent or opaque
// `opacity` Opacity (0.0f - transparent, 1.0f - opaque) This will be
// clamped internally between 0.0f and 1.0f.
//
// returns 0 on success, or -1 if setting the opacity isn't supported.
//
// See also: SDL_GetWindowOpacity()
pub fn set_window_opacity(window &Window, opacity f32) int {
	return C.SDL_SetWindowOpacity(window, opacity)
}

fn C.SDL_GetWindowOpacity(window &C.SDL_Window, out_opacity &f32) int

// get_window_opacity gets the opacity of a window.
//
// If transparency isn't supported on this platform, opacity will be reported
// as 1.0f without error.
//
// `window` The window in question.
// `out_opacity` Opacity (0.0f - transparent, 1.0f - opaque)
//
// returns 0 on success, or -1 on error (invalid window, etc).
//
// See also: SDL_SetWindowOpacity()
pub fn get_window_opacity(window &Window, out_opacity &f32) int {
	return C.SDL_GetWindowOpacity(window, out_opacity)
}

fn C.SDL_SetWindowModalFor(modal_window &C.SDL_Window, parent_window &C.SDL_Window) int

// set_window_modal_for sets the window as a modal for another window (TODO: reconsider this function and/or its name)
//
// `modal_window` The window that should be modal
// `parent_window` The parent window
//
// returns 0 on success, or -1 otherwise.
pub fn set_window_modal_for(modal_window &Window, parent_window &Window) int {
	return C.SDL_SetWindowModalFor(modal_window, parent_window)
}

fn C.SDL_SetWindowInputFocus(window &C.SDL_Window) int

// set_window_input_focus explicitly sets input focus to the window.
//
// You almost certainly want SDL_RaiseWindow() instead of this function. Use
// this with caution, as you might give focus to a window that's completely
// obscured by other windows.
//
// `window` The window that should get the input focus
//
// returns 0 on success, or -1 otherwise.
// See also: SDL_RaiseWindow()
pub fn set_window_input_focus(window &Window) int {
	return C.SDL_SetWindowInputFocus(window)
}

fn C.SDL_SetWindowGammaRamp(window &C.SDL_Window, const_red &u16, const_green &u16, const_blue &u16) int

// set_window_gamma_ramp sets the gamma ramp for a window.
//
// `window` The window for which the gamma ramp should be set.
// `red` The translation table for the red channel, or NULL.
// `green` The translation table for the green channel, or NULL.
// `blue` The translation table for the blue channel, or NULL.
//
// returns 0 on success, or -1 if gamma ramps are unsupported.
//
// Set the gamma translation table for the red, green, and blue channels
// of the video hardware.  Each table is an array of 256 16-bit quantities,
// representing a mapping between the input and output for that channel.
// The input is the index into the array, and the output is the 16-bit
// gamma value at that index, scaled to the output color precision.
//
// See also: SDL_GetWindowGammaRamp()
pub fn set_window_gamma_ramp(window &Window, const_red &u16, const_green &u16, const_blue &u16) int {
	return C.SDL_SetWindowGammaRamp(window, const_red, const_green, const_blue)
}

fn C.SDL_GetWindowGammaRamp(window &C.SDL_Window, red &u16, green &u16, blue &u16) int

// get_window_gamma_ramp gets the gamma ramp for a window.
//
// `window` The window from which the gamma ramp should be queried.
// `red`   A pointer to a 256 element array of 16-bit quantities to hold
// the translation table for the red channel, or NULL.
// `green` A pointer to a 256 element array of 16-bit quantities to hold
// the translation table for the green channel, or NULL.
// `blue`  A pointer to a 256 element array of 16-bit quantities to hold
// the translation table for the blue channel, or NULL.
//
// returns 0 on success, or -1 if gamma ramps are unsupported.
//
// See also: SDL_SetWindowGammaRamp()
pub fn get_window_gamma_ramp(window &Window, red &u16, green &u16, blue &u16) int {
	return C.SDL_GetWindowGammaRamp(window, red, green, blue)
}

fn C.SDL_SetWindowHitTest(window &C.SDL_Window, callback C.SDL_HitTest, callback_data voidptr) int

// set_window_hit_test provides a callback that decides if a window region has special properties.
//
// Normally windows are dragged and resized by decorations provided by the
// system window manager (a title bar, borders, etc), but for some apps, it
// makes sense to drag them from somewhere else inside the window itself; for
// example, one might have a borderless window that wants to be draggable
// from any part, or simulate its own title bar, etc.
//
// This function lets the app provide a callback that designates pieces of
// a given window as special. This callback is run during event processing
// if we need to tell the OS to treat a region of the window specially; the
// use of this callback is known as "hit testing."
//
// Mouse input may not be delivered to your application if it is within
// a special area; the OS will often apply that input to moving the window or
// resizing the window and not deliver it to the application.
//
// Specifying NULL for a callback disables hit-testing. Hit-testing is
// disabled by default.
//
// Platforms that don't support this functionality will return -1
// unconditionally, even if you're attempting to disable hit-testing.
//
// Your callback may fire at any time, and its firing does not indicate any
// specific behavior (for example, on Windows, this certainly might fire
// when the OS is deciding whether to drag your window, but it fires for lots
// of other reasons, too, some unrelated to anything you probably care about
// _and when the mouse isn't actually at the location it is testing_).
// Since this can fire at any time, you should try to keep your callback
// efficient, devoid of allocations, etc.
//
// `window` The window to set hit-testing on.
// `callback` The callback to call when doing a hit-test.
// `callback_data` An app-defined void pointer passed to the callback.
// returns 0 on success, -1 on error (including unsupported).
pub fn set_window_hit_test(window &Window, callback HitTest, callback_data voidptr) int {
	return C.SDL_SetWindowHitTest(window, C.SDL_HitTest(callback), callback_data)
}

fn C.SDL_DestroyWindow(window &C.SDL_Window)

// destroy_window destroys a window.
pub fn destroy_window(window &Window) {
	C.SDL_DestroyWindow(window)
}

fn C.SDL_IsScreenSaverEnabled() bool

// is_screen_saver_enabled returns whether the screensaver is currently enabled (default off).
//
// See also: SDL_EnableScreenSaver()
// See also: SDL_DisableScreenSaver()
pub fn is_screen_saver_enabled() bool {
	return C.SDL_IsScreenSaverEnabled()
}

fn C.SDL_EnableScreenSaver()

// enable_screen_saver allows the screen to be blanked by a screensaver
//
// See also: SDL_IsScreenSaverEnabled()
// See also: SDL_DisableScreenSaver()
pub fn enable_screen_saver() {
	C.SDL_EnableScreenSaver()
}

fn C.SDL_DisableScreenSaver()

// disable_screen_saver prevents the screen from being blanked by a screensaver
//
// See also: SDL_IsScreenSaverEnabled()
// See also: SDL_EnableScreenSaver()
pub fn disable_screen_saver() {
	C.SDL_DisableScreenSaver()
}

//
// OpenGL support functions
//

fn C.SDL_GL_LoadLibrary(path &char) int

// gl_load_library dynamically load an OpenGL library.
//
// `path` The platform dependent OpenGL library name, or NULL to open the
// default OpenGL library.
//
// returns 0 on success, or -1 if the library couldn't be loaded.
//
// This should be done after initializing the video driver, but before
// creating any OpenGL windows.  If no OpenGL library is loaded, the default
// library will be loaded upon creation of the first OpenGL window.
//
// NOTE If you do this, you need to retrieve all of the GL functions used in
// your program from the dynamic library using SDL_GL_GetProcAddress().
//
// See also: SDL_GL_GetProcAddress()
// See also: SDL_GL_UnloadLibrary()
pub fn gl_load_library(path &char) int {
	return C.SDL_GL_LoadLibrary(path)
}

fn C.SDL_GL_GetProcAddress(proc &char) voidptr

// gl_get_proc_address gets the address of an OpenGL function.
pub fn gl_get_proc_address(proc &char) voidptr {
	return C.SDL_GL_GetProcAddress(proc)
}

fn C.SDL_GL_UnloadLibrary()

// gl_unload_library unloads the OpenGL library previously loaded by SDL_GL_LoadLibrary().
//
// See also: SDL_GL_LoadLibrary()
pub fn gl_unload_library() {
	C.SDL_GL_UnloadLibrary()
}

fn C.SDL_GL_ExtensionSupported(extension &char) bool

// gl_extension_supported returns true if an OpenGL extension is supported for the current
// context.
pub fn gl_extension_supported(extension &char) bool {
	return C.SDL_GL_ExtensionSupported(extension)
}

fn C.SDL_GL_ResetAttributes()

// gl_reset_attributes resets all previously set OpenGL context attributes to their default values
pub fn gl_reset_attributes() {
	C.SDL_GL_ResetAttributes()
}

fn C.SDL_GL_SetAttribute(attr C.SDL_GLattr, value int) int

// gl_set_attribute sets an OpenGL window attribute before window creation.
//
// returns 0 on success, or -1 if the attribute could not be set.
pub fn gl_set_attribute(attr GLattr, value int) int {
	return C.SDL_GL_SetAttribute(C.SDL_GLattr(int(attr)), value)
}

fn C.SDL_GL_GetAttribute(attr C.SDL_GLattr, value &int) int

// gl_get_attribute gets the actual value for an attribute from the current context.
//
// returns 0 on success, or -1 if the attribute could not be retrieved.
// The integer at `value` will be modified in either case.
pub fn gl_get_attribute(attr GLattr, value &int) int {
	return C.SDL_GL_GetAttribute(C.SDL_GLattr(int(attr)), value)
}

fn C.SDL_GL_CreateContext(window &C.SDL_Window) C.SDL_GLContext

// gl_create_context creates an OpenGL context for use with an OpenGL window, and make it
// current.
//
// See also: SDL_GL_DeleteContext()
pub fn gl_create_context(window &Window) GLContext {
	return GLContext(voidptr(C.SDL_GL_CreateContext(window)))
}

fn C.SDL_GL_MakeCurrent(window &C.SDL_Window, context C.SDL_GLContext) int

// gl_make_current sets up an OpenGL context for rendering into an OpenGL window.
//
// NOTE The context must have been created with a compatible window.
pub fn gl_make_current(window &Window, context GLContext) int {
	return C.SDL_GL_MakeCurrent(window, voidptr(context))
}

fn C.SDL_GL_GetCurrentWindow() &C.SDL_Window

// gl_get_current_window gets the currently active OpenGL window.
pub fn gl_get_current_window() &Window {
	return C.SDL_GL_GetCurrentWindow()
}

fn C.SDL_GL_GetCurrentContext() C.SDL_GLContext

// gl_get_current_context gets the currently active OpenGL context.
pub fn gl_get_current_context() GLContext {
	return GLContext(voidptr(C.SDL_GL_GetCurrentContext()))
}

fn C.SDL_GL_GetDrawableSize(window &C.SDL_Window, w &int, h &int)

// gl_get_drawable_size gets the size of a window's underlying drawable in pixels (for use
// with glViewport).
//
// `window`   Window from which the drawable size should be queried
// `w`        Pointer to variable for storing the width in pixels, may be NULL
// `h`        Pointer to variable for storing the height in pixels, may be NULL
//
// This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
// drawable, i.e. the window was created with SDL_WINDOW_ALLOW_HIGHDPI on a
// platform with high-DPI support (Apple calls this "Retina"), and not disabled
// by the SDL_HINT_VIDEO_HIGHDPI_DISABLED hint.
//
// See also: SDL_GetWindowSize()
// See also: SDL_CreateWindow()
pub fn gl_get_drawable_size(window &Window, w &int, h &int) {
	C.SDL_GL_GetDrawableSize(window, w, h)
}

fn C.SDL_GL_SetSwapInterval(interval int) int

// gl_set_swap_interval sets the swap interval for the current OpenGL context.
//
// `interval` 0 for immediate updates, 1 for updates synchronized with the
// vertical retrace. If the system supports it, you may
// specify -1 to allow late swaps to happen immediately
// instead of waiting for the next retrace.
//
// returns 0 on success, or -1 if setting the swap interval is not supported.
//
// See also: SDL_GL_GetSwapInterval()
pub fn gl_set_swap_interval(interval int) int {
	return C.SDL_GL_SetSwapInterval(interval)
}

fn C.SDL_GL_GetSwapInterval() int

// gl_get_swap_interval gets the swap interval for the current OpenGL context.
//
// returns 0 if there is no vertical retrace synchronization, 1 if the buffer
// swap is synchronized with the vertical retrace, and -1 if late
// swaps happen immediately instead of waiting for the next retrace.
// If the system can't determine the swap interval, or there isn't a
// valid current context, this will return 0 as a safe default.
//
// See also: SDL_GL_SetSwapInterval()
pub fn gl_get_swap_interval() int {
	return C.SDL_GL_GetSwapInterval()
}

fn C.SDL_GL_SwapWindow(window &C.SDL_Window)

// gl_swap_window swaps the OpenGL buffers for a window, if double-buffering is
// supported.
pub fn gl_swap_window(window &Window) {
	C.SDL_GL_SwapWindow(window)
}

fn C.SDL_GL_DeleteContext(context C.SDL_GLContext)

// gl_delete_context deletes an OpenGL context.
//
// See also: SDL_GL_CreateContext()
pub fn gl_delete_context(context GLContext) {
	C.SDL_GL_DeleteContext(voidptr(context))
}
