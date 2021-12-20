// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_video.h
// (/usr/include/SDL2/SDL_video.h)
//

/**
 *  \brief  The structure that defines a display mode
 *
 *  \sa SDL_GetNumDisplayModes()
 *  \sa SDL_GetDisplayMode()
 *  \sa SDL_GetDesktopDisplayMode()
 *  \sa SDL_GetCurrentDisplayMode()
 *  \sa SDL_GetClosestDisplayMode()
 *  \sa SDL_SetWindowDisplayMode()
 *  \sa SDL_GetWindowDisplayMode()
*/
[typedef]
struct C.SDL_DisplayMode {
	format       u32     // pixel format
	w            int     // width, in screen coordinates
	h            int     // height, in screen coordinates
	refresh_rate int     // refresh rate (or zero for unspecified)
	driverdata   voidptr // driver-specific data, initialize to 0
}

pub type DisplayMode = C.SDL_DisplayMode

/**
 *  \brief The type used to identify a window
 *
 *  \sa SDL_CreateWindow()
 *  \sa SDL_CreateWindowFrom()
 *  \sa SDL_DestroyWindow()
 *  \sa SDL_GetWindowData()
 *  \sa SDL_GetWindowFlags()
 *  \sa SDL_GetWindowGrab()
 *  \sa SDL_GetWindowPosition()
 *  \sa SDL_GetWindowSize()
 *  \sa SDL_GetWindowTitle()
 *  \sa SDL_HideWindow()
 *  \sa SDL_MaximizeWindow()
 *  \sa SDL_MinimizeWindow()
 *  \sa SDL_RaiseWindow()
 *  \sa SDL_RestoreWindow()
 *  \sa SDL_SetWindowData()
 *  \sa SDL_SetWindowFullscreen()
 *  \sa SDL_SetWindowGrab()
 *  \sa SDL_SetWindowIcon()
 *  \sa SDL_SetWindowPosition()
 *  \sa SDL_SetWindowSize()
 *  \sa SDL_SetWindowBordered()
 *  \sa SDL_SetWindowResizable()
 *  \sa SDL_SetWindowTitle()
 *  \sa SDL_ShowWindow()
*/
[typedef]
struct C.SDL_Window {
}

pub type Window = C.SDL_Window

/**
 *  \brief The flags on a window
 *
 *  \sa SDL_GetWindowFlags()
*/
// WindowFlags is C.SDL_WindowFlags
pub enum WindowFlags {
	fullscreen = C.SDL_WINDOW_FULLSCREEN // 0x00000001 fullscreen window
	opengl = C.SDL_WINDOW_OPENGL // 0x00000002 window usable with OpenGL context
	shown = C.SDL_WINDOW_SHOWN // 0x00000004 window is visible
	hidden = C.SDL_WINDOW_HIDDEN // 0x00000008 window is not visible
	borderless = C.SDL_WINDOW_BORDERLESS // 0x00000010 no window decoration
	resizable = C.SDL_WINDOW_RESIZABLE // 0x00000020 window can be resized
	minimized = C.SDL_WINDOW_MINIMIZED // 0x00000040 window is minimized
	maximized = C.SDL_WINDOW_MAXIMIZED // 0x00000080 window is maximized
	input_grabbed = C.SDL_WINDOW_INPUT_GRABBED // 0x00000100 window has grabbed input focus
	input_focus = C.SDL_WINDOW_INPUT_FOCUS // 0x00000200 window has input focus
	mouse_focus = C.SDL_WINDOW_MOUSE_FOCUS // 0x00000400 window has mouse focus
	fullscreen_desktop = C.SDL_WINDOW_FULLSCREEN_DESKTOP // ( SDL_WINDOW_FULLSCREEN | 0x00001000 )
	foreign = C.SDL_WINDOW_FOREIGN // 0x00000800 window not created by SDL
	allow_highdpi = C.SDL_WINDOW_ALLOW_HIGHDPI // 0x00002000 window should be created in high-DPI mode if supported. On macOS NSHighResolutionCapable must be set true in the application's Info.plist for this to have any effect.
	mouse_capture = C.SDL_WINDOW_MOUSE_CAPTURE // 0x00004000 window has mouse captured (unrelated to INPUT_GRABBED)
	always_on_top = C.SDL_WINDOW_ALWAYS_ON_TOP // 0x00008000 window should always be above others
	skip_taskbar = C.SDL_WINDOW_SKIP_TASKBAR // 0x00010000 window should not be added to the taskbar
	utility = C.SDL_WINDOW_UTILITY // 0x00020000 window should be treated as a utility window
	tooltip = C.SDL_WINDOW_TOOLTIP // 0x00040000 window should be treated as a tooltip
	popup_menu = C.SDL_WINDOW_POPUP_MENU // 0x00080000 window should be treated as a popup menu
	vulkan = C.SDL_WINDOW_VULKAN // 0x10000000 window usable for Vulkan surface
}

