if status is-interactive
    # Commands to run in interactive sessions can go here
  atuin init fish | source
end

function j
  set dir "$(jump cd "$argv")"
  test -d "$dir"  && cd "$dir"
end

# Set color theme to "cappucin-mocha"
set -g theme_color_scheme catpuccin-mocha

zoxide init fish | source

## After the Oh-My-Fish inclusion line:
test -f /etc/lsb-release && bass source /etc/profile
export MY_FISH_SHELL="true"
bass source ~/.profile

bass source ~/.config/nnn/nnn_config.sh
bass . "$HOME/.cargo/env"

eval $(jump shell)

eval $(tmux set default-shell /usr/bin/fish)
eval $(tmux set default-command /usr/bin/fish)

## tmux.fish default configuration
# fish_tmux_default_session_name main_fish

# Don't auto-connect to Tmux
set -Ux fish_tmux_autoconnect false
set -Ux fish_tmux_autostart false

set --universal nvm_default_version v22.17.1

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish

# Support sdkman.io sdk command copied from https://github.com/sdkman/sdkman-cli/issues/294#issuecomment-241680772
function sdk
  bass source ~/.sdkman/bin/sdkman-init.sh --no-use ';' sdk $argv
end

# bind to ctrl-r in normal and insert mode, add any other bindings you want here too
bind \cr _atuin_search
bind -M insert \cr _atuin_search

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/tripham/miniconda3/bin/conda
    eval /home/tripham/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/tripham/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/tripham/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/tripham/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

function _clipy_history
  set clipy_output $(clipy history --tmux)  
  commandline -a "$clipy_output"
  commandline -C 9999 # Move cursor to the end of the line
end

# Bind the function to Ctrl+j
bind  \e\cf _clipy_history
bind -M insert \e\cf _clipy_history

# Add config for navi
navi widget fish | source
