set-psreadlineoption -editmode emacs
set-psreadlinekeyhandler -chord tab -function menucomplete

function ll { get-childitem -force @args }
function rmf { remove-item -force @args }
