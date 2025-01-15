#!/usr/bin/env bash

set -e

if [[ "$1" == "--stop" ]]; then
  DIFFERENT="exit 1"
fi

rm -rf .generated/*

function copy() {
  SOURCE=$1
  DEST=$2

  copier copy "$SOURCE" "$DEST" \
    --defaults \
    --force \
    --overwrite \
    --vcs-ref=HEAD
}

function test_template() {
  TEMPLATE=$1

  copy . ".generated/template-$TEMPLATE"

  diff --recursive ".generated/template-$TEMPLATE" ".fixtures/template-$TEMPLATE" --exclude=.copier-answers.yml --exclude=.fixtures || $DIFFERENT

  copy ".generated/template-$TEMPLATE" ".generated/template-$TEMPLATE.generated/project-default"

  diff --recursive ".generated/template-$TEMPLATE.generated/project-default" ".fixtures/template-$TEMPLATE/.fixtures/project-default" --exclude=.copier-answers.yml || $DIFFERENT
  diff --recursive ".generated/template-$TEMPLATE.generated/project-default" ".fixtures/template-$TEMPLATE.generated/project-default" --exclude=.copier-answers.yml || $DIFFERENT
}

test_template "default"
