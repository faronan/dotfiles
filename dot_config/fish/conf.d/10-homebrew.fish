# Homebrew (Apple Silicon)
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# mise/uv 管理対象を brew で誤導入させない
set -gx HOMEBREW_FORBIDDEN_FORMULAE "node python python3 pip npm pnpm yarn bun ruff uv claude"
