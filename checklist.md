# Dotfiles 作成チェックリスト

## Phase 1: 基盤構築

- [x] ディレクトリ構造作成
  - [x] `.local/share/chezmoi/`
  - [x] `dot_config/fish/conf.d/`
  - [x] `dot_config/fish/functions/`
  - [x] `dot_config/git/`
  - [x] `dot_config/mise/`

- [x] chezmoi 設定ファイル
  - [x] `.chezmoi.toml.tmpl`
  - [x] `.chezmoiignore`

## Phase 2: Fish Shell 設定

- [x] メイン設定
  - [x] `dot_config/fish/config.fish`

- [x] conf.d/ ファイル
  - [x] `00-xdg.fish`
  - [x] `10-homebrew.fish`
  - [x] `20-mise.fish`
  - [x] `30-tools.fish`
  - [x] `40-aliases.fish`
  - [x] `50-uv.fish`

- [x] functions/ ファイル
  - [x] `mkcd.fish`
  - [x] `proj.fish`
  - [x] `fvim.fish`
  - [x] `fbr.fish`

## Phase 3: Git 設定

- [x] `dot_config/git/config.tmpl`
- [x] `dot_config/git/ignore`

## Phase 4: その他設定

- [x] `dot_config/mise/config.toml`
- [x] `dot_config/starship.toml`
- [x] `Brewfile`

## Phase 5: 実行スクリプト

- [x] `run_once_before_00-install-homebrew.sh.tmpl`
- [x] `run_once_before_10-install-packages.sh.tmpl`
- [x] `run_onchange_after_configure-macos.sh.tmpl`

## Phase 6: Git リポジトリ

- [x] `git init` 実行
- [ ] `.gitignore` 作成
- [ ] `README.md` 作成

## 検証

- [ ] ディレクトリ構造が仕様書と一致
- [ ] 全ファイルが作成済み
- [x] Git リポジトリが初期化済み