// TODO
/*
//
// \brief Used to indicate that you don't care what the window position is.
//
windowpos_undefined_mask = SDL_WINDOWPOS_UNDEFINED_MASK    0x1FFF0000u
windowpos_undefined_display = SDL_WINDOWPOS_UNDEFINED_DISPLAY(X)  (SDL_WINDOWPOS_UNDEFINED_MASK|(X))
windowpos_undefined = SDL_WINDOWPOS_UNDEFINED         SDL_WINDOWPOS_UNDEFINED_DISPLAY(0)
windowpos_isundefined = SDL_WINDOWPOS_ISUNDEFINED(X)                (((X)&0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK)

//
// \brief Used to indicate that the window position should be centered.
//
WINDOWPOS_CENTERED_MASK =  SDL_WINDOWPOS_CENTERED_MASK    0x2FFF0000u
WINDOWPOS_CENTERED_DISPLAY = SDL_WINDOWPOS_CENTERED_DISPLAY(X)  (SDL_WINDOWPOS_CENTERED_MASK|(X))
WINDOWPOS_CENTERED = SDL_WINDOWPOS_CENTERED         SDL_WINDOWPOS_CENTERED_DISPLAY(0)
SDL_WINDOWPOS_ISCENTERED =  SDL_WINDOWPOS_ISCENTERED(X)    (((X)&0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK)
*/

// WindowEventID is C.SDL_WindowEventID
pub enum WindowEventID {
	@none = C.SDL_WINDOWEVENT_NONE // Never used
	shown = C.SDL_WINDOWEVENT_SHOWN // Window has been shown
	hidden = C.SDL_WINDOWEVENT_HIDDEN // Window has been hidden
	exposed = C.SDL_WINDOWEVENT_EXPOSED // Window has been exposed and should be redrawn
	moved = C.SDL_WINDOWEVENT_MOVED // Window has been moved to data1, data2
	resized = C.SDL_WINDOWEVENT_RESIZED // Window has been resized to data1xdata2
	size_changed = C.SDL_WINDOWEVENT_SIZE_CHANGED // The window size has changed, either as a result of an API call or through the system or user changing the window size.
	minimized = C.SDL_WINDOWEVENT_MINIMIZED // Window has been minimized
	maximized = C.SDL_WINDOWEVENT_MAXIMIZED // Window has been maximized
	restored = C.SDL_WINDOWEVENT_RESTORED // Window has been restored to normal size and position
	enter = C.SDL_WINDOWEVENT_ENTER // Window has gained mouse focus
	leave = C.SDL_WINDOWEVENT_LEAVE // Window has lost mouse focus
	focus_gained = C.SDL_WINDOWEVENT_FOCUS_GAINED // Window has gained keyboard focus
	focus_lost = C.SDL_WINDOWEVENT_FOCUS_LOST // Window has lost keyboard focus
	close = C.SDL_WINDOWEVENT_CLOSE // The window manager requests that the window be closed
	take_focus = C.SDL_WINDOWEVENT_TAKE_FOCUS // Window is being offered a focus (should SetWindowInputFocus() on itself or a subwindow, or ignore)
	hit_test = C.SDL_WINDOWEVENT_HIT_TEST // Window had a hit test that wasn't SDL_HITTEST_NORMAL.
}

/**
 *  \brief An opaque handle to an OpenGL context.
*/
// typedef void *SDL_GLContext; // ??
[typedef]
struct C.SDL_GLContext {}

// GLattr is C.SDL_GLattr
pub enum GLattr {
	red_size = C.SDL_GL_RED_SIZE
	green_size = C.SDL_GL_GREEN_SIZE
	blue_size = C.SDL_GL_BLUE_SIZE
	alpha_size = C.SDL_GL_ALPHA_SIZE
	buffer_size = C.SDL_GL_BUFFER_SIZE
	doublebuffer = C.SDL_GL_DOUBLEBUFFER
	depth_size = C.SDL_GL_DEPTH_SIZE
	stencil_size = C.SDL_GL_STENCIL_SIZE
	accum_red_size = C.SDL_GL_ACCUM_RED_SIZE
	accum_green_size = C.SDL_GL_ACCUM_GREEN_SIZE
	accum_blue_size = C.SDL_GL_ACCUM_BLUE_SIZE
	accum_alpha_size = C.SDL_GL_ACCUM_ALPHA_SIZE
	stereo = C.SDL_GL_STEREO
	multisamplebuffers = C.SDL_GL_MULTISAMPLEBUFFERS
	multisamplesamples = C.SDL_GL_MULTISAMPLESAMPLES
	accelerated_visual = C.SDL_GL_ACCELERATED_VISUAL
	retained_backing = C.SDL_GL_RETAINED_BACKING
	context_major_version = C.SDL_GL_CONTEXT_MAJOR_VERSION
	context_minor_version = C.SDL_GL_CONTEXT_MINOR_VERSION
	context_egl = C.SDL_GL_CONTEXT_EGL
	context_flags = C.SDL_GL_CONTEXT_FLAGS
	context_profile_mask = C.SDL_GL_CONTEXT_PROFILE_MASK
	share_with_current_context = C.SDL_GL_SHARE_WITH_CURRENT_CONTEXT
	framebuffer_srgb_capable = C.SDL_GL_FRAMEBUFFER_SRGB_CAPABLE
	context_release_behavior = C.SDL_GL_CONTEXT_RELEASE_BEHAVIOR
	context_reset_notification = C.SDL_GL_CONTEXT_RESET_NOTIFICATION
	context_no_error = C.SDL_GL_CONTEXT_NO_ERROR
}

