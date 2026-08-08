# workaround for obfuscated firefox profile names

$profiles = Join-Path $PWD "Profiles"
$chrome = Join-Path $PWD "chrome"
$userjs = Join-Path $PWD "user.js"

if (-not (Test-Path $profiles -PathType Container)) {
  throw "please complete firefox initial setup"
}

# a folder containing prefs.js is assumed to be a profile
$activeProfiles = Get-ChildItem $profiles -Directory | Where-Object {
  Test-Path (Join-Path $_.FullName "prefs.js") -PathType Leaf
}

foreach ($p in $activeProfiles) {
  Copy-Item -Path $userjs -Destination $p.FullName -Force
  Copy-Item -Path $chrome -Destination $p.FullName -Recurse -Force
}
