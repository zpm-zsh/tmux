DEPENDENCES_ARCH+=( tmux )
DEPENDENCES_DEBIAN+=( tmux )
DEPENDENCES_ZSH+=( zpm-zsh/helpers )

if (( $+function[zpm] )); then
  zpm zpm-zsh/helpers
fi

if (( $+commands[tmux] )); then
  if [[ "$TMUX_AUTOSTART" != "false" && -n "$SSH_CONNECTION" ]]; then
    TMUX_AUTOSTART="true"
  fi
fi

function _tmux_autostart(){
  if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" ]]; then
    (tmux ls | grep -vq attached && tmux -2 at) 2>/dev/null || TERM=xterm-256color tmux -2
    exit 0
  fi
  add-zsh-hook -d precmd _tmux_autostart
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _tmux_autostart

if [[ $TMUX_MOTD != false && ! -z $TMUX  && \
$(\tmux list-windows | wc -l | tr -d ' ') == 1 ]] && \
( \tmux list-windows | tr -d ' '|grep -q 1panes  ); then
  _tmux_motd
fi
