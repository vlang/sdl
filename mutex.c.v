// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_mutex.h
//

// SDL offers several thread synchronization primitives. This document can't
// cover the complicated topic of thread safety, but reading up on what each
// of these primitives are, why they are useful, and how to correctly use them
// is vital to writing correct and safe multithreaded programs.
//
// - Mutexes: SDL_CreateMutex()
// - Read/Write locks: SDL_CreateRWLock()
// - Semaphores: SDL_CreateSemaphore()
// - Condition variables: SDL_CreateCondition()
//
// SDL also offers a datatype, SDL_InitState, which can be used to make sure
// only one thread initializes/deinitializes some resource that several
// threads might try to use for the first time simultaneously.

// TODO: Function: #define SDL_THREAD_ANNOTATION_ATTRIBUTE__(x)   __attribute__((x))

// TODO: Function: #define SDL_THREAD_ANNOTATION_ATTRIBUTE__(x)   __attribute__((x))

// TODO: Function: #define SDL_THREAD_ANNOTATION_ATTRIBUTE__(x)

// TODO: Non-numerical: #define SDL_CAPABILITY(x) \

// TODO: Non-numerical: #define SDL_SCOPED_CAPABILITY \

// TODO: Non-numerical: #define SDL_GUARDED_BY(x) \

// TODO: Non-numerical: #define SDL_PT_GUARDED_BY(x) \

// TODO: Non-numerical: #define SDL_ACQUIRED_BEFORE(x) \

// TODO: Non-numerical: #define SDL_ACQUIRED_AFTER(x) \

// TODO: Non-numerical: #define SDL_REQUIRES(x) \

// TODO: Non-numerical: #define SDL_REQUIRES_SHARED(x) \

// TODO: Non-numerical: #define SDL_ACQUIRE(x) \

// TODO: Non-numerical: #define SDL_ACQUIRE_SHARED(x) \

// TODO: Non-numerical: #define SDL_RELEASE(x) \

// TODO: Non-numerical: #define SDL_RELEASE_SHARED(x) \

// TODO: Non-numerical: #define SDL_RELEASE_GENERIC(x) \

// TODO: Non-numerical: #define SDL_TRY_ACQUIRE(x, y) \

// TODO: Non-numerical: #define SDL_TRY_ACQUIRE_SHARED(x, y) \

// TODO: Non-numerical: #define SDL_EXCLUDES(x) \

// TODO: Non-numerical: #define SDL_ASSERT_CAPABILITY(x) \

// TODO: Non-numerical: #define SDL_ASSERT_SHARED_CAPABILITY(x) \

// TODO: Non-numerical: #define SDL_RETURN_CAPABILITY(x) \

// TODO: Non-numerical: #define SDL_NO_THREAD_SAFETY_ANALYSIS \

@[noinit; typedef]
pub struct C.SDL_Mutex {
	// NOTE: Opaque type
}

pub type Mutex = C.SDL_Mutex

// C.SDL_CreateMutex [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateMutex)
fn C.SDL_CreateMutex() &Mutex

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
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_mutex (SDL_DestroyMutex)
// See also: lock_mutex (SDL_LockMutex)
// See also: try_lock_mutex (SDL_TryLockMutex)
// See also: unlock_mutex (SDL_UnlockMutex)
pub fn create_mutex() &Mutex {
	return C.SDL_CreateMutex()
}

// C.SDL_LockMutex [official documentation](https://wiki.libsdl.org/SDL3/SDL_LockMutex)
fn C.SDL_LockMutex(mutex &Mutex)

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
// This function does not fail; if mutex is NULL, it will return immediately
// having locked nothing. If the mutex is valid, this function will always
// block until it can lock the mutex, and return with it locked.
//
// `mutex` mutex the mutex to lock.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: try_lock_mutex (SDL_TryLockMutex)
// See also: unlock_mutex (SDL_UnlockMutex)
pub fn lock_mutex(mutex &Mutex) {
	C.SDL_LockMutex(mutex)
}

fn C.SDL_TryLockMutex(mutex &Mutex) bool

