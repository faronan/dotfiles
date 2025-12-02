# Dotfiles開発仕様書（Claude Code向け）

## 概要

macOS + Fish Shell環境のdotfilesをchezmoiで管理する構成を開発する。

## 技術スタック

| カテゴリ | ツール | バージョン |
|----------|--------|-----------|
| シェル | Fish Shell | 4.0+ |
| dotfile管理 | chezmoi | latest |
| プロンプト | Starship | latest |
| バージョン管理 | mise | latest |
| Pythonパッケージ | uv | latest |
| CLIツール | eza, bat, ripgrep, fd, fzf, zoxide, delta | latest |

## ディレクトリ構成

### 最終的なホームディレクトリ構成（chezmoi apply後）

```
~/
├── .config/
│   ├── fish/
│   │   ├── config.fish              # メイン設定
│   │   ├── conf.d/                  # 自動読み込み（アルファベット順）
│   │   │   ├── 00-xdg.fish          # XDG環境変数
│   │   │   ├── 10-homebrew.fish     # Homebrew PATH
│   │   │   ├── 20-mise.fish         # mise初期化
│   │   │   ├── 30-tools.fish        # zoxide, fzf等
│   │   │   ├── 40-aliases.fish      # エイリアス
│   │   │   └── 50-uv.fish           # uv設定
│   │   └── functions/               # カスタム関数（遅延読み込み）
│   │       ├── mkcd.fish
│   │       ├── proj.fish
│   │       └── fvim.fish
│   ├── git/
│   │   ├── config
│   │   └── ignore
│   ├── mise/
│   │   └── config.toml
│   └── starship.toml
├── .local/
│   └── share/
│       └── chezmoi/                 # chezmoiソース（後述）
└── Brewfile
```

### chezmoiソースディレクトリ構成

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl               # chezmoi設定テンプレート
├── .chezmoiignore                   # 無視ファイル
├── dot_config/
│   ├── fish/
│   │   ├── config.fish
│   │   ├── conf.d/
│   │   │   ├── 00-xdg.fish
│   │   │   ├── 10-homebrew.fish
│   │   │   ├── 20-mise.fish
│   │   │   ├── 30-tools.fish
│   │   │   ├── 40-aliases.fish
│   │   │   └── 50-uv.fish
│   │   └── functions/
│   │       ├── mkcd.fish
│   │       ├── proj.fish
│   │       └── fvim.fish
│   ├── git/
│   │   ├── config.tmpl              # テンプレート（.tmpl拡張子）
│   │   └── ignore
│   ├── mise/
│   │   └── config.toml
│   └── starship.toml
├── Brewfile
├── run_once_before_00-install-homebrew.sh.tmpl
├── run_once_before_10-install-packages.sh.tmpl
└── run_onchange_after_configure-macos.sh.tmpl
```

---

## chezmoiファイル命名規則

| プレフィックス | 効果 | 例 |
|---------------|------|-----|
| `dot_` | `.`に変換 | `dot_config/` → `.config/` |
| `private_` | パーミッション600 | `private_dot_ssh/` |
| `exact_` | ディレクトリ完全同期 | `exact_dot_config/` |
| `run_once_` | 初回のみ実行 | `run_once_install.sh` |
| `run_onchange_` | 内容変更時に実行 | `run_onchange_setup.sh` |
| `before_` | apply前に実行 | `run_once_before_install.sh` |
| `after_` | apply後に実行 | `run_onchange_after_setup.sh` |
| `.tmpl` | Goテンプレート処理 | `config.tmpl` |

**実行順序**: `before_` → ファイル配置 → `after_`  
**ファイル名順**: 数字プレフィックスで制御（`00-`, `10-`, `20-`...）

---

## 設定ファイル内容

### .chezmoi.toml.tmpl

```toml
{{- $name := promptStringOnce . "name" "名前（Git用）" -}}
{{- $email := promptStringOnce . "email" "メールアドレス" -}}
{{- $isWork := promptBoolOnce . "isWork" "仕事用マシンですか？ (y/n)" -}}

