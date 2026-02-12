# AWS CLI
if command -q aws
    set -gx AWS_PAGER ""
end

# Google Cloud SDK
# 公式インストーラ (tar.gz) の場合: ~/google-cloud-sdk/path.fish.inc
# Homebrew の場合: $HOMEBREW_PREFIX/share/google-cloud-sdk/path.fish.inc
if test -f ~/google-cloud-sdk/path.fish.inc
    source ~/google-cloud-sdk/path.fish.inc
else if test -n "$HOMEBREW_PREFIX"; and test -f "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.fish.inc"
    source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.fish.inc"
end
