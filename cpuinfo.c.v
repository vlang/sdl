// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_cpuinfo.h
//

fn C.SDL_GetCPUCount() int

// get_cpu_count gets the number of CPU cores available.
//
// returns the total number of logical CPU cores. On CPUs that include
//         technologies such as hyperthreading, the number of logical cores
//         may be more than the number of physical cores.
//
// NOTE This function is available since SDL 2.0.0.
pub fn get_cpu_count() int {
	return C.SDL_GetCPUCount()
}

fn C.SDL_GetCPUCacheLineSize() int

// get_cpu_cache_line_size determines the L1 cache line size of the CPU.
//
// This is useful for determining multi-threaded structure padding or SIMD
// prefetch sizes.
//
// returns the L1 cache line size of the CPU, in bytes.
//
// NOTE This function is available since SDL 2.0.0.
pub fn get_cpu_cache_line_size() int {
	return C.SDL_GetCPUCacheLineSize()
}

fn C.SDL_HasRDTSC() bool

// has_rdtsc determines whether the CPU has the RDTSC instruction.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns SDL_TRUE if the CPU has the RDTSC instruction or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Has3DNow
// See also: SDL_HasAltiVec
// See also: SDL_HasAVX
// See also: SDL_HasAVX2
// See also: SDL_HasMMX
// See also: SDL_HasSSE
// See also: SDL_HasSSE2
// See also: SDL_HasSSE3
// See also: SDL_HasSSE41
// See also: SDL_HasSSE42
pub fn has_rdtsc() bool {
	return C.SDL_HasRDTSC()
}

fn C.SDL_HasAltiVec() bool

// has_alti_vec determines whether the CPU has AltiVec features.
//
// This always returns false on CPUs that aren't using PowerPC instruction
// sets.
//
// returns SDL_TRUE if the CPU has AltiVec features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Has3DNow
// See also: SDL_HasAVX
// See also: SDL_HasAVX2
// See also: SDL_HasMMX
// See also: SDL_HasRDTSC
// See also: SDL_HasSSE
// See also: SDL_HasSSE2
// See also: SDL_HasSSE3
// See also: SDL_HasSSE41
// See also: SDL_HasSSE42
pub fn has_alti_vec() bool {
	return C.SDL_HasAltiVec()
}

fn C.SDL_HasMMX() bool

// has_mmx determines whether the CPU has MMX features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns SDL_TRUE if the CPU has MMX features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Has3DNow
// See also: SDL_HasAltiVec
// See also: SDL_HasAVX
// See also: SDL_HasAVX2
// See also: SDL_HasRDTSC
// See also: SDL_HasSSE
// See also: SDL_HasSSE2
// See also: SDL_HasSSE3
// See also: SDL_HasSSE41
// See also: SDL_HasSSE42
pub fn has_mmx() bool {
	return C.SDL_HasMMX()
}

fn C.SDL_Has3DNow() bool

// has_3d_now determines whether the CPU has 3DNow! features.
//
// This always returns false on CPUs that aren't using AMD instruction sets.
//
// returns SDL_TRUE if the CPU has 3DNow! features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_HasAltiVec
// See also: SDL_HasAVX
// See also: SDL_HasAVX2
// See also: SDL_HasMMX
// See also: SDL_HasRDTSC
// See also: SDL_HasSSE
// See also: SDL_HasSSE2
// See also: SDL_HasSSE3
// See also: SDL_HasSSE41
// See also: SDL_HasSSE42
pub fn has_3d_now() bool {
	return C.SDL_Has3DNow()
}

fn C.SDL_HasSSE() bool

// has_sse determines whether the CPU has SSE features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns SDL_TRUE if the CPU has SSE features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Has3DNow
// See also: SDL_HasAltiVec
// See also: SDL_HasAVX
// See also: SDL_HasAVX2
// See also: SDL_HasMMX
// See also: SDL_HasRDTSC
// See also: SDL_HasSSE2
// See also: SDL_HasSSE3
// See also: SDL_HasSSE41
// See also: SDL_HasSSE42
pub fn has_sse() bool {
	return C.SDL_HasSSE()
}

fn C.SDL_HasSSE2() bool

// has_sse2 determines whether the CPU has SSE2 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns SDL_TRUE if the CPU has SSE2 features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Has3DNow
// See also: SDL_HasAltiVec
// See also: SDL_HasAVX
// See also: SDL_HasAVX2
// See also: SDL_HasMMX
// See also: SDL_HasRDTSC
// See also: SDL_HasSSE
// See also: SDL_HasSSE3
// See also: SDL_HasSSE41
// See also: SDL_HasSSE42
pub fn has_sse2() bool {
	return C.SDL_HasSSE2()
}

