module main

// This can be used in CI to check against the compiled version
import sdl

fn main() {
	println(sdl.version_string())
}
