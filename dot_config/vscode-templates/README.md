# VSCode Extension Management - Hybrid Workflow

**ハイブリッド運用**: 共通ベースはグローバル、重い拡張はWorkspace単位でEnable。

## 運用ルール

### ルール1: グローバルに残す拡張の条件

- 言語を問わず役に立つ
- 重くない（LSPを立ち上げない）
- プロジェクトごとの差異が関係ない

→ **共通ベース（10個）のみグローバルで有効**

### ルール2: 言語別の重い拡張はWorkspace単位でEnable

1. インストール直後に**グローバルでDisable**
2. 使いたいプロジェクトで**Enable (Workspace)**

→ これを「重い拡張の儀式」として習慣化

### ルール3: `.vscode/extensions.json` を書く

- 将来の自分のためのメモ
- 別マシンで環境再現が楽になる

### ルール4: Profilesは役割が明確に増えたときだけ

- 「エンジニアリング用」と「執筆用」を完全分離したい、など
- 現時点では過剰 → 必要になったら導入

---

## セットアップ手順

### Step 1: 共通ベース拡張をインストール（グローバル有効）

```bash
vscode-install-base
```

インストールされる拡張（すべてグローバル有効）：

| 拡張 | 用途 |
|------|------|
| GitLens | Git blame/履歴 |
| indent-rainbow | インデント可視化 |
| Error Lens | エラー/警告インライン表示 |
| zenkaku | 全角文字ハイライト |
| Material Icon Theme | ファイルアイコン |
| Prettier | マルチ言語フォーマッタ |
| EditorConfig | エディタ共通設定 |
| Todo Tree | TODO集約 |
| Code Spell Checker | スペルチェック |
| Markdown All in One | Markdown編集 |

### Step 2: 言語別拡張をインストール（グローバル無効）

```bash
# Node.js用
vscode-install-node

# Python用
vscode-install-python
```

**重要**: インストール後、VSCodeで各拡張を**グローバルでDisable**する：

1. `Cmd+Shift+X` で拡張機能ビューを開く
2. 各拡張の歯車アイコン → `Disable`

### Step 3: プロジェクトごとにEnable

Node.jsプロジェクトを開いたとき：

1. 拡張機能ビュー（`Cmd+Shift+X`）を開く
2. ESLint等の歯車アイコン → `Enable (Workspace)`

---

## プロジェクト初期化

```bash
cd your-project

# Node.jsプロジェクト
vscode-init-project node

# Pythonプロジェクト
vscode-init-project python
```

`.vscode/extensions.json` が作成され、VSCodeが推奨拡張を表示するようになる。

---

## ディレクトリ構成

```
vscode-templates/
├── README.md                   # このファイル
├── base/extensions.json        # 共通ベース（グローバル有効）
├── node/extensions.json        # Node.js用（Workspace Enable）
└── python/extensions.json      # Python用（Workspace Enable）
```

## ソース・オブ・トゥルース

**JSONファイルが正**。スクリプトはJSONから読み取るだけ。

```
拡張を追加/削除したい場合:
  1. 該当する extensions.json を編集
  2. vscode-install-* を実行

スクリプトを直接編集する必要はない
```

Prettierについて:
- ベースに含まれているが、`settings.json` で `prettier.requireConfig: true` を設定
- → `.prettierrc` があるプロジェクトでのみ動作（意図しないフォーマット防止）

---

## 拡張カテゴリ別一覧

### 共通ベース（グローバル有効）

```
eamodio.gitlens
oderwat.indent-rainbow
usernamehw.errorlens
mosapride.zenkaku
pkief.material-icon-theme
esbenp.prettier-vscode
editorconfig.editorconfig
gruntfuggly.todo-tree
streetsidesoftware.code-spell-checker
yzhang.markdown-all-in-one
```

### Node.js（グローバル無効 → Workspace Enable）

```
dbaeumer.vscode-eslint
christian-kohler.npm-intellisense
christian-kohler.path-intellisense
formulahendry.auto-rename-tag
humao.rest-client
```

### Python（グローバル無効 → Workspace Enable）

```
ms-python.python
ms-python.vscode-pylance
charliermarsh.ruff
ms-toolsai.jupyter
ms-toolsai.jupyter-keymap
ms-toolsai.jupyter-renderers
mechatroner.rainbow-csv
```

---

## トラブルシューティング

### VSCodeが重い

```bash
# 拡張の起動時間を確認
Cmd+Shift+P → Developer: Show Running Extensions
```

重い拡張がグローバル有効になっていないか確認。

### 拡張がWorkspaceで有効にならない

1. `.vscode` フォルダが存在するか確認
2. VSCodeをリロード（`Cmd+Shift+P` → `Reload Window`）

### Profilesに移行したくなったとき

1. `Cmd+Shift+P` → `Profiles: Create Profile`
2. 名前: `Node` or `Python`
3. 共通ベースをコピー
4. 言語別拡張を追加・有効化
5. フォルダに紐付け: `Profiles: Associate Profile with Folder`