fn C.SDL_HasSSE3() bool

// has_sse3 determines whether the CPU has SSE3 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns SDL_TRUE if the CPU has SSE3 features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Has3DNow
// See also: SDL_HasAltiVec
// See also: SDL_HasAVX
// See also: SDL_HasAVX2
// See also: SDL_HasMMX
// See also: SDL_HasRDTSC
// See also: SDL_HasSSE
// See also: SDL_HasSSE2
// See also: SDL_HasSSE41
// See also: SDL_HasSSE42
pub fn has_sse3() bool {
	return C.SDL_HasSSE3()
}

fn C.SDL_HasSSE41() bool

// has_sse41 determines whether the CPU has SSE4.1 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns SDL_TRUE if the CPU has SSE4.1 features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Has3DNow
// See also: SDL_HasAltiVec
// See also: SDL_HasAVX
// See also: SDL_HasAVX2
// See also: SDL_HasMMX
// See also: SDL_HasRDTSC
// See also: SDL_HasSSE
// See also: SDL_HasSSE2
// See also: SDL_HasSSE3
// See also: SDL_HasSSE42
pub fn has_sse41() bool {
	return C.SDL_HasSSE41()
}

fn C.SDL_HasSSE42() bool

// has_sse42 determines whether the CPU has SSE4.2 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns SDL_TRUE if the CPU has SSE4.2 features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_Has3DNow
// See also: SDL_HasAltiVec
// See also: SDL_HasAVX
// See also: SDL_HasAVX2
// See also: SDL_HasMMX
// See also: SDL_HasRDTSC
// See also: SDL_HasSSE
// See also: SDL_HasSSE2
// See also: SDL_HasSSE3
// See also: SDL_HasSSE41
pub fn has_sse42() bool {
	return C.SDL_HasSSE42()
}

fn C.SDL_HasAVX() bool

// has_avx determines whether the CPU has AVX features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns SDL_TRUE if the CPU has AVX features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.2.
//
// See also: SDL_Has3DNow
// See also: SDL_HasAltiVec
// See also: SDL_HasAVX2
// See also: SDL_HasMMX
// See also: SDL_HasRDTSC
// See also: SDL_HasSSE
// See also: SDL_HasSSE2
// See also: SDL_HasSSE3
// See also: SDL_HasSSE41
// See also: SDL_HasSSE42
pub fn has_avx() bool {
	return C.SDL_HasAVX()
}

fn C.SDL_HasAVX2() bool

// has_avx2 determines whether the CPU has AVX2 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns SDL_TRUE if the CPU has AVX2 features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.4.
//
// See also: SDL_Has3DNow
// See also: SDL_HasAltiVec
// See also: SDL_HasAVX
// See also: SDL_HasMMX
// See also: SDL_HasRDTSC
// See also: SDL_HasSSE
// See also: SDL_HasSSE2
// See also: SDL_HasSSE3
// See also: SDL_HasSSE41
// See also: SDL_HasSSE42
pub fn has_avx2() bool {
	return C.SDL_HasAVX2()
}

fn C.SDL_HasAVX512F() bool

// has_avx512f determines whether the CPU has AVX-512F (foundation) features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns SDL_TRUE if the CPU has AVX-512F features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.9.
//
// See also: SDL_HasAVX
pub fn has_avx512f() bool {
	return C.SDL_HasAVX512F()
}

fn C.SDL_HasARMSIMD() bool

// has_arm_simd determines whether the CPU has ARM SIMD (ARMv6) features.
//
// This is different from ARM NEON, which is a different instruction set.
//
// This always returns false on CPUs that aren't using ARM instruction sets.
//
// returns SDL_TRUE if the CPU has ARM SIMD features or SDL_FALSE if not.
//
// NOTE This function is available since SDL 2.0.12.
//
// See also: SDL_HasNEON
pub fn has_arm_simd() bool {
	return C.SDL_HasARMSIMD()
}

fn C.SDL_HasNEON() bool

// has_neon determines whether the CPU has NEON (ARM SIMD) features.
//
// This always returns false on CPUs that aren't using ARM instruction sets.
//
// NOTE This function is available since SDL 2.0.6.
//
// returns SDL_TRUE if the CPU has ARM NEON features or SDL_FALSE if not.
pub fn has_neon() bool {
	return C.SDL_HasNEON()
}

fn C.SDL_GetSystemRAM() int

// get_system_ram gets the amount of RAM configured in the system.
//
// returns the amount of RAM configured in the system in MB.
//
// NOTE This function is available since SDL 2.0.1.
pub fn get_system_ram() int {
	return C.SDL_GetSystemRAM()
}

fn C.SDL_SIMDGetAlignment() usize

