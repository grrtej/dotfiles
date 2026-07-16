param (
  [switch]$GetPassword
)

$keyFile = Join-Path $HOME "rclone.sec"

function Get-DecryptedPassword {
  if (-not (Test-Path -LiteralPath $keyFile)) {
    throw "Key file not found at '$keyFile'. Run this script interactively first to initialize."
  }
  $secure = Get-Content -LiteralPath $keyFile -Raw | ConvertTo-SecureString
  (New-Object System.Net.NetworkCredential('', $secure)).Password
}

function Initialize-RcloneAuth {
  # 1. Initialize the key file if it doesn't exist
  if (-not (Test-Path -LiteralPath $keyFile)) {
    Read-Host -Prompt 'Enter rclone configuration password' -AsSecureString | 
    ConvertFrom-SecureString | 
    Out-File -LiteralPath $keyFile -NoNewline
    Write-Host "Key file created at: $keyFile" -ForegroundColor Green
  }

  # 2. Configure/Update the environment variable
  $expectedCmd = "pwsh -noprofile -file `"$PSCommandPath`" -GetPassword"
  $currentRegistryValue = [Environment]::GetEnvironmentVariable("RCLONE_PASSWORD_COMMAND", "User")

  if ($currentRegistryValue -ne $expectedCmd) {
    [Environment]::SetEnvironmentVariable("RCLONE_PASSWORD_COMMAND", $expectedCmd, "User")
    $Env:RCLONE_PASSWORD_COMMAND = $expectedCmd
    Write-Host "Environment variable RCLONE_PASSWORD_COMMAND configured." -ForegroundColor Green
  }
}

# --- Main Execution ---
if ($GetPassword) {
  $oldEncoding = [Console]::OutputEncoding
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
  Get-DecryptedPassword
  [Console]::OutputEncoding = $oldEncoding
}
else {
  Initialize-RcloneAuth
}
