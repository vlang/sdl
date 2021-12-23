// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_scancode.h
//

// Scancode is the SDL keyboard scancode representation.
//
// Values of this type are used to represent keyboard keys, among other places
// in the SDL_Keysym::scancode key.keysym.scancode field of the
// SDL_Event structure.
//
// The values in this enumeration are based on the USB usage page standard:
// http://www.usb.org/developers/hidpage/Hut1_12v2.pdf
// Scancode is C.SDL_Scancode
pub enum Scancode {
	scancode_unknown = C.SDL_SCANCODE_UNKNOWN // 0
	// Usage page 0x07
	//
	// These values are from usage page 0x07 (USB keyboard page).
	//
	scancode_a = C.SDL_SCANCODE_A // 4
	scancode_b = C.SDL_SCANCODE_B // 5
	scancode_c = C.SDL_SCANCODE_C // 6
	scancode_d = C.SDL_SCANCODE_D // 7
	scancode_e = C.SDL_SCANCODE_E // 8
	scancode_f = C.SDL_SCANCODE_F // 9
	scancode_g = C.SDL_SCANCODE_G // 10
	scancode_h = C.SDL_SCANCODE_H // 11
	scancode_i = C.SDL_SCANCODE_I // 12
	scancode_j = C.SDL_SCANCODE_J // 13
	scancode_k = C.SDL_SCANCODE_K // 14
	scancode_l = C.SDL_SCANCODE_L // 15
	scancode_m = C.SDL_SCANCODE_M // 16
	scancode_n = C.SDL_SCANCODE_N // 17
	scancode_o = C.SDL_SCANCODE_O // 18
	scancode_p = C.SDL_SCANCODE_P // 19
	scancode_q = C.SDL_SCANCODE_Q // 20
	scancode_r = C.SDL_SCANCODE_R // 21
	scancode_s = C.SDL_SCANCODE_S // 22
	scancode_t = C.SDL_SCANCODE_T // 23
	scancode_u = C.SDL_SCANCODE_U // 24
	scancode_v = C.SDL_SCANCODE_V // 25
	scancode_w = C.SDL_SCANCODE_W // 26
	scancode_x = C.SDL_SCANCODE_X // 27
	scancode_y = C.SDL_SCANCODE_Y // 28
	scancode_z = C.SDL_SCANCODE_Z // 29
	//
	scancode_1 = C.SDL_SCANCODE_1 // 30
	scancode_2 = C.SDL_SCANCODE_2 // 31
	scancode_3 = C.SDL_SCANCODE_3 // 32
	scancode_4 = C.SDL_SCANCODE_4 // 33
	scancode_5 = C.SDL_SCANCODE_5 // 34
	scancode_6 = C.SDL_SCANCODE_6 // 35
	scancode_7 = C.SDL_SCANCODE_7 // 36
	scancode_8 = C.SDL_SCANCODE_8 // 37
	scancode_9 = C.SDL_SCANCODE_9 // 38
	scancode_0 = C.SDL_SCANCODE_0 // 39
	//
	scancode_return = C.SDL_SCANCODE_RETURN // 40
	scancode_escape = C.SDL_SCANCODE_ESCAPE // 41
	scancode_backspace = C.SDL_SCANCODE_BACKSPACE // 42
	scancode_tab = C.SDL_SCANCODE_TAB // 43
	scancode_space = C.SDL_SCANCODE_SPACE // 44
	//
	scancode_minus = C.SDL_SCANCODE_MINUS // 45
	scancode_equals = C.SDL_SCANCODE_EQUALS // 46
	scancode_leftbracket = C.SDL_SCANCODE_LEFTBRACKET // 47
	scancode_rightbracket = C.SDL_SCANCODE_RIGHTBRACKET // 48
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
	scancode_backslash = C.SDL_SCANCODE_BACKSLASH // 49
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
	scancode_nonushash = C.SDL_SCANCODE_NONUSHASH // 50
	scancode_semicolon = C.SDL_SCANCODE_SEMICOLON // 51
	scancode_apostrophe = C.SDL_SCANCODE_APOSTROPHE // 52
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
	scancode_grave = C.SDL_SCANCODE_GRAVE // 53
	//
	scancode_comma = C.SDL_SCANCODE_COMMA // 54
	scancode_period = C.SDL_SCANCODE_PERIOD // 55
	scancode_slash = C.SDL_SCANCODE_SLASH // 56
	//
	scancode_capslock = C.SDL_SCANCODE_CAPSLOCK // 57
	//
	scancode_f1 = C.SDL_SCANCODE_F1 // 58
	scancode_f2 = C.SDL_SCANCODE_F2 // 59
	scancode_f3 = C.SDL_SCANCODE_F3 // 60
	scancode_f4 = C.SDL_SCANCODE_F4 // 61
	scancode_f5 = C.SDL_SCANCODE_F5 // 62
	scancode_f6 = C.SDL_SCANCODE_F6 // 63
	scancode_f7 = C.SDL_SCANCODE_F7 // 64
	scancode_f8 = C.SDL_SCANCODE_F8 // 65
	scancode_f9 = C.SDL_SCANCODE_F9 // 66
	scancode_f10 = C.SDL_SCANCODE_F10 // 67
	scancode_f11 = C.SDL_SCANCODE_F11 // 68
	scancode_f12 = C.SDL_SCANCODE_F12 // 69
	//
	scancode_printscreen = C.SDL_SCANCODE_PRINTSCREEN // 70
	scancode_scrolllock = C.SDL_SCANCODE_SCROLLLOCK // 71
	scancode_pause = C.SDL_SCANCODE_PAUSE // 72
	// insert on PC, help on some Mac keyboards (but does send code 73, not 117)
	scancode_insert = C.SDL_SCANCODE_INSERT // 73
	//
	scancode_home = C.SDL_SCANCODE_HOME // 74
	scancode_pageup = C.SDL_SCANCODE_PAGEUP // 75
	scancode_delete = C.SDL_SCANCODE_DELETE // 76
	scancode_end = C.SDL_SCANCODE_END // 77
	scancode_pagedown = C.SDL_SCANCODE_PAGEDOWN // 78
	scancode_right = C.SDL_SCANCODE_RIGHT // 79
	scancode_left = C.SDL_SCANCODE_LEFT // 80
	scancode_down = C.SDL_SCANCODE_DOWN // 81
	scancode_up = C.SDL_SCANCODE_UP // 82
	//
	scancode_numlockclear = C.SDL_SCANCODE_NUMLOCKCLEAR // 83 num lock on PC, clear on Mac keyboards
	//
	scancode_kp_divide = C.SDL_SCANCODE_KP_DIVIDE // 84
	scancode_kp_multiply = C.SDL_SCANCODE_KP_MULTIPLY // 85
	scancode_kp_minus = C.SDL_SCANCODE_KP_MINUS // 86
	scancode_kp_plus = C.SDL_SCANCODE_KP_PLUS // 87
	scancode_kp_enter = C.SDL_SCANCODE_KP_ENTER // 88
	scancode_kp_1 = C.SDL_SCANCODE_KP_1 // 89
	scancode_kp_2 = C.SDL_SCANCODE_KP_2 // 90
	scancode_kp_3 = C.SDL_SCANCODE_KP_3 // 91
	scancode_kp_4 = C.SDL_SCANCODE_KP_4 // 92
	scancode_kp_5 = C.SDL_SCANCODE_KP_5 // 93
	scancode_kp_6 = C.SDL_SCANCODE_KP_6 // 94
	scancode_kp_7 = C.SDL_SCANCODE_KP_7 // 95
	scancode_kp_8 = C.SDL_SCANCODE_KP_8 // 96
	scancode_kp_9 = C.SDL_SCANCODE_KP_9 // 97
	scancode_kp_0 = C.SDL_SCANCODE_KP_0 // 98
	scancode_kp_period = C.SDL_SCANCODE_KP_PERIOD // 99
	//
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
	scancode_nonusbackslash = C.SDL_SCANCODE_NONUSBACKSLASH // 100
	//
	scancode_application = C.SDL_SCANCODE_APPLICATION // 101 windows contextual menu, compose
	// The USB document says this is a status flag,
	// not a physical key - but some Mac keyboards
	// do have a power key.
	scancode_power = C.SDL_SCANCODE_POWER // 102
	//
	scancode_kp_equals = C.SDL_SCANCODE_KP_EQUALS // 103
	scancode_f13 = C.SDL_SCANCODE_F13 // 104
	scancode_f14 = C.SDL_SCANCODE_F14 // 105
	scancode_f15 = C.SDL_SCANCODE_F15 // 106
	scancode_f16 = C.SDL_SCANCODE_F16 // 107
	scancode_f17 = C.SDL_SCANCODE_F17 // 108
	scancode_f18 = C.SDL_SCANCODE_F18 // 109
	scancode_f19 = C.SDL_SCANCODE_F19 // 110
	scancode_f20 = C.SDL_SCANCODE_F20 // 111
	scancode_f21 = C.SDL_SCANCODE_F21 // 112
	scancode_f22 = C.SDL_SCANCODE_F22 // 113
	scancode_f23 = C.SDL_SCANCODE_F23 // 114
	scancode_f24 = C.SDL_SCANCODE_F24 // 115
	scancode_execute = C.SDL_SCANCODE_EXECUTE // 116
	scancode_help = C.SDL_SCANCODE_HELP // 117
	scancode_menu = C.SDL_SCANCODE_MENU // 118
	scancode_select = C.SDL_SCANCODE_SELECT // 119
	scancode_stop = C.SDL_SCANCODE_STOP // 120
	scancode_again = C.SDL_SCANCODE_AGAIN // 121< redo
	scancode_undo = C.SDL_SCANCODE_UNDO // 122
	scancode_cut = C.SDL_SCANCODE_CUT // 123
	scancode_copy = C.SDL_SCANCODE_COPY // 124
	scancode_paste = C.SDL_SCANCODE_PASTE // 125
	scancode_find = C.SDL_SCANCODE_FIND // 126
	scancode_mute = C.SDL_SCANCODE_MUTE // 127
	scancode_volumeup = C.SDL_SCANCODE_VOLUMEUP // 128
	scancode_volumedown = C.SDL_SCANCODE_VOLUMEDOWN // 129
	//
	scancode_kp_comma = C.SDL_SCANCODE_KP_COMMA // 133
	scancode_kp_equalsas400 = C.SDL_SCANCODE_KP_EQUALSAS400 // 134
	scancode_international1 = C.SDL_SCANCODE_INTERNATIONAL1 // 135 used on Asian keyboards, see footnotes in USB doc
	scancode_international2 = C.SDL_SCANCODE_INTERNATIONAL2 // 136
	scancode_international3 = C.SDL_SCANCODE_INTERNATIONAL3 // 137 Yen
	scancode_international4 = C.SDL_SCANCODE_INTERNATIONAL4 // 138
	scancode_international5 = C.SDL_SCANCODE_INTERNATIONAL5 // 139
	scancode_international6 = C.SDL_SCANCODE_INTERNATIONAL6 // 140
	scancode_international7 = C.SDL_SCANCODE_INTERNATIONAL7 // 141
	scancode_international8 = C.SDL_SCANCODE_INTERNATIONAL8 // 142
	scancode_international9 = C.SDL_SCANCODE_INTERNATIONAL9 // 143
	scancode_lang1 = C.SDL_SCANCODE_LANG1 // 144 Hangul/English toggle
	scancode_lang2 = C.SDL_SCANCODE_LANG2 // 145 Hanja conversion
	scancode_lang3 = C.SDL_SCANCODE_LANG3 // 146 Katakana
	scancode_lang4 = C.SDL_SCANCODE_LANG4 // 147 Hiragana
	scancode_lang5 = C.SDL_SCANCODE_LANG5 // 148 Zenkaku/Hankaku
	scancode_lang6 = C.SDL_SCANCODE_LANG6 // 149 reserved
	scancode_lang7 = C.SDL_SCANCODE_LANG7 // 150 reserved
	scancode_lang8 = C.SDL_SCANCODE_LANG8 // 151 reserved
	scancode_lang9 = C.SDL_SCANCODE_LANG9 // 152 reserved
	//
	scancode_alterase = C.SDL_SCANCODE_ALTERASE // 153 Erase-Eaze
	scancode_sysreq = C.SDL_SCANCODE_SYSREQ // 154
	scancode_cancel = C.SDL_SCANCODE_CANCEL // 155
	scancode_clear = C.SDL_SCANCODE_CLEAR // 156
	scancode_prior = C.SDL_SCANCODE_PRIOR // 157
	scancode_return2 = C.SDL_SCANCODE_RETURN2 // 158
	scancode_separator = C.SDL_SCANCODE_SEPARATOR // 159
	scancode_out = C.SDL_SCANCODE_OUT // 160
	scancode_oper = C.SDL_SCANCODE_OPER // 161
	scancode_clearagain = C.SDL_SCANCODE_CLEARAGAIN // 162
	scancode_crsel = C.SDL_SCANCODE_CRSEL // 163
	scancode_exsel = C.SDL_SCANCODE_EXSEL // 164
	scancode_kp_00 = C.SDL_SCANCODE_KP_00 // 176
	scancode_kp_000 = C.SDL_SCANCODE_KP_000 // 177
	scancode_thousandsseparator = C.SDL_SCANCODE_THOUSANDSSEPARATOR // 178
	scancode_decimalseparator = C.SDL_SCANCODE_DECIMALSEPARATOR // 179
	scancode_currencyunit = C.SDL_SCANCODE_CURRENCYUNIT // 180
	scancode_currencysubunit = C.SDL_SCANCODE_CURRENCYSUBUNIT // 181
	scancode_kp_leftparen = C.SDL_SCANCODE_KP_LEFTPAREN // 182
	scancode_kp_rightparen = C.SDL_SCANCODE_KP_RIGHTPAREN // 183
	scancode_kp_leftbrace = C.SDL_SCANCODE_KP_LEFTBRACE // 184
	scancode_kp_rightbrace = C.SDL_SCANCODE_KP_RIGHTBRACE // 185
	scancode_kp_tab = C.SDL_SCANCODE_KP_TAB // 186
	scancode_kp_backspace = C.SDL_SCANCODE_KP_BACKSPACE // 187
	scancode_kp_a = C.SDL_SCANCODE_KP_A // 188
	scancode_kp_b = C.SDL_SCANCODE_KP_B // 189
	scancode_kp_c = C.SDL_SCANCODE_KP_C // 190
	scancode_kp_d = C.SDL_SCANCODE_KP_D // 191
	scancode_kp_e = C.SDL_SCANCODE_KP_E // 192
	scancode_kp_f = C.SDL_SCANCODE_KP_F // 193
	scancode_kp_xor = C.SDL_SCANCODE_KP_XOR // 194
	scancode_kp_power = C.SDL_SCANCODE_KP_POWER // 195
	scancode_kp_percent = C.SDL_SCANCODE_KP_PERCENT // 196
	scancode_kp_less = C.SDL_SCANCODE_KP_LESS // 197
	scancode_kp_greater = C.SDL_SCANCODE_KP_GREATER // 198
	scancode_kp_ampersand = C.SDL_SCANCODE_KP_AMPERSAND // 199
	scancode_kp_dblampersand = C.SDL_SCANCODE_KP_DBLAMPERSAND // 200
	scancode_kp_verticalbar = C.SDL_SCANCODE_KP_VERTICALBAR // 201
	scancode_kp_dblverticalbar = C.SDL_SCANCODE_KP_DBLVERTICALBAR // 202
	scancode_kp_colon = C.SDL_SCANCODE_KP_COLON // 203
	scancode_kp_hash = C.SDL_SCANCODE_KP_HASH // 204
	scancode_kp_space = C.SDL_SCANCODE_KP_SPACE // 205
	scancode_kp_at = C.SDL_SCANCODE_KP_AT // 206
	scancode_kp_exclam = C.SDL_SCANCODE_KP_EXCLAM // 207
	scancode_kp_memstore = C.SDL_SCANCODE_KP_MEMSTORE // 208
	scancode_kp_memrecall = C.SDL_SCANCODE_KP_MEMRECALL // 209
	scancode_kp_memclear = C.SDL_SCANCODE_KP_MEMCLEAR // 210
	scancode_kp_memadd = C.SDL_SCANCODE_KP_MEMADD // 211
	scancode_kp_memsubtract = C.SDL_SCANCODE_KP_MEMSUBTRACT // 212
	scancode_kp_memmultiply = C.SDL_SCANCODE_KP_MEMMULTIPLY // 213
	scancode_kp_memdivide = C.SDL_SCANCODE_KP_MEMDIVIDE // 214
	scancode_kp_plusminus = C.SDL_SCANCODE_KP_PLUSMINUS // 215
	scancode_kp_clear = C.SDL_SCANCODE_KP_CLEAR // 216
	scancode_kp_clearentry = C.SDL_SCANCODE_KP_CLEARENTRY // 217
	scancode_kp_binary = C.SDL_SCANCODE_KP_BINARY // 218
	scancode_kp_octal = C.SDL_SCANCODE_KP_OCTAL // 219
	scancode_kp_decimal = C.SDL_SCANCODE_KP_DECIMAL // 220
	scancode_kp_hexadecimal = C.SDL_SCANCODE_KP_HEXADECIMAL // 221
	//
	scancode_lctrl = C.SDL_SCANCODE_LCTRL // 224
	scancode_lshift = C.SDL_SCANCODE_LSHIFT // 225
	scancode_lalt = C.SDL_SCANCODE_LALT // 226 < alt, option
	scancode_lgui = C.SDL_SCANCODE_LGUI // 227 < windows, command (apple), meta
	scancode_rctrl = C.SDL_SCANCODE_RCTRL // 228
	scancode_rshift = C.SDL_SCANCODE_RSHIFT // 229
	scancode_ralt = C.SDL_SCANCODE_RALT // 230 < alt gr, option
	scancode_rgui = C.SDL_SCANCODE_RGUI // 231 < windows, command (apple), meta
	//
	// I'm not sure if this is really not covered
	// by any of the above, but since there's a
	// special KMOD_MODE for it I'm adding it here
	scancode_mode = C.SDL_SCANCODE_MODE // 257
	// I'm not sure if this is really not covered
	// by any of the above, but since there's a
	// special KMOD_MODE for it I'm adding it here
	scancode_audionext = C.SDL_SCANCODE_AUDIONEXT // 258
	scancode_audioprev = C.SDL_SCANCODE_AUDIOPREV // 259
	scancode_audiostop = C.SDL_SCANCODE_AUDIOSTOP // 260
	scancode_audioplay = C.SDL_SCANCODE_AUDIOPLAY // 261
	scancode_audiomute = C.SDL_SCANCODE_AUDIOMUTE // 262
	scancode_mediaselect = C.SDL_SCANCODE_MEDIASELECT // 263
	scancode_www = C.SDL_SCANCODE_WWW // 264
	scancode_mail = C.SDL_SCANCODE_MAIL // 265
	scancode_calculator = C.SDL_SCANCODE_CALCULATOR // 266
	scancode_computer = C.SDL_SCANCODE_COMPUTER // 267
	scancode_ac_search = C.SDL_SCANCODE_AC_SEARCH // 268
	scancode_ac_home = C.SDL_SCANCODE_AC_HOME // 269
	scancode_ac_back = C.SDL_SCANCODE_AC_BACK // 270
	scancode_ac_forward = C.SDL_SCANCODE_AC_FORWARD // 271
	scancode_ac_stop = C.SDL_SCANCODE_AC_STOP // 272
	scancode_ac_refresh = C.SDL_SCANCODE_AC_REFRESH // 273
	scancode_ac_bookmarks = C.SDL_SCANCODE_AC_BOOKMARKS // 274
	// Walther keys
	//
	// These are values that Christian Walther added (for mac keyboard?).
	scancode_brightnessdown = C.SDL_SCANCODE_BRIGHTNESSDOWN // 275
	scancode_brightnessup = C.SDL_SCANCODE_BRIGHTNESSUP // 276
	// display mirroring/dual display
	// switch, video mode switch
	scancode_displayswitch = C.SDL_SCANCODE_DISPLAYSWITCH // 277
	scancode_kbdillumtoggle = C.SDL_SCANCODE_KBDILLUMTOGGLE // 278
	scancode_kbdillumdown = C.SDL_SCANCODE_KBDILLUMDOWN // 279
	scancode_kbdillumup = C.SDL_SCANCODE_KBDILLUMUP // 280
	scancode_eject = C.SDL_SCANCODE_EJECT // 281
	scancode_sleep = C.SDL_SCANCODE_SLEEP // 282
	//
	scancode_app1 = C.SDL_SCANCODE_APP1 // 283
	scancode_app2 = C.SDL_SCANCODE_APP2 // 284
	//
	// Usage page 0x0C (additional media keys)
	//
	// These values are mapped from usage page 0x0C (USB consumer page).
	scancode_audiorewind = C.SDL_SCANCODE_AUDIOREWIND // 285
	scancode_audiofastforward = C.SDL_SCANCODE_AUDIOFASTFORWARD // 286
	// Add any other keys here.
	num_scancodes = C.SDL_NUM_SCANCODES // 512
}
