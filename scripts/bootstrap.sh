#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)

set -e

echo ''

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=true backup_all=false skip_all=false

  for src in $(find "$DOTFILES_ROOT/" -maxdepth 2 -name '*.symlink')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done

  success 'installed dotfiles'
}

install_alacritty () {
  info 'installing alacritty'

  if [ -f "${HOME}/.alacritty.yml" ]
  then
    success "alacritty installed"
  else
    link_file "$DOTFILES_ROOT/alacritty/alacritty.yml" "${HOME}/.alacritty.yml"
  fi

  cd $DOTFILES_ROOT
}

install_kitty () {
  info 'installing kitty'

  if [ -d "${HOME}/.config/kitty/" ]
  then
    success "kitty exists already"
  else
    mkdir -p "${HOME}/.config/kitty/"
    link_file "$DOTFILES_ROOT/kitty/kitty.conf" "${HOME}/.config/kitty/kitty.conf"
    success "installed kitty"
  fi

  cd $DOTFILES_ROOT
}

install_neovim() {
  info 'installing neovim'

  if [ -f "$HOME/.config/nvim/init.vim" ]
  then
    success "neovim config installed"
  else
    mkdir -p $HOME/.config/nvim
    link_file "$DOTFILES_ROOT/nvim/init.vim" "$HOME/.config/nvim"
  fi

  if [ -f "$HOME/.config/nvim/coc-settings.json" ]
  then
    success "coc.nvim installed"
  else
    link_file "$DOTFILES_ROOT/nvim/coc-settings.json" "$HOME/.config/nvim"
  fi

  cd $DOTFILES_ROOT
}

install_tmux() {
  info 'installing tmux'

  if [ -f "${HOME}/.tmux.conf" ]
  then
    success "tmux conf installed"
  else
    link_file "$DOTFILES_ROOT/tmux/tmux.conf" "${HOME}/.tmux.conf"
  fi

  cd $DOTFILES_ROOT
}

install_zplugin() {
  if [ -d "${HOME}/.zplugin/bin" ]; then
    success "zplugin installed"
  else
    mkdir ~/.zplugin
    git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
    zsh -c "source ~/.zshrc && -zplg-scheduler burst && zplugin compile --all  || true "
  fi

  cd $DOTFILES
}

install_yamllint() {
  if [ -f "${HOME}/.config/yamllint/config" ]; then
    success "yamllint installed"
  else
    mkdir -p "${HOME}/.config/yamllint"
    link_file "$DOTFILES_ROOT/yamllint/config.yaml" "${HOME}/.config/yamllint/config"
  fi

  cd $DOTFILES
}

install_k9s() {
if [ -L "${HOME}/.k9s/config.yml" ]; then
    success "k9s installed"
  else
    mkdir -p "${HOME}/.k9s"
    rm -f ${HOME}/.k9s/config.yml
    link_file "$DOTFILES_ROOT/k9s/config.yml" "${HOME}/.k9s/config.yml"
    link_file "$DOTFILES_ROOT/k9s/skin.yml" "${HOME}/.k9s/skin.yml"
  fi

  cd $DOTFILES
}

install_dotfiles
install_alacritty
install_kitty
install_neovim
install_tmux
install_zplugin
install_yamllint
install_k9s

if [ "$(uname 2> /dev/null)" == "Darwin" ]; then
    brew bundle --file="$DOTFILES_ROOT/Brewfile"
    pip3 install yamllint
fi

echo ''
echo '  All installed!'
