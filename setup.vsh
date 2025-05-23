import os

os.chdir(os.dir(os.executable()))!

mut res := os.execute('sdl2-config --version')
if res.exit_code != 0 {
	println('sdl2-config is missing. Trying pkg-config...')
	pkgconf := os.find_abs_path_of_executable('pkg-config') or { '' }
	if !os.is_executable(pkgconf) {
		println('pkg-config not found. Giving up')
		exit(1)
	}
	res = os.execute('pkg-config --modversion sdl2')
	if res.exit_code != 0 {
		println('SDL2 is missing. Trying SDL3...')
		res = os.execute('pkg-config --modversion sdl3')
		if res.exit_code != 0 {
			println('SDL3 is missing. Giving up')
			exit(1)
		}
	}
}
system_version := res.output.trim_space()
println('Your version is ${system_version}')

remotes := os.execute('git branch -r --list')
if remotes.exit_code != 0 {
	println('git is missing. Giving up')
	exit(1)
}
supported_versions := remotes.output.split_into_lines().map(it.trim_space()).filter(
	it.starts_with('origin/2') || it.starts_with('origin/3')).map(it.all_after('origin/'))
println('The SDL module officially supports these versions of SDL:\n   ${supported_versions}')

if system_version in supported_versions {
	println('Setting up the repository to branch ${system_version} that exactly matches your system SDL version')
	os.system('git checkout ${system_version}')
	exit(0)
}

base_version := '${system_version.all_before_last('.')}.0'
println('Setting up the repository to branch ${base_version}, that best matches the system SDL version: ${system_version} ...')
os.system('git checkout ${base_version}')
