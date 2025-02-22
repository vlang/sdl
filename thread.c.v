// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_thread.h
//

// SDL offers cross-platform thread management functions. These are mostly
// concerned with starting threads, setting their priority, and dealing with
// their termination.
//
// In addition, there is support for Thread Local Storage (data that is unique
// to each thread, but accessed from a single key).
//
// On platforms without thread support (such as Emscripten when built without
// pthreads), these functions still exist, but things like SDL_CreateThread()
// will report failure without doing anything.
//
// If you're going to work with threads, you almost certainly need to have a
// good understanding of [CategoryMutex](CategoryMutex) as well.

// A unique numeric ID that identifies a thread.
//
// These are different from SDL_Thread objects, which are generally what an
// application will operate on, but having a way to uniquely identify a thread
// can be useful at times.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: get_thread_id (SDL_GetThreadID)
// See also: get_current_thread_id (SDL_GetCurrentThreadID)
pub type ThreadID = u64

// Thread local storage ID.
//
// 0 is the invalid ID. An app can create these and then set data for these
// IDs that is unique to each thread.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: get_tls (SDL_GetTLS)
// See also: set_tls (SDL_SetTLS)
pub type TLSID = C.SDL_AtomicInt

@[noinit; typedef]
pub struct C.SDL_Thread {
	// NOTE: Opaque type
}

pub type Thread = C.SDL_Thread

// ThreadPriority is C.SDL_ThreadPriority
pub enum ThreadPriority {
	low           = C.SDL_THREAD_PRIORITY_LOW
	normal        = C.SDL_THREAD_PRIORITY_NORMAL
	high          = C.SDL_THREAD_PRIORITY_HIGH
	time_critical = C.SDL_THREAD_PRIORITY_TIME_CRITICAL
}

// ThreadState is C.SDL_ThreadState
pub enum ThreadState {
	unknown  = C.SDL_THREAD_UNKNOWN  // `unknown` The thread is not valid
	alive    = C.SDL_THREAD_ALIVE    // `alive` The thread is currently running
	detached = C.SDL_THREAD_DETACHED // `detached` The thread is detached and can't be waited on
	complete = C.SDL_THREAD_COMPLETE // `complete` The thread has finished and should be cleaned up with SDL_WaitThread()
}

// ThreadFunction thes function passed to SDL_CreateThread() as the new thread's entry point.
//
// `data` data what was passed as `data` to SDL_CreateThread().
// returns a value that can be reported through SDL_WaitThread().
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_ThreadFunction)
pub type ThreadFunction = fn (data voidptr) int

// C.SDL_CreateThread [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateThread)
fn C.SDL_CreateThread(@fn ThreadFunction, const_name &char, data voidptr) &Thread

// create_thread creates a new thread with a default stack size.
//
// This is a convenience function, equivalent to calling
// SDL_CreateThreadWithProperties with the following properties set:
//
// - `SDL_PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER`: `fn`
// - `SDL_PROP_THREAD_CREATE_NAME_STRING`: `name`
// - `SDL_PROP_THREAD_CREATE_USERDATA_POINTER`: `data`
//
// Note that this "function" is actually a macro that calls an internal
// function with two extra parameters not listed here; they are hidden through
// preprocessor macros and are needed to support various C runtimes at the
// point of the function call. Language bindings that aren't using the C
// headers will need to deal with this.
//
// Usually, apps should just call this function the same way on every platform
// and let the macros hide the details.
//
// `fn` fn the SDL_ThreadFunction function to call in the new thread.
// `name` name the name of the thread.
// `data` data a pointer that is passed to `fn`.
// returns an opaque pointer to the new thread object on success, NULL if the
//          new thread could not be created; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_thread_with_properties (SDL_CreateThreadWithProperties)
// See also: wait_thread (SDL_WaitThread)
pub fn create_thread(@fn ThreadFunction, const_name &char, data voidptr) &Thread {
	return C.SDL_CreateThread(@fn, const_name, data)
}

// C.SDL_CreateThreadWithProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateThreadWithProperties)
fn C.SDL_CreateThreadWithProperties(props PropertiesID) &Thread