// try_lock_mutex tries to lock a mutex without blocking.
//
// This works just like SDL_LockMutex(), but if the mutex is not available,
// this function returns false immediately.
//
// This technique is useful if you need exclusive access to a resource but
// don't want to wait for it, and will return to it to try again later.
//
// This function returns true if passed a NULL mutex.
//
// `mutex` mutex the mutex to try to lock.
// returns true on success, false if the mutex would block.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_mutex (SDL_LockMutex)
// See also: unlock_mutex (SDL_UnlockMutex)
//
pub fn try_lock_mutex(mutex &Mutex) bool {
	return C.SDL_TryLockMutex(mutex)
}

// C.SDL_UnlockMutex [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnlockMutex)
fn C.SDL_UnlockMutex(mutex &Mutex)

// unlock_mutex unlocks the mutex.
//
// It is legal for the owning thread to lock an already-locked mutex. It must
// unlock it the same number of times before it is actually made available for
// other threads in the system (this is known as a "recursive mutex").
//
// It is illegal to unlock a mutex that has not been locked by the current
// thread, and doing so results in undefined behavior.
//
// `mutex` mutex the mutex to unlock.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_mutex (SDL_LockMutex)
// See also: try_lock_mutex (SDL_TryLockMutex)
pub fn unlock_mutex(mutex &Mutex) {
	C.SDL_UnlockMutex(mutex)
}

// C.SDL_DestroyMutex [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyMutex)
fn C.SDL_DestroyMutex(mutex &Mutex)

// destroy_mutex destroys a mutex created with SDL_CreateMutex().
//
// This function must be called on any mutex that is no longer needed. Failure
// to destroy a mutex will result in a system memory or resource leak. While
// it is safe to destroy a mutex that is _unlocked_, it is not safe to attempt
// to destroy a locked mutex, and may result in undefined behavior depending
// on the platform.
//
// `mutex` mutex the mutex to destroy.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_mutex (SDL_CreateMutex)
pub fn destroy_mutex(mutex &Mutex) {
	C.SDL_DestroyMutex(mutex)
}

@[noinit; typedef]
pub struct C.SDL_RWLock {
	// NOTE: Opaque type
}

pub type RWLock = C.SDL_RWLock

// C.SDL_CreateRWLock [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateRWLock)
fn C.SDL_CreateRWLock() &RWLock

// create_rw_lock creates a new read/write lock.
//
// A read/write lock is useful for situations where you have multiple threads
// trying to access a resource that is rarely updated. All threads requesting
// a read-only lock will be allowed to run in parallel; if a thread requests a
// write lock, it will be provided exclusive access. This makes it safe for
// multiple threads to use a resource at the same time if they promise not to
// change it, and when it has to be changed, the rwlock will serve as a
// gateway to make sure those changes can be made safely.
//
// In the right situation, a rwlock can be more efficient than a mutex, which
// only lets a single thread proceed at a time, even if it won't be modifying
// the data.
//
// All newly-created read/write locks begin in the _unlocked_ state.
//
// Calls to SDL_LockRWLockForReading() and SDL_LockRWLockForWriting will not
// return while the rwlock is locked _for writing_ by another thread. See
// SDL_TryLockRWLockForReading() and SDL_TryLockRWLockForWriting() to attempt
// to lock without blocking.
//
// SDL read/write locks are only recursive for read-only locks! They are not
// guaranteed to be fair, or provide access in a FIFO manner! They are not
// guaranteed to favor writers. You may not lock a rwlock for both read-only
// and write access at the same time from the same thread (so you can't
// promote your read-only lock to a write lock without unlocking first).
//
// returns the initialized and unlocked read/write lock or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_rw_lock (SDL_DestroyRWLock)
// See also: lock_rw_lock_for_reading (SDL_LockRWLockForReading)
// See also: lock_rw_lock_for_writing (SDL_LockRWLockForWriting)
// See also: try_lock_rw_lock_for_reading (SDL_TryLockRWLockForReading)
// See also: try_lock_rw_lock_for_writing (SDL_TryLockRWLockForWriting)
// See also: unlock_rw_lock (SDL_UnlockRWLock)
pub fn create_rw_lock() &RWLock {
	return C.SDL_CreateRWLock()
}

