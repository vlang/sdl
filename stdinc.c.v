// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_stdinc.h
//

// SDL provides its own implementation of some of the most important C runtime
// functions.
//
// Using these functions allows an app to have access to common C
// functionality without depending on a specific C runtime (or a C runtime at
// all). More importantly, the SDL implementations work identically across
// platforms, so apps can avoid surprises like snprintf() behaving differently
// between Windows and Linux builds, or itoa() only existing on some
// platforms.
//
// For many of the most common functions, like SDL_memcpy, SDL might just call
// through to the usual C runtime behind the scenes, if it makes sense to do
// so (if it's faster and always available/reliable on a given platform),
// reducing library size and offering the most optimized option.
//
// SDL also offers other C-runtime-adjacent functionality in this header that
// either isn't, strictly speaking, part of any C runtime standards, like
// SDL_crc32() and SDL_reinterpret_cast, etc. It also offers a few better
// options, like SDL_strlcpy(), which functions as a safer form of strcpy().

// A signed 8-bit integer type.
//
// NOTE: This macro is available since SDL 3.2.0.
pub type Sint8 = i8

// An unsigned 8-bit integer type.
//
// NOTE: This macro is available since SDL 3.2.0.
pub type Uint8 = u8

// A signed 16-bit integer type.
//
// NOTE: This macro is available since SDL 3.2.0.
pub type Sint16 = i16

// An unsigned 16-bit integer type.
//
// NOTE: This macro is available since SDL 3.2.0.
pub type Uint16 = u16

// A signed 32-bit integer type.
//
// NOTE: This macro is available since SDL 3.2.0.
pub type Sint32 = int

// An unsigned 32-bit integer type.
//
// NOTE: This macro is available since SDL 3.2.0.
pub type Uint32 = u32

// A signed 64-bit integer type.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: sin_t64_c (SDL_SINT64_C)
pub type Sint64 = i64

// An unsigned 64-bit integer type.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: uin_t64_c (SDL_UINT64_C)
pub type Uint64 = u64

// SDL times are signed, 64-bit integers representing nanoseconds since the
// Unix epoch (Jan 1, 1970).
//
// They can be converted between POSIX time_t values with SDL_NS_TO_SECONDS()
// and SDL_SECONDS_TO_NS(), and between Windows FILETIME values with
// SDL_TimeToWindows() and SDL_TimeFromWindows().
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: maxsin_t64 (SDL_MAX_SINT64)
// See also: minsin_t64 (SDL_MIN_SINT64)
pub type Time = i64

// TODO: Non-numerical: #define bool  unsigned char

// Visual Studio 2017
pub const @false = 0

pub const @true = 1

pub const __bool_true_false_are_defined = C.__bool_true_false_are_defined // 1

// Don't let SDL use "long long" C types.
//
// SDL will define this if it believes the compiler doesn't understand the
// "long long" syntax for C datatypes. This can happen on older compilers.
//
// If _your_ compiler doesn't support "long long" but SDL doesn't know it, it
// is safe to define this yourself to build against the SDL headers.
//
// If this is defined, it will remove access to some C runtime support
// functions, like SDL_ulltoa and SDL_strtoll that refer to this datatype
// explicitly. The rest of SDL will still be available.
//
// SDL's own source code cannot be built with a compiler that has this
// defined, for various technical reasons.
// pub const nolonglong = C.SDL_NOLONGLONG // 1

pub const size_max = C.SDL_SIZE_MAX

// TODO: Function: #define SDL_COMPILE_TIME_ASSERT(name, x) FailToCompileIf_x_IsFalse(x)

// TODO: Function: #define SDL_COMPILE_TIME_ASSERT(name, x)  static_assert(x, #x)

// TODO: Function: #define SDL_COMPILE_TIME_ASSERT(name, x)  static_assert(x, #x)

// TODO: Function: #define SDL_COMPILE_TIME_ASSERT(name, x) _Static_assert(x, #x)

// TODO: Non-numerical: #define SDL_COMPILE_TIME_ASSERT(name, x)               \

// TODO: Function: #define SDL_arraysize(array) (sizeof(array)/sizeof(array[0]))

// TODO: Non-numerical: #define SDL_STRINGIFY_ARG(arg)  #arg

// TODO: Function: #define SDL_reinterpret_cast(type, expression) reinterpret_cast<type>(expression)

// TODO: Function: #define SDL_static_cast(type, expression) static_cast<type>(expression)

// TODO: Function: #define SDL_const_cast(type, expression) const_cast<type>(expression)

// TODO: Function: #define SDL_reinterpret_cast(type, expression) reinterpret_cast<type>(expression)

// TODO: Function: #define SDL_static_cast(type, expression) static_cast<type>(expression)

// TODO: Function: #define SDL_const_cast(type, expression) const_cast<type>(expression)

// TODO: Function: #define SDL_reinterpret_cast(type, expression) ((type)(expression))

// TODO: Function: #define SDL_static_cast(type, expression) ((type)(expression))

// TODO: Function: #define SDL_const_cast(type, expression) ((type)(expression))

// TODO: Non-numerical: #define SDL_FOURCC(A, B, C, D) \

// TODO: Non-numerical: #define SDL_SINT64_C(c)  c ## LL

// TODO: Non-numerical: #define SDL_UINT64_C(c)  c ## ULL

// TODO: Function: #define SDL_SINT64_C(c)  INT64_C(c)

// TODO: Non-numerical: #define SDL_SINT64_C(c)  c ## i64

// TODO: Non-numerical: #define SDL_SINT64_C(c)  c ## L

// TODO: Non-numerical: #define SDL_SINT64_C(c)  c ## LL

// TODO: Function: #define SDL_UINT64_C(c)  UINT64_C(c)

// TODO: Non-numerical: #define SDL_UINT64_C(c)  c ## ui64

// TODO: Non-numerical: #define SDL_UINT64_C(c)  c ## UL

// TODO: Non-numerical: #define SDL_UINT64_C(c)  c ## ULL

pub const max_sint8 = i8(C.SDL_MAX_SINT8) // ((Sint8)0x7F)

pub const min_sint8 = i8(C.SDL_MIN_SINT8) // ((Sint8)(~0x7F))

pub const max_uint8 = u8(C.SDL_MAX_UINT8) // ((Uint8)0xFF)

pub const min_uint8 = u8(C.SDL_MIN_UINT8) // ((Uint8)0x00)

pub const max_sint16 = i16(C.SDL_MAX_SINT16) // ((Sint16)0x7FFF)

pub const min_sint16 = i16(C.SDL_MIN_SINT16) // ((Sint16)(~0x7FFF))

pub const max_uint16 = u16(C.SDL_MAX_UINT16) // ((Uint16)0xFFFF)

pub const min_uint16 = u16(C.SDL_MIN_UINT16) // ((Uint16)0x0000)

pub const max_sint32 = i32(C.SDL_MAX_SINT32) // ((Sint32)0x7FFFFFFF)

pub const min_sint32 = i32(C.SDL_MIN_SINT32) // ((Sint32)(~0x7FFFFFFF))

pub const max_uint32 = u32(C.SDL_MAX_UINT32) // ((Uint32)0xFFFFFFFFu)

pub const min_uint32 = u32(C.SDL_MIN_UINT32) // ((Uint32)0x00000000)

pub const max_sint64 = i64(C.SDL_MAX_SINT64) // SDL_SINT64_C(0x7FFFFFFFFFFFFFFF)

pub const min_sint64 = i64(C.SDL_MIN_SINT64) // ~SDL_SINT64_C(0x7FFFFFFFFFFFFFFF)

pub const max_uint64 = u64(C.SDL_MAX_UINT64) // SDL_UINT64_C(0xFFFFFFFFFFFFFFFF)

pub const min_uint64 = u64(C.SDL_MIN_UINT64) // SDL_UINT64_C(0x0000000000000000)

pub const max_time = i64(C.SDL_MAX_TIME) // SDL_MAX_SINT64

pub const min_time = i64(C.SDL_MIN_TIME) // SDL_MIN_SINT64

pub const flt_epsilon = f32(C.SDL_FLT_EPSILON) // 1.1920928955078125e-07F

// A printf-formatting string for an Sint64 value.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRIs64 " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const pris64 = &char(C.SDL_PRIs64) // 'lld'

// A printf-formatting string for a Uint64 value.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRIu64 " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const priu64 = &char(C.SDL_PRIu64) // 'llu'

// A printf-formatting string for a Uint64 value as lower-case hexadecimal.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRIx64 " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const prix64 = &char(C.SDL_PRIx64) // 'llx'

// A printf-formatting string for a Uint64 value as upper-case hexadecimal.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRIX64 " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const prix64x = &char(C.SDL_PRIX64) // 'llX'

// A printf-formatting string for an Sint32 value.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRIs32 " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const pris32 = &char(C.SDL_PRIs32) // 'd'

// A printf-formatting string for a Uint32 value.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRIu32 " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const priu32 = &char(C.SDL_PRIu32) // 'u'

// A printf-formatting string for a Uint32 value as lower-case hexadecimal.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRIx32 " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const prix32 = &char(C.SDL_PRIx32) // 'x'

// A printf-formatting string for a Uint32 value as upper-case hexadecimal.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRIX32 " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const prix32x = &char(C.SDL_PRIX32) // 'X'

// A printf-formatting string prefix for a `long long` value.
//
// This is just the prefix! You probably actually want SDL_PRILLd, SDL_PRILLu,
// SDL_PRILLx, or SDL_PRILLX instead.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRILL_PREFIX "d bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const prill_prefix = &char(C.SDL_PRILL_PREFIX) // 'll'

// A printf-formatting string for a `long long` value.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRILLd " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const prilld = &char(C.SDL_PRILLd) // SDL_PRILL_PREFIX 'd'

// A printf-formatting string for a `unsigned long long` value.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRILLu " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const prillu = &char(C.SDL_PRILLu) // SDL_PRILL_PREFIX 'u'

// A printf-formatting string for an `unsigned long long` value as lower-case
// hexadecimal.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRILLx " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const prillx = &char(C.SDL_PRILLx) // SDL_PRILL_PREFIX 'x'

// A printf-formatting string for an `unsigned long long` value as upper-case
// hexadecimal.
//
// Use it like this:
//
// ```c
// SDL_Log("There are %" SDL_PRILLX " bottles of beer on the wall.", bottles);
// ```
//
// NOTE: This macro is available since SDL 3.2.0.
pub const prillxx = &char(C.SDL_PRILLX) // SDL_PRILL_PREFIX 'X'

// TODO: Function: #define SDL_IN_BYTECAP(x) _In_bytecount_(x)

// TODO: Function: #define SDL_INOUT_Z_CAP(x) _Inout_z_cap_(x)

// TODO: Function: #define SDL_OUT_Z_CAP(x) _Out_z_cap_(x)

// TODO: Function: #define SDL_OUT_CAP(x) _Out_cap_(x)

// TODO: Function: #define SDL_OUT_BYTECAP(x) _Out_bytecap_(x)

// TODO: Function: #define SDL_OUT_Z_BYTECAP(x) _Out_z_bytecap_(x)

// TODO: Non-numerical: #define SDL_PRINTF_FORMAT_STRING _Printf_format_string_

// TODO: Non-numerical: #define SDL_SCANF_FORMAT_STRING _Scanf_format_string_impl_

// TODO: Function: #define SDL_PRINTF_VARARG_FUNC( fmtargnumber ) __attribute__ (( format( __printf__, fmtargnumber, fmtargnumber+1 )))

// TODO: Function: #define SDL_PRINTF_VARARG_FUNCV( fmtargnumber ) __attribute__(( format( __printf__, fmtargnumber, 0 )))

// TODO: Function: #define SDL_SCANF_VARARG_FUNC( fmtargnumber ) __attribute__ (( format( __scanf__, fmtargnumber, fmtargnumber+1 )))

// TODO: Function: #define SDL_SCANF_VARARG_FUNCV( fmtargnumber ) __attribute__(( format( __scanf__, fmtargnumber, 0 )))

// TODO: Non-numerical: #define SDL_WPRINTF_VARARG_FUNC( fmtargnumber )

// TODO: Non-numerical: #define SDL_WPRINTF_VARARG_FUNCV( fmtargnumber )

// TODO: Function: #define SDL_IN_BYTECAP(x)

// TODO: Function: #define SDL_INOUT_Z_CAP(x)

// TODO: Function: #define SDL_OUT_Z_CAP(x)

// TODO: Function: #define SDL_OUT_CAP(x)

// TODO: Function: #define SDL_OUT_BYTECAP(x)

// TODO: Function: #define SDL_OUT_Z_BYTECAP(x)

// TODO: Non-numerical: #define SDL_PRINTF_FORMAT_STRING

// TODO: Non-numerical: #define SDL_SCANF_FORMAT_STRING

// TODO: Non-numerical: #define SDL_PRINTF_VARARG_FUNC( fmtargnumber )

// TODO: Non-numerical: #define SDL_PRINTF_VARARG_FUNCV( fmtargnumber )

// TODO: Non-numerical: #define SDL_SCANF_VARARG_FUNC( fmtargnumber )

// TODO: Non-numerical: #define SDL_SCANF_VARARG_FUNCV( fmtargnumber )

// TODO: Non-numerical: #define SDL_WPRINTF_VARARG_FUNC( fmtargnumber )

// TODO: Non-numerical: #define SDL_WPRINTF_VARARG_FUNCV( fmtargnumber )

// TODO: Function: #define SDL_IN_BYTECAP(x) _In_bytecount_(x)

// TODO: Function: #define SDL_INOUT_Z_CAP(x) _Inout_z_cap_(x)

// TODO: Function: #define SDL_OUT_Z_CAP(x) _Out_z_cap_(x)

// TODO: Function: #define SDL_OUT_CAP(x) _Out_cap_(x)

// TODO: Function: #define SDL_OUT_BYTECAP(x) _Out_bytecap_(x)

// TODO: Function: #define SDL_OUT_Z_BYTECAP(x) _Out_z_bytecap_(x)

// TODO: Non-numerical: #define SDL_PRINTF_FORMAT_STRING _Printf_format_string_

// TODO: Non-numerical: #define SDL_SCANF_FORMAT_STRING _Scanf_format_string_impl_

// TODO: Function: #define SDL_IN_BYTECAP(x)

// TODO: Function: #define SDL_INOUT_Z_CAP(x)

// TODO: Function: #define SDL_OUT_Z_CAP(x)

// TODO: Function: #define SDL_OUT_CAP(x)

// TODO: Function: #define SDL_OUT_BYTECAP(x)

// TODO: Function: #define SDL_OUT_Z_BYTECAP(x)

// TODO: Non-numerical: #define SDL_PRINTF_FORMAT_STRING

// TODO: Non-numerical: #define SDL_SCANF_FORMAT_STRING

// TODO: Function: #define SDL_PRINTF_VARARG_FUNC( fmtargnumber ) __attribute__ (( format( __printf__, fmtargnumber, fmtargnumber+1 )))

// TODO: Function: #define SDL_PRINTF_VARARG_FUNCV( fmtargnumber ) __attribute__(( format( __printf__, fmtargnumber, 0 )))

// TODO: Function: #define SDL_SCANF_VARARG_FUNC( fmtargnumber ) __attribute__ (( format( __scanf__, fmtargnumber, fmtargnumber+1 )))

// TODO: Function: #define SDL_SCANF_VARARG_FUNCV( fmtargnumber ) __attribute__(( format( __scanf__, fmtargnumber, 0 )))

// TODO: Non-numerical: #define SDL_WPRINTF_VARARG_FUNC( fmtargnumber )

// TODO: Non-numerical: #define SDL_WPRINTF_VARARG_FUNCV( fmtargnumber )

// TODO: Non-numerical: #define SDL_PRINTF_VARARG_FUNC( fmtargnumber )

// TODO: Non-numerical: #define SDL_PRINTF_VARARG_FUNCV( fmtargnumber )

// TODO: Non-numerical: #define SDL_SCANF_VARARG_FUNC( fmtargnumber )

// TODO: Non-numerical: #define SDL_SCANF_VARARG_FUNCV( fmtargnumber )

// TODO: Non-numerical: #define SDL_WPRINTF_VARARG_FUNC( fmtargnumber )

// TODO: Non-numerical: #define SDL_WPRINTF_VARARG_FUNCV( fmtargnumber )

@[typedef]
pub struct C.SDL_alignment_test {
pub mut:
	a u8
	b voidptr
}

pub type AlignmentTest = C.SDL_alignment_test

// DUMMYENUM is C.SDL_DUMMY_ENUM
pub enum DUMMYENUM {
	value = C.DUMMY_ENUM_VALUE
}

// TODO: Non-numerical: #define SDL_INIT_INTERFACE(iface)               \

// TODO: Function: #define SDL_stack_alloc(type, count)    (type*)alloca(sizeof(type)*(count))

// TODO: Function: #define SDL_stack_free(data)

// TODO: Function: #define SDL_stack_alloc(type, count)    (type*)alloca(sizeof(type)*(count))

// TODO: Function: #define SDL_stack_free(data)

// TODO: Function: #define SDL_stack_alloc(type, count)    (type*)SDL_malloc(sizeof(type)*(count))

// TODO: Function: #define SDL_stack_free(data)            SDL_free(data)

// C.SDL_malloc [official documentation](https://wiki.libsdl.org/SDL3/SDL_malloc)
fn C.SDL_malloc(size usize) voidptr

// malloc allocates uninitialized memory.
//
// The allocated memory returned by this function must be freed with
// SDL_free().
//
// If `size` is 0, it will be set to 1.
//
// If you want to allocate memory aligned to a specific alignment, consider
// using SDL_aligned_alloc().
//
// `size` size the size to allocate.
// returns a pointer to the allocated memory, or NULL if allocation failed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: free (SDL_free)
// See also: calloc (SDL_calloc)
// See also: realloc (SDL_realloc)
// See also: aligned_alloc (SDL_aligned_alloc)
pub fn malloc(size usize) voidptr {
	return C.SDL_malloc(size)
}

// C.SDL_calloc [official documentation](https://wiki.libsdl.org/SDL3/SDL_calloc)
fn C.SDL_calloc(nmemb usize, size usize) voidptr

// calloc allocates a zero-initialized array.
//
// The memory returned by this function must be freed with SDL_free().
//
// If either of `nmemb` or `size` is 0, they will both be set to 1.
//
// `nmemb` nmemb the number of elements in the array.
// `size` size the size of each element of the array.
// returns a pointer to the allocated array, or NULL if allocation failed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: free (SDL_free)
// See also: malloc (SDL_malloc)
// See also: realloc (SDL_realloc)
//
pub fn calloc(nmemb usize, size usize) voidptr {
	return C.SDL_calloc(nmemb, size)
}

// C.SDL_realloc [official documentation](https://wiki.libsdl.org/SDL3/SDL_realloc)
fn C.SDL_realloc(mem voidptr, size usize) voidptr

// realloc changes the size of allocated memory.
//
// The memory returned by this function must be freed with SDL_free().
//
// If `size` is 0, it will be set to 1. Note that this is unlike some other C
// runtime `realloc` implementations, which may treat `realloc(mem, 0)` the
// same way as `free(mem)`.
//
// If `mem` is NULL, the behavior of this function is equivalent to
// SDL_malloc(). Otherwise, the function can have one of three possible
// outcomes:
//
// - If it returns the same pointer as `mem`, it means that `mem` was resized
//   in place without freeing.
// - If it returns a different non-NULL pointer, it means that `mem` was freed
//   and cannot be dereferenced anymore.
// - If it returns NULL (indicating failure), then `mem` will remain valid and
//   must still be freed with SDL_free().
//
// `mem` mem a pointer to allocated memory to reallocate, or NULL.
// `size` size the new size of the memory.
// returns a pointer to the newly allocated memory, or NULL if allocation
//          failed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: free (SDL_free)
// See also: malloc (SDL_malloc)
// See also: calloc (SDL_calloc)
//
pub fn realloc(mem voidptr, size usize) voidptr {
	return C.SDL_realloc(mem, size)
}

// C.SDL_free [official documentation](https://wiki.libsdl.org/SDL3/SDL_free)
fn C.SDL_free(mem voidptr)

// free frees allocated memory.
//
// The pointer is no longer valid after this call and cannot be dereferenced
// anymore.
//
// If `mem` is NULL, this function does nothing.
//
// `mem` mem a pointer to allocated memory, or NULL.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: malloc (SDL_malloc)
// See also: calloc (SDL_calloc)
// See also: realloc (SDL_realloc)
pub fn free(mem voidptr) {
	C.SDL_free(mem)
}

// MallocFunc as callback used to implement SDL_malloc().
//
// SDL will always ensure that the passed `size` is greater than 0.
//
// `size` size the size to allocate.
// returns a pointer to the allocated memory, or NULL if allocation failed.
//
// NOTE: (thread safety) It should be safe to call this callback from any thread.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: malloc (SDL_malloc)
// See also: get_original_memory_functions (SDL_GetOriginalMemoryFunctions)
// See also: get_memory_functions (SDL_GetMemoryFunctions)
// See also: set_memory_functions (SDL_SetMemoryFunctions)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_MallocFunc)
pub type MallocFunc = fn (size usize) voidptr

// CallocFunc as callback used to implement SDL_calloc().
//
// SDL will always ensure that the passed `nmemb` and `size` are both greater
// than 0.
//
// `nmemb` nmemb the number of elements in the array.
// `size` size the size of each element of the array.
// returns a pointer to the allocated array, or NULL if allocation failed.
//
// NOTE: (thread safety) It should be safe to call this callback from any thread.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: calloc (SDL_calloc)
// See also: get_original_memory_functions (SDL_GetOriginalMemoryFunctions)
// See also: get_memory_functions (SDL_GetMemoryFunctions)
// See also: set_memory_functions (SDL_SetMemoryFunctions)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_CallocFunc)
pub type CallocFunc = fn (nmemb usize, size usize) voidptr

