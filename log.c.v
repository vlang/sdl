// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_log.h
//

// Simple log messages with priorities and categories. A message's
// SDL_LogPriority signifies how important the message is. A message's
// SDL_LogCategory signifies from what domain it belongs to. Every category
// has a minimum priority specified: when a message belongs to that category,
// it will only be sent out if it has that minimum priority or higher.
//
// SDL's own logs are sent below the default priority threshold, so they are
// quiet by default.
//
// You can change the log verbosity programmatically using
// SDL_SetLogPriority() or with SDL_SetHint(SDL_HINT_LOGGING, ...), or with
// the "SDL_LOGGING" environment variable. This variable is a comma separated
// set of category=level tokens that define the default logging levels for SDL
// applications.
//
// The category can be a numeric category, one of "app", "error", "assert",
// "system", "audio", "video", "render", "input", "test", or `*` for any
// unspecified category.
//
// The level can be a numeric level, one of "verbose", "debug", "info",
// "warn", "error", "critical", or "quiet" to disable that category.
//
// You can omit the category if you want to set the logging level for all
// categories.
//
// If this hint isn't set, the default log levels are equivalent to:
//
// `app=info,assert=warn,test=verbose,*=error`
//
// Here's where the messages go on different platforms:
//
// - Windows: debug output stream
// - Android: log output
// - Others: standard error output (stderr)
//
// You don't need to have a newline (`\n`) on the end of messages, the
// functions will do that for you. For consistent behavior cross-platform, you
// shouldn't have any newlines in messages, such as to log multiple lines in
// one call; unusual platform-specific behavior can be observed in such usage.
// Do one log call per line instead, with no newlines in messages.
//
// Each log call is atomic, so you won't see log messages cut off one another
// when logging from multiple threads.

// LogCategory is C.SDL_LogCategory
pub enum LogCategory {
	application = C.SDL_LOG_CATEGORY_APPLICATION
	error       = C.SDL_LOG_CATEGORY_ERROR
	@assert     = C.SDL_LOG_CATEGORY_ASSERT
	system      = C.SDL_LOG_CATEGORY_SYSTEM
	audio       = C.SDL_LOG_CATEGORY_AUDIO
	video       = C.SDL_LOG_CATEGORY_VIDEO
	render      = C.SDL_LOG_CATEGORY_RENDER
	input       = C.SDL_LOG_CATEGORY_INPUT
	test        = C.SDL_LOG_CATEGORY_TEST
	gpu         = C.SDL_LOG_CATEGORY_GPU
	// Reserved for future SDL library use
	reserved2  = C.SDL_LOG_CATEGORY_RESERVED2
	reserved3  = C.SDL_LOG_CATEGORY_RESERVED3
	reserved4  = C.SDL_LOG_CATEGORY_RESERVED4
	reserved5  = C.SDL_LOG_CATEGORY_RESERVED5
	reserved6  = C.SDL_LOG_CATEGORY_RESERVED6
	reserved7  = C.SDL_LOG_CATEGORY_RESERVED7
	reserved8  = C.SDL_LOG_CATEGORY_RESERVED8
	reserved9  = C.SDL_LOG_CATEGORY_RESERVED9
	reserved10 = C.SDL_LOG_CATEGORY_RESERVED10
	// Beyond this point is reserved for application use, e.g.
	// enum {
	// MYAPP_CATEGORY_AWESOME1 = SDL_LOG_CATEGORY_CUSTOM,
	// MYAPP_CATEGORY_AWESOME2,
	// MYAPP_CATEGORY_AWESOME3,
	// ...
	// };
	//
	custom = C.SDL_LOG_CATEGORY_CUSTOM
}

// LogPriority is C.SDL_LogPriority
pub enum LogPriority {
	invalid  = C.SDL_LOG_PRIORITY_INVALID
	trace    = C.SDL_LOG_PRIORITY_TRACE
	verbose  = C.SDL_LOG_PRIORITY_VERBOSE
	debug    = C.SDL_LOG_PRIORITY_DEBUG
	info     = C.SDL_LOG_PRIORITY_INFO
	warn     = C.SDL_LOG_PRIORITY_WARN
	error    = C.SDL_LOG_PRIORITY_ERROR
	critical = C.SDL_LOG_PRIORITY_CRITICAL
	count    = C.SDL_LOG_PRIORITY_COUNT
}

// C.SDL_SetLogPriorities [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetLogPriorities)
fn C.SDL_SetLogPriorities(priority LogPriority)

