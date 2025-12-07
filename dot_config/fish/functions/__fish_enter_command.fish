# ===========================================
# Enter key handler
# Show ls + git status on empty command line
# ===========================================

function __fish_enter_command
    set -l cmd (commandline)

    if test -z "$cmd"
        # Empty line: show ls + git status
        echo
        __show_ls

        # Show git status if in a git repository
        if git rev-parse --git-dir >/dev/null 2>&1
            echo
            git status -sb
        end

        echo
    else
        # Execute the command
        commandline -f execute
    end
end
