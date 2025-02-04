// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_messagebox.h
//

// SDL offers a simple message box API, which is useful for simple alerts,
// such as informing the user when something fatal happens at startup without
// the need to build a UI for it (or informing the user _before_ your UI is
// ready).
//
// These message boxes are native system dialogs where possible.
//
// There is both a customizable function (SDL_ShowMessageBox()) that offers
// lots of options for what to display and reports on what choice the user
// made, and also a much-simplified version (SDL_ShowSimpleMessageBox()),
// merely takes a text message and title, and waits until the user presses a
// single "OK" UI button. Often, this is all that is necessary.

// Message box flags.
//
// If supported will display warning icon, etc.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type MessageBoxFlags = u32

// SDL_MessageBoxButtonData flags.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type MessageBoxButtonFlags = u32

pub const messagebox_error = C.SDL_MESSAGEBOX_ERROR // 0x00000010u

pub const messagebox_warning = C.SDL_MESSAGEBOX_WARNING // 0x00000020u

pub const messagebox_information = C.SDL_MESSAGEBOX_INFORMATION // 0x00000040u

pub const messagebox_buttons_left_to_right = C.SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT // 0x00000080u

pub const messagebox_buttons_right_to_left = C.SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT // 0x00000100u

pub const messagebox_button_returnkey_default = C.SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT // 0x00000001u

pub const messagebox_button_escapekey_default = C.SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT // 0x00000002u

@[typedef]
pub struct C.SDL_MessageBoxButtonData {
pub mut:
	flags    MessageBoxButtonFlags
	buttonID int // User defined button id (value returned via SDL_ShowMessageBox)
	text     &char = unsafe { nil } // The UTF-8 button text
}

pub type MessageBoxButtonData = C.SDL_MessageBoxButtonData

@[typedef]
pub struct C.SDL_MessageBoxColor {
pub mut:
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
	count             = C.SDL_MESSAGEBOX_COLOR_COUNT // `count` Size of the colors array of SDL_MessageBoxColorScheme.
}

@[typedef]
pub struct C.SDL_MessageBoxColorScheme {
	// TODO 	colors [SDL_MESSAGEBOX_COLOR_COUNT]MessageBoxColor
}

pub type MessageBoxColorScheme = C.SDL_MessageBoxColorScheme

@[typedef]
pub struct C.SDL_MessageBoxData {
pub mut:
	flags       MessageBoxFlags
	window      &Window = unsafe { nil } // Parent window, can be NULL
	title       &char   = unsafe { nil } // UTF-8 title
	message     &char   = unsafe { nil } // UTF-8 message text
	numbuttons  int
	buttons     &MessageBoxButtonData  = unsafe { nil }
	colorScheme &MessageBoxColorScheme = unsafe { nil } // SDL_MessageBoxColorScheme, can be NULL to use system settings
}

pub type MessageBoxData = C.SDL_MessageBoxData

// C.SDL_ShowMessageBox [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShowMessageBox)
fn C.SDL_ShowMessageBox(const_messageboxdata &MessageBoxData, buttonid &int) bool

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
// `messageboxdata` messageboxdata the SDL_MessageBoxData structure with title, text and
//                       other options.
// `buttonid` buttonid the pointer to which user id of hit button should be
//                 copied.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: show_simple_message_box (SDL_ShowSimpleMessageBox)
pub fn show_message_box(const_messageboxdata &MessageBoxData, buttonid &int) bool {
	return C.SDL_ShowMessageBox(const_messageboxdata, buttonid)
}

// C.SDL_ShowSimpleMessageBox [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShowSimpleMessageBox)
fn C.SDL_ShowSimpleMessageBox(flags MessageBoxFlags, const_title &char, const_message &char, window &Window) bool

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
// `flags` flags an SDL_MessageBoxFlags value.
// `title` title UTF-8 title text.
// `message` message UTF-8 message text.
// `window` window the parent window, or NULL for no parent.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: show_message_box (SDL_ShowMessageBox)
pub fn show_simple_message_box(flags MessageBoxFlags, const_title &char, const_message &char, window &Window) bool {
	return C.SDL_ShowSimpleMessageBox(flags, const_title, const_message, window)
}