// set_log_priorities sets the priority of all log categories.
//
// `priority` priority the SDL_LogPriority to assign.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: reset_log_priorities (SDL_ResetLogPriorities)
// See also: set_log_priority (SDL_SetLogPriority)
pub fn set_log_priorities(priority LogPriority) {
	C.SDL_SetLogPriorities(priority)
}

// C.SDL_SetLogPriority [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetLogPriority)
fn C.SDL_SetLogPriority(category int, priority LogPriority)

// set_log_priority sets the priority of a particular log category.
//
// `category` category the category to assign a priority to.
// `priority` priority the SDL_LogPriority to assign.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_log_priority (SDL_GetLogPriority)
// See also: reset_log_priorities (SDL_ResetLogPriorities)
// See also: set_log_priorities (SDL_SetLogPriorities)
pub fn set_log_priority(category int, priority LogPriority) {
	C.SDL_SetLogPriority(category, priority)
}

// C.SDL_GetLogPriority [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetLogPriority)
fn C.SDL_GetLogPriority(category int) LogPriority

// get_log_priority gets the priority of a particular log category.
//
// `category` category the category to query.
// returns the SDL_LogPriority for the requested category.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_log_priority (SDL_SetLogPriority)
pub fn get_log_priority(category int) LogPriority {
	return C.SDL_GetLogPriority(category)
}

// C.SDL_ResetLogPriorities [official documentation](https://wiki.libsdl.org/SDL3/SDL_ResetLogPriorities)
fn C.SDL_ResetLogPriorities()

// reset_log_priorities resets all priorities to default.
//
// This is called by SDL_Quit().
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_log_priorities (SDL_SetLogPriorities)
// See also: set_log_priority (SDL_SetLogPriority)
pub fn reset_log_priorities() {
	C.SDL_ResetLogPriorities()
}

// C.SDL_SetLogPriorityPrefix [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetLogPriorityPrefix)
fn C.SDL_SetLogPriorityPrefix(priority LogPriority, const_prefix &char) bool

// set_log_priority_prefix sets the text prepended to log messages of a given priority.
//
// By default SDL_LOG_PRIORITY_INFO and below have no prefix, and
// SDL_LOG_PRIORITY_WARN and higher have a prefix showing their priority, e.g.
// "WARNING: ".
//
// `priority` priority the SDL_LogPriority to modify.
// `prefix` prefix the prefix to use for that log priority, or NULL to use no
//               prefix.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_log_priorities (SDL_SetLogPriorities)
// See also: set_log_priority (SDL_SetLogPriority)
pub fn set_log_priority_prefix(priority LogPriority, const_prefix &char) bool {
	return C.SDL_SetLogPriorityPrefix(priority, const_prefix)
}

// TODO: extern SDL_DECLSPEC void SDLCALL SDL_Log(SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(1);

// log logs a message with SDL_LOG_CATEGORY_APPLICATION and SDL_LOG_PRIORITY_INFO.
//
// `fmt` fmt a printf() style message format string.
// `...` ... additional parameters matching % tokens in the `fmt` string, if
//            any.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log_critical (SDL_LogCritical)
// See also: log_debug (SDL_LogDebug)
// See also: log_error (SDL_LogError)
// See also: log_info (SDL_LogInfo)
// See also: log_message (SDL_LogMessage)
// See also: log_message_v (SDL_LogMessageV)
// See also: log_trace (SDL_LogTrace)
// See also: log_verbose (SDL_LogVerbose)
// See also: log_warn (SDL_LogWarn)
//
// TODO: log_info(const_fmt &char, ...) {}

// TODO: extern SDL_DECLSPEC void SDLCALL SDL_LogTrace(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);

// log_trace logs a message with SDL_LOG_PRIORITY_TRACE.
//
// `category` category the category of the message.
// `fmt` fmt a printf() style message format string.
// `...` ... additional parameters matching % tokens in the **fmt** string,
//            if any.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log (SDL_Log)
// See also: log_critical (SDL_LogCritical)
// See also: log_debug (SDL_LogDebug)
// See also: log_error (SDL_LogError)
// See also: log_info (SDL_LogInfo)
// See also: log_message (SDL_LogMessage)
// See also: log_message_v (SDL_LogMessageV)
// See also: log_trace (SDL_LogTrace)
// See also: log_verbose (SDL_LogVerbose)
// See also: log_warn (SDL_LogWarn)
//
// TODO: log_trace(category int, const_fmt &char, ...) {}

// TODO: extern SDL_DECLSPEC void SDLCALL SDL_LogVerbose(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);

