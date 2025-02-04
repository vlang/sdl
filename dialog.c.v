// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_dialog.h
//

// File dialog support.
//
// SDL offers file dialogs, to let users select files with native GUI
// interfaces. There are "open" dialogs, "save" dialogs, and folder selection
// dialogs. The app can control some details, such as filtering to specific
// files, or whether multiple files can be selected by the user.
//
// Note that launching a file dialog is a non-blocking operation; control
// returns to the app immediately, and a callback is called later (possibly in
// another thread) when the user makes a choice.

@[typedef]
pub struct C.SDL_DialogFileFilter {
pub mut:
	name    &char = unsafe { nil }
	pattern &char = unsafe { nil }
}

pub type DialogFileFilter = C.SDL_DialogFileFilter

// DialogFileCallback callbacks used by file dialog functions.
//
// The specific usage is described in each function.
//
// If `filelist` is:
//
// - NULL, an error occurred. Details can be obtained with SDL_GetError().
// - A pointer to NULL, the user either didn't choose any file or canceled the
//   dialog.
// - A pointer to non-`NULL`, the user chose one or more files. The argument
//   is a null-terminated list of pointers to C strings, each containing a
//   path.
//
// The filelist argument should not be freed; it will automatically be freed
// when the callback returns.
//
// The filter argument is the index of the filter that was selected, or -1 if
// no filter was selected or if the platform or method doesn't support
// fetching the selected filter.
//
// In Android, the `filelist` are `content://` URIs. They should be opened
// using SDL_IOFromFile() with appropriate modes. This applies both to open
// and save file dialog.
//
// `userdata` userdata an app-provided pointer, for the callback's use.
// `filelist` filelist the file(s) chosen by the user.
// `filter` filter index of the selected filter.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: dialog_file_filter (SDL_DialogFileFilter)
// See also: show_open_file_dialog (SDL_ShowOpenFileDialog)
// See also: show_save_file_dialog (SDL_ShowSaveFileDialog)
// See also: show_open_folder_dialog (SDL_ShowOpenFolderDialog)
// See also: show_file_dialog_with_properties (SDL_ShowFileDialogWithProperties)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_DialogFileCallback)
pub type DialogFileCallback = fn (userdata voidptr, const_filelist &&char, filter int)

// C.SDL_ShowOpenFileDialog [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShowOpenFileDialog)
fn C.SDL_ShowOpenFileDialog(callback DialogFileCallback, userdata voidptr, window &Window, const_filters &DialogFileFilter, nfilters int, const_default_location &char, allow_many bool)

// show_open_file_dialog displays a dialog that lets the user select a file on their filesystem.
//
// This is an asynchronous function; it will return immediately, and the
// result will be passed to the callback.
//
// The callback will be invoked with a null-terminated list of files the user
// chose. The list will be empty if the user canceled the dialog, and it will
// be NULL if an error occurred.
//
// Note that the callback may be called from a different thread than the one
// the function was invoked on.
//
// Depending on the platform, the user may be allowed to input paths that
// don't yet exist.
//
// On Linux, dialogs may require XDG Portals, which requires DBus, which
// requires an event-handling loop. Apps that do not use SDL to handle events
// should add a call to SDL_PumpEvents in their main loop.
//
// `callback` callback a function pointer to be invoked when the user selects a
//                 file and accepts, or cancels the dialog, or an error
//                 occurs.
// `userdata` userdata an optional pointer to pass extra data to the callback when
//                 it will be invoked.
// `window` window the window that the dialog should be modal for, may be NULL.
//               Not all platforms support this option.
// `filters` filters a list of filters, may be NULL. Not all platforms support
//                this option, and platforms that do support it may allow the
//                user to ignore the filters. If non-NULL, it must remain
//                valid at least until the callback is invoked.
// `nfilters` nfilters the number of filters. Ignored if filters is NULL.
// `default_location` default_location the default folder or file to start the dialog at,
//                         may be NULL. Not all platforms support this option.
// `allow_many` allow_many if non-zero, the user will be allowed to select multiple
//                   entries. Not all platforms support this option.
//
// NOTE: (thread safety) This function should be called only from the main thread. The
//               callback may be invoked from the same thread or from a
//               different one, depending on the OS's constraints.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: dialog_file_callback (SDL_DialogFileCallback)
// See also: dialog_file_filter (SDL_DialogFileFilter)
// See also: show_save_file_dialog (SDL_ShowSaveFileDialog)
// See also: show_open_folder_dialog (SDL_ShowOpenFolderDialog)
// See also: show_file_dialog_with_properties (SDL_ShowFileDialogWithProperties)
pub fn show_open_file_dialog(callback DialogFileCallback, userdata voidptr, window &Window, const_filters &DialogFileFilter, nfilters int, const_default_location &char, allow_many bool) {
	C.SDL_ShowOpenFileDialog(callback, userdata, window, const_filters, nfilters, const_default_location,
		allow_many)
}

