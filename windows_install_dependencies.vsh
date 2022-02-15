import os

const (
	powershell = 'powershell.exe -executionpolicy remotesigned -File'
	urls       = [
		'https://www.libsdl.org/release/SDL2-devel-2.0.9-VC.zip',
		'https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.14-VC.zip',
		'https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.3-VC.zip',
		'https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.2-VC.zip',
	]
)

fn main() {
	cwd := os.dir(os.executable())
	destination := os.real_path(os.join_path(cwd, 'thirdparty'))
	download_ps1 := os.real_path(os.join_path(cwd, '.github/workflows/download.ps1'))
	unzip_ps1 := os.real_path(os.join_path(cwd, '.github/workflows/unzip.ps1'))
	os.mkdir(destination) or {}
	for url in urls {
		parts := url.split('/')
		zip_file := os.join_path(destination, parts[parts.len - 1])
		mut res := os.execute('$powershell $download_ps1 "$url" "$zip_file"')
		if res.exit_code > 0 {
			return
		}
		if os.exists(zip_file) {
			res = os.execute('$powershell $unzip_ps1 "$zip_file" "$destination"')
			if res.exit_code > 0 {
				return
			}
			os.rm(zip_file) or { println('unable to delete $zip_file') }
		} else {
			println('Unable to find $zip_file')
			return
		}
	}
}
