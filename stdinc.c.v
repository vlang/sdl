// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_stdinc.h
//

// Basic data types

pub const (
	// A signed 8-bit integer type.
	// typedef int8_t Sint8;
	// i8
	max_sint8  = C.SDL_MAX_SINT8 // 127
	min_sint8  = C.SDL_MIN_SINT8 // -128
	// An unsigned 8-bit integer type.
	// typedef uint8_t Uint8;
	// byte
	max_uint8  = C.SDL_MAX_UINT8 // 255
	min_uint8  = C.SDL_MIN_UINT8 // 0
	// A signed 16-bit integer type.
	// typedef int16_t Sint16;
	// i16
	max_sint16 = C.SDL_MAX_SINT16 // 32767
	min_sint16 = C.SDL_MIN_SINT16 // -32768
	// An unsigned 16-bit integer type.
	// typedef uint16_t Uint16;
	// u16
	max_uint16 = C.SDL_MAX_UINT16 // 65535
	min_uint16 = C.SDL_MIN_UINT16 // 0
	// A signed 32-bit integer type.
	// typedef int32_t Sint32;
	// int
	max_sint32 = C.SDL_MAX_SINT32 // 2147483647
	min_sint32 = C.SDL_MIN_SINT32 // -2147483648
	// An unsigned 32-bit integer type.
	// typedef uint32_t Uint32;
	// u32
	max_uint32 = C.SDL_MAX_UINT32 // 4294967295
	min_uint32 = C.SDL_MIN_UINT32 // 0
	// A signed 64-bit integer type.
	// typedef int64_t Sint64;
	// i64
	max_sint64 = C.SDL_MAX_SINT64 // 9223372036854775807
	min_sint64 = C.SDL_MIN_SINT64 // -9223372036854775808
	// An unsigned 64-bit integer type.
	// typedef uint64_t Uint64;
	// u64
	max_uint64 = C.SDL_MAX_UINT64 // 18446744073709551615
	min_uint64 = C.SDL_MIN_UINT64 // 0
)

/*
// bool
pub enum C.SDL_bool {
	false = 0 //0
	true = 1 //1
}
*/

fn C.SDL_malloc(size usize) voidptr
pub fn malloc(size usize) voidptr {
	return C.SDL_malloc(size)
}

fn C.SDL_calloc(nmemb usize, size usize) voidptr
pub fn calloc(nmemb usize, size usize) voidptr {
	return C.SDL_calloc(nmemb, size)
}

fn C.SDL_realloc(mem voidptr, size usize) voidptr
pub fn realloc(mem voidptr, size usize) voidptr {
	return C.SDL_realloc(mem, size)
}

fn C.SDL_free(mem voidptr)
pub fn free(mem voidptr) {
	C.SDL_free(mem)
}

/*
// TODO
// typedef void *(SDLCALL *SDL_malloc_func)(size_t size);
fn C.SDL_malloc_func(size usize) voidptr
//typedef void *(SDLCALL *SDL_calloc_func)(size_t nmemb, size_t size);
fn C.SDL_calloc_func(nmemb usize, size usize) voidptr
//typedef void *(SDLCALL *SDL_realloc_func)(void *mem, size_t size);
fn C.SDL_realloc_func(mem voidptr, size usize) voidptr
//typedef void (SDLCALL *SDL_free_func)(void *mem);
fn C.SDL_free_func(mem voidptr)

pub type MallocFunc = C.SDL_malloc_func // fn(size usize) voidptr
pub type CallocFunc = C.SDL_calloc_func // fn(nmemb usize, size usize) voidptr
pub type ReallocFunc = C.SDL_realloc_func // fn(mem voidptr, size usize) voidptr
pub type FreeFunc = C.SDL_free_func //fn(mem voidptr)

fn C.SDL_GetMemoryFunctions(malloc_func &C.SDL_malloc_func, calloc_func &C.SDL_calloc_func, realloc_func &C.SDL_realloc_func, free_func &C.SDL_free_func)

// get_memory_functions gets the current set of SDL memory functions
pub fn get_memory_functions(malloc_func &MallocFunc, calloc_func &CallocFunc, realloc_func &ReallocFunc, free_func &FreeFunc){
	 C.SDL_GetMemoryFunctions(malloc_func, calloc_func, realloc_func, free_func)
}

fn C.SDL_SetMemoryFunctions(malloc_func C.SDL_malloc_func, calloc_func C.SDL_calloc_func, realloc_func C.SDL_realloc_func, free_func C.SDL_free_func) int

// set_memory_functions replaces SDL's memory allocation functions with a custom set
//
// NOTE If you are replacing SDL's memory functions, you should call
//      SDL_GetNumAllocations() and be very careful if it returns non-zero.
//      That means that your free function will be called with memory
//      allocated by the previous memory allocation functions.
pub fn set_memory_functions(malloc_func MallocFunc, calloc_func CallocFunc, realloc_func ReallocFunc, free_func FreeFunc) int{
	return C.SDL_SetMemoryFunctions(malloc_func, calloc_func, realloc_func, free_func)
}
*/

