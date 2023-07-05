// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_mutex.h
//

// mutex_timeout. Synchronization functions which can time out return this value
// if they time out.
pub const mutex_timeout = C.SDL_MUTEX_TIMEDOUT // 1

// mutex_maxwait is the timeout value which corresponds to never time out.
pub const mutex_maxwait = C.SDL_MUTEX_MAXWAIT // (~(Uint32)0)

// Mutex is the SDL mutex structure, defined in SDL_sysmutex.c
// Mutex is C.SDL_mutex
[typedef]
pub struct C.SDL_mutex {
}

pub type Mutex = C.SDL_mutex

fn C.SDL_CreateMutex() &C.SDL_mutex

// create_mutex creates a new mutex.
//
// All newly-created mutexes begin in the _unlocked_ state.
//
// Calls to SDL_LockMutex() will not return while the mutex is locked by
// another thread. See SDL_TryLockMutex() to attempt to lock without blocking.
//
// SDL mutexes are reentrant.
//
// returns the initialized and unlocked mutex or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_DestroyMutex
// See also: SDL_LockMutex
// See also: SDL_TryLockMutex
// See also: SDL_UnlockMutex
pub fn create_mutex() &C.SDL_mutex {
	return C.SDL_CreateMutex()
}

fn C.SDL_LockMutex(mutex &C.SDL_mutex) int

// lock_mutex locks the mutex.
//
// This will block until the mutex is available, which is to say it is in the
// unlocked state and the OS has chosen the caller as the next thread to lock
// it. Of all threads waiting to lock the mutex, only one may do so at a time.
//
// It is legal for the owning thread to lock an already-locked mutex. It must
// unlock it the same number of times before it is actually made available for
// other threads in the system (this is known as a "recursive mutex").
//
// `mutex` the mutex to lock
// returns 0, or -1 on error.
//
// NOTE This function is available since SDL 2.0.0.
pub fn lock_mutex(mutex &Mutex) int {
	return C.SDL_LockMutex(mutex)
}

fn C.SDL_TryLockMutex(mutex &C.SDL_mutex) int

// try_lock_mutex trys to lock a mutex without blocking.
//
// This works just like SDL_LockMutex(), but if the mutex is not available,
// this function returns `SDL_MUTEX_TIMEOUT` immediately.
//
// This technique is useful if you need exclusive access to a resource but
// don't want to wait for it, and will return to it to try again later.
//
// `mutex` the mutex to try to lock
// returns 0, `SDL_MUTEX_TIMEDOUT`, or -1 on error; call SDL_GetError() for
//          more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateMutex
// See also: SDL_DestroyMutex
// See also: SDL_LockMutex
// See also: SDL_UnlockMutex
pub fn try_lock_mutex(mutex &Mutex) int {
	return C.SDL_TryLockMutex(mutex)
}

fn C.SDL_UnlockMutex(mutex &C.SDL_mutex) int

// unlock_mutex unlocks the mutex.
//
// It is legal for the owning thread to lock an already-locked mutex. It must
// unlock it the same number of times before it is actually made available for
// other threads in the system (this is known as a "recursive mutex").
//
// It is an error to unlock a mutex that has not been locked by the current
// thread, and doing so results in undefined behavior.
//
// It is also an error to unlock a mutex that isn't locked at all.
//
// `mutex` the mutex to unlock.
// returns 0, or -1 on error.
//
// NOTE This function is available since SDL 2.0.0.
pub fn unlock_mutex(mutex &Mutex) int {
	return C.SDL_UnlockMutex(mutex)
}

fn C.SDL_DestroyMutex(mutex &C.SDL_mutex)

// destroy_mutex destroys a mutex created with SDL_CreateMutex().
//
// This function must be called on any mutex that is no longer needed. Failure
// to destroy a mutex will result in a system memory or resource leak. While
// it is safe to destroy a mutex that is _unlocked_, it is not safe to attempt
// to destroy a locked mutex, and may result in undefined behavior depending
// on the platform.
//
// `mutex` the mutex to destroy
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateMutex
// See also: SDL_LockMutex
// See also: SDL_TryLockMutex
// See also: SDL_UnlockMutex
pub fn destroy_mutex(mutex &Mutex) {
	C.SDL_DestroyMutex(mutex)
}

// Sem is the SDL semaphore structure, defined in SDL_syssem.c
// Sem is C.SDL_sem
[typedef]
pub struct C.SDL_sem {
}

pub type Sem = C.SDL_sem

fn C.SDL_CreateSemaphore(initial_value u32) &C.SDL_sem