// create_thread_with_properties creates a new thread with with the specified properties.
//
// These are the supported properties:
//
// - `SDL_PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER`: an SDL_ThreadFunction
//   value that will be called at the start of the new thread's life.
//   Required.
// - `SDL_PROP_THREAD_CREATE_NAME_STRING`: the name of the new thread, which
//   might be available to debuggers. Optional, defaults to NULL.
// - `SDL_PROP_THREAD_CREATE_USERDATA_POINTER`: an arbitrary app-defined
//   pointer, which is passed to the entry function on the new thread, as its
//   only parameter. Optional, defaults to NULL.
// - `SDL_PROP_THREAD_CREATE_STACKSIZE_NUMBER`: the size, in bytes, of the new
//   thread's stack. Optional, defaults to 0 (system-defined default).
//
// SDL makes an attempt to report `SDL_PROP_THREAD_CREATE_NAME_STRING` to the
// system, so that debuggers can display it. Not all platforms support this.
//
// Thread naming is a little complicated: Most systems have very small limits
// for the string length (Haiku has 32 bytes, Linux currently has 16, Visual
// C++ 6.0 has _nine_!), and possibly other arbitrary rules. You'll have to
// see what happens with your system's debugger. The name should be UTF-8 (but
// using the naming limits of C identifiers is a better bet). There are no
// requirements for thread naming conventions, so long as the string is
// null-terminated UTF-8, but these guidelines are helpful in choosing a name:
//
// https://stackoverflow.com/questions/149932/naming-conventions-for-threads
//
// If a system imposes requirements, SDL will try to munge the string for it
// (truncate, etc), but the original string contents will be available from
// SDL_GetThreadName().
//
// The size (in bytes) of the new stack can be specified with
// `SDL_PROP_THREAD_CREATE_STACKSIZE_NUMBER`. Zero means "use the system
// default" which might be wildly different between platforms. x86 Linux
// generally defaults to eight megabytes, an embedded device might be a few
// kilobytes instead. You generally need to specify a stack that is a multiple
// of the system's page size (in many cases, this is 4 kilobytes, but check
// your system documentation).
//
// Note that this "function" is actually a macro that calls an internal
// function with two extra parameters not listed here; they are hidden through
// preprocessor macros and are needed to support various C runtimes at the
// point of the function call. Language bindings that aren't using the C
// headers will need to deal with this.
//
// The actual symbol in SDL is `SDL_CreateThreadWithPropertiesRuntime`, so
// there is no symbol clash, but trying to load an SDL shared library and look
// for "SDL_CreateThreadWithProperties" will fail.
//
// Usually, apps should just call this function the same way on every platform
// and let the macros hide the details.
//
// `props` props the properties to use.
// returns an opaque pointer to the new thread object on success, NULL if the
//          new thread could not be created; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_thread (SDL_CreateThread)
// See also: wait_thread (SDL_WaitThread)
pub fn create_thread_with_properties(props PropertiesID) &Thread {
	return C.SDL_CreateThreadWithProperties(props)
}

pub const prop_thread_create_entry_function_pointer = &char(C.SDL_PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER) // 'SDL.thread.create.entry_function'

pub const prop_thread_create_name_string = &char(C.SDL_PROP_THREAD_CREATE_NAME_STRING) // 'SDL.thread.create.name'

pub const prop_thread_create_userdata_pointer = &char(C.SDL_PROP_THREAD_CREATE_USERDATA_POINTER) // 'SDL.thread.create.userdata'

pub const prop_thread_create_stacksize_number = &char(C.SDL_PROP_THREAD_CREATE_STACKSIZE_NUMBER) // 'SDL.thread.create.stacksize'

// C.SDL_CreateThreadRuntime [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateThreadRuntime)
fn C.SDL_CreateThreadRuntime(@fn ThreadFunction, const_name &char, data voidptr, pfn_begin_thread FunctionPointer, pfn_end_thread FunctionPointer) &Thread

// create_thread_runtime thes actual entry point for SDL_CreateThread.
//
// `fn` fn the SDL_ThreadFunction function to call in the new thread
// `name` name the name of the thread
// `data` data a pointer that is passed to `fn`
// `pfn_begin_thread` pfnBeginThread the C runtime's _beginthreadex (or whatnot). Can be NULL.
// `pfn_end_thread` pfnEndThread the C runtime's _endthreadex (or whatnot). Can be NULL.
// returns an opaque pointer to the new thread object on success, NULL if the
//          new thread could not be created; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn create_thread_runtime(@fn ThreadFunction, const_name &char, data voidptr, pfn_begin_thread FunctionPointer, pfn_end_thread FunctionPointer) &Thread {
	return C.SDL_CreateThreadRuntime(@fn, const_name, data, pfn_begin_thread, pfn_end_thread)
}

// C.SDL_CreateThreadWithPropertiesRuntime [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateThreadWithPropertiesRuntime)
fn C.SDL_CreateThreadWithPropertiesRuntime(props PropertiesID, pfn_begin_thread FunctionPointer, pfn_end_thread FunctionPointer) &Thread

