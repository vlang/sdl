// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_process.h
//

// Process control support.
//
// These functions provide a cross-platform way to spawn and manage OS-level
// processes.
//
// You can create a new subprocess with SDL_CreateProcess() and optionally
// read and write to it using SDL_ReadProcess() or SDL_GetProcessInput() and
// SDL_GetProcessOutput(). If more advanced functionality like chaining input
// between processes is necessary, you can use
// SDL_CreateProcessWithProperties().
//
// You can get the status of a created process with SDL_WaitProcess(), or
// terminate the process with SDL_KillProcess().
//
// Don't forget to call SDL_DestroyProcess() to clean up, whether the process
// process was killed, terminated on its own, or is still running!

@[noinit; typedef]
pub struct C.SDL_Process {
	// NOTE: Opaque type
}

pub type Process = C.SDL_Process

// C.SDL_CreateProcess [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateProcess)
fn C.SDL_CreateProcess(const_args &&char, pipe_stdio bool) &Process

// create_process creates a new process.
//
// The path to the executable is supplied in args[0]. args[1..N] are
// additional arguments passed on the command line of the new process, and the
// argument list should be terminated with a NULL, e.g.:
//
// ```c
// const char *args[] = { "myprogram", "argument", NULL };
// ```
//
// Setting pipe_stdio to true is equivalent to setting
// `SDL_PROP_PROCESS_CREATE_STDIN_NUMBER` and
// `SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER` to `SDL_PROCESS_STDIO_APP`, and
// will allow the use of SDL_ReadProcess() or SDL_GetProcessInput() and
// SDL_GetProcessOutput().
//
// See SDL_CreateProcessWithProperties() for more details.
//
// `args` args the path and arguments for the new process.
// `pipe_stdio` pipe_stdio true to create pipes to the process's standard input and
//                   from the process's standard output, false for the process
//                   to have no input and inherit the application's standard
//                   output.
// returns the newly created and running process, or NULL if the process
//          couldn't be created.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_process_with_properties (SDL_CreateProcessWithProperties)
// See also: get_process_properties (SDL_GetProcessProperties)
// See also: read_process (SDL_ReadProcess)
// See also: get_process_input (SDL_GetProcessInput)
// See also: get_process_output (SDL_GetProcessOutput)
// See also: kill_process (SDL_KillProcess)
// See also: wait_process (SDL_WaitProcess)
// See also: destroy_process (SDL_DestroyProcess)
pub fn create_process(const_args &&char, pipe_stdio bool) &Process {
	return C.SDL_CreateProcess(const_args, pipe_stdio)
}

// ProcessIO is C.SDL_ProcessIO
pub enum ProcessIO {
	inherited = C.SDL_PROCESS_STDIO_INHERITED // `inherited` The I/O stream is inherited from the application.
	null      = C.SDL_PROCESS_STDIO_NULL      // `null` The I/O stream is ignored.
	app       = C.SDL_PROCESS_STDIO_APP       // `app` The I/O stream is connected to a new SDL_IOStream that the application can read or write
	redirect  = C.SDL_PROCESS_STDIO_REDIRECT  // `redirect` The I/O stream is redirected to an existing SDL_IOStream.
}

// C.SDL_CreateProcessWithProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateProcessWithProperties)
fn C.SDL_CreateProcessWithProperties(props PropertiesID) &Process

