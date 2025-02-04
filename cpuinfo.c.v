// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_cpuinfo.h
//

// CPU feature detection for SDL.
//
// These functions are largely concerned with reporting if the system has
// access to various SIMD instruction sets, but also has other important info
// to share, such as system RAM size and number of logical CPU cores.
//
// CPU instruction set checks, like SDL_HasSSE() and SDL_HasNEON(), are
// available on all platforms, even if they don't make sense (an ARM processor
// will never have SSE and an x86 processor will never have NEON, for example,
// but these functions still exist and will simply return false in these
// cases).

// A guess for the cacheline size used for padding.
//
// Most x86 processors have a 64 byte cache line. The 64-bit PowerPC
// processors have a 128 byte cache line. We use the larger value to be
// generally safe.
//
// NOTE: This macro is available since SDL 3.2.0.
pub const cacheline_size = C.SDL_CACHELINE_SIZE // 128

// C.SDL_GetNumLogicalCPUCores [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumLogicalCPUCores)
fn C.SDL_GetNumLogicalCPUCores() int

// get_num_logical_cpu_cores gets the number of logical CPU cores available.
//
// returns the total number of logical CPU cores. On CPUs that include
//          technologies such as hyperthreading, the number of logical cores
//          may be more than the number of physical cores.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_num_logical_cpu_cores() int {
	return C.SDL_GetNumLogicalCPUCores()
}

// C.SDL_GetCPUCacheLineSize [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetCPUCacheLineSize)
fn C.SDL_GetCPUCacheLineSize() int

// get_cpu_cache_line_size determines the L1 cache line size of the CPU.
//
// This is useful for determining multi-threaded structure padding or SIMD
// prefetch sizes.
//
// returns the L1 cache line size of the CPU, in bytes.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_cpu_cache_line_size() int {
	return C.SDL_GetCPUCacheLineSize()
}

// C.SDL_HasAltiVec [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasAltiVec)
fn C.SDL_HasAltiVec() bool

// has_alti_vec determines whether the CPU has AltiVec features.
//
// This always returns false on CPUs that aren't using PowerPC instruction
// sets.
//
// returns true if the CPU has AltiVec features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn has_alti_vec() bool {
	return C.SDL_HasAltiVec()
}

// C.SDL_HasMMX [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasMMX)
fn C.SDL_HasMMX() bool

// has_mmx determines whether the CPU has MMX features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns true if the CPU has MMX features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn has_mmx() bool {
	return C.SDL_HasMMX()
}

// C.SDL_HasSSE [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasSSE)
fn C.SDL_HasSSE() bool

// has_sse determines whether the CPU has SSE features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns true if the CPU has SSE features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_ss_e2 (SDL_HasSSE2)
// See also: has_ss_e3 (SDL_HasSSE3)
// See also: has_ss_e41 (SDL_HasSSE41)
// See also: has_ss_e42 (SDL_HasSSE42)
pub fn has_sse() bool {
	return C.SDL_HasSSE()
}

// C.SDL_HasSSE2 [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasSSE2)
fn C.SDL_HasSSE2() bool

// has_ss_e2 determines whether the CPU has SSE2 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns true if the CPU has SSE2 features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_sse (SDL_HasSSE)
// See also: has_ss_e3 (SDL_HasSSE3)
// See also: has_ss_e41 (SDL_HasSSE41)
// See also: has_ss_e42 (SDL_HasSSE42)
pub fn has_ss_e2() bool {
	return C.SDL_HasSSE2()
}

// C.SDL_HasSSE3 [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasSSE3)
fn C.SDL_HasSSE3() bool

// has_ss_e3 determines whether the CPU has SSE3 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns true if the CPU has SSE3 features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_sse (SDL_HasSSE)
// See also: has_ss_e2 (SDL_HasSSE2)
// See also: has_ss_e41 (SDL_HasSSE41)
// See also: has_ss_e42 (SDL_HasSSE42)
pub fn has_ss_e3() bool {
	return C.SDL_HasSSE3()
}

// C.SDL_HasSSE41 [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasSSE41)
fn C.SDL_HasSSE41() bool