// ReallocFunc as callback used to implement SDL_realloc().
//
// SDL will always ensure that the passed `size` is greater than 0.
//
// `mem` mem a pointer to allocated memory to reallocate, or NULL.
// `size` size the new size of the memory.
// returns a pointer to the newly allocated memory, or NULL if allocation
//          failed.
//
// NOTE: (thread safety) It should be safe to call this callback from any thread.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: realloc (SDL_realloc)
// See also: get_original_memory_functions (SDL_GetOriginalMemoryFunctions)
// See also: get_memory_functions (SDL_GetMemoryFunctions)
// See also: set_memory_functions (SDL_SetMemoryFunctions)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_ReallocFunc)
pub type ReallocFunc = fn (mem voidptr, size usize) voidptr

// FreeFunc as callback used to implement SDL_free().
//
// SDL will always ensure that the passed `mem` is a non-NULL pointer.
//
// `mem` mem a pointer to allocated memory.
//
// NOTE: (thread safety) It should be safe to call this callback from any thread.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: free (SDL_free)
// See also: get_original_memory_functions (SDL_GetOriginalMemoryFunctions)
// See also: get_memory_functions (SDL_GetMemoryFunctions)
// See also: set_memory_functions (SDL_SetMemoryFunctions)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_FreeFunc)
pub type FreeFunc = fn (mem voidptr)

// C.SDL_GetOriginalMemoryFunctions [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetOriginalMemoryFunctions)
fn C.SDL_GetOriginalMemoryFunctions(malloc_func &MallocFunc, calloc_func &CallocFunc, realloc_func &ReallocFunc, free_func &FreeFunc)

// get_original_memory_functions gets the original set of SDL memory functions.
//
// This is what SDL_malloc and friends will use by default, if there has been
// no call to SDL_SetMemoryFunctions. This is not necessarily using the C
// runtime's `malloc` functions behind the scenes! Different platforms and
// build configurations might do any number of unexpected things.
//
// `malloc_func` malloc_func filled with malloc function.
// `calloc_func` calloc_func filled with calloc function.
// `realloc_func` realloc_func filled with realloc function.
// `free_func` free_func filled with free function.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_original_memory_functions(malloc_func &MallocFunc, calloc_func &CallocFunc, realloc_func &ReallocFunc, free_func &FreeFunc) {
	C.SDL_GetOriginalMemoryFunctions(malloc_func, calloc_func, realloc_func, free_func)
}

// C.SDL_GetMemoryFunctions [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetMemoryFunctions)
fn C.SDL_GetMemoryFunctions(malloc_func &MallocFunc, calloc_func &CallocFunc, realloc_func &ReallocFunc, free_func &FreeFunc)

// get_memory_functions gets the current set of SDL memory functions.
//
// `malloc_func` malloc_func filled with malloc function.
// `calloc_func` calloc_func filled with calloc function.
// `realloc_func` realloc_func filled with realloc function.
// `free_func` free_func filled with free function.
//
// NOTE: (thread safety) This does not hold a lock, so do not call this in the
//               unlikely event of a background thread calling
//               SDL_SetMemoryFunctions simultaneously.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_memory_functions (SDL_SetMemoryFunctions)
// See also: get_original_memory_functions (SDL_GetOriginalMemoryFunctions)
pub fn get_memory_functions(malloc_func &MallocFunc, calloc_func &CallocFunc, realloc_func &ReallocFunc, free_func &FreeFunc) {
	C.SDL_GetMemoryFunctions(malloc_func, calloc_func, realloc_func, free_func)
}

// C.SDL_SetMemoryFunctions [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetMemoryFunctions)
fn C.SDL_SetMemoryFunctions(malloc_func MallocFunc, calloc_func CallocFunc, realloc_func ReallocFunc, free_func FreeFunc) bool

// set_memory_functions replaces SDL's memory allocation functions with a custom set.
//
// It is not safe to call this function once any allocations have been made,
// as future calls to SDL_free will use the new allocator, even if they came
// from an SDL_malloc made with the old one!
//
// If used, usually this needs to be the first call made into the SDL library,
// if not the very first thing done at program startup time.
//
// `malloc_func` malloc_func custom malloc function.
// `calloc_func` calloc_func custom calloc function.
// `realloc_func` realloc_func custom realloc function.
// `free_func` free_func custom free function.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread, but one
//               should not replace the memory functions once any allocations
//               are made!
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_memory_functions (SDL_GetMemoryFunctions)
// See also: get_original_memory_functions (SDL_GetOriginalMemoryFunctions)
pub fn set_memory_functions(malloc_func MallocFunc, calloc_func CallocFunc, realloc_func ReallocFunc, free_func FreeFunc) bool {
	return C.SDL_SetMemoryFunctions(malloc_func, calloc_func, realloc_func, free_func)
}

// C.SDL_aligned_alloc [official documentation](https://wiki.libsdl.org/SDL3/SDL_aligned_alloc)
fn C.SDL_aligned_alloc(alignment usize, size usize) voidptr

// aligned_alloc allocates memory aligned to a specific alignment.
//
// The memory returned by this function must be freed with SDL_aligned_free(),
// _not_ SDL_free().
//
// If `alignment` is less than the size of `void *`, it will be increased to
// match that.
//
// The returned memory address will be a multiple of the alignment value, and
// the size of the memory allocated will be a multiple of the alignment value.
//
// `alignment` alignment the alignment of the memory.
// `size` size the size to allocate.
// returns a pointer to the aligned memory, or NULL if allocation failed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: aligned_free (SDL_aligned_free)
pub fn aligned_alloc(alignment usize, size usize) voidptr {
	return C.SDL_aligned_alloc(alignment, size)
}

// C.SDL_aligned_free [official documentation](https://wiki.libsdl.org/SDL3/SDL_aligned_free)
fn C.SDL_aligned_free(mem voidptr)

// aligned_free frees memory allocated by SDL_aligned_alloc().
//
// The pointer is no longer valid after this call and cannot be dereferenced
// anymore.
//
// If `mem` is NULL, this function does nothing.
//
// `mem` mem a pointer previously returned by SDL_aligned_alloc(), or NULL.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: aligned_alloc (SDL_aligned_alloc)
pub fn aligned_free(mem voidptr) {
	C.SDL_aligned_free(mem)
}

// C.SDL_GetNumAllocations [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumAllocations)
fn C.SDL_GetNumAllocations() int

// get_num_allocations gets the number of outstanding (unfreed) allocations.
//
// returns the number of allocations or -1 if allocation counting is
//          disabled.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_num_allocations() int {
	return C.SDL_GetNumAllocations()
}

@[noinit; typedef]
pub struct C.SDL_Environment {
	// NOTE: Opaque type
}

pub type Environment = C.SDL_Environment

// C.SDL_GetEnvironment [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetEnvironment)
fn C.SDL_GetEnvironment() &Environment

// get_environment gets the process environment.
//
// This is initialized at application start and is not affected by setenv()
// and unsetenv() calls after that point. Use SDL_SetEnvironmentVariable() and
// SDL_UnsetEnvironmentVariable() if you want to modify this environment, or
// SDL_setenv_unsafe() or SDL_unsetenv_unsafe() if you want changes to persist
// in the C runtime environment after SDL_Quit().
//
// returns a pointer to the environment for the process or NULL on failure;
//          call SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_environment_variable (SDL_GetEnvironmentVariable)
// See also: get_environment_variables (SDL_GetEnvironmentVariables)
// See also: set_environment_variable (SDL_SetEnvironmentVariable)
// See also: unset_environment_variable (SDL_UnsetEnvironmentVariable)
pub fn get_environment() &Environment {
	return C.SDL_GetEnvironment()
}

// C.SDL_CreateEnvironment [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateEnvironment)
fn C.SDL_CreateEnvironment(populated bool) &Environment

// create_environment creates a set of environment variables
//
// `populated` populated true to initialize it from the C runtime environment,
//                  false to create an empty environment.
// returns a pointer to the new environment or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) If `populated` is false, it is safe to call this function
//               from any thread, otherwise it is safe if no other threads are
//               calling setenv() or unsetenv()
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_environment_variable (SDL_GetEnvironmentVariable)
// See also: get_environment_variables (SDL_GetEnvironmentVariables)
// See also: set_environment_variable (SDL_SetEnvironmentVariable)
// See also: unset_environment_variable (SDL_UnsetEnvironmentVariable)
// See also: destroy_environment (SDL_DestroyEnvironment)
pub fn create_environment(populated bool) &Environment {
	return C.SDL_CreateEnvironment(populated)
}

// C.SDL_GetEnvironmentVariable [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetEnvironmentVariable)
fn C.SDL_GetEnvironmentVariable(env &Environment, const_name &char) &char

// get_environment_variable gets the value of a variable in the environment.
//
// `env` env the environment to query.
// `name` name the name of the variable to get.
// returns a pointer to the value of the variable or NULL if it can't be
//          found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_environment (SDL_GetEnvironment)
// See also: create_environment (SDL_CreateEnvironment)
// See also: get_environment_variables (SDL_GetEnvironmentVariables)
// See also: set_environment_variable (SDL_SetEnvironmentVariable)
// See also: unset_environment_variable (SDL_UnsetEnvironmentVariable)
pub fn get_environment_variable(env &Environment, const_name &char) &char {
	return &char(C.SDL_GetEnvironmentVariable(env, const_name))
}

// C.SDL_GetEnvironmentVariables [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetEnvironmentVariables)
fn C.SDL_GetEnvironmentVariables(env &Environment) &&char

// get_environment_variables gets all variables in the environment.
//
// `env` env the environment to query.
// returns a NULL terminated array of pointers to environment variables in
//          the form "variable=value" or NULL on failure; call SDL_GetError()
//          for more information. This is a single allocation that should be
//          freed with SDL_free() when it is no longer needed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_environment (SDL_GetEnvironment)
// See also: create_environment (SDL_CreateEnvironment)
// See also: get_environment_variables (SDL_GetEnvironmentVariables)
// See also: set_environment_variable (SDL_SetEnvironmentVariable)
// See also: unset_environment_variable (SDL_UnsetEnvironmentVariable)
pub fn get_environment_variables(env &Environment) &&char {
	return C.SDL_GetEnvironmentVariables(env)
}

// C.SDL_SetEnvironmentVariable [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetEnvironmentVariable)
fn C.SDL_SetEnvironmentVariable(env &Environment, const_name &char, const_value &char, overwrite bool) bool

// set_environment_variable sets the value of a variable in the environment.
//
// `env` env the environment to modify.
// `name` name the name of the variable to set.
// `value` value the value of the variable to set.
// `overwrite` overwrite true to overwrite the variable if it exists, false to
//                  return success without setting the variable if it already
//                  exists.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_environment (SDL_GetEnvironment)
// See also: create_environment (SDL_CreateEnvironment)
// See also: get_environment_variable (SDL_GetEnvironmentVariable)
// See also: get_environment_variables (SDL_GetEnvironmentVariables)
// See also: unset_environment_variable (SDL_UnsetEnvironmentVariable)
pub fn set_environment_variable(env &Environment, const_name &char, const_value &char, overwrite bool) bool {
	return C.SDL_SetEnvironmentVariable(env, const_name, const_value, overwrite)
}

// C.SDL_UnsetEnvironmentVariable [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnsetEnvironmentVariable)
fn C.SDL_UnsetEnvironmentVariable(env &Environment, const_name &char) bool

// unset_environment_variable clears a variable from the environment.
//
// `env` env the environment to modify.
// `name` name the name of the variable to unset.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_environment (SDL_GetEnvironment)
// See also: create_environment (SDL_CreateEnvironment)
// See also: get_environment_variable (SDL_GetEnvironmentVariable)
// See also: get_environment_variables (SDL_GetEnvironmentVariables)
// See also: set_environment_variable (SDL_SetEnvironmentVariable)
// See also: unset_environment_variable (SDL_UnsetEnvironmentVariable)
pub fn unset_environment_variable(env &Environment, const_name &char) bool {
	return C.SDL_UnsetEnvironmentVariable(env, const_name)
}

// C.SDL_DestroyEnvironment [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyEnvironment)
fn C.SDL_DestroyEnvironment(env &Environment)

// destroy_environment destroys a set of environment variables.
//
// `env` env the environment to destroy.
//
// NOTE: (thread safety) It is safe to call this function from any thread, as long as
//               the environment is no longer in use.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_environment (SDL_CreateEnvironment)
pub fn destroy_environment(env &Environment) {
	C.SDL_DestroyEnvironment(env)
}

// C.SDL_getenv [official documentation](https://wiki.libsdl.org/SDL3/SDL_getenv)
fn C.SDL_getenv(const_name &char) &char

// getenv gets the value of a variable in the environment.
//
// This function uses SDL's cached copy of the environment and is thread-safe.
//
// `name` name the name of the variable to get.
// returns a pointer to the value of the variable or NULL if it can't be
//          found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn getenv(const_name &char) &char {
	return &char(C.SDL_getenv(const_name))
}

// C.SDL_getenv_unsafe [official documentation](https://wiki.libsdl.org/SDL3/SDL_getenv_unsafe)
fn C.SDL_getenv_unsafe(const_name &char) &char

// getenv_unsafe gets the value of a variable in the environment.
//
// This function bypasses SDL's cached copy of the environment and is not
// thread-safe.
//
// `name` name the name of the variable to get.
// returns a pointer to the value of the variable or NULL if it can't be
//          found.
//
// NOTE: (thread safety) This function is not thread safe, consider using SDL_getenv()
//               instead.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: getenv (SDL_getenv)
pub fn getenv_unsafe(const_name &char) &char {
	return &char(C.SDL_getenv_unsafe(const_name))
}

// C.SDL_setenv_unsafe [official documentation](https://wiki.libsdl.org/SDL3/SDL_setenv_unsafe)
fn C.SDL_setenv_unsafe(const_name &char, const_value &char, overwrite int) int

// setenv_unsafe sets the value of a variable in the environment.
//
// `name` name the name of the variable to set.
// `value` value the value of the variable to set.
// `overwrite` overwrite 1 to overwrite the variable if it exists, 0 to return
//                  success without setting the variable if it already exists.
// returns 0 on success, -1 on error.
//
// NOTE: (thread safety) This function is not thread safe, consider using
//               SDL_SetEnvironmentVariable() instead.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: set_environment_variable (SDL_SetEnvironmentVariable)
pub fn setenv_unsafe(const_name &char, const_value &char, overwrite int) int {
	return C.SDL_setenv_unsafe(const_name, const_value, overwrite)
}

// C.SDL_unsetenv_unsafe [official documentation](https://wiki.libsdl.org/SDL3/SDL_unsetenv_unsafe)
fn C.SDL_unsetenv_unsafe(const_name &char) int

// unsetenv_unsafe clears a variable from the environment.
//
// `name` name the name of the variable to unset.
// returns 0 on success, -1 on error.
//
// NOTE: (thread safety) This function is not thread safe, consider using
//               SDL_UnsetEnvironmentVariable() instead.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: unset_environment_variable (SDL_UnsetEnvironmentVariable)
pub fn unsetenv_unsafe(const_name &char) int {
	return C.SDL_unsetenv_unsafe(const_name)
}

// CompareCallback as callback used with SDL sorting and binary search functions.
//
// `a` a a pointer to the first element being compared.
// `b` b a pointer to the second element being compared.
// returns -1 if `a` should be sorted before `b`, 1 if `b` should be sorted
//          before `a`, 0 if they are equal. If two elements are equal, their
//          order in the sorted array is undefined.
//
// NOTE: This callback is available since SDL 3.2.0.
//
// See also: bsearch (SDL_bsearch)
// See also: qsort (SDL_qsort)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_CompareCallback)
pub type CompareCallback = fn (const_a voidptr, const_b voidptr) int

// C.SDL_qsort [official documentation](https://wiki.libsdl.org/SDL3/SDL_qsort)
fn C.SDL_qsort(base voidptr, nmemb usize, size usize, compare CompareCallback)

// qsort sorts an array.
//
// For example:
//
// ```c
// typedef struct {
//     int key;
//     const char *string;
// } data;
//
// int SDLCALL compare(const void *a, const void *b)
// {
//     const data *A = (const data *)a;
//     const data *B = (const data *)b;
//
//     if (A->n < B->n) {
//         return -1;
//     } else if (B->n < A->n) {
//         return 1;
//     } else {
//         return 0;
//     }
// }
//
// data values[] = {
//     { 3, "third" }, { 1, "first" }, { 2, "second" }
// };
//
// SDL_qsort(values, SDL_arraysize(values), sizeof(values[0]), compare);
// ```
//
// `base` base a pointer to the start of the array.
// `nmemb` nmemb the number of elements in the array.
// `size` size the size of the elements in the array.
// `compare` compare a function used to compare elements in the array.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: bsearch (SDL_bsearch)
// See also: qsort_r (SDL_qsort_r)
pub fn qsort(base voidptr, nmemb usize, size usize, compare CompareCallback) {
	C.SDL_qsort(base, nmemb, size, compare)
}

// C.SDL_bsearch [official documentation](https://wiki.libsdl.org/SDL3/SDL_bsearch)
fn C.SDL_bsearch(const_key voidptr, const_base voidptr, nmemb usize, size usize, compare CompareCallback) voidptr

// bsearch performs a binary search on a previously sorted array.
//
// For example:
//
// ```c
// typedef struct {
//     int key;
//     const char *string;
// } data;
//
// int SDLCALL compare(const void *a, const void *b)
// {
//     const data *A = (const data *)a;
//     const data *B = (const data *)b;
//
//     if (A->n < B->n) {
//         return -1;
//     } else if (B->n < A->n) {
//         return 1;
//     } else {
//         return 0;
//     }
// }
//
// data values[] = {
//     { 1, "first" }, { 2, "second" }, { 3, "third" }
// };
// data key = { 2, NULL };
//
// data *result = SDL_bsearch(&key, values, SDL_arraysize(values), sizeof(values[0]), compare);
// ```
//
// `key` key a pointer to a key equal to the element being searched for.
// `base` base a pointer to the start of the array.
// `nmemb` nmemb the number of elements in the array.
// `size` size the size of the elements in the array.
// `compare` compare a function used to compare elements in the array.
// returns a pointer to the matching element in the array, or NULL if not
//          found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: bsearch_r (SDL_bsearch_r)
// See also: qsort (SDL_qsort)
pub fn bsearch(const_key voidptr, const_base voidptr, nmemb usize, size usize, compare CompareCallback) voidptr {
	return C.SDL_bsearch(const_key, const_base, nmemb, size, compare)
}

// CompareCallbackR as callback used with SDL sorting and binary search functions.
//
// `userdata` userdata the `userdata` pointer passed to the sort function.
// `a` a a pointer to the first element being compared.
// `b` b a pointer to the second element being compared.
// returns -1 if `a` should be sorted before `b`, 1 if `b` should be sorted
//          before `a`, 0 if they are equal. If two elements are equal, their
//          order in the sorted array is undefined.
//
// NOTE: This callback is available since SDL 3.2.0.
//
// See also: qsort_r (SDL_qsort_r)
// See also: bsearch_r (SDL_bsearch_r)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_CompareCallbackR)
pub type CompareCallbackR = fn (userdata voidptr, const_a voidptr, const_b voidptr) int

// C.SDL_qsort_r [official documentation](https://wiki.libsdl.org/SDL3/SDL_qsort_r)
fn C.SDL_qsort_r(base voidptr, nmemb usize, size usize, compare CompareCallbackR, userdata voidptr)

// qsort_r sorts an array, passing a userdata pointer to the compare function.
//
// For example:
//
// ```c
// typedef enum {
//     sort_increasing,
//     sort_decreasing,
// } sort_method;
//
// typedef struct {
//     int key;
//     const char *string;
// } data;
//
// int SDLCALL compare(const void *userdata, const void *a, const void *b)
// {
//     sort_method method = (sort_method)(uintptr_t)userdata;
//     const data *A = (const data *)a;
//     const data *B = (const data *)b;
//
//     if (A->key < B->key) {
//         return (method == sort_increasing) ? -1 : 1;
//     } else if (B->key < A->key) {
//         return (method == sort_increasing) ? 1 : -1;
//     } else {
//         return 0;
//     }
// }
//
// data values[] = {
//     { 3, "third" }, { 1, "first" }, { 2, "second" }
// };
//
// SDL_qsort_r(values, SDL_arraysize(values), sizeof(values[0]), compare, (const void *)(uintptr_t)sort_increasing);
// ```
//
// `base` base a pointer to the start of the array.
// `nmemb` nmemb the number of elements in the array.
// `size` size the size of the elements in the array.
// `compare` compare a function used to compare elements in the array.
// `userdata` userdata a pointer to pass to the compare function.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: bsearch_r (SDL_bsearch_r)
// See also: qsort (SDL_qsort)
pub fn qsort_r(base voidptr, nmemb usize, size usize, compare CompareCallbackR, userdata voidptr) {
	C.SDL_qsort_r(base, nmemb, size, compare, userdata)
}

// C.SDL_bsearch_r [official documentation](https://wiki.libsdl.org/SDL3/SDL_bsearch_r)
fn C.SDL_bsearch_r(const_key voidptr, const_base voidptr, nmemb usize, size usize, compare CompareCallbackR, userdata voidptr) voidptr

