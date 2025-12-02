# Dotfiles リポジトリ作成 - 詳細行動計画書

## 概要

このドキュメントは `dotfiles-development-spec.md` に基づき、macOS + Fish Shell 環境の dotfiles を chezmoi で管理するリポジトリを作成するための詳細な行動計画を記述します。

## 作業方針

### ディレクトリ配置戦略

1. **作業ディレクトリ**: `/Users/toshiki.ito/Documents/tmp/dotfiles/`
2. **chezmoi ソース**: 上記ディレクトリ内に `.local/share/chezmoi/` を作成
3. **最終配置**: 作業完了後、`$HOME` にコピーして使用

```
/Users/toshiki.ito/Documents/tmp/dotfiles/
├── .local/
│   └── share/
│       └── chezmoi/          # ← chezmoiソース（ここで作業）
│           ├── .chezmoi.toml.tmpl
│           ├── .chezmoiignore
│           ├── dot_config/
│           │   ├── fish/
│           │   ├── git/
│           │   ├── mise/
│           │   └── starship.toml
│           ├── Brewfile
│           └── run_*.sh.tmpl
├── README.md                  # リポジトリ説明
├── action-plan.md            # この計画書
├── checklist.md              # 作業チェックリスト
└── dotfiles-development-spec.md  # 仕様書（既存）
```

---

## Phase 1: 基盤構築

### 1.1 ディレクトリ構造の作成

```bash
# chezmoiソースディレクトリ
.local/share/chezmoi/
├── dot_config/
│   ├── fish/
│   │   ├── conf.d/
│   │   └── functions/
│   ├── git/
│   └── mise/
```

**注意点**:
- chezmoi の命名規則: `dot_` → `.` に変換
- ディレクトリは再帰的に作成

### 1.2 chezmoi 設定ファイルの作成

| ファイル | 目的 |
|---------|------|
| `.chezmoi.toml.tmpl` | chezmoi 本体設定（ユーザー情報のプロンプト） |
| `.chezmoiignore` | 管理対象外ファイルの指定 |

**技術詳細**:
- `.chezmoi.toml.tmpl` は Go テンプレート形式
- `promptStringOnce`, `promptBoolOnce` で初回のみユーザー入力を求める
- `.chezmoiignore` も Go テンプレート対応（OS 条件分岐可能）

---

## Phase 2: Fish Shell 設定

### 2.1 メイン設定ファイル

| ファイル | 役割 |
|---------|------|
| `dot_config/fish/config.fish` | メイン設定（最後に読み込み） |

**内容**:
- インタラクティブシェルチェック
- 挨拶メッセージ無効化
- Starship 初期化

### 2.2 conf.d/ 自動読み込みファイル

読み込み順序はファイル名のアルファベット順（数字プレフィックスで制御）:

| 順序 | ファイル | 内容 |
|------|---------|------|
| 00 | `00-xdg.fish` | XDG Base Directory 環境変数 |
| 10 | `10-homebrew.fish` | Homebrew PATH 設定 |
| 20 | `20-mise.fish` | mise 初期化 |
| 30 | `30-tools.fish` | zoxide, fzf 初期化 |
| 40 | `40-aliases.fish` | エイリアス定義 |
| 50 | `50-uv.fish` | uv (Python) 設定 |

**依存関係**:
- `10-homebrew.fish` → PATH 設定が他ツールの前提
- `20-mise.fish` → mise が有効になってから Node/Python 利用可能
- `30-tools.fish` → zoxide, fzf は Homebrew でインストール後

### 2.3 Fish 関数ファイル

| ファイル | 関数名 | 機能 |
|---------|--------|------|
| `mkcd.fish` | `mkcd` | ディレクトリ作成 & 移動 |
| `proj.fish` | `proj` | fzf でプロジェクト選択 & 移動 |
| `fvim.fish` | `fvim` | fzf でファイル選択 & vim で開く |
| `fbr.fish` | `fbr` | fzf で git ブランチ切り替え |

**注意点**:
- ファイル名と関数名は一致必須（遅延読み込みの仕組み）
- functions/ 内のファイルは初回呼び出し時に読み込み

---

## Phase 3: Git 設定

### 3.1 設定ファイル

| ファイル | 形式 | 備考 |
|---------|------|------|
| `dot_config/git/config.tmpl` | Go テンプレート | ユーザー情報を変数化 |
| `dot_config/git/ignore` | プレーンテキスト | グローバル ignore |

**config.tmpl の変数**:
- `{{ .name }}` → chezmoi データから取得
- `{{ .email }}` → chezmoi データから取得
- `{{ .chezmoi.os }}` → OS 判定（darwin/linux）
- `{{ .isWork }}` → 仕事用マシンフラグ

**条件分岐**:
- macOS: `osxkeychain` クレデンシャルヘルパー
- 仕事用: プロキシ設定（コメントアウト状態）

---

## Phase 4: その他設定ファイル

### 4.1 mise 設定

`dot_config/mise/config.toml`:
- Node.js LTS
- Python 3.12
- uv latest

### 4.2 Starship 設定

`dot_config/starship.toml`:
- ディレクトリ表示
- Git ブランチ/ステータス
- Node.js/Python バージョン
- コマンド実行時間
- カスタムプロンプト記号

