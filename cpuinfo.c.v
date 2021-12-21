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
