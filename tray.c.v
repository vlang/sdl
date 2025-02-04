// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_tray.h
//

// SDL offers a way to add items to the "system tray" (more correctly called
// the "notification area" on Windows). On platforms that offer this concept,
// an SDL app can add a tray icon, submenus, checkboxes, and clickable
// entries, and register a callback that is fired when the user clicks on
// these pieces.

// Flags that control the creation of system tray entries.
//
// Some of these flags are required; exactly one of them must be specified at
// the time a tray entry is created. Other flags are optional; zero or more of
// those can be OR'ed together with the required flag.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
pub type TrayEntryFlags = u32

@[noinit; typedef]
pub struct C.SDL_Tray {
	// NOTE: Opaque type
}

pub type Tray = C.SDL_Tray

@[noinit; typedef]
pub struct C.SDL_TrayMenu {
	// NOTE: Opaque type
}

pub type TrayMenu = C.SDL_TrayMenu

@[noinit; typedef]
pub struct C.SDL_TrayEntry {
	// NOTE: Opaque type
}

pub type TrayEntry = C.SDL_TrayEntry

pub const trayentry_button = C.SDL_TRAYENTRY_BUTTON // 0x00000001u

pub const trayentry_checkbox = C.SDL_TRAYENTRY_CHECKBOX // 0x00000002u

pub const trayentry_submenu = C.SDL_TRAYENTRY_SUBMENU // 0x00000004u

pub const trayentry_disabled = C.SDL_TRAYENTRY_DISABLED // 0x80000000u

pub const trayentry_checked = C.SDL_TRAYENTRY_CHECKED // 0x40000000u

// TrayCallback as callback that is invoked when a tray entry is selected.
//
// `userdata` userdata an optional pointer to pass extra data to the callback when
//                 it will be invoked.
// `entry` entry the tray entry that was selected.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: set_tray_entry_callback (SDL_SetTrayEntryCallback)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_TrayCallback)
pub type TrayCallback = fn (userdata voidptr, entry &TrayEntry)

// C.SDL_CreateTray [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateTray)
fn C.SDL_CreateTray(icon &Surface, const_tooltip &char) &Tray

// create_tray creates an icon to be placed in the operating system's tray, or equivalent.
//
// Many platforms advise not using a system tray unless persistence is a
// necessary feature. Avoid needlessly creating a tray icon, as the user may
// feel like it clutters their interface.
//
// Using tray icons require the video subsystem.
//
// `icon` icon a surface to be used as icon. May be NULL.
// `tooltip` tooltip a tooltip to be displayed when the mouse hovers the icon in
//                UTF-8 encoding. Not supported on all platforms. May be NULL.
// returns The newly created system tray icon.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_tray_menu (SDL_CreateTrayMenu)
// See also: get_tray_menu (SDL_GetTrayMenu)
// See also: destroy_tray (SDL_DestroyTray)
pub fn create_tray(icon &Surface, const_tooltip &char) &Tray {
	return C.SDL_CreateTray(icon, const_tooltip)
}

// C.SDL_SetTrayIcon [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTrayIcon)
fn C.SDL_SetTrayIcon(tray &Tray, icon &Surface)

// set_tray_icon updates the system tray icon's icon.
//
// `tray` tray the tray icon to be updated.
// `icon` icon the new icon. May be NULL.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_tray (SDL_CreateTray)
pub fn set_tray_icon(tray &Tray, icon &Surface) {
	C.SDL_SetTrayIcon(tray, icon)
}

// C.SDL_SetTrayTooltip [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTrayTooltip)
fn C.SDL_SetTrayTooltip(tray &Tray, const_tooltip &char)

// set_tray_tooltip updates the system tray icon's tooltip.
//
// `tray` tray the tray icon to be updated.
// `tooltip` tooltip the new tooltip in UTF-8 encoding. May be NULL.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_tray (SDL_CreateTray)
pub fn set_tray_tooltip(tray &Tray, const_tooltip &char) {
	C.SDL_SetTrayTooltip(tray, const_tooltip)
}

// C.SDL_CreateTrayMenu [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateTrayMenu)
fn C.SDL_CreateTrayMenu(tray &Tray) &TrayMenu

// create_tray_menu creates a menu for a system tray.
//
// This should be called at most once per tray icon.
//
// This function does the same thing as SDL_CreateTraySubmenu(), except that
// it takes a SDL_Tray instead of a SDL_TrayEntry.
//
// A menu does not need to be destroyed; it will be destroyed with the tray.
//
// `tray` tray the tray to bind the menu to.
// returns the newly created menu.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_tray (SDL_CreateTray)
// See also: get_tray_menu (SDL_GetTrayMenu)
// See also: get_tray_menu_parent_tray (SDL_GetTrayMenuParentTray)
pub fn create_tray_menu(tray &Tray) &TrayMenu {
	return C.SDL_CreateTrayMenu(tray)
}

