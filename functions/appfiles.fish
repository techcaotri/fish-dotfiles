function appfiles --description 'List installed applications with aligned desktop file paths'
    set -l dirs
    
    for dir in \
                $HOME/.local/share/applications \
                /usr/share/applications \
                /usr/local/share/applications \
                /var/lib/snapd/desktop/applications \
                /var/lib/flatpak/exports/share/applications \
                $HOME/.local/share/flatpak/exports/share/applications
    
        if test -d "$dir"
            set -a dirs "$dir"
        end
    end
    
    if test (count $dirs) -eq 0
        return
    end
    
    find $dirs -type f -name '*.desktop' -exec awk '
        FNR == 1 { in_desktop = 0 }
        /^\[Desktop Entry\]\r?$/ { in_desktop = 1; next }
        /^\[/ { in_desktop = 0 }
        in_desktop && /^Name=/ {
            name = substr($0, 6)
            sub(/\r$/, "", name)
            printf "%s\t%s\n", name, FILENAME
            nextfile
        }
    ' '{}' + 2>/dev/null |
        sort -f |
        column -t -s (printf '\t')
end