// get_num_allocations gets the number of outstanding (unfreed) allocations
fn C.SDL_GetNumAllocations() int
pub fn get_num_allocations() int {
	return C.SDL_GetNumAllocations()
}

fn C.SDL_getenv(name &char) &char
pub fn getenv(name string) &char {
	return C.SDL_getenv(name.str)
}

fn C.SDL_setenv(name &char, value &char, overwrite int) int
pub fn setenv(name string, value string, overwrite int) int {
	return C.SDL_setenv(name.str, value.str, overwrite)
}

// int (*compare) (const void *, const void *)
pub type QSortCompare = fn (voidptr, voidptr) int

fn C.SDL_qsort(base voidptr, nmemb usize, size usize, compare QSortCompare)
pub fn qsort(base voidptr, nmemb usize, size usize, compare QSortCompare) {
	C.SDL_qsort(base, nmemb, size, compare)
}

fn C.SDL_abs(x int) int
pub fn abs(x int) int {
	return C.SDL_abs(x)
}

fn C.SDL_isdigit(x int) int
pub fn isdigit(x int) int {
	return C.SDL_isdigit(x)
}

fn C.SDL_isspace(x int) int
pub fn isspace(x int) int {
	return C.SDL_isspace(x)
}

fn C.SDL_toupper(x int) int
pub fn toupper(x int) int {
	return C.SDL_toupper(x)
}

fn C.SDL_tolower(x int) int
pub fn tolower(x int) int {
	return C.SDL_tolower(x)
}

/*
// TODO
// extern DECLSPEC void *SDLCALL SDL_memset(SDL_OUT_BYTECAP(len) void *dst, int c, size_t len)
fn C.SDL_memset(dst &C.SDL_OUT_BYTECAP(len) void, c int, len usize) voidptr
pub fn memset(dst &C.SDL_OUT_BYTECAP(len) void, c int, len usize) voidptr{
	return C.SDL_memset(dst, c, len)
}
*/

/*
// TODO
// extern DECLSPEC void *SDLCALL SDL_memcpy(SDL_OUT_BYTECAP(len) void *dst, SDL_IN_BYTECAP(len) const void *src, size_t len)
fn C.SDL_memcpy(dst &C.SDL_OUT_BYTECAP(len) void, src &C.SDL_IN_BYTECAP(len)  void, len usize) voidptr
pub fn memcpy(dst &C.SDL_OUT_BYTECAP(len) void, src &C.SDL_IN_BYTECAP(len)  void, len usize) voidptr{
	return C.SDL_memcpy(dst, src, len)
}
*/

/*
// TODO
// extern DECLSPEC void *SDLCALL SDL_memmove(SDL_OUT_BYTECAP(len) void *dst, SDL_IN_BYTECAP(len) const void *src, size_t len)
fn C.SDL_memmove(dst &C.SDL_OUT_BYTECAP(len) void, src &C.SDL_IN_BYTECAP(len)  void, len usize) voidptr
pub fn memmove(dst &C.SDL_OUT_BYTECAP(len) void, src &C.SDL_IN_BYTECAP(len)  void, len usize) voidptr{
	return C.SDL_memmove(dst, src, len)
}
*/

