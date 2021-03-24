#!/usr/bin/env bash

if [ "$(uname 2> /dev/null)" == "Darwin" ]; then
    brew bundle
    pip3 install yamllint
fi

stow zsh
stow nvim
stow kitty
stow git
stow k9s
stow tmux
stow yamllint

if [ -d "${HOME}/.zinit/bin" ]; then
    echo "zinit installed"
else
    mkdir ${HOME}/.zinit
    git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
    zsh -c "source ~/.zshrc && -zplg-scheduler burst && zinit compile --all  || true "
fi

