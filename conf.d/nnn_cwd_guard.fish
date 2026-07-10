# nnn_cwd_guard.fish -- guard against a working directory that was moved out
# from under this shell (full analysis: nnn repo docs/nnn_Problems_And_Solutions.md).
#
# Problem: deleting a directory you are cd'd into (nnn `x` with NNN_TRASH=1 runs
# trash-put, which *moves* the dir to ~/.local/share/Trash/files/). The kernel
# working directory silently follows the moved inode into the Trash, while
# `pwd` / `prompt_pwd` keep showing the (recreated) original path -- so files
# you create afterwards land in the Trash unnoticed.
#
# Fix: before each prompt, compare the inode this shell is actually in against
# the inode that $PWD names. If they differ, warn and (by default) re-attach to
# $PWD (re-resolving the logical path to the current directory there).
#
#   set -Ux NNN_CWD_GUARD 0          # disable the guard entirely
#   set -Ux NNN_CWD_GUARD_AUTOCD 0   # warn only, do NOT auto re-attach

function __nnn_cwd_guard --on-event fish_prompt \
        --description 'Detect/repair a working directory displaced into the Trash'
    test "$NNN_CWD_GUARD" = 0; and return

    # device:inode this shell is really in, vs. what $PWD resolves to.
    # stat -L makes the comparison symlink-safe (no false positive on symlinked
    # directories, where $PWD keeps the symlink path but . is the target).
    set -l cur (command stat -c '%d:%i' -- . 2>/dev/null)
    test -n "$cur"; or return
    set -l logical (command stat -Lc '%d:%i' -- "$PWD" 2>/dev/null)
    test "$cur" = "$logical"; and return   # CWD matches $PWD -> nothing to do

    set -l here (env pwd -P 2>/dev/null)   # real getcwd (not the stale builtin)
    switch "$here"
        case "*/.local/share/Trash/*" "*/.Trash-*/*"
            echo "[cwd-guard] Warning: this shell is physically inside the Trash:" >&2
            echo "            $here" >&2
        case "*"
            echo "[cwd-guard] Warning: working directory was moved/replaced under this shell (real: $here)" >&2
    end

    if test -d "$PWD"; and test "$NNN_CWD_GUARD_AUTOCD" != 0
        if builtin cd -- "$PWD" 2>/dev/null
            echo "[cwd-guard] re-attached to $PWD" >&2
        end
    else if not test -d "$PWD"
        echo "[cwd-guard] its original path no longer exists: $PWD" >&2
    end
end
