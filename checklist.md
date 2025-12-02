# Dotfiles 作成チェックリスト

## Phase 1: 基盤構築

- [ ] ディレクトリ構造作成
  - [ ] `.local/share/chezmoi/`
  - [ ] `dot_config/fish/conf.d/`
  - [ ] `dot_config/fish/functions/`
  - [ ] `dot_config/git/`
  - [ ] `dot_config/mise/`

- [ ] chezmoi 設定ファイル
  - [ ] `.chezmoi.toml.tmpl`
  - [ ] `.chezmoiignore`

## Phase 2: Fish Shell 設定

- [ ] メイン設定
  - [ ] `dot_config/fish/config.fish`

- [ ] conf.d/ ファイル
  - [ ] `00-xdg.fish`
  - [ ] `10-homebrew.fish`
  - [ ] `20-mise.fish`
  - [ ] `30-tools.fish`
  - [ ] `40-aliases.fish`
  - [ ] `50-uv.fish`

- [ ] functions/ ファイル
  - [ ] `mkcd.fish`
  - [ ] `proj.fish`
  - [ ] `fvim.fish`
  - [ ] `fbr.fish`

## Phase 3: Git 設定

- [ ] `dot_config/git/config.tmpl`
- [ ] `dot_config/git/ignore`

## Phase 4: その他設定

- [ ] `dot_config/mise/config.toml`
- [ ] `dot_config/starship.toml`
- [ ] `Brewfile`

## Phase 5: 実行スクリプト

- [ ] `run_once_before_00-install-homebrew.sh.tmpl`
- [ ] `run_once_before_10-install-packages.sh.tmpl`
- [ ] `run_onchange_after_configure-macos.sh.tmpl`

## Phase 6: Git リポジトリ

- [ ] `.gitignore` 作成
- [ ] `README.md` 作成
- [ ] `git init` 実行

## 検証

- [ ] ディレクトリ構造が仕様書と一致
- [ ] 全ファイルが作成済み
- [ ] Git リポジトリが初期化済み
