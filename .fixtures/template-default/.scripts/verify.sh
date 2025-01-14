#!/usr/bin/env bash

set -e

if [[ "$1" == "--stop" ]]; then
  DIFFERENT="exit 1"
fi

rm -rf .generated/*

function copy() {
  SOURCE=$1
  DEST=$2

  set -x
  copier copy "$SOURCE" "$DEST" \
    --defaults \
    --force \
    --overwrite \
    --vcs-ref=HEAD
  { set +x; } 2>/dev/null
}

function compare() {
  GENERATED=$1
  FIXTURES=$2

  set -x
  diff --recursive "$GENERATED" "$FIXTURES" --exclude=.copier-answers.yml || $DIFFERENT
  { set +x; } 2>/dev/null
}

function test_project() {
  TEMPLATE=$1

  copy . ".generated/project-$TEMPLATE"

  compare ".generated/project-$TEMPLATE" ".fixtures/project-$TEMPLATE"
}

test_project "default"