// C.SDL_CreateTraySubmenu [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateTraySubmenu)
fn C.SDL_CreateTraySubmenu(entry &TrayEntry) &TrayMenu

// create_tray_submenu creates a submenu for a system tray entry.
//
// This should be called at most once per tray entry.
//
// This function does the same thing as SDL_CreateTrayMenu, except that it
// takes a SDL_TrayEntry instead of a SDL_Tray.
//
// A menu does not need to be destroyed; it will be destroyed with the tray.
//
// `entry` entry the tray entry to bind the menu to.
// returns the newly created menu.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
// See also: get_tray_submenu (SDL_GetTraySubmenu)
// See also: get_tray_menu_parent_entry (SDL_GetTrayMenuParentEntry)
pub fn create_tray_submenu(entry &TrayEntry) &TrayMenu {
	return C.SDL_CreateTraySubmenu(entry)
}

// C.SDL_GetTrayMenu [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTrayMenu)
fn C.SDL_GetTrayMenu(tray &Tray) &TrayMenu

// get_tray_menu gets a previously created tray menu.
//
// You should have called SDL_CreateTrayMenu() on the tray object. This
// function allows you to fetch it again later.
//
// This function does the same thing as SDL_GetTraySubmenu(), except that it
// takes a SDL_Tray instead of a SDL_TrayEntry.
//
// A menu does not need to be destroyed; it will be destroyed with the tray.
//
// `tray` tray the tray entry to bind the menu to.
// returns the newly created menu.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_tray (SDL_CreateTray)
// See also: create_tray_menu (SDL_CreateTrayMenu)
pub fn get_tray_menu(tray &Tray) &TrayMenu {
	return C.SDL_GetTrayMenu(tray)
}

// C.SDL_GetTraySubmenu [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTraySubmenu)
fn C.SDL_GetTraySubmenu(entry &TrayEntry) &TrayMenu

// get_tray_submenu gets a previously created tray entry submenu.
//
// You should have called SDL_CreateTraySubmenu() on the entry object. This
// function allows you to fetch it again later.
//
// This function does the same thing as SDL_GetTrayMenu(), except that it
// takes a SDL_TrayEntry instead of a SDL_Tray.
//
// A menu does not need to be destroyed; it will be destroyed with the tray.
//
// `entry` entry the tray entry to bind the menu to.
// returns the newly created menu.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
// See also: create_tray_submenu (SDL_CreateTraySubmenu)
pub fn get_tray_submenu(entry &TrayEntry) &TrayMenu {
	return C.SDL_GetTraySubmenu(entry)
}

// C.SDL_GetTrayEntries [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTrayEntries)
fn C.SDL_GetTrayEntries(menu &TrayMenu, size &int) &&C.SDL_TrayEntry

// get_tray_entries returns a list of entries in the menu, in order.
//
// `menu` menu The menu to get entries from.
// `size` size An optional pointer to obtain the number of entries in the
//             menu.
// returns a NULL-terminated list of entries within the given menu. The
//          pointer becomes invalid when any function that inserts or deletes
//          entries in the menu is called.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: remove_tray_entry (SDL_RemoveTrayEntry)
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
pub fn get_tray_entries(menu &TrayMenu, size &int) &&C.SDL_TrayEntry {
	return C.SDL_GetTrayEntries(menu, size)
}

// C.SDL_RemoveTrayEntry [official documentation](https://wiki.libsdl.org/SDL3/SDL_RemoveTrayEntry)
fn C.SDL_RemoveTrayEntry(entry &TrayEntry)

// remove_tray_entry removes a tray entry.
//
// `entry` entry The entry to be deleted.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_tray_entries (SDL_GetTrayEntries)
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
pub fn remove_tray_entry(entry &TrayEntry) {
	C.SDL_RemoveTrayEntry(entry)
}

// C.SDL_InsertTrayEntryAt [official documentation](https://wiki.libsdl.org/SDL3/SDL_InsertTrayEntryAt)
fn C.SDL_InsertTrayEntryAt(menu &TrayMenu, pos int, const_label &char, flags TrayEntryFlags) &TrayEntry