### 4.3 Brewfile

`Brewfile`:
- Shell: fish, starship
- Dev Tools: mise, uv, gh
- CLI Tools: eza, bat, ripgrep, fd, fzf, zoxide, git-delta, jq, yq, httpie
- Applications: VS Code, Warp, Docker, 1Password, Chrome, Slack, Notion
- Fonts: Hack Nerd Font, Fira Code Nerd Font

---

## Phase 5: 実行スクリプト

### 5.1 スクリプト一覧

| ファイル | タイミング | 目的 |
|---------|-----------|------|
| `run_once_before_00-install-homebrew.sh.tmpl` | apply 前・初回のみ | Homebrew インストール |
| `run_once_before_10-install-packages.sh.tmpl` | apply 前・初回のみ | Brewfile パッケージインストール |
| `run_onchange_after_configure-macos.sh.tmpl` | apply 後・変更時 | macOS 設定（Fish デフォルト化、mise 初期化） |

**chezmoi 実行順序**:
1. `run_once_before_*` スクリプト（番号順）
2. ファイル配置
3. `run_onchange_after_*` スクリプト（番号順）

### 5.2 スクリプトの注意点

- すべて `.tmpl` 拡張子 → Go テンプレート処理
- `{{ if eq .chezmoi.os "darwin" }}` で macOS のみ実行
- `run_once_*` は初回のみ、`run_onchange_*` はファイル内容変更時に実行
- shebang: `#!/bin/bash`

---

## Phase 6: Git リポジトリ初期化

### 6.1 初期化手順

```bash
cd /Users/toshiki.ito/Documents/tmp/dotfiles
git init
```

### 6.2 .gitignore 作成

```
# OS
.DS_Store

# Editor
*.swp
*.swo
*~
.idea/
.vscode/
```

### 6.3 README.md 作成

リポジトリの説明と使用方法を記載

---

## 技術的考慮事項

### chezmoi 命名規則サマリー

| プレフィックス | 効果 |
|---------------|------|
| `dot_` | `.` に変換 |
| `private_` | パーミッション 600 |
| `exact_` | ディレクトリ完全同期 |
| `run_once_` | 初回のみ実行 |
| `run_onchange_` | 内容変更時に実行 |
| `before_` | apply 前に実行 |
| `after_` | apply 後に実行 |
| `.tmpl` | Go テンプレート処理 |

### Go テンプレート構文

```go
// 変数展開
{{ .name }}
{{ .email | quote }}

// 条件分岐
{{ if eq .chezmoi.os "darwin" -}}
macOS 用の内容
{{ end -}}

// 空白制御
{{- .variable -}}  // 前後の空白を削除
```

### Fish Shell 構文の特徴

```fish
# 変数設定
set -gx VARIABLE "value"    # グローバル + export

# 条件分岐
if test -f /path/to/file
    echo "exists"
end

# コマンド存在チェック
if type -q mise
    # mise が存在する場合
end
```

---

## 最終配置手順

作業完了後、以下の手順で `$HOME` に配置:

```bash
# 1. .local ディレクトリをコピー
cp -r /Users/toshiki.ito/Documents/tmp/dotfiles/.local ~/

# 2. chezmoi で差分確認
chezmoi diff

# 3. 適用
chezmoi apply
```

または、Git リポジトリとして push 後:

```bash
# GitHub から直接セットアップ
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

---

## 作成ファイル一覧

計 22 ファイル:

1. `.local/share/chezmoi/.chezmoi.toml.tmpl`
2. `.local/share/chezmoi/.chezmoiignore`
3. `.local/share/chezmoi/dot_config/fish/config.fish`
4. `.local/share/chezmoi/dot_config/fish/conf.d/00-xdg.fish`
5. `.local/share/chezmoi/dot_config/fish/conf.d/10-homebrew.fish`
6. `.local/share/chezmoi/dot_config/fish/conf.d/20-mise.fish`
7. `.local/share/chezmoi/dot_config/fish/conf.d/30-tools.fish`
8. `.local/share/chezmoi/dot_config/fish/conf.d/40-aliases.fish`
9. `.local/share/chezmoi/dot_config/fish/conf.d/50-uv.fish`
10. `.local/share/chezmoi/dot_config/fish/functions/mkcd.fish`
11. `.local/share/chezmoi/dot_config/fish/functions/proj.fish`
12. `.local/share/chezmoi/dot_config/fish/functions/fvim.fish`
13. `.local/share/chezmoi/dot_config/fish/functions/fbr.fish`
14. `.local/share/chezmoi/dot_config/git/config.tmpl`
15. `.local/share/chezmoi/dot_config/git/ignore`
16. `.local/share/chezmoi/dot_config/mise/config.toml`
17. `.local/share/chezmoi/dot_config/starship.toml`
18. `.local/share/chezmoi/Brewfile`
19. `.local/share/chezmoi/run_once_before_00-install-homebrew.sh.tmpl`
20. `.local/share/chezmoi/run_once_before_10-install-packages.sh.tmpl`
21. `.local/share/chezmoi/run_onchange_after_configure-macos.sh.tmpl`
22. `.gitignore`
23. `README.md`
