set-psreadlineoption -editmode emacs
set-psreadlinekeyhandler -key tab -function menucomplete
set-psreadlineoption -predictionviewstyle listview

function ll { ls -force @args }
function rmf { rm -force @args }
function vim { & "C:\Program Files\Vim\vim91\vim.exe" @args }
function gvim { & "C:\Program Files\Vim\vim91\gvim.exe" @args }
new-alias n gvim
