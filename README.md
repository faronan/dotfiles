# Dotfiles

macOS + Fish Shell 環境の dotfiles を chezmoi で管理するリポジトリです。

## 技術スタック

| カテゴリ | ツール |
|----------|--------|
| シェル | Fish Shell 4.0+ |
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

この1行で以下がすべて自動実行されます：

1. chezmoi インストール
2. Homebrew インストール
3. Brewfile からパッケージ一括インストール
4. dotfiles 配置
5. macOS 設定適用
6. Fish をデフォルトシェルに設定

### 注意事項

- **SSH鍵**: セキュリティ上、SSH秘密鍵は管理対象外です。事前に準備してください
  ```bash
  ssh-keygen -t ed25519 -C "your_email@example.com"
  # → GitHubに公開鍵を登録
  ```
- **初回入力**: `chezmoi init` 時に名前・メール・仕事用マシンかどうかを聞かれます
- **シェル再起動**: 適用後、ターミナルを再起動するとFishが有効になります

### 適用前に確認したい場合

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init YOUR_GITHUB_USERNAME
chezmoi diff    # 変更内容を確認
chezmoi apply   # 適用
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

## カスタマイズ

初回 `chezmoi init` 時に以下の情報を入力します：

- 名前（Git用）
- メールアドレス
- 仕事用マシンかどうか

これらの情報は `~/.config/chezmoi/chezmoi.toml` に保存され、テンプレートファイルで使用されます。

## 自動設定

セットアップ時に以下が自動的に実行されます：

| スクリプト | 内容 |
|-----------|------|
| Homebrew インストール | Homebrewが未インストールの場合 |
| パッケージインストール | Brewfileからツール・アプリをインストール |
| Fish シェル設定 | デフォルトシェルをFishに変更 |
| macOS 設定 | キーリピート高速化、Finder設定、Dock自動非表示など |
| SSH ローカル設定 | `~/.ssh/local.config` を初回作成（マシン固有のホスト用） |

## SSH設定

SSHは2つのファイルで構成されます：

- `~/.ssh/config` - chezmoi管理（GitHub設定、グローバルデフォルト）
- `~/.ssh/local.config` - 手動管理（EC2等のマシン固有ホスト）

仕事用マシン（`isWork=true`）の場合、`github.com.work` エイリアスが追加されます。

## ライセンス

MIT
