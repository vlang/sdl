module main

// This can be used in CI to check against the compiled version
import sdl

fn main() {
	println(sdl.compiled_version_string())
}
