#!/bin/bash

GITCONFIG="${HOME}/.gitconfig"
BASHRC="${HOME}/.bashrc"

set -ex
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "dotfiles will be install in $HOME"

if [[ ! -f "${GITCONFIG:?}" ]]; then
    ln -s "${DIR:?}/gitconfig" "${GITCONFIG:?}"
fi

if [[ ! -f "${BASHRC}" ]]; then
    ln -s "${DIR:?}/bashrc" "${BASHRC:?}"
fi
