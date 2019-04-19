DEPENDENCES_ZSH+=( zpm-zsh/helpers )
DEPENDENCES_ARCH+=( tmux )
DEPENDENCES_DEBIAN+=( tmux )

[[ -f ~/.tmux.conf ]] || touch ~/.tmux.conf

if ! check-if tmux; then
  alias tmux="TERM=xterm-256color tmux -2 attach || TERM=xterm-256color tmux -2 new"
fi

if (( $+commands[tmux] )); then
  if [[ ! "$TMUX_AUTOSTART" == "false" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    TMUX_AUTOSTART="true"
  fi
fi

function _tmux_autostart(){
  if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" ]]; then
    tmux
    exit 0
  fi
  precmd_functions=(${precmd_functions#_tmux_autostart})
}
precmd_functions+=( _tmux_autostart )

if [[ $TMUX_MOTD != false && ! -z $TMUX  &&  $(\tmux list-windows | wc -l | tr -d ' ') == 1 ]] && ( \tmux list-windows | tr -d ' '|grep -q 1panes  ); then
    _tmux_monitor
fi
