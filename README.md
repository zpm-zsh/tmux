# Zsh plugin for Tmux

Small plugin for Tmux. It will setup TERM variable, will start tmux automaticaliy
if you logined via SSH and show motd in first window.

Autostart can be disabled (or enabled on local host) by setting the variable `TMUX_AUTOSTART=false`  
Motd can be disabled `TMUX_MOTD=false`

### Example

```sh
PROMPT='$pr_node ...REST OF PROMPT'
```

This plugin made to be fast. It runs in background and update information only if need.

## Installation

### This plugin depends on [helpers](https://github.com/zpm-zsh/helpers)

### If you use [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

* Clone this repository into `~/.oh-my-zsh/custom/plugins`
```sh
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zpm-zsh/pr-node
```
* After that, add `pr-node` to your oh-my-zsh plugins array.

### If you use [Zgen](https://github.com/tarjoilija/zgen)

1. Add `zgen load zpm-zsh/pr-node` to your `.zshrc` with your other plugin
2. run `zgen save`

### If you use my [ZPM](https://github.com/zpm-zsh/zpm)

* Add `zpm load zpm-zsh/pr-node` into your `.zshrc`