// C.SDL_LockRWLockForReading [official documentation](https://wiki.libsdl.org/SDL3/SDL_LockRWLockForReading)
fn C.SDL_LockRWLockForReading(rwlock &RWLock)

// lock_rw_lock_for_reading locks the read/write lock for _read only_ operations.
//
// This will block until the rwlock is available, which is to say it is not
// locked for writing by any other thread. Of all threads waiting to lock the
// rwlock, all may do so at the same time as long as they are requesting
// read-only access; if a thread wants to lock for writing, only one may do so
// at a time, and no other threads, read-only or not, may hold the lock at the
// same time.
//
// It is legal for the owning thread to lock an already-locked rwlock for
// reading. It must unlock it the same number of times before it is actually
// made available for other threads in the system (this is known as a
// "recursive rwlock").
//
// Note that locking for writing is not recursive (this is only available to
// read-only locks).
//
// It is illegal to request a read-only lock from a thread that already holds
// the write lock. Doing so results in undefined behavior. Unlock the write
// lock before requesting a read-only lock. (But, of course, if you have the
// write lock, you don't need further locks to read in any case.)
//
// This function does not fail; if rwlock is NULL, it will return immediately
// having locked nothing. If the rwlock is valid, this function will always
// block until it can lock the mutex, and return with it locked.
//
// `rwlock` rwlock the read/write lock to lock.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_rw_lock_for_writing (SDL_LockRWLockForWriting)
// See also: try_lock_rw_lock_for_reading (SDL_TryLockRWLockForReading)
// See also: unlock_rw_lock (SDL_UnlockRWLock)
pub fn lock_rw_lock_for_reading(rwlock &RWLock) {
	C.SDL_LockRWLockForReading(rwlock)
}

// C.SDL_LockRWLockForWriting [official documentation](https://wiki.libsdl.org/SDL3/SDL_LockRWLockForWriting)
fn C.SDL_LockRWLockForWriting(rwlock &RWLock)

// lock_rw_lock_for_writing locks the read/write lock for _write_ operations.
//
// This will block until the rwlock is available, which is to say it is not
// locked for reading or writing by any other thread. Only one thread may hold
// the lock when it requests write access; all other threads, whether they
// also want to write or only want read-only access, must wait until the
// writer thread has released the lock.
//
// It is illegal for the owning thread to lock an already-locked rwlock for
// writing (read-only may be locked recursively, writing can not). Doing so
// results in undefined behavior.
//
// It is illegal to request a write lock from a thread that already holds a
// read-only lock. Doing so results in undefined behavior. Unlock the
// read-only lock before requesting a write lock.
//
// This function does not fail; if rwlock is NULL, it will return immediately
// having locked nothing. If the rwlock is valid, this function will always
// block until it can lock the mutex, and return with it locked.
//
// `rwlock` rwlock the read/write lock to lock.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_rw_lock_for_reading (SDL_LockRWLockForReading)
// See also: try_lock_rw_lock_for_writing (SDL_TryLockRWLockForWriting)
// See also: unlock_rw_lock (SDL_UnlockRWLock)
pub fn lock_rw_lock_for_writing(rwlock &RWLock) {
	C.SDL_LockRWLockForWriting(rwlock)
}

// C.SDL_TryLockRWLockForReading [official documentation](https://wiki.libsdl.org/SDL3/SDL_TryLockRWLockForReading)
fn C.SDL_TryLockRWLockForReading(rwlock &RWLock) bool

// try_lock_rw_lock_for_reading tries to lock a read/write lock _for reading_ without blocking.
//
// This works just like SDL_LockRWLockForReading(), but if the rwlock is not
// available, then this function returns false immediately.
//
// This technique is useful if you need access to a resource but don't want to
// wait for it, and will return to it to try again later.
//
// Trying to lock for read-only access can succeed if other threads are
// holding read-only locks, as this won't prevent access.
//
// This function returns true if passed a NULL rwlock.
//
// `rwlock` rwlock the rwlock to try to lock.
// returns true on success, false if the lock would block.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_rw_lock_for_reading (SDL_LockRWLockForReading)
// See also: try_lock_rw_lock_for_writing (SDL_TryLockRWLockForWriting)
// See also: unlock_rw_lock (SDL_UnlockRWLock)
//
pub fn try_lock_rw_lock_for_reading(rwlock &RWLock) bool {
  return C.SDL_TryLockRWLockForReading(rwlock)
}

