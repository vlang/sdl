// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_atomic.h
//

// Atomic operations.
//
// IMPORTANT: If you are not an expert in concurrent lockless programming, you
// should not be using any functions in this file. You should be protecting
// your data structures with full mutexes instead.
//
// ***Seriously, here be dragons!***
//
// You can find out a little more about lockless programming and the subtle
// issues that can arise here:
// https://learn.microsoft.com/en-us/windows/win32/dxtecharts/lockless-programming
//
// There's also lots of good information here:
//
// - https://www.1024cores.net/home/lock-free-algorithms
// - https://preshing.com/
//
// These operations may or may not actually be implemented using processor
// specific atomic operations. When possible they are implemented as true
// processor specific atomic operations. When that is not possible the are
// implemented using locks that *do* use the available atomic operations.
//
// All of the atomic operations that modify memory are full memory barriers.

// An atomic spinlock.
//
// The atomic locks are efficient spinlocks using CPU instructions, but are
// vulnerable to starvation and can spin forever if a thread holding a lock
// has been terminated. For this reason you should minimize the code executed
// inside an atomic lock and never do expensive things like API or system
// calls while holding them.
//
// They are also vulnerable to starvation if the thread holding the lock is
// lower priority than other threads and doesn't get scheduled. In general you
// should use mutexes instead, since they have better performance and
// contention behavior.
//
// The atomic locks are not safe to lock recursively.
//
// Porting Note: The spin lock functions and type are required and can not be
// emulated because they are used in the atomic emulation code.
pub type SpinLock = int

// C.SDL_TryLockSpinlock [official documentation](https://wiki.libsdl.org/SDL3/SDL_TryLockSpinlock)
fn C.SDL_TryLockSpinlock(@lock &int) bool

// try_lock_spinlock tries to lock a spin lock by setting it to a non-zero value.
//
// ***Please note that spinlocks are dangerous if you don't know what you're
// doing. Please be careful using any sort of spinlock!***
//
// `lock` lock a pointer to a lock variable.
// returns true if the lock succeeded, false if the lock is already held.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_spinlock (SDL_LockSpinlock)
// See also: unlock_spinlock (SDL_UnlockSpinlock)
pub fn try_lock_spinlock(@lock &int) bool {
	return C.SDL_TryLockSpinlock(@lock)
}

// C.SDL_LockSpinlock [official documentation](https://wiki.libsdl.org/SDL3/SDL_LockSpinlock)
fn C.SDL_LockSpinlock(@lock &int)

// lock_spinlock locks a spin lock by setting it to a non-zero value.
//
// ***Please note that spinlocks are dangerous if you don't know what you're
// doing. Please be careful using any sort of spinlock!***
//
// `lock` lock a pointer to a lock variable.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: try_lock_spinlock (SDL_TryLockSpinlock)
// See also: unlock_spinlock (SDL_UnlockSpinlock)
pub fn lock_spinlock(@lock &int) {
	C.SDL_LockSpinlock(@lock)
}

// C.SDL_UnlockSpinlock [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnlockSpinlock)
fn C.SDL_UnlockSpinlock(@lock &int)

// unlock_spinlock unlocks a spin lock by setting it to 0.
//
// Always returns immediately.
//
// ***Please note that spinlocks are dangerous if you don't know what you're
// doing. Please be careful using any sort of spinlock!***
//
// `lock` lock a pointer to a lock variable.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_spinlock (SDL_LockSpinlock)
// See also: try_lock_spinlock (SDL_TryLockSpinlock)
pub fn unlock_spinlock(@lock &int) {
	C.SDL_UnlockSpinlock(@lock)
}

// TODO: Function: #define SDL_CompilerBarrier() DoCompilerSpecificReadWriteBarrier()

// TODO: Function: #define SDL_CompilerBarrier()   _ReadWriteBarrier()

// This is correct for all CPUs when using GCC or Solaris Studio 12.1+.
// TODO: pub const compilerbarrier() = __asm__ __volatile__ ('' : : : 'memory')

