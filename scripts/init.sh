#!/usr/bin/env bash

set -euo pipefail

exit_failure=1

project_root=$(git rev-parse --show-toplevel)

yeet_name=${1:-}

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
  if [ -n "$default" ]; then
    read -p "$prompt [default: $default]: " response
  else
    read -p "$prompt: " response
  fi

  if [ -z "$response" ]; then
    response=$default
  fi
  echo $response
}


process_variables() {
  if [ -z "$yeet_name" ]; then
    yeet_name=$(prompt_user "What would you like to name the new yeet?")
    echo $yeet_name
  fi
  location=$(prompt_user "Where would you like to create the new yeet?" "$(pwd)")

  initialize_git=$(prompt_user "Would you like to initialize a git repository?" "y")
}

cleanup() {
  find . -type f ! -path "./$location/$yeet_name/*" -exec rm -rf {} +
}

main() {
  >&2 echo "Creating directory for $yeet_name"
  if [ -d "$location/$yeet_name" ]; then
    >&2 echo "Directory for $yeet_name already exists!"
    exit $exit_failure
  fi

  mkdir -p "$location/$yeet_name"
  cp -r templates/yeet/* "$location/$yeet_name"

  pushd "$location/$yeet_name" > /dev/null 2>&1
    render_yeet_template
    if [ "$initialize_git" == "y" ]; then
      git init
    fi
  popd > /dev/null 2>&1
  cleanup
}

pushd "$project_root" > /dev/null 2>&1
  main
popd > /dev/null 2>&1