// C.SDL_TryLockRWLockForWriting [official documentation](https://wiki.libsdl.org/SDL3/SDL_TryLockRWLockForWriting)
fn C.SDL_TryLockRWLockForWriting(rwlock &RWLock) bool

// try_lock_rw_lock_for_writing tries to lock a read/write lock _for writing_ without blocking.
//
// This works just like SDL_LockRWLockForWriting(), but if the rwlock is not
// available, then this function returns false immediately.
//
// This technique is useful if you need exclusive access to a resource but
// don't want to wait for it, and will return to it to try again later.
//
// It is illegal for the owning thread to lock an already-locked rwlock for
// writing (read-only may be locked recursively, writing can not). Doing so
// results in undefined behavior.
//
// It is illegal to request a write lock from a thread that already holds a
// read-only lock. Doing so results in undefined behavior. Unlock the
// read-only lock before requesting a write lock.
//
// This function returns true if passed a NULL rwlock.
//
// `rwlock` rwlock the rwlock to try to lock.
// returns true on success, false if the lock would block.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_rw_lock_for_writing (SDL_LockRWLockForWriting)
// See also: try_lock_rw_lock_for_reading (SDL_TryLockRWLockForReading)
// See also: unlock_rw_lock (SDL_UnlockRWLock)
//
pub fn try_lock_rw_lock_for_writing(rwlock &RWLock) bool {
 return C.SDL_TryLockRWLockForWriting(rwlock)
}

// C.SDL_UnlockRWLock [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnlockRWLock)
fn C.SDL_UnlockRWLock(rwlock &RWLock) 

// unlock_rw_lock unlocks the read/write lock.
//
// Use this function to unlock the rwlock, whether it was locked for read-only
// or write operations.
//
// It is legal for the owning thread to lock an already-locked read-only lock.
// It must unlock it the same number of times before it is actually made
// available for other threads in the system (this is known as a "recursive
// rwlock").
//
// It is illegal to unlock a rwlock that has not been locked by the current
// thread, and doing so results in undefined behavior.
//
// `rwlock` rwlock the rwlock to unlock.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_rw_lock_for_reading (SDL_LockRWLockForReading)
// See also: lock_rw_lock_for_writing (SDL_LockRWLockForWriting)
// See also: try_lock_rw_lock_for_reading (SDL_TryLockRWLockForReading)
// See also: try_lock_rw_lock_for_writing (SDL_TryLockRWLockForWriting)
pub fn unlock_rw_lock(rwlock &RWLock) {
	C.SDL_UnlockRWLock(rwlock)
}

// C.SDL_DestroyRWLock [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyRWLock)
fn C.SDL_DestroyRWLock(rwlock &RWLock)

// destroy_rw_lock destroys a read/write lock created with SDL_CreateRWLock().
//
// This function must be called on any read/write lock that is no longer
// needed. Failure to destroy a rwlock will result in a system memory or
// resource leak. While it is safe to destroy a rwlock that is _unlocked_, it
// is not safe to attempt to destroy a locked rwlock, and may result in
// undefined behavior depending on the platform.
//
// `rwlock` rwlock the rwlock to destroy.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_rw_lock (SDL_CreateRWLock)
pub fn destroy_rw_lock(rwlock &RWLock) {
	C.SDL_DestroyRWLock(rwlock)
}

@[noinit; typedef]
pub struct C.SDL_Semaphore {
	// NOTE: Opaque type
}

pub type Semaphore = C.SDL_Semaphore

// C.SDL_CreateSemaphore [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateSemaphore)
fn C.SDL_CreateSemaphore(initial_value u32) &Semaphore

