if status is-interactive
    # Commands to run in interactive sessions can go here
end

function j
  set dir "$(jump cd "$argv")"
  test -d "$dir"  && cd "$dir"
end

zoxide init fish | source

## After the Oh-My-Fish inclusion line:
bass source /etc/profile
bass source ~/.profile

bass source ~/.config/nnn/nnn_config.sh
bass . "$HOME/.cargo/env"

eval $(jump shell)

eval $(tmux set default-shell /bin/bash)
eval $(tmux set default-command /usr/bin/fish)

## tmux.fish default configuration
# fish_tmux_default_session_name main_fish

# Don't auto-connect to Tmux
set -Ux fish_tmux_autoconnect false
set -Ux fish_tmux_autostart false

set --universal nvm_default_version v20.11.1

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish
