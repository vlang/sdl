// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_thread.h
//

// Thread is the SDL thread structure, defined in SDL_thread.c
// Thread is C.SDL_Thread

[typedef]
struct C.SDL_Thread {
}

pub type Thread = C.SDL_Thread

// The SDL thread ID
// `typedef unsigned long SDL_threadID;`
pub type ThreadID = u32

// Thread local storage ID, 0 is the invalid ID
// `typedef unsigned int SDL_TLSID;`
pub type TLSID = u32

// ThreadPriority is the SDL thread priority.
//
// NOTE On many systems you require special privileges to set high or time critical priority.
//
// ThreadPriority is C.SDL_ThreadPriority
pub enum ThreadPriority {
	low = C.SDL_THREAD_PRIORITY_LOW
	normal = C.SDL_THREAD_PRIORITY_NORMAL
	high = C.SDL_THREAD_PRIORITY_HIGH
	time_critical = C.SDL_THREAD_PRIORITY_TIME_CRITICAL
}

// ThreadFunction is the function passed to SDL_CreateThread().
// It is passed a void* user context parameter and returns an int.
// `typedef int (SDLCALL * SDL_ThreadFunction) (void *data);`
pub type ThreadFunction = fn (data voidptr) int

/*
// TODO win32 & OS2 ???
// extern DECLSPEC SDL_Thread *SDLCALL SDL_CreateThread(SDL_ThreadFunction fn, const char *name, void *data, pfnSDL_CurrentBeginThread pfnBeginThread, pfnSDL_CurrentEndThread pfnEndThread)
fn C.SDL_CreateThread(func C.SDL_ThreadFunction, name &char, data voidptr, pfn_begin_thread C.pfnSDL_CurrentBeginThread, pfn_end_thread C.pfnSDL_CurrentEndThread) &C.SDL_Thread

pub fn create_thread(func C.SDL_ThreadFunction, name &char, data voidptr, pfn_begin_thread C.pfnSDL_CurrentBeginThread, pfn_end_thread C.pfnSDL_CurrentEndThread) &C.SDL_Thread{
	return C.SDL_CreateThread(func, name, data, pfn_begin_thread, pfn_end_thread)
}

// extern DECLSPEC SDL_Thread *SDLCALL SDL_CreateThreadWithStackSize(int (SDLCALL * fn) (void *),                 const char *name, const size_t stacksize, void *data,                 pfnSDL_CurrentBeginThread pfnBeginThread,                 pfnSDL_CurrentEndThread pfnEndThread)
fn C.SDL_CreateThreadWithStackSize((void* ) &C.int (SDLCALL  fn), name &char, stacksize usize, data voidptr, pfn_begin_thread C.pfnSDL_CurrentBeginThread, pfn_end_thread C.pfnSDL_CurrentEndThread) &C.SDL_Thread
pub fn create_thread_with_stack_size((void* ) &C.int (SDLCALL  fn), name &char, stacksize usize, data voidptr, pfn_begin_thread C.pfnSDL_CurrentBeginThread, pfn_end_thread C.pfnSDL_CurrentEndThread) &C.SDL_Thread{
	return C.SDL_CreateThreadWithStackSize((void* ), name, stacksize, data, pfn_begin_thread, pfn_end_thread)
}

// extern DECLSPEC SDL_Thread * SDLCALL SDL_CreateThread(SDL_ThreadFunction fn, const char * name, void * data,                 pfnSDL_CurrentBeginThread pfnBeginThread,                 pfnSDL_CurrentEndThread pfnEndThread)
fn C.SDL_CreateThread(func C.SDL_ThreadFunction, name &char, data voidptr, pfn_begin_thread C.pfnSDL_CurrentBeginThread, pfn_end_thread C.pfnSDL_CurrentEndThread) &C.SDL_Thread
pub fn create_thread(func C.SDL_ThreadFunction, name &char, data voidptr, pfn_begin_thread C.pfnSDL_CurrentBeginThread, pfn_end_thread C.pfnSDL_CurrentEndThread) &C.SDL_Thread{
	return C.SDL_CreateThread(func, name, data, pfn_begin_thread, pfn_end_thread)
}
*/

