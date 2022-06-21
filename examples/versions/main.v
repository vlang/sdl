module main

import sdl

fn main() {
	println('v.mod version $sdl.vmod_version()')
	println('Const version ${sdl.major_version}.${sdl.minor_version}.$sdl.patchlevel')
	mut compiled_version := sdl.Version{}
	sdl.version(mut compiled_version)
	println('Compiled against version $compiled_version.str()')
	mut linked_version := sdl.Version{}
	sdl.get_version(mut linked_version)
	println('Runtime loaded version $linked_version.str()')
	println('Revision $sdl.get_revision_number() / $sdl.get_revision()')
}
