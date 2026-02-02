function gbase --description 'Switch to base branch and pull'
    # origin/HEAD からデフォルトブランチを検出
    set -l branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | string replace 'refs/remotes/origin/' '')

    # フォールバック: ローカルブランチから検出
    if test -z "$branch"
        for b in main master staging develop
            if git show-ref --verify --quiet refs/heads/$b
                set branch $b
                break
            end
        end
    end

    if test -z "$branch"
        echo "Error: デフォルトブランチを検出できません"
        return 1
    end

    echo "→ $branch"
    git switch $branch && git pull origin $branch
end
