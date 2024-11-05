#!/bin/bash

GITCONFIG="${HOME}/.gitconfig"
VIMRC="${HOME}/.vimrc"
BASHRC="${HOME}/.bashrc"
VSCODE_SETTINGS="${HOME}/.vscode/settings.json"

set -ex
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "dotfiles will be install in $HOME"

if [[ ! -f "${GITCONFIG:?}" ]]; then
    ln -s "${DIR:?}/gitconfig" "${GITCONFIG:?}"
fi

if [[ ! -f "${BASHRC}" ]]; then
    ln -s "${DIR:?}/bashrc" "${BASHRC:?}"
fi

if [[ ! -f "${VIMRC}" && ! -d "${HOME}/.vim" ]]; then
    ln -s "${DIR:?}/vimrc" "${VIMRC:?}"
    git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi

if [[ ! -f "${VIMRC}" && ! -d "${HOME}/.vim" ]]; then
    ln -s "${DIR:?}/vimrc" "${VIMRC:?}"
    git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi

if [[ ! -f "${VSCODE_SETTINGS}" ]]; then
    mkdir -p ${HOME}/.vscode
    ln -s "${DIR:?}/vscode-settings.json" "${VSCODE_SETTINGS:?}"
fi