// bsearch_r performs a binary search on a previously sorted array, passing a userdata
// pointer to the compare function.
//
// For example:
//
// ```c
// typedef enum {
//     sort_increasing,
//     sort_decreasing,
// } sort_method;
//
// typedef struct {
//     int key;
//     const char *string;
// } data;
//
// int SDLCALL compare(const void *userdata, const void *a, const void *b)
// {
//     sort_method method = (sort_method)(uintptr_t)userdata;
//     const data *A = (const data *)a;
//     const data *B = (const data *)b;
//
//     if (A->key < B->key) {
//         return (method == sort_increasing) ? -1 : 1;
//     } else if (B->key < A->key) {
//         return (method == sort_increasing) ? 1 : -1;
//     } else {
//         return 0;
//     }
// }
//
// data values[] = {
//     { 1, "first" }, { 2, "second" }, { 3, "third" }
// };
// data key = { 2, NULL };
//
// data *result = SDL_bsearch_r(&key, values, SDL_arraysize(values), sizeof(values[0]), compare, (const void *)(uintptr_t)sort_increasing);
// ```
//
// `key` key a pointer to a key equal to the element being searched for.
// `base` base a pointer to the start of the array.
// `nmemb` nmemb the number of elements in the array.
// `size` size the size of the elements in the array.
// `compare` compare a function used to compare elements in the array.
// `userdata` userdata a pointer to pass to the compare function.
// returns a pointer to the matching element in the array, or NULL if not
//          found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: bsearch (SDL_bsearch)
// See also: qsort_r (SDL_qsort_r)
pub fn bsearch_r(const_key voidptr, const_base voidptr, nmemb usize, size usize, compare CompareCallbackR, userdata voidptr) voidptr {
	return C.SDL_bsearch_r(const_key, const_base, nmemb, size, compare, userdata)
}

// C.SDL_abs [official documentation](https://wiki.libsdl.org/SDL3/SDL_abs)
fn C.SDL_abs(x int) int

// abs computes the absolute value of `x`.
//
// `x` x an integer value.
// returns the absolute value of x.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn abs(x int) int {
	return C.SDL_abs(x)
}

// TODO: Function: #define SDL_min(x, y) (((x) < (y)) ? (x) : (y))

// TODO: Function: #define SDL_max(x, y) (((x) > (y)) ? (x) : (y))

// TODO: Function: #define SDL_clamp(x, a, b) (((x) < (a)) ? (a) : (((x) > (b)) ? (b) : (x)))

// C.SDL_isalpha [official documentation](https://wiki.libsdl.org/SDL3/SDL_isalpha)
fn C.SDL_isalpha(x int) int

// isalpha querys if a character is alphabetic (a letter).
//
// **WARNING**: Regardless of system locale, this will only treat ASCII values
// for English 'a-z' and 'A-Z' as true.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn isalpha(x int) int {
	return C.SDL_isalpha(x)
}

// C.SDL_isalnum [official documentation](https://wiki.libsdl.org/SDL3/SDL_isalnum)
fn C.SDL_isalnum(x int) int

// isalnum querys if a character is alphabetic (a letter) or a number.
//
// **WARNING**: Regardless of system locale, this will only treat ASCII values
// for English 'a-z', 'A-Z', and '0-9' as true.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn isalnum(x int) int {
	return C.SDL_isalnum(x)
}

// C.SDL_isblank [official documentation](https://wiki.libsdl.org/SDL3/SDL_isblank)
fn C.SDL_isblank(x int) int

// isblank reports if a character is blank (a space or tab).
//
// **WARNING**: Regardless of system locale, this will only treat ASCII values
// 0x20 (space) or 0x9 (tab) as true.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn isblank(x int) int {
	return C.SDL_isblank(x)
}

// C.SDL_iscntrl [official documentation](https://wiki.libsdl.org/SDL3/SDL_iscntrl)
fn C.SDL_iscntrl(x int) int

// iscntrl reports if a character is a control character.
//
// **WARNING**: Regardless of system locale, this will only treat ASCII values
// 0 through 0x1F, and 0x7F, as true.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn iscntrl(x int) int {
	return C.SDL_iscntrl(x)
}

// C.SDL_isdigit [official documentation](https://wiki.libsdl.org/SDL3/SDL_isdigit)
fn C.SDL_isdigit(x int) int

// isdigit reports if a character is a numeric digit.
//
// **WARNING**: Regardless of system locale, this will only treat ASCII values
// '0' (0x30) through '9' (0x39), as true.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn isdigit(x int) int {
	return C.SDL_isdigit(x)
}

// C.SDL_isxdigit [official documentation](https://wiki.libsdl.org/SDL3/SDL_isxdigit)
fn C.SDL_isxdigit(x int) int

// isxdigit reports if a character is a hexadecimal digit.
//
// **WARNING**: Regardless of system locale, this will only treat ASCII values
// 'A' through 'F', 'a' through 'f', and '0' through '9', as true.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn isxdigit(x int) int {
	return C.SDL_isxdigit(x)
}

// C.SDL_ispunct [official documentation](https://wiki.libsdl.org/SDL3/SDL_ispunct)
fn C.SDL_ispunct(x int) int

// ispunct reports if a character is a punctuation mark.
//
// **WARNING**: Regardless of system locale, this is equivalent to
// `((SDL_isgraph(x)) && (!SDL_isalnum(x)))`.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: isgraph (SDL_isgraph)
// See also: isalnum (SDL_isalnum)
pub fn ispunct(x int) int {
	return C.SDL_ispunct(x)
}

// C.SDL_isspace [official documentation](https://wiki.libsdl.org/SDL3/SDL_isspace)
fn C.SDL_isspace(x int) int

// isspace reports if a character is whitespace.
//
// **WARNING**: Regardless of system locale, this will only treat the
// following ASCII values as true:
//
// - space (0x20)
// - tab (0x09)
// - newline (0x0A)
// - vertical tab (0x0B)
// - form feed (0x0C)
// - return (0x0D)
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn isspace(x int) int {
	return C.SDL_isspace(x)
}

// C.SDL_isupper [official documentation](https://wiki.libsdl.org/SDL3/SDL_isupper)
fn C.SDL_isupper(x int) int

// isupper reports if a character is upper case.
//
// **WARNING**: Regardless of system locale, this will only treat ASCII values
// 'A' through 'Z' as true.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn isupper(x int) int {
	return C.SDL_isupper(x)
}

// C.SDL_islower [official documentation](https://wiki.libsdl.org/SDL3/SDL_islower)
fn C.SDL_islower(x int) int

// islower reports if a character is lower case.
//
// **WARNING**: Regardless of system locale, this will only treat ASCII values
// 'a' through 'z' as true.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn islower(x int) int {
	return C.SDL_islower(x)
}

// C.SDL_isprint [official documentation](https://wiki.libsdl.org/SDL3/SDL_isprint)
fn C.SDL_isprint(x int) int

// isprint reports if a character is "printable".
//
// Be advised that "printable" has a definition that goes back to text
// terminals from the dawn of computing, making this a sort of special case
// function that is not suitable for Unicode (or most any) text management.
//
// **WARNING**: Regardless of system locale, this will only treat ASCII values
// ' ' (0x20) through '~' (0x7E) as true.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn isprint(x int) int {
	return C.SDL_isprint(x)
}

// C.SDL_isgraph [official documentation](https://wiki.libsdl.org/SDL3/SDL_isgraph)
fn C.SDL_isgraph(x int) int

// isgraph reports if a character is any "printable" except space.
//
// Be advised that "printable" has a definition that goes back to text
// terminals from the dawn of computing, making this a sort of special case
// function that is not suitable for Unicode (or most any) text management.
//
// **WARNING**: Regardless of system locale, this is equivalent to
// `(SDL_isprint(x)) && ((x) != ' ')`.
//
// `x` x character value to check.
// returns non-zero if x falls within the character class, zero otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: isprint (SDL_isprint)
pub fn isgraph(x int) int {
	return C.SDL_isgraph(x)
}

// C.SDL_toupper [official documentation](https://wiki.libsdl.org/SDL3/SDL_toupper)
fn C.SDL_toupper(x int) int

// toupper converts low-ASCII English letters to uppercase.
//
// **WARNING**: Regardless of system locale, this will only convert ASCII
// values 'a' through 'z' to uppercase.
//
// This function returns the uppercase equivalent of `x`. If a character
// cannot be converted, or is already uppercase, this function returns `x`.
//
// `x` x character value to check.
// returns capitalized version of x, or x if no conversion available.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn toupper(x int) int {
	return C.SDL_toupper(x)
}

// C.SDL_tolower [official documentation](https://wiki.libsdl.org/SDL3/SDL_tolower)
fn C.SDL_tolower(x int) int

// tolower converts low-ASCII English letters to lowercase.
//
// **WARNING**: Regardless of system locale, this will only convert ASCII
// values 'A' through 'Z' to lowercase.
//
// This function returns the lowercase equivalent of `x`. If a character
// cannot be converted, or is already lowercase, this function returns `x`.
//
// `x` x character value to check.
// returns lowercase version of x, or x if no conversion available.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn tolower(x int) int {
	return C.SDL_tolower(x)
}

// C.SDL_crc16 [official documentation](https://wiki.libsdl.org/SDL3/SDL_crc16)
fn C.SDL_crc16(crc u16, const_data voidptr, len usize) u16

// crc16 calculates a CRC-16 value.
//
// https://en.wikipedia.org/wiki/Cyclic_redundancy_check
//
// This function can be called multiple times, to stream data to be
// checksummed in blocks. Each call must provide the previous CRC-16 return
// value to be updated with the next block. The first call to this function
// for a set of blocks should pass in a zero CRC value.
//
// `crc` crc the current checksum for this data set, or 0 for a new data set.
// `data` data a new block of data to add to the checksum.
// `len` len the size, in bytes, of the new block of data.
// returns a CRC-16 checksum value of all blocks in the data set.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn crc16(crc u16, const_data voidptr, len usize) u16 {
	return C.SDL_crc16(crc, const_data, len)
}

// C.SDL_crc32 [official documentation](https://wiki.libsdl.org/SDL3/SDL_crc32)
fn C.SDL_crc32(crc u32, const_data voidptr, len usize) u32

// crc32 calculates a CRC-32 value.
//
// https://en.wikipedia.org/wiki/Cyclic_redundancy_check
//
// This function can be called multiple times, to stream data to be
// checksummed in blocks. Each call must provide the previous CRC-32 return
// value to be updated with the next block. The first call to this function
// for a set of blocks should pass in a zero CRC value.
//
// `crc` crc the current checksum for this data set, or 0 for a new data set.
// `data` data a new block of data to add to the checksum.
// `len` len the size, in bytes, of the new block of data.
// returns a CRC-32 checksum value of all blocks in the data set.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn crc32(crc u32, const_data voidptr, len usize) u32 {
	return C.SDL_crc32(crc, const_data, len)
}

// C.SDL_murmur3_32 [official documentation](https://wiki.libsdl.org/SDL3/SDL_murmur3_32)
fn C.SDL_murmur3_32(const_data voidptr, len usize, seed u32) u32

// murmur3_32 calculates a 32-bit MurmurHash3 value for a block of data.
//
// https://en.wikipedia.org/wiki/MurmurHash
//
// A seed may be specified, which changes the final results consistently, but
// this does not work like SDL_crc16 and SDL_crc32: you can't feed a previous
// result from this function back into itself as the next seed value to
// calculate a hash in chunks; it won't produce the same hash as it would if
// the same data was provided in a single call.
//
// If you aren't sure what to provide for a seed, zero is fine. Murmur3 is not
// cryptographically secure, so it shouldn't be used for hashing top-secret
// data.
//
// `data` data the data to be hashed.
// `len` len the size of data, in bytes.
// `seed` seed a value that alters the final hash value.
// returns a Murmur3 32-bit hash value.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn murmur3_32(const_data voidptr, len usize, seed u32) u32 {
	return C.SDL_murmur3_32(const_data, len, seed)
}

// C.SDL_memcpy [official documentation](https://wiki.libsdl.org/SDL3/SDL_memcpy)
fn C.SDL_memcpy(dst voidptr, const_src voidptr, len usize) voidptr

// memcpy copys non-overlapping memory.
//
// The memory regions must not overlap. If they do, use SDL_memmove() instead.
//
// `dst` dst The destination memory region. Must not be NULL, and must not
//            overlap with `src`.
// `src` src The source memory region. Must not be NULL, and must not overlap
//            with `dst`.
// `len` len The length in bytes of both `dst` and `src`.
// returns `dst`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: memmove (SDL_memmove)
pub fn memcpy(dst voidptr, const_src voidptr, len usize) voidptr {
	return C.SDL_memcpy(dst, const_src, len)
}

// TODO: Non-numerical: #define SDL_copyp(dst, src) \

// C.SDL_memmove [official documentation](https://wiki.libsdl.org/SDL3/SDL_memmove)
fn C.SDL_memmove(dst voidptr, const_src voidptr, len usize) voidptr

// memmove copys memory ranges that might overlap.
//
// It is okay for the memory regions to overlap. If you are confident that the
// regions never overlap, using SDL_memcpy() may improve performance.
//
// `dst` dst The destination memory region. Must not be NULL.
// `src` src The source memory region. Must not be NULL.
// `len` len The length in bytes of both `dst` and `src`.
// returns `dst`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: memcpy (SDL_memcpy)
pub fn memmove(dst voidptr, const_src voidptr, len usize) voidptr {
	return C.SDL_memmove(dst, const_src, len)
}

// C.SDL_memset [official documentation](https://wiki.libsdl.org/SDL3/SDL_memset)
fn C.SDL_memset(dst voidptr, c int, len usize) voidptr

// memset initializes all bytes of buffer of memory to a specific value.
//
// This function will set `len` bytes, pointed to by `dst`, to the value
// specified in `c`.
//
// Despite `c` being an `int` instead of a `char`, this only operates on
// bytes; `c` must be a value between 0 and 255, inclusive.
//
// `dst` dst the destination memory region. Must not be NULL.
// `c` c the byte value to set.
// `len` len the length, in bytes, to set in `dst`.
// returns `dst`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn memset(dst voidptr, c int, len usize) voidptr {
	return C.SDL_memset(dst, c, len)
}

// C.SDL_memset4 [official documentation](https://wiki.libsdl.org/SDL3/SDL_memset4)
fn C.SDL_memset4(dst voidptr, val u32, dwords usize) voidptr

// memset4 initializes all 32-bit words of buffer of memory to a specific value.
//
// This function will set a buffer of `dwords` Uint32 values, pointed to by
// `dst`, to the value specified in `val`.
//
// Unlike SDL_memset, this sets 32-bit values, not bytes, so it's not limited
// to a range of 0-255.
//
// `dst` dst the destination memory region. Must not be NULL.
// `val` val the Uint32 value to set.
// `dwords` dwords the number of Uint32 values to set in `dst`.
// returns `dst`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn memset4(dst voidptr, val u32, dwords usize) voidptr {
	return C.SDL_memset4(dst, val, dwords)
}

// TODO: Function: #define SDL_zero(x) SDL_memset(&(x), 0, sizeof((x)))

// TODO: Function: #define SDL_zerop(x) SDL_memset((x), 0, sizeof(*(x)))

// TODO: Function: #define SDL_zeroa(x) SDL_memset((x), 0, sizeof((x)))

// C.SDL_memcmp [official documentation](https://wiki.libsdl.org/SDL3/SDL_memcmp)
fn C.SDL_memcmp(const_s1 voidptr, const_s2 voidptr, len usize) int

// memcmp compares two buffers of memory.
//
// `s1` s1 the first buffer to compare. NULL is not permitted!
// `s2` s2 the second buffer to compare. NULL is not permitted!
// `len` len the number of bytes to compare between the buffers.
// returns less than zero if s1 is "less than" s2, greater than zero if s1 is
//          "greater than" s2, and zero if the buffers match exactly for `len`
//          bytes.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn memcmp(const_s1 voidptr, const_s2 voidptr, len usize) int {
	return C.SDL_memcmp(const_s1, const_s2, len)
}

// C.SDL_wcslen [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcslen)
fn C.SDL_wcslen(const_wstr &WCharT) usize

// wcslen this works exactly like wcslen() but doesn't require access to a C runtime.
//
// Counts the number of wchar_t values in `wstr`, excluding the null
// terminator.
//
// Like SDL_strlen only counts bytes and not codepoints in a UTF-8 string,
// this counts wchar_t values in a string, even if the string's encoding is of
// variable width, like UTF-16.
//
// Also be aware that wchar_t is different sizes on different platforms (4
// bytes on Linux, 2 on Windows, etc).
//
// `wstr` wstr The null-terminated wide string to read. Must not be NULL.
// returns the length (in wchar_t values, excluding the null terminator) of
//          `wstr`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: wcsnlen (SDL_wcsnlen)
// See also: utf8strlen (SDL_utf8strlen)
// See also: utf8strnlen (SDL_utf8strnlen)
pub fn wcslen(const_wstr &WCharT) usize {
	return C.SDL_wcslen(const_wstr)
}

// C.SDL_wcsnlen [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcsnlen)
fn C.SDL_wcsnlen(const_wstr &WCharT, maxlen usize) usize

// wcsnlen this works exactly like wcsnlen() but doesn't require access to a C
// runtime.
//
// Counts up to a maximum of `maxlen` wchar_t values in `wstr`, excluding the
// null terminator.
//
// Like SDL_strnlen only counts bytes and not codepoints in a UTF-8 string,
// this counts wchar_t values in a string, even if the string's encoding is of
// variable width, like UTF-16.
//
// Also be aware that wchar_t is different sizes on different platforms (4
// bytes on Linux, 2 on Windows, etc).
//
// Also, `maxlen` is a count of wide characters, not bytes!
//
// `wstr` wstr The null-terminated wide string to read. Must not be NULL.
// `maxlen` maxlen The maximum amount of wide characters to count.
// returns the length (in wide characters, excluding the null terminator) of
//          `wstr` but never more than `maxlen`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: wcslen (SDL_wcslen)
// See also: utf8strlen (SDL_utf8strlen)
// See also: utf8strnlen (SDL_utf8strnlen)
pub fn wcsnlen(const_wstr &WCharT, maxlen usize) usize {
	return C.SDL_wcsnlen(const_wstr, maxlen)
}

// C.SDL_wcslcpy [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcslcpy)
fn C.SDL_wcslcpy(dst &WCharT, const_src &WCharT, maxlen usize) usize

// wcslcpy copys a wide string.
//
// This function copies `maxlen` - 1 wide characters from `src` to `dst`, then
// appends a null terminator.
//
// `src` and `dst` must not overlap.
//
// If `maxlen` is 0, no wide characters are copied and no null terminator is
// written.
//
// `dst` dst The destination buffer. Must not be NULL, and must not overlap
//            with `src`.
// `src` src The null-terminated wide string to copy. Must not be NULL, and
//            must not overlap with `dst`.
// `maxlen` maxlen The length (in wide characters) of the destination buffer.
// returns the length (in wide characters, excluding the null terminator) of
//          `src`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: wcslcat (SDL_wcslcat)
pub fn wcslcpy(dst &WCharT, const_src &WCharT, maxlen usize) usize {
	return C.SDL_wcslcpy(dst, const_src, maxlen)
}

// C.SDL_wcslcat [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcslcat)
fn C.SDL_wcslcat(dst &WCharT, const_src &WCharT, maxlen usize) usize

// wcslcat concatenates wide strings.
//
// This function appends up to `maxlen` - SDL_wcslen(dst) - 1 wide characters
// from `src` to the end of the wide string in `dst`, then appends a null
// terminator.
//
// `src` and `dst` must not overlap.
//
// If `maxlen` - SDL_wcslen(dst) - 1 is less than or equal to 0, then `dst` is
// unmodified.
//
// `dst` dst The destination buffer already containing the first
//            null-terminated wide string. Must not be NULL and must not
//            overlap with `src`.
// `src` src The second null-terminated wide string. Must not be NULL, and
//            must not overlap with `dst`.
// `maxlen` maxlen The length (in wide characters) of the destination buffer.
// returns the length (in wide characters, excluding the null terminator) of
//          the string in `dst` plus the length of `src`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: wcslcpy (SDL_wcslcpy)
//
pub fn wcslcat(dst &WCharT, const_src &WCharT, maxlen usize) usize {
	return C.SDL_wcslcat(dst, const_src, maxlen)
}

// C.SDL_wcsdup [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcsdup)
fn C.SDL_wcsdup(const_wstr &WCharT) &WCharT

// wcsdup allocates a copy of a wide string.
//
// This allocates enough space for a null-terminated copy of `wstr`, using
// SDL_malloc, and then makes a copy of the string into this space.
//
// The returned string is owned by the caller, and should be passed to
// SDL_free when no longer needed.
//
// `wstr` wstr the string to copy.
// returns a pointer to the newly-allocated wide string.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn wcsdup(const_wstr &WCharT) &WCharT {
	return C.SDL_wcsdup(const_wstr)
}

// C.SDL_wcsstr [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcsstr)
fn C.SDL_wcsstr(const_haystack &WCharT, const_needle &WCharT) &WCharT

// wcsstr searchs a wide string for the first instance of a specific substring.
//
// The search ends once it finds the requested substring, or a null terminator
// byte to end the string.
//
// Note that this looks for strings of _wide characters_, not _codepoints_, so
// it's legal to search for malformed and incomplete UTF-16 sequences.
//
// `haystack` haystack the wide string to search. Must not be NULL.
// `needle` needle the wide string to search for. Must not be NULL.
// returns a pointer to the first instance of `needle` in the string, or NULL
//          if not found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn wcsstr(const_haystack &WCharT, const_needle &WCharT) &WCharT {
	return C.SDL_wcsstr(const_haystack, const_needle)
}

