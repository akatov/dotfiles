# akatov/dotfiles

Dmitri's dotfiles, managed with [https://github.com/twpayne/chezmoi](chezmoi).

Installation:

```bash
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install 1password
brew install 1password 1password-cli

# install chezmoi and set up
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply akatov

# or separately
brew install chezmoi
chezmoi init akatov
```

Secrets are stored in [https://1password.com/](1Password).

Using 1password-cli version 2.0 and up log in and get a session using:

```sh
op account add --address $SUBDOMAIN.1password.com --email $EMAIL
eval $(op signin --account $SUBDOMAIN)
```
