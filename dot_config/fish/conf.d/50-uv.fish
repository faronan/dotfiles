# uv (Python package manager)
if type -q uv
    # 補完
    uv generate-shell-completion fish | source

    # エイリアス
    alias pip 'uv pip'
    alias pip3 'uv pip'
    alias uvr 'uv run'
    alias uvs 'uv sync'
    alias uva 'uv add'
    alias python 'uv run python'
    alias pytest 'uv run pytest'
end
