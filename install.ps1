function install($from, $to) {
  new-item -force -type dir (split-path -parent $to) | out-null
  new-item -force -type sym -path $to -target (resolve-path $from)
}

install "Microsoft.PowerShell_profile.ps1" "~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
install "vimrc" "~/vimfiles/vimrc"
install "gvimrc" "~/vimfiles/gvimrc"
