# Socket Firewall (sfw) - supply chain attack protection
# npm/pnpm/yarn/uv のインストール時にマルウェアをブロック
# 注: pip は 50-uv.fish で uv pip にエイリアス済み → uv 経由で保護される
if type -q sfw
    alias npm 'sfw npm'
    alias npx 'sfw npx'
    alias pnpm 'sfw pnpm'
    alias yarn 'sfw yarn'
    alias uv 'sfw uv'
end
