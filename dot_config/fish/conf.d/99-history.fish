# ===========================================
# History filtering (Fish 4.0+)
# ===========================================
# Defining this function overrides Fish's built-in filtering,
# so we must re-implement space-prefix exclusion ourselves.
# Commands excluded from history can still be recalled once with up-arrow.

function fish_should_add_to_history
    set -l cmd (string trim -- $argv[1])

    # Exclude commands starting with space (preserve default Fish behavior)
    string match -qr '^ ' -- $argv[1]; and return 1

    # Exclude very short commands (2 chars or less: ls, cd, etc.)
    test (string length -- $cmd) -le 2; and return 1

    # Exclude session management commands
    set -l ignore_cmds exit clear history reload
    set -l first_word (string split ' ' -- $cmd)[1]
    contains -- $first_word $ignore_cmds; and return 1

    return 0
end
