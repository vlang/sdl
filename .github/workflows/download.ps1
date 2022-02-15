
# It is expected that the script is called with two parameters,
# a url and a full path of the file name used to store it.
# Each of these parameters should be encased in double quotes.
# E.g. "url1" "C:\temp\x.zip"


if (-not($args.length -eq 2)) {
	Write-Host "Script must be called with two parameters, provided: $args.length" -Foreground "Red"
	Exit 1
}

try {
	Invoke-WebRequest -Uri $args[0] -OutFile $args[1]
} catch {
	Write-Host "ERROR downloading $url" -Foreground "Red"
	Exit 2
}

Exit 0  # success
