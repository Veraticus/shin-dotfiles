# shortcut to this dotfiles path is $ZSH
export ZSH=$HOME/.zsh

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:${PATH}"

# all of our zsh files
typeset -U config_files
config_files=($ZSH/**/*.zsh)

# load the path files
for file in ${(M)config_files:#*/path.zsh}
do
  . $file
done

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
do
  . $file
done

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}
do
  . $file
done

unset config_files

# zinit
. ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust \
  NICHOLAS85/z-a-linkbin

zinit ice wait"0b" lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# Syntax
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zi ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zi light trapd00r/LS_COLORS

# zsh-autosuggestions
zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-autosuggestions

zstyle ":history-search-multi-word" page-size "11"
zinit ice wait"1" lucid
zinit load zdharma-continuum/history-search-multi-word

# Docker
zi for \
  as'completions' \
  atclone'buildx* completion zsh > _buildx' \
  from"gh-r" \
  sbin'!buildx-* -> buildx' \
@docker/buildx \

# exa
zi for \
  atclone'cp -vf completions/exa.zsh _exa'  \
  from'gh-r' \
  sbin'**/exa -> exa' \
ogham/exa

# fzf
zi for \
  from'gh-r'  \
  sbin'fzf'   \
junegunn/fzf

zi for \
  https://github.com/junegunn/fzf/raw/master/shell/{'completion','key-bindings'}.zsh

# gh cli
zi for \
  from'gh-r' \
  sbin'**/gh' \
cli/cli

# ripgrep
zi for \
  from'gh-r' \
  sbin'**/rg -> rg' \
BurntSushi/ripgrep

# bat
zi for \
  from'gh-r' \
  lbin'!' \
  id-as \
  null \
@sharkdp/bat   

# stow
zi for \
  as'null' \
  atclone'autoreconf -iv && ./configure --prefix=$PWD' \
  atpull'%atclone' \
  sbin'!**/stow' \
  make'PREFIX=$PWD install' \
  nocompile \
@aspiers/stow

# jq
zi for \
  from'gh-r' \
  sbin'* -> jq' \
  nocompile \
@stedolan/jq

# neovim
zi for \
  from'gh-r' \
  sbin'**/nvim -> nvim' \
  ver'nightly' \
neovim/neovim

# delta
zi for \
  from'gh-r' \
  sbin'**/delta -> delta' \
dandavison/delta

# direnv
zi for \
  as"program" \
  atclone'./direnv hook zsh > zhook.zsh' \
  from"gh-r" \
  light-mode \
  mv"direnv* -> direnv" \
  src'zhook.zsh' \
direnv/direnv

# fd
zi for \
  from'gh-r' \
  lbin'!' \
  id-as \
  null \
@sharkdp/fd

# golangci-lint
zi for \
  atclone'golangci-lint completion zsh > _golangci-lint' \
  from'gh-r' \
  light-mode \
  nocompile \
  sbin \
golangci/golangci-lint

zinit light geometry-zsh/geometry

### End of Zinit's installer chunk
