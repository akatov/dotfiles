#!/bin/sh

# @see https://github.com/twpayne/dotfiles/blob/master/install.sh

set -e # -e: exit on error

# @see https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

bin_dir="$HOME/.local/bin"

chezmoi="$bin_dir/chezmoi"


if [ "$(command -v chezmoi)" ]; then
  chezmoi=chezmoi
elif [ "$(command -v curl)" ]; then
  sh -c "$(curl --fail --silent --show-error --location https://git.io/chezmoi)" -- -b "$bin_dir"
elif [ "$(command -v wget)" ]; then
  sh -c "$(wget --quiet --output-document=- https://git.io/chezmoi)" -- -b "$bin_dir"
else
  echo "To install chezmoi, you must have curl or wget installed." >&2
  exit 1
fi

# replace current process with chezmoi init
exec "$chezmoi" init --apply "--source=$script_dir"