// GLprofile is C.SDL_GLprofile
pub enum GLprofile {
	core = C.SDL_GL_CONTEXT_PROFILE_CORE // 0x0001
	compatibility = C.SDL_GL_CONTEXT_PROFILE_COMPATIBILITY // 0x0002
	es = C.SDL_GL_CONTEXT_PROFILE_ES // 0x0004,  GLX_CONTEXT_ES2_PROFILE_BIT_EXT
}

// GLcontextFlag is C.SDL_GLcontextFlag
pub enum GLcontextFlag {
	debug_flag = C.SDL_GL_CONTEXT_DEBUG_FLAG // 0x0001
	forward_compatible_flag = C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG // 0x0002
	robust_access_flag = C.SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG // 0x0004
	reset_isolation_flag = C.SDL_GL_CONTEXT_RESET_ISOLATION_FLAG // 0x0008
}

// GLcontextReleaseFlag is C.SDL_GLcontextReleaseFlag
pub enum GLcontextReleaseFlag {
	@none = C.SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE // 0x0000
	flush = C.SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH // 0x0001
}

// GLContextResetNotification is C.SDL_GLContextResetNotification
pub enum GLContextResetNotification {
	no_notification = C.SDL_GL_CONTEXT_RESET_NO_NOTIFICATION // 0x0000
	lose_context = C.SDL_GL_CONTEXT_RESET_LOSE_CONTEXT // 0x0001
}

// HitTestResult is C.SDL_HitTestResult
pub enum HitTestResult {
	normal = C.SDL_HITTEST_NORMAL // Region is normal. No special properties.
	draggable = C.SDL_HITTEST_DRAGGABLE // Region can drag entire window.
	resize_topleft = C.SDL_HITTEST_RESIZE_TOPLEFT
	resize_top = C.SDL_HITTEST_RESIZE_TOP
	resize_topright = C.SDL_HITTEST_RESIZE_TOPRIGHT
	resize_right = C.SDL_HITTEST_RESIZE_RIGHT
	resize_bottomright = C.SDL_HITTEST_RESIZE_BOTTOMRIGHT
	resize_bottom = C.SDL_HITTEST_RESIZE_BOTTOM
	resize_bottomleft = C.SDL_HITTEST_RESIZE_BOTTOMLEFT
	resize_left = C.SDL_HITTEST_RESIZE_LEFT
}

/**
 *  \brief Get the number of video drivers compiled into SDL
 *
 *  \sa SDL_GetVideoDriver()
*/
fn C.SDL_GetNumVideoDrivers() int
pub fn get_num_video_drivers() int {
	return C.SDL_GetNumVideoDrivers()
}

/**
 *  \brief Get the name of a built in video driver.
 *
 *  \note The video drivers are presented in the order in which they are
 *        normally checked during initialization.
 *
 *  \sa SDL_GetNumVideoDrivers()
*/
fn C.SDL_GetVideoDriver(index int) &char
pub fn get_video_driver(index int) &char {
	return C.SDL_GetVideoDriver(index)
}

/**
 *  \brief Initialize the video subsystem, optionally specifying a video driver.
 *
 *  \param driver_name Initialize a specific driver by name, or NULL for the
 *                     default video driver.
 *
 *  \return 0 on success, -1 on error
 *
 *  This function initializes the video subsystem; setting up a connection
 *  to the window manager, etc, and determines the available display modes
 *  and pixel formats, but does not initialize a window or graphics mode.
 *
 *  \sa SDL_VideoQuit()
*/
fn C.SDL_VideoInit(driver_name &char) int
pub fn video_init(driver_name &char) int {
	return C.SDL_VideoInit(driver_name)
}

/**
 *  \brief Shuts down the video subsystem.
 *
 *  This function closes all windows, and restores the original video mode.
 *
 *  \sa SDL_VideoInit()
*/
fn C.SDL_VideoQuit()
pub fn video_quit() {
	C.SDL_VideoQuit()
}

/**
 *  \brief Returns the name of the currently initialized video driver.
 *
 *  \return The name of the current video driver or NULL if no driver
 *          has been initialized
 *
 *  \sa SDL_GetNumVideoDrivers()
 *  \sa SDL_GetVideoDriver()
*/
fn C.SDL_GetCurrentVideoDriver() &char
pub fn get_current_video_driver() &char {
	return C.SDL_GetCurrentVideoDriver()
}

/**
 *  \brief Returns the number of available video displays.
 *
 *  \sa SDL_GetDisplayBounds()
*/
fn C.SDL_GetNumVideoDisplays() int
pub fn get_num_video_displays() int {
	return C.SDL_GetNumVideoDisplays()
}

// extern DECLSPEC const char * SDLCALL SDL_GetDisplayName(int displayIndex)
fn C.SDL_GetDisplayName(display_index int) &char
pub fn get_display_name(display_index int) &char {
	return C.SDL_GetDisplayName(display_index)
}