fn C.SDL_CreateThread(func ThreadFunction, const_name &char, data voidptr) &C.SDL_Thread

// create_thread creates a thread with a default stack size.
//
// This is equivalent to calling:
// SDL_CreateThreadWithStackSize(fn, name, 0, data);
pub fn create_thread(func ThreadFunction, const_name &char, data voidptr) &Thread {
	return C.SDL_CreateThread(func, const_name, data)
}

fn C.SDL_CreateThreadWithStackSize(func ThreadFunction, const_name &char, const_stacksize usize, data voidptr) &C.SDL_Thread

// create_thread_with_stack_size creates a a thread.
//
// Thread naming is a little complicated: Most systems have very small
//  limits for the string length (Haiku has 32 bytes, Linux currently has 16,
//  Visual C++ 6.0 has nine!), and possibly other arbitrary rules. You'll
//  have to see what happens with your system's debugger. The name should be
//  UTF-8 (but using the naming limits of C identifiers is a better bet).
// There are no requirements for thread naming conventions, so long as the
//  string is null-terminated UTF-8, but these guidelines are helpful in
//  choosing a name:
//
//  http://stackoverflow.com/questions/149932/naming-conventions-for-threads
//
// If a system imposes requirements, SDL will try to munge the string for
//  it (truncate, etc), but the original string contents will be available
//  from SDL_GetThreadName().
//
// The size (in bytes) of the new stack can be specified. Zero means "use
//  the system default" which might be wildly different between platforms
//  (x86 Linux generally defaults to eight megabytes, an embedded device
//  might be a few kilobytes instead).
//
// In SDL 2.1, stacksize will be folded into the original SDL_CreateThread
//  function.
pub fn create_thread_with_stack_size(func ThreadFunction, const_name &char, const_stacksize usize, data voidptr) &Thread {
	$if !windows {
		return C.SDL_CreateThreadWithStackSize(func, const_name, const_stacksize, data)
	} $else {
		panic('TODO support this call on Windows')
	}
	return voidptr(0)
}

fn C.SDL_GetThreadName(thread &C.SDL_Thread) &char

// get_thread_name gets the thread name, as it was specified in SDL_CreateThread().
// This function returns a pointer to a UTF-8 string that names the
// specified thread, or NULL if it doesn't have a name. This is internal
// memory, not to be free()'d by the caller, and remains valid until the
// specified thread is cleaned up by SDL_WaitThread().
pub fn get_thread_name(thread &Thread) &char {
	return C.SDL_GetThreadName(thread)
}

fn C.SDL_ThreadID() C.SDL_threadID

// thread_id gets the thread identifier for the current thread.
pub fn thread_id() ThreadID {
	return ThreadID(u32(C.SDL_ThreadID()))
}

fn C.SDL_GetThreadID(thrd &C.SDL_Thread) C.SDL_threadID

// get_thread_id gets the thread identifier for the specified thread.
//
// Equivalent to SDL_ThreadID() if the specified thread is NULL.
pub fn get_thread_id(thrd &Thread) ThreadID {
	return ThreadID(u32(C.SDL_GetThreadID(thrd)))
}

fn C.SDL_SetThreadPriority(priority C.SDL_ThreadPriority) int

// set_thread_priority sets the priority for the current thread
pub fn set_thread_priority(priority ThreadPriority) int {
	return C.SDL_SetThreadPriority(C.SDL_ThreadPriority(priority))
}

fn C.SDL_WaitThread(thrd &C.SDL_Thread, status &int)