// create_process_with_properties creates a new process with the specified properties.
//
// These are the supported properties:
//
// - `SDL_PROP_PROCESS_CREATE_ARGS_POINTER`: an array of strings containing
//   the program to run, any arguments, and a NULL pointer, e.g. const char
//   *args[] = { "myprogram", "argument", NULL }. This is a required property.
// - `SDL_PROP_PROCESS_CREATE_ENVIRONMENT_POINTER`: an SDL_Environment
//   pointer. If this property is set, it will be the entire environment for
//   the process, otherwise the current environment is used.
// - `SDL_PROP_PROCESS_CREATE_STDIN_NUMBER`: an SDL_ProcessIO value describing
//   where standard input for the process comes from, defaults to
//   `SDL_PROCESS_STDIO_NULL`.
// - `SDL_PROP_PROCESS_CREATE_STDIN_POINTER`: an SDL_IOStream pointer used for
//   standard input when `SDL_PROP_PROCESS_CREATE_STDIN_NUMBER` is set to
//   `SDL_PROCESS_STDIO_REDIRECT`.
// - `SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER`: an SDL_ProcessIO value
//   describing where standard output for the process goes go, defaults to
//   `SDL_PROCESS_STDIO_INHERITED`.
// - `SDL_PROP_PROCESS_CREATE_STDOUT_POINTER`: an SDL_IOStream pointer used
//   for standard output when `SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER` is set
//   to `SDL_PROCESS_STDIO_REDIRECT`.
// - `SDL_PROP_PROCESS_CREATE_STDERR_NUMBER`: an SDL_ProcessIO value
//   describing where standard error for the process goes go, defaults to
//   `SDL_PROCESS_STDIO_INHERITED`.
// - `SDL_PROP_PROCESS_CREATE_STDERR_POINTER`: an SDL_IOStream pointer used
//   for standard error when `SDL_PROP_PROCESS_CREATE_STDERR_NUMBER` is set to
//   `SDL_PROCESS_STDIO_REDIRECT`.
// - `SDL_PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN`: true if the error
//   output of the process should be redirected into the standard output of
//   the process. This property has no effect if
//   `SDL_PROP_PROCESS_CREATE_STDERR_NUMBER` is set.
// - `SDL_PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN`: true if the process should
//   run in the background. In this case the default input and output is
//   `SDL_PROCESS_STDIO_NULL` and the exitcode of the process is not
//   available, and will always be 0.
//
// On POSIX platforms, wait() and waitpid(-1, ...) should not be called, and
// SIGCHLD should not be ignored or handled because those would prevent SDL
// from properly tracking the lifetime of the underlying process. You should
// use SDL_WaitProcess() instead.
//
// `props` props the properties to use.
// returns the newly created and running process, or NULL if the process
//          couldn't be created.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_process (SDL_CreateProcess)
// See also: get_process_properties (SDL_GetProcessProperties)
// See also: read_process (SDL_ReadProcess)
// See also: get_process_input (SDL_GetProcessInput)
// See also: get_process_output (SDL_GetProcessOutput)
// See also: kill_process (SDL_KillProcess)
// See also: wait_process (SDL_WaitProcess)
// See also: destroy_process (SDL_DestroyProcess)
pub fn create_process_with_properties(props PropertiesID) &Process {
	return C.SDL_CreateProcessWithProperties(props)
}

pub const prop_process_create_args_pointer = C.SDL_PROP_PROCESS_CREATE_ARGS_POINTER // 'SDL.process.create.args'

pub const prop_process_create_environment_pointer = C.SDL_PROP_PROCESS_CREATE_ENVIRONMENT_POINTER // 'SDL.process.create.environment'

pub const prop_process_create_stdin_number = C.SDL_PROP_PROCESS_CREATE_STDIN_NUMBER // 'SDL.process.create.stdin_option'

pub const prop_process_create_stdin_pointer = C.SDL_PROP_PROCESS_CREATE_STDIN_POINTER // 'SDL.process.create.stdin_source'

pub const prop_process_create_stdout_number = C.SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER // 'SDL.process.create.stdout_option'

pub const prop_process_create_stdout_pointer = C.SDL_PROP_PROCESS_CREATE_STDOUT_POINTER // 'SDL.process.create.stdout_source'

pub const prop_process_create_stderr_number = C.SDL_PROP_PROCESS_CREATE_STDERR_NUMBER // 'SDL.process.create.stderr_option'

pub const prop_process_create_stderr_pointer = C.SDL_PROP_PROCESS_CREATE_STDERR_POINTER // 'SDL.process.create.stderr_source'

pub const prop_process_create_stderr_to_stdout_boolean = C.SDL_PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN // 'SDL.process.create.stderr_to_stdout'

pub const prop_process_create_background_boolean = C.SDL_PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN // 'SDL.process.create.background'

