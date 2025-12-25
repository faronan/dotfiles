# Dotfiles

macOS + Fish Shell 環境の dotfiles を chezmoi で管理するリポジトリです。

## 技術スタック

| カテゴリ | ツール |
|----------|--------|
| ターミナル | Ghostty (GPU加速, ネイティブUI) |
| シェル | Fish Shell 4.0+ |
| Fishプラグイン | Fisher (autopair.fish) |
| dotfile管理 | chezmoi |
| プロンプト | Starship |
| バージョン管理 | mise |
| Pythonパッケージ | uv |
| フォーマッタ/リンター | Biome (JS/TS), Prettier (Markdown/YAML), Ruff (Python) |
| CLIツール | eza, bat, ripgrep, fd, fzf, zoxide, delta |

## VSCode拡張管理（ハイブリッド運用）

**運用方針**: 共通ベースはグローバル有効、言語別の重い拡張はWorkspace単位でEnable。

### セットアップ

```bash
# Step 1: 共通ベース（グローバル有効）
vscode-install-base

# Step 2: 言語別拡張（インストール後、グローバルでDisable）
vscode-install-node     # Node.js用
vscode-install-python   # Python用
```

### プロジェクトでの使用

```bash
# プロジェクトに推奨拡張を追加
cd your-project
vscode-init-project node    # または python

# VSCodeでプロジェクトを開き、言語別拡張を Enable (Workspace)
```

### 共通ベース拡張（グローバル有効・11個）

| 拡張 | 用途 |
|------|------|
| GitLens | Git blame/履歴 |
| indent-rainbow | インデント可視化 |
| Error Lens | エラー/警告インライン表示 |
| zenkaku | 全角文字ハイライト |
| Material Icon Theme | ファイルアイコン |
| Biome | フォーマッタ/リンター（JS/TS/JSON/CSS/HTML） |
| Prettier | フォーマッタ（Markdown/YAML/SCSS） |
| EditorConfig | エディタ共通設定 |
| Todo Tree | TODO集約 |
| Code Spell Checker | スペルチェック |
| Markdown All in One | Markdown編集 |

> **Note**: Biomeは高速なRust製ツールでJS/TS/JSON/CSS/HTMLを担当。Biome未対応のMarkdown/YAML/SCSSはPrettierがカバー。

詳細・運用ルールは `~/.config/vscode-templates/README.md` を参照。

## セットアップ

### 新規マシン

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

初回実行時に以下の入力を求められます：
- 名前（Git user.name用）
- メールアドレス（Git user.email用）
- 仕事用マシンかどうか（y/n）

途中でHomebrew、各種パッケージ、アプリケーションがインストールされます（10-20分程度）。
sudoパスワードの入力が数回求められます。

**適用前に変更内容を確認したい場合：**

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init YOUR_GITHUB_USERNAME
~/bin/chezmoi diff    # 変更内容を確認
~/bin/chezmoi apply -v
```

### 既存マシンでの更新

dotfilesリポジトリに変更をpushした後、既にセットアップ済みのマシンで最新を反映するには：

```bash
chezmoi update
```

これは内部で `git pull` + `chezmoi apply` を実行します。

**変更内容を確認してから適用したい場合：**

```bash
chezmoi git pull
chezmoi diff          # 変更内容を確認
chezmoi apply -v
```

**ローカルの状態を完全にリセットしたい場合：**

```bash
rm -rf ~/.local/share/chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

> **Note**: `chezmoi init` は初回セットアップ用です。一度実行すると `~/.local/share/chezmoi` にソースがクローンされるため、再度 `init` してもリモートの更新は反映されません。継続的な更新には `chezmoi update` を使用してください。

### セットアップ後の手順

#### 1. Ghosttyを起動

セットアップでインストールされたGhosttyを起動してください。

- Nerd Fontは設定済み（Hack Nerd Font）
- Fish shell統合は自動で有効
- テーマはOS設定に連動（ライト/ダーク自動切り替え）

**設定の確認・変更:**
```bash
# 設定ファイルを開く
$EDITOR ~/.config/ghostty/config

# 利用可能なテーマ一覧
ghostty +list-themes

# 利用可能なフォント一覧
ghostty +list-fonts

# 設定を即座にリロード: Cmd + Shift + ,
```

