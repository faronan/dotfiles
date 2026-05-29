# uv (Python package manager)
if type -q uv
    # 補完
    if status is-interactive
        uv generate-shell-completion fish | source
    end

    # エイリアス
    alias pip 'uv pip'
    alias pip3 'uv pip'
    alias uvr 'uv run'
    alias uvs 'uv sync'
    alias uva 'uv add'
    alias pytest 'uv run pytest'
end