// C.SDL_wcsnstr [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcsnstr)
fn C.SDL_wcsnstr(const_haystack &WCharT, const_needle &WCharT, maxlen usize) &WCharT

// wcsnstr searchs a wide string, up to n wide chars, for the first instance of a
// specific substring.
//
// The search ends once it finds the requested substring, or a null terminator
// value to end the string, or `maxlen` wide character have been examined. It
// is possible to use this function on a wide string without a null
// terminator.
//
// Note that this looks for strings of _wide characters_, not _codepoints_, so
// it's legal to search for malformed and incomplete UTF-16 sequences.
//
// `haystack` haystack the wide string to search. Must not be NULL.
// `needle` needle the wide string to search for. Must not be NULL.
// `maxlen` maxlen the maximum number of wide characters to search in
//               `haystack`.
// returns a pointer to the first instance of `needle` in the string, or NULL
//          if not found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn wcsnstr(const_haystack &WCharT, const_needle &WCharT, maxlen usize) &WCharT {
	return C.SDL_wcsnstr(const_haystack, const_needle, maxlen)
}

// C.SDL_wcscmp [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcscmp)
fn C.SDL_wcscmp(const_str1 &WCharT, const_str2 &WCharT) int

// wcscmp compares two null-terminated wide strings.
//
// This only compares wchar_t values until it hits a null-terminating
// character; it does not care if the string is well-formed UTF-16 (or UTF-32,
// depending on your platform's wchar_t size), or uses valid Unicode values.
//
// `str1` str1 the first string to compare. NULL is not permitted!
// `str2` str2 the second string to compare. NULL is not permitted!
// returns less than zero if str1 is "less than" str2, greater than zero if
//          str1 is "greater than" str2, and zero if the strings match
//          exactly.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn wcscmp(const_str1 &WCharT, const_str2 &WCharT) int {
	return C.SDL_wcscmp(const_str1, const_str2)
}

// C.SDL_wcsncmp [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcsncmp)
fn C.SDL_wcsncmp(const_str1 &WCharT, const_str2 &WCharT, maxlen usize) int

// wcsncmp compares two wide strings up to a number of wchar_t values.
//
// This only compares wchar_t values; it does not care if the string is
// well-formed UTF-16 (or UTF-32, depending on your platform's wchar_t size),
// or uses valid Unicode values.
//
// Note that while this function is intended to be used with UTF-16 (or
// UTF-32, depending on your platform's definition of wchar_t), it is
// comparing raw wchar_t values and not Unicode codepoints: `maxlen` specifies
// a wchar_t limit! If the limit lands in the middle of a multi-wchar UTF-16
// sequence, it will only compare a portion of the final character.
//
// `maxlen` specifies a maximum number of wchar_t to compare; if the strings
// match to this number of wide chars (or both have matched to a
// null-terminator character before this count), they will be considered
// equal.
//
// `str1` str1 the first string to compare. NULL is not permitted!
// `str2` str2 the second string to compare. NULL is not permitted!
// `maxlen` maxlen the maximum number of wchar_t to compare.
// returns less than zero if str1 is "less than" str2, greater than zero if
//          str1 is "greater than" str2, and zero if the strings match
//          exactly.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn wcsncmp(const_str1 &WCharT, const_str2 &WCharT, maxlen usize) int {
	return C.SDL_wcsncmp(const_str1, const_str2, maxlen)
}

// C.SDL_wcscasecmp [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcscasecmp)
fn C.SDL_wcscasecmp(const_str1 &WCharT, const_str2 &WCharT) int

// wcscasecmp compares two null-terminated wide strings, case-insensitively.
//
// This will work with Unicode strings, using a technique called
// "case-folding" to handle the vast majority of case-sensitive human
// languages regardless of system locale. It can deal with expanding values: a
// German Eszett character can compare against two ASCII 's' chars and be
// considered a match, for example. A notable exception: it does not handle
// the Turkish 'i' character; human language is complicated!
//
// Depending on your platform, "wchar_t" might be 2 bytes, and expected to be
// UTF-16 encoded (like Windows), or 4 bytes in UTF-32 format. Since this
// handles Unicode, it expects the string to be well-formed and not a
// null-terminated string of arbitrary bytes. Characters that are not valid
// UTF-16 (or UTF-32) are treated as Unicode character U+FFFD (REPLACEMENT
// CHARACTER), which is to say two strings of random bits may turn out to
// match if they convert to the same amount of replacement characters.
//
// `str1` str1 the first string to compare. NULL is not permitted!
// `str2` str2 the second string to compare. NULL is not permitted!
// returns less than zero if str1 is "less than" str2, greater than zero if
//          str1 is "greater than" str2, and zero if the strings match
//          exactly.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn wcscasecmp(const_str1 &WCharT, const_str2 &WCharT) int {
	return C.SDL_wcscasecmp(const_str1, const_str2)
}

// C.SDL_wcsncasecmp [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcsncasecmp)
fn C.SDL_wcsncasecmp(const_str1 &WCharT, const_str2 &WCharT, maxlen usize) int

// wcsncasecmp compares two wide strings, case-insensitively, up to a number of wchar_t.
//
// This will work with Unicode strings, using a technique called
// "case-folding" to handle the vast majority of case-sensitive human
// languages regardless of system locale. It can deal with expanding values: a
// German Eszett character can compare against two ASCII 's' chars and be
// considered a match, for example. A notable exception: it does not handle
// the Turkish 'i' character; human language is complicated!
//
// Depending on your platform, "wchar_t" might be 2 bytes, and expected to be
// UTF-16 encoded (like Windows), or 4 bytes in UTF-32 format. Since this
// handles Unicode, it expects the string to be well-formed and not a
// null-terminated string of arbitrary bytes. Characters that are not valid
// UTF-16 (or UTF-32) are treated as Unicode character U+FFFD (REPLACEMENT
// CHARACTER), which is to say two strings of random bits may turn out to
// match if they convert to the same amount of replacement characters.
//
// Note that while this function might deal with variable-sized characters,
// `maxlen` specifies a _wchar_ limit! If the limit lands in the middle of a
// multi-byte UTF-16 sequence, it may convert a portion of the final character
// to one or more Unicode character U+FFFD (REPLACEMENT CHARACTER) so as not
// to overflow a buffer.
//
// `maxlen` specifies a maximum number of wchar_t values to compare; if the
// strings match to this number of wchar_t (or both have matched to a
// null-terminator character before this number of bytes), they will be
// considered equal.
//
// `str1` str1 the first string to compare. NULL is not permitted!
// `str2` str2 the second string to compare. NULL is not permitted!
// `maxlen` maxlen the maximum number of wchar_t values to compare.
// returns less than zero if str1 is "less than" str2, greater than zero if
//          str1 is "greater than" str2, and zero if the strings match
//          exactly.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn wcsncasecmp(const_str1 &WCharT, const_str2 &WCharT, maxlen usize) int {
	return C.SDL_wcsncasecmp(const_str1, const_str2, maxlen)
}

// C.SDL_wcstol [official documentation](https://wiki.libsdl.org/SDL3/SDL_wcstol)
fn C.SDL_wcstol(const_str &WCharT, endp &&WCharT, base int) int

// wcstol parses a `long` from a wide string.
//
// If `str` starts with whitespace, then those whitespace characters are
// skipped before attempting to parse the number.
//
// If the parsed number does not fit inside a `long`, the result is clamped to
// the minimum and maximum representable `long` values.
//
// `str` str The null-terminated wide string to read. Must not be NULL.
// `endp` endp If not NULL, the address of the first invalid wide character
//             (i.e. the next character after the parsed number) will be
//             written to this pointer.
// `base` base The base of the integer to read. Supported values are 0 and 2
//             to 36 inclusive. If 0, the base will be inferred from the
//             number's prefix (0x for hexadecimal, 0 for octal, decimal
//             otherwise).
// returns the parsed `long`, or 0 if no number could be parsed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: strtol (SDL_strtol)
pub fn wcstol(const_str &WCharT, endp &&WCharT, base int) int {
	return C.SDL_wcstol(const_str, endp, base)
}

// C.SDL_strlen [official documentation](https://wiki.libsdl.org/SDL3/SDL_strlen)
fn C.SDL_strlen(const_str &char) usize

// strlen this works exactly like strlen() but doesn't require access to a C runtime.
//
// Counts the bytes in `str`, excluding the null terminator.
//
// If you need the length of a UTF-8 string, consider using SDL_utf8strlen().
//
// `str` str The null-terminated string to read. Must not be NULL.
// returns the length (in bytes, excluding the null terminator) of `src`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: strnlen (SDL_strnlen)
// See also: utf8strlen (SDL_utf8strlen)
// See also: utf8strnlen (SDL_utf8strnlen)
pub fn strlen(const_str &char) usize {
	return C.SDL_strlen(const_str)
}

// C.SDL_strnlen [official documentation](https://wiki.libsdl.org/SDL3/SDL_strnlen)
fn C.SDL_strnlen(const_str &char, maxlen usize) usize

// strnlen this works exactly like strnlen() but doesn't require access to a C
// runtime.
//
// Counts up to a maximum of `maxlen` bytes in `str`, excluding the null
// terminator.
//
// If you need the length of a UTF-8 string, consider using SDL_utf8strnlen().
//
// `str` str The null-terminated string to read. Must not be NULL.
// `maxlen` maxlen The maximum amount of bytes to count.
// returns the length (in bytes, excluding the null terminator) of `src` but
//          never more than `maxlen`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: strlen (SDL_strlen)
// See also: utf8strlen (SDL_utf8strlen)
// See also: utf8strnlen (SDL_utf8strnlen)
pub fn strnlen(const_str &char, maxlen usize) usize {
	return C.SDL_strnlen(const_str, maxlen)
}

// C.SDL_strlcpy [official documentation](https://wiki.libsdl.org/SDL3/SDL_strlcpy)
fn C.SDL_strlcpy(dst &char, const_src &char, maxlen usize) usize

// strlcpy copys a string.
//
// This function copies up to `maxlen` - 1 characters from `src` to `dst`,
// then appends a null terminator.
//
// If `maxlen` is 0, no characters are copied and no null terminator is
// written.
//
// If you want to copy an UTF-8 string but need to ensure that multi-byte
// sequences are not truncated, consider using SDL_utf8strlcpy().
//
// `dst` dst The destination buffer. Must not be NULL, and must not overlap
//            with `src`.
// `src` src The null-terminated string to copy. Must not be NULL, and must
//            not overlap with `dst`.
// `maxlen` maxlen The length (in characters) of the destination buffer.
// returns the length (in characters, excluding the null terminator) of
//          `src`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: strlcat (SDL_strlcat)
// See also: utf8strlcpy (SDL_utf8strlcpy)
//
pub fn strlcpy(dst &char, const_src &char, maxlen usize) usize {
	return C.SDL_strlcpy(dst, const_src, maxlen)
}

// C.SDL_utf8strlcpy [official documentation](https://wiki.libsdl.org/SDL3/SDL_utf8strlcpy)
fn C.SDL_utf8strlcpy(dst &char, const_src &char, dst_bytes usize) usize

// utf8strlcpy copys an UTF-8 string.
//
// This function copies up to `dst_bytes` - 1 bytes from `src` to `dst` while
// also ensuring that the string written to `dst` does not end in a truncated
// multi-byte sequence. Finally, it appends a null terminator.
//
// `src` and `dst` must not overlap.
//
// Note that unlike SDL_strlcpy(), this function returns the number of bytes
// written, not the length of `src`.
//
// `dst` dst The destination buffer. Must not be NULL, and must not overlap
//            with `src`.
// `src` src The null-terminated UTF-8 string to copy. Must not be NULL, and
//            must not overlap with `dst`.
// `dst_bytes` dst_bytes The length (in bytes) of the destination buffer. Must not
//                  be 0.
// returns the number of bytes written, excluding the null terminator.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: strlcpy (SDL_strlcpy)
//
pub fn utf8strlcpy(dst &char, const_src &char, dst_bytes usize) usize {
	return C.SDL_utf8strlcpy(dst, const_src, dst_bytes)
}

// C.SDL_strlcat [official documentation](https://wiki.libsdl.org/SDL3/SDL_strlcat)
fn C.SDL_strlcat(dst &char, const_src &char, maxlen usize) usize

// strlcat concatenates strings.
//
// This function appends up to `maxlen` - SDL_strlen(dst) - 1 characters from
// `src` to the end of the string in `dst`, then appends a null terminator.
//
// `src` and `dst` must not overlap.
//
// If `maxlen` - SDL_strlen(dst) - 1 is less than or equal to 0, then `dst` is
// unmodified.
//
// `dst` dst The destination buffer already containing the first
//            null-terminated string. Must not be NULL and must not overlap
//            with `src`.
// `src` src The second null-terminated string. Must not be NULL, and must
//            not overlap with `dst`.
// `maxlen` maxlen The length (in characters) of the destination buffer.
// returns the length (in characters, excluding the null terminator) of the
//          string in `dst` plus the length of `src`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: strlcpy (SDL_strlcpy)
//
pub fn strlcat(dst &char, const_src &char, maxlen usize) usize {
	return C.SDL_strlcat(dst, const_src, maxlen)
}

// C.SDL_strdup [official documentation](https://wiki.libsdl.org/SDL3/SDL_strdup)
fn C.SDL_strdup(const_str &char) &char

// strdup allocates a copy of a string.
//
// This allocates enough space for a null-terminated copy of `str`, using
// SDL_malloc, and then makes a copy of the string into this space.
//
// The returned string is owned by the caller, and should be passed to
// SDL_free when no longer needed.
//
// `str` str the string to copy.
// returns a pointer to the newly-allocated string.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strdup(const_str &char) &char {
	return &char(C.SDL_strdup(const_str))
}

// C.SDL_strndup [official documentation](https://wiki.libsdl.org/SDL3/SDL_strndup)
fn C.SDL_strndup(const_str &char, maxlen usize) &char

// strndup allocates a copy of a string, up to n characters.
//
// This allocates enough space for a null-terminated copy of `str`, up to
// `maxlen` bytes, using SDL_malloc, and then makes a copy of the string into
// this space.
//
// If the string is longer than `maxlen` bytes, the returned string will be
// `maxlen` bytes long, plus a null-terminator character that isn't included
// in the count.
//
// The returned string is owned by the caller, and should be passed to
// SDL_free when no longer needed.
//
// `str` str the string to copy.
// `maxlen` maxlen the maximum length of the copied string, not counting the
//               null-terminator character.
// returns a pointer to the newly-allocated string.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strndup(const_str &char, maxlen usize) &char {
	return &char(C.SDL_strndup(const_str, maxlen))
}

// C.SDL_strrev [official documentation](https://wiki.libsdl.org/SDL3/SDL_strrev)
fn C.SDL_strrev(str &char) &char

// strrev reverses a string's contents.
//
// This reverses a null-terminated string in-place. Only the content of the
// string is reversed; the null-terminator character remains at the end of the
// reversed string.
//
// **WARNING**: This function reverses the _bytes_ of the string, not the
// codepoints. If `str` is a UTF-8 string with Unicode codepoints > 127, this
// will ruin the string data. You should only use this function on strings
// that are completely comprised of low ASCII characters.
//
// `str` str the string to reverse.
// returns `str`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strrev(str &char) &char {
	return &char(C.SDL_strrev(str))
}

// C.SDL_strupr [official documentation](https://wiki.libsdl.org/SDL3/SDL_strupr)
fn C.SDL_strupr(str &char) &char

// strupr converts a string to uppercase.
//
// **WARNING**: Regardless of system locale, this will only convert ASCII
// values 'A' through 'Z' to uppercase.
//
// This function operates on a null-terminated string of bytes--even if it is
// malformed UTF-8!--and converts ASCII characters 'a' through 'z' to their
// uppercase equivalents in-place, returning the original `str` pointer.
//
// `str` str the string to convert in-place. Can not be NULL.
// returns the `str` pointer passed into this function.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: strlwr (SDL_strlwr)
pub fn strupr(str &char) &char {
	return &char(C.SDL_strupr(str))
}

// C.SDL_strlwr [official documentation](https://wiki.libsdl.org/SDL3/SDL_strlwr)
fn C.SDL_strlwr(str &char) &char

// strlwr converts a string to lowercase.
//
// **WARNING**: Regardless of system locale, this will only convert ASCII
// values 'A' through 'Z' to lowercase.
//
// This function operates on a null-terminated string of bytes--even if it is
// malformed UTF-8!--and converts ASCII characters 'A' through 'Z' to their
// lowercase equivalents in-place, returning the original `str` pointer.
//
// `str` str the string to convert in-place. Can not be NULL.
// returns the `str` pointer passed into this function.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: strupr (SDL_strupr)
pub fn strlwr(str &char) &char {
	return &char(C.SDL_strlwr(str))
}

// C.SDL_strchr [official documentation](https://wiki.libsdl.org/SDL3/SDL_strchr)
fn C.SDL_strchr(const_str &char, c int) &char

// strchr searchs a string for the first instance of a specific byte.
//
// The search ends once it finds the requested byte value, or a null
// terminator byte to end the string.
//
// Note that this looks for _bytes_, not _characters_, so you cannot match
// against a Unicode codepoint > 255, regardless of character encoding.
//
// `str` str the string to search. Must not be NULL.
// `c` c the byte value to search for.
// returns a pointer to the first instance of `c` in the string, or NULL if
//          not found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strchr(const_str &char, c int) &char {
	return &char(C.SDL_strchr(const_str, c))
}

// C.SDL_strrchr [official documentation](https://wiki.libsdl.org/SDL3/SDL_strrchr)
fn C.SDL_strrchr(const_str &char, c int) &char

// strrchr searchs a string for the last instance of a specific byte.
//
// The search must go until it finds a null terminator byte to end the string.
//
// Note that this looks for _bytes_, not _characters_, so you cannot match
// against a Unicode codepoint > 255, regardless of character encoding.
//
// `str` str the string to search. Must not be NULL.
// `c` c the byte value to search for.
// returns a pointer to the last instance of `c` in the string, or NULL if
//          not found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strrchr(const_str &char, c int) &char {
	return &char(C.SDL_strrchr(const_str, c))
}

// C.SDL_strstr [official documentation](https://wiki.libsdl.org/SDL3/SDL_strstr)
fn C.SDL_strstr(const_haystack &char, const_needle &char) &char

// strstr searchs a string for the first instance of a specific substring.
//
// The search ends once it finds the requested substring, or a null terminator
// byte to end the string.
//
// Note that this looks for strings of _bytes_, not _characters_, so it's
// legal to search for malformed and incomplete UTF-8 sequences.
//
// `haystack` haystack the string to search. Must not be NULL.
// `needle` needle the string to search for. Must not be NULL.
// returns a pointer to the first instance of `needle` in the string, or NULL
//          if not found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strstr(const_haystack &char, const_needle &char) &char {
	return &char(C.SDL_strstr(const_haystack, const_needle))
}

// C.SDL_strnstr [official documentation](https://wiki.libsdl.org/SDL3/SDL_strnstr)
fn C.SDL_strnstr(const_haystack &char, const_needle &char, maxlen usize) &char

// strnstr searchs a string, up to n bytes, for the first instance of a specific
// substring.
//
// The search ends once it finds the requested substring, or a null terminator
// byte to end the string, or `maxlen` bytes have been examined. It is
// possible to use this function on a string without a null terminator.
//
// Note that this looks for strings of _bytes_, not _characters_, so it's
// legal to search for malformed and incomplete UTF-8 sequences.
//
// `haystack` haystack the string to search. Must not be NULL.
// `needle` needle the string to search for. Must not be NULL.
// `maxlen` maxlen the maximum number of bytes to search in `haystack`.
// returns a pointer to the first instance of `needle` in the string, or NULL
//          if not found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strnstr(const_haystack &char, const_needle &char, maxlen usize) &char {
	return &char(C.SDL_strnstr(const_haystack, const_needle, maxlen))
}

// C.SDL_strcasestr [official documentation](https://wiki.libsdl.org/SDL3/SDL_strcasestr)
fn C.SDL_strcasestr(const_haystack &char, const_needle &char) &char

// strcasestr searchs a UTF-8 string for the first instance of a specific substring,
// case-insensitively.
//
// This will work with Unicode strings, using a technique called
// "case-folding" to handle the vast majority of case-sensitive human
// languages regardless of system locale. It can deal with expanding values: a
// German Eszett character can compare against two ASCII 's' chars and be
// considered a match, for example. A notable exception: it does not handle
// the Turkish 'i' character; human language is complicated!
//
// Since this handles Unicode, it expects the strings to be well-formed UTF-8
// and not a null-terminated string of arbitrary bytes. Bytes that are not
// valid UTF-8 are treated as Unicode character U+FFFD (REPLACEMENT
// CHARACTER), which is to say two strings of random bits may turn out to
// match if they convert to the same amount of replacement characters.
//
// `haystack` haystack the string to search. Must not be NULL.
// `needle` needle the string to search for. Must not be NULL.
// returns a pointer to the first instance of `needle` in the string, or NULL
//          if not found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strcasestr(const_haystack &char, const_needle &char) &char {
	return &char(C.SDL_strcasestr(const_haystack, const_needle))
}

// C.SDL_strtok_r [official documentation](https://wiki.libsdl.org/SDL3/SDL_strtok_r)
fn C.SDL_strtok_r(str &char, const_delim &char, saveptr &&char) &char

