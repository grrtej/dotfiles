# dotfiles

## Usage

edit dotfiles in repo, then run diff/apply. avoid editing managed dotfiles directly

`dotfiles <-> chezmoi <-> git`

```sh
chezmoi init --ssh grrtej # new machine
chezmoi git -- commit # commit change
chezmoi git -- push # push changes
chezmoi update -vn # pull and preview changes
chezmoi diff # preview changes
chezmoi apply # apply changes
chezmoi managed # dotfiles managed on this machine
```

## TODO

- fix broken vscode autocomplete because of tmpl file ext
  - modelines?
    - vscode doesnt pick up vim modeline
  - chezmoitemplates?
    - dont need tmpl file ext
    - but adds extra indirection