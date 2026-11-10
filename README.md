# dotfiles

chezmoi source state for Windows and WSL/Linux. Git is the undo; `chezmoi diff` is the review.

## New machine

Install chezmoi and git. Linux/WSL: zsh + oh-my-zsh, Vim 9.1+, wsl2-ssh-agent. Windows: PowerShell 7, VS Code, Windows Terminal, Firefox (launch once).

```sh
git config --global core.autocrlf false   # .gitattributes owns line endings
chezmoi init --ssh grrtej
chezmoi diff
chezmoi apply
```

Windows: run `~/.local/bin/rclone-config-password.ps1` once; it prompts for the rclone config password and sets `RCLONE_PASSWORD_COMMAND`. Hook: `chezmoi cd && git config core.hooksPath .githooks`.

## Daily

```sh
chezmoi edit ~/.gitconfig
chezmoi diff
chezmoi apply
chezmoi git -- commit -m "..."
chezmoi update -vn
```
