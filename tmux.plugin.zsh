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
  if [[ -z "$TMUX_AUTOSTART" ]]; then
    if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
      TMUX_AUTOSTART='true'
    else
      TMUX_AUTOSTART='false'
    fi
  fi

  TMUX_OVERRIDE_TERM=${TMUX_OVERRIDE_TERM:-'true'}

  if [[ "$TMUX_AUTOSTART" == 'true' && -z "$TMUX" ]]; then
    function _tmux_autostart() {
      if [[ "$TMUX_OVERRIDE_TERM" == 'true' ]]; then
        TERM=xterm-256color tmux -2 attach-session || TERM=xterm-256color tmux -2 new-session
      else
        tmux -2 attach-session || tmux -2 new-session
      fi

      exit 0
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _tmux_autostart
  fi

  if [[ $TMUX_MOTD == true && ! -z $TMUX ]]; then
    declare -a list_windows; list_windows=( ${(f)"$(command tmux list-windows)"} )
    if [[ "${#list_windows}" == 1 && "${list_windows}" == *"1 panes"*  ]]; then
      tmux-motd
    fi
  fi

fi
