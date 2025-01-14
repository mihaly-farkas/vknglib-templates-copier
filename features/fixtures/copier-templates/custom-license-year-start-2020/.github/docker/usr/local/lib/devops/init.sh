#!/usr/bin/env bash

# Configure the git user
git config --global user.name "$SERVICE_USER_NAME"
git config --global user.email "$SERVICE_USER_EMAIL"

# Checkout the desired reference
git remote add origin "https://$SERVICE_USER_PAT@github.com/$GIT_REPO_OWNER/$GIT_REPO_NAME.git"
git fetch origin
git checkout "$GIT_CHECKOUT_REF"

# If it is a branch, set the upstream
git show-ref --verify "refs/heads/$GIT_CHECKOUT_REF" >/dev/null 2>/dev/null && git branch "--set-upstream-to=origin/$GIT_CHECKOUT_REF" "$GIT_CHECKOUT_REF"