// C.SDL_GetProcessProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetProcessProperties)
fn C.SDL_GetProcessProperties(process &Process) PropertiesID

// get_process_properties gets the properties associated with a process.
//
// The following read-only properties are provided by SDL:
//
// - `SDL_PROP_PROCESS_PID_NUMBER`: the process ID of the process.
// - `SDL_PROP_PROCESS_STDIN_POINTER`: an SDL_IOStream that can be used to
//   write input to the process, if it was created with
//   `SDL_PROP_PROCESS_CREATE_STDIN_NUMBER` set to `SDL_PROCESS_STDIO_APP`.
// - `SDL_PROP_PROCESS_STDOUT_POINTER`: a non-blocking SDL_IOStream that can
//   be used to read output from the process, if it was created with
//   `SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER` set to `SDL_PROCESS_STDIO_APP`.
// - `SDL_PROP_PROCESS_STDERR_POINTER`: a non-blocking SDL_IOStream that can
//   be used to read error output from the process, if it was created with
//   `SDL_PROP_PROCESS_CREATE_STDERR_NUMBER` set to `SDL_PROCESS_STDIO_APP`.
// - `SDL_PROP_PROCESS_BACKGROUND_BOOLEAN`: true if the process is running in
//   the background.
//
// `process` process the process to query.
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_process (SDL_CreateProcess)
// See also: create_process_with_properties (SDL_CreateProcessWithProperties)
pub fn get_process_properties(process &Process) PropertiesID {
	return C.SDL_GetProcessProperties(process)
}

pub const prop_process_pid_number = C.SDL_PROP_PROCESS_PID_NUMBER // 'SDL.process.pid'

pub const prop_process_stdin_pointer = C.SDL_PROP_PROCESS_STDIN_POINTER // 'SDL.process.stdin'

pub const prop_process_stdout_pointer = C.SDL_PROP_PROCESS_STDOUT_POINTER // 'SDL.process.stdout'

pub const prop_process_stderr_pointer = C.SDL_PROP_PROCESS_STDERR_POINTER // 'SDL.process.stderr'

pub const prop_process_background_boolean = C.SDL_PROP_PROCESS_BACKGROUND_BOOLEAN // 'SDL.process.background'

// C.SDL_ReadProcess [official documentation](https://wiki.libsdl.org/SDL3/SDL_ReadProcess)
fn C.SDL_ReadProcess(process &Process, datasize &usize, exitcode &int) voidptr

// read_process reads all the output from a process.
//
// If a process was created with I/O enabled, you can use this function to
// read the output. This function blocks until the process is complete,
// capturing all output, and providing the process exit code.
//
// The data is allocated with a zero byte at the end (null terminated) for
// convenience. This extra byte is not included in the value reported via
// `datasize`.
//
// The data should be freed with SDL_free().
//
// `process` process The process to read.
// `datasize` datasize a pointer filled in with the number of bytes read, may be
//                 NULL.
// `exitcode` exitcode a pointer filled in with the process exit code if the
//                 process has exited, may be NULL.
// returns the data or NULL on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_process (SDL_CreateProcess)
// See also: create_process_with_properties (SDL_CreateProcessWithProperties)
// See also: destroy_process (SDL_DestroyProcess)
pub fn read_process(process &Process, datasize &usize, exitcode &int) voidptr {
	return C.SDL_ReadProcess(process, datasize, exitcode)
}

// C.SDL_GetProcessInput [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetProcessInput)
fn C.SDL_GetProcessInput(process &Process) &IOStream

// get_process_input gets the SDL_IOStream associated with process standard input.
//
// The process must have been created with SDL_CreateProcess() and pipe_stdio
// set to true, or with SDL_CreateProcessWithProperties() and
// `SDL_PROP_PROCESS_CREATE_STDIN_NUMBER` set to `SDL_PROCESS_STDIO_APP`.
//
// Writing to this stream can return less data than expected if the process
// hasn't read its input. It may be blocked waiting for its output to be read,
// if so you may need to call SDL_GetProcessOutput() and read the output in
// parallel with writing input.
//
// `process` process The process to get the input stream for.
// returns the input stream or NULL on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_process (SDL_CreateProcess)
// See also: create_process_with_properties (SDL_CreateProcessWithProperties)
// See also: get_process_output (SDL_GetProcessOutput)
pub fn get_process_input(process &Process) &IOStream {
	return C.SDL_GetProcessInput(process)
}