// C.SDL_ShowSaveFileDialog [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShowSaveFileDialog)
fn C.SDL_ShowSaveFileDialog(callback DialogFileCallback, userdata voidptr, window &Window, const_filters &DialogFileFilter, nfilters int, const_default_location &char)

// show_save_file_dialog displays a dialog that lets the user choose a new or existing file on their
// filesystem.
//
// This is an asynchronous function; it will return immediately, and the
// result will be passed to the callback.
//
// The callback will be invoked with a null-terminated list of files the user
// chose. The list will be empty if the user canceled the dialog, and it will
// be NULL if an error occurred.
//
// Note that the callback may be called from a different thread than the one
// the function was invoked on.
//
// The chosen file may or may not already exist.
//
// On Linux, dialogs may require XDG Portals, which requires DBus, which
// requires an event-handling loop. Apps that do not use SDL to handle events
// should add a call to SDL_PumpEvents in their main loop.
//
// `callback` callback a function pointer to be invoked when the user selects a
//                 file and accepts, or cancels the dialog, or an error
//                 occurs.
// `userdata` userdata an optional pointer to pass extra data to the callback when
//                 it will be invoked.
// `window` window the window that the dialog should be modal for, may be NULL.
//               Not all platforms support this option.
// `filters` filters a list of filters, may be NULL. Not all platforms support
//                this option, and platforms that do support it may allow the
//                user to ignore the filters. If non-NULL, it must remain
//                valid at least until the callback is invoked.
// `nfilters` nfilters the number of filters. Ignored if filters is NULL.
// `default_location` default_location the default folder or file to start the dialog at,
//                         may be NULL. Not all platforms support this option.
//
// NOTE: (thread safety) This function should be called only from the main thread. The
//               callback may be invoked from the same thread or from a
//               different one, depending on the OS's constraints.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: dialog_file_callback (SDL_DialogFileCallback)
// See also: dialog_file_filter (SDL_DialogFileFilter)
// See also: show_open_file_dialog (SDL_ShowOpenFileDialog)
// See also: show_open_folder_dialog (SDL_ShowOpenFolderDialog)
// See also: show_file_dialog_with_properties (SDL_ShowFileDialogWithProperties)
pub fn show_save_file_dialog(callback DialogFileCallback, userdata voidptr, window &Window, const_filters &DialogFileFilter, nfilters int, const_default_location &char) {
	C.SDL_ShowSaveFileDialog(callback, userdata, window, const_filters, nfilters, const_default_location)
}

// C.SDL_ShowOpenFolderDialog [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShowOpenFolderDialog)
fn C.SDL_ShowOpenFolderDialog(callback DialogFileCallback, userdata voidptr, window &Window, const_default_location &char, allow_many bool)

// show_open_folder_dialog displays a dialog that lets the user select a folder on their filesystem.
//
// This is an asynchronous function; it will return immediately, and the
// result will be passed to the callback.
//
// The callback will be invoked with a null-terminated list of files the user
// chose. The list will be empty if the user canceled the dialog, and it will
// be NULL if an error occurred.
//
// Note that the callback may be called from a different thread than the one
// the function was invoked on.
//
// Depending on the platform, the user may be allowed to input paths that
// don't yet exist.
//
// On Linux, dialogs may require XDG Portals, which requires DBus, which
// requires an event-handling loop. Apps that do not use SDL to handle events
// should add a call to SDL_PumpEvents in their main loop.
//
// `callback` callback a function pointer to be invoked when the user selects a
//                 file and accepts, or cancels the dialog, or an error
//                 occurs.
// `userdata` userdata an optional pointer to pass extra data to the callback when
//                 it will be invoked.
// `window` window the window that the dialog should be modal for, may be NULL.
//               Not all platforms support this option.
// `default_location` default_location the default folder or file to start the dialog at,
//                         may be NULL. Not all platforms support this option.
// `allow_many` allow_many if non-zero, the user will be allowed to select multiple
//                   entries. Not all platforms support this option.
//
// NOTE: (thread safety) This function should be called only from the main thread. The
//               callback may be invoked from the same thread or from a
//               different one, depending on the OS's constraints.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: dialog_file_callback (SDL_DialogFileCallback)
// See also: show_open_file_dialog (SDL_ShowOpenFileDialog)
// See also: show_save_file_dialog (SDL_ShowSaveFileDialog)
// See also: show_file_dialog_with_properties (SDL_ShowFileDialogWithProperties)
pub fn show_open_folder_dialog(callback DialogFileCallback, userdata voidptr, window &Window, const_default_location &char, allow_many bool) {
	C.SDL_ShowOpenFolderDialog(callback, userdata, window, const_default_location, allow_many)
}