// create_thread_with_properties_runtime thes actual entry point for SDL_CreateThreadWithProperties.
//
// `props` props the properties to use
// `pfn_begin_thread` pfnBeginThread the C runtime's _beginthreadex (or whatnot). Can be NULL.
// `pfn_end_thread` pfnEndThread the C runtime's _endthreadex (or whatnot). Can be NULL.
// returns an opaque pointer to the new thread object on success, NULL if the
//          new thread could not be created; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn create_thread_with_properties_runtime(props PropertiesID, pfn_begin_thread FunctionPointer, pfn_end_thread FunctionPointer) &Thread {
	return C.SDL_CreateThreadWithPropertiesRuntime(props, pfn_begin_thread, pfn_end_thread)
}

// TODO: Function: #define SDL_CreateThread(fn, name, data) SDL_CreateThreadRuntime((fn), (name), (data), (SDL_FunctionPointer) (SDL_BeginThreadFunction), (SDL_FunctionPointer) (SDL_EndThreadFunction))

// TODO: Function: #define SDL_CreateThreadWithProperties(props) SDL_CreateThreadWithPropertiesRuntime((props), (SDL_FunctionPointer) (SDL_BeginThreadFunction), (SDL_FunctionPointer) (SDL_EndThreadFunction))

// C.SDL_GetThreadName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetThreadName)
fn C.SDL_GetThreadName(thread_ &Thread) &char

// get_thread_name gets the thread name as it was specified in SDL_CreateThread().
//
// `thread` thread the thread to query.
// returns a pointer to a UTF-8 string that names the specified thread, or
//          NULL if it doesn't have a name.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_thread_name(thread_ &Thread) &char {
	return &char(C.SDL_GetThreadName(thread_))
}

// C.SDL_GetCurrentThreadID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCurrentThreadID)
fn C.SDL_GetCurrentThreadID() ThreadID

// get_current_thread_id gets the thread identifier for the current thread.
//
// This thread identifier is as reported by the underlying operating system.
// If SDL is running on a platform that does not support threads the return
// value will always be zero.
//
// This function also returns a valid thread ID when called from the main
// thread.
//
// returns the ID of the current thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_thread_id (SDL_GetThreadID)
pub fn get_current_thread_id() ThreadID {
	return C.SDL_GetCurrentThreadID()
}

// C.SDL_GetThreadID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetThreadID)
fn C.SDL_GetThreadID(thread_ &Thread) ThreadID

// get_thread_id gets the thread identifier for the specified thread.
//
// This thread identifier is as reported by the underlying operating system.
// If SDL is running on a platform that does not support threads the return
// value will always be zero.
//
// `thread` thread the thread to query.
// returns the ID of the specified thread, or the ID of the current thread if
//          `thread` is NULL.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_current_thread_id (SDL_GetCurrentThreadID)
pub fn get_thread_id(thread_ &Thread) ThreadID {
	return C.SDL_GetThreadID(thread_)
}

// C.SDL_SetCurrentThreadPriority [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetCurrentThreadPriority)
fn C.SDL_SetCurrentThreadPriority(priority ThreadPriority) bool

// set_current_thread_priority sets the priority for the current thread.
//
// Note that some platforms will not let you alter the priority (or at least,
// promote the thread to a higher priority) at all, and some require you to be
// an administrator account. Be prepared for this to fail.
//
// `priority` priority the SDL_ThreadPriority to set.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn set_current_thread_priority(priority ThreadPriority) bool {
	return C.SDL_SetCurrentThreadPriority(priority)
}

// C.SDL_WaitThread [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitThread)
fn C.SDL_WaitThread(thread_ &Thread, status &int)

// wait_thread waits for a thread to finish.
//
// Threads that haven't been detached will remain until this function cleans
// them up. Not doing so is a resource leak.
//
// Once a thread has been cleaned up through this function, the SDL_Thread
// that references it becomes invalid and should not be referenced again. As
// such, only one thread may call SDL_WaitThread() on another.
//
// The return code from the thread function is placed in the area pointed to
// by `status`, if `status` is not NULL.
//
// You may not wait on a thread that has been used in a call to
// SDL_DetachThread(). Use either that function or this one, but not both, or
// behavior is undefined.
//
// It is safe to pass a NULL thread to this function; it is a no-op.
//
// Note that the thread pointer is freed by this function and is not valid
// afterward.
//
// `thread` thread the SDL_Thread pointer that was returned from the
//               SDL_CreateThread() call that started this thread.
// `status` status a pointer filled in with the value returned from the thread
//               function by its 'return', or -1 if the thread has been
//               detached or isn't valid, may be NULL.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_thread (SDL_CreateThread)
// See also: detach_thread (SDL_DetachThread)
pub fn wait_thread(thread_ &Thread, status &int) {
	C.SDL_WaitThread(thread_, status)
}

