#!/usr/bin/env bash

set -e

if [[ "$1" == "--stop" ]]; then
  DIFFERENT="exit 1"
fi

# If is a Git repository
if [[ -d .git ]]; then
  # If there are uncommitted changes
  if ! git diff --quiet; then
    git add . -A
    git commit -m "..."
  fi
  git tag "@latest" --force
fi

rm -rf .generated/*

function copy() {
  SOURCE=$1
  DEST=$2
  shift 2

  set -x
  copier copy "$SOURCE" "$DEST" \
    --defaults \
    --overwrite \
    --vcs-ref=@latest \
    "$@"
  { set +x; } 2>/dev/null
}

function compare() {
  GENERATED=$1
  FIXTURES=$2

  set -x
  diff --recursive "$GENERATED" "$FIXTURES" --exclude=.fixtures || $DIFFERENT
  { set +x; } 2>/dev/null
}

function verify_project() {
  TEMPLATE=$1

  copy . ".generated/project-$TEMPLATE"

  compare ".generated/project-$TEMPLATE" ".fixtures/project-$TEMPLATE"
}

verify_project "default"

verify_project "license-year-start-2020" --data "license_year_start=2020"
verify_project "license-year-start-2025" --data "license_year_start=2025"

verify_project "license-owner-dolor-sic-amet-ltd" --data "license_owner=Dolor Sic Amet Ltd."
verify_project "license-owner-john-doe" --data "license_owner=John Doe"