// extern DECLSPEC int SDLCALL SDL_GetDisplayBounds(int displayIndex, SDL_Rect * rect)
fn C.SDL_GetDisplayBounds(display_index int, rect &C.SDL_Rect) int
pub fn get_display_bounds(display_index int, rect &C.SDL_Rect) int {
	return C.SDL_GetDisplayBounds(display_index, rect)
}

// extern DECLSPEC int SDLCALL SDL_GetDisplayDPI(int displayIndex, float * ddpi, float * hdpi, float * vdpi)
fn C.SDL_GetDisplayDPI(display_index int, ddpi &f32, hdpi &f32, vdpi &f32) int
pub fn get_display_d_p_i(display_index int, ddpi &f32, hdpi &f32, vdpi &f32) int {
	return C.SDL_GetDisplayDPI(display_index, ddpi, hdpi, vdpi)
}

// extern DECLSPEC int SDLCALL SDL_GetDisplayUsableBounds(int displayIndex, SDL_Rect * rect)
fn C.SDL_GetDisplayUsableBounds(display_index int, rect &C.SDL_Rect) int
pub fn get_display_usable_bounds(display_index int, rect &C.SDL_Rect) int {
	return C.SDL_GetDisplayUsableBounds(display_index, rect)
}

// extern DECLSPEC int SDLCALL SDL_GetNumDisplayModes(int displayIndex)
fn C.SDL_GetNumDisplayModes(display_index int) int
pub fn get_num_display_modes(display_index int) int {
	return C.SDL_GetNumDisplayModes(display_index)
}

// extern DECLSPEC int SDLCALL SDL_GetDisplayMode(int displayIndex, int modeIndex, SDL_DisplayMode * mode)
fn C.SDL_GetDisplayMode(display_index int, mode_index int, mode &C.SDL_DisplayMode) int
pub fn get_display_mode(display_index int, mode_index int, mode &C.SDL_DisplayMode) int {
	return C.SDL_GetDisplayMode(display_index, mode_index, mode)
}

// extern DECLSPEC int SDLCALL SDL_GetDesktopDisplayMode(int displayIndex, SDL_DisplayMode * mode)
fn C.SDL_GetDesktopDisplayMode(display_index int, mode &C.SDL_DisplayMode) int
pub fn get_desktop_display_mode(display_index int, mode &C.SDL_DisplayMode) int {
	return C.SDL_GetDesktopDisplayMode(display_index, mode)
}

// extern DECLSPEC int SDLCALL SDL_GetCurrentDisplayMode(int displayIndex, SDL_DisplayMode * mode)
fn C.SDL_GetCurrentDisplayMode(display_index int, mode &C.SDL_DisplayMode) int
pub fn get_current_display_mode(display_index int, mode &C.SDL_DisplayMode) int {
	return C.SDL_GetCurrentDisplayMode(display_index, mode)
}

// extern DECLSPEC SDL_DisplayMode * SDLCALL SDL_GetClosestDisplayMode(int displayIndex, const SDL_DisplayMode * mode, SDL_DisplayMode * closest)
fn C.SDL_GetClosestDisplayMode(display_index int, mode &C.SDL_DisplayMode, closest &C.SDL_DisplayMode) &C.SDL_DisplayMode
pub fn get_closest_display_mode(display_index int, mode &C.SDL_DisplayMode, closest &C.SDL_DisplayMode) &C.SDL_DisplayMode {
	return C.SDL_GetClosestDisplayMode(display_index, mode, closest)
}

// extern DECLSPEC int SDLCALL SDL_GetWindowDisplayIndex(SDL_Window * window)
fn C.SDL_GetWindowDisplayIndex(window &C.SDL_Window) int
pub fn get_window_display_index(window &Window) int {
	return C.SDL_GetWindowDisplayIndex(window)
}

// extern DECLSPEC int SDLCALL SDL_SetWindowDisplayMode(SDL_Window * window, const SDL_DisplayMode * mode)
fn C.SDL_SetWindowDisplayMode(window &C.SDL_Window, mode &C.SDL_DisplayMode) int
pub fn set_window_display_mode(window &Window, mode &C.SDL_DisplayMode) int {
	return C.SDL_SetWindowDisplayMode(window, mode)
}

// extern DECLSPEC int SDLCALL SDL_GetWindowDisplayMode(SDL_Window * window, SDL_DisplayMode * mode)
fn C.SDL_GetWindowDisplayMode(window &C.SDL_Window, mode &C.SDL_DisplayMode) int
pub fn get_window_display_mode(window &Window, mode &C.SDL_DisplayMode) int {
	return C.SDL_GetWindowDisplayMode(window, mode)
}

// extern DECLSPEC Uint32 SDLCALL SDL_GetWindowPixelFormat(SDL_Window * window)
fn C.SDL_GetWindowPixelFormat(window &C.SDL_Window) u32
pub fn get_window_pixel_format(window &Window) u32 {
	return C.SDL_GetWindowPixelFormat(window)
}

// extern DECLSPEC SDL_Window * SDLCALL SDL_CreateWindow(const char *title,                                                      int x, int y, int w,                                                      int h, Uint32 flags)
fn C.SDL_CreateWindow(title &char, x int, y int, w int, h int, flags u32) &C.SDL_Window
pub fn create_window(title &char, x int, y int, w int, h int, flags u32) &Window {
	return C.SDL_CreateWindow(title, x, y, w, h, flags)
}

