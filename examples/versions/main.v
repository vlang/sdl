module main

import sdl

fn main() {
	println('v.mod version $vmod_version()')
	println('Const version ${major_version}.${minor_version}.$patchlevel')
	mut compiled_version := Version{}
	version(mut compiled_version)
	println('Compiled against version $compiled_version.str()')
	mut linked_version := Version{}
	get_version(mut linked_version)
	println('Runtime loaded version $linked_version.str()')
	println('Revision $get_revision_number() / $get_revision()')
}
