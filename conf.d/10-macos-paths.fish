# Use as ~/.config/fish/conf.d/10-macos-paths.fish
# Avoid duplicating fzf/OMF initialization here; preserve your existing plugins.
if test (uname) = Darwin
    fish_add_path --path /opt/homebrew/bin /opt/homebrew/sbin
    fish_add_path --path "$HOME/.cargo/bin" "$HOME/.local/bin"
end