// FileDialogType is C.SDL_FileDialogType
pub enum FileDialogType {
	openfile   = C.SDL_FILEDIALOG_OPENFILE
	savefile   = C.SDL_FILEDIALOG_SAVEFILE
	openfolder = C.SDL_FILEDIALOG_OPENFOLDER
}

// C.SDL_ShowFileDialogWithProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShowFileDialogWithProperties)
fn C.SDL_ShowFileDialogWithProperties(typ FileDialogType, callback DialogFileCallback, userdata voidptr, props PropertiesID)

// show_file_dialog_with_properties creates and launch a file dialog with the specified properties.
//
// These are the supported properties:
//
// - `SDL_PROP_FILE_DIALOG_FILTERS_POINTER`: a pointer to a list of
//   SDL_DialogFileFilter structs, which will be used as filters for
//   file-based selections. Ignored if the dialog is an "Open Folder" dialog.
//   If non-NULL, the array of filters must remain valid at least until the
//   callback is invoked.
// - `SDL_PROP_FILE_DIALOG_NFILTERS_NUMBER`: the number of filters in the
//   array of filters, if it exists.
// - `SDL_PROP_FILE_DIALOG_WINDOW_POINTER`: the window that the dialog should
//   be modal for.
// - `SDL_PROP_FILE_DIALOG_LOCATION_STRING`: the default folder or file to
//   start the dialog at.
// - `SDL_PROP_FILE_DIALOG_MANY_BOOLEAN`: true to allow the user to select
//   more than one entry.
// - `SDL_PROP_FILE_DIALOG_TITLE_STRING`: the title for the dialog.
// - `SDL_PROP_FILE_DIALOG_ACCEPT_STRING`: the label that the accept button
//   should have.
// - `SDL_PROP_FILE_DIALOG_CANCEL_STRING`: the label that the cancel button
//   should have.
//
// Note that each platform may or may not support any of the properties.
//
// `type` type the type of file dialog.
// `callback` callback a function pointer to be invoked when the user selects a
//                 file and accepts, or cancels the dialog, or an error
//                 occurs.
// `userdata` userdata an optional pointer to pass extra data to the callback when
//                 it will be invoked.
// `props` props the properties to use.
//
// NOTE: (thread safety) This function should be called only from the main thread. The
//               callback may be invoked from the same thread or from a
//               different one, depending on the OS's constraints.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: file_dialog_type (SDL_FileDialogType)
// See also: dialog_file_callback (SDL_DialogFileCallback)
// See also: dialog_file_filter (SDL_DialogFileFilter)
// See also: show_open_file_dialog (SDL_ShowOpenFileDialog)
// See also: show_save_file_dialog (SDL_ShowSaveFileDialog)
// See also: show_open_folder_dialog (SDL_ShowOpenFolderDialog)
pub fn show_file_dialog_with_properties(typ FileDialogType, callback DialogFileCallback, userdata voidptr, props PropertiesID) {
	C.SDL_ShowFileDialogWithProperties(typ, callback, userdata, props)
}

pub const prop_file_dialog_filters_pointer = C.SDL_PROP_FILE_DIALOG_FILTERS_POINTER // 'SDL.filedialog.filters'

pub const prop_file_dialog_nfilters_number = C.SDL_PROP_FILE_DIALOG_NFILTERS_NUMBER // 'SDL.filedialog.nfilters'

pub const prop_file_dialog_window_pointer = C.SDL_PROP_FILE_DIALOG_WINDOW_POINTER // 'SDL.filedialog.window'

pub const prop_file_dialog_location_string = C.SDL_PROP_FILE_DIALOG_LOCATION_STRING // 'SDL.filedialog.location'

pub const prop_file_dialog_many_boolean = C.SDL_PROP_FILE_DIALOG_MANY_BOOLEAN // 'SDL.filedialog.many'

pub const prop_file_dialog_title_string = C.SDL_PROP_FILE_DIALOG_TITLE_STRING // 'SDL.filedialog.title'

pub const prop_file_dialog_accept_string = C.SDL_PROP_FILE_DIALOG_ACCEPT_STRING // 'SDL.filedialog.accept'

pub const prop_file_dialog_cancel_string = C.SDL_PROP_FILE_DIALOG_CANCEL_STRING // 'SDL.filedialog.cancel'
