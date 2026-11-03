module sdl

fn compare_i32(a voidptr, b voidptr) i32 {
	return unsafe { *(&i32(a)) - *(&i32(b)) }
}

fn thread_status(data voidptr) i32 {
	return unsafe { *(&i32(data)) }
}

fn log_category(data voidptr, category i32, _ LogPriority, _ &char) {
	unsafe { *(&i32(data)) = category }
}

fn test_qsort_callback_uses_c_int() {
	mut values := [i32(3), -2, 1]!
	qsort(&values[0], uint(values.len), uint(sizeof(i32)), compare_i32)
	assert values == [i32(-2), 1, 3]!
}

fn test_bsearch_callback_uses_c_int() {
	values := [i32(-2), 1, 3]!
	key := i32(1)
	result := unsafe { bsearch(&key, &values[0], uint(values.len), uint(sizeof(i32)), compare_i32) }
	assert result == unsafe { voidptr(&values[1]) }
}

fn test_thread_callback_uses_c_int() {
	value := i32(-42)
	handle := create_thread(thread_status, c'callback-test', unsafe { &value })
	assert !isnil(handle)
	mut status := 0
	wait_thread(handle, &status)
	assert status == -42
}

fn test_wait_null_thread_preserves_status() {
	mut status := 42
	wait_thread(unsafe { nil }, &status)
	assert status == 42
}

fn C.SDL_LogMessage(category i32, priority LogPriority, message &char, ...voidptr)

fn test_log_callback_uses_c_int() {
	mut category := i32(0)
	mut old_callback := LogOutputFunction(unsafe { nil })
	mut old_data := unsafe { nil }
	log_get_output_function(&old_callback, &old_data)
	log_set_output_function(log_category, &category)
	defer { log_set_output_function(old_callback, old_data) }
	C.SDL_LogMessage(3, .critical, c'callback-test')
	assert category == 3
}