// extern DECLSPEC SDL_Window * SDLCALL SDL_CreateWindowFrom(const void *data)
fn C.SDL_CreateWindowFrom(data voidptr) &C.SDL_Window
pub fn create_window_from(data voidptr) &Window {
	return C.SDL_CreateWindowFrom(data)
}

// extern DECLSPEC Uint32 SDLCALL SDL_GetWindowID(SDL_Window * window)
fn C.SDL_GetWindowID(window &C.SDL_Window) u32
pub fn get_window_id(window &Window) u32 {
	return C.SDL_GetWindowID(window)
}

// extern DECLSPEC SDL_Window * SDLCALL SDL_GetWindowFromID(Uint32 id)
fn C.SDL_GetWindowFromID(id u32) &C.SDL_Window
pub fn get_window_from_id(id u32) &Window {
	return C.SDL_GetWindowFromID(id)
}

// extern DECLSPEC Uint32 SDLCALL SDL_GetWindowFlags(SDL_Window * window)
fn C.SDL_GetWindowFlags(window &C.SDL_Window) u32
pub fn get_window_flags(window &Window) u32 {
	return C.SDL_GetWindowFlags(window)
}

// extern DECLSPEC void SDLCALL SDL_SetWindowTitle(SDL_Window * window,                                                const char *title)
fn C.SDL_SetWindowTitle(window &C.SDL_Window, title &char)
pub fn set_window_title(window &Window, title string) {
	C.SDL_SetWindowTitle(window, title.str)
}

// extern DECLSPEC const char *SDLCALL SDL_GetWindowTitle(SDL_Window * window)
fn C.SDL_GetWindowTitle(window &C.SDL_Window) &char
pub fn get_window_title(window &Window) &char {
	return C.SDL_GetWindowTitle(window)
}

// extern DECLSPEC void SDLCALL SDL_SetWindowIcon(SDL_Window * window,                                               SDL_Surface * icon)
fn C.SDL_SetWindowIcon(window &C.SDL_Window, icon &C.SDL_Surface)
pub fn set_window_icon(window &Window, icon &C.SDL_Surface) {
	C.SDL_SetWindowIcon(window, icon)
}

// extern DECLSPEC void* SDLCALL SDL_SetWindowData(SDL_Window * window,                                                const char *name,                                                void *userdata)
fn C.SDL_SetWindowData(window &C.SDL_Window, name &char, userdata voidptr) voidptr
pub fn set_window_data(window &Window, name &char, userdata voidptr) voidptr {
	return C.SDL_SetWindowData(window, name, userdata)
}

// extern DECLSPEC void *SDLCALL SDL_GetWindowData(SDL_Window * window,                                                const char *name)
fn C.SDL_GetWindowData(window &C.SDL_Window, name &char) voidptr
pub fn get_window_data(window &Window, name &char) voidptr {
	return C.SDL_GetWindowData(window, name)
}

// extern DECLSPEC void SDLCALL SDL_SetWindowPosition(SDL_Window * window,                                                   int x, int y)
fn C.SDL_SetWindowPosition(window &C.SDL_Window, x int, y int)
pub fn set_window_position(window &Window, x int, y int) {
	C.SDL_SetWindowPosition(window, x, y)
}

// extern DECLSPEC void SDLCALL SDL_GetWindowPosition(SDL_Window * window,                                                   int *x, int *y)
fn C.SDL_GetWindowPosition(window &C.SDL_Window, x &int, y &int)
pub fn get_window_position(window &Window, x &int, y &int) {
	C.SDL_GetWindowPosition(window, x, y)
}

// extern DECLSPEC void SDLCALL SDL_SetWindowSize(SDL_Window * window, int w,                                               int h)
fn C.SDL_SetWindowSize(window &C.SDL_Window, w int, h int)
pub fn set_window_size(window &Window, w int, h int) {
	C.SDL_SetWindowSize(window, w, h)
}

// extern DECLSPEC void SDLCALL SDL_GetWindowSize(SDL_Window * window, int *w,                                               int *h)
fn C.SDL_GetWindowSize(window &C.SDL_Window, w &int, h &int)
pub fn get_window_size(window &Window, w &int, h &int) {
	C.SDL_GetWindowSize(window, w, h)
}

// extern DECLSPEC int SDLCALL SDL_GetWindowBordersSize(SDL_Window * window,                                                     int *top, int *left,                                                     int *bottom, int *right)
fn C.SDL_GetWindowBordersSize(window &C.SDL_Window, top &int, left &int, bottom &int, right &int) int
pub fn get_window_borders_size(window &Window, top &int, left &int, bottom &int, right &int) int {
	return C.SDL_GetWindowBordersSize(window, top, left, bottom, right)
}

// extern DECLSPEC void SDLCALL SDL_SetWindowMinimumSize(SDL_Window * window,                                                      int min_w, int min_h)
fn C.SDL_SetWindowMinimumSize(window &C.SDL_Window, min_w int, min_h int)
pub fn set_window_minimum_size(window &Window, min_w int, min_h int) {
	C.SDL_SetWindowMinimumSize(window, min_w, min_h)
}

