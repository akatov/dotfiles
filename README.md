# akatov/dotfiles

Dmitri's dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Installation

```bash
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then do one of the following:

```bash
# install chezmoi into ~/.local/bin and auto-init
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply akatov
```

or

```bash
# install chezmoi using homebrew and init manually
brew install chezmoi
chezmoi init akatov
```