#### 2. （任意）Terminal.appを使う場合

Ghosttyを使わずTerminal.appを使う場合は、Nerd Fontを手動設定します：

1. ターミナル → 設定 → プロファイル
2. フォント → 変更...
3. 「Hack Nerd Font」または「FiraCode Nerd Font」を選択

**VS Codeターミナル：** 設定済み（自動適用）

#### 3. 開発ツールのインストール

Fishシェル内で実行：

```bash
mise install   # Node.js (LTS), Python 3.12 をインストール
```

#### 4. SSH鍵の設定（git push時に必要）

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# GitHubに公開鍵を登録: https://github.com/settings/keys
```

#### 5. 不要ファイルの削除（任意）

```bash
rm -rf ~/.zsh_sessions ~/.zsh_history
```

#### 6. 再ログイン（推奨）

一部のmacOS設定（Dock、Finderなど）は再ログインまたは再起動で完全に反映されます。

## トラブルシューティング

### 初期設定の入力画面が表示されずに終了した場合

名前・メール・仕事用マシンの入力を求められずに終了した場合：

```bash
~/bin/chezmoi init --prompt
~/bin/chezmoi apply -v
```

### chezmoiコマンドが見つからない

`get.chezmoi.io` は `~/bin/` にインストールします。セットアップ後に `chezmoi` コマンドを使うには：

```bash
# 方法1: 絶対パスで実行
~/bin/chezmoi apply -v

# 方法2: PATHを通す（Fish適用後は不要）
export PATH="$HOME/bin:$PATH"
```

## ディレクトリ構成

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl       # chezmoi設定
├── .chezmoiignore           # 管理対象外ファイル
├── Brewfile                 # Homebrewパッケージ
├── dot_config/
│   ├── fish/
│   │   ├── config.fish      # メイン設定
│   │   ├── fish_plugins     # Fisherプラグイン一覧
│   │   ├── conf.d/          # 自動読み込み設定
│   │   └── functions/       # カスタム関数
│   ├── git/
│   │   ├── config.tmpl      # Git設定（テンプレート）
│   │   ├── ignore           # グローバルgitignore
│   │   └── commit_template  # コミットメッセージテンプレート
│   ├── ghostty/config       # Ghostty設定
│   ├── bat/config           # bat設定
│   ├── ripgrep/config       # ripgrep設定
│   ├── mise/config.toml     # mise設定
│   ├── starship.toml        # プロンプト設定
│   └── vscode-templates/    # VSCode拡張テンプレート
│       ├── base/            # 共通ベース拡張
│       ├── node/            # Node.js用拡張
│       └── python/          # Python用拡張
├── dot_editorconfig         # エディタ共通設定
├── dot_hushlogin            # ターミナルのLast login非表示
├── private_dot_ssh/
│   └── config.tmpl          # SSH設定（テンプレート）
├── Library/.../Code/User/   # VS Code設定（macOSのみ）
│   ├── settings.json
│   └── keybindings.json
└── run_*.sh.tmpl            # 実行スクリプト
```

## 開発ワークフロー

```bash
# ファイル編集
chezmoi edit ~/.config/fish/config.fish

# 差分確認
chezmoi diff

# 適用
chezmoi apply

# ソースディレクトリでgit操作
chezmoi cd
git add .
git commit -m "update fish config"
git push
```

## 自動設定

セットアップ時に以下が自動的に実行されます：

| スクリプト | 内容 |
|-----------|------|
| Homebrew インストール | Homebrewが未インストールの場合 |
| パッケージインストール | Brewfileからツール・アプリをインストール |
| Fisher インストール | Fishプラグインマネージャー + autopair.fish |
| Fish シェル設定 | デフォルトシェルをFishに変更（sudo必要） |
| macOS 設定 | キーリピート高速化、Finder設定、Dock自動非表示など |
| SSH ローカル設定 | `~/.ssh/local.config` を初回作成（マシン固有のホスト用） |

## SSH設定

SSHは2つのファイルで構成されます：

- `~/.ssh/config` - chezmoi管理（GitHub設定、グローバルデフォルト）
- `~/.ssh/local.config` - 手動管理（EC2等のマシン固有ホスト）

仕事用マシン（`isWork=true`）の場合、`github.com.work` エイリアスが追加されます。

## ライセンス

MIT