// create_semaphore creates a semaphore.
//
// This function creates a new semaphore and initializes it with the value
// `initial_value`. Each wait operation on the semaphore will atomically
// decrement the semaphore value and potentially block if the semaphore value
// is 0. Each post operation will atomically increment the semaphore value and
// wake waiting threads and allow them to retry the wait operation.
//
// `initial_value` initial_value the starting value of the semaphore.
// returns a new semaphore or NULL on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_semaphore (SDL_DestroySemaphore)
// See also: signal_semaphore (SDL_SignalSemaphore)
// See also: try_wait_semaphore (SDL_TryWaitSemaphore)
// See also: get_semaphore_value (SDL_GetSemaphoreValue)
// See also: wait_semaphore (SDL_WaitSemaphore)
// See also: wait_semaphore_timeout (SDL_WaitSemaphoreTimeout)
pub fn create_semaphore(initial_value u32) &Semaphore {
	return C.SDL_CreateSemaphore(initial_value)
}

// C.SDL_DestroySemaphore [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroySemaphore)
fn C.SDL_DestroySemaphore(sem &Semaphore)

// destroy_semaphore destroys a semaphore.
//
// It is not safe to destroy a semaphore if there are threads currently
// waiting on it.
//
// `sem` sem the semaphore to destroy.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_semaphore (SDL_CreateSemaphore)
pub fn destroy_semaphore(sem &Semaphore) {
	C.SDL_DestroySemaphore(sem)
}

// C.SDL_WaitSemaphore [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitSemaphore)
fn C.SDL_WaitSemaphore(sem &Semaphore)

// wait_semaphore waits until a semaphore has a positive value and then decrements it.
//
// This function suspends the calling thread until the semaphore pointed to by
// `sem` has a positive value, and then atomically decrement the semaphore
// value.
//
// This function is the equivalent of calling SDL_WaitSemaphoreTimeout() with
// a time length of -1.
//
// `sem` sem the semaphore wait on.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: signal_semaphore (SDL_SignalSemaphore)
// See also: try_wait_semaphore (SDL_TryWaitSemaphore)
// See also: wait_semaphore_timeout (SDL_WaitSemaphoreTimeout)
pub fn wait_semaphore(sem &Semaphore) {
	C.SDL_WaitSemaphore(sem)
}

// C.SDL_TryWaitSemaphore [official documentation](https://wiki.libsdl.org/SDL3/SDL_TryWaitSemaphore)
fn C.SDL_TryWaitSemaphore(sem &Semaphore) bool

// try_wait_semaphore sees if a semaphore has a positive value and decrement it if it does.
//
// This function checks to see if the semaphore pointed to by `sem` has a
// positive value and atomically decrements the semaphore value if it does. If
// the semaphore doesn't have a positive value, the function immediately
// returns false.
//
// `sem` sem the semaphore to wait on.
// returns true if the wait succeeds, false if the wait would block.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: signal_semaphore (SDL_SignalSemaphore)
// See also: wait_semaphore (SDL_WaitSemaphore)
// See also: wait_semaphore_timeout (SDL_WaitSemaphoreTimeout)
pub fn try_wait_semaphore(sem &Semaphore) bool {
	return C.SDL_TryWaitSemaphore(sem)
}

// C.SDL_WaitSemaphoreTimeout [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitSemaphoreTimeout)
fn C.SDL_WaitSemaphoreTimeout(sem &Semaphore, timeout_ms i32) bool

// wait_semaphore_timeout waits until a semaphore has a positive value and then decrements it.
//
// This function suspends the calling thread until either the semaphore
// pointed to by `sem` has a positive value or the specified time has elapsed.
// If the call is successful it will atomically decrement the semaphore value.
//
// `sem` sem the semaphore to wait on.
// `timeout_ms` timeoutMS the length of the timeout, in milliseconds, or -1 to wait
//                  indefinitely.
// returns true if the wait succeeds or false if the wait times out.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: signal_semaphore (SDL_SignalSemaphore)
// See also: try_wait_semaphore (SDL_TryWaitSemaphore)
// See also: wait_semaphore (SDL_WaitSemaphore)
pub fn wait_semaphore_timeout(sem &Semaphore, timeout_ms i32) bool {
	return C.SDL_WaitSemaphoreTimeout(sem, timeout_ms)
}

// C.SDL_SignalSemaphore [official documentation](https://wiki.libsdl.org/SDL3/SDL_SignalSemaphore)
fn C.SDL_SignalSemaphore(sem &Semaphore)

