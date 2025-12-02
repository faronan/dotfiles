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

### 新規マシン（完全自動）

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

### 手動セットアップ

```bash
# 1. Homebrewインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. chezmoiインストール
brew install chezmoi

# 3. dotfilesをclone
chezmoi init YOUR_GITHUB_USERNAME

# 4. 差分確認
chezmoi diff

# 5. 適用
chezmoi apply

# 6. シェル再起動
exec fish
```

## ディレクトリ構成

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl       # chezmoi設定
├── .chezmoiignore           # 管理対象外ファイル
├── dot_config/
│   ├── fish/
│   │   ├── config.fish      # メイン設定
│   │   ├── conf.d/          # 自動読み込み設定
│   │   └── functions/       # カスタム関数
│   ├── git/
│   │   ├── config.tmpl      # Git設定（テンプレート）
│   │   └── ignore           # グローバルgitignore
│   ├── mise/
│   │   └── config.toml      # mise設定
│   └── starship.toml        # プロンプト設定
├── Brewfile                 # Homebrewパッケージ
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

## ライセンス

MIT
