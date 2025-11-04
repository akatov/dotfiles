# akatov/dotfiles

Dmitri's dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Installation

Install Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then do one of the following:

install chezmoi into `~/.local/bin` and auto-init

```bash
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply akatov
```

or install chezmoi using homebrew and init manually

```bash
brew install chezmoi
chezmoi init akatov
```