// TODO: Non-numerical: #define SDL_CompilerBarrier()   \

// C.SDL_MemoryBarrierReleaseFunction [official documentation](https://wiki.libsdl.org/SDL3/SDL_MemoryBarrierReleaseFunction)
fn C.SDL_MemoryBarrierReleaseFunction()

// memory_barrier_release_function inserts a memory release barrier (function version).
//
// Please refer to SDL_MemoryBarrierRelease for details. This is a function
// version, which might be useful if you need to use this functionality from a
// scripting language, etc. Also, some of the macro versions call this
// function behind the scenes, where more heavy lifting can happen inside of
// SDL. Generally, though, an app written in C/C++/etc should use the macro
// version, as it will be more efficient.
//
// NOTE: (thread safety) Obviously this function is safe to use from any thread at any
//               time, but if you find yourself needing this, you are probably
//               dealing with some very sensitive code; be careful!
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: memory_barrier_release (SDL_MemoryBarrierRelease)
pub fn memory_barrier_release_function() {
	C.SDL_MemoryBarrierReleaseFunction()
}

// C.SDL_MemoryBarrierAcquireFunction [official documentation](https://wiki.libsdl.org/SDL3/SDL_MemoryBarrierAcquireFunction)
fn C.SDL_MemoryBarrierAcquireFunction()

// memory_barrier_acquire_function inserts a memory acquire barrier (function version).
//
// Please refer to SDL_MemoryBarrierRelease for details. This is a function
// version, which might be useful if you need to use this functionality from a
// scripting language, etc. Also, some of the macro versions call this
// function behind the scenes, where more heavy lifting can happen inside of
// SDL. Generally, though, an app written in C/C++/etc should use the macro
// version, as it will be more efficient.
//
// NOTE: (thread safety) Obviously this function is safe to use from any thread at any
//               time, but if you find yourself needing this, you are probably
//               dealing with some very sensitive code; be careful!
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: memory_barrier_acquire (SDL_MemoryBarrierAcquire)
pub fn memory_barrier_acquire_function() {
	C.SDL_MemoryBarrierAcquireFunction()
}

// TODO: Function: #define SDL_MemoryBarrierRelease() SDL_MemoryBarrierReleaseFunction()

// TODO: Function: #define SDL_MemoryBarrierAcquire() SDL_MemoryBarrierAcquireFunction()

// KernelMemoryBarrierFunc informations from:
//
//   The Linux kernel provides a helper function which provides the right code for a memory barrier,
//   hard-coded at address 0xffff0fa0
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_KernelMemoryBarrierFunc)
pub type KernelMemoryBarrierFunc = fn ()

// TODO: Non-numerical: #define SDL_MEMORY_BARRIER_USES_FUNCTION

// TODO: Non-numerical: #define SDL_CPUPauseInstruction() DoACPUPauseInACompilerAndArchitectureSpecificWay

@[typedef]
pub struct C.SDL_AtomicInt {
	value int
}

// A type representing an atomic integer value.
//
// This can be used to manage a value that is synchronized across multiple
// CPUs without a race condition; when an app sets a value with
// SDL_SetAtomicInt all other threads, regardless of the CPU it is running on,
// will see that value when retrieved with SDL_GetAtomicInt, regardless of CPU
// caches, etc.
//
// This is also useful for atomic compare-and-swap operations: a thread can
// change the value as long as its current value matches expectations. When
// done in a loop, one can guarantee data consistency across threads without a
// lock (but the usual warnings apply: if you don't know what you're doing, or
// you don't do it carefully, you can confidently cause any number of
// disasters with this, so in most cases, you _should_ use a mutex instead of
// this!).
//
// This is a struct so people don't accidentally use numeric operations on it
// directly. You have to use SDL atomic functions.
//
// NOTE: This struct is available since SDL 3.2.0.
//
// See also: compare_and_swap_atomic_int (SDL_CompareAndSwapAtomicInt)
// See also: get_atomic_int (SDL_GetAtomicInt)
// See also: set_atomic_int (SDL_SetAtomicInt)
// See also: add_atomic_int (SDL_AddAtomicInt)
pub type AtomicInt = C.SDL_AtomicInt

