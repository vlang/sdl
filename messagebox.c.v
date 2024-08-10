// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_messagebox.h
//

// MessageBoxFlags is C.SDL_MessageBoxFlags
// MessageBox flags. If supported will display warning icon, etc.
pub enum MessageBoxFlags {
	error                 = C.SDL_MESSAGEBOX_ERROR                 // 0x00000010, error dialog
	warning               = C.SDL_MESSAGEBOX_WARNING               // 0x00000020, warning dialog
	information           = C.SDL_MESSAGEBOX_INFORMATION           // 0x00000040, informational dialog
	buttons_left_to_right = C.SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT // 0x00000080, buttons placed left to right
	buttons_right_to_left = C.SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT // 0x00000100, buttons placed right to left
}

// MessageBoxButtonFlags is C.SDL_MessageBoxButtonFlags
// Flags for SDL_MessageBoxButtonData.
pub enum MessageBoxButtonFlags {
	returnkey_default = C.SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT // 0x00000001, Marks the default button when return is hit
	escapekey_default = C.SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT // 0x00000002, Marks the default button when escape is hit
}

// MessageBoxButtonData is individual button data.
@[typedef]
pub struct C.SDL_MessageBoxButtonData {
pub:
	flags    u32   // ::SDL_MessageBoxButtonFlags
	buttonid int   // User defined button id (value returned via SDL_ShowMessageBox)
	text     &char // The UTF-8 button text
}

pub type MessageBoxButtonData = C.SDL_MessageBoxButtonData

// MessageBoxColor is a RGB value used in a message box color scheme
@[typedef]
pub struct C.SDL_MessageBoxColor {
pub:
	r u8
	g u8
	b u8
}

pub type MessageBoxColor = C.SDL_MessageBoxColor

// MessageBoxColorType is C.SDL_MessageBoxColorType
pub enum MessageBoxColorType {
	background        = C.SDL_MESSAGEBOX_COLOR_BACKGROUND
	text              = C.SDL_MESSAGEBOX_COLOR_TEXT
	button_border     = C.SDL_MESSAGEBOX_COLOR_BUTTON_BORDER
	button_background = C.SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND
	button_selected   = C.SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED
	max               = C.SDL_MESSAGEBOX_COLOR_MAX
}

// MessageBoxColorScheme is a set of colors to use for message box dialogs
@[typedef]
pub struct C.SDL_MessageBoxColorScheme {
pub:
	colors [6]MessageBoxColor
}

pub type MessageBoxColorScheme = C.SDL_MessageBoxColorScheme

// MessageBoxData is a MessageBox structure containing title, text, window, etc.
@[typedef]
pub struct C.SDL_MessageBoxData {
pub:
	flags       u32     // ::SDL_MessageBoxFlags
	window      &Window // Parent window, can be NULL
	title       &char   // UTF-8 title
	message     &char   // UTF-8 message text
	numbuttons  int
	buttons     &MessageBoxButtonData  // C.SDL_MessageBoxButtonData
	colorScheme &MessageBoxColorScheme // C.SDL_MessageBoxColorScheme, ::SDL_MessageBoxColorScheme, can be NULL to use system settings
}

pub type MessageBoxData = C.SDL_MessageBoxData

fn C.SDL_ShowMessageBox(messageboxdata &C.SDL_MessageBoxData, buttonid &int) int

// show_message_box creates a modal message box.
//
// If your needs aren't complex, it might be easier to use
// SDL_ShowSimpleMessageBox.
//
// This function should be called on the thread that created the parent
// window, or on the main thread if the messagebox has no parent. It will
// block execution of that thread until the user clicks a button or closes the
// messagebox.
//
// This function may be called at any time, even before SDL_Init(). This makes
// it useful for reporting errors like a failure to create a renderer or
// OpenGL context.
//
// On X11, SDL rolls its own dialog box with X11 primitives instead of a
// formal toolkit like GTK+ or Qt.
//
// Note that if SDL_Init() would fail because there isn't any available video
// target, this function is likely to fail for the same reasons. If this is a
// concern, check the return value from this function and fall back to writing
// to stderr if you can.
//
// `messageboxdata` the SDL_MessageBoxData structure with title, text and
//                       other options
// `buttonid` the pointer to which user id of hit button should be copied
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_ShowSimpleMessageBox
pub fn show_message_box(messageboxdata &MessageBoxData, buttonid &int) int {
	return C.SDL_ShowMessageBox(messageboxdata, buttonid)
}

fn C.SDL_ShowSimpleMessageBox(flags u32, const_title &char, const_message &char, window &C.SDL_Window) int

// show_simple_message_box displays a simple modal message box.
//
// If your needs aren't complex, this function is preferred over
// SDL_ShowMessageBox.
//
// `flags` may be any of the following:
//
// - `SDL_MESSAGEBOX_ERROR`: error dialog
// - `SDL_MESSAGEBOX_WARNING`: warning dialog
// - `SDL_MESSAGEBOX_INFORMATION`: informational dialog
//
// This function should be called on the thread that created the parent
// window, or on the main thread if the messagebox has no parent. It will
// block execution of that thread until the user clicks a button or closes the
// messagebox.
//
// This function may be called at any time, even before SDL_Init(). This makes
// it useful for reporting errors like a failure to create a renderer or
// OpenGL context.
//
// On X11, SDL rolls its own dialog box with X11 primitives instead of a
// formal toolkit like GTK+ or Qt.
//
// Note that if SDL_Init() would fail because there isn't any available video
// target, this function is likely to fail for the same reasons. If this is a
// concern, check the return value from this function and fall back to writing
// to stderr if you can.
//
// `flags` an SDL_MessageBoxFlags value
// `title` UTF-8 title text
// `message` UTF-8 message text
// `window` the parent window, or NULL for no parent
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_ShowMessageBox
pub fn show_simple_message_box(flags u32, const_title &char, const_message &char, window &Window) int {
	return C.SDL_ShowSimpleMessageBox(flags, const_title, const_message, window)
}
