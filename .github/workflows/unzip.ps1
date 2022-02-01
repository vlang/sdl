
# It is expected that the script is called with two parameters,
# a zip file and a path where to extract to.
# Each of these parameters should be encased in double quotes.
# E.g. "C:\test.zip" "C:\temp"


if (-not($args.length -eq 2)) {
	Write-Host "Script must be called with two parameters, provided: $args.length" -Foreground "Red"
	Exit 1
}

$zip_file = $args[0]
$destination_path = $args[1]
if (-not (Test-Path $destination_path -PathType Container)) {
	Write-Host "Desitnation directory $destination_path does NOT exist" -Foreground "Red"
	Exit 2
}

try {
	if (-not (Test-Path $zip_file -PathType leaf)) {
		Write-Host "Zip file $zip_file does NOT exist" -Foreground "Red"
		Exit 3
	}
	$shell = new-object -com shell.application
	$zip = $shell.NameSpace($zip_file)
	foreach($item in $zip.items())
	{
		$shell.Namespace($destination_path).copyhere($item)
	}
} catch {
	Write-Host "$_" -Foreground "Red"
	Write-Host "ERROR unziping $zip_file" -Foreground "Red"
	Exit 4
}

Exit 0  # success
