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
  diff --recursive "$GENERATED" "$FIXTURES" --exclude=.copier-answers.yml --exclude=.fixtures || $DIFFERENT
  { set +x; } 2>/dev/null
}

function test_template() {
  TEMPLATE=$1

  copy . ".generated/template-$TEMPLATE"
  compare ".generated/template-$TEMPLATE" ".fixtures/template-$TEMPLATE"

  copy ".generated/template-$TEMPLATE" ".generated/template-$TEMPLATE.generated/project-default"
  compare ".generated/template-$TEMPLATE.generated/project-default" ".fixtures/template-$TEMPLATE/.fixtures/project-default"
  compare ".generated/template-$TEMPLATE.generated/project-default" ".fixtures/template-$TEMPLATE.generated/project-default"
}

test_template "default"
