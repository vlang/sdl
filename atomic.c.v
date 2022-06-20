// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_atomic.h
//

// Atomic operations.
//
// IMPORTANT:
// If you are not an expert in concurrent lockless programming, you should
// only be using the atomic lock and reference counting functions in this
// file.  In all other cases you should be protecting your data structures
// with full mutexes.
//
// The list of "safe" functions to use are:
//  SDL_AtomicLock()
//  SDL_AtomicUnlock()
//  SDL_AtomicIncRef()
//  SDL_AtomicDecRef()
//
// Seriously, here be dragons!
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^
//
// You can find out a little more about lockless programming and the
// subtle issues that can arise here:
// http://msdn.microsoft.com/en-us/library/ee418650%28v=vs.85%29.aspx
//
// There's also lots of good information here:
// http://www.1024cores.net/home/lock-free-algorithms
// http://preshing.com/
//
// These operations may or may not actually be implemented using
// processor specific atomic operations. When possible they are
// implemented as true processor specific atomic operations. When that
// is not possible the are implemented using locks that *do* use the
// available atomic operations.
//
// All of the atomic operations that modify memory are full memory barriers.

// SDL AtomicLock
//
// The atomic locks are efficient spinlocks using CPU instructions,
// but are vulnerable to starvation and can spin forever if a thread
// holding a lock has been terminated.  For this reason you should
// minimize the code executed inside an atomic lock and never do
// expensive things like API or system calls while holding them.
//
// The atomic locks are not safe to lock recursively.
//
// Porting Note:
// The spin lock functions and type are required and can not be
// emulated because they are used in the atomic emulation code.

// `typedef int SDL_SpinLock;`
// SpinLock is C.SDL_SpinLock
pub type SpinLock = int

fn C.SDL_AtomicTryLock(lock_ &C.SDL_SpinLock) bool

// atomic_try_lock tries to lock a spin lock by setting it to a non-zero value.
//
// ***Please note that spinlocks are dangerous if you don't know what you're
// doing. Please be careful using any sort of spinlock!***
// `lock_` a pointer to a lock variable
//
// returns SDL_TRUE if the lock succeeded, SDL_FALSE if the lock is already held.
//
// See also: SDL_AtomicLock
// See also: SDL_AtomicUnlock
pub fn atomic_try_lock(lock_ &SpinLock) bool {
	return unsafe { C.SDL_AtomicTryLock(&C.SDL_SpinLock(lock_)) }
}

fn C.SDL_AtomicLock(lock_ &C.SDL_SpinLock)

// atomic_lock locks a spin lock by setting it to a non-zero value.
//
// ***Please note that spinlocks are dangerous if you don't know what you're
// doing. Please be careful using any sort of spinlock!***
//
// `lock_`  a pointer to a lock variable
//
// See also: SDL_AtomicTryLock
// See also: SDL_AtomicUnlock
pub fn atomic_lock(lock_ &SpinLock) {
	unsafe { C.SDL_AtomicLock(&C.SDL_SpinLock(lock_)) }
}

fn C.SDL_AtomicUnlock(lock_ &C.SDL_SpinLock)

// atomic_unlock unlocks a spin lock by setting it to 0.
//
// Always returns immediately.
//
// ***Please note that spinlocks are dangerous if you don't know what you're
// doing. Please be careful using any sort of spinlock!***
//
// `lock_` a pointer to a lock variable
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AtomicLock
// See also: SDL_AtomicTryLock
pub fn atomic_unlock(lock_ &SpinLock) {
	unsafe { C.SDL_AtomicUnlock(&C.SDL_SpinLock(lock_)) }
}

// Memory barriers are designed to prevent reads and writes from being
// reordered by the compiler and being seen out of order on multi-core CPUs.
//
// A typical pattern would be for thread A to write some data and a flag, and
// for thread B to read the flag and get the data. In this case you would
// insert a release barrier between writing the data and the flag,
// guaranteeing that the data write completes no later than the flag is
// written, and you would insert an acquire barrier between reading the flag
// and reading the data, to ensure that all the reads associated with the flag
// have completed.
//
// In this pattern you should always see a release barrier paired with an
// acquire barrier and you should gate the data reads/writes with a single
// flag variable.
//
// For more information on these semantics, take a look at the blog post:
// http://preshing.com/20120913/acquire-and-release-semantics
fn C.SDL_MemoryBarrierReleaseFunction()
pub fn memory_barrier_release_function() {
	C.SDL_MemoryBarrierReleaseFunction()
}

fn C.SDL_MemoryBarrierAcquireFunction()
pub fn memory_barrier_acquire_function() {
	C.SDL_MemoryBarrierAcquireFunction()
}

// AtomicT is a type representing an atomic integer value.  It is a struct
// so people don't accidentally use numeric operations on it.
[typedef]
pub struct C.SDL_atomic_t {
pub:
	value int
}

pub type AtomicT = C.SDL_atomic_t