// log_verbose logs a message with SDL_LOG_PRIORITY_VERBOSE.
//
// `category` category the category of the message.
// `fmt` fmt a printf() style message format string.
// `...` ... additional parameters matching % tokens in the **fmt** string,
//            if any.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log (SDL_Log)
// See also: log_critical (SDL_LogCritical)
// See also: log_debug (SDL_LogDebug)
// See also: log_error (SDL_LogError)
// See also: log_info (SDL_LogInfo)
// See also: log_message (SDL_LogMessage)
// See also: log_message_v (SDL_LogMessageV)
// See also: log_warn (SDL_LogWarn)
//
// TODO: log_verbose(category int, const_fmt &char, ...) {}

// TODO: extern SDL_DECLSPEC void SDLCALL SDL_LogDebug(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);

// log_debug logs a message with SDL_LOG_PRIORITY_DEBUG.
//
// `category` category the category of the message.
// `fmt` fmt a printf() style message format string.
// `...` ... additional parameters matching % tokens in the **fmt** string,
//            if any.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log (SDL_Log)
// See also: log_critical (SDL_LogCritical)
// See also: log_error (SDL_LogError)
// See also: log_info (SDL_LogInfo)
// See also: log_message (SDL_LogMessage)
// See also: log_message_v (SDL_LogMessageV)
// See also: log_trace (SDL_LogTrace)
// See also: log_verbose (SDL_LogVerbose)
// See also: log_warn (SDL_LogWarn)
//
// TODO: log_debug(category int, const_fmt &char, ...) {}

// TODO: extern SDL_DECLSPEC void SDLCALL SDL_LogInfo(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);

// log_info logs a message with SDL_LOG_PRIORITY_INFO.
//
// `category` category the category of the message.
// `fmt` fmt a printf() style message format string.
// `...` ... additional parameters matching % tokens in the **fmt** string,
//            if any.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log (SDL_Log)
// See also: log_critical (SDL_LogCritical)
// See also: log_debug (SDL_LogDebug)
// See also: log_error (SDL_LogError)
// See also: log_message (SDL_LogMessage)
// See also: log_message_v (SDL_LogMessageV)
// See also: log_trace (SDL_LogTrace)
// See also: log_verbose (SDL_LogVerbose)
// See also: log_warn (SDL_LogWarn)
//
// TODO: log_info(category int, const_fmt &char, ...) {}

// TODO: extern SDL_DECLSPEC void SDLCALL SDL_LogWarn(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);

// log_warn logs a message with SDL_LOG_PRIORITY_WARN.
//
// `category` category the category of the message.
// `fmt` fmt a printf() style message format string.
// `...` ... additional parameters matching % tokens in the **fmt** string,
//            if any.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log (SDL_Log)
// See also: log_critical (SDL_LogCritical)
// See also: log_debug (SDL_LogDebug)
// See also: log_error (SDL_LogError)
// See also: log_info (SDL_LogInfo)
// See also: log_message (SDL_LogMessage)
// See also: log_message_v (SDL_LogMessageV)
// See also: log_trace (SDL_LogTrace)
// See also: log_verbose (SDL_LogVerbose)
//
// TODO: log_warn(category int, const_fmt &char, ...) {}

// TODO: extern SDL_DECLSPEC void SDLCALL SDL_LogError(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);

// log_error logs a message with SDL_LOG_PRIORITY_ERROR.
//
// `category` category the category of the message.
// `fmt` fmt a printf() style message format string.
// `...` ... additional parameters matching % tokens in the **fmt** string,
//            if any.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log (SDL_Log)
// See also: log_critical (SDL_LogCritical)
// See also: log_debug (SDL_LogDebug)
// See also: log_info (SDL_LogInfo)
// See also: log_message (SDL_LogMessage)
// See also: log_message_v (SDL_LogMessageV)
// See also: log_trace (SDL_LogTrace)
// See also: log_verbose (SDL_LogVerbose)
// See also: log_warn (SDL_LogWarn)
//
// TODO: log_error(category int, const_fmt &char, ...) {}

// TODO: extern SDL_DECLSPEC void SDLCALL SDL_LogCritical(int category, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);

// log_critical logs a message with SDL_LOG_PRIORITY_CRITICAL.
//
// `category` category the category of the message.
// `fmt` fmt a printf() style message format string.
// `...` ... additional parameters matching % tokens in the **fmt** string,
//            if any.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log (SDL_Log)
// See also: log_debug (SDL_LogDebug)
// See also: log_error (SDL_LogError)
// See also: log_info (SDL_LogInfo)
// See also: log_message (SDL_LogMessage)
// See also: log_message_v (SDL_LogMessageV)
// See also: log_trace (SDL_LogTrace)
// See also: log_verbose (SDL_LogVerbose)
// See also: log_warn (SDL_LogWarn)
//
// TODO: log_critical(category int, const_fmt &char, ...) {}

