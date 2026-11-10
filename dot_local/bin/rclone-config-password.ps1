# RCLONE_PASSWORD_COMMAND helper.
# Stores the rclone config password DPAPI-encrypted in %LOCALAPPDATA%\rclone\rclone-config-password.dpapi,
# so rclone can decrypt rclone.conf without a plaintext password or a prompt per command.
# Run once per machine without arguments. -GetPassword prints the password for rclone.

param (
  [switch]$GetPassword
)

$ErrorActionPreference = 'Stop'
$keyFile = Join-Path $env:LOCALAPPDATA 'rclone\rclone-config-password.dpapi'

function Get-DecryptedPassword {
  if (-not (Test-Path -LiteralPath $keyFile)) {
    throw "Key file not found at '$keyFile'. Run this script once to create it."
  }
  $secure = Get-Content -LiteralPath $keyFile -Raw | ConvertTo-SecureString
  (New-Object System.Net.NetworkCredential('', $secure)).Password
}

function Initialize-RcloneAuth {
  if (-not (Test-Path -LiteralPath $keyFile)) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $keyFile) | Out-Null
    Read-Host -Prompt 'Enter rclone configuration password' -AsSecureString |
      ConvertFrom-SecureString |
      Out-File -LiteralPath $keyFile -NoNewline
    Write-Host "Key file created at: $keyFile" -ForegroundColor Green
  }

  $expectedCmd = "pwsh -noprofile -file `"$PSCommandPath`" -GetPassword"
  if ([Environment]::GetEnvironmentVariable('RCLONE_PASSWORD_COMMAND', 'User') -ne $expectedCmd) {
    [Environment]::SetEnvironmentVariable('RCLONE_PASSWORD_COMMAND', $expectedCmd, 'User')
    $Env:RCLONE_PASSWORD_COMMAND = $expectedCmd
    Write-Host 'RCLONE_PASSWORD_COMMAND configured.' -ForegroundColor Green
  }
}

if ($GetPassword) {
  $oldEncoding = [Console]::OutputEncoding
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
  try { Get-DecryptedPassword } finally { [Console]::OutputEncoding = $oldEncoding }
}
else {
  Initialize-RcloneAuth
}
