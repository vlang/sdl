// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_scancode.h
//

// Defines keyboard scancodes.
//
// Please refer to the Best Keyboard Practices document for details on what
// this information means and how best to use it.
//
// https://wiki.libsdl.org/SDL3/BestKeyboardPractices

// Scancode is the SDL keyboard scancode representation.
//
// An SDL scancode is the physical representation of a key on the keyboard,
// independent of language and keyboard mapping.
//
// Values of this type are used to represent keyboard keys, among other places
// in the `scancode` field of the SDL_KeyboardEvent structure.
//
// The values in this enumeration are based on the USB usage page standard:
// https://usb.org/sites/default/files/hut1_5.pdf
//
// NOTE: This enum is available since SDL 3.2.0.
// Scancode is C.SDL_Scancode
pub enum Scancode {
	unknown = C.SDL_SCANCODE_UNKNOWN // 0,
	//
	// Usage page 0x07
	//
	// These values are from usage page 0x07 (USB keyboard page).
	//
	a = C.SDL_SCANCODE_A // 4,
	b = C.SDL_SCANCODE_B // 5,
	c = C.SDL_SCANCODE_C // 6,
	d = C.SDL_SCANCODE_D // 7,
	e = C.SDL_SCANCODE_E // 8,
	f = C.SDL_SCANCODE_F // 9,
	g = C.SDL_SCANCODE_G // 10,
	h = C.SDL_SCANCODE_H // 11,
	i = C.SDL_SCANCODE_I // 12,
	j = C.SDL_SCANCODE_J // 13,
	k = C.SDL_SCANCODE_K // 14,
	l = C.SDL_SCANCODE_L // 15,
	m = C.SDL_SCANCODE_M // 16,
	n = C.SDL_SCANCODE_N // 17,
	o = C.SDL_SCANCODE_O // 18,
	p = C.SDL_SCANCODE_P // 19,
	q = C.SDL_SCANCODE_Q // 20,
	r = C.SDL_SCANCODE_R // 21,
	s = C.SDL_SCANCODE_S // 22,
	t = C.SDL_SCANCODE_T // 23,
	u = C.SDL_SCANCODE_U // 24,
	v = C.SDL_SCANCODE_V // 25,
	w = C.SDL_SCANCODE_W // 26,
	x = C.SDL_SCANCODE_X // 27,
	y = C.SDL_SCANCODE_Y // 28,
	z = C.SDL_SCANCODE_Z // 29,

	_1 = C.SDL_SCANCODE_1 // 30,
	_2 = C.SDL_SCANCODE_2 // 31,
	_3 = C.SDL_SCANCODE_3 // 32,
	_4 = C.SDL_SCANCODE_4 // 33,
	_5 = C.SDL_SCANCODE_5 // 34,
	_6 = C.SDL_SCANCODE_6 // 35,
	_7 = C.SDL_SCANCODE_7 // 36,
	_8 = C.SDL_SCANCODE_8 // 37,
	_9 = C.SDL_SCANCODE_9 // 38,
	_0 = C.SDL_SCANCODE_0 // 39,

	return    = C.SDL_SCANCODE_RETURN    // 40,
	escape    = C.SDL_SCANCODE_ESCAPE    // 41,
	backspace = C.SDL_SCANCODE_BACKSPACE // 42,
	tab       = C.SDL_SCANCODE_TAB       // 43,
	space     = C.SDL_SCANCODE_SPACE     // 44,

