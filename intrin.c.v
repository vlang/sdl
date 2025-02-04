// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_intrin.h
//

// SDL does some preprocessor gymnastics to determine if any CPU-specific
// compiler intrinsics are available, as this is not necessarily an easy thing
// to calculate, and sometimes depends on quirks of a system, versions of
// build tools, and other external forces.
//
// Apps including SDL's headers will be able to check consistent preprocessor
// definitions to decide if it's safe to use compiler intrinsics for a
// specific CPU architecture. This check only tells you that the compiler is
// capable of using those intrinsics; at runtime, you should still check if
// they are available on the current system with the
// [CPU info functions](https://wiki.libsdl.org/SDL3/CategoryCPUInfo)
// , such as SDL_HasSSE() or SDL_HasNEON(). Otherwise, the process might crash
// for using an unsupported CPU instruction.
//
// SDL only sets preprocessor defines for CPU intrinsics if they are
// supported, so apps should check with `#ifdef` and not `#if`.
//
// SDL will also include the appropriate instruction-set-specific support
// headers, so if SDL decides to define SDL_SSE2_INTRINSICS, it will also
// `#include <emmintrin.h>` as well.

// Defined if (and only if) the compiler supports Loongarch LSX intrinsics.
//
// If this macro is defined, SDL will have already included `<lsxintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_LASX_INTRINSICS
pub const lsx_intrinsics = C.SDL_LSX_INTRINSICS // 1

// Defined if (and only if) the compiler supports Loongarch LSX intrinsics.
//
// If this macro is defined, SDL will have already included `<lasxintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_LASX_INTRINSICS
pub const lasx_intrinsics = C.SDL_LASX_INTRINSICS // 1

// Defined if (and only if) the compiler supports ARM NEON intrinsics.
//
// If this macro is defined, SDL will have already included `<armintr.h>`
// `<arm_neon.h>`, `<arm64intr.h>`, and `<arm64_neon.h>`, as appropriate.
//
// NOTE: This macro is available since SDL 3.2.0.
pub const neon_intrinsics = C.SDL_NEON_INTRINSICS // 1

// Defined if (and only if) the compiler supports PowerPC Altivec intrinsics.
//
// If this macro is defined, SDL will have already included `<altivec.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
pub const altivec_intrinsics = C.SDL_ALTIVEC_INTRINSICS // 1

// Defined if (and only if) the compiler supports Intel MMX intrinsics.
//
// If this macro is defined, SDL will have already included `<mmintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_SSE_INTRINSICS
pub const mmx_intrinsics = C.SDL_MMX_INTRINSICS // 1

// Defined if (and only if) the compiler supports Intel SSE intrinsics.
//
// If this macro is defined, SDL will have already included `<xmmintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_SSE2_INTRINSICS
// See also: SDL_SSE3_INTRINSICS
// See also: SDL_SSE4_1_INTRINSICS
// See also: SDL_SSE4_2_INTRINSICS
pub const sse_intrinsics = C.SDL_SSE_INTRINSICS // 1

// Defined if (and only if) the compiler supports Intel SSE2 intrinsics.
//
// If this macro is defined, SDL will have already included `<emmintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_SSE_INTRINSICS
// See also: SDL_SSE3_INTRINSICS
// See also: SDL_SSE4_1_INTRINSICS
// See also: SDL_SSE4_2_INTRINSICS
pub const sse2_intrinsics = C.SDL_SSE2_INTRINSICS // 1

// Defined if (and only if) the compiler supports Intel SSE3 intrinsics.
//
// If this macro is defined, SDL will have already included `<pmmintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_SSE_INTRINSICS
// See also: SDL_SSE2_INTRINSICS
// See also: SDL_SSE4_1_INTRINSICS
// See also: SDL_SSE4_2_INTRINSICS
pub const sse3_intrinsics = C.SDL_SSE3_INTRINSICS // 1

// Defined if (and only if) the compiler supports Intel SSE4.1 intrinsics.
//
// If this macro is defined, SDL will have already included `<smmintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_SSE_INTRINSICS
// See also: SDL_SSE2_INTRINSICS
// See also: SDL_SSE3_INTRINSICS
// See also: SDL_SSE4_2_INTRINSICS
pub const sse4_1_intrinsics = C.SDL_SSE4_1_INTRINSICS // 1

// Defined if (and only if) the compiler supports Intel SSE4.2 intrinsics.
//
// If this macro is defined, SDL will have already included `<nmmintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_SSE_INTRINSICS
// See also: SDL_SSE2_INTRINSICS
// See also: SDL_SSE3_INTRINSICS
// See also: SDL_SSE4_1_INTRINSICS
pub const sse4_2_intrinsics = C.SDL_SSE4_2_INTRINSICS // 1

// Defined if (and only if) the compiler supports Intel AVX intrinsics.
//
// If this macro is defined, SDL will have already included `<immintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_AVX2_INTRINSICS
// See also: SDL_AVX512F_INTRINSICS
pub const avx_intrinsics = C.SDL_AVX_INTRINSICS // 1

// Defined if (and only if) the compiler supports Intel AVX2 intrinsics.
//
// If this macro is defined, SDL will have already included `<immintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_AVX_INTRINSICS
// See also: SDL_AVX512F_INTRINSICS
pub const avx2_intrinsics = C.SDL_AVX2_INTRINSICS // 1

// Defined if (and only if) the compiler supports Intel AVX-512F intrinsics.
//
// AVX-512F is also sometimes referred to as "AVX-512 Foundation."
//
// If this macro is defined, SDL will have already included `<immintrin.h>`
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_AVX_INTRINSICS
// See also: SDL_AVX2_INTRINSICS
pub const avx512f_intrinsics = C.SDL_AVX512F_INTRINSICS // 1

// TODO: Non-numerical: #define SDL_HAS_TARGET_ATTRIBS

// TODO: Function: #define SDL_TARGETING(x) __attribute__((target(x)))
