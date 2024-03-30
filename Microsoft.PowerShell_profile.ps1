set-psreadlineoption -editmode emacs
set-psreadlinekeyhandler -key tab -function menucomplete

function ll { ls -force @args }
function rmf { rm -force @args }
function md5 { get-filehash -algorithm md5 @args }
function sha1 { get-filehash -algorithm sha1 @args }
function sha256 { get-filehash -algorithm sha256 @args }

if (get-command nvim -ea silent) {
  new-alias n nvim
} else {
  new-alias n notepad
}
