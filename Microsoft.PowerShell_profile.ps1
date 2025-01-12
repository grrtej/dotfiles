set-psreadlineoption -editmode emacs
set-psreadlinekeyhandler -key tab -function menucomplete

function  ll   { ls -force @args }
function  rmf  { rm -force @args }

new-alias vim  "C:\Program Files\Vim\vim91\vim.exe"
new-alias gvim "C:\Program Files\Vim\vim91\gvim.exe"
function  hex  { vim -b "+%!xxd" @args }
function  ghex { gvim -b "+%!xxd" @args }
new-alias n    gvim