// create_semaphore creates a semaphore.
//
// This function creates a new semaphore and initializes it with the value
// `initial_value`. Each wait operation on the semaphore will atomically
// decrement the semaphore value and potentially block if the semaphore value
// is 0. Each post operation will atomically increment the semaphore value and
// wake waiting threads and allow them to retry the wait operation.
//
// `initial_value` the starting value of the semaphore
// returns a new semaphore or NULL on failure; call SDL_GetError() for more
//          information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_DestroySemaphore
// See also: SDL_SemPost
// See also: SDL_SemTryWait
// See also: SDL_SemValue
// See also: SDL_SemWait
// See also: SDL_SemWaitTimeout
pub fn create_semaphore(initial_value u32) &Sem {
	return C.SDL_CreateSemaphore(initial_value)
}

fn C.SDL_DestroySemaphore(sem &C.SDL_sem)

// destroy_semaphore destroys a semaphore.
//
// It is not safe to destroy a semaphore if there are threads currently
// waiting on it.
//
// `sem` the semaphore to destroy
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateSemaphore
// See also: SDL_SemPost
// See also: SDL_SemTryWait
// See also: SDL_SemValue
// See also: SDL_SemWait
// See also: SDL_SemWaitTimeout
pub fn destroy_semaphore(sem &Sem) {
	C.SDL_DestroySemaphore(sem)
}

fn C.SDL_SemWait(sem &C.SDL_sem) int

// sem_wait waits until a semaphore has a positive value and then decrements it.
//
// This function suspends the calling thread until either the semaphore
// pointed to by `sem` has a positive value or the call is interrupted by a
// signal or error. If the call is successful it will atomically decrement the
// semaphore value.
//
// This function is the equivalent of calling SDL_SemWaitTimeout() with a time
// length of `SDL_MUTEX_MAXWAIT`.
//
// `sem` the semaphore wait on
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateSemaphore
// See also: SDL_DestroySemaphore
// See also: SDL_SemPost
// See also: SDL_SemTryWait
// See also: SDL_SemValue
// See also: SDL_SemWait
// See also: SDL_SemWaitTimeout
pub fn sem_wait(sem &Sem) int {
	return C.SDL_SemWait(sem)
}

fn C.SDL_SemTryWait(sem &C.SDL_sem) int

// sem_try_wait sees if a semaphore has a positive value and decrement it if it does.
//
// This function checks to see if the semaphore pointed to by `sem` has a
// positive value and atomically decrements the semaphore value if it does. If
// the semaphore doesn't have a positive value, the function immediately
// returns SDL_MUTEX_TIMEDOUT.
//
// `sem` the semaphore to wait on
// returns 0 if the wait succeeds, `SDL_MUTEX_TIMEDOUT` if the wait would
//          block, or a negative error code on failure; call SDL_GetError()
//          for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateSemaphore
// See also: SDL_DestroySemaphore
// See also: SDL_SemPost
// See also: SDL_SemValue
// See also: SDL_SemWait
// See also: SDL_SemWaitTimeout
pub fn sem_try_wait(sem &Sem) int {
	return C.SDL_SemTryWait(sem)
}

fn C.SDL_SemWaitTimeout(sem &C.SDL_sem, timeout u32) int

// sem_wait_timeout waits until a semaphore has a positive value and then decrements it.
//
// This function suspends the calling thread until either the semaphore
// pointed to by `sem` has a positive value, the call is interrupted by a
// signal or error, or the specified time has elapsed. If the call is
// successful it will atomically decrement the semaphore value.
//
// `sem` the semaphore to wait on
// `timeout` the length of the timeout, in milliseconds
// returns 0 if the wait succeeds, `SDL_MUTEX_TIMEDOUT` if the wait does not
//          succeed in the allotted time, or a negative error code on failure;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateSemaphore
// See also: SDL_DestroySemaphore
// See also: SDL_SemPost
// See also: SDL_SemTryWait
// See also: SDL_SemValue
// See also: SDL_SemWait
pub fn sem_wait_timeout(sem &Sem, timeout u32) int {
	return C.SDL_SemWaitTimeout(sem, timeout)
}

fn C.SDL_SemPost(sem &C.SDL_sem) int

// sem_post atomically increments a semaphore's value and wake waiting threads.
//
// `sem` the semaphore to increment
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateSemaphore
// See also: SDL_DestroySemaphore
// See also: SDL_SemTryWait
// See also: SDL_SemValue
// See also: SDL_SemWait
// See also: SDL_SemWaitTimeout
pub fn sem_post(sem &Sem) int {
	return C.SDL_SemPost(sem)
}

