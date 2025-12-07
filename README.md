# Dotfiles

macOS + Fish Shell 環境の dotfiles を chezmoi で管理するリポジトリです。

## 技術スタック

| カテゴリ | ツール |
|----------|--------|
| シェル | Fish Shell 4.0+ |
| Fishプラグイン | Fisher (autopair.fish) |
| dotfile管理 | chezmoi |
| プロンプト | Starship |
| バージョン管理 | mise |
| Pythonパッケージ | uv |
| CLIツール | eza, bat, ripgrep, fd, fzf, zoxide, delta |

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

### セットアップ後の手順

#### 1. ターミナルを再起動

Fishシェルを有効にするため、ターミナルアプリを完全に終了して再度開いてください。

#### 2. ターミナルのフォント設定

アイコンを正しく表示するため、Nerd Fontを設定します。

**Terminal.appの場合：**
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
│   ├── bat/config           # bat設定
│   ├── ripgrep/config       # ripgrep設定
│   ├── mise/config.toml     # mise設定
│   └── starship.toml        # プロンプト設定
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