// extern DECLSPEC void SDLCALL SDL_GetWindowMinimumSize(SDL_Window * window,                                                      int *w, int *h)
fn C.SDL_GetWindowMinimumSize(window &C.SDL_Window, w &int, h &int)
pub fn get_window_minimum_size(window &Window, w &int, h &int) {
	C.SDL_GetWindowMinimumSize(window, w, h)
}

// extern DECLSPEC void SDLCALL SDL_SetWindowMaximumSize(SDL_Window * window,                                                      int max_w, int max_h)
fn C.SDL_SetWindowMaximumSize(window &C.SDL_Window, max_w int, max_h int)
pub fn set_window_maximum_size(window &Window, max_w int, max_h int) {
	C.SDL_SetWindowMaximumSize(window, max_w, max_h)
}

// extern DECLSPEC void SDLCALL SDL_GetWindowMaximumSize(SDL_Window * window,                                                      int *w, int *h)
fn C.SDL_GetWindowMaximumSize(window &C.SDL_Window, w &int, h &int)
pub fn get_window_maximum_size(window &Window, w &int, h &int) {
	C.SDL_GetWindowMaximumSize(window, w, h)
}

// extern DECLSPEC void SDLCALL SDL_SetWindowBordered(SDL_Window * window,                                                   SDL_bool bordered)
fn C.SDL_SetWindowBordered(window &C.SDL_Window, bordered bool)
pub fn set_window_bordered(window &Window, bordered bool) {
	C.SDL_SetWindowBordered(window, bordered)
}

// extern DECLSPEC void SDLCALL SDL_SetWindowResizable(SDL_Window * window,                                                    SDL_bool resizable)
fn C.SDL_SetWindowResizable(window &C.SDL_Window, resizable bool)
pub fn set_window_resizable(window &Window, resizable bool) {
	C.SDL_SetWindowResizable(window, resizable)
}

// extern DECLSPEC void SDLCALL SDL_ShowWindow(SDL_Window * window)
fn C.SDL_ShowWindow(window &C.SDL_Window)
pub fn show_window(window &Window) {
	C.SDL_ShowWindow(window)
}

// extern DECLSPEC void SDLCALL SDL_HideWindow(SDL_Window * window)
fn C.SDL_HideWindow(window &C.SDL_Window)
pub fn hide_window(window &Window) {
	C.SDL_HideWindow(window)
}

// extern DECLSPEC void SDLCALL SDL_RaiseWindow(SDL_Window * window)
fn C.SDL_RaiseWindow(window &C.SDL_Window)
pub fn raise_window(window &Window) {
	C.SDL_RaiseWindow(window)
}

// extern DECLSPEC void SDLCALL SDL_MaximizeWindow(SDL_Window * window)
fn C.SDL_MaximizeWindow(window &C.SDL_Window)
pub fn maximize_window(window &Window) {
	C.SDL_MaximizeWindow(window)
}

// extern DECLSPEC void SDLCALL SDL_MinimizeWindow(SDL_Window * window)
fn C.SDL_MinimizeWindow(window &C.SDL_Window)
pub fn minimize_window(window &Window) {
	C.SDL_MinimizeWindow(window)
}

// extern DECLSPEC void SDLCALL SDL_RestoreWindow(SDL_Window * window)
fn C.SDL_RestoreWindow(window &C.SDL_Window)
pub fn restore_window(window &Window) {
	C.SDL_RestoreWindow(window)
}

// extern DECLSPEC int SDLCALL SDL_SetWindowFullscreen(SDL_Window * window,                                                    Uint32 flags)
fn C.SDL_SetWindowFullscreen(window &C.SDL_Window, flags u32) int
pub fn set_window_fullscreen(window &Window, flags u32) int {
	return C.SDL_SetWindowFullscreen(window, flags)
}

// extern DECLSPEC SDL_Surface * SDLCALL SDL_GetWindowSurface(SDL_Window * window)
fn C.SDL_GetWindowSurface(window &C.SDL_Window) &C.SDL_Surface
pub fn get_window_surface(window &Window) &C.SDL_Surface {
	return C.SDL_GetWindowSurface(window)
}

// extern DECLSPEC int SDLCALL SDL_UpdateWindowSurface(SDL_Window * window)
fn C.SDL_UpdateWindowSurface(window &C.SDL_Window) int
pub fn update_window_surface(window &Window) int {
	return C.SDL_UpdateWindowSurface(window)
}

// extern DECLSPEC int SDLCALL SDL_UpdateWindowSurfaceRects(SDL_Window * window,                                                         const SDL_Rect * rects,                                                         int numrects)
fn C.SDL_UpdateWindowSurfaceRects(window &C.SDL_Window, rects &C.SDL_Rect, numrects int) int
pub fn update_window_surface_rects(window &Window, rects &C.SDL_Rect, numrects int) int {
	return C.SDL_UpdateWindowSurfaceRects(window, rects, numrects)
}