fn C.SDL_memcmp(s1 voidptr, s2 voidptr, len usize) int
pub fn memcmp(s1 voidptr, s2 voidptr, len usize) int {
	return C.SDL_memcmp(s1, s2, len)
}

/*
// extern DECLSPEC size_t SDLCALL SDL_wcslen(const wchar_t *wstr)
fn C.SDL_wcslen(wstr &C.wchar_t) usize
pub fn wcslen(wstr &C.wchar_t) usize{
	return C.SDL_wcslen(wstr)
}

// extern DECLSPEC size_t SDLCALL SDL_wcslcpy(SDL_OUT_Z_CAP(maxlen) wchar_t *dst, const wchar_t *src, size_t maxlen)
fn C.SDL_wcslcpy(dst &C.SDL_OUT_Z_CAP(maxlen) wchar_t, src &C.wchar_t, maxlen usize) usize
pub fn wcslcpy(dst &C.SDL_OUT_Z_CAP(maxlen) wchar_t, src &C.wchar_t, maxlen usize) usize{
	return C.SDL_wcslcpy(dst, src, maxlen)
}

// extern DECLSPEC size_t SDLCALL SDL_wcslcat(SDL_INOUT_Z_CAP(maxlen) wchar_t *dst, const wchar_t *src, size_t maxlen)
fn C.SDL_wcslcat(dst &C.SDL_INOUT_Z_CAP(maxlen) wchar_t, src &C.wchar_t, maxlen usize) usize
pub fn wcslcat(dst &C.SDL_INOUT_Z_CAP(maxlen) wchar_t, src &C.wchar_t, maxlen usize) usize{
	return C.SDL_wcslcat(dst, src, maxlen)
}

// extern DECLSPEC int SDLCALL SDL_wcscmp(const wchar_t *str1, const wchar_t *str2)
fn C.SDL_wcscmp(str1 &C.wchar_t, str2 &C.wchar_t) int
pub fn wcscmp(str1 &C.wchar_t, str2 &C.wchar_t) int{
	return C.SDL_wcscmp(str1, str2)
}
*/

fn C.SDL_strlen(str &char) usize
pub fn strlen(str string) usize {
	return C.SDL_strlen(str.str)
}

/*
// TODO
// extern DECLSPEC size_t SDLCALL SDL_strlcpy(SDL_OUT_Z_CAP(maxlen) char *dst, const char *src, size_t maxlen)
fn C.SDL_strlcpy(dst &C.SDL_OUT_Z_CAP(maxlen) char, src &char, maxlen usize) usize
pub fn strlcpy(dst &C.SDL_OUT_Z_CAP(maxlen) char, src &char, maxlen usize) usize{
	return C.SDL_strlcpy(dst, src, maxlen)
}

// extern DECLSPEC size_t SDLCALL SDL_utf8strlcpy(SDL_OUT_Z_CAP(dst_bytes) char *dst, const char *src, size_t dst_bytes)
fn C.SDL_utf8strlcpy(dst &C.SDL_OUT_Z_CAP(dst_bytes) char, src &char, dst_bytes usize) usize
pub fn utf8strlcpy(dst &C.SDL_OUT_Z_CAP(dst_bytes) char, src &char, dst_bytes usize) usize{
	return C.SDL_utf8strlcpy(dst, src, dst_bytes)
}

// extern DECLSPEC size_t SDLCALL SDL_strlcat(SDL_INOUT_Z_CAP(maxlen) char *dst, const char *src, size_t maxlen)
fn C.SDL_strlcat(dst &C.SDL_INOUT_Z_CAP(maxlen) char, src &char, maxlen usize) usize
pub fn strlcat(dst &C.SDL_INOUT_Z_CAP(maxlen) char, src &char, maxlen usize) usize{
	return C.SDL_strlcat(dst, src, maxlen)
}
*/

fn C.SDL_strdup(str &char) &char
pub fn strdup(str string) &char {
	return C.SDL_strdup(str.str)
}

fn C.SDL_strrev(str &char) &char
pub fn strrev(str string) &char {
	return C.SDL_strrev(str.str)
}

fn C.SDL_strupr(str &char) &char
pub fn strupr(str string) &char {
	return C.SDL_strupr(str.str)
}