// signal_semaphore atomicallys increment a semaphore's value and wake waiting threads.
//
// `sem` sem the semaphore to increment.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: try_wait_semaphore (SDL_TryWaitSemaphore)
// See also: wait_semaphore (SDL_WaitSemaphore)
// See also: wait_semaphore_timeout (SDL_WaitSemaphoreTimeout)
pub fn signal_semaphore(sem &Semaphore) {
	C.SDL_SignalSemaphore(sem)
}

// C.SDL_GetSemaphoreValue [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSemaphoreValue)
fn C.SDL_GetSemaphoreValue(sem &Semaphore) u32

// get_semaphore_value gets the current value of a semaphore.
//
// `sem` sem the semaphore to query.
// returns the current value of the semaphore.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_semaphore_value(sem &Semaphore) u32 {
	return C.SDL_GetSemaphoreValue(sem)
}

@[noinit; typedef]
pub struct C.SDL_Condition {
	// NOTE: Opaque type
}

pub type Condition = C.SDL_Condition

// C.SDL_CreateCondition [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateCondition)
fn C.SDL_CreateCondition() &Condition

// create_condition creates a condition variable.
//
// returns a new condition variable or NULL on failure; call SDL_GetError()
//          for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: broadcast_condition (SDL_BroadcastCondition)
// See also: signal_condition (SDL_SignalCondition)
// See also: wait_condition (SDL_WaitCondition)
// See also: wait_condition_timeout (SDL_WaitConditionTimeout)
// See also: destroy_condition (SDL_DestroyCondition)
pub fn create_condition() &Condition {
	return C.SDL_CreateCondition()
}

// C.SDL_DestroyCondition [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyCondition)
fn C.SDL_DestroyCondition(cond &Condition)

// destroy_condition destroys a condition variable.
//
// `cond` cond the condition variable to destroy.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_condition (SDL_CreateCondition)
pub fn destroy_condition(cond &Condition) {
	C.SDL_DestroyCondition(cond)
}

// C.SDL_SignalCondition [official documentation](https://wiki.libsdl.org/SDL3/SDL_SignalCondition)
fn C.SDL_SignalCondition(cond &Condition)

// signal_condition restarts one of the threads that are waiting on the condition variable.
//
// `cond` cond the condition variable to signal.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: broadcast_condition (SDL_BroadcastCondition)
// See also: wait_condition (SDL_WaitCondition)
// See also: wait_condition_timeout (SDL_WaitConditionTimeout)
pub fn signal_condition(cond &Condition) {
	C.SDL_SignalCondition(cond)
}

// C.SDL_BroadcastCondition [official documentation](https://wiki.libsdl.org/SDL3/SDL_BroadcastCondition)
fn C.SDL_BroadcastCondition(cond &Condition)

// broadcast_condition restarts all threads that are waiting on the condition variable.
//
// `cond` cond the condition variable to signal.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: signal_condition (SDL_SignalCondition)
// See also: wait_condition (SDL_WaitCondition)
// See also: wait_condition_timeout (SDL_WaitConditionTimeout)
pub fn broadcast_condition(cond &Condition) {
	C.SDL_BroadcastCondition(cond)
}

// C.SDL_WaitCondition [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitCondition)
fn C.SDL_WaitCondition(cond &Condition, mutex &Mutex)

// wait_condition waits until a condition variable is signaled.
//
// This function unlocks the specified `mutex` and waits for another thread to
// call SDL_SignalCondition() or SDL_BroadcastCondition() on the condition
// variable `cond`. Once the condition variable is signaled, the mutex is
// re-locked and the function returns.
//
// The mutex must be locked before calling this function. Locking the mutex
// recursively (more than once) is not supported and leads to undefined
// behavior.
//
// This function is the equivalent of calling SDL_WaitConditionTimeout() with
// a time length of -1.
//
// `cond` cond the condition variable to wait on.
// `mutex` mutex the mutex used to coordinate thread access.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: broadcast_condition (SDL_BroadcastCondition)
// See also: signal_condition (SDL_SignalCondition)
// See also: wait_condition_timeout (SDL_WaitConditionTimeout)
pub fn wait_condition(cond &Condition, mutex &Mutex) {
	C.SDL_WaitCondition(cond, mutex)
}

