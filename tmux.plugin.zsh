#!/usr/bin/env zsh
# Standarized $0 handling, following:
# https://github.com/zdharma/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

DEPENDENCES_ARCH+=( tmux )
DEPENDENCES_DEBIAN+=( tmux )

if (( $+functions[zpm] )); then
  zpm zpm-zsh/helpers
fi

if [[ $PMSPEC != *b* ]] {
  PATH=$PATH:"${0:h}/bin"
}

if (( $+commands[tmux] )); then
  if [[ "$TMUX_AUTOSTART" != "false" && -n "$SSH_CONNECTION" ]]; then
    TMUX_AUTOSTART="true"
  fi
fi

function _tmux_autostart() {
  if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" ]]; then
    TERM=xterm-256color tmux -2 new-session -A -s main
    exit 0
  fi
  add-zsh-hook -d precmd _tmux_autostart
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _tmux_autostart

if [[ $TMUX_MOTD != false && ! -z $TMUX ]]; then
  declare -a list_windows; list_windows=( ${(f)"$(command tmux list-windows)"} )
  if [[ "${#list_windows}" == 1 && "${list_windows}" == *"1 panes"*  ]]; then
    _tmux_motd
  fi
fi