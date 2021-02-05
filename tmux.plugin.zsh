#!/usr/bin/env zsh
# Standarized $0 handling, following:
# https://github.com/zdharma/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

DEPENDENCES_ARCH+=( tmux )
DEPENDENCES_DEBIAN+=( tmux )

if (( $+functions[zpm] )); then #DO_NOT_INCLUDE_LINE_IN_ZPM_CACHE
  zpm load zpm-zsh/colors zpm-zsh/helpers #DO_NOT_INCLUDE_LINE_IN_ZPM_CACHE
fi #DO_NOT_INCLUDE_LINE_IN_ZPM_CACHE

if [[ $PMSPEC != *f* ]] {
  fpath+=( "${0:h}/functions" )
}

autoload -Uz tmux-motd

if [[ $PMSPEC != *b* ]] {
  PATH=$PATH:"${0:h}/bin"
}

if (( $+commands[tmux] )); then
  TMUX_AUTOSTART=${TMUX_AUTOSTART:-'true'}

  if [[ "$TMUX_AUTOSTART" == 'true' && -z "$TMUX" ]]; then
    function _tmux_autostart() {
      TERM=xterm-256color tmux -2 new-session -A -s main
      exit 0
      add-zsh-hook -d precmd _tmux_autostart
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _tmux_autostart
  fi

  if [[ $TMUX_MOTD != false && ! -z $TMUX ]]; then
    declare -a list_windows; list_windows=( ${(f)"$(command tmux list-windows)"} )
    if [[ "${#list_windows}" == 1 && "${list_windows}" == *"1 panes"*  ]]; then
      tmux-motd
    fi
  fi

fi