[data]
  name = {{ $name | quote }}
  email = {{ $email | quote }}
  isWork = {{ $isWork }}

[edit]
  command = "code"
  args = ["--wait"]
```

### .chezmoiignore

```
README.md
LICENSE
.git/
.gitignore

# OS固有ファイルを除外
{{- if ne .chezmoi.os "darwin" }}
Brewfile
run_once_before_00-install-homebrew.sh.tmpl
run_onchange_after_configure-macos.sh.tmpl
{{- end }}
```

---

### Fish設定ファイル

#### dot_config/fish/config.fish

```fish
# ===========================================
# Fish Shell Configuration
# ===========================================
# conf.d/ 内のファイルは自動で読み込まれる
# このファイルは最後に読み込まれる

# インタラクティブシェルのみ
if not status is-interactive
    return
end

# 挨拶メッセージを無効化
set -g fish_greeting

# Starship prompt
starship init fish | source
```

#### dot_config/fish/conf.d/00-xdg.fish

```fish
# XDG Base Directory
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_STATE_HOME $HOME/.local/state

# エディタ
set -gx EDITOR vim
set -gx VISUAL code
```

#### dot_config/fish/conf.d/10-homebrew.fish

```fish
# Homebrew (Apple Silicon)
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end
```

#### dot_config/fish/conf.d/20-mise.fish

```fish
# mise (Node.js, Python, etc.)
if type -q mise
    mise activate fish | source
end
```

#### dot_config/fish/conf.d/30-tools.fish

```fish
# zoxide (smarter cd)
if type -q zoxide
    zoxide init fish | source
end

# fzf
if type -q fzf
    fzf --fish | source
end

# fzf設定
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
```

#### dot_config/fish/conf.d/40-aliases.fish

```fish
# ===========================================
# モダンCLIツール
# ===========================================
if type -q eza
    alias ls 'eza --icons --group-directories-first'
    alias ll 'eza -la --icons --group-directories-first --git'
    alias lt 'eza --tree --icons -L 2'
    alias la 'eza -a --icons --group-directories-first'
end

if type -q bat
    alias cat 'bat'
end

if type -q rg
    alias grep 'rg'
end

if type -q fd
    alias find 'fd'
end

if type -q delta
    alias diff 'delta'
end

# zoxide
if type -q zoxide
    alias cd 'z'
    alias cdi 'zi'
end

# ===========================================
# Git
# ===========================================
alias g 'git'
alias ga 'git add'
alias gc 'git commit'
alias gp 'git push'
alias gl 'git pull'
alias gs 'git status'
alias gd 'git diff'
alias gco 'git checkout'
alias gb 'git branch'
alias glog 'git log --oneline --graph --decorate'

# ===========================================
# Node.js
# ===========================================
alias pn 'pnpm'
alias ni 'npm install'
alias nr 'npm run'

# ===========================================
# macOS固有
# ===========================================
alias finder 'open -a Finder'
alias chrome 'open -a "Google Chrome"'
alias code 'open -a "Visual Studio Code"'
alias ip 'ipconfig getifaddr en0'
alias flushdns 'sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias cleanup 'find . -type f -name "*.DS_Store" -ls -delete'

# ===========================================
# その他
# ===========================================
alias reload 'source ~/.config/fish/config.fish'
alias path 'echo $PATH | tr " " "\n"'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
```

#### dot_config/fish/conf.d/50-uv.fish

```fish
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
```

---

### Fish関数ファイル

#### dot_config/fish/functions/mkcd.fish

```fish
function mkcd --description 'Create directory and cd into it'
    mkdir -p $argv[1] && cd $argv[1]
end
```

#### dot_config/fish/functions/proj.fish

```fish
function proj --description 'Jump to project directory with fzf'
    set -l dir (fd --type d --max-depth 2 . ~/Projects 2>/dev/null | fzf)
    if test -n "$dir"
        cd $dir
    end
