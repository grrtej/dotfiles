set-psreadlineoption -editmode emacs
set-psreadlinekeyhandler -chord tab -function menucomplete

function ll { ls -force @args }
function rmf { rm -force @args }

new-alias vim "C:\Program Files\Vim\gvim.exe"
