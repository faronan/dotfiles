# ===========================================
# Abbreviations (入力時に展開される省略形)
# ===========================================
# alias より推奨: 履歴に正確なコマンドが残る
# https://fishshell.com/docs/current/cmds/abbr.html

if status is-interactive
    # ===========================================
    # Git
    # ===========================================
    abbr -a g git
    abbr -a ga 'git add'
    abbr -a gaa 'git add --all'
    abbr -a gc 'git commit'
    abbr -a gcm 'git commit -m'
    abbr -a gca 'git commit --amend'
    abbr -a gcac 'git commit --amend -C HEAD'
    abbr -a gcacn 'git commit --amend -C HEAD --date=now'
    abbr -a gp 'git push'
    abbr -a gpo 'git push origin'
    abbr -a gpf 'git push --force-with-lease'
    abbr -a gl 'git pull'
    abbr -a gs 'git status'
    abbr -a gd 'git diff'
    abbr -a gdh 'git diff HEAD'
    abbr -a gds 'git diff --staged'
    abbr -a gco 'git checkout'
    abbr -a gb 'git branch'
    abbr -a gba 'git branch -a'
    abbr -a glo 'git log --oneline'
    abbr -a glog 'git log --oneline --graph --decorate --all'
    abbr -a gg 'git graph'
    abbr -a gfa 'git fetch --all --prune'
    abbr -a gpra 'git pull --rebase --autostash'
    abbr -a grs 'git reset'
    abbr -a grss 'git reset --soft'
    abbr -a grssh 'git reset --soft HEAD'
    abbr -a grsh 'git reset --hard'
    abbr -a gr 'git rebase'
    abbr -a gri 'git rebase -i'
    abbr -a grbc 'git rebase --continue'
    abbr -a grba 'git rebase --abort'
    abbr -a gf 'git fetch'
    abbr -a gfo 'git fetch origin'
    abbr -a gsw 'git switch'
    abbr -a gswc 'git switch -c'
    abbr -a gst 'git stash'
    abbr -a gstp 'git stash pop'
    abbr -a lg lazygit

    # ===========================================
    # Node.js / pnpm
    # ===========================================
    abbr -a pn pnpm
    abbr -a pni 'pnpm install'
    abbr -a pna 'pnpm add'
    abbr -a pnad 'pnpm add -D'
    abbr -a pnr 'pnpm run'
    abbr -a pnx 'pnpm dlx'
    abbr -a ni 'npm install'
    abbr -a nr 'npm run'

    # ===========================================
    # Docker
    # ===========================================
    abbr -a dc 'docker compose'
    abbr -a dcu 'docker compose up'
    abbr -a dcud 'docker compose up -d'
    abbr -a dcd 'docker compose down'
    abbr -a dcb 'docker compose build'
    abbr -a dcr 'docker compose run --rm'
    abbr -a dcl 'docker compose logs -f'
    abbr -a dce 'docker compose exec'
    abbr -a dps 'docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'

    # ===========================================
    # AWS CLI
    # ===========================================
    abbr -a awsl 'aws sso login'
    abbr -a awsw 'aws sts get-caller-identity'
    abbr -a awsp 'set -gx AWS_PROFILE'

    # ===========================================
    # Google Cloud SDK
    # ===========================================
    abbr -a gcl 'gcloud auth login'
    abbr -a gcal 'gcloud auth application-default login'
    abbr -a gcw 'gcloud config list'
    abbr -a gcp 'gcloud config configurations activate'
    abbr -a gcpl 'gcloud config configurations list'

    # ===========================================
    # ナビゲーション
    # ===========================================
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'

    # ===========================================
    # その他
    # ===========================================
    abbr -a reload 'exec fish'

    # sd (テキスト置換)
    abbr -a sdp 'sd -p'
    abbr -a sdf 'sd -F'

    # tldr (コマンドチートシート)
    abbr -a tl tldr
    abbr -a tlj 'tldr --language ja'
    abbr -a tlu 'LANG=ja_JP.UTF-8 tldr --update'

    # duf (ディスク容量)
    abbr -a dfl 'duf --only local'
end
