DEPENDENCES_ARCH+=( tmux )
DEPENDENCES_DEBIAN+=( tmux )
DEPENDENCES_ZSH+=( zpm-zsh/helpers )

which zpm >/dev/null && zpm load zpm-zsh/helpers

[[ -f ~/.tmux.conf ]] || touch ~/.tmux.conf

if (( $+commands[tmux] )); then
  if [[ ! "$TMUX_AUTOSTART" == "false" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    TMUX_AUTOSTART="true"
  fi
fi

function _tmux_autostart(){
  if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" ]]; then
    tmux attach || TERM=xterm-256color tmux new
    exit 0
  fi
  precmd_functions=(${precmd_functions#_tmux_autostart})
}
precmd_functions+=( _tmux_autostart )

if [[ $TMUX_MOTD != false && ! -z $TMUX  &&  $(\tmux list-windows | wc -l | tr -d ' ') == 1 ]] && ( \tmux list-windows | tr -d ' '|grep -q 1panes  ); then
    _tmux_motd
fi