// strtok_r this works exactly like strtok_r() but doesn't require access to a C
// runtime.
//
// Break a string up into a series of tokens.
//
// To start tokenizing a new string, `str` should be the non-NULL address of
// the string to start tokenizing. Future calls to get the next token from the
// same string should specify a NULL.
//
// Note that this function will overwrite pieces of `str` with null chars to
// split it into tokens. This function cannot be used with const/read-only
// strings!
//
// `saveptr` just needs to point to a `char *` that can be overwritten; SDL
// will use this to save tokenizing state between calls. It is initialized if
// `str` is non-NULL, and used to resume tokenizing when `str` is NULL.
//
// `str` str the string to tokenize, or NULL to continue tokenizing.
// `delim` delim the delimiter string that separates tokens.
// `saveptr` saveptr pointer to a char *, used for ongoing state.
// returns A pointer to the next token, or NULL if no tokens remain.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strtok_r(str &char, const_delim &char, saveptr &&char) &char {
	return &char(C.SDL_strtok_r(str, const_delim, saveptr))
}

// C.SDL_utf8strlen [official documentation](https://wiki.libsdl.org/SDL3/SDL_utf8strlen)
fn C.SDL_utf8strlen(const_str &char) usize

// utf8strlen counts the number of codepoints in a UTF-8 string.
//
// Counts the _codepoints_, not _bytes_, in `str`, excluding the null
// terminator.
//
// If you need to count the bytes in a string instead, consider using
// SDL_strlen().
//
// Since this handles Unicode, it expects the strings to be well-formed UTF-8
// and not a null-terminated string of arbitrary bytes. Bytes that are not
// valid UTF-8 are treated as Unicode character U+FFFD (REPLACEMENT
// CHARACTER), so a malformed or incomplete UTF-8 sequence might increase the
// count by several replacement characters.
//
// `str` str The null-terminated UTF-8 string to read. Must not be NULL.
// returns The length (in codepoints, excluding the null terminator) of
//          `src`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: utf8strnlen (SDL_utf8strnlen)
// See also: strlen (SDL_strlen)
pub fn utf8strlen(const_str &char) usize {
	return C.SDL_utf8strlen(const_str)
}

// C.SDL_utf8strnlen [official documentation](https://wiki.libsdl.org/SDL3/SDL_utf8strnlen)
fn C.SDL_utf8strnlen(const_str &char, bytes usize) usize

// utf8strnlen counts the number of codepoints in a UTF-8 string, up to n bytes.
//
// Counts the _codepoints_, not _bytes_, in `str`, excluding the null
// terminator.
//
// If you need to count the bytes in a string instead, consider using
// SDL_strnlen().
//
// The counting stops at `bytes` bytes (not codepoints!). This seems
// counterintuitive, but makes it easy to express the total size of the
// string's buffer.
//
// Since this handles Unicode, it expects the strings to be well-formed UTF-8
// and not a null-terminated string of arbitrary bytes. Bytes that are not
// valid UTF-8 are treated as Unicode character U+FFFD (REPLACEMENT
// CHARACTER), so a malformed or incomplete UTF-8 sequence might increase the
// count by several replacement characters.
//
// `str` str The null-terminated UTF-8 string to read. Must not be NULL.
// `bytes` bytes The maximum amount of bytes to count.
// returns The length (in codepoints, excluding the null terminator) of `src`
//          but never more than `maxlen`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: utf8strlen (SDL_utf8strlen)
// See also: strnlen (SDL_strnlen)
pub fn utf8strnlen(const_str &char, bytes usize) usize {
	return C.SDL_utf8strnlen(const_str, bytes)
}

// C.SDL_itoa [official documentation](https://wiki.libsdl.org/SDL3/SDL_itoa)
fn C.SDL_itoa(value int, str &char, radix int) &char

// itoa converts an integer into a string.
//
// This requires a radix to specified for string format. Specifying 10
// produces a decimal number, 16 hexidecimal, etc. Must be in the range of 2
// to 36.
//
// Note that this function will overflow a buffer if `str` is not large enough
// to hold the output! It may be safer to use SDL_snprintf to clamp output, or
// SDL_asprintf to allocate a buffer. Otherwise, it doesn't hurt to allocate
// much more space than you expect to use (and don't forget possible negative
// signs, null terminator bytes, etc).
//
// `value` value the integer to convert.
// `str` str the buffer to write the string into.
// `radix` radix the radix to use for string generation.
// returns `str`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: uitoa (SDL_uitoa)
// See also: ltoa (SDL_ltoa)
// See also: lltoa (SDL_lltoa)
pub fn itoa(value int, str &char, radix int) &char {
	return &char(C.SDL_itoa(value, str, radix))
}

// C.SDL_uitoa [official documentation](https://wiki.libsdl.org/SDL3/SDL_uitoa)
fn C.SDL_uitoa(value u32, str &char, radix int) &char

// uitoa converts an unsigned integer into a string.
//
// This requires a radix to specified for string format. Specifying 10
// produces a decimal number, 16 hexidecimal, etc. Must be in the range of 2
// to 36.
//
// Note that this function will overflow a buffer if `str` is not large enough
// to hold the output! It may be safer to use SDL_snprintf to clamp output, or
// SDL_asprintf to allocate a buffer. Otherwise, it doesn't hurt to allocate
// much more space than you expect to use (and don't forget null terminator
// bytes, etc).
//
// `value` value the unsigned integer to convert.
// `str` str the buffer to write the string into.
// `radix` radix the radix to use for string generation.
// returns `str`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: itoa (SDL_itoa)
// See also: ultoa (SDL_ultoa)
// See also: ulltoa (SDL_ulltoa)
pub fn uitoa(value u32, str &char, radix int) &char {
	return &char(C.SDL_uitoa(value, str, radix))
}

// C.SDL_ltoa [official documentation](https://wiki.libsdl.org/SDL3/SDL_ltoa)
fn C.SDL_ltoa(value int, str &char, radix int) &char

// ltoa converts a long integer into a string.
//
// This requires a radix to specified for string format. Specifying 10
// produces a decimal number, 16 hexidecimal, etc. Must be in the range of 2
// to 36.
//
// Note that this function will overflow a buffer if `str` is not large enough
// to hold the output! It may be safer to use SDL_snprintf to clamp output, or
// SDL_asprintf to allocate a buffer. Otherwise, it doesn't hurt to allocate
// much more space than you expect to use (and don't forget possible negative
// signs, null terminator bytes, etc).
//
// `value` value the long integer to convert.
// `str` str the buffer to write the string into.
// `radix` radix the radix to use for string generation.
// returns `str`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: ultoa (SDL_ultoa)
// See also: itoa (SDL_itoa)
// See also: lltoa (SDL_lltoa)
pub fn ltoa(value int, str &char, radix int) &char {
	return &char(C.SDL_ltoa(value, str, radix))
}

// C.SDL_ultoa [official documentation](https://wiki.libsdl.org/SDL3/SDL_ultoa)
fn C.SDL_ultoa(value u32, str &char, radix int) &char

// ultoa converts an unsigned long integer into a string.
//
// This requires a radix to specified for string format. Specifying 10
// produces a decimal number, 16 hexidecimal, etc. Must be in the range of 2
// to 36.
//
// Note that this function will overflow a buffer if `str` is not large enough
// to hold the output! It may be safer to use SDL_snprintf to clamp output, or
// SDL_asprintf to allocate a buffer. Otherwise, it doesn't hurt to allocate
// much more space than you expect to use (and don't forget null terminator
// bytes, etc).
//
// `value` value the unsigned long integer to convert.
// `str` str the buffer to write the string into.
// `radix` radix the radix to use for string generation.
// returns `str`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: ltoa (SDL_ltoa)
// See also: uitoa (SDL_uitoa)
// See also: ulltoa (SDL_ulltoa)
pub fn ultoa(value u32, str &char, radix int) &char {
	return &char(C.SDL_ultoa(value, str, radix))
}

// C.SDL_lltoa [official documentation](https://wiki.libsdl.org/SDL3/SDL_lltoa)
fn C.SDL_lltoa(value i64, str &char, radix int) &char

// lltoa converts a long long integer into a string.
//
// This requires a radix to specified for string format. Specifying 10
// produces a decimal number, 16 hexidecimal, etc. Must be in the range of 2
// to 36.
//
// Note that this function will overflow a buffer if `str` is not large enough
// to hold the output! It may be safer to use SDL_snprintf to clamp output, or
// SDL_asprintf to allocate a buffer. Otherwise, it doesn't hurt to allocate
// much more space than you expect to use (and don't forget possible negative
// signs, null terminator bytes, etc).
//
// `value` value the long long integer to convert.
// `str` str the buffer to write the string into.
// `radix` radix the radix to use for string generation.
// returns `str`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: ulltoa (SDL_ulltoa)
// See also: itoa (SDL_itoa)
// See also: ltoa (SDL_ltoa)
pub fn lltoa(value i64, str &char, radix int) &char {
	return &char(C.SDL_lltoa(value, str, radix))
}

// C.SDL_ulltoa [official documentation](https://wiki.libsdl.org/SDL3/SDL_ulltoa)
fn C.SDL_ulltoa(value u64, str &char, radix int) &char

// ulltoa converts an unsigned long long integer into a string.
//
// This requires a radix to specified for string format. Specifying 10
// produces a decimal number, 16 hexidecimal, etc. Must be in the range of 2
// to 36.
//
// Note that this function will overflow a buffer if `str` is not large enough
// to hold the output! It may be safer to use SDL_snprintf to clamp output, or
// SDL_asprintf to allocate a buffer. Otherwise, it doesn't hurt to allocate
// much more space than you expect to use (and don't forget null terminator
// bytes, etc).
//
// `value` value the unsigned long long integer to convert.
// `str` str the buffer to write the string into.
// `radix` radix the radix to use for string generation.
// returns `str`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lltoa (SDL_lltoa)
// See also: uitoa (SDL_uitoa)
// See also: ultoa (SDL_ultoa)
pub fn ulltoa(value u64, str &char, radix int) &char {
	return &char(C.SDL_ulltoa(value, str, radix))
}

// C.SDL_atoi [official documentation](https://wiki.libsdl.org/SDL3/SDL_atoi)
fn C.SDL_atoi(const_str &char) int

// atoi parses an `int` from a string.
//
// The result of calling `SDL_atoi(str)` is equivalent to
// `(int)SDL_strtol(str, NULL, 10)`.
//
// `str` str The null-terminated string to read. Must not be NULL.
// returns the parsed `int`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atof (SDL_atof)
// See also: strtol (SDL_strtol)
// See also: strtoul (SDL_strtoul)
// See also: strtoll (SDL_strtoll)
// See also: strtoull (SDL_strtoull)
// See also: strtod (SDL_strtod)
// See also: itoa (SDL_itoa)
pub fn atoi(const_str &char) int {
	return C.SDL_atoi(const_str)
}

// C.SDL_atof [official documentation](https://wiki.libsdl.org/SDL3/SDL_atof)
fn C.SDL_atof(const_str &char) f64

// atof parses a `double` from a string.
//
// The result of calling `SDL_atof(str)` is equivalent to `SDL_strtod(str,
// NULL)`.
//
// `str` str The null-terminated string to read. Must not be NULL.
// returns the parsed `double`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atoi (SDL_atoi)
// See also: strtol (SDL_strtol)
// See also: strtoul (SDL_strtoul)
// See also: strtoll (SDL_strtoll)
// See also: strtoull (SDL_strtoull)
// See also: strtod (SDL_strtod)
pub fn atof(const_str &char) f64 {
	return C.SDL_atof(const_str)
}

// C.SDL_strtol [official documentation](https://wiki.libsdl.org/SDL3/SDL_strtol)
fn C.SDL_strtol(const_str &char, endp &&char, base int) int

// strtol parses a `long` from a string.
//
// If `str` starts with whitespace, then those whitespace characters are
// skipped before attempting to parse the number.
//
// If the parsed number does not fit inside a `long`, the result is clamped to
// the minimum and maximum representable `long` values.
//
// `str` str The null-terminated string to read. Must not be NULL.
// `endp` endp If not NULL, the address of the first invalid character (i.e.
//             the next character after the parsed number) will be written to
//             this pointer.
// `base` base The base of the integer to read. Supported values are 0 and 2
//             to 36 inclusive. If 0, the base will be inferred from the
//             number's prefix (0x for hexadecimal, 0 for octal, decimal
//             otherwise).
// returns the parsed `long`, or 0 if no number could be parsed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atoi (SDL_atoi)
// See also: atof (SDL_atof)
// See also: strtoul (SDL_strtoul)
// See also: strtoll (SDL_strtoll)
// See also: strtoull (SDL_strtoull)
// See also: strtod (SDL_strtod)
// See also: ltoa (SDL_ltoa)
// See also: wcstol (SDL_wcstol)
pub fn strtol(const_str &char, endp &&char, base int) int {
	return C.SDL_strtol(const_str, endp, base)
}

// C.SDL_strtoul [official documentation](https://wiki.libsdl.org/SDL3/SDL_strtoul)
fn C.SDL_strtoul(const_str &char, endp &&char, base int) u32

// strtoul parses an `unsigned long` from a string.
//
// If `str` starts with whitespace, then those whitespace characters are
// skipped before attempting to parse the number.
//
// If the parsed number does not fit inside an `unsigned long`, the result is
// clamped to the maximum representable `unsigned long` value.
//
// `str` str The null-terminated string to read. Must not be NULL.
// `endp` endp If not NULL, the address of the first invalid character (i.e.
//             the next character after the parsed number) will be written to
//             this pointer.
// `base` base The base of the integer to read. Supported values are 0 and 2
//             to 36 inclusive. If 0, the base will be inferred from the
//             number's prefix (0x for hexadecimal, 0 for octal, decimal
//             otherwise).
// returns the parsed `unsigned long`, or 0 if no number could be parsed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atoi (SDL_atoi)
// See also: atof (SDL_atof)
// See also: strtol (SDL_strtol)
// See also: strtoll (SDL_strtoll)
// See also: strtoull (SDL_strtoull)
// See also: strtod (SDL_strtod)
// See also: ultoa (SDL_ultoa)
pub fn strtoul(const_str &char, endp &&char, base int) u32 {
	return C.SDL_strtoul(const_str, endp, base)
}

// C.SDL_strtoll [official documentation](https://wiki.libsdl.org/SDL3/SDL_strtoll)
fn C.SDL_strtoll(const_str &char, endp &&char, base int) i64

// strtoll parses a `long long` from a string.
//
// If `str` starts with whitespace, then those whitespace characters are
// skipped before attempting to parse the number.
//
// If the parsed number does not fit inside a `long long`, the result is
// clamped to the minimum and maximum representable `long long` values.
//
// `str` str The null-terminated string to read. Must not be NULL.
// `endp` endp If not NULL, the address of the first invalid character (i.e.
//             the next character after the parsed number) will be written to
//             this pointer.
// `base` base The base of the integer to read. Supported values are 0 and 2
//             to 36 inclusive. If 0, the base will be inferred from the
//             number's prefix (0x for hexadecimal, 0 for octal, decimal
//             otherwise).
// returns the parsed `long long`, or 0 if no number could be parsed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atoi (SDL_atoi)
// See also: atof (SDL_atof)
// See also: strtol (SDL_strtol)
// See also: strtoul (SDL_strtoul)
// See also: strtoull (SDL_strtoull)
// See also: strtod (SDL_strtod)
// See also: lltoa (SDL_lltoa)
pub fn strtoll(const_str &char, endp &&char, base int) i64 {
	return C.SDL_strtoll(const_str, endp, base)
}

// C.SDL_strtoull [official documentation](https://wiki.libsdl.org/SDL3/SDL_strtoull)
fn C.SDL_strtoull(const_str &char, endp &&char, base int) u64

// strtoull parses an `unsigned long long` from a string.
//
// If `str` starts with whitespace, then those whitespace characters are
// skipped before attempting to parse the number.
//
// If the parsed number does not fit inside an `unsigned long long`, the
// result is clamped to the maximum representable `unsigned long long` value.
//
// `str` str The null-terminated string to read. Must not be NULL.
// `endp` endp If not NULL, the address of the first invalid character (i.e.
//             the next character after the parsed number) will be written to
//             this pointer.
// `base` base The base of the integer to read. Supported values are 0 and 2
//             to 36 inclusive. If 0, the base will be inferred from the
//             number's prefix (0x for hexadecimal, 0 for octal, decimal
//             otherwise).
// returns the parsed `unsigned long long`, or 0 if no number could be
//          parsed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atoi (SDL_atoi)
// See also: atof (SDL_atof)
// See also: strtol (SDL_strtol)
// See also: strtoll (SDL_strtoll)
// See also: strtoul (SDL_strtoul)
// See also: strtod (SDL_strtod)
// See also: ulltoa (SDL_ulltoa)
pub fn strtoull(const_str &char, endp &&char, base int) u64 {
	return C.SDL_strtoull(const_str, endp, base)
}

// C.SDL_strtod [official documentation](https://wiki.libsdl.org/SDL3/SDL_strtod)
fn C.SDL_strtod(const_str &char, endp &&char) f64

// strtod parses a `double` from a string.
//
// This function makes fewer guarantees than the C runtime `strtod`:
//
// - Only decimal notation is guaranteed to be supported. The handling of
//   scientific and hexadecimal notation is unspecified.
// - Whether or not INF and NAN can be parsed is unspecified.
// - The precision of the result is unspecified.
//
// `str` str the null-terminated string to read. Must not be NULL.
// `endp` endp if not NULL, the address of the first invalid character (i.e.
//             the next character after the parsed number) will be written to
//             this pointer.
// returns the parsed `double`, or 0 if no number could be parsed.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atoi (SDL_atoi)
// See also: atof (SDL_atof)
// See also: strtol (SDL_strtol)
// See also: strtoll (SDL_strtoll)
// See also: strtoul (SDL_strtoul)
// See also: strtoull (SDL_strtoull)
pub fn strtod(const_str &char, endp &&char) f64 {
	return C.SDL_strtod(const_str, endp)
}

// C.SDL_strcmp [official documentation](https://wiki.libsdl.org/SDL3/SDL_strcmp)
fn C.SDL_strcmp(const_str1 &char, const_str2 &char) int

// strcmp compares two null-terminated UTF-8 strings.
//
// Due to the nature of UTF-8 encoding, this will work with Unicode strings,
// since effectively this function just compares bytes until it hits a
// null-terminating character. Also due to the nature of UTF-8, this can be
// used with SDL_qsort() to put strings in (roughly) alphabetical order.
//
// `str1` str1 the first string to compare. NULL is not permitted!
// `str2` str2 the second string to compare. NULL is not permitted!
// returns less than zero if str1 is "less than" str2, greater than zero if
//          str1 is "greater than" str2, and zero if the strings match
//          exactly.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strcmp(const_str1 &char, const_str2 &char) int {
	return C.SDL_strcmp(const_str1, const_str2)
}

// C.SDL_strncmp [official documentation](https://wiki.libsdl.org/SDL3/SDL_strncmp)
fn C.SDL_strncmp(const_str1 &char, const_str2 &char, maxlen usize) int

// strncmp compares two UTF-8 strings up to a number of bytes.
//
// Due to the nature of UTF-8 encoding, this will work with Unicode strings,
// since effectively this function just compares bytes until it hits a
// null-terminating character. Also due to the nature of UTF-8, this can be
// used with SDL_qsort() to put strings in (roughly) alphabetical order.
//
// Note that while this function is intended to be used with UTF-8, it is
// doing a bytewise comparison, and `maxlen` specifies a _byte_ limit! If the
// limit lands in the middle of a multi-byte UTF-8 sequence, it will only
// compare a portion of the final character.
//
// `maxlen` specifies a maximum number of bytes to compare; if the strings
// match to this number of bytes (or both have matched to a null-terminator
// character before this number of bytes), they will be considered equal.
//
// `str1` str1 the first string to compare. NULL is not permitted!
// `str2` str2 the second string to compare. NULL is not permitted!
// `maxlen` maxlen the maximum number of _bytes_ to compare.
// returns less than zero if str1 is "less than" str2, greater than zero if
//          str1 is "greater than" str2, and zero if the strings match
//          exactly.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strncmp(const_str1 &char, const_str2 &char, maxlen usize) int {
	return C.SDL_strncmp(const_str1, const_str2, maxlen)
}

// C.SDL_strcasecmp [official documentation](https://wiki.libsdl.org/SDL3/SDL_strcasecmp)
fn C.SDL_strcasecmp(const_str1 &char, const_str2 &char) int

// strcasecmp compares two null-terminated UTF-8 strings, case-insensitively.
//
// This will work with Unicode strings, using a technique called
// "case-folding" to handle the vast majority of case-sensitive human
// languages regardless of system locale. It can deal with expanding values: a
// German Eszett character can compare against two ASCII 's' chars and be
// considered a match, for example. A notable exception: it does not handle
// the Turkish 'i' character; human language is complicated!
//
// Since this handles Unicode, it expects the string to be well-formed UTF-8
// and not a null-terminated string of arbitrary bytes. Bytes that are not
// valid UTF-8 are treated as Unicode character U+FFFD (REPLACEMENT
// CHARACTER), which is to say two strings of random bits may turn out to
// match if they convert to the same amount of replacement characters.
//
// `str1` str1 the first string to compare. NULL is not permitted!
// `str2` str2 the second string to compare. NULL is not permitted!
// returns less than zero if str1 is "less than" str2, greater than zero if
//          str1 is "greater than" str2, and zero if the strings match
//          exactly.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strcasecmp(const_str1 &char, const_str2 &char) int {
	return C.SDL_strcasecmp(const_str1, const_str2)
}

// C.SDL_strncasecmp [official documentation](https://wiki.libsdl.org/SDL3/SDL_strncasecmp)
fn C.SDL_strncasecmp(const_str1 &char, const_str2 &char, maxlen usize) int

