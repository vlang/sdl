// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_messagebox.h
//

/**
 * \brief SDL_MessageBox flags. If supported will display warning icon, etc.
*/
// MessageBoxFlags is C.SDL_MessageBoxFlags
pub enum MessageBoxFlags {
	messagebox_error = C.SDL_MESSAGEBOX_ERROR // 0x00000010, error dialog
	messagebox_warning = C.SDL_MESSAGEBOX_WARNING // 0x00000020, warning dialog
	messagebox_information = C.SDL_MESSAGEBOX_INFORMATION // 0x00000040, informational dialog
}

/**
 * \brief Flags for SDL_MessageBoxButtonData.
*/
// MessageBoxButtonFlags is C.SDL_MessageBoxButtonFlags
pub enum MessageBoxButtonFlags {
	messagebox_button_returnkey_default = C.SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT // 0x00000001, Marks the default button when return is hit
	messagebox_button_escapekey_default = C.SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT // 0x00000002, Marks the default button when escape is hit
}

/**
 *  \brief Individual button data.
*/
[typedef]
struct C.SDL_MessageBoxButtonData {
	flags    u32   // ::SDL_MessageBoxButtonFlags
	buttonid int   // User defined button id (value returned via SDL_ShowMessageBox)
	text     &char // The UTF-8 button text
}

pub type MessageBoxButtonData = C.SDL_MessageBoxButtonData

/**
 * \brief RGB value used in a message box color scheme
*/
[typedef]
struct C.SDL_MessageBoxColor {
	r byte
	g byte
	b byte
}

pub type MessageBoxColor = C.SDL_MessageBoxColor

// MessageBoxColorType is C.SDL_MessageBoxColorType
pub enum MessageBoxColorType {
	background = C.SDL_MESSAGEBOX_COLOR_BACKGROUND
	text = C.SDL_MESSAGEBOX_COLOR_TEXT
	button_border = C.SDL_MESSAGEBOX_COLOR_BUTTON_BORDER
	button_background = C.SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND
	button_selected = C.SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED
	max = C.SDL_MESSAGEBOX_COLOR_MAX
}

/**
 * \brief A set of colors to use for message box dialogs
*/
[typedef]
struct C.SDL_MessageBoxColorScheme {
	colors [6]MessageBoxColor
}

pub type MessageBoxColorScheme = C.SDL_MessageBoxColorScheme

/**
 *  \brief MessageBox structure containing title, text, window, etc.
*/
[typedef]
struct C.SDL_MessageBoxData {
	flags       u32     // ::SDL_MessageBoxFlags
	window      &Window // Parent window, can be NULL
	title       &char   // UTF-8 title
	message     &char   // UTF-8 message text
	numbuttons  int
	buttons     &MessageBoxButtonData  // C.SDL_MessageBoxButtonData
	colorScheme &MessageBoxColorScheme // C.SDL_MessageBoxColorScheme, ::SDL_MessageBoxColorScheme, can be NULL to use system settings
}

pub type MessageBoxData = C.SDL_MessageBoxData

/**
 *  \brief Create a modal message box.
 *
 *  \param messageboxdata The SDL_MessageBoxData structure with title, text, etc.
 *  \param buttonid The pointer to which user id of hit button should be copied.
 *
 *  \return -1 on error, otherwise 0 and buttonid contains user id of button
 *          hit or -1 if dialog was closed.
 *
 *  \note This function should be called on the thread that created the parent
 *        window, or on the main thread if the messagebox has no parent.  It will
 *        block execution of that thread until the user clicks a button or
 *        closes the messagebox.
*/
fn C.SDL_ShowMessageBox(messageboxdata &C.SDL_MessageBoxData, buttonid &int) int
pub fn show_message_box(messageboxdata &MessageBoxData, buttonid &int) int {
	return C.SDL_ShowMessageBox(messageboxdata, buttonid)
}

/**
 *  \brief Create a simple modal message box
 *
 *  \param flags    ::SDL_MessageBoxFlags
 *  \param title    UTF-8 title text
 *  \param message  UTF-8 message text
 *  \param window   The parent window, or NULL for no parent
 *
 *  \return 0 on success, -1 on error
 *
 *  \sa SDL_ShowMessageBox
*/
fn C.SDL_ShowSimpleMessageBox(flags u32, title &char, message &char, window &C.SDL_Window) int
pub fn show_simple_message_box(flags u32, title string, message string, window &Window) int {
	return C.SDL_ShowSimpleMessageBox(flags, title.str, message.str, window)
}
