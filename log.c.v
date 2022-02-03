// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

pub const (
	max_log_message = C.SDL_MAX_LOG_MESSAGE // 4096
)

// LogOutputFunction is the prototype for the log output function
// C.SDL_LogOutputFunction
// `typedef void (SDLCALL *SDL_LogOutputFunction)(void *userdata, int category, SDL_LogPriority priority, const char *message);`
pub type LogOutputFunction = fn (userdata voidptr, category int, priority LogPriority, const_message &char)

// LogCategory is the predefined log categories
//
// By default the application category is enabled at the INFO level,
// the assert category is enabled at the WARN level, test is enabled
// at the VERBOSE level and all other categories are enabled at the
// CRITICAL level.
//
// LogCategory is C.SDL_LogCategory
pub enum LogCategory {
	application = C.SDL_LOG_CATEGORY_APPLICATION
	error = C.SDL_LOG_CATEGORY_ERROR
	@assert = C.SDL_LOG_CATEGORY_ASSERT
	system = C.SDL_LOG_CATEGORY_SYSTEM
	audio = C.SDL_LOG_CATEGORY_AUDIO
	video = C.SDL_LOG_CATEGORY_VIDEO
	render = C.SDL_LOG_CATEGORY_RENDER
	input = C.SDL_LOG_CATEGORY_INPUT
	test = C.SDL_LOG_CATEGORY_TEST
	// Reserved for future SDL library use
	reserved1 = C.SDL_LOG_CATEGORY_RESERVED1
	reserved2 = C.SDL_LOG_CATEGORY_RESERVED2
	reserved3 = C.SDL_LOG_CATEGORY_RESERVED3
	reserved4 = C.SDL_LOG_CATEGORY_RESERVED4
	reserved5 = C.SDL_LOG_CATEGORY_RESERVED5
	reserved6 = C.SDL_LOG_CATEGORY_RESERVED6
	reserved7 = C.SDL_LOG_CATEGORY_RESERVED7
	reserved8 = C.SDL_LOG_CATEGORY_RESERVED8
	reserved9 = C.SDL_LOG_CATEGORY_RESERVED9
	reserved10 = C.SDL_LOG_CATEGORY_RESERVED10
	// Beyond this point is reserved for application use, e.g.
	//   enum {
	//       MYAPP_CATEGORY_AWESOME1 = SDL_LOG_CATEGORY_CUSTOM,
	//       MYAPP_CATEGORY_AWESOME2,
	//       MYAPP_CATEGORY_AWESOME3,
	//       ...
	//   };
	//
	custom = C.SDL_LOG_CATEGORY_CUSTOM
}

// LogPriority is C.SDL_LogPriority
pub enum LogPriority {
	verbose = C.SDL_LOG_PRIORITY_VERBOSE // 1
	debug = C.SDL_LOG_PRIORITY_DEBUG
	info = C.SDL_LOG_PRIORITY_INFO
	warn = C.SDL_LOG_PRIORITY_WARN
	error = C.SDL_LOG_PRIORITY_ERROR
	critical = C.SDL_LOG_PRIORITY_CRITICAL
	num_log_priorities = C.SDL_NUM_LOG_PRIORITIES
}

fn C.SDL_LogSetAllPriority(priority C.SDL_LogPriority)

// log_set_all_priority sets the priority of all log categories
pub fn log_set_all_priority(priority LogPriority) {
	C.SDL_LogSetAllPriority(C.SDL_LogPriority(int(priority)))
}

fn C.SDL_LogSetPriority(category int, priority C.SDL_LogPriority)

// log_set_priority sets the priority of a particular log category
pub fn log_set_priority(category int, priority LogPriority) {
	C.SDL_LogSetPriority(category, C.SDL_LogPriority(int(priority)))
}

fn C.SDL_LogGetPriority(category int) C.SDL_LogPriority

// log_get_priority gets the priority of a particular log category
pub fn log_get_priority(category int) LogPriority {
	return LogPriority(int(C.SDL_LogGetPriority(category)))
}

fn C.SDL_LogResetPriorities()

// log_reset_priorities resets all priorities to default.
//
// NOTE This is called in SDL_Quit().
pub fn log_reset_priorities() {
	C.SDL_LogResetPriorities()
}

// Skipped:
// extern DECLSPEC void SDLCALL SDL_Log(SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(1);
// extern DECLSPEC void SDLCALL SDL_LogVerbose(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);
// extern DECLSPEC void SDLCALL SDL_LogDebug(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);
// extern DECLSPEC void SDLCALL SDL_LogInfo(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);
// extern DECLSPEC void SDLCALL SDL_LogWarn(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);
// extern DECLSPEC void SDLCALL SDL_LogError(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);
// extern DECLSPEC void SDLCALL SDL_LogCritical(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);
// extern DECLSPEC void SDLCALL SDL_LogMessage(int category, SDL_LogPriority priority, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(3);

fn C.SDL_LogMessageV(category int, priority C.SDL_LogPriority, const_fmt &char, ap C.va_list)

// log_message_v logs a message with the specified category and priority.
pub fn log_message_v(category int, priority LogPriority, const_fmt &char, ap C.va_list) {
	C.SDL_LogMessageV(category, C.SDL_LogPriority(priority), const_fmt, ap)
}

fn C.SDL_LogGetOutputFunction(callback &LogOutputFunction, userdata voidptr)

// log_get_output_function get the current log output function.
// NOTE `userdata` is `**`
pub fn log_get_output_function(callback &LogOutputFunction, userdata voidptr) {
	C.SDL_LogGetOutputFunction(callback, userdata)
}

fn C.SDL_LogSetOutputFunction(callback LogOutputFunction, userdata voidptr)

// log_set_output_function allows you to replace the default log output
// function with one of your own.
pub fn log_set_output_function(callback LogOutputFunction, userdata voidptr) {
	C.SDL_LogSetOutputFunction(callback, userdata)
}
