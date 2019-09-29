josh_geometry_git() {
  (( $+commands[git] )) || return

  command git rev-parse --git-dir > /dev/null 2>&1 || return

  $(command git rev-parse --is-bare-repository 2>/dev/null) \
    && ansi ${GEOMETRY_GIT_COLOR_BARE:=blue} ${GEOMETRY_GIT_SYMBOL_BARE:="⬢"} \
    && return

  local geometry_git_details && geometry_git_details=(
    $(geometry_git_conflicts)
    $(geometry_git_stashes)
    $(geometry_git_status)
  )

  local separator=${GEOMETRY_GIT_SEPARATOR:-" :: "}
  echo -n $(geometry_git_symbol) $(geometry_git_branch) ${(pj.$separator.)geometry_git_details}
}

GEOMETRY_STATUS_SYMBOL="▶"
GEOMETRY_STATUS_SYMBOL_ERROR="▷"
GEOMETRY_PROMPT=(geometry_echo geometry_path geometry_status)
GEOMETRY_RPROMPT=(geometry_exec_time josh_geometry_git geometry_echo)
