// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

import sdl.c

pub const used_import = c.used_import

pub fn vmod_version() string {
	mut v := '0.0.0'
	vmod := @VMOD_FILE
	if vmod.len > 0 {
		if vmod.contains('version:') {
			v = vmod.all_after('version:').all_before('\n').replace("'", '').replace('"',
				'').trim(' ')
		}
	}
	return v
}