// C.SDL_CompareAndSwapAtomicInt [official documentation](https://wiki.libsdl.org/SDL3/SDL_CompareAndSwapAtomicInt)
fn C.SDL_CompareAndSwapAtomicInt(a &AtomicInt, oldval int, newval int) bool

// compare_and_swap_atomic_int sets an atomic variable to a new value if it is currently an old value.
//
// ***Note: If you don't know what this function is for, you shouldn't use
// it!***
//
// `a` a a pointer to an SDL_AtomicInt variable to be modified.
// `oldval` oldval the old value.
// `newval` newval the new value.
// returns true if the atomic variable was set, false otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_atomic_int (SDL_GetAtomicInt)
// See also: set_atomic_int (SDL_SetAtomicInt)
pub fn compare_and_swap_atomic_int(a &AtomicInt, oldval int, newval int) bool {
	return C.SDL_CompareAndSwapAtomicInt(a, oldval, newval)
}

// C.SDL_SetAtomicInt [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetAtomicInt)
fn C.SDL_SetAtomicInt(a &AtomicInt, v int) int

// set_atomic_int sets an atomic variable to a value.
//
// This function also acts as a full memory barrier.
//
// ***Note: If you don't know what this function is for, you shouldn't use
// it!***
//
// `a` a a pointer to an SDL_AtomicInt variable to be modified.
// `v` v the desired value.
// returns the previous value of the atomic variable.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_atomic_int (SDL_GetAtomicInt)
pub fn set_atomic_int(a &AtomicInt, v int) int {
	return C.SDL_SetAtomicInt(a, v)
}

// C.SDL_GetAtomicInt [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAtomicInt)
fn C.SDL_GetAtomicInt(a &AtomicInt) int

// get_atomic_int gets the value of an atomic variable.
//
// ***Note: If you don't know what this function is for, you shouldn't use
// it!***
//
// `a` a a pointer to an SDL_AtomicInt variable.
// returns the current value of an atomic variable.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_atomic_int (SDL_SetAtomicInt)
pub fn get_atomic_int(a &AtomicInt) int {
	return C.SDL_GetAtomicInt(a)
}

// C.SDL_AddAtomicInt [official documentation](https://wiki.libsdl.org/SDL3/SDL_AddAtomicInt)
fn C.SDL_AddAtomicInt(a &AtomicInt, v int) int

// add_atomic_int adds to an atomic variable.
//
// This function also acts as a full memory barrier.
//
// ***Note: If you don't know what this function is for, you shouldn't use
// it!***
//
// `a` a a pointer to an SDL_AtomicInt variable to be modified.
// `v` v the desired value to add.
// returns the previous value of the atomic variable.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atomic_dec_ref (SDL_AtomicDecRef)
// See also: atomic_inc_ref (SDL_AtomicIncRef)
pub fn add_atomic_int(a &AtomicInt, v int) int {
	return C.SDL_AddAtomicInt(a, v)
}

// TODO: Function: #define SDL_AtomicIncRef(a)    SDL_AddAtomicInt(a, 1)

// TODO: Function: #define SDL_AtomicDecRef(a)    (SDL_AddAtomicInt(a, -1) == 1)

@[typedef]
pub struct C.SDL_AtomicU32 {}

pub type AtomicU32 = C.SDL_AtomicU32

// C.SDL_CompareAndSwapAtomicU32 [official documentation](https://wiki.libsdl.org/SDL3/SDL_CompareAndSwapAtomicU32)
fn C.SDL_CompareAndSwapAtomicU32(a &AtomicU32, oldval u32, newval u32) bool

// compare_and_swap_atomic_u32 sets an atomic variable to a new value if it is currently an old value.
//
// ***Note: If you don't know what this function is for, you shouldn't use
// it!***
//
// `a` a a pointer to an SDL_AtomicU32 variable to be modified.
// `oldval` oldval the old value.
// `newval` newval the new value.
// returns true if the atomic variable was set, false otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_atomic_u32 (SDL_GetAtomicU32)
// See also: set_atomic_u32 (SDL_SetAtomicU32)
pub fn compare_and_swap_atomic_u32(a &AtomicU32, oldval u32, newval u32) bool {
	return C.SDL_CompareAndSwapAtomicU32(a, oldval, newval)
}

