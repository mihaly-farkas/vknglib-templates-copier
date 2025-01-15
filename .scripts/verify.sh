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
  TEMPLATE="$1"
  PROJECT="$2"
  shift 2

  copy ".generated/template-$TEMPLATE" ".generated/template-$TEMPLATE.generated/project-$PROJECT" "$@"

  compare ".generated/template-$TEMPLATE.generated/project-$PROJECT" ".fixtures/template-$TEMPLATE/.fixtures/project-$PROJECT"
  compare ".generated/template-$TEMPLATE.generated/project-$PROJECT" ".fixtures/template-$TEMPLATE.generated/project-$PROJECT"
}

function verify_template() {
  TEMPLATE="$1"
  shift 1

  copy . ".generated/template-$TEMPLATE" "$@" --data "template_name=$TEMPLATE"

  compare ".generated/template-$TEMPLATE" ".fixtures/template-$TEMPLATE"

  verify_project "$TEMPLATE" "default"

  verify_project "$TEMPLATE" "license-year-start-2020" --data "license_year_start=2020"
  verify_project "$TEMPLATE" "license-year-start-2025" --data "license_year_start=2025"

  verify_project "$TEMPLATE" "license-owner-dolor-sic-amet-ltd" --data "license_owner=Dolor Sic Amet Ltd."
  verify_project "$TEMPLATE" "license-owner-john-doe" --data "license_owner=John Doe"
}

verify_template "default"

verify_template "license-year-start-2018" --data "license_year_start=2018"
verify_template "license-year-start-2025" --data "license_year_start=2025"

verify_template "license-owner-eric-example" --data "license_owner=Eric Example"
verify_template "license-owner-lorem-ipsum-corporation" --data "license_owner=Lorem Ipsum Corporation"
