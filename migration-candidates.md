# 既存dotfilesからの移行候補リスト

既存の `~/dotfiles/` (zsh) と新規作成した `dotfiles/.local/share/chezmoi/` (fish) の差分をまとめました。

---

## カテゴリ別リスト

### 1. Git関連

#### 1.1 コミットテンプレート (新規dotfilesに**なし**)

**ファイル**: `.git_config/.commit_template`

絵文字付きコミットメッセージのテンプレート：
```
🎉 :tada: 初めてのコミット
📦 :package: パッケージの追加/更新
🔧 :wrench: ツール
✨ :sparkles: 新機能
🐛 :bug: バグ修正
🚿 :shower: 不要機能の削除
💚 :green_heart: テスト/CI
👕 :shirt: Lintエラー/コードスタイル修正
🗑️ :wastebasket: 削除
🚧 :construction: WIP
📚 :books: ドキュメント
🎨 :art: デザインUI/UX
🐎 :horse: パフォーマンス
```

- [x] **追加する**
- [ ] 不要

---

#### 1.2 Git追加エイリアス (部分的に**あり**)

**既存にあって新規にないもの**:
| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `gcm` | `git commit -m` | メッセージ付きコミット |
| `gca` | `git commit --amend` | 直前コミット修正 |
| `gcac` | `git commit --amend -C HEAD` | 同メッセージでamend |
| `gcacn` | `git commit --amend -C HEAD --date=now` | 日時更新でamend |
| `gdh` | `git diff HEAD` | HEAD差分 |
| `gpo` | `git push origin` | originにpush |
| `grs` | `git reset` | reset |
| `grss` | `git reset --soft` | soft reset |
| `grssh` | `git reset --soft HEAD` | HEADにsoft reset |
| `grsh` | `git reset --hard` | hard reset |
| `gr` | `git rebase` | rebase |
| `gri` | `git rebase -i` | 対話的rebase |
| `gf` | `git fetch` | fetch |
| `gfo` | `git fetch origin` | origin fetch |
| `gg` | `git graph` | グラフ表示 |
| `gs` | `git switch` | ブランチ切り替え |
| `gsc` | `git switch -c` | 新規ブランチ作成&切り替え |

- [x] **追加する（全部）**
- [ ] **追加する（一部）**: _______________
- [ ] 不要

---

#### 1.3 GitConfig追加設定 (部分的に**あり**)

**既存にあって新規にないもの**:
```toml
[url "https://github.com/"]
  insteadOf = git@github.com:
[url "git@github.com:"]
  insteadOf = https://github.com/

[color]
  status = auto
  diff = auto
  branch = auto
  interactive = auto
  grep = auto

[include]
  path = ~/.gitconfig.local  # ローカル設定の分離

[commit]
  template = ~/.git_config/.commit_template
```

- [ ] **追加する（全部）**
- [x] **追加する（一部）**: 基本全部追加して欲しいが、path = ~/.gitconfig.localのように対象ファイルがないと機能しないものは除外、もしくは今のFish版の構成に合わせて調整
- [ ] 不要

---

### 2. シェル関数・機能

#### 2.1 Enter時のls + git status自動表示 (新規dotfilesに**なし**)

**機能**: 空のEnterを押すとlsとgit statusを自動表示

```
--- ls ---
(ディレクトリ一覧)

--- git status ---
(gitステータス)
```

- [x] **追加する**（Fish版で実装）
- [ ] 不要

---

#### 2.2 ディレクトリ移動時のls自動表示 (新規dotfilesに**なし**)

**機能**: `cd`でディレクトリ移動すると自動的にlsを実行

- [x] **追加する**（Fish版で実装）
- [ ] 不要

---

#### 2.3 peco/fzf連携機能 (部分的に**あり**)

**既存にあって新規にないもの**:
| 機能 | キーバインド | 説明 |
|-----|-------------|------|
| 履歴検索 | Ctrl+R | 重複除去した履歴をpeco/fzfで検索 |
| ghqリポジトリ選択 | Ctrl+G | `ghq list`からリポジトリ選択&移動 |
| 最近のディレクトリ | Ctrl+E | `cdr`で最近のディレクトリ選択&移動 |
| ファイル検索 | Ctrl+F | findでファイル検索&開く/移動 |

- [x] **追加する（全部）**
- [ ] **追加する（一部）**: _______________
- [ ] 不要

---

#### 2.4 カスタムGitコマンド (新規dotfilesに**なし**)

**ファイル**: `custom_command/git_checkout` (バイナリ)

pecoを使った対話的ブランチ切り替えツール（`gco`エイリアスで使用）

※ 新規dotfilesには `fbr.fish` で似た機能あり（fzf使用）

- [ ] **追加する**（fbr.fishで代替可能）
- [x] 不要

---

### 3. Docker関連

#### 3.1 Dockerエイリアス (新規dotfilesに**なし**)

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `dps` | `docker ps --format "table ..."` | 整形されたコンテナ一覧 |
| `dc` | `docker compose` | docker compose |
| `dcu` | `docker compose up` | compose up |
| `dcb` | `docker compose build` | compose build |
| `dcrun` | `docker compose run --rm` | compose run |

