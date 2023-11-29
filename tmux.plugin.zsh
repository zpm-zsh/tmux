#!/usr/bin/env zsh
# Standarized $0 handling, following:
# https://z-shell.github.io/zsh-plugin-assessor/Zsh-Plugin-Standard
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

DEPENDENCES_ARCH+=( tmux )
DEPENDENCES_DEBIAN+=( tmux )

if (( $+functions[zpm] )); then
  zpm load zpm-zsh/colors zpm-zsh/helpers
fi

if [[ $PMSPEC != *f* ]] {
  fpath+=( "${0:h}/functions" )
}

autoload -Uz tmux-motd

if [[ $PMSPEC != *b* ]] {
  PATH=$PATH:"${0:h}/bin"
}

if (( $+commands[tmux] )); then
  TMUX_AUTOSTART=${TMUX_AUTOSTART:-'false'}
  TMUX_OVERRIDE_TERM=${TMUX_OVERRIDE_TERM:-'true'}

  if [[ "$TMUX_AUTOSTART" == 'true' && -z "$TMUX" ]]; then
    function _tmux_autostart() {
      if [[ "$TMUX_OVERRIDE_TERM" == 'true' ]]; then
        TERM=xterm-256color tmux -2 new-session -A -s main
      else
        tmux -2 new-session -A -s main
      fi

      exit 0
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
