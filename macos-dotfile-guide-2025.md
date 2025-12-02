# macOS開発者のためのモダンdotfile・シェル設定ガイド（2025年版）

2025年後半のmacOS + Node.js/Python開発者に最適な構成を解説します。

## 推奨スタック（結論）

| カテゴリ | 推奨ツール | 備考 |
|----------|-----------|------|
| **シェル** | Zsh または Fish 4.0 | POSIX互換が必要ならZsh |
| **dotfile管理** | chezmoi | テンプレート・シークレット管理が強力 |
| **プロンプト** | Starship | Powerlevel10kはメンテナンスモード入り |
| **バージョン管理** | mise | Node.js + Python + ツール全般 |
| **Pythonパッケージ** | uv | pip/venv/pyenvを統合、超高速 |
| **CLIツール** | eza, bat, ripgrep, fd, fzf, zoxide | Rust製モダンツール群 |

---

## 目次

1. [シェル選択](#1-シェル選択)
2. [POSIX互換性について](#2-posix互換性について)
3. [dotfile管理（chezmoi）](#3-dotfile管理chezmoi)
4. [XDG Base Directory](#4-xdg-base-directory)
5. [ディレクトリ構成とファイル分割](#5-ディレクトリ構成とファイル分割)
6. [モダンシェルツール](#6-モダンシェルツール)
7. [macOS固有の設定](#7-macos固有の設定)
8. [Node.js環境（mise）](#8-nodejs環境mise)
9. [Python環境（uv + mise）](#9-python環境uv--mise)
10. [完全な設定例](#10-完全な設定例)

---

## 1. シェル選択

### Fish 4.0 vs Zsh

2025年3月にFish 4.0がRustで書き直されてリリースされました。

| 項目 | Fish 4.0 | Zsh |
|------|----------|-----|
| **起動時間** | 約2-4ms | 15-50ms（プラグイン次第） |
| **設定の手間** | ほぼ不要 | プラグイン設定が必要 |
| **自動補完** | 標準で強力 | プラグインで実現 |
| **構文ハイライト** | 標準搭載 | zsh-syntax-highlighting必要 |
| **POSIX互換** | ❌ なし | ✅ あり |
| **プラグイン** | Fisher | Oh-My-Zsh, zinit等 |

### 選択の指針

**Zshを選ぶべき場合：**
- チームで共有のシェルスクリプトを使う
- .zshrcの資産を活かしたい
- リモートサーバーとの一貫性が必要
- POSIX互換スクリプトを頻繁に書く

**Fishを選ぶべき場合：**
- 設定を最小限にしたい
- 最高のインタラクティブ体験を求める
- 主にモダンなCLIツールを使用する

### Nushellについて

Nushellはデータ処理（jq + Python的な操作）には優れていますが、v1.0未満で破壊的変更の可能性があり、メインシェルとしてはまだ時期尚早です。

---

## 2. POSIX互換性について

### POSIXとは

**POSIX（Portable Operating System Interface）** はUnix系OSの標準規格です。POSIX互換シェル（bash, zsh, sh）では、同じ構文でスクリプトが動作することが保証されています。

### スクリプトの実行方法

```bash
# 方法1: 明示的にインタプリタ指定
bash script.sh
zsh script.sh

# 方法2: 直接実行（実行権限が必要）
chmod +x script.sh
./script.sh

# 方法3: PATHに含まれていれば
script.sh
```

直接実行時は、スクリプト冒頭の **shebang（シバン）** でインタプリタが決まります：

```bash
#!/bin/bash          # bashで実行
#!/bin/sh            # shで実行
#!/usr/bin/env zsh   # zshで実行
#!/usr/bin/env fish  # fishで実行
```

### Fishの構文の違い

```bash
# === Bash/Zsh（POSIX互換） ===
if [ "$x" = "1" ]; then
  echo "yes"
fi

export PATH="/usr/local/bin:$PATH"

for file in *.txt; do
  echo "$file"
done
```

```fish
# === Fish（非互換） ===
if test "$x" = "1"
  echo "yes"
end

set -gx PATH /usr/local/bin $PATH

for file in *.txt
  echo "$file"
end
```

### 実際の影響

- ネットで見つけたシェルスクリプトの多くはbash/sh向け
- `curl ... | bash` 形式のインストーラーは問題なし（bashを明示的に呼んでいる）
- ただし、既存の.zshrc設定はそのままFishに移行できない

---

## 3. dotfile管理（chezmoi）

### なぜchezmoiか

- **GitHub スター数**: 約16,600（2025年11月時点）
- **シークレット管理**: 1Password, Bitwarden, macOSキーチェーンとネイティブ連携
- **テンプレート**: マシン別設定をGoテンプレートで記述
- **ワンライナーセットアップ**: 新マシンでの環境構築が一瞬

### 基本ワークフロー

```bash
# 初期化
chezmoi init

# 既存ファイルを管理下に追加
chezmoi add ~/.zshrc
chezmoi add ~/.config/starship.toml
chezmoi add ~/.config/git/config

# 編集
chezmoi edit ~/.zshrc

# 差分確認
chezmoi diff

# 適用
chezmoi apply

# GitHubにpush
chezmoi cd  # ソースディレクトリに移動
git add . && git commit -m "update dotfiles" && git push
```

### ディレクトリ構造とプレフィックス

chezmoiは `~/.local/share/chezmoi/` にソースを保持します：

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl          # 設定テンプレート（初回セットアップ時に質問）
├── .chezmoiignore              # 無視するファイル
├── dot_zshenv                  # → ~/.zshenv
├── dot_config/
│   ├── exact_zsh/              # exact_ = ディレクトリ内を完全同期
│   │   ├── dot_zshrc.tmpl      # → ~/.config/zsh/.zshrc
│   │   ├── aliases.zsh
│   │   └── completions.zsh
│   ├── starship.toml           # → ~/.config/starship.toml
│   ├── mise/
│   │   └── config.toml
│   └── git/
│       └── config.tmpl
├── private_dot_ssh/
│   └── config                  # → ~/.ssh/config（パーミッション600）
├── run_once_before_install-packages.sh.tmpl  # 初回のみ、apply前に実行
└── run_onchange_after_configure.sh           # 内容変更時にapply後実行
```

**プレフィックスの意味：**

| プレフィックス | 効果 |
|---------------|------|
| `dot_` | `.`（ドット）に変換 |
| `private_` | パーミッション600で作成 |
| `exact_` | ディレクトリ内のファイルを完全同期（余分なファイルを削除） |
| `run_once_` | 初回適用時のみ実行 |
| `run_onchange_` | ファイル内容変更時に実行 |
| `before_` | chezmoi apply の前に実行 |
| `after_` | chezmoi apply の後に実行 |
| `.tmpl` | Goテンプレートとして処理 |

### 設定ファイル（.chezmoi.toml.tmpl）

初回 `chezmoi init` 時に質問され、回答が保存されます：

```toml
{{- $email := promptStringOnce . "email" "メールアドレス" -}}
{{- $name := promptStringOnce . "name" "名前" -}}
{{- $isWork := promptBoolOnce . "isWork" "仕事用マシンですか？" -}}

[data]
  email = {{ $email | quote }}
  name = {{ $name | quote }}
  isWork = {{ $isWork }}

{{- if eq .chezmoi.os "darwin" }}
[onepassword]
  command = "op"
{{- end }}
```

### テンプレート例：マシン別設定

`dot_config/git/config.tmpl`:

```toml
[user]
  name = {{ .name | quote }}
  email = {{ .email | quote }}

[core]
  editor = vim

{{ if eq .chezmoi.os "darwin" -}}
[credential]
  helper = osxkeychain
{{ end -}}

{{ if .isWork -}}
[http]
  proxy = http://proxy.company.com:8080
{{ end -}}
```

### シークレット管理（1Password連携）

```toml
# dot_config/git/config.tmpl
[user]
  signingkey = {{ onepasswordRead "op://Private/GPG Key/fingerprint" | quote }}

[commit]
  gpgsign = true
```

### 新しいマシンでのセットアップ

```bash
# これだけで全環境が再現される
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

---

## 4. XDG Base Directory

### XDGとは

**XDG Base Directory Specification** は、設定ファイルやデータの保存場所を標準化する規格です。ホームディレクトリの散らかりを防ぎます。

| 変数 | 用途 | デフォルト値 |
|------|------|-------------|
| `XDG_CONFIG_HOME` | 設定ファイル | `~/.config` |
| `XDG_DATA_HOME` | データファイル | `~/.local/share` |
| `XDG_CACHE_HOME` | キャッシュ | `~/.cache` |
| `XDG_STATE_HOME` | 状態・ログ | `~/.local/state` |

### なぜmacOSで設定が必要か

Linuxでは多くのツールがXDGをサポートしていますが、**macOSではこれらの環境変数がデフォルトで設定されていません**。明示的に設定しないと、ツールごとに挙動が異なります。

### 設定方法

`~/.zshenv` に追加（最初に読み込まれるファイル）：

```bash
# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Zshの設定ディレクトリを移動
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
```

### XDG対応ツール例

設定後、以下のツールが `~/.config/` 配下を使用：

```
~/.config/
├── git/config          # ~/.gitconfig の代わり
├── mise/config.toml
├── starship.toml
├── npm/npmrc           # ~/.npmrc の代わり（要設定）
├── zsh/
│   ├── .zshrc
│   └── .zshenv
└── fish/
    └── config.fish
```

### npmをXDG対応させる

```bash
# ~/.config/npm/npmrc
prefix=${XDG_DATA_HOME}/npm
cache=${XDG_CACHE_HOME}/npm
```

```bash
# .zshrcに追加
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PATH="$XDG_DATA_HOME/npm/bin:$PATH"
```

---

## 5. ディレクトリ構成とファイル分割

### ファイル分割は今でも有効

ファイル分割は可読性・メンテナンス性の観点から**推奨**されます。

### 推奨ディレクトリ構成

```
~/.config/
├── zsh/
│   ├── .zshenv              # 環境変数（最初に読まれる）
│   ├── .zshrc               # メイン設定
│   ├── aliases.zsh          # エイリアス定義
│   ├── completions.zsh      # 補完設定
│   ├── functions.zsh        # カスタム関数
│   ├── plugins.zsh          # プラグイン設定
│   └── local.zsh            # マシン固有設定（gitignore対象）
├── git/
│   └── config
├── mise/
│   └── config.toml
├── starship.toml
└── fish/                    # Fishを使う場合
    ├── config.fish
    ├── conf.d/              # 自動読み込み
    │   ├── aliases.fish
    │   └── mise.fish
    └── functions/           # 遅延読み込み関数
        └── my_function.fish
```

### Zshでの読み込み設定

`.zshrc`:

```bash
ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# 分割ファイルを読み込み
for config in "$ZDOTDIR"/*.zsh(N); do
  source "$config"
done

# マシン固有設定（存在する場合のみ）
[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"
```

### Fishの場合

Fishは `conf.d/` 内のファイルを**自動で読み込む**ため、明示的なsourceは不要：

```
~/.config/fish/
├── config.fish           # メイン設定
├── conf.d/               # 自動読み込みディレクトリ
│   ├── aliases.fish
│   ├── mise.fish
│   └── starship.fish
└── functions/            # 関数定義（遅延読み込み）
    ├── fish_greeting.fish
    └── my_function.fish
```

---

## 6. モダンシェルツール

### プロンプト：Starship

**Powerlevel10kは2024年5月に「延命措置」モードに入りました。** 新機能追加やバグ修正が行われなくなったため、新規セットアップには**Starship**を推奨します。

```bash
# インストール
brew install starship

# .zshrcに追加
eval "$(starship init zsh)"
```

設定（`~/.config/starship.toml`）:

```toml
format = """
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$cmd_duration\
$line_break\
$character"""

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = " "

[nodejs]
symbol = " "

[python]
symbol = " "

[character]
success_symbol = "[❯](green)"
error_symbol = "[❯](red)"
```

### CLIツール置き換え

| 従来 | 代替 | インストール | 用途 |
|------|------|-------------|------|
| ls | **eza** | `brew install eza` | ファイル一覧（アイコン対応） |
| cat | **bat** | `brew install bat` | 構文ハイライト付き表示 |
| grep | **ripgrep** | `brew install ripgrep` | 高速検索、.gitignore尊重 |
| find | **fd** | `brew install fd` | 直感的なファイル検索 |
| - | **fzf** | `brew install fzf` | ファジーファインダー |
| cd | **zoxide** | `brew install zoxide` | 頻度ベースディレクトリジャンプ |
| diff | **delta** | `brew install git-delta` | Git diff表示改善 |

一括インストール：

```bash
brew install starship mise eza bat ripgrep fd fzf zoxide git-delta
```

### エイリアス設定例

```bash
# aliases.zsh
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias lt="eza --tree --icons -L 2"
alias cat="bat"
alias grep="rg"
alias find="fd"

# zoxide (cd置き換え)
eval "$(zoxide init zsh)"
alias cd="z"

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```

---

## 7. macOS固有の設定

### Apple Silicon PATH設定

Apple SiliconではHomebrewのインストール先が `/opt/homebrew` に変更されています。

`~/.zprofile` に追加：

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**注意：** macOSの `/etc/zprofile` が `path_helper` を実行し、PATHを並べ替える可能性があります。カスタムPATHは `.zshrc`（path_helper実行後）で設定するのが安全です。

### Brewfileでパッケージ管理

```bash
# 現在のインストール状態をエクスポート
brew bundle dump --describe --file=~/.dotfiles/Brewfile

# 新マシンで復元
brew bundle install --file=~/.dotfiles/Brewfile

# Brewfileにないものを削除（厳密な同期）
brew bundle cleanup --file=~/.dotfiles/Brewfile --force
```

`Brewfile` の例：

```ruby
# Taps
tap "homebrew/bundle"

# CLI tools
brew "mise"
brew "starship"
brew "eza"
brew "bat"
brew "ripgrep"
brew "fd"
brew "fzf"
brew "zoxide"
brew "git-delta"
brew "uv"
brew "gh"

# Applications
cask "visual-studio-code"
cask "warp"           # または "iterm2"
cask "docker"
cask "1password"
cask "google-chrome"

# Fonts
cask "font-hack-nerd-font"
```

### macOS固有のエイリアス

```bash
# aliases.zsh（macOS用）
alias finder="open -a Finder"
alias chrome="open -a 'Google Chrome'"
alias code="open -a 'Visual Studio Code'"

# クリップボード
alias pbp="pbpaste"
alias pbc="pbcopy"

# ネットワーク
alias ip="ipconfig getifaddr en0"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# .DS_Store削除
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
```

### iCloud同期は避ける

iCloudは隠しファイルの同期に問題があり、dotfile管理には不向きです。Git + chezmoiの組み合わせを推奨します。

---

## 8. Node.js環境（mise）

### miseとは

**mise**（旧rtx）はRust製のバージョン管理ツールで、asdfの高速な代替です。Node.js、Python、その他多くのツールを統一的に管理できます。

### インストールと初期設定

```bash
# インストール
brew install mise

# シェル統合
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc

# または Fish
echo 'mise activate fish | source' >> ~/.config/fish/config.fish
```

### 基本的な使い方

```bash
# Node.jsインストール
mise use --global node@lts    # グローバルデフォルト
mise use node@20              # カレントディレクトリ用

# 利用可能なバージョン確認
mise ls-remote node

# インストール済み確認
mise ls
```

### プロジェクト設定

`.mise.toml`（プロジェクトルートに配置）：

```toml
[tools]
node = "20"

[env]
NODE_ENV = "development"
```

### .nvmrcからの移行

miseは `.nvmrc` と `.node-version` を自動認識するため、既存プロジェクトでもそのまま動作します。

---

## 9. Python環境（uv + mise）

### uvとは

**uv**はRust製の超高速Pythonパッケージマネージャーです。pip、venv、pyenv、poetry、pipxの機能を統合し、10-100倍高速に動作します。

### インストール

```bash
# Homebrewで（推奨）
brew install uv

# または公式インストーラー
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### mise + uv の推奨構成

miseでPythonバージョン管理、uvでパッケージ管理：

`~/.config/mise/config.toml`:

```toml
[tools]
node = "lts"
python = "3.12"
uv = "latest"
```

### uvの基本的な使い方

```bash
# === プロジェクト管理 ===
# 新規プロジェクト作成
uv init my-project
cd my-project

# 依存関係追加
uv add requests fastapi
uv add --dev pytest ruff mypy

# lockファイルから環境を再現
uv sync

# スクリプト実行（venv自動作成・有効化）
uv run python main.py
uv run pytest

# === 既存プロジェクトの移行 ===
# requirements.txtから
uv add -r requirements.txt

# === Pythonバージョン管理（uv単体でも可能） ===
uv python install 3.12
uv python install 3.11
uv python list
uv python pin 3.12
```

### プロジェクト設定

`pyproject.toml`（uv initで自動生成）:

```toml
[project]
name = "my-project"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = [
    "fastapi>=0.115.0",
    "requests>=2.32.0",
]

[dependency-groups]
dev = [
    "mypy>=1.13.0",
    "pytest>=8.3.0",
    "ruff>=0.8.0",
]

[tool.ruff]
line-length = 100

[tool.mypy]
strict = true
```

### mise + uvの自動venv設定

プロジェクトの `.mise.toml`:

```toml
[tools]
python = "3.12"

[env]
# ディレクトリに入ると自動でvenv作成・有効化
_.python.venv = { path = ".venv", create = true }
```

### シェル設定

```bash
# === .zshrc または aliases.zsh ===

# uvの補完
eval "$(uv generate-shell-completion zsh)"

# pipの代わりにuvを使用
alias pip="uv pip"
alias pip3="uv pip"

# 便利なエイリアス
alias uvr="uv run"
alias uvs="uv sync"
alias uva="uv add"
```

### 推奨ワークフロー

```bash
# 1. 新規プロジェクト
uv init my-app
cd my-app

# 2. Pythonバージョン固定
uv python pin 3.12

# 3. 依存追加
uv add fastapi uvicorn
uv add --dev pytest ruff mypy

# 4. 開発
uv run uvicorn main:app --reload

# 5. テスト・リント
uv run pytest
uv run ruff check .
uv run mypy .

# 6. チームメンバーはclone後に
uv sync  # pyproject.toml + uv.lock から環境再現
```

---

## 10. 完全な設定例

### ディレクトリ構造

```
~/.config/
├── zsh/
│   ├── .zshenv
│   ├── .zshrc
│   ├── aliases.zsh
│   ├── completions.zsh
│   └── functions.zsh
├── git/
│   └── config
├── mise/
│   └── config.toml
└── starship.toml

~/.local/share/chezmoi/    # chezmoiソース
├── .chezmoi.toml.tmpl
├── dot_zshenv
├── dot_config/
│   ├── zsh/
│   │   ├── dot_zshrc.tmpl
│   │   ├── aliases.zsh
│   │   ├── completions.zsh
│   │   └── functions.zsh
│   ├── git/
│   │   └── config.tmpl
│   ├── mise/
│   │   └── config.toml
│   └── starship.toml
├── Brewfile
└── run_once_before_install.sh.tmpl
```

### ~/.zshenv

```bash
# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Zsh設定ディレクトリ
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# エディタ
export EDITOR="vim"
export VISUAL="code"
```

### ~/.config/zsh/.zshrc

```bash
# ===========================================
# Homebrew (Apple Silicon)
# ===========================================
eval "$(/opt/homebrew/bin/brew shellenv)"

# ===========================================
# ツール初期化
# ===========================================
# Starship prompt
eval "$(starship init zsh)"

# mise (Node.js, Python, etc.)
eval "$(mise activate zsh)"

# zoxide (smarter cd)
eval "$(zoxide init zsh)"

# fzf
source <(fzf --zsh)

# uv completion
eval "$(uv generate-shell-completion zsh)"

# ===========================================
# 分割設定ファイル読み込み
# ===========================================
for config in "$ZDOTDIR"/*.zsh(N); do
  source "$config"
done

# ===========================================
# ローカル設定（gitignore対象）
# ===========================================
[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"
```

### ~/.config/zsh/aliases.zsh

```bash
# ===========================================
# モダンCLIツール
# ===========================================
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"
alias lt="eza --tree --icons -L 2"
alias cat="bat"
alias grep="rg"
alias find="fd"
alias diff="delta"

# zoxide
alias cd="z"
alias cdi="zi"  # インタラクティブ選択

# ===========================================
# Git
# ===========================================
alias g="git"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gs="git status"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# ===========================================
# Python / uv
# ===========================================
alias pip="uv pip"
alias pip3="uv pip"
alias uvr="uv run"
alias uvs="uv sync"
alias uva="uv add"
alias python="uv run python"
alias pytest="uv run pytest"

# ===========================================
# Node.js
# ===========================================
alias pn="pnpm"
alias ni="npm install"
alias nr="npm run"

# ===========================================
# macOS固有
# ===========================================
alias finder="open -a Finder"
alias chrome="open -a 'Google Chrome'"
alias code="open -a 'Visual Studio Code'"
alias ip="ipconfig getifaddr en0"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# ===========================================
# その他
# ===========================================
alias reload="source $ZDOTDIR/.zshrc"
alias path='echo -e ${PATH//:/\\n}'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
```

### ~/.config/zsh/functions.zsh

```bash
# ディレクトリ作成して移動
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# fzfでgit branchを選択してcheckout
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" | fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fzfでファイルを選択してvimで開く
fvim() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
  [[ -n "$file" ]] && vim "$file"
}

# プロジェクトディレクトリに移動
proj() {
  local dir
  dir=$(fd --type d --max-depth 2 . ~/Projects | fzf)
  [[ -n "$dir" ]] && cd "$dir"
}
```

### ~/.config/zsh/completions.zsh

```bash
# 補完システム初期化
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# 補完オプション
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'

# キャッシュ
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
```

### ~/.config/mise/config.toml

```toml
[tools]
node = "lts"
python = "3.12"
uv = "latest"

[settings]
experimental = true
```

### ~/.config/starship.toml

```toml
format = """
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$cmd_duration\
$line_break\
$character"""

[directory]
truncation_length = 3
truncate_to_repo = true
style = "bold cyan"

[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "bold red"

[nodejs]
symbol = " "
style = "bold green"

[python]
symbol = " "
style = "bold yellow"

[cmd_duration]
min_time = 2_000
style = "bold yellow"

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
```

### ~/.config/git/config

```toml
[user]
  name = Your Name
  email = your.email@example.com

[core]
  editor = vim
  pager = delta
  excludesfile = ~/.config/git/ignore

[init]
  defaultBranch = main

[pull]
  rebase = true

[push]
  autoSetupRemote = true

[fetch]
  prune = true

[diff]
  colorMoved = default

[merge]
  conflictstyle = diff3

[delta]
  navigate = true
  side-by-side = true
  line-numbers = true

[alias]
  st = status
  co = checkout
  br = branch
  ci = commit
  unstage = reset HEAD --
  last = log -1 HEAD
  graph = log --graph --oneline --decorate --all

[credential]
  helper = osxkeychain
```

### Brewfile

```ruby
# Taps
tap "homebrew/bundle"

# === Development Tools ===
brew "mise"
brew "uv"
brew "gh"

# === Shell & Prompt ===
brew "starship"
brew "zsh-completions"

# === Modern CLI Tools ===
brew "eza"
brew "bat"
brew "ripgrep"
brew "fd"
brew "fzf"
brew "zoxide"
brew "git-delta"
brew "jq"
brew "yq"
brew "httpie"

# === Applications ===
cask "visual-studio-code"
cask "warp"
cask "docker"
cask "1password"
cask "google-chrome"
cask "slack"
cask "notion"

# === Fonts ===
cask "font-hack-nerd-font"
cask "font-fira-code-nerd-font"
```

---

## クイックスタート

新しいMacをセットアップする場合：

```bash
# 1. Homebrewインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. chezmoiでdotfilesを適用
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME

# 3. Brewfileからパッケージインストール
brew bundle install --file=~/.dotfiles/Brewfile

# 4. シェル再起動
exec zsh
```

これで完全な開発環境が再現されます。

---

## 参考リンク

- [chezmoi公式ドキュメント](https://www.chezmoi.io/)
- [mise公式ドキュメント](https://mise.jdx.dev/)
- [uv公式ドキュメント](https://docs.astral.sh/uv/)
- [Starship公式](https://starship.rs/)
- [Fish Shell](https://fishshell.com/)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