// C.SDL_GetThreadState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetThreadState)
fn C.SDL_GetThreadState(thread_ &Thread) ThreadState

// get_thread_state gets the current state of a thread.
//
// `thread` thread the thread to query.
// returns the current state of a thread, or SDL_THREAD_UNKNOWN if the thread
//          isn't valid.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: thread_state (SDL_ThreadState)
pub fn get_thread_state(thread_ &Thread) ThreadState {
	return C.SDL_GetThreadState(thread_)
}

// C.SDL_DetachThread [official documentation](https://wiki.libsdl.org/SDL3/SDL_DetachThread)
fn C.SDL_DetachThread(thread_ &Thread)

// detach_thread lets a thread clean up on exit without intervention.
//
// A thread may be "detached" to signify that it should not remain until
// another thread has called SDL_WaitThread() on it. Detaching a thread is
// useful for long-running threads that nothing needs to synchronize with or
// further manage. When a detached thread is done, it simply goes away.
//
// There is no way to recover the return code of a detached thread. If you
// need this, don't detach the thread and instead use SDL_WaitThread().
//
// Once a thread is detached, you should usually assume the SDL_Thread isn't
// safe to reference again, as it will become invalid immediately upon the
// detached thread's exit, instead of remaining until someone has called
// SDL_WaitThread() to finally clean it up. As such, don't detach the same
// thread more than once.
//
// If a thread has already exited when passed to SDL_DetachThread(), it will
// stop waiting for a call to SDL_WaitThread() and clean up immediately. It is
// not safe to detach a thread that might be used with SDL_WaitThread().
//
// You may not call SDL_WaitThread() on a thread that has been detached. Use
// either that function or this one, but not both, or behavior is undefined.
//
// It is safe to pass NULL to this function; it is a no-op.
//
// `thread` thread the SDL_Thread pointer that was returned from the
//               SDL_CreateThread() call that started this thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_thread (SDL_CreateThread)
// See also: wait_thread (SDL_WaitThread)
pub fn detach_thread(thread_ &Thread) {
	C.SDL_DetachThread(thread_)
}

// C.SDL_GetTLS [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetTLS)
fn C.SDL_GetTLS(id &TLSID) voidptr

// get_tls gets the current thread's value associated with a thread local storage ID.
//
// `id` id a pointer to the thread local storage ID, may not be NULL.
// returns the value associated with the ID for the current thread or NULL if
//          no value has been set; call SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_tls (SDL_SetTLS)
pub fn get_tls(id &TLSID) voidptr {
	return C.SDL_GetTLS(id)
}

// TLSDestructorCallback thes callback used to cleanup data passed to SDL_SetTLS.
//
// This is called when a thread exits, to allow an app to free any resources.
//
// `value` value a pointer previously handed to SDL_SetTLS.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: set_tls (SDL_SetTLS)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_TLSDestructorCallback)
pub type TLSDestructorCallback = fn (value voidptr)

// C.SDL_SetTLS [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetTLS)
fn C.SDL_SetTLS(id &TLSID, const_value voidptr, destructor TLSDestructorCallback) bool

// set_tls sets the current thread's value associated with a thread local storage ID.
//
// If the thread local storage ID is not initialized (the value is 0), a new
// ID will be created in a thread-safe way, so all calls using a pointer to
// the same ID will refer to the same local storage.
//
// Note that replacing a value from a previous call to this function on the
// same thread does _not_ call the previous value's destructor!
//
// `destructor` can be NULL; it is assumed that `value` does not need to be
// cleaned up if so.
//
// `id` id a pointer to the thread local storage ID, may not be NULL.
// `value` value the value to associate with the ID for the current thread.
// `destructor` destructor a function called when the thread exits, to free the
//                   value, may be NULL.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_tls (SDL_GetTLS)
pub fn set_tls(id &TLSID, const_value voidptr, destructor TLSDestructorCallback) bool {
	return C.SDL_SetTLS(id, const_value, destructor)
}

// C.SDL_CleanupTLS [official documentation](https://wiki.libsdl.org/SDL3/SDL_CleanupTLS)
fn C.SDL_CleanupTLS()

// cleanup_tls cleanups all TLS data for this thread.
//
// If you are creating your threads outside of SDL and then calling SDL
// functions, you should call this function before your thread exits, to
// properly clean up SDL memory.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn cleanup_tls() {
	C.SDL_CleanupTLS()
}
