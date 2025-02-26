module main

import sdl
import os

struct App {
mut:
	selected_files []string
}

fn main() {
	if !sdl.init(sdl.init_video) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Unable to initialize SDL: SDL error:\n${error_msg}')
	}

	// Properties for the file dialog
	props := sdl.create_properties()
	if props == 0 {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Unable to create properties: SDL error:\n${error_msg}')
	}

	file_dialog_filters := [
		sdl.DialogFileFilter{
			name:    c'All files'
			pattern: c'*'
		},
		sdl.DialogFileFilter{
			name:    c'V files'
			pattern: c'v'
		},
		sdl.DialogFileFilter{
			name:    c'V C files'
			pattern: c'c.v'
		},
	]!
	if !sdl.set_number_property(props, sdl.prop_file_dialog_nfilters_number, file_dialog_filters.len) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Unable to set number property: SDL error:\n${error_msg}')
	}

	if !sdl.set_pointer_property(props, sdl.prop_file_dialog_filters_pointer, &file_dialog_filters[0]) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Unable to set pointer property: SDL error:\n${error_msg}')
	}

	if !sdl.set_string_property(props, sdl.prop_file_dialog_title_string, c'Select one or more files') {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Unable to set string property: SDL error:\n${error_msg}')
	}

	if !sdl.set_string_property(props, sdl.prop_file_dialog_location_string, '${os.getwd()}'.str) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Unable to set string property: SDL error:\n${error_msg}')
	}

	if !sdl.set_boolean_property(props, sdl.prop_file_dialog_many_boolean, true) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Unable to set boolean property: SDL error:\n${error_msg}')
	}

	if !sdl.set_string_property(props, sdl.prop_file_dialog_accept_string, c'A-okay') {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Unable to set string property: SDL error:\n${error_msg}')
	}

	if !sdl.set_string_property(props, sdl.prop_file_dialog_cancel_string, c'No thanks') {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Unable to set string property: SDL error:\n${error_msg}')
	}

	// NOTE: In this next block a window is used so we have something that receives OS events.
	// If you just need a file dialog and no window, this part can be omitted.
	window := sdl.create_window(c'File Dialog Example', 400, 400, sdl.WindowFlags(0))
	if window == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not create SDL window and renderer. SDL error:\n${error_msg}')
	}
	if !sdl.set_pointer_property(props, sdl.prop_file_dialog_window_pointer, voidptr(window)) {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Unable to set pointer property: SDL error:\n${error_msg}')
	}
	defer {
		sdl.destroy_window(window)
	}
	println('File Dialog Example, if this is running without a window, use Ctrl+C in to terminate the application')

	// Called when user close, cancel or accept
	dialog_file_callback := fn (userdata voidptr, const_filelist &&char, filter int) {
		// Retreive App instance to interact with it
		mut app := unsafe { &App(userdata) }

		// Read more about handling arguments in this callback here: https://wiki.libsdl.org/SDL3/SDL_DialogFileCallback
		if const_filelist == sdl.null {
			error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
			panic('An error occurred in the file dialog: SDL error:\n${error_msg}')
		}
		if unsafe { const_filelist[0] } == sdl.null {
			println('No files selected or dialog cancelled')
			return
		}

		mut file_list := []string{}
		for i := 0; true; i++ {
			c_str_ptr := unsafe { const_filelist[i] }
			if c_str_ptr == sdl.null {
				break
			}
			file_list << unsafe { cstring_to_vstring(c_str_ptr) }
		}

		println('Files selected (in callback): ${file_list}')

		app.selected_files = file_list
	}

	mut app := &App{}
	sdl.show_file_dialog_with_properties(.openfile, dialog_file_callback, app, props)
	sdl.destroy_properties(props)

	// NOTE: the file dialog runs in a separate thread so we have to block the main thread to retrieve
	// any input from the dialog. I.e. `app.selected_files` will likely always be empty at this point.
	// We block in a loop so the dialog_file_callback is called when user is done interacting with the dialog.
	mut should_close := false
	for {
		evt := sdl.Event{}
		for sdl.poll_event(&evt) {
			match evt.type {
				.quit {
					should_close = true
				}
				.key_down {
					key := unsafe { sdl.KeyCode(evt.key.key) }
					match key {
						.escape { should_close = true }
						else {}
					}
				}
				else {}
			}
		}
		if should_close {
			break
		}
	}

	println('Files selected (after blocking, out of callback): ${app.selected_files}')
	if file := app.selected_files[0] {
		println('First file entry: "${file}"')
		$if android {
			// On Android the strings returned uses a special `content://` scheme that can be
			// opened with SDL_IOFromFile.
			// See: https://wiki.libsdl.org/SDL3/SDL_ShowFileDialogWithProperties
			// And: https://wiki.libsdl.org/SDL3/SDL_IOFromFile
			//
			// iostream := sdl.io_from_file(file.str,c'rb')
		} $else {
			// Read file like you normally would
		}
	}

	sdl.quit()
}
