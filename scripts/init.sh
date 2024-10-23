#!/usr/bin/env bash

set -euo pipefail

exit_failure=1

project_root=$(git rev-parse --show-toplevel)

yeet_name=${1:-}
location=$project_root

render_file_template() {
  if [ "$(uname)" == "Darwin" ]; then
    sed -i '' "s/$1/$2/g" $3
  else
    sed -i "s/$1/$2/g" $3
  fi
}

render_yeet_template() {
  render_file_template "__TARGET__" "$yeet_name" Makefile
  render_file_template "__TARGET__" "$yeet_name" YEET
}

prompt_user() {
  prompt=$1
  default=${2:-}
  while :; do
    if [ -n "$default" ]; then
      read -p "$prompt [default: $default]: " response
    else
      read -p "$prompt: " response
    fi

    if [ -n "$response" ]; then
      echo "$response"
      return
    fi

    if [ -z "$response" ] && [ -n "$default" ]; then
      response=$default
      echo "$response"
      return
    fi

    >&2 echo "Invalid input."
  done
}

process_variables() {
  if [ -z "$yeet_name" ]; then
    yeet_name=$(prompt_user "What would you like to name the new yeet?")
  fi
}

main() {
  process_variables

  >&2 echo "Creating directory for $yeet_name"
  if [ -d "$location/$yeet_name" ]; then
    >&2 echo "Directory for $yeet_name already exists!"
    exit $exit_failure
  fi

  mkdir -p "$location/$yeet_name"
  cp -r .templates/yeet/* "$location/$yeet_name"
  cp -r .templates/yeet/.clang-format "$location/$yeet_name"

  pushd "$location/$yeet_name" > /dev/null 2>&1
    render_yeet_template
    git init
  popd > /dev/null 2>&1
}

pushd "$project_root" > /dev/null 2>&1
  main
popd > /dev/null 2>&1
