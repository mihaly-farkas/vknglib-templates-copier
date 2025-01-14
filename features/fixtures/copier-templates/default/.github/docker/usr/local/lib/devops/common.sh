#!/usr/bin/env bash

export CYAN='\033[0;36m'
export GREEN='\033[0;32m'
export NC='\033[0m'

# Configure the git user
git config --global user.name "$SERVICE_USER_NAME"
git config --global user.email "$SERVICE_USER_EMAIL"

echo "$SERVICE_USER_SSH_PRIVAT_KEY_BASE64" | base64 --decode >/root/.ssh/id_ed25519
chmod 600 /root/.ssh/id_ed25519

# Checkout the desired reference
git fetch origin
git checkout "$GIT_CHECKOUT_REF"

# If it is a branch, set the upstream
git show-ref --verify "refs/heads/$GIT_CHECKOUT_REF" >/dev/null 2>/dev/null && git branch "--set-upstream-to=origin/$GIT_CHECKOUT_REF" "$GIT_CHECKOUT_REF"
