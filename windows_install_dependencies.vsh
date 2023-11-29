import os
import szip
import net.http

const urls = [
	'https://www.libsdl.org/release/SDL2-devel-2.0.9-VC.zip',
	'https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.14-VC.zip',
	'https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.3-VC.zip',
	'https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.2-VC.zip',
]

fn main() {
	cwd := os.dir(os.executable())
	destination := os.real_path(os.join_path(cwd, 'thirdparty'))
	os.mkdir(destination) or {}
	for url in urls {
		parts := url.split('/')
		zip_file := os.join_path(destination, parts.last())
		http.download_file(url, zip_file) or { eprintln('Failed to download `${url}`: ${err}') }
		if os.exists(zip_file) {
			szip.extract_zip_to_dir(zip_file, destination) or {
				eprintln('Unable to delete ${zip_file}')
			}
			os.rm(zip_file) or { println('Unable to delete ${zip_file}') }
		} else {
			eprintln('Unable to find ${zip_file}')
			return
		}
	}
	// Finally, create the SDL2main.def stub file for tcc
	stub_file := os.real_path(os.join_path(destination, 'SDL2main.def'))
	mut f := os.create(stub_file) or {
		eprintln('Unable to create ${stub_file}')
		return
	}
	f.close()
}