// extern DECLSPEC void SDLCALL SDL_SetWindowGrab(SDL_Window * window,                                               SDL_bool grabbed)
fn C.SDL_SetWindowGrab(window &C.SDL_Window, grabbed bool)
pub fn set_window_grab(window &Window, grabbed bool) {
	C.SDL_SetWindowGrab(window, grabbed)
}

// extern DECLSPEC SDL_bool SDLCALL SDL_GetWindowGrab(SDL_Window * window)
fn C.SDL_GetWindowGrab(window &C.SDL_Window) bool
pub fn get_window_grab(window &Window) bool {
	return C.SDL_GetWindowGrab(window)
}

// extern DECLSPEC SDL_Window * SDLCALL SDL_GetGrabbedWindow(void)
fn C.SDL_GetGrabbedWindow() &C.SDL_Window
pub fn get_grabbed_window() &Window {
	return C.SDL_GetGrabbedWindow()
}

// extern DECLSPEC int SDLCALL SDL_SetWindowBrightness(SDL_Window * window, float brightness)
fn C.SDL_SetWindowBrightness(window &C.SDL_Window, brightness f32) int
pub fn set_window_brightness(window &Window, brightness f32) int {
	return C.SDL_SetWindowBrightness(window, brightness)
}

// extern DECLSPEC float SDLCALL SDL_GetWindowBrightness(SDL_Window * window)
fn C.SDL_GetWindowBrightness(window &C.SDL_Window) f32
pub fn get_window_brightness(window &Window) f32 {
	return C.SDL_GetWindowBrightness(window)
}

// extern DECLSPEC int SDLCALL SDL_SetWindowOpacity(SDL_Window * window, float opacity)
fn C.SDL_SetWindowOpacity(window &C.SDL_Window, opacity f32) int
pub fn set_window_opacity(window &Window, opacity f32) int {
	return C.SDL_SetWindowOpacity(window, opacity)
}

// extern DECLSPEC int SDLCALL SDL_GetWindowOpacity(SDL_Window * window, float * out_opacity)
fn C.SDL_GetWindowOpacity(window &C.SDL_Window, out_opacity &f32) int
pub fn get_window_opacity(window &Window, out_opacity &f32) int {
	return C.SDL_GetWindowOpacity(window, out_opacity)
}

// extern DECLSPEC int SDLCALL SDL_SetWindowModalFor(SDL_Window * modal_window, SDL_Window * parent_window)
fn C.SDL_SetWindowModalFor(modal_window &C.SDL_Window, parent_window &C.SDL_Window) int
pub fn set_window_modal_for(modal_window &Window, parent_window &Window) int {
	return C.SDL_SetWindowModalFor(modal_window, parent_window)
}

// extern DECLSPEC int SDLCALL SDL_SetWindowInputFocus(SDL_Window * window)
fn C.SDL_SetWindowInputFocus(window &C.SDL_Window) int
pub fn set_window_input_focus(window &Window) int {
	return C.SDL_SetWindowInputFocus(window)
}

// extern DECLSPEC int SDLCALL SDL_SetWindowGammaRamp(SDL_Window * window,                                                   const Uint16 * red,                                                   const Uint16 * green,                                                   const Uint16 * blue)
fn C.SDL_SetWindowGammaRamp(window &C.SDL_Window, red &u16, green &u16, blue &u16) int
pub fn set_window_gamma_ramp(window &Window, red &u16, green &u16, blue &u16) int {
	return C.SDL_SetWindowGammaRamp(window, red, green, blue)
}

// extern DECLSPEC int SDLCALL SDL_GetWindowGammaRamp(SDL_Window * window,                                                   Uint16 * red,                                                   Uint16 * green,                                                   Uint16 * blue)
fn C.SDL_GetWindowGammaRamp(window &C.SDL_Window, red &u16, green &u16, blue &u16) int
pub fn get_window_gamma_ramp(window &Window, red &u16, green &u16, blue &u16) int {
	return C.SDL_GetWindowGammaRamp(window, red, green, blue)
}

// extern DECLSPEC int SDLCALL SDL_SetWindowHitTest(SDL_Window * window,                                                 SDL_HitTest callback,                                                 void *callback_data)
fn C.SDL_SetWindowHitTest(window &C.SDL_Window, callback C.SDL_HitTest, callback_data voidptr) int
pub fn set_window_hit_test(window &Window, callback C.SDL_HitTest, callback_data voidptr) int {
	return C.SDL_SetWindowHitTest(window, callback, callback_data)
}

// extern DECLSPEC void SDLCALL SDL_DestroyWindow(SDL_Window * window)
fn C.SDL_DestroyWindow(window &C.SDL_Window)
pub fn destroy_window(window &Window) {
	C.SDL_DestroyWindow(window)
}

// extern DECLSPEC SDL_bool SDLCALL SDL_IsScreenSaverEnabled(void)
fn C.SDL_IsScreenSaverEnabled() bool
pub fn is_screen_saver_enabled() bool {
	return C.SDL_IsScreenSaverEnabled()
}

// extern DECLSPEC void SDLCALL SDL_EnableScreenSaver(void)
fn C.SDL_EnableScreenSaver()
pub fn enable_screen_saver() {
	C.SDL_EnableScreenSaver()
}

