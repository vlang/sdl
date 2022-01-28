
# sdl2 developer packages
$urls = @('https://www.libsdl.org/release/SDL2-devel-2.0.8-VC.zip',
		  'https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.14-VC.zip',
		  'https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.3-VC.zip',
		  'https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.2-VC.zip'
		)

# make thirdparty directory if it does not exist
$destination_path = Join-Path -Path $pwd -ChildPath 'thirdparty'
if (-not (Test-Path $destination_path -PathType Container)) {
	try {
		New-Item -ItemType Directory -Path $destination_path -ErrorAction Stop | Out-Null
	}
	catch {
		Write-Host "Unable to create DIRECTORY $destination_path. ERROR was: $_" -Foreground "Red"
		Exit
	}
	"Successfully created directory $destination_path."
}
else {
	"Directory $destination_path already exists."
}

# download and extract sdl zips
$shell = new-object -com shell.application
for($i = 0; $i -lt $urls.length; $i++) {
	$url = $urls[$i]
	$zip_file = Join-Path -Path $destination_path -ChildPath $url.split("/")[-1]
	try {
		Write-Host "Downloading $($urls[$i])" -ForegroundColor White
		Invoke-WebRequest -Uri $url -OutFile $zip_file
	} catch {
		Write-Host "ERROR downloading $url" -Foreground "Red"
		Exit
	}
	try {
		Write-Host "Unzipping $zip_file ..." -ForegroundColor White
		$zip = $shell.NameSpace($zip_file)
		foreach($item in $zip.items())
		{
			$shell.Namespace($destination_path).copyhere($item)
		}
	} catch {
		Write-Host "ERROR unziping $zip_file" -Foreground "Red"
		Exit
	}
	if (Test-Path $zip_file) {
		Write-Host "Removing $zip_file" -ForegroundColor White
		Remove-Item $zip_file
	}
}
Write-Host "Note that for an SDL program to run successfully,
the required SDL dlls must be copied from the third-party directories
to the root directory where the application resides." -ForegroundColor Yellow
