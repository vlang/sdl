// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_locale.h
//

// SDL locale services.
//
// This provides a way to get a list of preferred locales (language plus
// country) for the user. There is exactly one function:
// SDL_GetPreferredLocales(), which handles all the heavy lifting, and offers
// documentation on all the strange ways humans might have configured their
// language settings.

// TODO: Non-numerical: #define SDL_locale_h

@[typedef]
pub struct C.SDL_Locale {
pub mut:
	language &char = unsafe { nil } // A language name, like "en" for English.
	country  &char = unsafe { nil } // A country, like "US" for America. Can be NULL.
}

pub type Locale = C.SDL_Locale

// C.SDL_GetPreferredLocales [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPreferredLocales)
fn C.SDL_GetPreferredLocales(count &int) &&C.SDL_Locale

// get_preferred_locales reports the user's preferred locale.
//
// Returned language strings are in the format xx, where 'xx' is an ISO-639
// language specifier (such as "en" for English, "de" for German, etc).
// Country strings are in the format YY, where "YY" is an ISO-3166 country
// code (such as "US" for the United States, "CA" for Canada, etc). Country
// might be NULL if there's no specific guidance on them (so you might get {
// "en", "US" } for American English, but { "en", NULL } means "English
// language, generically"). Language strings are never NULL, except to
// terminate the array.
//
// Please note that not all of these strings are 2 characters; some are three
// or more.
//
// The returned list of locales are in the order of the user's preference. For
// example, a German citizen that is fluent in US English and knows enough
// Japanese to navigate around Tokyo might have a list like: { "de", "en_US",
// "jp", NULL }. Someone from England might prefer British English (where
// "color" is spelled "colour", etc), but will settle for anything like it: {
// "en_GB", "en", NULL }.
//
// This function returns NULL on error, including when the platform does not
// supply this information at all.
//
// This might be a "slow" call that has to query the operating system. It's
// best to ask for this once and save the results. However, this list can
// change, usually because the user has changed a system preference outside of
// your program; SDL will send an SDL_EVENT_LOCALE_CHANGED event in this case,
// if possible, and you can call this function again to get an updated copy of
// preferred locales.
//
// `count` count a pointer filled in with the number of locales returned, may
//              be NULL.
// returns a NULL terminated array of locale pointers, or NULL on failure;
//          call SDL_GetError() for more information. This is a single
//          allocation that should be freed with SDL_free() when it is no
//          longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_preferred_locales(count &int) &&C.SDL_Locale {
	return C.SDL_GetPreferredLocales(count)
}
