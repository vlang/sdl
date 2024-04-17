import os

os.chdir(os.dir(os.executable()))!

res := os.execute('sdl2-config --version')
if res.exit_code != 0 {
	println('sdl2-config is missing')
	exit(1)
}
system_version := res.output.trim_space()
println('Your version is ${system_version}')

remotes := os.execute('git branch -r --list')
if remotes.exit_code != 0 {
	println('git is missing')
	exit(1)
}
if remotes.output.split_into_lines().len == 2 {
	// Shallow clone:
	// origin/HEAD -> origin/master
	// origin/master
	os.execute("git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'")
	os.execute("git fetch --all")
}

mut supported_versions := remotes.output.split_into_lines().map(it.trim_space()).filter(it.starts_with('origin/2')).map(it.all_after('origin/'))
supported_versions.insert(0, '2.0.8') // master
println('The SDL module officially supports these versions of SDL:\n   ${supported_versions}')

if system_version == '2.0.8' {
	println('Setting up the repository to branch master, that exactly matches your system SDL version 2.0.8')
	os.system('git checkout master')
	exit(0)
}

if system_version in supported_versions {
	println('Setting up the repository to branch ${system_version} that exactly matches your system SDL version')
	os.system('git checkout ${system_version}')
	exit(0)
}

base_version := '${system_version.all_before_last('.')}.0'
println('Setting up the repository to branch ${base_version}, that best matches the system SDL version: ${system_version} ...')
os.system('git checkout ${base_version}')