fn C.SDL_strlwr(str &char) &char
pub fn strlwr(str string) &char {
	return C.SDL_strlwr(str.str)
}

fn C.SDL_strchr(str &char, c int) &char
pub fn strchr(str string, c int) &char {
	return C.SDL_strchr(str.str, c)
}

fn C.SDL_strrchr(str &char, c int) &char
pub fn strrchr(str string, c int) &char {
	return C.SDL_strrchr(str.str, c)
}

fn C.SDL_strstr(haystack &char, needle &char) &char
pub fn strstr(haystack string, needle string) &char {
	return C.SDL_strstr(haystack.str, needle.str)
}

fn C.SDL_utf8strlen(str &char) usize
pub fn utf8strlen(str string) usize {
	return C.SDL_utf8strlen(str.str)
}

fn C.SDL_itoa(value int, str &char, radix int) &char
pub fn itoa(value int, str string, radix int) &char {
	return C.SDL_itoa(value, str.str, radix)
}

fn C.SDL_uitoa(value u32, str &char, radix int) &char
pub fn uitoa(value u32, str string, radix int) &char {
	return C.SDL_uitoa(value, str.str, radix)
}

fn C.SDL_ltoa(value int, str &char, radix int) &char
pub fn ltoa(value int, str string, radix int) &char {
	return C.SDL_ltoa(value, str.str, radix)
}

fn C.SDL_ultoa(value u32, str &char, radix int) &char
pub fn ultoa(value u32, str string, radix int) &char {
	return C.SDL_ultoa(value, str.str, radix)
}

fn C.SDL_lltoa(value C.Sint64, str &char, radix int) &char
pub fn lltoa(value C.Sint64, str string, radix int) &char {
	return C.SDL_lltoa(value, str.str, radix)
}

fn C.SDL_ulltoa(value u64, str &char, radix int) &char
pub fn ulltoa(value u64, str string, radix int) &char {
	return C.SDL_ulltoa(value, str.str, radix)
}

fn C.SDL_atoi(str &char) int
pub fn atoi(str string) int {
	return C.SDL_atoi(str.str)
}

fn C.SDL_atof(str &char) f64
pub fn atof(str string) f64 {
	return C.SDL_atof(str.str)
}

fn C.SDL_strtol(str &char, endp &&char, base int) int
pub fn strtol(str string, endp &&char, base int) int {
	return C.SDL_strtol(str.str, endp, base)
}

fn C.SDL_strtoul(str &char, endp &&char, base int) u32
pub fn strtoul(str string, endp &&char, base int) u32 {
	return C.SDL_strtoul(str.str, endp, base)
}

fn C.SDL_strtoll(str &char, endp &&char, base int) C.Sint64
pub fn strtoll(str string, endp &&char, base int) C.Sint64 {
	return C.SDL_strtoll(str.str, endp, base)
}

fn C.SDL_strtoull(str &char, endp &&char, base int) u64
pub fn strtoull(str string, endp &&char, base int) u64 {
	return C.SDL_strtoull(str.str, endp, base)
}

fn C.SDL_strtod(str &char, endp &&char) f64
pub fn strtod(str string, endp &&char) f64 {
	return C.SDL_strtod(str.str, endp)
}

fn C.SDL_strcmp(str1 &char, str2 &char) int
pub fn strcmp(str1 string, str2 string) int {
	return C.SDL_strcmp(str1.str, str2.str)
}

fn C.SDL_strncmp(str1 &char, str2 &char, maxlen usize) int
pub fn strncmp(str1 string, str2 string, maxlen usize) int {
	return C.SDL_strncmp(str1.str, str2.str, maxlen)
}

fn C.SDL_strcasecmp(str1 &char, str2 &char) int
pub fn strcasecmp(str1 string, str2 string) int {
	return C.SDL_strcasecmp(str1.str, str2.str)
}

fn C.SDL_strncasecmp(str1 &char, str2 &char, len usize) int
pub fn strncasecmp(str1 string, str2 string, len usize) int {
	return C.SDL_strncasecmp(str1.str, str2.str, len)
}

