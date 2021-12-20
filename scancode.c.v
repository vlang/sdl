// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_scancode.h
//

/**
 *  \brief The SDL keyboard scancode representation.
 *
 *  Values of this type are used to represent keyboard keys, among other places
 *  in the \link SDL_Keysym::scancode key.keysym.scancode \endlink field of the
 *  SDL_Event structure.
 *
 *  The values in this enumeration are based on the USB usage page standard:
 *  http://www.usb.org/developers/hidpage/Hut1_12v2.pdf
*/
// Scancode is C.SDL_Scancode
pub enum Scancode {
	scancode_unknown = 0 // 0
	// \name Usage page 0x07
	//
	// These values are from usage page 0x07 (USB keyboard page).
	//
	scancode_a = 4 // 4
	scancode_b = 5 // 5
	scancode_c = 6 // 6
	scancode_d = 7 // 7
	scancode_e = 8 // 8
	scancode_f = 9 // 9
	scancode_g = 10 // 10
	scancode_h = 11 // 11
	scancode_i = 12 // 12
	scancode_j = 13 // 13
	scancode_k = 14 // 14
	scancode_l = 15 // 15
	scancode_m = 16 // 16
	scancode_n = 17 // 17
	scancode_o = 18 // 18
	scancode_p = 19 // 19
	scancode_q = 20 // 20
	scancode_r = 21 // 21
	scancode_s = 22 // 22
	scancode_t = 23 // 23
	scancode_u = 24 // 24
	scancode_v = 25 // 25
	scancode_w = 26 // 26
	scancode_x = 27 // 27
	scancode_y = 28 // 28
	scancode_z = 29 // 29
	//
	scancode_1 = 30 // 30
	scancode_2 = 31 // 31
	scancode_3 = 32 // 32
	scancode_4 = 33 // 33
	scancode_5 = 34 // 34
	scancode_6 = 35 // 35
	scancode_7 = 36 // 36
	scancode_8 = 37 // 37
	scancode_9 = 38 // 38
	scancode_0 = 39 // 39
	//
	scancode_return = 40 // 40
	scancode_escape = 41 // 41
	scancode_backspace = 42 // 42
	scancode_tab = 43 // 43
	scancode_space = 44 // 44
	//
	scancode_minus = 45 // 45
	scancode_equals = 46 // 46
	scancode_leftbracket = 47 // 47
	scancode_rightbracket = 48 // 48
	/*
	Located at the lower left of the return
	*  key on ISO keyboards and at the right end
	*  of the QWERTY row on ANSI keyboards.
	*  Produces REVERSE SOLIDUS (backslash) and
	*  VERTICAL LINE in a US layout, REVERSE
	*  SOLIDUS and VERTICAL LINE in a UK Mac
	*  layout, NUMBER SIGN and TILDE in a UK
	*  Windows layout, DOLLAR SIGN and POUND SIGN
	*  in a Swiss German layout, NUMBER SIGN and
	*  APOSTROPHE in a German layout, GRAVE
	*  ACCENT and POUND SIGN in a French Mac
	*  layout, and ASTERISK and MICRO SIGN in a
	*  French Windows layout.
	*/
	scancode_backslash = 49 // 49
	/*
	*   ISO USB keyboards actually use this code
	*   instead of 49 for the same key, but all
	*   OSes I've seen treat the two codes
	*   identically. So, as an implementor, unless
	*   your keyboard generates both of those
	*   codes and your OS treats them differently,
	*   you should generate SDL_SCANCODE_BACKSLASH
	*   instead of this code. As a user, you
	*   should not rely on this code because SDL
	*   will never generate it with most (all?)
	*   keyboards.
	*/
	scancode_nonushash = 50 // 50
	scancode_semicolon = 51 // 51
	scancode_apostrophe = 52 // 52
	/*
	Located in the top left corner (on both ANSI
	*   and ISO keyboards). Produces GRAVE ACCENT and
	*   TILDE in a US Windows layout and in US and UK
	*   Mac layouts on ANSI keyboards, GRAVE ACCENT
	*   and NOT SIGN in a UK Windows layout, SECTION
	*   SIGN and PLUS-MINUS SIGN in US and UK Mac
	*   layouts on ISO keyboards, SECTION SIGN and
	*   DEGREE SIGN in a Swiss German layout (Mac:
	*   only on ISO keyboards), CIRCUMFLEX ACCENT and
	*   DEGREE SIGN in a German layout (Mac: only on
	*   ISO keyboards), SUPERSCRIPT TWO and TILDE in a
	*   French Windows layout, COMMERCIAL AT and
	*   NUMBER SIGN in a French Mac layout on ISO
	*   keyboards, and LESS-THAN SIGN and GREATER-THAN
	*   SIGN in a Swiss German, German, or French Mac
	*   layout on ANSI keyboards.
	*/
	scancode_grave = 53
	//
	scancode_comma = 54 // 54
	scancode_period = 55 // 55
	scancode_slash = 56 // 56
	//
	scancode_capslock = 57 // 57
	//
	scancode_f1 = 58 // 58
	scancode_f2 = 59 // 59
	scancode_f3 = 60 // 60
	scancode_f4 = 61 // 61
	scancode_f5 = 62 // 62
	scancode_f6 = 63 // 63
	scancode_f7 = 64 // 64
	scancode_f8 = 65 // 65
	scancode_f9 = 66 // 66
	scancode_f10 = 67 // 67
	scancode_f11 = 68 // 68
	scancode_f12 = 69 // 69
	//
	scancode_printscreen = 70 // 70
	scancode_scrolllock = 71 // 71
	scancode_pause = 72 // 72
	// insert on PC, help on some Mac keyboards (but does send code 73, not 117)
	scancode_insert = 73
	//
	scancode_home = 74 // 74
	scancode_pageup = 75 // 75
	scancode_delete = 76 // 76
	scancode_end = 77 // 77
	scancode_pagedown = 78 // 78
	scancode_right = 79 // 79
	scancode_left = 80 // 80
	scancode_down = 81 // 81
	scancode_up = 82 // 82
	//
	scancode_numlockclear = 83 // 83 num lock on PC, clear on Mac keyboards
	//
	scancode_kp_divide = 84 // 84
	scancode_kp_multiply = 85 // 85
	scancode_kp_minus = 86 // 86
	scancode_kp_plus = 87 // 87
	scancode_kp_enter = 88 // 88
	scancode_kp_1 = 89 // 89
	scancode_kp_2 = 90 // 90
	scancode_kp_3 = 91 // 91
	scancode_kp_4 = 92 // 92
	scancode_kp_5 = 93 // 93
	scancode_kp_6 = 94 // 94
	scancode_kp_7 = 95 // 95
	scancode_kp_8 = 96 // 96
	scancode_kp_9 = 97 // 97
	scancode_kp_0 = 98 // 98
	scancode_kp_period = 99 // 99
	//
	/*
	* This is the additional key that ISO
	*   keyboards have over ANSI ones,
	*   located between left shift and Y.
	*   Produces GRAVE ACCENT and TILDE in a
	*   US or UK Mac layout, REVERSE SOLIDUS
	*   (backslash) and VERTICAL LINE in a
	*   US or UK Windows layout, and
	*   LESS-THAN SIGN and GREATER-THAN SIGN
	*   in a Swiss German, German, or French
	*   layout.
	*/
	scancode_nonusbackslash = 100 // 100
	//
	scancode_application = 101 // windows contextual menu, compose
	/*
	* The USB document says this is a status flag,
	* not a physical key - but some Mac keyboards
	* do have a power key.
	*/
	scancode_power = 102
	//
	scancode_kp_equals = 103 // 103
	scancode_f13 = 104 // 104
	scancode_f14 = 105 // 105
	scancode_f15 = 106 // 106
	scancode_f16 = 107 // 107
	scancode_f17 = 108 // 108
	scancode_f18 = 109 // 109
	scancode_f19 = 110 // 110
	scancode_f20 = 111 // 111
	scancode_f21 = 112 // 112
	scancode_f22 = 113 // 113
	scancode_f23 = 114 // 114
	scancode_f24 = 115 // 115
	scancode_execute = 116 // 116
	scancode_help = 117 // 117
	scancode_menu = 118 // 118
	scancode_select = 119 // 119
	scancode_stop = 120 // 120
	scancode_again = 121 // 121/**< redo */
	scancode_undo = 122 // 122
	scancode_cut = 123 // 123
	scancode_copy = 124 // 124
	scancode_paste = 125 // 125
	scancode_find = 126 // 126
	scancode_mute = 127 // 127
	scancode_volumeup = 128 // 128
	scancode_volumedown = 129 // 129
	//
	scancode_kp_comma = 133 // 133
	scancode_kp_equalsas400 = 134 // 134
	scancode_international1 = 135 // 135 used on Asian keyboards, see footnotes in USB doc
	scancode_international2 = 136 // 136
	scancode_international3 = 137 // 137 Yen
	scancode_international4 = 138 // 138
	scancode_international5 = 139 // 139
	scancode_international6 = 140 // 140
	scancode_international7 = 141 // 141
	scancode_international8 = 142 // 142
	scancode_international9 = 143 // 143
	scancode_lang1 = 144 // 144 Hangul/English toggle
	scancode_lang2 = 145 // 145 Hanja conversion
	scancode_lang3 = 146 // 146 Katakana
	scancode_lang4 = 147 // 147 Hiragana
	scancode_lang5 = 148 // 148 Zenkaku/Hankaku
	scancode_lang6 = 149 // 149 reserved
	scancode_lang7 = 150 // 150 reserved
	scancode_lang8 = 151 // 151 reserved
	scancode_lang9 = 152 // 152 reserved
	//
	scancode_alterase = 153 // 153 Erase-Eaze
	scancode_sysreq = 154 // 154
	scancode_cancel = 155 // 155
	scancode_clear = 156 // 156
	scancode_prior = 157 // 157
	scancode_return2 = 158 // 158
	scancode_separator = 159 // 159
	scancode_out = 160 // 160
	scancode_oper = 161 // 161
	scancode_clearagain = 162 // 162
	scancode_crsel = 163 // 163
	scancode_exsel = 164 // 164
	scancode_kp_00 = 176 // 176
	scancode_kp_000 = 177 // 177
	scancode_thousandsseparator = 178 // 178
	scancode_decimalseparator = 179 // 179
	scancode_currencyunit = 180 // 180
	scancode_currencysubunit = 181 // 181
	scancode_kp_leftparen = 182 // 182
	scancode_kp_rightparen = 183 // 183
	scancode_kp_leftbrace = 184 // 184
	scancode_kp_rightbrace = 185 // 185
	scancode_kp_tab = 186 // 186
	scancode_kp_backspace = 187 // 187
	scancode_kp_a = 188 // 188
	scancode_kp_b = 189 // 189
	scancode_kp_c = 190 // 190
	scancode_kp_d = 191 // 191
	scancode_kp_e = 192 // 192
	scancode_kp_f = 193 // 193
	scancode_kp_xor = 194 // 194
	scancode_kp_power = 195 // 195
	scancode_kp_percent = 196 // 196
	scancode_kp_less = 197 // 197
	scancode_kp_greater = 198 // 198
	scancode_kp_ampersand = 199 // 199
	scancode_kp_dblampersand = 200 // 200
	scancode_kp_verticalbar = 201 // 201
	scancode_kp_dblverticalbar = 202 // 202
	scancode_kp_colon = 203 // 203
	scancode_kp_hash = 204 // 204
	scancode_kp_space = 205 // 205
	scancode_kp_at = 206 // 206
	scancode_kp_exclam = 207 // 207
	scancode_kp_memstore = 208 // 208
	scancode_kp_memrecall = 209 // 209
	scancode_kp_memclear = 210 // 210
	scancode_kp_memadd = 211 // 211
	scancode_kp_memsubtract = 212 // 212
	scancode_kp_memmultiply = 213 // 213
	scancode_kp_memdivide = 214 // 214
	scancode_kp_plusminus = 215 // 215
	scancode_kp_clear = 216 // 216
	scancode_kp_clearentry = 217 // 217
	scancode_kp_binary = 218 // 218
	scancode_kp_octal = 219 // 219
	scancode_kp_decimal = 220 // 220
	scancode_kp_hexadecimal = 221 // 221
	//
	scancode_lctrl = 224 // 224
	scancode_lshift = 225 // 225
	scancode_lalt = 226 // 226 /**< alt, option */
	scancode_lgui = 227 // 227 /**< windows, command (apple), meta */
	scancode_rctrl = 228 // 228
	scancode_rshift = 229 // 229
	scancode_ralt = 230 // 230 /**< alt gr, option */
	scancode_rgui = 231 // 231 /**< windows, command (apple), meta */
	//
	/*
	* I'm not sure if this is really not covered
	*   by any of the above, but since there's a
	*   special KMOD_MODE for it I'm adding it here
	*/
	scancode_mode = 257 // 257
	/*
	I'm not sure if this is really not covered
	*   by any of the above, but since there's a
	*   special KMOD_MODE for it I'm adding it here
	*/
	scancode_audionext = 258 // 258
	scancode_audioprev = 259 // 259
	scancode_audiostop = 260 // 260
	scancode_audioplay = 261 // 261
	scancode_audiomute = 262 // 262
	scancode_mediaselect = 263 // 263
	scancode_www = 264 // 264
	scancode_mail = 265 // 265
	scancode_calculator = 266 // 266
	scancode_computer = 267 // 267
	scancode_ac_search = 268 // 268
	scancode_ac_home = 269 // 269
	scancode_ac_back = 270 // 270
	scancode_ac_forward = 271 // 271
	scancode_ac_stop = 272 // 272
	scancode_ac_refresh = 273 // 273
	scancode_ac_bookmarks = 274 // 274
	/**
     *  \name Walther keys
     *
     *  These are values that Christian Walther added (for mac keyboard?).
	*/
	scancode_brightnessdown = 275 // 275
	scancode_brightnessup = 276 // 276
	/*
	* display mirroring/dual display
     *switch, video mode switch
	*/
	scancode_displayswitch = 277 // 277
	scancode_kbdillumtoggle = 278 // 278
	scancode_kbdillumdown = 279 // 279
	scancode_kbdillumup = 280 // 280
	scancode_eject = 281 // 281
	scancode_sleep = 282 // 282
	//
	scancode_app1 = 283 // 283
	scancode_app2 = 284 // 284
	//
	/**
     *  \name Usage page 0x0C (additional media keys)
     *
     *  These values are mapped from usage page 0x0C (USB consumer page).
	*/
	scancode_audiorewind = 285 // 285
	scancode_audiofastforward = 286 // 286
	// Add any other keys here.
	num_scancodes = 512 // 512
}