// strncasecmp compares two UTF-8 strings, case-insensitively, up to a number of bytes.
//
// This will work with Unicode strings, using a technique called
// "case-folding" to handle the vast majority of case-sensitive human
// languages regardless of system locale. It can deal with expanding values: a
// German Eszett character can compare against two ASCII 's' chars and be
// considered a match, for example. A notable exception: it does not handle
// the Turkish 'i' character; human language is complicated!
//
// Since this handles Unicode, it expects the string to be well-formed UTF-8
// and not a null-terminated string of arbitrary bytes. Bytes that are not
// valid UTF-8 are treated as Unicode character U+FFFD (REPLACEMENT
// CHARACTER), which is to say two strings of random bits may turn out to
// match if they convert to the same amount of replacement characters.
//
// Note that while this function is intended to be used with UTF-8, `maxlen`
// specifies a _byte_ limit! If the limit lands in the middle of a multi-byte
// UTF-8 sequence, it may convert a portion of the final character to one or
// more Unicode character U+FFFD (REPLACEMENT CHARACTER) so as not to overflow
// a buffer.
//
// `maxlen` specifies a maximum number of bytes to compare; if the strings
// match to this number of bytes (or both have matched to a null-terminator
// character before this number of bytes), they will be considered equal.
//
// `str1` str1 the first string to compare. NULL is not permitted!
// `str2` str2 the second string to compare. NULL is not permitted!
// `maxlen` maxlen the maximum number of bytes to compare.
// returns less than zero if str1 is "less than" str2, greater than zero if
//          str1 is "greater than" str2, and zero if the strings match
//          exactly.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strncasecmp(const_str1 &char, const_str2 &char, maxlen usize) int {
	return C.SDL_strncasecmp(const_str1, const_str2, maxlen)
}

// C.SDL_strpbrk [official documentation](https://wiki.libsdl.org/SDL3/SDL_strpbrk)
fn C.SDL_strpbrk(const_str &char, const_breakset &char) &char

// strpbrk searches a string for the first occurence of any character contained in a
// breakset, and returns a pointer from the string to that character.
//
// `str` str The null-terminated string to be searched. Must not be NULL, and
//            must not overlap with `breakset`.
// `breakset` breakset A null-terminated string containing the list of characters
//                 to look for. Must not be NULL, and must not overlap with
//                 `str`.
// returns A pointer to the location, in str, of the first occurence of a
//          character present in the breakset, or NULL if none is found.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn strpbrk(const_str &char, const_breakset &char) &char {
	return &char(C.SDL_strpbrk(const_str, const_breakset))
}

// The Unicode REPLACEMENT CHARACTER codepoint.
//
// SDL_StepUTF8() and SDL_StepBackUTF8() report this codepoint when they
// encounter a UTF-8 string with encoding errors.
//
// This tends to render as something like a question mark in most places.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_StepBackUTF8
// See also: SDL_StepUTF8
pub const invalid_unicode_codepoint = C.SDL_INVALID_UNICODE_CODEPOINT // 0xFFFD

// C.SDL_StepUTF8 [official documentation](https://wiki.libsdl.org/SDL3/SDL_StepUTF8)
fn C.SDL_StepUTF8(const_pstr &&char, pslen &usize) u32

// step_ut_f8 decodes a UTF-8 string, one Unicode codepoint at a time.
//
// This will return the first Unicode codepoint in the UTF-8 encoded string in
// `*pstr`, and then advance `*pstr` past any consumed bytes before returning.
//
// It will not access more than `*pslen` bytes from the string. `*pslen` will
// be adjusted, as well, subtracting the number of bytes consumed.
//
// `pslen` is allowed to be NULL, in which case the string _must_ be
// NULL-terminated, as the function will blindly read until it sees the NULL
// char.
//
// if `*pslen` is zero, it assumes the end of string is reached and returns a
// zero codepoint regardless of the contents of the string buffer.
//
// If the resulting codepoint is zero (a NULL terminator), or `*pslen` is
// zero, it will not advance `*pstr` or `*pslen` at all.
//
// Generally this function is called in a loop until it returns zero,
// adjusting its parameters each iteration.
//
// If an invalid UTF-8 sequence is encountered, this function returns
// SDL_INVALID_UNICODE_CODEPOINT and advances the string/length by one byte
// (which is to say, a multibyte sequence might produce several
// SDL_INVALID_UNICODE_CODEPOINT returns before it syncs to the next valid
// UTF-8 sequence).
//
// Several things can generate invalid UTF-8 sequences, including overlong
// encodings, the use of UTF-16 surrogate values, and truncated data. Please
// refer to
// [RFC3629](https://www.ietf.org/rfc/rfc3629.txt)
// for details.
//
// `pstr` pstr a pointer to a UTF-8 string pointer to be read and adjusted.
// `pslen` pslen a pointer to the number of bytes in the string, to be read and
//              adjusted. NULL is allowed.
// returns the first Unicode codepoint in the string.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn step_ut_f8(const_pstr &&char, pslen &usize) u32 {
	return C.SDL_StepUTF8(const_pstr, pslen)
}

// C.SDL_StepBackUTF8 [official documentation](https://wiki.libsdl.org/SDL3/SDL_StepBackUTF8)
fn C.SDL_StepBackUTF8(const_start &char, const_pstr &&char) u32

// step_back_ut_f8 decodes a UTF-8 string in reverse, one Unicode codepoint at a time.
//
// This will go to the start of the previous Unicode codepoint in the string,
// move `*pstr` to that location and return that codepoint.
//
// If `*pstr` is already at the start of the string), it will not advance
// `*pstr` at all.
//
// Generally this function is called in a loop until it returns zero,
// adjusting its parameter each iteration.
//
// If an invalid UTF-8 sequence is encountered, this function returns
// SDL_INVALID_UNICODE_CODEPOINT.
//
// Several things can generate invalid UTF-8 sequences, including overlong
// encodings, the use of UTF-16 surrogate values, and truncated data. Please
// refer to
// [RFC3629](https://www.ietf.org/rfc/rfc3629.txt)
// for details.
//
// `start` start a pointer to the beginning of the UTF-8 string.
// `pstr` pstr a pointer to a UTF-8 string pointer to be read and adjusted.
// returns the previous Unicode codepoint in the string.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn step_back_ut_f8(const_start &char, const_pstr &&char) u32 {
	return C.SDL_StepBackUTF8(const_start, const_pstr)
}

// C.SDL_UCS4ToUTF8 [official documentation](https://wiki.libsdl.org/SDL3/SDL_UCS4ToUTF8)
fn C.SDL_UCS4ToUTF8(codepoint u32, dst &char) &char

// uc_s4_to_ut_f8 converts a single Unicode codepoint to UTF-8.
//
// The buffer pointed to by `dst` must be at least 4 bytes long, as this
// function may generate between 1 and 4 bytes of output.
//
// This function returns the first byte _after_ the newly-written UTF-8
// sequence, which is useful for encoding multiple codepoints in a loop, or
// knowing where to write a NULL-terminator character to end the string (in
// either case, plan to have a buffer of _more_ than 4 bytes!).
//
// If `codepoint` is an invalid value (outside the Unicode range, or a UTF-16
// surrogate value, etc), this will use U+FFFD (REPLACEMENT CHARACTER) for the
// codepoint instead, and not set an error.
//
// If `dst` is NULL, this returns NULL immediately without writing to the
// pointer and without setting an error.
//
// `codepoint` codepoint a Unicode codepoint to convert to UTF-8.
// `dst` dst the location to write the encoded UTF-8. Must point to at least
//            4 bytes!
// returns the first byte past the newly-written UTF-8 sequence.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn uc_s4_to_ut_f8(codepoint u32, dst &char) &char {
	return &char(C.SDL_UCS4ToUTF8(codepoint, dst))
}

// C.SDL_sscanf [official documentation](https://wiki.libsdl.org/SDL3/SDL_sscanf)
// TODO: extern SDL_DECLSPEC int SDLCALL SDL_sscanf(const char *text, SDL_SCANF_FORMAT_STRING const char *fmt, ...) SDL_SCANF_VARARG_FUNC(2);

// sscanf this works exactly like sscanf() but doesn't require access to a C runtime.
//
// Scan a string, matching a format string, converting each '%' item and
// storing it to pointers provided through variable arguments.
//
// `text` text the string to scan. Must not be NULL.
// `fmt` fmt a printf-style format string. Must not be NULL.
// `...` ... a list of pointers to values to be filled in with scanned items.
// returns the number of items that matched the format string.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// TODO: sscanf(const_text &char, const_fmt &char, ...) {}

// C.SDL_vsscanf [official documentation](https://wiki.libsdl.org/SDL3/SDL_vsscanf)
// TODO: extern SDL_DECLSPEC int SDLCALL SDL_vsscanf(const char *text, SDL_SCANF_FORMAT_STRING const char *fmt, va_list ap) SDL_SCANF_VARARG_FUNCV(2);

// vsscanf this works exactly like vsscanf() but doesn't require access to a C
// runtime.
//
// Functions identically to SDL_sscanf(), except it takes a `va_list` instead
// of using `...` variable arguments.
//
// `text` text the string to scan. Must not be NULL.
// `fmt` fmt a printf-style format string. Must not be NULL.
// `ap` ap a `va_list` of pointers to values to be filled in with scanned
//           items.
// returns the number of items that matched the format string.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// TODO: vsscanf(const_text &char, const_fmt &char, ap C.va_list) int {}

// C.SDL_snprintf [official documentation](https://wiki.libsdl.org/SDL3/SDL_snprintf)
// TODO: extern SDL_DECLSPEC int SDLCALL SDL_snprintf(SDL_OUT_Z_CAP(maxlen) char *text, size_t maxlen, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(3);

// snprintf this works exactly like snprintf() but doesn't require access to a C
// runtime.
//
// Format a string of up to `maxlen`-1 bytes, converting each '%' item with
// values provided through variable arguments.
//
// While some C runtimes differ on how to deal with too-large strings, this
// function null-terminates the output, by treating the null-terminator as
// part of the `maxlen` count. Note that if `maxlen` is zero, however, no
// bytes will be written at all.
//
// This function returns the number of _bytes_ (not _characters_) that should
// be written, excluding the null-terminator character. If this returns a
// number >= `maxlen`, it means the output string was truncated. A negative
// return value means an error occurred.
//
// Referencing the output string's pointer with a format item is undefined
// behavior.
//
// `text` text the buffer to write the string into. Must not be NULL.
// `maxlen` maxlen the maximum bytes to write, including the null-terminator.
// `fmt` fmt a printf-style format string. Must not be NULL.
// `...` ... a list of values to be used with the format string.
// returns the number of bytes that should be written, not counting the
//          null-terminator char, or a negative value on error.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// TODO: pub fn snprintf(text &char, maxlen usize, const_fmt &char, ...) int

// TODO: extern SDL_DECLSPEC int SDLCALL SDL_swprintf(SDL_OUT_Z_CAP(maxlen) wchar_t *text, size_t maxlen, SDL_PRINTF_FORMAT_STRING const wchar_t *fmt, ...) SDL_WPRINTF_VARARG_FUNC(3);

// swprintf this works exactly like swprintf() but doesn't require access to a C
// runtime.
//
// Format a wide string of up to `maxlen`-1 wchar_t values, converting each
// '%' item with values provided through variable arguments.
//
// While some C runtimes differ on how to deal with too-large strings, this
// function null-terminates the output, by treating the null-terminator as
// part of the `maxlen` count. Note that if `maxlen` is zero, however, no wide
// characters will be written at all.
//
// This function returns the number of _wide characters_ (not _codepoints_)
// that should be written, excluding the null-terminator character. If this
// returns a number >= `maxlen`, it means the output string was truncated. A
// negative return value means an error occurred.
//
// Referencing the output string's pointer with a format item is undefined
// behavior.
//
// `text` text the buffer to write the wide string into. Must not be NULL.
// `maxlen` maxlen the maximum wchar_t values to write, including the
//               null-terminator.
// `fmt` fmt a printf-style format string. Must not be NULL.
// `...` ... a list of values to be used with the format string.
// returns the number of wide characters that should be written, not counting
//          the null-terminator char, or a negative value on error.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// pub fn swprintf(text &WCharT, maxlen usize, const_fmt &WCharT, ...) int {}

// TODO: extern SDL_DECLSPEC int SDLCALL SDL_vsnprintf(SDL_OUT_Z_CAP(maxlen) char *text, size_t maxlen, SDL_PRINTF_FORMAT_STRING const char *fmt, va_list ap) SDL_PRINTF_VARARG_FUNCV(3);

// vsnprintf this works exactly like vsnprintf() but doesn't require access to a C
// runtime.
//
// Functions identically to SDL_snprintf(), except it takes a `va_list`
// instead of using `...` variable arguments.
//
// `text` text the buffer to write the string into. Must not be NULL.
// `maxlen` maxlen the maximum bytes to write, including the null-terminator.
// `fmt` fmt a printf-style format string. Must not be NULL.
// `ap` ap a `va_list` values to be used with the format string.
// returns the number of bytes that should be written, not counting the
//          null-terminator char, or a negative value on error.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// pub fn vsnprintf(text &char, maxlen usize, const_fmt &char, ap C.va_list) int {}

// TODO: extern SDL_DECLSPEC int SDLCALL SDL_vswprintf(SDL_OUT_Z_CAP(maxlen) wchar_t *text, size_t maxlen, SDL_PRINTF_FORMAT_STRING const wchar_t *fmt, va_list ap) SDL_WPRINTF_VARARG_FUNCV(3);

// vswprintf this works exactly like vswprintf() but doesn't require access to a C
// runtime.
//
// Functions identically to SDL_swprintf(), except it takes a `va_list`
// instead of using `...` variable arguments.
//
// `text` text the buffer to write the string into. Must not be NULL.
// `maxlen` maxlen the maximum wide characters to write, including the
//               null-terminator.
// `fmt` fmt a printf-style format wide string. Must not be NULL.
// `ap` ap a `va_list` values to be used with the format string.
// returns the number of wide characters that should be written, not counting
//          the null-terminator char, or a negative value on error.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// pub fn vswprintf(text &WCharT, maxlen usize, const_fmt &WCharT, ap C.va_list) int {}

// TODO: extern SDL_DECLSPEC int SDLCALL SDL_asprintf(char **strp, SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(2);

// asprintf this works exactly like asprintf() but doesn't require access to a C
// runtime.
//
// Functions identically to SDL_snprintf(), except it allocates a buffer large
// enough to hold the output string on behalf of the caller.
//
// On success, this function returns the number of bytes (not characters)
// comprising the output string, not counting the null-terminator character,
// and sets `*strp` to the newly-allocated string.
//
// On error, this function returns a negative number, and the value of `*strp`
// is undefined.
//
// The returned string is owned by the caller, and should be passed to
// SDL_free when no longer needed.
//
// `strp` strp on output, is set to the new string. Must not be NULL.
// `fmt` fmt a printf-style format string. Must not be NULL.
// `...` ... a list of values to be used with the format string.
// returns the number of bytes in the newly-allocated string, not counting
//          the null-terminator char, or a negative value on error.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// pub fn asprintf(strp &&char, const_fmt &char, ...) int {}

// TODO: extern SDL_DECLSPEC int SDLCALL SDL_vasprintf(char **strp, SDL_PRINTF_FORMAT_STRING const char *fmt, va_list ap) SDL_PRINTF_VARARG_FUNCV(2);

// vasprintf this works exactly like vasprintf() but doesn't require access to a C
// runtime.
//
// Functions identically to SDL_asprintf(), except it takes a `va_list`
// instead of using `...` variable arguments.
//
// `strp` strp on output, is set to the new string. Must not be NULL.
// `fmt` fmt a printf-style format string. Must not be NULL.
// `ap` ap a `va_list` values to be used with the format string.
// returns the number of bytes in the newly-allocated string, not counting
//          the null-terminator char, or a negative value on error.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// pub fn vasprintf(strp &&char, const_fmt &char, ap C.va_list) int {}

// C.SDL_srand [official documentation](https://wiki.libsdl.org/SDL3/SDL_srand)
fn C.SDL_srand(seed u64)

// srand seeds the pseudo-random number generator.
//
// Reusing the seed number will cause SDL_rand_*() to repeat the same stream
// of 'random' numbers.
//
// `seed` seed the value to use as a random number seed, or 0 to use
//             SDL_GetPerformanceCounter().
//
// NOTE: (thread safety) This should be called on the same thread that calls
//               SDL_rand*()
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: rand (SDL_rand)
// See also: rand_bits (SDL_rand_bits)
// See also: randf (SDL_randf)
pub fn srand(seed u64) {
	C.SDL_srand(seed)
}

// C.SDL_rand [official documentation](https://wiki.libsdl.org/SDL3/SDL_rand)
fn C.SDL_rand(n i32) i32

// rand generates a pseudo-random number less than n for positive n
//
// The method used is faster and of better quality than `rand() % n`. Odds are
// roughly 99.9% even for n = 1 million. Evenness is better for smaller n, and
// much worse as n gets bigger.
//
// Example: to simulate a d6 use `SDL_rand(6) + 1` The +1 converts 0..5 to
// 1..6
//
// If you want to generate a pseudo-random number in the full range of Sint32,
// you should use: (Sint32)SDL_rand_bits()
//
// If you want reproducible output, be sure to initialize with SDL_srand()
// first.
//
// There are no guarantees as to the quality of the random sequence produced,
// and this should not be used for security (cryptography, passwords) or where
// money is on the line (loot-boxes, casinos). There are many random number
// libraries available with different characteristics and you should pick one
// of those to meet any serious needs.
//
// `n` n the number of possible outcomes. n must be positive.
// returns a random value in the range of [0 .. n-1].
//
// NOTE: (thread safety) All calls should be made from a single thread
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: srand (SDL_srand)
// See also: randf (SDL_randf)
pub fn rand(n i32) i32 {
	return C.SDL_rand(n)
}

// C.SDL_randf [official documentation](https://wiki.libsdl.org/SDL3/SDL_randf)
fn C.SDL_randf() f32

// randf generates a uniform pseudo-random floating point number less than 1.0
//
// If you want reproducible output, be sure to initialize with SDL_srand()
// first.
//
// There are no guarantees as to the quality of the random sequence produced,
// and this should not be used for security (cryptography, passwords) or where
// money is on the line (loot-boxes, casinos). There are many random number
// libraries available with different characteristics and you should pick one
// of those to meet any serious needs.
//
// returns a random value in the range of [0.0, 1.0).
//
// NOTE: (thread safety) All calls should be made from a single thread
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: srand (SDL_srand)
// See also: rand (SDL_rand)
pub fn randf() f32 {
	return C.SDL_randf()
}

// C.SDL_rand_bits [official documentation](https://wiki.libsdl.org/SDL3/SDL_rand_bits)
fn C.SDL_rand_bits() u32

// rand_bits generates 32 pseudo-random bits.
//
// You likely want to use SDL_rand() to get a psuedo-random number instead.
//
// There are no guarantees as to the quality of the random sequence produced,
// and this should not be used for security (cryptography, passwords) or where
// money is on the line (loot-boxes, casinos). There are many random number
// libraries available with different characteristics and you should pick one
// of those to meet any serious needs.
//
// returns a random value in the range of [0-SDL_MAX_UINT32].
//
// NOTE: (thread safety) All calls should be made from a single thread
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: rand (SDL_rand)
// See also: randf (SDL_randf)
// See also: srand (SDL_srand)
pub fn rand_bits() u32 {
	return C.SDL_rand_bits()
}

// C.SDL_rand_r [official documentation](https://wiki.libsdl.org/SDL3/SDL_rand_r)
fn C.SDL_rand_r(state &u64, n i32) i32

// rand_r generates a pseudo-random number less than n for positive n
//
// The method used is faster and of better quality than `rand() % n`. Odds are
// roughly 99.9% even for n = 1 million. Evenness is better for smaller n, and
// much worse as n gets bigger.
//
// Example: to simulate a d6 use `SDL_rand_r(state, 6) + 1` The +1 converts
// 0..5 to 1..6
//
// If you want to generate a pseudo-random number in the full range of Sint32,
// you should use: (Sint32)SDL_rand_bits_r(state)
//
// There are no guarantees as to the quality of the random sequence produced,
// and this should not be used for security (cryptography, passwords) or where
// money is on the line (loot-boxes, casinos). There are many random number
// libraries available with different characteristics and you should pick one
// of those to meet any serious needs.
//
// `state` state a pointer to the current random number state, this may not be
//              NULL.
// `n` n the number of possible outcomes. n must be positive.
// returns a random value in the range of [0 .. n-1].
//
// NOTE: (thread safety) This function is thread-safe, as long as the state pointer
//               isn't shared between threads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: rand (SDL_rand)
// See also: rand_bits_r (SDL_rand_bits_r)
// See also: randf_r (SDL_randf_r)
pub fn rand_r(state &u64, n i32) i32 {
	return C.SDL_rand_r(state, n)
}

// C.SDL_randf_r [official documentation](https://wiki.libsdl.org/SDL3/SDL_randf_r)
fn C.SDL_randf_r(state &u64) f32

// randf_r generates a uniform pseudo-random floating point number less than 1.0
//
// If you want reproducible output, be sure to initialize with SDL_srand()
// first.
//
// There are no guarantees as to the quality of the random sequence produced,
// and this should not be used for security (cryptography, passwords) or where
// money is on the line (loot-boxes, casinos). There are many random number
// libraries available with different characteristics and you should pick one
// of those to meet any serious needs.
//
// `state` state a pointer to the current random number state, this may not be
//              NULL.
// returns a random value in the range of [0.0, 1.0).
//
// NOTE: (thread safety) This function is thread-safe, as long as the state pointer
//               isn't shared between threads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: rand_bits_r (SDL_rand_bits_r)
// See also: rand_r (SDL_rand_r)
// See also: randf (SDL_randf)
pub fn randf_r(state &u64) f32 {
	return C.SDL_randf_r(state)
}