// C.SDL_SetAtomicU32 [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetAtomicU32)
fn C.SDL_SetAtomicU32(a &AtomicU32, v u32) u32

// set_atomic_u32 sets an atomic variable to a value.
//
// This function also acts as a full memory barrier.
//
// ***Note: If you don't know what this function is for, you shouldn't use
// it!***
//
// `a` a a pointer to an SDL_AtomicU32 variable to be modified.
// `v` v the desired value.
// returns the previous value of the atomic variable.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_atomic_u32 (SDL_GetAtomicU32)
pub fn set_atomic_u32(a &AtomicU32, v u32) u32 {
	return C.SDL_SetAtomicU32(a, v)
}

// C.SDL_GetAtomicU32 [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAtomicU32)
fn C.SDL_GetAtomicU32(a &AtomicU32) u32

// get_atomic_u32 gets the value of an atomic variable.
//
// ***Note: If you don't know what this function is for, you shouldn't use
// it!***
//
// `a` a a pointer to an SDL_AtomicU32 variable.
// returns the current value of an atomic variable.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_atomic_u32 (SDL_SetAtomicU32)
pub fn get_atomic_u32(a &AtomicU32) u32 {
	return C.SDL_GetAtomicU32(a)
}

// C.SDL_CompareAndSwapAtomicPointer [official documentation](https://wiki.libsdl.org/SDL3/SDL_CompareAndSwapAtomicPointer)
fn C.SDL_CompareAndSwapAtomicPointer(a &voidptr, oldval voidptr, newval voidptr) bool

// compare_and_swap_atomic_pointer sets a pointer to a new value if it is currently an old value.
//
// ***Note: If you don't know what this function is for, you shouldn't use
// it!***
//
// `a` a a pointer to a pointer.
// `oldval` oldval the old pointer value.
// `newval` newval the new pointer value.
// returns true if the pointer was set, false otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: compare_and_swap_atomic_int (SDL_CompareAndSwapAtomicInt)
// See also: get_atomic_pointer (SDL_GetAtomicPointer)
// See also: set_atomic_pointer (SDL_SetAtomicPointer)
pub fn compare_and_swap_atomic_pointer(a &voidptr, oldval voidptr, newval voidptr) bool {
	return C.SDL_CompareAndSwapAtomicPointer(*a, oldval, newval)
}

// C.SDL_SetAtomicPointer [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetAtomicPointer)
fn C.SDL_SetAtomicPointer(a &voidptr, v voidptr) voidptr

// set_atomic_pointer sets a pointer to a value atomically.
//
// ***Note: If you don't know what this function is for, you shouldn't use
// it!***
//
// `a` a a pointer to a pointer.
// `v` v the desired pointer value.
// returns the previous value of the pointer.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: compare_and_swap_atomic_pointer (SDL_CompareAndSwapAtomicPointer)
// See also: get_atomic_pointer (SDL_GetAtomicPointer)
pub fn set_atomic_pointer(a &voidptr, v voidptr) voidptr {
	return C.SDL_SetAtomicPointer(*a, v)
}

// C.SDL_GetAtomicPointer [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAtomicPointer)
fn C.SDL_GetAtomicPointer(a &voidptr) voidptr

// get_atomic_pointer gets the value of a pointer atomically.
//
// ***Note: If you don't know what this function is for, you shouldn't use
// it!***
//
// `a` a a pointer to a pointer.
// returns the current value of a pointer.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: compare_and_swap_atomic_pointer (SDL_CompareAndSwapAtomicPointer)
// See also: set_atomic_pointer (SDL_SetAtomicPointer)
pub fn get_atomic_pointer(a &voidptr) voidptr {
	return C.SDL_GetAtomicPointer(*a)
}
