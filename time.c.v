// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_time.h
//

// SDL realtime clock and date/time routines.
//
// There are two data types that are used in this category: SDL_Time, which
// represents the nanoseconds since a specific moment (an "epoch"), and
// SDL_DateTime, which breaks time down into human-understandable components:
// years, months, days, hours, etc.
//
// Much of the functionality is involved in converting those two types to
// other useful forms.

@[typedef]
pub struct C.SDL_DateTime {
pub mut:
	year        int // Year
	month       int // Month [01-12]
	day         int // Day of the month [01-31]
	hour        int // Hour [0-23]
	minute      int // Minute [0-59]
	second      int // Seconds [0-60]
	nanosecond  int // Nanoseconds [0-999999999]
	day_of_week int // Day of the week [0-6] (0 being Sunday)
	utc_offset  int // Seconds east of UTC
}

pub type DateTime = C.SDL_DateTime

// DateFormat is C.SDL_DateFormat
pub enum DateFormat {
	yyyymmdd = C.SDL_DATE_FORMAT_YYYYMMDD // 0, Year/Month/Day
	ddmmyyyy = C.SDL_DATE_FORMAT_DDMMYYYY // 1, Day/Month/Year
	mmddyyyy = C.SDL_DATE_FORMAT_MMDDYYYY // 2, Month/Day/Year
}

// TimeFormat is C.SDL_TimeFormat
pub enum TimeFormat {
	_24hr = C.SDL_TIME_FORMAT_24HR // 0, 24 hour time
	_12hr = C.SDL_TIME_FORMAT_12HR // 1, 12 hour time
}

// C.SDL_GetDateTimeLocalePreferences [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDateTimeLocalePreferences)
fn C.SDL_GetDateTimeLocalePreferences(date_format &DateFormat, time_format &TimeFormat) bool

// get_date_time_locale_preferences gets the current preferred date and time format for the system locale.
//
// This might be a "slow" call that has to query the operating system. It's
// best to ask for this once and save the results. However, the preferred
// formats can change, usually because the user has changed a system
// preference outside of your program.
//
// `date_format` dateFormat a pointer to the SDL_DateFormat to hold the returned date
//                   format, may be NULL.
// `time_format` timeFormat a pointer to the SDL_TimeFormat to hold the returned time
//                   format, may be NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_date_time_locale_preferences(date_format &DateFormat, time_format &TimeFormat) bool {
	return C.SDL_GetDateTimeLocalePreferences(&date_format, &time_format)
}

// C.SDL_GetCurrentTime [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCurrentTime)
fn C.SDL_GetCurrentTime(ticks Time) bool

// get_current_time gets the current value of the system realtime clock in nanoseconds since
// Jan 1, 1970 in Universal Coordinated Time (UTC).
//
// `ticks` ticks the SDL_Time to hold the returned tick count.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_current_time(ticks Time) bool {
	return C.SDL_GetCurrentTime(ticks)
}

// C.SDL_TimeToDateTime [official documentation](https://wiki.libsdl.org/SDL3/SDL_TimeToDateTime)
fn C.SDL_TimeToDateTime(ticks Time, dt &DateTime, local_time bool) bool

// time_to_date_time converts an SDL_Time in nanoseconds since the epoch to a calendar time in
// the SDL_DateTime format.
//
// `ticks` ticks the SDL_Time to be converted.
// `dt` dt the resulting SDL_DateTime.
// `local_time` localTime the resulting SDL_DateTime will be expressed in local time
//                  if true, otherwise it will be in Universal Coordinated
//                  Time (UTC).
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn time_to_date_time(ticks Time, dt &DateTime, local_time bool) bool {
	return C.SDL_TimeToDateTime(ticks, dt, local_time)
}

// C.SDL_DateTimeToTime [official documentation](https://wiki.libsdl.org/SDL3/SDL_DateTimeToTime)
fn C.SDL_DateTimeToTime(const_dt &DateTime, ticks Time) bool

// date_time_to_time converts a calendar time to an SDL_Time in nanoseconds since the epoch.
//
// This function ignores the day_of_week member of the SDL_DateTime struct, so
// it may remain unset.
//
// `dt` dt the source SDL_DateTime.
// `ticks` ticks the resulting SDL_Time.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn date_time_to_time(const_dt &DateTime, ticks Time) bool {
	return C.SDL_DateTimeToTime(const_dt, ticks)
}

// C.SDL_TimeToWindows [official documentation](https://wiki.libsdl.org/SDL3/SDL_TimeToWindows)
fn C.SDL_TimeToWindows(ticks Time, dw_low_date_time &u32, dw_high_date_time &u32)

// time_to_windows converts an SDL time into a Windows FILETIME (100-nanosecond intervals
// since January 1, 1601).
//
// This function fills in the two 32-bit values of the FILETIME structure.
//
// `ticks` ticks the time to convert.
// `dw_low_date_time` dwLowDateTime a pointer filled in with the low portion of the
//                      Windows FILETIME value.
// `dw_high_date_time` dwHighDateTime a pointer filled in with the high portion of the
//                       Windows FILETIME value.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn time_to_windows(ticks Time, dw_low_date_time &u32, dw_high_date_time &u32) {
	C.SDL_TimeToWindows(ticks, dw_low_date_time, dw_high_date_time)
}

// C.SDL_TimeFromWindows [official documentation](https://wiki.libsdl.org/SDL3/SDL_TimeFromWindows)
fn C.SDL_TimeFromWindows(dw_low_date_time u32, dw_high_date_time u32) Time

// time_from_windows converts a Windows FILETIME (100-nanosecond intervals since January 1,
// 1601) to an SDL time.
//
// This function takes the two 32-bit values of the FILETIME structure as
// parameters.
//
// `dw_low_date_time` dwLowDateTime the low portion of the Windows FILETIME value.
// `dw_high_date_time` dwHighDateTime the high portion of the Windows FILETIME value.
// returns the converted SDL time.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn time_from_windows(dw_low_date_time u32, dw_high_date_time u32) Time {
	return C.SDL_TimeFromWindows(dw_low_date_time, dw_high_date_time)
}

// C.SDL_GetDaysInMonth [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDaysInMonth)
fn C.SDL_GetDaysInMonth(year int, month int) int

// get_days_in_month gets the number of days in a month for a given year.
//
// `year` year the year.
// `month` month the month [1-12].
// returns the number of days in the requested month or -1 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_days_in_month(year int, month int) int {
	return C.SDL_GetDaysInMonth(year, month)
}

// C.SDL_GetDayOfYear [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDayOfYear)
fn C.SDL_GetDayOfYear(year int, month int, day int) int

// get_day_of_year gets the day of year for a calendar date.
//
// `year` year the year component of the date.
// `month` month the month component of the date.
// `day` day the day component of the date.
// returns the day of year [0-365] if the date is valid or -1 on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_day_of_year(year int, month int, day int) int {
	return C.SDL_GetDayOfYear(year, month, day)
}

// C.SDL_GetDayOfWeek [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDayOfWeek)
fn C.SDL_GetDayOfWeek(year int, month int, day int) int

// get_day_of_week gets the day of week for a calendar date.
//
// `year` year the year component of the date.
// `month` month the month component of the date.
// `day` day the day component of the date.
// returns a value between 0 and 6 (0 being Sunday) if the date is valid or
//          -1 on failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_day_of_week(year int, month int, day int) int {
	return C.SDL_GetDayOfWeek(year, month, day)
}