// C.SDL_rand_bits_r [official documentation](https://wiki.libsdl.org/SDL3/SDL_rand_bits_r)
fn C.SDL_rand_bits_r(state &u64) u32

// rand_bits_r generates 32 pseudo-random bits.
//
// You likely want to use SDL_rand_r() to get a psuedo-random number instead.
//
// There are no guarantees as to the quality of the random sequence produced,
// and this should not be used for security (cryptography, passwords) or where
// money is on the line (loot-boxes, casinos). There are many random number
// libraries available with different characteristics and you should pick one
// of those to meet any serious needs.
//
// `state` state a pointer to the current random number state, this may not be
//              NULL.
// returns a random value in the range of [0-SDL_MAX_UINT32].
//
// NOTE: (thread safety) This function is thread-safe, as long as the state pointer
//               isn't shared between threads.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: rand_r (SDL_rand_r)
// See also: randf_r (SDL_randf_r)
pub fn rand_bits_r(state &u64) u32 {
	return C.SDL_rand_bits_r(state)
}

pub const pi_d = f64(C.SDL_PI_D) // 3.141592653589793238462643383279502884

pub const pi_f = f64(C.SDL_PI_F) // 3.141592653589793238462643383279502884F

// C.SDL_acos [official documentation](https://wiki.libsdl.org/SDL3/SDL_acos)
fn C.SDL_acos(x f64) f64

// acos computes the arc cosine of `x`.
//
// The definition of `y = acos(x)` is `x = cos(y)`.
//
// Domain: `-1 <= x <= 1`
//
// Range: `0 <= y <= Pi`
//
// This function operates on double-precision floating point values, use
// SDL_acosf for single-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value.
// returns arc cosine of `x`, in radians.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: acosf (SDL_acosf)
// See also: asin (SDL_asin)
// See also: cos (SDL_cos)
pub fn acos(x f64) f64 {
	return C.SDL_acos(x)
}

// C.SDL_acosf [official documentation](https://wiki.libsdl.org/SDL3/SDL_acosf)
fn C.SDL_acosf(x f32) f32

// acosf computes the arc cosine of `x`.
//
// The definition of `y = acos(x)` is `x = cos(y)`.
//
// Domain: `-1 <= x <= 1`
//
// Range: `0 <= y <= Pi`
//
// This function operates on single-precision floating point values, use
// SDL_acos for double-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value.
// returns arc cosine of `x`, in radians.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: acos (SDL_acos)
// See also: asinf (SDL_asinf)
// See also: cosf (SDL_cosf)
pub fn acosf(x f32) f32 {
	return C.SDL_acosf(x)
}

// C.SDL_asin [official documentation](https://wiki.libsdl.org/SDL3/SDL_asin)
fn C.SDL_asin(x f64) f64

// asin computes the arc sine of `x`.
//
// The definition of `y = asin(x)` is `x = sin(y)`.
//
// Domain: `-1 <= x <= 1`
//
// Range: `-Pi/2 <= y <= Pi/2`
//
// This function operates on double-precision floating point values, use
// SDL_asinf for single-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value.
// returns arc sine of `x`, in radians.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: asinf (SDL_asinf)
// See also: acos (SDL_acos)
// See also: sin (SDL_sin)
pub fn asin(x f64) f64 {
	return C.SDL_asin(x)
}

// C.SDL_asinf [official documentation](https://wiki.libsdl.org/SDL3/SDL_asinf)
fn C.SDL_asinf(x f32) f32

// asinf computes the arc sine of `x`.
//
// The definition of `y = asin(x)` is `x = sin(y)`.
//
// Domain: `-1 <= x <= 1`
//
// Range: `-Pi/2 <= y <= Pi/2`
//
// This function operates on single-precision floating point values, use
// SDL_asin for double-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value.
// returns arc sine of `x`, in radians.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: asin (SDL_asin)
// See also: acosf (SDL_acosf)
// See also: sinf (SDL_sinf)
pub fn asinf(x f32) f32 {
	return C.SDL_asinf(x)
}

// C.SDL_atan [official documentation](https://wiki.libsdl.org/SDL3/SDL_atan)
fn C.SDL_atan(x f64) f64

// atan computes the arc tangent of `x`.
//
// The definition of `y = atan(x)` is `x = tan(y)`.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-Pi/2 <= y <= Pi/2`
//
// This function operates on double-precision floating point values, use
// SDL_atanf for single-precision floats.
//
// To calculate the arc tangent of y / x, use SDL_atan2.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value.
// returns arc tangent of of `x` in radians, or 0 if `x = 0`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atanf (SDL_atanf)
// See also: atan2 (SDL_atan2)
// See also: tan (SDL_tan)
pub fn atan(x f64) f64 {
	return C.SDL_atan(x)
}

// C.SDL_atanf [official documentation](https://wiki.libsdl.org/SDL3/SDL_atanf)
fn C.SDL_atanf(x f32) f32

// atanf computes the arc tangent of `x`.
//
// The definition of `y = atan(x)` is `x = tan(y)`.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-Pi/2 <= y <= Pi/2`
//
// This function operates on single-precision floating point values, use
// SDL_atan for dboule-precision floats.
//
// To calculate the arc tangent of y / x, use SDL_atan2f.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value.
// returns arc tangent of of `x` in radians, or 0 if `x = 0`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atan (SDL_atan)
// See also: atan2f (SDL_atan2f)
// See also: tanf (SDL_tanf)
pub fn atanf(x f32) f32 {
	return C.SDL_atanf(x)
}

// C.SDL_atan2 [official documentation](https://wiki.libsdl.org/SDL3/SDL_atan2)
fn C.SDL_atan2(y f64, x f64) f64

// atan2 computes the arc tangent of `y / x`, using the signs of x and y to adjust
// the result's quadrant.
//
// The definition of `z = atan2(x, y)` is `y = x tan(z)`, where the quadrant
// of z is determined based on the signs of x and y.
//
// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
//
// Range: `-Pi/2 <= y <= Pi/2`
//
// This function operates on double-precision floating point values, use
// SDL_atan2f for single-precision floats.
//
// To calculate the arc tangent of a single value, use SDL_atan.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `y` y floating point value of the numerator (y coordinate).
// `x` x floating point value of the denominator (x coordinate).
// returns arc tangent of of `y / x` in radians, or, if `x = 0`, either
//          `-Pi/2`, `0`, or `Pi/2`, depending on the value of `y`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atan2f (SDL_atan2f)
// See also: atan (SDL_atan)
// See also: tan (SDL_tan)
pub fn atan2(y f64, x f64) f64 {
	return C.SDL_atan2(y, x)
}

// C.SDL_atan2f [official documentation](https://wiki.libsdl.org/SDL3/SDL_atan2f)
fn C.SDL_atan2f(y f32, x f32) f32

// atan2f computes the arc tangent of `y / x`, using the signs of x and y to adjust
// the result's quadrant.
//
// The definition of `z = atan2(x, y)` is `y = x tan(z)`, where the quadrant
// of z is determined based on the signs of x and y.
//
// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
//
// Range: `-Pi/2 <= y <= Pi/2`
//
// This function operates on single-precision floating point values, use
// SDL_atan2 for double-precision floats.
//
// To calculate the arc tangent of a single value, use SDL_atanf.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `y` y floating point value of the numerator (y coordinate).
// `x` x floating point value of the denominator (x coordinate).
// returns arc tangent of of `y / x` in radians, or, if `x = 0`, either
//          `-Pi/2`, `0`, or `Pi/2`, depending on the value of `y`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: atan2f (SDL_atan2f)
// See also: atan (SDL_atan)
// See also: tan (SDL_tan)
pub fn atan2f(y f32, x f32) f32 {
	return C.SDL_atan2f(y, x)
}

// C.SDL_ceil [official documentation](https://wiki.libsdl.org/SDL3/SDL_ceil)
fn C.SDL_ceil(x f64) f64

// ceil computes the ceiling of `x`.
//
// The ceiling of `x` is the smallest integer `y` such that `y > x`, i.e `x`
// rounded up to the nearest integer.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-INF <= y <= INF`, y integer
//
// This function operates on double-precision floating point values, use
// SDL_ceilf for single-precision floats.
//
// `x` x floating point value.
// returns the ceiling of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: ceilf (SDL_ceilf)
// See also: floor (SDL_floor)
// See also: trunc (SDL_trunc)
// See also: round (SDL_round)
// See also: lround (SDL_lround)
pub fn ceil(x f64) f64 {
	return C.SDL_ceil(x)
}

// C.SDL_ceilf [official documentation](https://wiki.libsdl.org/SDL3/SDL_ceilf)
fn C.SDL_ceilf(x f32) f32

// ceilf computes the ceiling of `x`.
//
// The ceiling of `x` is the smallest integer `y` such that `y > x`, i.e `x`
// rounded up to the nearest integer.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-INF <= y <= INF`, y integer
//
// This function operates on single-precision floating point values, use
// SDL_ceil for double-precision floats.
//
// `x` x floating point value.
// returns the ceiling of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: ceil (SDL_ceil)
// See also: floorf (SDL_floorf)
// See also: truncf (SDL_truncf)
// See also: roundf (SDL_roundf)
// See also: lroundf (SDL_lroundf)
pub fn ceilf(x f32) f32 {
	return C.SDL_ceilf(x)
}

// C.SDL_copysign [official documentation](https://wiki.libsdl.org/SDL3/SDL_copysign)
fn C.SDL_copysign(x f64, y f64) f64

// copysign copys the sign of one floating-point value to another.
//
// The definition of copysign is that ``copysign(x, y) = abs(x) * sign(y)``.
//
// Domain: `-INF <= x <= INF`, ``-INF <= y <= f``
//
// Range: `-INF <= z <= INF`
//
// This function operates on double-precision floating point values, use
// SDL_copysignf for single-precision floats.
//
// `x` x floating point value to use as the magnitude.
// `y` y floating point value to use as the sign.
// returns the floating point value with the sign of y and the magnitude of
//          x.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: copysignf (SDL_copysignf)
// See also: fabs (SDL_fabs)
pub fn copysign(x f64, y f64) f64 {
	return C.SDL_copysign(x, y)
}

// C.SDL_copysignf [official documentation](https://wiki.libsdl.org/SDL3/SDL_copysignf)
fn C.SDL_copysignf(x f32, y f32) f32

// copysignf copys the sign of one floating-point value to another.
//
// The definition of copysign is that ``copysign(x, y) = abs(x) * sign(y)``.
//
// Domain: `-INF <= x <= INF`, ``-INF <= y <= f``
//
// Range: `-INF <= z <= INF`
//
// This function operates on single-precision floating point values, use
// SDL_copysign for double-precision floats.
//
// `x` x floating point value to use as the magnitude.
// `y` y floating point value to use as the sign.
// returns the floating point value with the sign of y and the magnitude of
//          x.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: copysignf (SDL_copysignf)
// See also: fabsf (SDL_fabsf)
pub fn copysignf(x f32, y f32) f32 {
	return C.SDL_copysignf(x, y)
}

// C.SDL_cos [official documentation](https://wiki.libsdl.org/SDL3/SDL_cos)
fn C.SDL_cos(x f64) f64

// cos computes the cosine of `x`.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-1 <= y <= 1`
//
// This function operates on double-precision floating point values, use
// SDL_cosf for single-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value, in radians.
// returns cosine of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: cosf (SDL_cosf)
// See also: acos (SDL_acos)
// See also: sin (SDL_sin)
pub fn cos(x f64) f64 {
	return C.SDL_cos(x)
}

// C.SDL_cosf [official documentation](https://wiki.libsdl.org/SDL3/SDL_cosf)
fn C.SDL_cosf(x f32) f32

// cosf computes the cosine of `x`.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-1 <= y <= 1`
//
// This function operates on single-precision floating point values, use
// SDL_cos for double-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value, in radians.
// returns cosine of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: cos (SDL_cos)
// See also: acosf (SDL_acosf)
// See also: sinf (SDL_sinf)
pub fn cosf(x f32) f32 {
	return C.SDL_cosf(x)
}

// C.SDL_exp [official documentation](https://wiki.libsdl.org/SDL3/SDL_exp)
fn C.SDL_exp(x f64) f64

// exp computes the exponential of `x`.
//
// The definition of `y = exp(x)` is `y = e^x`, where `e` is the base of the
// natural logarithm. The inverse is the natural logarithm, SDL_log.
//
// Domain: `-INF <= x <= INF`
//
// Range: `0 <= y <= INF`
//
// The output will overflow if `exp(x)` is too large to be represented.
//
// This function operates on double-precision floating point values, use
// SDL_expf for single-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value.
// returns value of `e^x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: expf (SDL_expf)
// See also: log (SDL_log)
pub fn exp(x f64) f64 {
	return C.SDL_exp(x)
}

// C.SDL_expf [official documentation](https://wiki.libsdl.org/SDL3/SDL_expf)
fn C.SDL_expf(x f32) f32

// expf computes the exponential of `x`.
//
// The definition of `y = exp(x)` is `y = e^x`, where `e` is the base of the
// natural logarithm. The inverse is the natural logarithm, SDL_logf.
//
// Domain: `-INF <= x <= INF`
//
// Range: `0 <= y <= INF`
//
// The output will overflow if `exp(x)` is too large to be represented.
//
// This function operates on single-precision floating point values, use
// SDL_exp for double-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value.
// returns value of `e^x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: exp (SDL_exp)
// See also: logf (SDL_logf)
pub fn expf(x f32) f32 {
	return C.SDL_expf(x)
}

// C.SDL_fabs [official documentation](https://wiki.libsdl.org/SDL3/SDL_fabs)
fn C.SDL_fabs(x f64) f64

// fabs computes the absolute value of `x`
//
// Domain: `-INF <= x <= INF`
//
// Range: `0 <= y <= INF`
//
// This function operates on double-precision floating point values, use
// SDL_copysignf for single-precision floats.
//
// `x` x floating point value to use as the magnitude.
// returns the absolute value of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: fabsf (SDL_fabsf)
pub fn fabs(x f64) f64 {
	return C.SDL_fabs(x)
}

// C.SDL_fabsf [official documentation](https://wiki.libsdl.org/SDL3/SDL_fabsf)
fn C.SDL_fabsf(x f32) f32

// fabsf computes the absolute value of `x`
//
// Domain: `-INF <= x <= INF`
//
// Range: `0 <= y <= INF`
//
// This function operates on single-precision floating point values, use
// SDL_copysignf for double-precision floats.
//
// `x` x floating point value to use as the magnitude.
// returns the absolute value of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: fabs (SDL_fabs)
pub fn fabsf(x f32) f32 {
	return C.SDL_fabsf(x)
}

// C.SDL_floor [official documentation](https://wiki.libsdl.org/SDL3/SDL_floor)
fn C.SDL_floor(x f64) f64

// floor computes the floor of `x`.
//
// The floor of `x` is the largest integer `y` such that `y > x`, i.e `x`
// rounded down to the nearest integer.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-INF <= y <= INF`, y integer
//
// This function operates on double-precision floating point values, use
// SDL_floorf for single-precision floats.
//
// `x` x floating point value.
// returns the floor of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: floorf (SDL_floorf)
// See also: ceil (SDL_ceil)
// See also: trunc (SDL_trunc)
// See also: round (SDL_round)
// See also: lround (SDL_lround)
pub fn floor(x f64) f64 {
	return C.SDL_floor(x)
}

// C.SDL_floorf [official documentation](https://wiki.libsdl.org/SDL3/SDL_floorf)
fn C.SDL_floorf(x f32) f32

// floorf computes the floor of `x`.
//
// The floor of `x` is the largest integer `y` such that `y > x`, i.e `x`
// rounded down to the nearest integer.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-INF <= y <= INF`, y integer
//
// This function operates on single-precision floating point values, use
// SDL_floorf for double-precision floats.
//
// `x` x floating point value.
// returns the floor of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: floor (SDL_floor)
// See also: ceilf (SDL_ceilf)
// See also: truncf (SDL_truncf)
// See also: roundf (SDL_roundf)
// See also: lroundf (SDL_lroundf)
pub fn floorf(x f32) f32 {
	return C.SDL_floorf(x)
}

// C.SDL_trunc [official documentation](https://wiki.libsdl.org/SDL3/SDL_trunc)
fn C.SDL_trunc(x f64) f64

// trunc truncates `x` to an integer.
//
// Rounds `x` to the next closest integer to 0. This is equivalent to removing
// the fractional part of `x`, leaving only the integer part.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-INF <= y <= INF`, y integer
//
// This function operates on double-precision floating point values, use
// SDL_truncf for single-precision floats.
//
// `x` x floating point value.
// returns `x` truncated to an integer.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: truncf (SDL_truncf)
// See also: fmod (SDL_fmod)
// See also: ceil (SDL_ceil)
// See also: floor (SDL_floor)
// See also: round (SDL_round)
// See also: lround (SDL_lround)
pub fn trunc(x f64) f64 {
	return C.SDL_trunc(x)
}

// C.SDL_truncf [official documentation](https://wiki.libsdl.org/SDL3/SDL_truncf)
fn C.SDL_truncf(x f32) f32

// truncf truncates `x` to an integer.
//
// Rounds `x` to the next closest integer to 0. This is equivalent to removing
// the fractional part of `x`, leaving only the integer part.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-INF <= y <= INF`, y integer
//
// This function operates on single-precision floating point values, use
// SDL_truncf for double-precision floats.
//
// `x` x floating point value.
// returns `x` truncated to an integer.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: trunc (SDL_trunc)
// See also: fmodf (SDL_fmodf)
// See also: ceilf (SDL_ceilf)
// See also: floorf (SDL_floorf)
// See also: roundf (SDL_roundf)
// See also: lroundf (SDL_lroundf)
pub fn truncf(x f32) f32 {
	return C.SDL_truncf(x)
}

// C.SDL_fmod [official documentation](https://wiki.libsdl.org/SDL3/SDL_fmod)
fn C.SDL_fmod(x f64, y f64) f64

// fmod returns the floating-point remainder of `x / y`
//
// Divides `x` by `y`, and returns the remainder.
//
// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`, `y != 0`
//
// Range: `-y <= z <= y`
//
// This function operates on double-precision floating point values, use
// SDL_fmodf for single-precision floats.
//
// `x` x the numerator.
// `y` y the denominator. Must not be 0.
// returns the remainder of `x / y`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: fmodf (SDL_fmodf)
// See also: modf (SDL_modf)
// See also: trunc (SDL_trunc)
// See also: ceil (SDL_ceil)
// See also: floor (SDL_floor)
// See also: round (SDL_round)
// See also: lround (SDL_lround)
pub fn fmod(x f64, y f64) f64 {
	return C.SDL_fmod(x, y)
}

// C.SDL_fmodf [official documentation](https://wiki.libsdl.org/SDL3/SDL_fmodf)
fn C.SDL_fmodf(x f32, y f32) f32

// fmodf returns the floating-point remainder of `x / y`
//
// Divides `x` by `y`, and returns the remainder.
//
// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`, `y != 0`
//
// Range: `-y <= z <= y`
//
// This function operates on single-precision floating point values, use
// SDL_fmod for single-precision floats.
//
// `x` x the numerator.
// `y` y the denominator. Must not be 0.
// returns the remainder of `x / y`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: fmod (SDL_fmod)
// See also: truncf (SDL_truncf)
// See also: modff (SDL_modff)
// See also: ceilf (SDL_ceilf)
// See also: floorf (SDL_floorf)
// See also: roundf (SDL_roundf)
// See also: lroundf (SDL_lroundf)
pub fn fmodf(x f32, y f32) f32 {
	return C.SDL_fmodf(x, y)
}

// C.SDL_isinf [official documentation](https://wiki.libsdl.org/SDL3/SDL_isinf)
fn C.SDL_isinf(x f64) int

// isinf returns whether the value is infinity.
//
// `x` x double-precision floating point value.
// returns non-zero if the value is infinity, 0 otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: isinff (SDL_isinff)
pub fn isinf(x f64) int {
	return C.SDL_isinf(x)
}

// C.SDL_isinff [official documentation](https://wiki.libsdl.org/SDL3/SDL_isinff)
fn C.SDL_isinff(x f32) int

// isinff returns whether the value is infinity.
//
// `x` x floating point value.
// returns non-zero if the value is infinity, 0 otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: isinf (SDL_isinf)
pub fn isinff(x f32) int {
	return C.SDL_isinff(x)
}

// C.SDL_isnan [official documentation](https://wiki.libsdl.org/SDL3/SDL_isnan)
fn C.SDL_isnan(x f64) int

// isnan returns whether the value is NaN.
//
// `x` x double-precision floating point value.
// returns non-zero if the value is NaN, 0 otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: isnanf (SDL_isnanf)
pub fn isnan(x f64) int {
	return C.SDL_isnan(x)
}

// C.SDL_isnanf [official documentation](https://wiki.libsdl.org/SDL3/SDL_isnanf)
fn C.SDL_isnanf(x f32) int

// isnanf returns whether the value is NaN.
//
// `x` x floating point value.
// returns non-zero if the value is NaN, 0 otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: isnan (SDL_isnan)
pub fn isnanf(x f32) int {
	return C.SDL_isnanf(x)
}

// C.SDL_log [official documentation](https://wiki.libsdl.org/SDL3/SDL_log)
fn C.SDL_log(x f64) f64