// TODO: extern SDL_DECLSPEC void SDLCALL SDL_LogMessage(int category, SDL_LogPriority priority, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(3);

// log_message logs a message with the specified category and priority.
//
// `category` category the category of the message.
// `priority` priority the priority of the message.
// `fmt` fmt a printf() style message format string.
// `...` ... additional parameters matching % tokens in the **fmt** string,
//            if any.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log (SDL_Log)
// See also: log_critical (SDL_LogCritical)
// See also: log_debug (SDL_LogDebug)
// See also: log_error (SDL_LogError)
// See also: log_info (SDL_LogInfo)
// See also: log_message_v (SDL_LogMessageV)
// See also: log_trace (SDL_LogTrace)
// See also: log_verbose (SDL_LogVerbose)
// See also: log_warn (SDL_LogWarn)
//
// TODO: log_message(category int, priority LogPriority, const_fmt &char, ...)

// TODO: extern SDL_DECLSPEC void SDLCALL SDL_LogMessageV(int category, SDL_LogPriority priority, SDL_PRINTF_FORMAT_STRING const char *fmt, va_list ap) SDL_PRINTF_VARARG_FUNCV(3);

// log_message_v logs a message with the specified category and priority.
//
// `category` category the category of the message.
// `priority` priority the priority of the message.
// `fmt` fmt a printf() style message format string.
// `ap` ap a variable argument list.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log (SDL_Log)
// See also: log_critical (SDL_LogCritical)
// See also: log_debug (SDL_LogDebug)
// See also: log_error (SDL_LogError)
// See also: log_info (SDL_LogInfo)
// See also: log_message (SDL_LogMessage)
// See also: log_trace (SDL_LogTrace)
// See also: log_verbose (SDL_LogVerbose)
// See also: log_warn (SDL_LogWarn)
//
// TODO: log_message_v(category int, priority LogPriority, const_fmt &char, ap C.va_list)

// LogOutputFunction thes prototype for the log output callback function.
//
// This function is called by SDL when there is new text to be logged. A mutex
// is held so that this function is never called by more than one thread at
// once.
//
// `userdata` userdata what was passed as `userdata` to
//                 SDL_SetLogOutputFunction().
// `category` category the category of the message.
// `priority` priority the priority of the message.
// `message` message the message being output.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_LogOutputFunction)
pub type LogOutputFunction = fn (userdata voidptr, category int, priority LogPriority, const_message &char)

// C.SDL_GetDefaultLogOutputFunction [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetDefaultLogOutputFunction)
fn C.SDL_GetDefaultLogOutputFunction() LogOutputFunction

// get_default_log_output_function gets the default log output function.
//
// returns the default log output callback.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_log_output_function (SDL_SetLogOutputFunction)
// See also: get_log_output_function (SDL_GetLogOutputFunction)
pub fn get_default_log_output_function() LogOutputFunction {
	return C.SDL_GetDefaultLogOutputFunction()
}

// C.SDL_GetLogOutputFunction [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetLogOutputFunction)
fn C.SDL_GetLogOutputFunction(callback &LogOutputFunction, userdata &voidptr)

// get_log_output_function gets the current log output function.
//
// `callback` callback an SDL_LogOutputFunction filled in with the current log
//                 callback.
// `userdata` userdata a pointer filled in with the pointer that is passed to
//                 `callback`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_default_log_output_function (SDL_GetDefaultLogOutputFunction)
// See also: set_log_output_function (SDL_SetLogOutputFunction)
pub fn get_log_output_function(callback &LogOutputFunction, userdata &voidptr) {
	C.SDL_GetLogOutputFunction(callback, userdata)
}

// C.SDL_SetLogOutputFunction [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetLogOutputFunction)
fn C.SDL_SetLogOutputFunction(callback LogOutputFunction, userdata voidptr)

// set_log_output_function replaces the default log output function with one of your own.
//
// `callback` callback an SDL_LogOutputFunction to call instead of the default.
// `userdata` userdata a pointer that is passed to `callback`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_default_log_output_function (SDL_GetDefaultLogOutputFunction)
// See also: get_log_output_function (SDL_GetLogOutputFunction)
pub fn set_log_output_function(callback LogOutputFunction, userdata voidptr) {
	C.SDL_SetLogOutputFunction(callback, userdata)
}
