# emacs keybindings
set-psreadlineoption -editmode emacs
set-psreadlinekeyhandler -key tab -function menucomplete

# some shortcuts
function ll { ls -force @args }
function rmf { rm -force @args }
function md5 { get-filehash -algorithm md5 @args }
function sha1 { get-filehash -algorithm sha1 @args }
function sha256 { get-filehash -algorithm sha256 @args }

# nvim shortcut (notepad fallback)
if (get-command nvim -ea silent) {
  new-alias n nvim
} else {
  new-alias n notepad
}

# ripgrep completions, if installed
if (get-command rg -ea silent) {
  . "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\BurntSushi.ripgrep*\ripgrep*\complete\_rg.ps1"
}