- [x] **追加する**
- [ ] 不要

---

### 4. 環境変数・PATH

#### 4.1 追加PATH設定 (部分的に**あり**)

**既存にあって新規にないもの**:
| 項目 | PATH |
|-----|------|
| Go | `$GOPATH/bin` |
| Rust/Cargo | `$HOME/.cargo/bin` |
| pnpm | `$HOME/Library/pnpm` |
| Google Cloud SDK | `$HOME/google-cloud-sdk/...` |
| nodenv | `eval "$(nodenv init -)"` |

- [ ] **追加する（全部）**
- [x] **追加する（一部）**: pnpmのみ追加を検討したいが、miseの仕組みを使う方がよければ不要
- [ ] 不要

---

#### 4.2 ロケール設定 (新規dotfilesに**なし**)

```fish
set -gx LC_ALL ja_JP.UTF-8
set -gx LANG ja_JP.UTF-8
```

- [ ] **追加する**
- [x] 不要

---

#### 4.3 LS_COLORS設定 (新規dotfilesに**なし**)

```fish
set -gx LS_COLORS 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
```

- [ ] **追加する**
- [x] 不要（ezaはアイコン表示）

---

### 5. 履歴設定

#### 5.1 シェル履歴の詳細設定 (新規dotfilesに**なし**)

**既存の設定**:
- 履歴ファイル: `~/.zsh_history`
- 履歴サイズ: 1,000,000件
- 重複削除
- ターミナル間共有
- 実行時間保存
- スペース先頭コマンド除外

**Fish版の実装例**:
```fish
# Fishはデフォルトで履歴機能あり
# カスタマイズ例:
set -gx HISTSIZE 1000000
```

- [ ] **追加する**
- [x] 不要（Fishデフォルトで十分）

---

### 6. Terraform関連 (仕事環境向け)

#### 6.1 Terraformエイリアス (新規dotfilesに**なし**)

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `tii` | `terraform init -backend-config=...` | init |
| `tpi` | `terraform plan -var project_id=...` | plan |
| `tai` | `terraform apply -auto-approve -var ...` | apply |

※ プロジェクト固有設定がハードコードされている

- [ ] **追加する**（汎用版で）
- [x] 不要

---

### 7. その他ツール

#### 7.1 追加エイリアス (部分的に**あり**)

**既存にあって新規にないもの**:
| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `fgrep` | `find ./ \| grep` | ファイル検索+grep |
| `du` | `du -shc * \| sort -h` | サイズ表示（ソート済み） |
| `tree` | `tree -a -I ".git\|.history\|..."` | ツリー表示（除外付き） |
| `psgrep` | `ps aux \| grep` | プロセス検索 |

- [x] **追加する**
- [ ] 不要

---

#### 7.2 lsd vs eza (代替あり)

既存: `lsd` を使用
新規: `eza` を使用

どちらもモダンなls代替ツール

- [ ] lsdに変更する
- [x] ezaのまま（推奨）

---

### 8. VSCode設定 (新規dotfilesに**なし**)

**ファイル**: `.vscode/settings.json`

- テーマ: Monokai
- タブサイズ: 2
- 自動保存: afterDelay
- Python: flake8, autopep8, mypy
- 各種言語のスペルチェック
- など

- [ ] **追加する**
- [x] 不要（VSCode設定同期で管理）

---

### 9. Zinitプラグイン (zsh専用)

**既存のプラグイン**:
- zsh-autosuggestions
- fast-syntax-highlighting
- history-search-multi-word
- pure (プロンプトテーマ)
- fzf
- git-extras
- LS_COLORS
- zsh-completions
- git-prompt
- zsh-command-time
- enhancd

**Fish版での対応**:
- autosuggestions → Fish標準機能
- syntax-highlighting → Fish標準機能
- プロンプト → Starship使用
- fzf → 設定済み
- enhancd → zoxide使用

- [ ] 追加対応が必要な機能: _______________
- [x] 不要（Fish標準+Starship+zoxideで十分）

---

## 優先度サマリー

### 高（実用性が高い）
- [ ] Gitコミットテンプレート
- [ ] Git追加エイリアス
- [ ] ghqリポジトリ選択機能
- [ ] Dockerエイリアス

### 中（便利だが必須ではない）
- [ ] Enter時のls+git status表示
- [ ] ディレクトリ移動時のls自動表示
- [ ] ロケール設定
- [ ] 追加PATH（Go, Rust, pnpm等）

### 低（個別判断）
- [ ] Terraformエイリアス
- [ ] VSCode設定
- [ ] その他細かいエイリアス

---

## 次のステップ

1. 上記のチェックボックスに「追加する」「不要」を記入
2. このファイルを保存
3. 選択した項目の実装を依頼

---

**作成日**: 2024-12-02
**対象**: ~/dotfiles/ → /Users/toshiki.ito/Documents/tmp/dotfiles/.local/share/chezmoi/
