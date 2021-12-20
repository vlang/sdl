// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

const (
 max_log_message = C.SDL_MAX_LOG_MESSAGE // 4096
)

/**
 *  \brief The prototype for the log output function
 */
// TODO typedef void (SDLCALL *SDL_LogOutputFunction)(void *userdata, int category, SDL_LogPriority priority, const char *message);

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

/**
 *  \brief Set the priority of all log categories
 */
fn C.SDL_LogSetAllPriority(priority C.SDL_LogPriority)
pub fn log_set_all_priority(priority C.SDL_LogPriority){
	 C.SDL_LogSetAllPriority(priority)
}

/**
 *  \brief Set the priority of a particular log category
 */
fn C.SDL_LogSetPriority(category int, priority C.SDL_LogPriority)
pub fn log_set_priority(category int, priority C.SDL_LogPriority){
	 C.SDL_LogSetPriority(category, priority)
}


/**
 *  \brief Get the priority of a particular log category
 */
fn C.SDL_LogGetPriority(category int) C.SDL_LogPriority
pub fn log_get_priority(category int) C.SDL_LogPriority{
	return C.SDL_LogGetPriority(category)
}


/**
 *  \brief Reset all priorities to default.
 *
 *  \note This is called in SDL_Quit().
 */
fn C.SDL_LogResetPriorities()
pub fn log_reset_priorities(){
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

/**
 *  \brief Log a message with the specified category and priority.
 */
fn C.SDL_LogMessageV(category int, priority C.SDL_LogPriority, fmt &char, ap C.va_list)
pub fn log_message_v(category int, priority C.SDL_LogPriority, fmt &char, ap C.va_list){
	 C.SDL_LogMessageV(category, priority, fmt, ap)
}


/**
 *  \brief Get the current log output function.
 */
// `userdata` is `**`
fn C.SDL_LogGetOutputFunction(callback &C.SDL_LogOutputFunction, userdata voidptr)
pub fn log_get_output_function(callback &C.SDL_LogOutputFunction, userdata voidptr){
	 C.SDL_LogGetOutputFunction(callback, userdata)
}


/**
 *  \brief This function allows you to replace the default log output
 *         function with one of your own.
 */
fn C.SDL_LogSetOutputFunction(callback C.SDL_LogOutputFunction, userdata voidptr)
pub fn log_set_output_function(callback C.SDL_LogOutputFunction, userdata voidptr){
	 C.SDL_LogSetOutputFunction(callback, userdata)
}