end
```

#### dot_config/fish/functions/fvim.fish

```fish
function fvim --description 'Open file in vim with fzf'
    set -l file (fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
    if test -n "$file"
        vim $file
    end
end
```

#### dot_config/fish/functions/fbr.fish

```fish
function fbr --description 'Checkout git branch with fzf'
    set -l branches (git branch --all 2>/dev/null | grep -v HEAD)
    if test -z "$branches"
        echo "Not a git repository or no branches"
        return 1
    end
    set -l branch (echo $branches | fzf -d (math 2 + (count $branches)) +m)
    if test -n "$branch"
        git checkout (echo $branch | sed 's/.* //' | sed 's#remotes/[^/]*/##')
    end
end
```

---

### Git設定

#### dot_config/git/config.tmpl

```toml
[user]
  name = {{ .name | quote }}
  email = {{ .email | quote }}

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

{{ if eq .chezmoi.os "darwin" -}}
[credential]
  helper = osxkeychain
{{ end -}}

{{ if .isWork -}}
# 仕事用マシン固有設定
[http]
  # proxy = http://proxy.company.com:8080
{{ end -}}
```

#### dot_config/git/ignore

```
# macOS
.DS_Store
.AppleDouble
.LSOverride
._*

# Editors
*.swp
*.swo
*~
.idea/
.vscode/
*.sublime-*

# Environment
.env
.env.local
.env.*.local

# Dependencies
node_modules/
__pycache__/
*.pyc
.venv/
venv/
```

---

### mise設定

#### dot_config/mise/config.toml

```toml
[tools]
node = "lts"
python = "3.12"
uv = "latest"

[settings]
experimental = true
```

---

### Starship設定

#### dot_config/starship.toml

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
format = '([\[$all_status$ahead_behind\]]($style) )'

[nodejs]
symbol = " "
style = "bold green"
format = "[$symbol($version )]($style)"

[python]
symbol = " "
style = "bold yellow"
format = "[$symbol($version )]($style)"

[cmd_duration]
min_time = 2_000
style = "bold yellow"
format = "[$duration]($style) "

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
```

---

### Brewfile

```ruby
# Taps
tap "homebrew/bundle"

# === Shell ===
brew "fish"
brew "starship"

# === Development Tools ===
brew "mise"
brew "uv"
brew "gh"

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

### 実行スクリプト

#### run_once_before_00-install-homebrew.sh.tmpl

```bash
#!/bin/bash
{{ if eq .chezmoi.os "darwin" -}}
# Homebrewがなければインストール
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
{{ end -}}
```

#### run_once_before_10-install-packages.sh.tmpl

```bash
#!/bin/bash
{{ if eq .chezmoi.os "darwin" -}}
# Homebrew PATHを設定
eval "$(/opt/homebrew/bin/brew shellenv)"

# Brewfileからインストール
if [ -f "{{ .chezmoi.sourceDir }}/Brewfile" ]; then
    echo "Installing packages from Brewfile..."
    brew bundle install --file="{{ .chezmoi.sourceDir }}/Brewfile" --no-lock
fi
{{ end -}}
```

#### run_onchange_after_configure-macos.sh.tmpl

```bash
#!/bin/bash
{{ if eq .chezmoi.os "darwin" -}}
# Fishをデフォルトシェルに設定
FISH_PATH="/opt/homebrew/bin/fish"

if [ -x "$FISH_PATH" ]; then
    # /etc/shellsに追加されていなければ追加
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "Adding Fish to /etc/shells..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells
    fi
    
    # デフォルトシェルがFishでなければ変更
    if [ "$SHELL" != "$FISH_PATH" ]; then
        echo "Setting Fish as default shell..."
        chsh -s "$FISH_PATH"
    fi
fi

# mise初期設定
if command -v mise &> /dev/null; then
    echo "Installing mise tools..."
    mise install
fi
{{ end -}}
```

---

## セットアップ手順

### 新規マシンでのセットアップ（完全自動）

```bash
# これだけで完了
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

### 手動セットアップ（開発・テスト用）

```bash
# 1. Homebrewインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. chezmoiインストール
brew install chezmoi

# 3. dotfilesリポジトリをclone
chezmoi init YOUR_GITHUB_USERNAME
# または既存リポジトリを使用
chezmoi init --source=/path/to/dotfiles

# 4. 差分確認
chezmoi diff

# 5. 適用
chezmoi apply

# 6. シェル再起動
exec fish
```

### 開発中のワークフロー

```bash
# ファイル編集
chezmoi edit ~/.config/fish/config.fish

# 差分確認
chezmoi diff

# 適用
chezmoi apply

# ソースディレクトリに移動してgit操作
chezmoi cd
git add .
git commit -m "update fish config"
git push
```

---

## 開発時の注意点

### 1. Fish構文の特徴

```fish
# 変数設定（exportの代わり）
set -gx VARIABLE "value"    # グローバル + export
set -g VARIABLE "value"     # グローバル（export無し）
set -l VARIABLE "value"     # ローカル

# 条件分岐
if test -f /path/to/file
    echo "exists"
else if test -d /path/to/dir
    echo "is directory"
else
    echo "not found"
end

# ループ
for file in *.fish
    echo $file
end

# コマンド存在チェック
if type -q mise
    # miseが存在する場合
end

# コマンド置換
set result (command arg1 arg2)

# パイプ結果の変数代入
command | read -l variable
```

### 2. conf.d/の読み込み順序

- ファイル名のアルファベット順で読み込まれる
- 数字プレフィックス（00-, 10-, 20-...）で順序制御
- 依存関係がある場合は順序に注意

### 3. functions/の遅延読み込み

- `~/.config/fish/functions/`内の関数は初回呼び出し時に読み込まれる
- ファイル名と関数名を一致させる必要あり（`mkcd.fish`内に`function mkcd`）

### 4. chezmoiテンプレート内でのGoテンプレート構文

```go
// 変数展開
{{ .name }}
{{ .email | quote }}

// 条件分岐
{{ if eq .chezmoi.os "darwin" -}}
macOS用の内容
{{ end -}}

// 条件分岐（複数条件）
{{ if and (eq .chezmoi.os "darwin") .isWork -}}
macOS + 仕事用
{{ end -}}

// 空白制御（-で前後の空白を削除）
{{- .variable -}}
```

---

## テスト項目

セットアップ後に確認すべき項目：

```fish
# シェルがFishになっているか
echo $SHELL
# → /opt/homebrew/bin/fish

# Starshipが動作しているか
# → プロンプトが正しく表示される

# miseが動作しているか
mise doctor
mise ls

# Node.jsが使えるか
node --version
npm --version

# Pythonが使えるか
python --version
uv --version

# uvでプロジェクト作成できるか
cd /tmp
uv init test-project
cd test-project
uv add requests
uv run python -c "import requests; print('OK')"

# CLIツールが使えるか
eza --version
bat --version
rg --version
fd --version
fzf --version
zoxide --version
delta --version

# zoxideが動作するか
z ~
zi  # インタラクティブ選択

# fzf統合が動作するか
# Ctrl+T, Ctrl+R で確認
```

---

## トラブルシューティング

### Fishで既存bashスクリプトを実行

```fish
# 明示的にbashで実行
bash /path/to/script.sh

# または実行権限があれば直接（shebangで判断）
./script.sh
```

### PATHが正しく設定されない

```fish
# 現在のPATHを確認
echo $PATH | tr " " "\n"

# fish_user_pathsを確認
echo $fish_user_paths

# PATHに追加（永続化）
fish_add_path /opt/homebrew/bin
```

### miseが反映されない

```fish
# シェル再起動
exec fish

# または手動でアクティベート
mise activate fish | source
```

### chezmoiの変更が反映されない

```bash
# 強制適用
chezmoi apply --force

# ソースを直接確認
chezmoi source-path ~/.config/fish/config.fish

# デバッグモード
chezmoi apply --verbose
```
