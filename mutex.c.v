// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_mutex.h
//

// mutex_timeout. Synchronization functions which can time out return this value
// if they time out.
pub const mutex_timeout = C.SDL_MUTEX_TIMEDOUT

// 1

// mutex_maxwait is the timeout value which corresponds to never time out.
pub const mutex_maxwait = C.SDL_MUTEX_MAXWAIT

// (~(Uint32)0)

// Mutex is the SDL mutex structure, defined in SDL_sysmutex.c
// Mutex is C.SDL_mutex
@[noinit; typedef]
pub struct C.SDL_mutex {
}

pub type Mutex = C.SDL_mutex

fn C.SDL_CreateMutex() &C.SDL_mutex

// create_mutex creates a mutex, initialized unlocked.
pub fn create_mutex() &C.SDL_mutex {
	return C.SDL_CreateMutex()
}

fn C.SDL_LockMutex(mutex &C.SDL_mutex) int

// lock_mutex locks the mutex.
//
// returns 0, or -1 on error.
pub fn lock_mutex(mutex &Mutex) int {
	return C.SDL_LockMutex(mutex)
}

fn C.SDL_TryLockMutex(mutex &C.SDL_mutex) int

// try_lock_mutex tries to lock the mutex
//
// returns 0, SDL_MUTEX_TIMEDOUT, or -1 on error
pub fn try_lock_mutex(mutex &Mutex) int {
	return C.SDL_TryLockMutex(mutex)
}

fn C.SDL_UnlockMutex(mutex &C.SDL_mutex) int

// unlock_mutex unlocks the mutex.
//
// returns 0, or -1 on error.
//
// WARNING It is an error to unlock a mutex that has not been locked by
//          the current thread, and doing so results in undefined behavior.
pub fn unlock_mutex(mutex &Mutex) int {
	return C.SDL_UnlockMutex(mutex)
}

fn C.SDL_DestroyMutex(mutex &C.SDL_mutex)

// destroy_mutex destroys a mutex.
pub fn destroy_mutex(mutex &Mutex) {
	C.SDL_DestroyMutex(mutex)
}

// Sem is the SDL semaphore structure, defined in SDL_syssem.c
// Sem is C.SDL_sem
@[noinit; typedef]
pub struct C.SDL_sem {
}

pub type Sem = C.SDL_sem

fn C.SDL_CreateSemaphore(initial_value u32) &C.SDL_sem

// create_semaphore creates a semaphore, initialized with value, returns NULL on failure.
pub fn create_semaphore(initial_value u32) &Sem {
	return C.SDL_CreateSemaphore(initial_value)
}

fn C.SDL_DestroySemaphore(sem &C.SDL_sem)

// destroy_semaphore destroys a semaphore.
pub fn destroy_semaphore(sem &Sem) {
	C.SDL_DestroySemaphore(sem)
}

fn C.SDL_SemWait(sem &C.SDL_sem) int

// sem_wait this function suspends the calling thread until the semaphore pointed
// to by `sem` has a positive count. It then atomically decreases the
// semaphore count.
pub fn sem_wait(sem &Sem) int {
	return C.SDL_SemWait(sem)
}

fn C.SDL_SemTryWait(sem &C.SDL_sem) int

// sem_try_wait is a non-blocking variant of SDL_SemWait().
//
// returns 0 if the wait succeeds, ::SDL_MUTEX_TIMEDOUT if the wait would
//         block, and -1 on error.
pub fn sem_try_wait(sem &Sem) int {
	return C.SDL_SemTryWait(sem)
}

fn C.SDL_SemWaitTimeout(sem &C.SDL_sem, ms u32) int

// sem_wait_timeout variants of SDL_SemWait() with a timeout in milliseconds.
//
// returns 0 if the wait succeeds, ::SDL_MUTEX_TIMEDOUT if the wait does not
//         succeed in the allotted time, and -1 on error.
//
// WARNING On some platforms this function is implemented by looping with a
//          delay of 1 ms, and so should be avoided if possible.
pub fn sem_wait_timeout(sem &Sem, ms u32) int {
	return C.SDL_SemWaitTimeout(sem, ms)
}

fn C.SDL_SemPost(sem &C.SDL_sem) int

// sem_post atomically increases the semaphore's count (not blocking).
//
// returns 0, or -1 on error.
pub fn sem_post(sem &Sem) int {
	return C.SDL_SemPost(sem)
}

fn C.SDL_SemValue(sem &C.SDL_sem) u32

// sem_value returns the current count of the semaphore.
pub fn sem_value(sem &Sem) u32 {
	return C.SDL_SemValue(sem)
}

// Cond is the SDL condition variable structure, defined in SDL_syscond.c
// Cond is C.SDL_cond
@[noinit; typedef]
pub struct C.SDL_cond {
}

pub type Cond = C.SDL_cond

fn C.SDL_CreateCond() &C.SDL_cond

// create_cond creates a condition variable.
//
// Typical use of condition variables:
//
// Thread A:
//   SDL_LockMutex(lock);
//   while ( ! condition ) {
//       SDL_CondWait(cond, lock);
//   }
//   SDL_UnlockMutex(lock);
//
// Thread B:
//   SDL_LockMutex(lock);
//   ...
//   condition = true;
//   ...
//   SDL_CondSignal(cond);
//   SDL_UnlockMutex(lock);
//
// There is some discussion whether to signal the condition variable
// with the mutex locked or not.  There is some potential performance
// benefit to unlocking first on some platforms, but there are some
// potential race conditions depending on how your code is structured.
//
// In general it's safer to signal the condition variable while the
// mutex is locked.
pub fn create_cond() &Cond {
	return C.SDL_CreateCond()
}

fn C.SDL_DestroyCond(cond &C.SDL_cond)

// destroy_cond destroys a condition variable.
pub fn destroy_cond(cond &Cond) {
	C.SDL_DestroyCond(cond)
}

fn C.SDL_CondSignal(cond &C.SDL_cond) int

// cond_signal restarts one of the threads that are waiting on the condition variable.
//
// returns 0 or -1 on error.
pub fn cond_signal(cond &Cond) int {
	return C.SDL_CondSignal(cond)
}

fn C.SDL_CondBroadcast(cond &C.SDL_cond) int

// cond_broadcast restarts all threads that are waiting on the condition variable.
//
// returns 0 or -1 on error.
pub fn cond_broadcast(cond &Cond) int {
	return C.SDL_CondBroadcast(cond)
}

fn C.SDL_CondWait(cond &C.SDL_cond, mutex &C.SDL_mutex) int

// cond_wait waits on the condition variable, unlocking the provided mutex.
//
// WARNING The mutex must be locked before entering this function!
//
// The mutex is re-locked once the condition variable is signaled.
//
// returns 0 when it is signaled, or -1 on error.
pub fn cond_wait(cond &Cond, mutex &Mutex) int {
	return C.SDL_CondWait(cond, mutex)
}

fn C.SDL_CondWaitTimeout(cond &C.SDL_cond, mutex &C.SDL_mutex, ms u32) int

// cond_wait_timeout waits for at most `ms` milliseconds, and returns 0 if the condition
// variable is signaled, ::SDL_MUTEX_TIMEDOUT if the condition is not
// signaled in the allotted time, and -1 on error.
//
// WARNING On some platforms this function is implemented by looping with a
//          delay of 1 ms, and so should be avoided if possible.
pub fn cond_wait_timeout(cond &Cond, mutex &Mutex, ms u32) int {
	return C.SDL_CondWaitTimeout(cond, mutex, ms)
}