// Skipped:
/*
extern DECLSPEC int SDLCALL SDL_sscanf(const char *text, SDL_SCANF_FORMAT_STRING const char *fmt, ...) SDL_SCANF_VARARG_FUNC(2);
*/

fn C.SDL_vsscanf(text &char, fmt &char, ap C.va_list) int
pub fn vsscanf(text string, fmt string, ap C.va_list) int {
	return C.SDL_vsscanf(text.str, fmt.str, ap)
}

// Skipped:
/*
extern DECLSPEC int SDLCALL SDL_snprintf(SDL_OUT_Z_CAP(maxlen) char *text, size_t maxlen, SDL_PRINTF_FORMAT_STRING const char *fmt, ... ) SDL_PRINTF_VARARG_FUNC(3);
*/

/*
// TODO
// extern DECLSPEC int SDLCALL SDL_vsnprintf(SDL_OUT_Z_CAP(maxlen) char *text, size_t maxlen, const char *fmt, va_list ap)
fn C.SDL_vsnprintf(text &C.SDL_OUT_Z_CAP(maxlen) char, maxlen usize, fmt &char, ap C.va_list) int
pub fn vsnprintf(text &C.SDL_OUT_Z_CAP(maxlen) char, maxlen usize, fmt &char, ap C.va_list) int{
	return C.SDL_vsnprintf(text, maxlen, fmt, ap)
}
*/

pub const (
	m_pi = C.M_PI // 3.14159265358979323846264338327950288 // pi
)

fn C.SDL_acos(x f64) f64
pub fn acos(x f64) f64 {
	return C.SDL_acos(x)
}

fn C.SDL_acosf(x f32) f32
pub fn acosf(x f32) f32 {
	return C.SDL_acosf(x)
}

fn C.SDL_asin(x f64) f64
pub fn asin(x f64) f64 {
	return C.SDL_asin(x)
}

fn C.SDL_asinf(x f32) f32
pub fn asinf(x f32) f32 {
	return C.SDL_asinf(x)
}

fn C.SDL_atan(x f64) f64
pub fn atan(x f64) f64 {
	return C.SDL_atan(x)
}

fn C.SDL_atanf(x f32) f32
pub fn atanf(x f32) f32 {
	return C.SDL_atanf(x)
}

fn C.SDL_atan2(x f64, y f64) f64
pub fn atan2(x f64, y f64) f64 {
	return C.SDL_atan2(x, y)
}

fn C.SDL_atan2f(x f32, y f32) f32
pub fn atan2f(x f32, y f32) f32 {
	return C.SDL_atan2f(x, y)
}

fn C.SDL_ceil(x f64) f64
pub fn ceil(x f64) f64 {
	return C.SDL_ceil(x)
}

fn C.SDL_ceilf(x f32) f32
pub fn ceilf(x f32) f32 {
	return C.SDL_ceilf(x)
}

fn C.SDL_copysign(x f64, y f64) f64
pub fn copysign(x f64, y f64) f64 {
	return C.SDL_copysign(x, y)
}

fn C.SDL_copysignf(x f32, y f32) f32
pub fn copysignf(x f32, y f32) f32 {
	return C.SDL_copysignf(x, y)
}

fn C.SDL_cos(x f64) f64
pub fn cos(x f64) f64 {
	return C.SDL_cos(x)
}

fn C.SDL_cosf(x f32) f32
pub fn cosf(x f32) f32 {
	return C.SDL_cosf(x)
}

fn C.SDL_fabs(x f64) f64
pub fn fabs(x f64) f64 {
	return C.SDL_fabs(x)
}

fn C.SDL_fabsf(x f32) f32
pub fn fabsf(x f32) f32 {
	return C.SDL_fabsf(x)
}

fn C.SDL_floor(x f64) f64
pub fn floor(x f64) f64 {
	return C.SDL_floor(x)
}

fn C.SDL_floorf(x f32) f32
pub fn floorf(x f32) f32 {
	return C.SDL_floorf(x)
}

fn C.SDL_fmod(x f64, y f64) f64
pub fn fmod(x f64, y f64) f64 {
	return C.SDL_fmod(x, y)
}

fn C.SDL_fmodf(x f32, y f32) f32
pub fn fmodf(x f32, y f32) f32 {
	return C.SDL_fmodf(x, y)
}

