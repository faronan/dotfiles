function fbr --description 'Checkout git branch with fzf'
    set -l branches (git branch --all 2>/dev/null | grep -v HEAD)
    if test -z "$branches"
        echo "Not a git repository or no branches"
        return 1
    end
    set -l branch (echo $branches | fzf -d (math 2 + (count $branches)) +m)
    if test -n "$branch"
        git checkout (echo $branch | sed 's/.* //' | sed 's#remotes/[^/]*/##')
    end
end