// wait_thread waits for a thread to finish. Threads that haven't been detached will
// remain (as a "zombie") until this function cleans them up. Not doing so
// is a resource leak.
//
// Once a thread has been cleaned up through this function, the SDL_Thread
// that references it becomes invalid and should not be referenced again.
// As such, only one thread may call SDL_WaitThread() on another.
//
// The return code for the thread function is placed in the area
// pointed to by `status`, if `status` is not NULL.
//
// You may not wait on a thread that has been used in a call to
// SDL_DetachThread(). Use either that function or this one, but not
// both, or behavior is undefined.
//
// It is safe to pass NULL to this function; it is a no-op.
pub fn wait_thread(thrd &Thread, status &int) {
	C.SDL_WaitThread(thrd, status)
}

fn C.SDL_DetachThread(thrd &C.SDL_Thread)

// detach_thread. A thread may be "detached" to signify that it should not remain until
// another thread has called SDL_WaitThread() on it. Detaching a thread
// is useful for long-running threads that nothing needs to synchronize
// with or further manage. When a detached thread is done, it simply
// goes away.
//
// There is no way to recover the return code of a detached thread. If you
// need this, don't detach the thread and instead use SDL_WaitThread().
//
// Once a thread is detached, you should usually assume the SDL_Thread isn't
// safe to reference again, as it will become invalid immediately upon
// the detached thread's exit, instead of remaining until someone has called
// SDL_WaitThread() to finally clean it up. As such, don't detach the same
// thread more than once.
//
// If a thread has already exited when passed to SDL_DetachThread(), it will
// stop waiting for a call to SDL_WaitThread() and clean up immediately.
// It is not safe to detach a thread that might be used with SDL_WaitThread().
//
// You may not call SDL_WaitThread() on a thread that has been detached.
// Use either that function or this one, but not both, or behavior is
// undefined.
//
// It is safe to pass NULL to this function; it is a no-op.
pub fn detach_thread(thrd &Thread) {
	C.SDL_DetachThread(thrd)
}

fn C.SDL_TLSCreate() C.SDL_TLSID

// tls_create create an identifier that is globally visible to all threads but refers to data that is thread-specific.
//
// returns The newly created thread local storage identifier, or 0 on error
//
/*
```
    static SDL_SpinLock tls_lock;
    static SDL_TLSID thread_local_storage;

    void SetMyThreadData(void * value)
    {
        if (!thread_local_storage) {
            SDL_AtomicLock(&tls_lock);
            if (!thread_local_storage) {
                thread_local_storage = SDL_TLSCreate();
            }
            SDL_AtomicUnlock(&tls_lock);
        }
        SDL_TLSSet(thread_local_storage, value, 0);
    }

    void * GetMyThreadData(void)
    {
        return SDL_TLSGet(thread_local_storage);
    }
```
*/
//
// See also: SDL_TLSGet()
// See also: SDL_TLSSet()
pub fn tls_create() TLSID {
	return TLSID(u32(C.SDL_TLSCreate()))
}

fn C.SDL_TLSGet(id C.SDL_TLSID) voidptr

// tls_get gets the value associated with a thread local storage ID for the current thread.
//
// `id` The thread local storage ID
//
// returns The value associated with the ID for the current thread, or NULL if no value has been set.
//
// See also: SDL_TLSCreate()
// See also: SDL_TLSSet()
pub fn tls_get(id TLSID) voidptr {
	return C.SDL_TLSGet(C.SDL_TLSID(id))
}

fn C.SDL_TLSSet(id C.SDL_TLSID, const_value voidptr, destructor fn (voidptr)) int

// tls_set sets the value associated with a thread local storage ID for the current thread.
//
// `id` The thread local storage ID
// `value` The value to associate with the ID for the current thread
// `destructor` A function called when the thread exits, to free the value.
//
// returns 0 on success, -1 on error
//
// See also: SDL_TLSCreate()
// See also: SDL_TLSGet()
pub fn tls_set(id TLSID, const_value voidptr, destructor fn (voidptr)) int {
	return C.SDL_TLSSet(C.SDL_TLSID(id), const_value, destructor)
}