fn C.SDL_log(x f64) f64
pub fn log(x f64) f64 {
	return C.SDL_log(x)
}

fn C.SDL_logf(x f32) f32
pub fn logf(x f32) f32 {
	return C.SDL_logf(x)
}

fn C.SDL_log10(x f64) f64
pub fn log10(x f64) f64 {
	return C.SDL_log10(x)
}

fn C.SDL_log10f(x f32) f32
pub fn log10f(x f32) f32 {
	return C.SDL_log10f(x)
}

fn C.SDL_pow(x f64, y f64) f64
pub fn pow(x f64, y f64) f64 {
	return C.SDL_pow(x, y)
}

fn C.SDL_powf(x f32, y f32) f32
pub fn powf(x f32, y f32) f32 {
	return C.SDL_powf(x, y)
}

fn C.SDL_scalbn(x f64, n int) f64
pub fn scalbn(x f64, n int) f64 {
	return C.SDL_scalbn(x, n)
}

fn C.SDL_scalbnf(x f32, n int) f32
pub fn scalbnf(x f32, n int) f32 {
	return C.SDL_scalbnf(x, n)
}

fn C.SDL_sin(x f64) f64
pub fn sin(x f64) f64 {
	return C.SDL_sin(x)
}

fn C.SDL_sinf(x f32) f32
pub fn sinf(x f32) f32 {
	return C.SDL_sinf(x)
}

fn C.SDL_sqrt(x f64) f64
pub fn sqrt(x f64) f64 {
	return C.SDL_sqrt(x)
}

fn C.SDL_sqrtf(x f32) f32
pub fn sqrtf(x f32) f32 {
	return C.SDL_sqrtf(x)
}

fn C.SDL_tan(x f64) f64
pub fn tan(x f64) f64 {
	return C.SDL_tan(x)
}

fn C.SDL_tanf(x f32) f32
pub fn tanf(x f32) f32 {
	return C.SDL_tanf(x)
}

pub const (
	// The SDL implementation of iconv() returns these error codes
	iconv_error  = C.SDL_ICONV_ERROR // (size_t)-1
	iconv_e2big  = C.SDL_ICONV_E2BIG // (size_t)-2
	iconv_eilseq = C.SDL_ICONV_EILSEQ // (size_t)-3
	iconv_einval = C.SDL_ICONV_EINVAL // (size_t)-4
)

// SDL_iconv_* are now always real symbols/types, not macros or inlined.
// typedef struct _SDL_iconv_t *SDL_iconv_t;
[typedef]
struct C.SDL_iconv_t {
}

pub type IconvT = C.SDL_iconv_t

fn C.SDL_iconv_open(tocode &char, fromcode &char) C.SDL_iconv_t
pub fn iconv_open(tocode &char, fromcode &char) IconvT {
	return C.SDL_iconv_open(tocode, fromcode)
}

fn C.SDL_iconv_close(cd C.SDL_iconv_t) int
pub fn iconv_close(cd C.SDL_iconv_t) int {
	return C.SDL_iconv_close(cd)
}

fn C.SDL_iconv(cd C.SDL_iconv_t, inbuf &&char, inbytesleft &usize, outbuf &&char, outbytesleft &usize) usize
pub fn iconv(cd C.SDL_iconv_t, inbuf &&char, inbytesleft &usize, outbuf &&char, outbytesleft &usize) usize {
	return C.SDL_iconv(cd, inbuf, inbytesleft, outbuf, outbytesleft)
}

fn C.SDL_iconv_string(tocode &char, fromcode &char, inbuf &char, inbytesleft usize) &char

// This function converts a string between encodings in one pass, returning a
// string that must be freed with SDL_free() or NULL on error.
pub fn iconv_string(tocode &char, fromcode &char, inbuf &char, inbytesleft usize) &char {
	return C.SDL_iconv_string(tocode, fromcode, inbuf, inbytesleft)
}

fn C.SDL_iconv_utf8_locale(inbuf &char) &char
fn C.SDL_iconv_utf8_ucs2(inbuf &char) &char
fn C.SDL_iconv_utf8_ucs4(inbuf &char) &char