	minus        = C.SDL_SCANCODE_MINUS        // 45,
	equals       = C.SDL_SCANCODE_EQUALS       // 46,
	leftbracket  = C.SDL_SCANCODE_LEFTBRACKET  // 47,
	rightbracket = C.SDL_SCANCODE_RIGHTBRACKET // 48,
	backslash    = C.SDL_SCANCODE_BACKSLASH    // 49,
	// Located at the lower left of the return
	// key on ISO keyboards and at the right end
	// of the QWERTY row on ANSI keyboards.
	// Produces REVERSE SOLIDUS (backslash) and
	// VERTICAL LINE in a US layout, REVERSE
	// SOLIDUS and VERTICAL LINE in a UK Mac
	// layout, NUMBER SIGN and TILDE in a UK
	// Windows layout, DOLLAR SIGN and POUND SIGN
	// in a Swiss German layout, NUMBER SIGN and
	// APOSTROPHE in a German layout, GRAVE
	// ACCENT and POUND SIGN in a French Mac
	// layout, and ASTERISK and MICRO SIGN in a
	// French Windows layout.
	//
	nonushash = C.SDL_SCANCODE_NONUSHASH // 50,
	// ISO USB keyboards actually use this code
	// instead of 49 for the same key, but all
	// OSes I've seen treat the two codes
	// identically. So, as an implementor, unless
	// your keyboard generates both of those
	// codes and your OS treats them differently,
	// you should generate SDL_SCANCODE_BACKSLASH
	// instead of this code. As a user, you
	// should not rely on this code because SDL
	// will never generate it with most (all?)
	// keyboards.
	//
	semicolon  = C.SDL_SCANCODE_SEMICOLON  // 51,
	apostrophe = C.SDL_SCANCODE_APOSTROPHE // 52,
	grave      = C.SDL_SCANCODE_GRAVE      // 53,
	// Located in the top left corner (on both ANSI
	// and ISO keyboards). Produces GRAVE ACCENT and
	// TILDE in a US Windows layout and in US and UK
	// Mac layouts on ANSI keyboards, GRAVE ACCENT
	// and NOT SIGN in a UK Windows layout, SECTION
	// SIGN and PLUS-MINUS SIGN in US and UK Mac
	// layouts on ISO keyboards, SECTION SIGN and
	// DEGREE SIGN in a Swiss German layout (Mac:
	// only on ISO keyboards), CIRCUMFLEX ACCENT and
	// DEGREE SIGN in a German layout (Mac: only on
	// ISO keyboards), SUPERSCRIPT TWO and TILDE in a
	// French Windows layout, COMMERCIAL AT and
	// NUMBER SIGN in a French Mac layout on ISO
	// keyboards, and LESS-THAN SIGN and GREATER-THAN
	// SIGN in a Swiss German, German, or French Mac
	// layout on ANSI keyboards.
	//
	comma       = C.SDL_SCANCODE_COMMA       // 54,
	period      = C.SDL_SCANCODE_PERIOD      // 55,
	slash       = C.SDL_SCANCODE_SLASH       // 56,
	capslock    = C.SDL_SCANCODE_CAPSLOCK    // 57,
	f1          = C.SDL_SCANCODE_F1          // 58,
	f2          = C.SDL_SCANCODE_F2          // 59,
	f3          = C.SDL_SCANCODE_F3          // 60,
	f4          = C.SDL_SCANCODE_F4          // 61,
	f5          = C.SDL_SCANCODE_F5          // 62,
	f6          = C.SDL_SCANCODE_F6          // 63,
	f7          = C.SDL_SCANCODE_F7          // 64,
	f8          = C.SDL_SCANCODE_F8          // 65,
	f9          = C.SDL_SCANCODE_F9          // 66,
	f10         = C.SDL_SCANCODE_F10         // 67,
	f11         = C.SDL_SCANCODE_F11         // 68,
	f12         = C.SDL_SCANCODE_F12         // 69,
	printscreen = C.SDL_SCANCODE_PRINTSCREEN // 70,
	scrolllock  = C.SDL_SCANCODE_SCROLLLOCK  // 71,
	pause       = C.SDL_SCANCODE_PAUSE       // 72,
	insert      = C.SDL_SCANCODE_INSERT      // 73,
	// insert on PC, help on some Mac keyboards (but
	// does send code 73, not 117)
	//
	home         = C.SDL_SCANCODE_HOME         // 74,
	pageup       = C.SDL_SCANCODE_PAGEUP       // 75,
	delete       = C.SDL_SCANCODE_DELETE       // 76,
	end          = C.SDL_SCANCODE_END          // 77,
	pagedown     = C.SDL_SCANCODE_PAGEDOWN     // 78,
	right        = C.SDL_SCANCODE_RIGHT        // 79,
	left         = C.SDL_SCANCODE_LEFT         // 80,
	down         = C.SDL_SCANCODE_DOWN         // 81,
	up           = C.SDL_SCANCODE_UP           // 82,
	numlockclear = C.SDL_SCANCODE_NUMLOCKCLEAR // 83,
	// num lock on PC, clear on Mac keyboards
	//
	kp_divide      = C.SDL_SCANCODE_KP_DIVIDE      // 84,
	kp_multiply    = C.SDL_SCANCODE_KP_MULTIPLY    // 85,
	kp_minus       = C.SDL_SCANCODE_KP_MINUS       // 86,
	kp_plus        = C.SDL_SCANCODE_KP_PLUS        // 87,
	kp_enter       = C.SDL_SCANCODE_KP_ENTER       // 88,
	kp_1           = C.SDL_SCANCODE_KP_1           // 89,
	kp_2           = C.SDL_SCANCODE_KP_2           // 90,
	kp_3           = C.SDL_SCANCODE_KP_3           // 91,
	kp_4           = C.SDL_SCANCODE_KP_4           // 92,
	kp_5           = C.SDL_SCANCODE_KP_5           // 93,
	kp_6           = C.SDL_SCANCODE_KP_6           // 94,
	kp_7           = C.SDL_SCANCODE_KP_7           // 95,
	kp_8           = C.SDL_SCANCODE_KP_8           // 96,
	kp_9           = C.SDL_SCANCODE_KP_9           // 97,
	kp_0           = C.SDL_SCANCODE_KP_0           // 98,
	kp_period      = C.SDL_SCANCODE_KP_PERIOD      // 99,
	nonusbackslash = C.SDL_SCANCODE_NONUSBACKSLASH // 100,
	// This is the additional key that ISO
	// keyboards have over ANSI ones,
	// located between left shift and Y.
	// Produces GRAVE ACCENT and TILDE in a
	// US or UK Mac layout, REVERSE SOLIDUS
	// (backslash) and VERTICAL LINE in a
	// US or UK Windows layout, and
	// LESS-THAN SIGN and GREATER-THAN SIGN
	// in a Swiss German, German, or French
	// layout.
	//
	application = C.SDL_SCANCODE_APPLICATION // 101,
	// windows contextual menu, compose
	//
	power = C.SDL_SCANCODE_POWER // 102,
	// The USB document says this is a status flag,
	// not a physical key - but some Mac keyboards
	// do have a power key.
	//
	kp_equals  = C.SDL_SCANCODE_KP_EQUALS  // 103,
	f13        = C.SDL_SCANCODE_F13        // 104,
	f14        = C.SDL_SCANCODE_F14        // 105,
	f15        = C.SDL_SCANCODE_F15        // 106,
	f16        = C.SDL_SCANCODE_F16        // 107,
	f17        = C.SDL_SCANCODE_F17        // 108,
	f18        = C.SDL_SCANCODE_F18        // 109,
	f19        = C.SDL_SCANCODE_F19        // 110,
	f20        = C.SDL_SCANCODE_F20        // 111,
	f21        = C.SDL_SCANCODE_F21        // 112,
	f22        = C.SDL_SCANCODE_F22        // 113,
	f23        = C.SDL_SCANCODE_F23        // 114,
	f24        = C.SDL_SCANCODE_F24        // 115,
	execute    = C.SDL_SCANCODE_EXECUTE    // 116,
	help       = C.SDL_SCANCODE_HELP       // 117, AL Integrated Help Center
	menu       = C.SDL_SCANCODE_MENU       // 118, Menu (show menu)
	select     = C.SDL_SCANCODE_SELECT     // 119,
	stop       = C.SDL_SCANCODE_STOP       // 120, AC Stop
	again      = C.SDL_SCANCODE_AGAIN      // 121, AC Redo/Repeat
	undo       = C.SDL_SCANCODE_UNDO       // 122, AC Undo
	cut        = C.SDL_SCANCODE_CUT        // 123, AC Cut
	copy       = C.SDL_SCANCODE_COPY       // 124, AC Copy
	paste      = C.SDL_SCANCODE_PASTE      // 125, AC Paste
	find       = C.SDL_SCANCODE_FIND       // 126, AC Find
	mute       = C.SDL_SCANCODE_MUTE       // 127,
	volumeup   = C.SDL_SCANCODE_VOLUMEUP   // 128,
	volumedown = C.SDL_SCANCODE_VOLUMEDOWN // 129,
	// not sure whether there's a reason to enable these:
	// lockingcapslock = C.SDL_SCANCODE_LOCKINGCAPSLOCK // 130,
	// lockingnumlock = C.SDL_SCANCODE_LOCKINGNUMLOCK = // 131,
	// lockingscrolllock = C:SDL_SCANCODE_LOCKINGSCROLLLOCK // 132,
	kp_comma       = C.SDL_SCANCODE_KP_COMMA       // 133,
	kp_equalsas400 = C.SDL_SCANCODE_KP_EQUALSAS400 // 134,
	international1 = C.SDL_SCANCODE_INTERNATIONAL1 // 135,
	// used on Asian keyboards, see
	// footnotes in USB doc
	international2     = C.SDL_SCANCODE_INTERNATIONAL2     // 136,
	international3     = C.SDL_SCANCODE_INTERNATIONAL3     // 137, Yen
	international4     = C.SDL_SCANCODE_INTERNATIONAL4     // 138,
	international5     = C.SDL_SCANCODE_INTERNATIONAL5     // 139,
	international6     = C.SDL_SCANCODE_INTERNATIONAL6     // 140,
	international7     = C.SDL_SCANCODE_INTERNATIONAL7     // 141,
	international8     = C.SDL_SCANCODE_INTERNATIONAL8     // 142,
	international9     = C.SDL_SCANCODE_INTERNATIONAL9     // 143,
	lang1              = C.SDL_SCANCODE_LANG1              // 144, Hangul/English toggle
	lang2              = C.SDL_SCANCODE_LANG2              // 145, Hanja conversion
	lang3              = C.SDL_SCANCODE_LANG3              // 146, Katakana
	lang4              = C.SDL_SCANCODE_LANG4              // 147, Hiragana
	lang5              = C.SDL_SCANCODE_LANG5              // 148, Zenkaku/Hankaku
	lang6              = C.SDL_SCANCODE_LANG6              // 149, reserved
	lang7              = C.SDL_SCANCODE_LANG7              // 150, reserved
	lang8              = C.SDL_SCANCODE_LANG8              // 151, reserved
	lang9              = C.SDL_SCANCODE_LANG9              // 152, reserved
	alterase           = C.SDL_SCANCODE_ALTERASE           // 153, Erase-Eaze
	sysreq             = C.SDL_SCANCODE_SYSREQ             // 154,
	cancel             = C.SDL_SCANCODE_CANCEL             // 155, AC Cancel
	clear              = C.SDL_SCANCODE_CLEAR              // 156,
	prior              = C.SDL_SCANCODE_PRIOR              // 157,
	return2            = C.SDL_SCANCODE_RETURN2            // 158,
	separator          = C.SDL_SCANCODE_SEPARATOR          // 159,
	out                = C.SDL_SCANCODE_OUT                // 160,
	oper               = C.SDL_SCANCODE_OPER               // 161,
	clearagain         = C.SDL_SCANCODE_CLEARAGAIN         // 162,
	crsel              = C.SDL_SCANCODE_CRSEL              // 163,
	exsel              = C.SDL_SCANCODE_EXSEL              // 164,
	kp_00              = C.SDL_SCANCODE_KP_00              // 176,
	kp_000             = C.SDL_SCANCODE_KP_000             // 177,
	thousandsseparator = C.SDL_SCANCODE_THOUSANDSSEPARATOR // 178,
	decimalseparator   = C.SDL_SCANCODE_DECIMALSEPARATOR   // 179,
	currencyunit       = C.SDL_SCANCODE_CURRENCYUNIT       // 180,
	currencysubunit    = C.SDL_SCANCODE_CURRENCYSUBUNIT    // 181,
	kp_leftparen       = C.SDL_SCANCODE_KP_LEFTPAREN       // 182,
	kp_rightparen      = C.SDL_SCANCODE_KP_RIGHTPAREN      // 183,
	kp_leftbrace       = C.SDL_SCANCODE_KP_LEFTBRACE       // 184,
	kp_rightbrace      = C.SDL_SCANCODE_KP_RIGHTBRACE      // 185,
	kp_tab             = C.SDL_SCANCODE_KP_TAB             // 186,
	kp_backspace       = C.SDL_SCANCODE_KP_BACKSPACE       // 187,
	kp_a               = C.SDL_SCANCODE_KP_A               // 188,
	kp_b               = C.SDL_SCANCODE_KP_B               // 189,
	kp_c               = C.SDL_SCANCODE_KP_C               // 190,
	kp_d               = C.SDL_SCANCODE_KP_D               // 191,
	kp_e               = C.SDL_SCANCODE_KP_E               // 192,
	kp_f               = C.SDL_SCANCODE_KP_F               // 193,
	kp_xor             = C.SDL_SCANCODE_KP_XOR             // 194,
	kp_power           = C.SDL_SCANCODE_KP_POWER           // 195,
	kp_percent         = C.SDL_SCANCODE_KP_PERCENT         // 196,
	kp_less            = C.SDL_SCANCODE_KP_LESS            // 197,
	kp_greater         = C.SDL_SCANCODE_KP_GREATER         // 198,
	kp_ampersand       = C.SDL_SCANCODE_KP_AMPERSAND       // 199,
	kp_dblampersand    = C.SDL_SCANCODE_KP_DBLAMPERSAND    // 200,
	kp_verticalbar     = C.SDL_SCANCODE_KP_VERTICALBAR     // 201,
	kp_dblverticalbar  = C.SDL_SCANCODE_KP_DBLVERTICALBAR  // 202,
	kp_colon           = C.SDL_SCANCODE_KP_COLON           // 203,
	kp_hash            = C.SDL_SCANCODE_KP_HASH            // 204,
	kp_space           = C.SDL_SCANCODE_KP_SPACE           // 205,
	kp_at              = C.SDL_SCANCODE_KP_AT              // 206,
	kp_exclam          = C.SDL_SCANCODE_KP_EXCLAM          // 207,
	kp_memstore        = C.SDL_SCANCODE_KP_MEMSTORE        // 208,
	kp_memrecall       = C.SDL_SCANCODE_KP_MEMRECALL       // 209,
	kp_memclear        = C.SDL_SCANCODE_KP_MEMCLEAR        // 210,
	kp_memadd          = C.SDL_SCANCODE_KP_MEMADD          // 211,
	kp_memsubtract     = C.SDL_SCANCODE_KP_MEMSUBTRACT     // 212,
	kp_memmultiply     = C.SDL_SCANCODE_KP_MEMMULTIPLY     // 213,
	kp_memdivide       = C.SDL_SCANCODE_KP_MEMDIVIDE       // 214,
	kp_plusminus       = C.SDL_SCANCODE_KP_PLUSMINUS       // 215,
	kp_clear           = C.SDL_SCANCODE_KP_CLEAR           // 216,
	kp_clearentry      = C.SDL_SCANCODE_KP_CLEARENTRY      // 217,
	kp_binary          = C.SDL_SCANCODE_KP_BINARY          // 218,
	kp_octal           = C.SDL_SCANCODE_KP_OCTAL           // 219,
	kp_decimal         = C.SDL_SCANCODE_KP_DECIMAL         // 220,
	kp_hexadecimal     = C.SDL_SCANCODE_KP_HEXADECIMAL     // 221,
	lctrl              = C.SDL_SCANCODE_LCTRL              // 224,
	lshift             = C.SDL_SCANCODE_LSHIFT             // 225,
	lalt               = C.SDL_SCANCODE_LALT               // 226, alt, option
	lgui               = C.SDL_SCANCODE_LGUI               // 227, windows, command (apple), meta
	rctrl              = C.SDL_SCANCODE_RCTRL              // 228,
	rshift             = C.SDL_SCANCODE_RSHIFT             // 229,
	ralt               = C.SDL_SCANCODE_RALT               // 230, alt gr, option
	rgui               = C.SDL_SCANCODE_RGUI               // 231, windows, command (apple), meta
	mode               = C.SDL_SCANCODE_MODE               // 257,
	// I'm not sure if this is really not covered
	// by any of the above, but since there's a
	// special SDL_KMOD_MODE for it I'm adding it here
	//

