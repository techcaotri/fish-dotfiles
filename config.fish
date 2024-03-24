if status is-interactive
    # Commands to run in interactive sessions can go here
end

function j
  set dir "$(jump cd "$argv")"
  test -d "$dir"  && cd "$dir"
end

## After the Oh-My-Fish inclusion line:
bass source /etc/profile
bass source ~/.profile

bass source ~/.config/nnn/nnn_config.sh
bass . "$HOME/.cargo/env"

eval $(jump shell)
