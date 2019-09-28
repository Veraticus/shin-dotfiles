#
# A stripped-down sorin theme.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Josh Symonds <josh@joshsymonds.com>
#
# Screenshots:
#   http://i.imgur.com/nBEEZ.png
#

function prompt_josh_pwd {
  local pwd="${PWD/#$HOME/~}"

  if [[ "$pwd" == (#m)[/~] ]]; then
    _prompt_josh_pwd="$MATCH"
    unset MATCH
  else
    _prompt_josh_pwd="${${${(@j:/:M)${(@s:/:)pwd}##.#?}:h}%/}/${pwd:t}"
  fi
}

function prompt_josh_precmd {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS

  # Format PWD.
  prompt_josh_pwd
}

function prompt_josh_setup {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)

  # Load required functions.
  autoload -Uz add-zsh-hook

  # Add hook for calling git-info before each command.
  add-zsh-hook precmd prompt_josh_precmd

  # Define prompts.
  PROMPT='%F{magenta} %f%F{cyan}${_prompt_josh_pwd}%f%(!. %B%F{red}#%f%b.)%B%(?;%{%F{green}%} ;%{%F{red}%} )❯%f%b '
  SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '
}

prompt_josh_setup "$@"
