module c

// When the Boehm collector is used, it is better to replace SDL's memory allocation functions, with versions
// that Boehm will later know how to process. The callbacks here provide such versions:
fn cb_malloc_func(size usize) voidptr {
	mut res := unsafe { nil }
	$if sdl_memory_no_gc ? {
		res = unsafe { C.malloc(size) }
	} $else {
		res = unsafe { malloc(int(size)) }
	}
	$if trace_sdl_memory ? {
		C.fprintf(C.stderr, c'>> sdl.c.cb_malloc_func | size: %lu | => %p\n', size, res)
	}
	return res
}

fn cb_calloc_func(nmemb usize, size usize) voidptr {
	mut res := unsafe { nil }
	$if sdl_memory_no_gc ? {
		res = unsafe { C.calloc(int(nmemb), int(size)) }
	} $else {
		res = unsafe { vcalloc(isize(nmemb) * isize(size)) }
	}
	$if trace_sdl_memory ? {
		C.fprintf(C.stderr, c'>> sdl.c.cb_calloc_func | nmemb: %lu | size: %lu | => %p\n',
			nmemb, size, res)
	}
	return res
}

fn cb_realloc_func(mem voidptr, size usize) voidptr {
	mut res := unsafe { nil }
	$if sdl_memory_no_gc ? {
		res = unsafe { C.realloc(&u8(mem), int(size)) }
	} $else {
		res = unsafe { v_realloc(&u8(mem), isize(size)) }
	}
	$if trace_sdl_memory ? {
		C.fprintf(C.stderr, c'>> sdl.c.cb_realloc_func | mem: %p | size: %lu | => %p\n',
			mem, size, res)
	}
	return res
}

fn cb_free_func(mem voidptr) {
	$if trace_sdl_memory ? {
		C.fprintf(C.stderr, c'>> sdl.c.cb_free_func | mem: %p\n', mem)
	}
	$if sdl_memory_no_gc ? {
		unsafe { C.free(mem) }
	} $else {
		unsafe { free(mem) }
	}
}

pub type MallocFunc = fn (size usize) voidptr // fn(size usize) voidptr

pub type CallocFunc = fn (nmemb usize, size usize) voidptr // fn(nmemb usize, size usize) voidptr

pub type ReallocFunc = fn (mem voidptr, size usize) voidptr // fn(mem voidptr, size usize) voidptr

pub type FreeFunc = fn (mem voidptr) // fn(mem voidptr)

fn C.SDL_SetMemoryFunctions(malloc_func MallocFunc, calloc_func CallocFunc, realloc_func ReallocFunc, free_func FreeFunc) int
fn C.SDL_GetNumAllocations() int

fn init() {
	// TODO move to `@[if !sdl_no_init ?]` when supported
	$if !sdl_no_init ? {
		prev_allocations := C.SDL_GetNumAllocations()
		if prev_allocations > 0 {
			eprintln('SDL memory allocation functions should have been replaced with the V ones, but vsdl found, that you did already ${prev_allocations} allocations.')
			return
		}
		replaced := C.SDL_SetMemoryFunctions(cb_malloc_func, cb_calloc_func, cb_realloc_func,
			cb_free_func)
		if replaced != 0 {
			eprintln('SDL memory allocation functions were not replaced.')
		}
	}
}
