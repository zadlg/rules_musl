#!/bin/sh

set -e

buck2 docs starlark \
  --format markdown_files \
  --markdown-files-starlark-subdir "" \
  --markdown-files-destination-dir "${PWD}/docs/" \
  -- @rules_musl//musl:rules.bzl \
  @rules_musl//musl/archive:rules.bzl \
  @rules_musl//musl:providers.bzl \
  @rules_musl//musl:define_toolchain.bzl \
  @rules_musl//musl:types.bzl

if ! [ "$1" = "generate" ]; then
  if [ -d ".git" ]; then
    if ! git diff --exit-code; then
      echo "Documentation is out of sync."
      exit 1
    fi
  elif [ -d ".sl" ]; then
    if [ -n "$(sl diff)" ]; then
      echo "Documentation is out of sync."
      exit 1
    fi
  else
    echo "Unknown vcs."
    exit 1
  fi
fi
exit 0
