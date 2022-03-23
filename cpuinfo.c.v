// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_cpuinfo.h
//

fn C.SDL_GetCPUCount() int

// get_cpu_count returns the number of CPU cores available.
pub fn get_cpu_count() int {
	return C.SDL_GetCPUCount()
}

fn C.SDL_GetCPUCacheLineSize() int

// get_cpu_cache_line_size returns the L1 cache line size of the CPU
// This is useful for determining multi-threaded structure padding
// or SIMD prefetch sizes.
pub fn get_cpu_cache_line_size() int {
	return C.SDL_GetCPUCacheLineSize()
}

fn C.SDL_HasRDTSC() bool

// has_rdtsc returns true if the CPU has the RDTSC instruction.
pub fn has_rdtsc() bool {
	return C.SDL_HasRDTSC()
}

fn C.SDL_HasAltiVec() bool

// has_alti_vec returns true if the CPU has AltiVec features.
pub fn has_alti_vec() bool {
	return C.SDL_HasAltiVec()
}

fn C.SDL_HasMMX() bool

// has_mmx returns true if the CPU has MMX features.
pub fn has_mmx() bool {
	return C.SDL_HasMMX()
}

fn C.SDL_Has3DNow() bool

// has_3d_now returns true if the CPU has 3DNow! features.
pub fn has_3d_now() bool {
	return C.SDL_Has3DNow()
}

fn C.SDL_HasSSE() bool

// has_sse returns true if the CPU has SSE features.
pub fn has_sse() bool {
	return C.SDL_HasSSE()
}

fn C.SDL_HasSSE2() bool

// has_sse2 returns true if the CPU has SSE2 features.
pub fn has_sse2() bool {
	return C.SDL_HasSSE2()
}

fn C.SDL_HasSSE3() bool

// has_sse3 returns true if the CPU has SSE3 features.
pub fn has_sse3() bool {
	return C.SDL_HasSSE3()
}

fn C.SDL_HasSSE41() bool

// has_sse41 returns true if the CPU has SSE4.1 features.
pub fn has_sse41() bool {
	return C.SDL_HasSSE41()
}

fn C.SDL_HasSSE42() bool

// has_sse42 returns true if the CPU has SSE4.2 features.
pub fn has_sse42() bool {
	return C.SDL_HasSSE42()
}

fn C.SDL_HasAVX() bool

// has_avx returns true if the CPU has AVX features.
pub fn has_avx() bool {
	return C.SDL_HasAVX()
}

fn C.SDL_HasAVX2() bool

// has_avx2 returns true if the CPU has AVX2 features.
pub fn has_avx2() bool {
	return C.SDL_HasAVX2()
}

fn C.SDL_HasAVX512F() bool

// has_avx512f returns true if the CPU has AVX-512F (foundation) features.
pub fn has_avx512f() bool {
	return C.SDL_HasAVX512F()
}

fn C.SDL_HasARMSIMD() bool

// has_arm_simd returns true if the CPU has ARM SIMD (ARMv6) features.
pub fn has_arm_simd() bool {
	return C.SDL_HasARMSIMD()
}

fn C.SDL_HasNEON() bool

// has_neon returns true if the CPU has NEON (ARM SIMD) features.
pub fn has_neon() bool {
	return C.SDL_HasNEON()
}

fn C.SDL_GetSystemRAM() int

// get_system_ram returns the amount of RAM configured in the system, in MB.
pub fn get_system_ram() int {
	return C.SDL_GetSystemRAM()
}

fn C.SDL_SIMDGetAlignment() usize

// simd_get_alignment reports the alignment this system needs for SIMD allocations.
//
// This will return the minimum number of bytes to which a pointer must be
//  aligned to be compatible with SIMD instructions on the current machine.
//  For example, if the machine supports SSE only, it will return 16, but if
//  it supports AVX-512F, it'll return 64 (etc). This only reports values for
//  instruction sets SDL knows about, so if your SDL build doesn't have
//  SDL_HasAVX512F(), then it might return 16 for the SSE support it sees and
//  not 64 for the AVX-512 instructions that exist but SDL doesn't know about.
//  Plan accordingly.
pub fn simd_get_alignment() usize {
	return C.SDL_SIMDGetAlignment()
}

fn C.SDL_SIMDAlloc(len usize) voidptr

// simd_alloc allocates memory in a SIMD-friendly way.
//
// This will allocate a block of memory that is suitable for use with SIMD
//  instructions. Specifically, it will be properly aligned and padded for
//  the system's supported vector instructions.
//
// The memory returned will be padded such that it is safe to read or write
//  an incomplete vector at the end of the memory block. This can be useful
//  so you don't have to drop back to a scalar fallback at the end of your
//  SIMD processing loop to deal with the final elements without overflowing
//  the allocated buffer.
//
// You must free this memory with SDL_FreeSIMD(), not free() or SDL_free()
//  or delete[], etc.
//
// Note that SDL will only deal with SIMD instruction sets it is aware of;
//  for example, SDL 2.0.8 knows that SSE wants 16-byte vectors
//  (SDL_HasSSE()), and AVX2 wants 32 bytes (SDL_HasAVX2()), but doesn't
//  know that AVX-512 wants 64. To be clear: if you can't decide to use an
//  instruction set with an SDL_Has*() function, don't use that instruction
//  set with memory allocated through here.
//
// SDL_AllocSIMD(0) will return a non-NULL pointer, assuming the system isn't
//  out of memory.
//
//  `len` The length, in bytes, of the block to allocated. The actual
//        allocated block might be larger due to padding, etc.
// returns Pointer to newly-allocated block, NULL if out of memory.
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
//  SDL_SIMDAlloc(). It can't be used on pointers from malloc, realloc,
//  SDL_malloc, memalign, new[], etc.
//
//  `mem` The pointer obtained from SDL_SIMDAlloc. This function also
//             accepts NULL, at which point this function is the same as
//             calling SDL_realloc with a NULL pointer.
//  `len` The length, in bytes, of the block to allocated. The actual
//             allocated block might be larger due to padding, etc. Passing 0
//             will return a non-NULL pointer, assuming the system isn't out of
//             memory.
// returns Pointer to newly-reallocated block, NULL if out of memory.
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
//  SDL_SIMDAlloc(). It can't be used on pointers from malloc, realloc,
//  SDL_malloc, memalign, new[], etc.
//
// However, SDL_SIMDFree(NULL) is a legal no-op.
//
// See also: SDL_SIMDAlloc
// See also: SDL_SIMDRealloc
pub fn simd_free(ptr voidptr) {
	C.SDL_SIMDFree(ptr)
}