// log computes the natural logarithm of `x`.
//
// Domain: `0 < x <= INF`
//
// Range: `-INF <= y <= INF`
//
// It is an error for `x` to be less than or equal to 0.
//
// This function operates on double-precision floating point values, use
// SDL_logf for single-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value. Must be greater than 0.
// returns the natural logarithm of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: logf (SDL_logf)
// See also: log10 (SDL_log10)
// See also: exp (SDL_exp)
pub fn log(x f64) f64 {
	return C.SDL_log(x)
}

// C.SDL_logf [official documentation](https://wiki.libsdl.org/SDL3/SDL_logf)
fn C.SDL_logf(x f32) f32

// logf computes the natural logarithm of `x`.
//
// Domain: `0 < x <= INF`
//
// Range: `-INF <= y <= INF`
//
// It is an error for `x` to be less than or equal to 0.
//
// This function operates on single-precision floating point values, use
// SDL_log for double-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value. Must be greater than 0.
// returns the natural logarithm of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log (SDL_log)
// See also: expf (SDL_expf)
pub fn logf(x f32) f32 {
	return C.SDL_logf(x)
}

// C.SDL_log10 [official documentation](https://wiki.libsdl.org/SDL3/SDL_log10)
fn C.SDL_log10(x f64) f64

// log10 computes the base-10 logarithm of `x`.
//
// Domain: `0 < x <= INF`
//
// Range: `-INF <= y <= INF`
//
// It is an error for `x` to be less than or equal to 0.
//
// This function operates on double-precision floating point values, use
// SDL_log10f for single-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value. Must be greater than 0.
// returns the logarithm of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log10f (SDL_log10f)
// See also: log (SDL_log)
// See also: pow (SDL_pow)
pub fn log10(x f64) f64 {
	return C.SDL_log10(x)
}

// C.SDL_log10f [official documentation](https://wiki.libsdl.org/SDL3/SDL_log10f)
fn C.SDL_log10f(x f32) f32

// log10f computes the base-10 logarithm of `x`.
//
// Domain: `0 < x <= INF`
//
// Range: `-INF <= y <= INF`
//
// It is an error for `x` to be less than or equal to 0.
//
// This function operates on single-precision floating point values, use
// SDL_log10 for double-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value. Must be greater than 0.
// returns the logarithm of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: log10 (SDL_log10)
// See also: logf (SDL_logf)
// See also: powf (SDL_powf)
pub fn log10f(x f32) f32 {
	return C.SDL_log10f(x)
}

// C.SDL_modf [official documentation](https://wiki.libsdl.org/SDL3/SDL_modf)
fn C.SDL_modf(x f64, y &f64) f64

// modf splits `x` into integer and fractional parts
//
// This function operates on double-precision floating point values, use
// SDL_modff for single-precision floats.
//
// `x` x floating point value.
// `y` y output pointer to store the integer part of `x`.
// returns the fractional part of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: modff (SDL_modff)
// See also: trunc (SDL_trunc)
// See also: fmod (SDL_fmod)
pub fn modf(x f64, y &f64) f64 {
	return C.SDL_modf(x, y)
}

// C.SDL_modff [official documentation](https://wiki.libsdl.org/SDL3/SDL_modff)
fn C.SDL_modff(x f32, y &f32) f32

// modff splits `x` into integer and fractional parts
//
// This function operates on single-precision floating point values, use
// SDL_modf for double-precision floats.
//
// `x` x floating point value.
// `y` y output pointer to store the integer part of `x`.
// returns the fractional part of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: modf (SDL_modf)
// See also: truncf (SDL_truncf)
// See also: fmodf (SDL_fmodf)
pub fn modff(x f32, y &f32) f32 {
	return C.SDL_modff(x, y)
}

// C.SDL_pow [official documentation](https://wiki.libsdl.org/SDL3/SDL_pow)
fn C.SDL_pow(x f64, y f64) f64

// pow raises `x` to the power `y`
//
// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
//
// Range: `-INF <= z <= INF`
//
// If `y` is the base of the natural logarithm (e), consider using SDL_exp
// instead.
//
// This function operates on double-precision floating point values, use
// SDL_powf for single-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x the base.
// `y` y the exponent.
// returns `x` raised to the power `y`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: powf (SDL_powf)
// See also: exp (SDL_exp)
// See also: log (SDL_log)
pub fn pow(x f64, y f64) f64 {
	return C.SDL_pow(x, y)
}

// C.SDL_powf [official documentation](https://wiki.libsdl.org/SDL3/SDL_powf)
fn C.SDL_powf(x f32, y f32) f32

// powf raises `x` to the power `y`
//
// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
//
// Range: `-INF <= z <= INF`
//
// If `y` is the base of the natural logarithm (e), consider using SDL_exp
// instead.
//
// This function operates on single-precision floating point values, use
// SDL_powf for double-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x the base.
// `y` y the exponent.
// returns `x` raised to the power `y`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: pow (SDL_pow)
// See also: expf (SDL_expf)
// See also: logf (SDL_logf)
pub fn powf(x f32, y f32) f32 {
	return C.SDL_powf(x, y)
}

// C.SDL_round [official documentation](https://wiki.libsdl.org/SDL3/SDL_round)
fn C.SDL_round(x f64) f64

// round rounds `x` to the nearest integer.
//
// Rounds `x` to the nearest integer. Values halfway between integers will be
// rounded away from zero.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-INF <= y <= INF`, y integer
//
// This function operates on double-precision floating point values, use
// SDL_roundf for single-precision floats. To get the result as an integer
// type, use SDL_lround.
//
// `x` x floating point value.
// returns the nearest integer to `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: roundf (SDL_roundf)
// See also: lround (SDL_lround)
// See also: floor (SDL_floor)
// See also: ceil (SDL_ceil)
// See also: trunc (SDL_trunc)
pub fn round(x f64) f64 {
	return C.SDL_round(x)
}

// C.SDL_roundf [official documentation](https://wiki.libsdl.org/SDL3/SDL_roundf)
fn C.SDL_roundf(x f32) f32

// roundf rounds `x` to the nearest integer.
//
// Rounds `x` to the nearest integer. Values halfway between integers will be
// rounded away from zero.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-INF <= y <= INF`, y integer
//
// This function operates on double-precision floating point values, use
// SDL_roundf for single-precision floats. To get the result as an integer
// type, use SDL_lroundf.
//
// `x` x floating point value.
// returns the nearest integer to `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: round (SDL_round)
// See also: lroundf (SDL_lroundf)
// See also: floorf (SDL_floorf)
// See also: ceilf (SDL_ceilf)
// See also: truncf (SDL_truncf)
pub fn roundf(x f32) f32 {
	return C.SDL_roundf(x)
}

// C.SDL_lround [official documentation](https://wiki.libsdl.org/SDL3/SDL_lround)
fn C.SDL_lround(x f64) int

// lround rounds `x` to the nearest integer representable as a long
//
// Rounds `x` to the nearest integer. Values halfway between integers will be
// rounded away from zero.
//
// Domain: `-INF <= x <= INF`
//
// Range: `MIN_LONG <= y <= MAX_LONG`
//
// This function operates on double-precision floating point values, use
// SDL_lround for single-precision floats. To get the result as a
// floating-point type, use SDL_round.
//
// `x` x floating point value.
// returns the nearest integer to `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lroundf (SDL_lroundf)
// See also: round (SDL_round)
// See also: floor (SDL_floor)
// See also: ceil (SDL_ceil)
// See also: trunc (SDL_trunc)
pub fn lround(x f64) int {
	return C.SDL_lround(x)
}

// C.SDL_lroundf [official documentation](https://wiki.libsdl.org/SDL3/SDL_lroundf)
fn C.SDL_lroundf(x f32) int

// lroundf rounds `x` to the nearest integer representable as a long
//
// Rounds `x` to the nearest integer. Values halfway between integers will be
// rounded away from zero.
//
// Domain: `-INF <= x <= INF`
//
// Range: `MIN_LONG <= y <= MAX_LONG`
//
// This function operates on single-precision floating point values, use
// SDL_lroundf for double-precision floats. To get the result as a
// floating-point type, use SDL_roundf,
//
// `x` x floating point value.
// returns the nearest integer to `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lround (SDL_lround)
// See also: roundf (SDL_roundf)
// See also: floorf (SDL_floorf)
// See also: ceilf (SDL_ceilf)
// See also: truncf (SDL_truncf)
pub fn lroundf(x f32) int {
	return C.SDL_lroundf(x)
}

// C.SDL_scalbn [official documentation](https://wiki.libsdl.org/SDL3/SDL_scalbn)
fn C.SDL_scalbn(x f64, n int) f64

// scalbn scales `x` by an integer power of two.
//
// Multiplies `x` by the `n`th power of the floating point radix (always 2).
//
// Domain: `-INF <= x <= INF`, `n` integer
//
// Range: `-INF <= y <= INF`
//
// This function operates on double-precision floating point values, use
// SDL_scalbnf for single-precision floats.
//
// `x` x floating point value to be scaled.
// `n` n integer exponent.
// returns `x * 2^n`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: scalbnf (SDL_scalbnf)
// See also: pow (SDL_pow)
pub fn scalbn(x f64, n int) f64 {
	return C.SDL_scalbn(x, n)
}

// C.SDL_scalbnf [official documentation](https://wiki.libsdl.org/SDL3/SDL_scalbnf)
fn C.SDL_scalbnf(x f32, n int) f32

// scalbnf scales `x` by an integer power of two.
//
// Multiplies `x` by the `n`th power of the floating point radix (always 2).
//
// Domain: `-INF <= x <= INF`, `n` integer
//
// Range: `-INF <= y <= INF`
//
// This function operates on single-precision floating point values, use
// SDL_scalbn for double-precision floats.
//
// `x` x floating point value to be scaled.
// `n` n integer exponent.
// returns `x * 2^n`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: scalbn (SDL_scalbn)
// See also: powf (SDL_powf)
pub fn scalbnf(x f32, n int) f32 {
	return C.SDL_scalbnf(x, n)
}

// C.SDL_sin [official documentation](https://wiki.libsdl.org/SDL3/SDL_sin)
fn C.SDL_sin(x f64) f64

// sin computes the sine of `x`.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-1 <= y <= 1`
//
// This function operates on double-precision floating point values, use
// SDL_sinf for single-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value, in radians.
// returns sine of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: sinf (SDL_sinf)
// See also: asin (SDL_asin)
// See also: cos (SDL_cos)
pub fn sin(x f64) f64 {
	return C.SDL_sin(x)
}

// C.SDL_sinf [official documentation](https://wiki.libsdl.org/SDL3/SDL_sinf)
fn C.SDL_sinf(x f32) f32

// sinf computes the sine of `x`.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-1 <= y <= 1`
//
// This function operates on single-precision floating point values, use
// SDL_sin for double-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value, in radians.
// returns sine of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: sin (SDL_sin)
// See also: asinf (SDL_asinf)
// See also: cosf (SDL_cosf)
pub fn sinf(x f32) f32 {
	return C.SDL_sinf(x)
}

// C.SDL_sqrt [official documentation](https://wiki.libsdl.org/SDL3/SDL_sqrt)
fn C.SDL_sqrt(x f64) f64

// sqrt computes the square root of `x`.
//
// Domain: `0 <= x <= INF`
//
// Range: `0 <= y <= INF`
//
// This function operates on double-precision floating point values, use
// SDL_sqrtf for single-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value. Must be greater than or equal to 0.
// returns square root of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: sqrtf (SDL_sqrtf)
pub fn sqrt(x f64) f64 {
	return C.SDL_sqrt(x)
}

// C.SDL_sqrtf [official documentation](https://wiki.libsdl.org/SDL3/SDL_sqrtf)
fn C.SDL_sqrtf(x f32) f32

// sqrtf computes the square root of `x`.
//
// Domain: `0 <= x <= INF`
//
// Range: `0 <= y <= INF`
//
// This function operates on single-precision floating point values, use
// SDL_sqrt for double-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value. Must be greater than or equal to 0.
// returns square root of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: sqrt (SDL_sqrt)
pub fn sqrtf(x f32) f32 {
	return C.SDL_sqrtf(x)
}

// C.SDL_tan [official documentation](https://wiki.libsdl.org/SDL3/SDL_tan)
fn C.SDL_tan(x f64) f64

// tan computes the tangent of `x`.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-INF <= y <= INF`
//
// This function operates on double-precision floating point values, use
// SDL_tanf for single-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value, in radians.
// returns tangent of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: tanf (SDL_tanf)
// See also: sin (SDL_sin)
// See also: cos (SDL_cos)
// See also: atan (SDL_atan)
// See also: atan2 (SDL_atan2)
pub fn tan(x f64) f64 {
	return C.SDL_tan(x)
}

// C.SDL_tanf [official documentation](https://wiki.libsdl.org/SDL3/SDL_tanf)
fn C.SDL_tanf(x f32) f32

// tanf computes the tangent of `x`.
//
// Domain: `-INF <= x <= INF`
//
// Range: `-INF <= y <= INF`
//
// This function operates on single-precision floating point values, use
// SDL_tanf for double-precision floats.
//
// This function may use a different approximation across different versions,
// platforms and configurations. i.e, it can return a different value given
// the same input on different machines or operating systems, or if SDL is
// updated.
//
// `x` x floating point value, in radians.
// returns tangent of `x`.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: tan (SDL_tan)
// See also: sinf (SDL_sinf)
// See also: cosf (SDL_cosf)
// See also: atanf (SDL_atanf)
// See also: atan2f (SDL_atan2f)
pub fn tanf(x f32) f32 {
	return C.SDL_tanf(x)
}

@[typedef]
pub struct C.SDL_iconv_t {}

pub type IconvT = C.SDL_iconv_t

// @[typedef]
// pub struct C.SDL_iconv_data_t {}

// pub type IconvDataT = C.SDL_iconv_data_t

// C.SDL_iconv_open [official documentation](https://wiki.libsdl.org/SDL3/SDL_iconv_open)
fn C.SDL_iconv_open(const_tocode &char, const_fromcode &char) IconvT

// iconv_open this function allocates a context for the specified character set
// conversion.
//
// `tocode` tocode The target character encoding, must not be NULL.
// `fromcode` fromcode The source character encoding, must not be NULL.
// returns a handle that must be freed with SDL_iconv_close, or
//          SDL_ICONV_ERROR on failure.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: iconv (SDL_iconv)
// See also: iconv_close (SDL_iconv_close)
// See also: iconv_string (SDL_iconv_string)
pub fn iconv_open(const_tocode &char, const_fromcode &char) IconvT {
	return C.SDL_iconv_open(const_tocode, const_fromcode)
}

// C.SDL_iconv_close [official documentation](https://wiki.libsdl.org/SDL3/SDL_iconv_close)
fn C.SDL_iconv_close(cd IconvT) int

// iconv_close this function frees a context used for character set conversion.
//
// `cd` cd The character set conversion handle.
// returns 0 on success, or -1 on failure.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: iconv (SDL_iconv)
// See also: iconv_open (SDL_iconv_open)
// See also: iconv_string (SDL_iconv_string)
pub fn iconv_close(cd IconvT) int {
	return C.SDL_iconv_close(cd)
}

// C.SDL_iconv [official documentation](https://wiki.libsdl.org/SDL3/SDL_iconv)
fn C.SDL_iconv(cd IconvT, const_inbuf &&char, inbytesleft &usize, outbuf &&char, outbytesleft &usize) usize

// iconv this function converts text between encodings, reading from and writing to
// a buffer.
//
// It returns the number of succesful conversions on success. On error,
// SDL_ICONV_E2BIG is returned when the output buffer is too small, or
// SDL_ICONV_EILSEQ is returned when an invalid input sequence is encountered,
// or SDL_ICONV_EINVAL is returned when an incomplete input sequence is
// encountered.
//
// On exit:
//
// - inbuf will point to the beginning of the next multibyte sequence. On
//   error, this is the location of the problematic input sequence. On
//   success, this is the end of the input sequence.
// - inbytesleft will be set to the number of bytes left to convert, which
//   will be 0 on success.
// - outbuf will point to the location where to store the next output byte.
// - outbytesleft will be set to the number of bytes left in the output
//   buffer.
//
// `cd` cd The character set conversion context, created in
//           SDL_iconv_open().
// `inbuf` inbuf Address of variable that points to the first character of the
//              input sequence.
// `inbytesleft` inbytesleft The number of bytes in the input buffer.
// `outbuf` outbuf Address of variable that points to the output buffer.
// `outbytesleft` outbytesleft The number of bytes in the output buffer.
// returns the number of conversions on success, or a negative error code.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: iconv_open (SDL_iconv_open)
// See also: iconv_close (SDL_iconv_close)
// See also: iconv_string (SDL_iconv_string)
pub fn iconv(cd IconvT, const_inbuf &&char, inbytesleft &usize, outbuf &&char, outbytesleft &usize) usize {
	return C.SDL_iconv(cd, const_inbuf, inbytesleft, outbuf, outbytesleft)
}

pub const iconv_error = C.SDL_ICONV_ERROR // (size_t)-1

pub const iconv_e2big = C.SDL_ICONV_E2BIG // (size_t)-2

pub const iconv_eilseq = C.SDL_ICONV_EILSEQ // (size_t)-3

pub const iconv_einval = C.SDL_ICONV_EINVAL // (size_t)-4

// C.SDL_iconv_string [official documentation](https://wiki.libsdl.org/SDL3/SDL_iconv_string)
fn C.SDL_iconv_string(const_tocode &char, const_fromcode &char, const_inbuf &char, inbytesleft usize) &char

// iconv_string helpers function to convert a string's encoding in one call.
//
// This function converts a buffer or string between encodings in one pass.
//
// The string does not need to be NULL-terminated; this function operates on
// the number of bytes specified in `inbytesleft` whether there is a NULL
// character anywhere in the buffer.
//
// The returned string is owned by the caller, and should be passed to
// SDL_free when no longer needed.
//
// `tocode` tocode the character encoding of the output string. Examples are
//               "UTF-8", "UCS-4", etc.
// `fromcode` fromcode the character encoding of data in `inbuf`.
// `inbuf` inbuf the string to convert to a different encoding.
// `inbytesleft` inbytesleft the size of the input string _in bytes_.
// returns a new string, converted to the new encoding, or NULL on error.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: iconv_open (SDL_iconv_open)
// See also: iconv_close (SDL_iconv_close)
// See also: iconv (SDL_iconv)
pub fn iconv_string(const_tocode &char, const_fromcode &char, const_inbuf &char, inbytesleft usize) &char {
	return &char(C.SDL_iconv_string(const_tocode, const_fromcode, const_inbuf, inbytesleft))
}

// Convert a UTF-8 string to the current locale's character encoding.
//
// This is a helper macro that might be more clear than calling
// SDL_iconv_string directly. However, it double-evaluates its parameter, so
// do not use an expression with side-effects here.
//
// `s` S the string to convert.
// returns a new string, converted to the new encoding, or NULL on error.
//
// NOTE: This macro is available since SDL 3.2.0.
// TODO: pub const iconv_utf8_locale(s) = SDL_iconv_string('', 'UTF-8', S, SDL_strlen(S)+1)

// Convert a UTF-8 string to UCS-2.
//
// This is a helper macro that might be more clear than calling
// SDL_iconv_string directly. However, it double-evaluates its parameter, so
// do not use an expression with side-effects here.
//
// `s` S the string to convert.
// returns a new string, converted to the new encoding, or NULL on error.
//
// NOTE: This macro is available since SDL 3.2.0.
// TODO: pub const iconv_utf8_ucs2(s) = (Uint16 *)SDL_iconv_string('UCS-2', 'UTF-8', S, SDL_strlen(S)+1)

// Convert a UTF-8 string to UCS-4.
//
// This is a helper macro that might be more clear than calling
// SDL_iconv_string directly. However, it double-evaluates its parameter, so
// do not use an expression with side-effects here.
//
// `s` S the string to convert.
// returns a new string, converted to the new encoding, or NULL on error.
//
// NOTE: This macro is available since SDL 3.2.0.
// TODO: pub const iconv_utf8_ucs4(s) = (Uint32 *)SDL_iconv_string('UCS-4', 'UTF-8', S, SDL_strlen(S)+1)

// Convert a wchar_t string to UTF-8.
//
// This is a helper macro that might be more clear than calling
// SDL_iconv_string directly. However, it double-evaluates its parameter, so
// do not use an expression with side-effects here.
//
// `s` S the string to convert.
// returns a new string, converted to the new encoding, or NULL on error.
//
// NOTE: This macro is available since SDL 3.2.0.
// TODO: pub const iconv_wchar_utf8(s) = SDL_iconv_string('UTF-8', 'WCHAR_T', (char *)S, (SDL_wcslen(S)+1)*sizeof(wchar_t))

// TODO: Function: #define SDL_size_mul_check_overflow(a, b, ret) SDL_size_mul_check_overflow_builtin(a, b, ret)

// TODO: Function: #define SDL_size_add_check_overflow(a, b, ret) SDL_size_add_check_overflow_builtin(a, b, ret)

// FunctionPointer as generic function pointer.
//
// In theory, generic function pointers should use this, instead of `void *`,
// since some platforms could treat code addresses differently than data
// addresses. Although in current times no popular platforms make this
// distinction, it is more correct and portable to use the correct type for a
// generic pointer.
//
// If for some reason you need to force this typedef to be an actual `void *`,
// perhaps to work around a compiler or existing code, you can define
// `SDL_FUNCTION_POINTER_IS_VOID_POINTER` before including any SDL headers.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_FunctionPointer)
pub type FunctionPointer = fn ()