// insert_tray_entry_at inserts a tray entry at a given position.
//
// If label is NULL, the entry will be a separator. Many functions won't work
// for an entry that is a separator.
//
// An entry does not need to be destroyed; it will be destroyed with the tray.
//
// `menu` menu the menu to append the entry to.
// `pos` pos the desired position for the new entry. Entries at or following
//            this place will be moved. If pos is -1, the entry is appended.
// `label` label the text to be displayed on the entry, in UTF-8 encoding, or
//              NULL for a separator.
// `flags` flags a combination of flags, some of which are mandatory.
// returns the newly created entry, or NULL if pos is out of bounds.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: tray_entry_flags (SDL_TrayEntryFlags)
// See also: get_tray_entries (SDL_GetTrayEntries)
// See also: remove_tray_entry (SDL_RemoveTrayEntry)
// See also: get_tray_entry_parent (SDL_GetTrayEntryParent)
pub fn insert_tray_entry_at(menu &TrayMenu, pos int, const_label &char, flags TrayEntryFlags) &TrayEntry {
	return C.SDL_InsertTrayEntryAt(menu, pos, const_label, flags)
}

// C.SDL_SetTrayEntryLabel [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTrayEntryLabel)
fn C.SDL_SetTrayEntryLabel(entry &TrayEntry, const_label &char)

// set_tray_entry_label sets the label of an entry.
//
// An entry cannot change between a separator and an ordinary entry; that is,
// it is not possible to set a non-NULL label on an entry that has a NULL
// label (separators), or to set a NULL label to an entry that has a non-NULL
// label. The function will silently fail if that happens.
//
// `entry` entry the entry to be updated.
// `label` label the new label for the entry in UTF-8 encoding.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_tray_entries (SDL_GetTrayEntries)
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
// See also: get_tray_entry_label (SDL_GetTrayEntryLabel)
pub fn set_tray_entry_label(entry &TrayEntry, const_label &char) {
	C.SDL_SetTrayEntryLabel(entry, const_label)
}

// C.SDL_GetTrayEntryLabel [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTrayEntryLabel)
fn C.SDL_GetTrayEntryLabel(entry &TrayEntry) &char

// get_tray_entry_label gets the label of an entry.
//
// If the returned value is NULL, the entry is a separator.
//
// `entry` entry the entry to be read.
// returns the label of the entry in UTF-8 encoding.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_tray_entries (SDL_GetTrayEntries)
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
// See also: set_tray_entry_label (SDL_SetTrayEntryLabel)
pub fn get_tray_entry_label(entry &TrayEntry) &char {
	return C.SDL_GetTrayEntryLabel(entry)
}

// C.SDL_SetTrayEntryChecked [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTrayEntryChecked)
fn C.SDL_SetTrayEntryChecked(entry &TrayEntry, checked bool)

// set_tray_entry_checked sets whether or not an entry is checked.
//
// The entry must have been created with the SDL_TRAYENTRY_CHECKBOX flag.
//
// `entry` entry the entry to be updated.
// `checked` checked true if the entry should be checked; false otherwise.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_tray_entries (SDL_GetTrayEntries)
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
// See also: get_tray_entry_checked (SDL_GetTrayEntryChecked)
pub fn set_tray_entry_checked(entry &TrayEntry, checked bool) {
	C.SDL_SetTrayEntryChecked(entry, checked)
}

// C.SDL_GetTrayEntryChecked [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTrayEntryChecked)
fn C.SDL_GetTrayEntryChecked(entry &TrayEntry) bool

// get_tray_entry_checked gets whether or not an entry is checked.
//
// The entry must have been created with the SDL_TRAYENTRY_CHECKBOX flag.
//
// `entry` entry the entry to be read.
// returns true if the entry is checked; false otherwise.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_tray_entries (SDL_GetTrayEntries)
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
// See also: set_tray_entry_checked (SDL_SetTrayEntryChecked)
pub fn get_tray_entry_checked(entry &TrayEntry) bool {
	return C.SDL_GetTrayEntryChecked(entry)
}

// C.SDL_SetTrayEntryEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTrayEntryEnabled)
fn C.SDL_SetTrayEntryEnabled(entry &TrayEntry, enabled bool)

// set_tray_entry_enabled sets whether or not an entry is enabled.
//
// `entry` entry the entry to be updated.
// `enabled` enabled true if the entry should be enabled; false otherwise.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_tray_entries (SDL_GetTrayEntries)
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
// See also: get_tray_entry_enabled (SDL_GetTrayEntryEnabled)
pub fn set_tray_entry_enabled(entry &TrayEntry, enabled bool) {
	C.SDL_SetTrayEntryEnabled(entry, enabled)
}

// C.SDL_GetTrayEntryEnabled [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTrayEntryEnabled)
fn C.SDL_GetTrayEntryEnabled(entry &TrayEntry) bool

