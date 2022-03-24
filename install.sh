#!/bin/bash -e

# Project installation script.
#
# Usage:
#   $ [options] curl -L bit.ly/makeops-system-detect | bash
#
# Options:
#   BRANCH_NAME=other-branch-than-main
#   INSTALL_DIR=/other/project/scripts
#   SCRIPTS_ONLY=true

# ==============================================================================

BRANCH_NAME=${BRANCH_NAME:-main}
INSTALL_DIR=${INSTALL_DIR:-$HOME/.$PROJECT_NAME}
ORG_NAME=makeops-scripts
PROJECT_NAME=makeops-system-detect
REPO_NAME=system-detect
SCRIPTS_ONLY=${SCRIPTS_ONLY:-false}

# ==============================================================================

function main() {
  clone || download
  finish
}

function clone() {
  if [[ "$SCRIPTS_ONLY" =~ ^(true|yes|y|on|1|TRUE|YES|Y|ON)$ ]]; then
    return 1
  fi
  if ! [ -d "$INSTALL_DIR/.git" ]; then
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    git clone https://github.com/$ORG_NAME/$REPO_NAME.git .
  fi
  cd "$INSTALL_DIR"
  git pull --all
  git checkout "$BRANCH_NAME"
}

function download() {
  curl -L \
    "https://github.com/$ORG_NAME/$REPO_NAME/tarball/$BRANCH_NAME?$(date +%s)" \
    -o /tmp/$PROJECT_NAME.tar.gz
  tar -zxf /tmp/$PROJECT_NAME.tar.gz -C /tmp
  rm -rf \
    /tmp/$PROJECT_NAME.tar.gz \
    /tmp/$PROJECT_NAME* \
    "$INSTALL_DIR"
  if [[ "$SCRIPTS_ONLY" =~ ^(true|yes|y|on|1|TRUE|YES|Y|ON)$ ]]; then
    rm /tmp/$ORG_NAME-$REPO_NAME-*/scripts/makeops/$REPO_NAME/init.mk
    mkdir -p "$INSTALL_DIR"
    mv /tmp/$ORG_NAME-$REPO_NAME-*/scripts/* "$INSTALL_DIR"
    rm -rf /tmp/$ORG_NAME-$REPO_NAME-*
  else
    mv /tmp/$ORG_NAME-$REPO_NAME-* "$INSTALL_DIR"
  fi
}

function finish() {
  tput setaf 4
  printf "\nProject installed in %s \n" "$INSTALL_DIR"
  tput setaf 2
  printf "\nAll done!\n\n"
  tput sgr0
}

# ==============================================================================

main