// C.SDL_GetProcessOutput [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetProcessOutput)
fn C.SDL_GetProcessOutput(process &Process) &IOStream

// get_process_output gets the SDL_IOStream associated with process standard output.
//
// The process must have been created with SDL_CreateProcess() and pipe_stdio
// set to true, or with SDL_CreateProcessWithProperties() and
// `SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER` set to `SDL_PROCESS_STDIO_APP`.
//
// Reading from this stream can return 0 with SDL_GetIOStatus() returning
// SDL_IO_STATUS_NOT_READY if no output is available yet.
//
// `process` process The process to get the output stream for.
// returns the output stream or NULL on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_process (SDL_CreateProcess)
// See also: create_process_with_properties (SDL_CreateProcessWithProperties)
// See also: get_process_input (SDL_GetProcessInput)
pub fn get_process_output(process &Process) &IOStream {
	return C.SDL_GetProcessOutput(process)
}

// C.SDL_KillProcess [official documentation](https://wiki.libsdl.org/SDL3/SDL_KillProcess)
fn C.SDL_KillProcess(process &Process, force bool) bool

// kill_process stops a process.
//
// `process` process The process to stop.
// `force` force true to terminate the process immediately, false to try to
//              stop the process gracefully. In general you should try to stop
//              the process gracefully first as terminating a process may
//              leave it with half-written data or in some other unstable
//              state.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_process (SDL_CreateProcess)
// See also: create_process_with_properties (SDL_CreateProcessWithProperties)
// See also: wait_process (SDL_WaitProcess)
// See also: destroy_process (SDL_DestroyProcess)
pub fn kill_process(process &Process, force bool) bool {
	return C.SDL_KillProcess(process, force)
}

// C.SDL_WaitProcess [official documentation](https://wiki.libsdl.org/SDL3/SDL_WaitProcess)
fn C.SDL_WaitProcess(process &Process, block bool, exitcode &int) bool

// wait_process waits for a process to finish.
//
// This can be called multiple times to get the status of a process.
//
// The exit code will be the exit code of the process if it terminates
// normally, a negative signal if it terminated due to a signal, or -255
// otherwise. It will not be changed if the process is still running.
//
// If you create a process with standard output piped to the application
// (`pipe_stdio` being true) then you should read all of the process output
// before calling SDL_WaitProcess(). If you don't do this the process might be
// blocked indefinitely waiting for output to be read and SDL_WaitProcess()
// will never return true;
//
// `process` process The process to wait for.
// `block` block If true, block until the process finishes; otherwise, report
//              on the process' status.
// `exitcode` exitcode a pointer filled in with the process exit code if the
//                 process has exited, may be NULL.
// returns true if the process exited, false otherwise.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_process (SDL_CreateProcess)
// See also: create_process_with_properties (SDL_CreateProcessWithProperties)
// See also: kill_process (SDL_KillProcess)
// See also: destroy_process (SDL_DestroyProcess)
pub fn wait_process(process &Process, block bool, exitcode &int) bool {
	return C.SDL_WaitProcess(process, block, exitcode)
}

// C.SDL_DestroyProcess [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyProcess)
fn C.SDL_DestroyProcess(process &Process)

// destroy_process destroys a previously created process object.
//
// Note that this does not stop the process, just destroys the SDL object used
// to track it. If you want to stop the process you should use
// SDL_KillProcess().
//
// `process` process The process object to destroy.
//
// NOTE: (thread safety) This function is not thread safe.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_process (SDL_CreateProcess)
// See also: create_process_with_properties (SDL_CreateProcessWithProperties)
// See also: kill_process (SDL_KillProcess)
pub fn destroy_process(process &Process) {
	C.SDL_DestroyProcess(process)
}
