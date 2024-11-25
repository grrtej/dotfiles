set-psreadlineoption -editmode emacs
set-psreadlinekeyhandler -key tab -function menucomplete
set-psreadlineoption -predictionviewstyle listview

new-alias vim  "C:\Program Files\Vim\vim91\vim.exe"
new-alias gvim "C:\Program Files\Vim\vim91\gvim.exe"
new-alias n    gvim
new-alias vlc  "C:\Program Files\VideoLAN\VLC\vlc.exe"
function  ll   { ls -force @args }
function  rmf  { rm -force @args }
function  hex  { vim "+%!xxd" @args }
function  ghex { gvim "+%!xxd" @args }
