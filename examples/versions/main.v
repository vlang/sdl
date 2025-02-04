module main

import sdl

fn main() {
	println('v.mod version ${sdl.vmod_version()}')
	println('Const version ${sdl.major_version}.${sdl.minor_version}.${sdl.micro_version}')
	println('Compiled against version ${sdl.compiled_version_string()}')
	println('Runtime (linked) loaded version ${sdl.linked_version_string()}')
}
