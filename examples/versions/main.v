module main

import sdl

fn main() {
	println('v.mod version $sdl.vmod_version()')
	println('Const version ${sdl.major_version}.${sdl.minor_version}.$sdl.patchlevel')
	println('Compiled against version $sdl.version()')
	println('Runtime loaded version $sdl.get_version()')
	println('Revision $sdl.get_revision_number() / $sdl.get_revision()')
}