// get_tray_entry_enabled gets whether or not an entry is enabled.
//
// `entry` entry the entry to be read.
// returns true if the entry is enabled; false otherwise.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_tray_entries (SDL_GetTrayEntries)
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
// See also: set_tray_entry_enabled (SDL_SetTrayEntryEnabled)
pub fn get_tray_entry_enabled(entry &TrayEntry) bool {
	return C.SDL_GetTrayEntryEnabled(entry)
}

// C.SDL_SetTrayEntryCallback [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTrayEntryCallback)
fn C.SDL_SetTrayEntryCallback(entry &TrayEntry, callback TrayCallback, userdata voidptr)

// set_tray_entry_callback sets a callback to be invoked when the entry is selected.
//
// `entry` entry the entry to be updated.
// `callback` callback a callback to be invoked when the entry is selected.
// `userdata` userdata an optional pointer to pass extra data to the callback when
//                 it will be invoked.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_tray_entries (SDL_GetTrayEntries)
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
pub fn set_tray_entry_callback(entry &TrayEntry, callback TrayCallback, userdata voidptr) {
	C.SDL_SetTrayEntryCallback(entry, callback, userdata)
}

// C.SDL_ClickTrayEntry [official documentation](https://wiki.libsdl.org/SDL3/SDL_ClickTrayEntry)
fn C.SDL_ClickTrayEntry(entry &TrayEntry)

// click_tray_entry simulates a click on a tray entry.
//
// `entry` entry The entry to activate.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn click_tray_entry(entry &TrayEntry) {
	C.SDL_ClickTrayEntry(entry)
}

// C.SDL_DestroyTray [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyTray)
fn C.SDL_DestroyTray(tray &Tray)

// destroy_tray destroys a tray object.
//
// This also destroys all associated menus and entries.
//
// `tray` tray the tray icon to be destroyed.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_tray (SDL_CreateTray)
pub fn destroy_tray(tray &Tray) {
	C.SDL_DestroyTray(tray)
}

// C.SDL_GetTrayEntryParent [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTrayEntryParent)
fn C.SDL_GetTrayEntryParent(entry &TrayEntry) &TrayMenu

// get_tray_entry_parent gets the menu containing a certain tray entry.
//
// `entry` entry the entry for which to get the parent menu.
// returns the parent menu.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: insert_tray_entry_at (SDL_InsertTrayEntryAt)
pub fn get_tray_entry_parent(entry &TrayEntry) &TrayMenu {
	return C.SDL_GetTrayEntryParent(entry)
}

// C.SDL_GetTrayMenuParentEntry [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTrayMenuParentEntry)
fn C.SDL_GetTrayMenuParentEntry(menu &TrayMenu) &TrayEntry

// get_tray_menu_parent_entry gets the entry for which the menu is a submenu, if the current menu is a
// submenu.
//
// Either this function or SDL_GetTrayMenuParentTray() will return non-NULL
// for any given menu.
//
// `menu` menu the menu for which to get the parent entry.
// returns the parent entry, or NULL if this menu is not a submenu.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_tray_submenu (SDL_CreateTraySubmenu)
// See also: get_tray_menu_parent_tray (SDL_GetTrayMenuParentTray)
pub fn get_tray_menu_parent_entry(menu &TrayMenu) &TrayEntry {
	return C.SDL_GetTrayMenuParentEntry(menu)
}

// C.SDL_GetTrayMenuParentTray [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTrayMenuParentTray)
fn C.SDL_GetTrayMenuParentTray(menu &TrayMenu) &Tray

// get_tray_menu_parent_tray gets the tray for which this menu is the first-level menu, if the current
// menu isn't a submenu.
//
// Either this function or SDL_GetTrayMenuParentEntry() will return non-NULL
// for any given menu.
//
// `menu` menu the menu for which to get the parent enttrayry.
// returns the parent tray, or NULL if this menu is a submenu.
//
// NOTE: (thread safety) This function should be called on the thread that created the
//               tray.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_tray_menu (SDL_CreateTrayMenu)
// See also: get_tray_menu_parent_entry (SDL_GetTrayMenuParentEntry)
pub fn get_tray_menu_parent_tray(menu &TrayMenu) &Tray {
	return C.SDL_GetTrayMenuParentTray(menu)
}

// C.SDL_UpdateTrays [official documentation](https://wiki.libsdl.org/SDL3/SDL_UpdateTrays)
fn C.SDL_UpdateTrays()

// update_trays updates the trays.
//
// This is called automatically by the event loop and is only needed if you're
// using trays but aren't handling SDL events.
//
// NOTE: (thread safety) This function should only be called on the main thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn update_trays() {
	C.SDL_UpdateTrays()
}