// C.SDL_WaitConditionTimeout [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitConditionTimeout)
fn C.SDL_WaitConditionTimeout(cond &Condition, mutex &Mutex, timeout_ms int) bool

// wait_condition_timeout waits until a condition variable is signaled or a certain time has passed.
//
// This function unlocks the specified `mutex` and waits for another thread to
// call SDL_SignalCondition() or SDL_BroadcastCondition() on the condition
// variable `cond`, or for the specified time to elapse. Once the condition
// variable is signaled or the time elapsed, the mutex is re-locked and the
// function returns.
//
// The mutex must be locked before calling this function. Locking the mutex
// recursively (more than once) is not supported and leads to undefined
// behavior.
//
// `cond` cond the condition variable to wait on.
// `mutex` mutex the mutex used to coordinate thread access.
// `timeout_ms` timeoutMS the maximum time to wait, in milliseconds, or -1 to wait
//                  indefinitely.
// returns true if the condition variable is signaled, false if the condition
//          is not signaled in the allotted time.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: broadcast_condition (SDL_BroadcastCondition)
// See also: signal_condition (SDL_SignalCondition)
// See also: wait_condition (SDL_WaitCondition)
pub fn wait_condition_timeout(cond &Condition, mutex &Mutex, timeout_ms int) bool {
	return C.SDL_WaitConditionTimeout(cond, mutex, timeout_ms)
}

// InitStatus is C.SDL_InitStatus
pub enum InitStatus {
	uninitialized  = C.SDL_INIT_STATUS_UNINITIALIZED
	initializing   = C.SDL_INIT_STATUS_INITIALIZING
	initialized    = C.SDL_INIT_STATUS_INITIALIZED
	uninitializing = C.SDL_INIT_STATUS_UNINITIALIZING
}

@[typedef]
pub struct C.SDL_InitState {
pub mut:
	status   AtomicInt
	thread   ThreadID
	reserved voidptr
}

pub type InitState = C.SDL_InitState

// C.SDL_ShouldInit [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShouldInit)
fn C.SDL_ShouldInit(state &InitState) bool

// should_init returns whether initialization should be done.
//
// This function checks the passed in state and if initialization should be
// done, sets the status to `SDL_INIT_STATUS_INITIALIZING` and returns true.
// If another thread is already modifying this state, it will wait until
// that's done before returning.
//
// If this function returns true, the calling code must call
// SDL_SetInitialized() to complete the initialization.
//
// `state` state the initialization state to check.
// returns true if initialization needs to be done, false otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_initialized (SDL_SetInitialized)
// See also: should_quit (SDL_ShouldQuit)
pub fn should_init(state &InitState) bool {
	return C.SDL_ShouldInit(state)
}

// C.SDL_ShouldQuit [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShouldQuit)
fn C.SDL_ShouldQuit(state &InitState) bool

// should_quit returns whether cleanup should be done.
//
// This function checks the passed in state and if cleanup should be done,
// sets the status to `SDL_INIT_STATUS_UNINITIALIZING` and returns true.
//
// If this function returns true, the calling code must call
// SDL_SetInitialized() to complete the cleanup.
//
// `state` state the initialization state to check.
// returns true if cleanup needs to be done, false otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_initialized (SDL_SetInitialized)
// See also: should_init (SDL_ShouldInit)
pub fn should_quit(state &InitState) bool {
	return C.SDL_ShouldQuit(state)
}

// C.SDL_SetInitialized [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetInitialized)
fn C.SDL_SetInitialized(state &InitState, initialized bool)

// set_initialized finishs an initialization state transition.
//
// This function sets the status of the passed in state to
// `SDL_INIT_STATUS_INITIALIZED` or `SDL_INIT_STATUS_UNINITIALIZED` and allows
// any threads waiting for the status to proceed.
//
// `state` state the initialization state to check.
// `initialized` initialized the new initialization state.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: should_init (SDL_ShouldInit)
// See also: should_quit (SDL_ShouldQuit)
pub fn set_initialized(state &InitState, initialized bool) {
	C.SDL_SetInitialized(state, initialized)
}