fn C.SDL_SemValue(sem &C.SDL_sem) u32

// sem_value gets the current value of a semaphore.
//
// `sem` the semaphore to query
// returns the current value of the semaphore.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CreateSemaphore
pub fn sem_value(sem &Sem) u32 {
	return C.SDL_SemValue(sem)
}

// Cond is the SDL condition variable structure, defined in SDL_syscond.c
// Cond is C.SDL_cond
[typedef]
pub struct C.SDL_cond {
}

pub type Cond = C.SDL_cond

fn C.SDL_CreateCond() &C.SDL_cond

// create_cond creates a condition variable.
//
// returns a new condition variable or NULL on failure; call SDL_GetError()
//          for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CondBroadcast
// See also: SDL_CondSignal
// See also: SDL_CondWait
// See also: SDL_CondWaitTimeout
// See also: SDL_DestroyCond
pub fn create_cond() &Cond {
	return C.SDL_CreateCond()
}

fn C.SDL_DestroyCond(cond &C.SDL_cond)

// destroy_cond destroys a condition variable.
//
// `cond` the condition variable to destroy
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CondBroadcast
// See also: SDL_CondSignal
// See also: SDL_CondWait
// See also: SDL_CondWaitTimeout
// See also: SDL_CreateCond
pub fn destroy_cond(cond &Cond) {
	C.SDL_DestroyCond(cond)
}

fn C.SDL_CondSignal(cond &C.SDL_cond) int

// cond_signal restarts one of the threads that are waiting on the condition variable.
//
// `cond` the condition variable to signal
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CondBroadcast
// See also: SDL_CondWait
// See also: SDL_CondWaitTimeout
// See also: SDL_CreateCond
// See also: SDL_DestroyCond
pub fn cond_signal(cond &Cond) int {
	return C.SDL_CondSignal(cond)
}

fn C.SDL_CondBroadcast(cond &C.SDL_cond) int

// cond_broadcast restarts all threads that are waiting on the condition variable.
//
// `cond` the condition variable to signal
// returns 0 on success or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CondSignal
// See also: SDL_CondWait
// See also: SDL_CondWaitTimeout
// See also: SDL_CreateCond
// See also: SDL_DestroyCond
pub fn cond_broadcast(cond &Cond) int {
	return C.SDL_CondBroadcast(cond)
}

fn C.SDL_CondWait(cond &C.SDL_cond, mutex &C.SDL_mutex) int

// cond_wait waits until a condition variable is signaled.
//
// This function unlocks the specified `mutex` and waits for another thread to
// call SDL_CondSignal() or SDL_CondBroadcast() on the condition variable
// `cond`. Once the condition variable is signaled, the mutex is re-locked and
// the function returns.
//
// The mutex must be locked before calling this function.
//
// This function is the equivalent of calling SDL_CondWaitTimeout() with a
// time length of `SDL_MUTEX_MAXWAIT`.
//
// `cond` the condition variable to wait on
// `mutex` the mutex used to coordinate thread access
// returns 0 when it is signaled or a negative error code on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CondBroadcast
// See also: SDL_CondSignal
// See also: SDL_CondWaitTimeout
// See also: SDL_CreateCond
// See also: SDL_DestroyCond
pub fn cond_wait(cond &Cond, mutex &Mutex) int {
	return C.SDL_CondWait(cond, mutex)
}

fn C.SDL_CondWaitTimeout(cond &C.SDL_cond, mutex &C.SDL_mutex, ms u32) int

// cond_wait_timeout waits until a condition variable is signaled or a certain time has passed.
//
// This function unlocks the specified `mutex` and waits for another thread to
// call SDL_CondSignal() or SDL_CondBroadcast() on the condition variable
// `cond`, or for the specified time to elapse. Once the condition variable is
// signaled or the time elapsed, the mutex is re-locked and the function
// returns.
//
// The mutex must be locked before calling this function.
//
// `cond` the condition variable to wait on
// `mutex` the mutex used to coordinate thread access
// `ms` the maximum time to wait, in milliseconds, or `SDL_MUTEX_MAXWAIT`
//           to wait indefinitely
// returns 0 if the condition variable is signaled, `SDL_MUTEX_TIMEDOUT` if
//          the condition is not signaled in the allotted time, or a negative
//          error code on failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_CondBroadcast
// See also: SDL_CondSignal
// See also: SDL_CondWait
// See also: SDL_CreateCond
// See also: SDL_DestroyCond
pub fn cond_wait_timeout(cond &Cond, mutex &Mutex, ms u32) int {
	return C.SDL_CondWaitTimeout(cond, mutex, ms)
}