fn C.SDL_AtomicCAS(a &C.SDL_atomic_t, oldval int, newval int) bool

// atomic_cas sets an atomic variable to a new value if it is currently an old value.
//
// NOTE If you don't know what this function is for, you shouldn't use it!
//
// `a` a pointer to an SDL_atomic_t variable to be modified
// `oldval` the old value
// `newval` the new value
// returns SDL_TRUE if the atomic variable was set, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.0.
// See also: SDL_AtomicCASPtr
// See also: SDL_AtomicGet
// See also: SDL_AtomicSet
pub fn atomic_cas(a &C.SDL_atomic_t, oldval int, newval int) bool {
	return unsafe { C.SDL_AtomicCAS(a, oldval, newval) }
}

fn C.SDL_AtomicSet(a &C.SDL_atomic_t, v int) int

// atomic_set sets an atomic variable to a value.
//
// This function also acts as a full memory barrier.
//
// NOTE If you don't know what this function is for, you shouldn't use
// it!
//
// `a` a pointer to an SDL_atomic_t variable to be modified
// `v` the desired value
// returns the previous value of the atomic variable.
//
// See also: SDL_AtomicGet
pub fn atomic_set(a &AtomicT, v int) int {
	return unsafe { C.SDL_AtomicSet(&C.SDL_atomic_t(a), v) }
}

fn C.SDL_AtomicGet(a &C.SDL_atomic_t) int

// atomic_get gets the value of an atomic variable.
//
// NOTE If you don't know what this function is for, you shouldn't use
// it!
//
// `a`  a pointer to an SDL_atomic_t variable
// returns the current value of an atomic variable.
//
// See also: SDL_AtomicSet
pub fn atomic_get(a &AtomicT) int {
	return unsafe { C.SDL_AtomicGet(&C.SDL_atomic_t(a)) }
}

fn C.SDL_AtomicAdd(a &C.SDL_atomic_t, v int) int

// atomic_add adds to an atomic variable.
//
// This function also acts as a full memory barrier.
//
// // NOTE If you don't know what this function is for, you shouldn't use
// it!
//
// `a` a pointer to an SDL_atomic_t variable to be modified
// `v` the desired value to add
// returns The previous value of the atomic variable.
//
// See also: SDL_AtomicDecRef
// See also: SDL_AtomicIncRef
pub fn atomic_add(a &AtomicT, v int) int {
	return unsafe { C.SDL_AtomicAdd(&C.SDL_atomic_t(a), v) }
}

fn C.SDL_AtomicIncRef(a &C.SDL_atomic_t) int

// atomic_inc_ref increments an atomic variable used as a reference count.
pub fn atomic_inc_ref(a &AtomicT) int {
	return unsafe { C.SDL_AtomicIncRef(&C.SDL_atomic_t(a)) }
}

fn C.SDL_AtomicDecRef(a &C.SDL_atomic_t) bool

// atomic_dec_ref decrements an atomic variable used as a reference count.
//
// returns SDL_TRUE if the variable reached zero after decrementing,
//         SDL_FALSE otherwise
//
// `a`'s C type is `void **a`
pub fn atomic_dec_ref(a &AtomicT) bool {
	return unsafe { C.SDL_AtomicDecRef(&C.SDL_atomic_t(a)) }
}

fn C.SDL_AtomicCASPtr(a voidptr, oldval voidptr, newval voidptr) bool

// atomic_cas_ptr sets a pointer to a new value if it is currently an old value.
//
// NOTE If you don't know what this function is for, you shouldn't use
// it!
//
// `a` a pointer to a pointer
// `oldval` the old pointer value
// `newval` the new pointer value
// returns SDL_TRUE if the pointer was set, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AtomicCAS
// See also: SDL_AtomicGetPtr
// See also: SDL_AtomicSetPtr
//
// `a`'s C type is `void **a`
pub fn atomic_cas_ptr(a voidptr, oldval voidptr, newval voidptr) bool {
	return C.SDL_AtomicCASPtr(a, oldval, newval)
}

fn C.SDL_AtomicSetPtr(a voidptr, v voidptr) voidptr

// atomic_set_ptr set a pointer to a value atomically.
//
// NOTE If you don't know what this function is for, you shouldn't use
// it!
//
// `a` a pointer to a pointer
// `v` the desired pointer value
// returns the previous value of the pointer.
//
// See also: SDL_AtomicCASPtr
// See also: SDL_AtomicGetPtr
//
// `a`'s C type is `void **a`
pub fn atomic_set_ptr(a voidptr, v voidptr) voidptr {
	return C.SDL_AtomicSetPtr(a, v)
}

fn C.SDL_AtomicGetPtr(a voidptr) voidptr

// atomic_get_ptr gets the value of a pointer atomically.
//
// `a`'s C type is `void **a`
pub fn atomic_get_ptr(a voidptr) voidptr {
	return C.SDL_AtomicGetPtr(a)
}