// simd_get_alignment reports the alignment this system needs for SIMD allocations.
//
// This will return the minimum number of bytes to which a pointer must be
// aligned to be compatible with SIMD instructions on the current machine. For
// example, if the machine supports SSE only, it will return 16, but if it
// supports AVX-512F, it'll return 64 (etc). This only reports values for
// instruction sets SDL knows about, so if your SDL build doesn't have
// SDL_HasAVX512F(), then it might return 16 for the SSE support it sees and
// not 64 for the AVX-512 instructions that exist but SDL doesn't know about.
// Plan accordingly.
//
// returns the alignment in bytes needed for available, known SIMD
//         instructions.
//
// NOTE This function is available since SDL 2.0.10.
pub fn simd_get_alignment() usize {
	return C.SDL_SIMDGetAlignment()
}

fn C.SDL_SIMDAlloc(len usize) voidptr

// simd_alloc allocates memory in a SIMD-friendly way.
//
// This will allocate a block of memory that is suitable for use with SIMD
// instructions. Specifically, it will be properly aligned and padded for the
// system's supported vector instructions.
//
// The memory returned will be padded such that it is safe to read or write an
// incomplete vector at the end of the memory block. This can be useful so you
// don't have to drop back to a scalar fallback at the end of your SIMD
// processing loop to deal with the final elements without overflowing the
// allocated buffer.
//
// You must free this memory with SDL_FreeSIMD(), not free() or SDL_free() or
// delete[], etc.
//
// Note that SDL will only deal with SIMD instruction sets it is aware of; for
// example, SDL 2.0.8 knows that SSE wants 16-byte vectors (SDL_HasSSE()), and
// AVX2 wants 32 bytes (SDL_HasAVX2()), but doesn't know that AVX-512 wants
// 64. To be clear: if you can't decide to use an instruction set with an
// SDL_Has*() function, don't use that instruction set with memory allocated
// through here.
//
// SDL_AllocSIMD(0) will return a non-NULL pointer, assuming the system isn't
// out of memory, but you are not allowed to dereference it (because you only
// own zero bytes of that buffer).
//
// `len` The length, in bytes, of the block to allocate. The actual
//       allocated block might be larger due to padding, etc.
// returns a pointer to the newly-allocated block, NULL if out of memory.
//
// NOTE This function is available since SDL 2.0.10.
//
// See also: SDL_SIMDAlignment
// See also: SDL_SIMDRealloc
// See also: SDL_SIMDFree
pub fn simd_alloc(len usize) voidptr {
	return C.SDL_SIMDAlloc(len)
}

fn C.SDL_SIMDRealloc(mem voidptr, len usize) voidptr

// simd_realloc reallocates memory obtained from SDL_SIMDAlloc
//
// It is not valid to use this function on a pointer from anything but
// SDL_SIMDAlloc(). It can't be used on pointers from malloc, realloc,
// SDL_malloc, memalign, new[], etc.
//
// `mem` The pointer obtained from SDL_SIMDAlloc. This function also
//       accepts NULL, at which point this function is the same as
//       calling SDL_SIMDAlloc with a NULL pointer.
// `len` The length, in bytes, of the block to allocated. The actual
//       allocated block might be larger due to padding, etc. Passing 0
//       will return a non-NULL pointer, assuming the system isn't out of
//       memory.
// returns a pointer to the newly-reallocated block, NULL if out of memory.
//
// NOTE This function is available since SDL 2.0.14.
//
// See also: SDL_SIMDAlignment
// See also: SDL_SIMDAlloc
// See also: SDL_SIMDFree
pub fn simd_realloc(mem voidptr, len usize) voidptr {
	return C.SDL_SIMDRealloc(mem, len)
}

fn C.SDL_SIMDFree(ptr voidptr)

// simd_free deallocates memory obtained from SDL_SIMDAlloc
//
// It is not valid to use this function on a pointer from anything but
// SDL_SIMDAlloc() or SDL_SIMDRealloc(). It can't be used on pointers from
// malloc, realloc, SDL_malloc, memalign, new[], etc.
//
// However, SDL_SIMDFree(NULL) is a legal no-op.
//
// The memory pointed to by `ptr` is no longer valid for access upon return,
// and may be returned to the system or reused by a future allocation. The
// pointer passed to this function is no longer safe to dereference once this
// function returns, and should be discarded.
//
// `ptr` The pointer, returned from SDL_SIMDAlloc or SDL_SIMDRealloc, to
//       deallocate. NULL is a legal no-op.
//
// NOTE This function is available since SDL 2.0.10.
//
// See also: SDL_SIMDAlloc
// See also: SDL_SIMDRealloc
pub fn simd_free(ptr voidptr) {
	C.SDL_SIMDFree(ptr)
}
