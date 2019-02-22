alias tmux="TERM=xterm-256color tmux -2 attach || TERM=xterm-256color tmux -2 new"


[[ ! -f ~/.tmux.conf ]] && touch ~/.tmux.conf


if (( $+commands[tmux] )); then
  if [[ -z "$TMUX_AUTOSTART" ]]; then
    if [[ -n "$SSH_CONNECTION" ]]; then
      TMUX_AUTOSTART="true"
    else
      TMUX_AUTOSTART="false"
    fi
  fi
else
  TMUX_AUTOSTART="false"
fi


function _tmux_autostart(){
  
  if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" ]]; then
    tmux -2 attach || tmux -2 new
    exit 0
  fi
  precmd_functions=(${precmd_functions#_tmux_autostart})
}

precmd_functions+=( _tmux_autostart )


if [[ $TMUX_MOTD != false && ! -z $TMUX  &&  $(\tmux list-windows | wc -l | tr -d ' ') == 1 ]] && ( \tmux list-windows | tr -d ' '|grep -q 1panes  ); then
  if [[ "$OSTYPE" == linux* || "$OSTYPE" == freebsd*  ]]; then
    _tmux_monitor
    return 0
  fi
fi


DEPENDENCES_ARCH+=( tmux )
DEPENDENCES_DEBIAN+=( tmux )