// has_ss_e41 determines whether the CPU has SSE4.1 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns true if the CPU has SSE4.1 features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_sse (SDL_HasSSE)
// See also: has_ss_e2 (SDL_HasSSE2)
// See also: has_ss_e3 (SDL_HasSSE3)
// See also: has_ss_e42 (SDL_HasSSE42)
pub fn has_ss_e41() bool {
	return C.SDL_HasSSE41()
}

// C.SDL_HasSSE42 [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasSSE42)
fn C.SDL_HasSSE42() bool

// has_ss_e42 determines whether the CPU has SSE4.2 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns true if the CPU has SSE4.2 features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_sse (SDL_HasSSE)
// See also: has_ss_e2 (SDL_HasSSE2)
// See also: has_ss_e3 (SDL_HasSSE3)
// See also: has_ss_e41 (SDL_HasSSE41)
pub fn has_ss_e42() bool {
	return C.SDL_HasSSE42()
}

// C.SDL_HasAVX [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasAVX)
fn C.SDL_HasAVX() bool

// has_avx determines whether the CPU has AVX features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns true if the CPU has AVX features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_av_x2 (SDL_HasAVX2)
// See also: has_av_x512_f (SDL_HasAVX512F)
pub fn has_avx() bool {
	return C.SDL_HasAVX()
}

// C.SDL_HasAVX2 [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasAVX2)
fn C.SDL_HasAVX2() bool

// has_av_x2 determines whether the CPU has AVX2 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns true if the CPU has AVX2 features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_avx (SDL_HasAVX)
// See also: has_av_x512_f (SDL_HasAVX512F)
pub fn has_av_x2() bool {
	return C.SDL_HasAVX2()
}

// C.SDL_HasAVX512F [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasAVX512F)
fn C.SDL_HasAVX512F() bool

// has_av_x512_f determines whether the CPU has AVX-512F (foundation) features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
//
// returns true if the CPU has AVX-512F features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_avx (SDL_HasAVX)
// See also: has_av_x2 (SDL_HasAVX2)
pub fn has_av_x512_f() bool {
	return C.SDL_HasAVX512F()
}

// C.SDL_HasARMSIMD [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasARMSIMD)
fn C.SDL_HasARMSIMD() bool

// has_armsimd determines whether the CPU has ARM SIMD (ARMv6) features.
//
// This is different from ARM NEON, which is a different instruction set.
//
// This always returns false on CPUs that aren't using ARM instruction sets.
//
// returns true if the CPU has ARM SIMD features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_neon (SDL_HasNEON)
pub fn has_armsimd() bool {
	return C.SDL_HasARMSIMD()
}

// C.SDL_HasNEON [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasNEON)
fn C.SDL_HasNEON() bool

// has_neon determines whether the CPU has NEON (ARM SIMD) features.
//
// This always returns false on CPUs that aren't using ARM instruction sets.
//
// returns true if the CPU has ARM NEON features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn has_neon() bool {
	return C.SDL_HasNEON()
}

// C.SDL_HasLSX [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasLSX)
fn C.SDL_HasLSX() bool

// has_lsx determines whether the CPU has LSX (LOONGARCH SIMD) features.
//
// This always returns false on CPUs that aren't using LOONGARCH instruction
// sets.
//
// returns true if the CPU has LOONGARCH LSX features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn has_lsx() bool {
	return C.SDL_HasLSX()
}

// C.SDL_HasLASX [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasLASX)
fn C.SDL_HasLASX() bool

// has_lasx determines whether the CPU has LASX (LOONGARCH SIMD) features.
//
// This always returns false on CPUs that aren't using LOONGARCH instruction
// sets.
//
// returns true if the CPU has LOONGARCH LASX features or false if not.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn has_lasx() bool {
	return C.SDL_HasLASX()
}

// C.SDL_GetSystemRAM [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSystemRAM)
fn C.SDL_GetSystemRAM() int

// get_system_ram gets the amount of RAM configured in the system.
//
// returns the amount of RAM configured in the system in MiB.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_system_ram() int {
	return C.SDL_GetSystemRAM()
}

// C.SDL_GetSIMDAlignment [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSIMDAlignment)
fn C.SDL_GetSIMDAlignment() usize

// get_simd_alignment reports the alignment this system needs for SIMD allocations.
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
//          instructions.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: aligned_alloc (SDL_aligned_alloc)
// See also: aligned_free (SDL_aligned_free)
pub fn get_simd_alignment() usize {
	return C.SDL_GetSIMDAlignment()
}
