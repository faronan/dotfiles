# Atuin - Shell history
# --disable-up-arrow: 上矢印キーを奪わない（通常の履歴操作を維持）
if command -q atuin
    atuin init fish --disable-up-arrow | source
end
