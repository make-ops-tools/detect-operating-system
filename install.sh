#!/bin/bash

set -e

# Project installation script
#
# Usage:
#   $ [options] /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/make-ops-tools/detect-operating-system/main/install.sh)"
#
# Options:
#   BRANCH_NAME=other-branch-than-main      # Default is `main`
#   INSTALL_DIR=other-dir-than-install-dir  # Default is `~/.local/share/$ORG_NAME/$REPO_NAME`
#   CLONE_REPO=true                         # Default is `false`
#   VERBOSE=true                            # Show all the executed commands, default is `false`

# ==============================================================================

export TERM=xterm-256color

SCRIPT_DIR=$([ -n "${BASH_SOURCE[0]}" ] && cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd || dirname "$(readlink -f "$0")")

ORG_NAME=make-ops-tools
REPO_NAME=detect-operating-system
PROJECT_NAME=$ORG_NAME-$REPO_NAME

BRANCH_NAME=${BRANCH_NAME:-main}
INSTALL_DIR=${INSTALL_DIR:-$HOME/.local/share/$ORG_NAME/$REPO_NAME}
CLONE_REPO=${CLONE_REPO:-false}

CMD_PATH=$HOME/.local/bin
CMD_NAME=$REPO_NAME.sh

# ==============================================================================

function main() {

  cd $SCRIPT_DIR

  clone || download
  check && install
  finish
}

function clone() {

  if (is-arg-false "$CLONE_REPO" || ! is-arg-true "$CLONE_REPO") then
    return 1
  fi

  if ! [ -d "$INSTALL_DIR/.git" ]; then
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    git clone https://github.com/$ORG_NAME/$REPO_NAME.git .
  else
    cd "$INSTALL_DIR"
    git pull --all
  fi
  git checkout "$BRANCH_NAME"
}

function download() {

  curl -L \
    "https://github.com/$ORG_NAME/$REPO_NAME/tarball/$BRANCH_NAME?$(date +%s)" \
    -o /tmp/$PROJECT_NAME.tar.gz
  tar -zxf /tmp/$PROJECT_NAME.tar.gz -C /tmp
  rm -rf /tmp/$PROJECT_NAME.tar.gz
  rm -rf $INSTALL_DIR
  mkdir -p $(dirname $INSTALL_DIR)
  mv /tmp/$PROJECT_NAME-* "$INSTALL_DIR"
  cd "$INSTALL_DIR"
}

# ==============================================================================

function check() {

  present=$(tput setaf 64; printf present;tput sgr0)
  missing=$(tput setaf 196; printf missing;tput sgr0)

  printf "Prerequisites:\n"

  [ -x /bin/bash ] && value=$present || value=$missing
  printf "bash [%s]\n" "$value"
  (make --version 2> /dev/null | grep -i "gnu make" | grep -Eq '[4]\.[0-9]+') && value=$present || value=$missing
  printf "make [%s]\n" "$value"
  which git > /dev/null 2>&1 && value=$present || value=$missing
  printf "git [%s]\n" "$value"
  which docker > /dev/null 2>&1 && value=$present || value=$missing
  printf "docker [%s]\n" "$value"
}

function install() {

  mkdir -pv $CMD_PATH
  ln -sfv \
    $INSTALL_DIR/scripts/$CMD_NAME \
    $CMD_PATH/$CMD_NAME
}

function finish() {

  printf "Project directory %s\n" "$INSTALL_DIR"
  printf "Executable %s\n" "$CMD_PATH/$CMD_NAME"
  printf "Add to your PATH the $CMD_PATH directory, i.e. 'PATH=\"$CMD_PATH:\$PATH\"' or\n"
  printf "create an alias i.e. 'alias detect-os=\"$CMD_PATH/$CMD_NAME | sed 's/export //'\"'\n"
}

# ==============================================================================

function is-arg-true() {

  if [[ "$1" =~ ^(true|yes|y|on|1|TRUE|YES|Y|ON)$ ]]; then
    return 0
  else
    return 1
  fi
}

function is-arg-false() {

  if [[ "$1" =~ ^(false|no|n|off|0|FALSE|NO|N|OFF)$ ]]; then
    return 0
  else
    return 1
  fi
}

# ==============================================================================

is-arg-true "$VERBOSE" && set -x
main $*

exit 0
