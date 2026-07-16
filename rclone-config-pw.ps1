# Usage: just run the script, provide a password and it'll handle the rest.

# RCLONE_PASSWORD_COMMAND plumbing
#
# What:
# To hinder malicious programs from stealing cloud secrets from rclone.conf,
# by providing at rest encryption.
#
# Why:
# Rclone stores cloud auth tokens in rclone.conf, which is sensitive data.
# It doesn't encrypt the config by default (as of v1.75). I don't like that.
# However, it does have the option to encrypt the config using a password (rclone config encryption).
# But unless configured furthur, that means supplying the password for every operation. Not fun.
# You can set the RCLONE_CONFIG_PASS env var to your password and be done. But that still doesn't
# feel secure to me. The password is visible as plaintext in the registry.
#
# Then there is RCLONE_PASSWORD_COMMAND, which Rclone can run and use the stdout as password.
# This means we can store the encrypted password to disk and provide a command decrypt it.
# But to encrypt the password you need another password. And another password for the second one.
# And so on...
#
# Fortunately, Windows DPAPI solves this issue pretty well.
# It can be used in pwsh via ConvertTo-SecureString and ConvertFrom-SecureString.
# It can encrypt and decrypt a string based on unique identifiers of the current device+user.
# Since the device+user context is globally unique and cannot be
# impersonated (hopefully), the secure string is secure even when exposed.
#
# This solves my main issue: the password for rclone.conf is "remembered"
# without storing the actual password on my machine in plaintext.

# Note:
# DPAPI is used for encrypting the *password* (key file). That means the key file is tied to a machine (can be regenerated).
# But rclone.conf encrypted by Rclone is portable as long as you know the password you used initially.
# This is an intentional choice. I could make the rclone.conf tied to a machine and remove any user remembered passwords.
# But that is unnecessary because password managers exist, and you generate the key file once per machine.
# Also, this setup keeps future config recovery/backup options open.

# mostly vibe coded using gemini

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
