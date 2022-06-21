module main

// This can be used in CI to check against the compiled version
import sdl

fn main() {
	mut v := sdl.Version{}
	sdl.version(mut v)
	println(v.str())
}
