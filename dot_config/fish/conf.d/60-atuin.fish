# Atuin - Shell history
# --disable-up-arrow: 上矢印キーを奪わない（通常の履歴操作を維持）
if not status is-interactive
    return
end

if command -q atuin
    atuin init fish --disable-up-arrow | source

    # _atuin_postexecが$statusを上書きするため、sponge等の後続ハンドラ用に復元する
    function _atuin_postexec --on-event fish_postexec
        set -l s $status
        if test -n "$ATUIN_HISTORY_ID"
            ATUIN_LOG=error atuin history end --exit $s -- $ATUIN_HISTORY_ID &>/dev/null &
            disown
        end
        set --erase ATUIN_HISTORY_ID
        return $s
    end
end