// extern DECLSPEC void SDLCALL SDL_DisableScreenSaver(void)
fn C.SDL_DisableScreenSaver()
pub fn disable_screen_saver() {
	C.SDL_DisableScreenSaver()
}

/*
// extern DECLSPEC int SDLCALL SDL_GL_LoadLibrary(const char *path)
fn C.SDL_GL_LoadLibrary(path &char) int
pub fn gl_load_library(path &char) int{
	return C.SDL_GL_LoadLibrary(path)
}

// extern DECLSPEC void *SDLCALL SDL_GL_GetProcAddress(const char *proc)
fn C.SDL_GL_GetProcAddress(proc &char) voidptr
pub fn gl_get_proc_address(proc &char) voidptr{
	return C.SDL_GL_GetProcAddress(proc)
}

// extern DECLSPEC void SDLCALL SDL_GL_UnloadLibrary(void)
fn C.SDL_GL_UnloadLibrary()
pub fn gl_unload_library(){
	 C.SDL_GL_UnloadLibrary()
}

// extern DECLSPEC SDL_bool SDLCALL SDL_GL_ExtensionSupported(const char                                                           *extension)
fn C.SDL_GL_ExtensionSupported(extension &C.char) bool
pub fn gl_extension_supported(extension &C.char) bool{
	return C.SDL_GL_ExtensionSupported(extension)
}

// extern DECLSPEC void SDLCALL SDL_GL_ResetAttributes(void)
fn C.SDL_GL_ResetAttributes()
pub fn gl_reset_attributes(){
	 C.SDL_GL_ResetAttributes()
}

// extern DECLSPEC int SDLCALL SDL_GL_SetAttribute(SDL_GLattr attr, int value)
fn C.SDL_GL_SetAttribute(attr C.SDL_GLattr, value int) int
pub fn gl_set_attribute(attr C.SDL_GLattr, value int) int{
	return C.SDL_GL_SetAttribute(attr, value)
}

// extern DECLSPEC int SDLCALL SDL_GL_GetAttribute(SDL_GLattr attr, int *value)
fn C.SDL_GL_GetAttribute(attr C.SDL_GLattr, value &int) int
pub fn gl_get_attribute(attr C.SDL_GLattr, value &int) int{
	return C.SDL_GL_GetAttribute(attr, value)
}

// extern DECLSPEC SDL_GLContext SDLCALL SDL_GL_CreateContext(SDL_Window *                                                           window)
fn C.SDL_GL_CreateContext(window &C.SDL_Window) C.SDL_GLContext
pub fn gl_create_context(window &Window) C.SDL_GLContext{
	return C.SDL_GL_CreateContext(window)
}

// extern DECLSPEC int SDLCALL SDL_GL_MakeCurrent(SDL_Window * window,                                               SDL_GLContext context)
fn C.SDL_GL_MakeCurrent(window &C.SDL_Window, context C.SDL_GLContext) int
pub fn gl_make_current(window &Window, context C.SDL_GLContext) int{
	return C.SDL_GL_MakeCurrent(window, context)
}

// extern DECLSPEC SDL_Window* SDLCALL SDL_GL_GetCurrentWindow(void)
fn C.SDL_GL_GetCurrentWindow() &C.SDL_Window
pub fn gl_get_current_window() &Window{
	return C.SDL_GL_GetCurrentWindow()
}

// extern DECLSPEC SDL_GLContext SDLCALL SDL_GL_GetCurrentContext(void)
fn C.SDL_GL_GetCurrentContext() C.SDL_GLContext
pub fn gl_get_current_context() C.SDL_GLContext{
	return C.SDL_GL_GetCurrentContext()
}

// extern DECLSPEC void SDLCALL SDL_GL_GetDrawableSize(SDL_Window * window, int *w,                                                    int *h)
fn C.SDL_GL_GetDrawableSize(window &C.SDL_Window, w &int, h &int)
pub fn gl_get_drawable_size(window &Window, w &int, h &int){
	 C.SDL_GL_GetDrawableSize(window, w, h)
}

// extern DECLSPEC int SDLCALL SDL_GL_SetSwapInterval(int interval)
fn C.SDL_GL_SetSwapInterval(interval int) int
pub fn gl_set_swap_interval(interval int) int{
	return C.SDL_GL_SetSwapInterval(interval)
}

// extern DECLSPEC int SDLCALL SDL_GL_GetSwapInterval(void)
fn C.SDL_GL_GetSwapInterval() int
pub fn gl_get_swap_interval() int{
	return C.SDL_GL_GetSwapInterval()
}

// extern DECLSPEC void SDLCALL SDL_GL_SwapWindow(SDL_Window * window)
fn C.SDL_GL_SwapWindow(window &C.SDL_Window)
pub fn gl_swap_window(window &Window){
	 C.SDL_GL_SwapWindow(window)
}

// extern DECLSPEC void SDLCALL SDL_GL_DeleteContext(SDL_GLContext context)
fn C.SDL_GL_DeleteContext(context C.SDL_GLContext)
pub fn gl_delete_context(context C.SDL_GLContext){
	 C.SDL_GL_DeleteContext(context)
}
*/