	//
	// Usage page 0x0C
	//
	// These values are mapped from usage page 0x0C (USB consumer page).
	//
	// There are way more keys in the spec than we can represent in the
	// current scancode range, so pick the ones that commonly come up in
	// real world usage.
	//
	sleep                = C.SDL_SCANCODE_SLEEP                // 258, Sleep
	wake                 = C.SDL_SCANCODE_WAKE                 // 259, Wake
	channel_increment    = C.SDL_SCANCODE_CHANNEL_INCREMENT    // 260, Channel Increment
	channel_decrement    = C.SDL_SCANCODE_CHANNEL_DECREMENT    // 261, Channel Decrement
	media_play           = C.SDL_SCANCODE_MEDIA_PLAY           // 262, Play
	media_pause          = C.SDL_SCANCODE_MEDIA_PAUSE          // 263, Pause
	media_record         = C.SDL_SCANCODE_MEDIA_RECORD         // 264, Record
	media_fast_forward   = C.SDL_SCANCODE_MEDIA_FAST_FORWARD   // 265, Fast Forward
	media_rewind         = C.SDL_SCANCODE_MEDIA_REWIND         // 266, Rewind
	media_next_track     = C.SDL_SCANCODE_MEDIA_NEXT_TRACK     // 267, Next Track
	media_previous_track = C.SDL_SCANCODE_MEDIA_PREVIOUS_TRACK // 268, Previous Track
	media_stop           = C.SDL_SCANCODE_MEDIA_STOP           // 269, Stop
	media_eject          = C.SDL_SCANCODE_MEDIA_EJECT          // 270, Eject
	media_play_pause     = C.SDL_SCANCODE_MEDIA_PLAY_PAUSE     // 271, Play / Pause
	media_select         = C.SDL_SCANCODE_MEDIA_SELECT         // 272, Media Select
	ac_new               = C.SDL_SCANCODE_AC_NEW               // 273, AC New
	ac_open              = C.SDL_SCANCODE_AC_OPEN              // 274, AC Open
	ac_close             = C.SDL_SCANCODE_AC_CLOSE             // 275, AC Close
	ac_exit              = C.SDL_SCANCODE_AC_EXIT              // 276, AC Exit
	ac_save              = C.SDL_SCANCODE_AC_SAVE              // 277, AC Save
	ac_print             = C.SDL_SCANCODE_AC_PRINT             // 278, AC Print
	ac_properties        = C.SDL_SCANCODE_AC_PROPERTIES        // 279, AC Properties
	ac_search            = C.SDL_SCANCODE_AC_SEARCH            // 280, AC Search
	ac_home              = C.SDL_SCANCODE_AC_HOME              // 281, AC Home
	ac_back              = C.SDL_SCANCODE_AC_BACK              // 282, AC Back
	ac_forward           = C.SDL_SCANCODE_AC_FORWARD           // 283, AC Forward
	ac_stop              = C.SDL_SCANCODE_AC_STOP              // 284, AC Stop
	ac_refresh           = C.SDL_SCANCODE_AC_REFRESH           // 285, AC Refresh
	ac_bookmarks         = C.SDL_SCANCODE_AC_BOOKMARKS         // 286, AC Bookmarks
	//
	// Mobile keys
	//
	// These are values that are often used on mobile phones.
	//
	softleft = C.SDL_SCANCODE_SOFTLEFT // 287,
	// Usually situated below the display on phones and
	// used as a multi-function feature key for selecting
	// a software defined function shown on the bottom left
	// of the display.
	softright = C.SDL_SCANCODE_SOFTRIGHT // 288,
	// Usually situated below the display on phones and
	// used as a multi-function feature key for selecting
	// a software defined function shown on the bottom right
	// of the display.
	call     = C.SDL_SCANCODE_CALL     // 289, Used for accepting phone calls.
	endcall  = C.SDL_SCANCODE_ENDCALL  // 290, Used for rejecting phone calls.
	reserved = C.SDL_SCANCODE_RESERVED // 400, 400-500 reserved for dynamic keycodes
	count    = C.SDL_SCANCODE_COUNT    // 512, not a key, just marks the number of scancodes for array bounds
}
