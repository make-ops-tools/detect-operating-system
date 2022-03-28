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
INSTALL_DIR=${INSTALL_DIR:-$HOME/.makeops/system-detect}
ORG_NAME=makeops-scripts
PROJECT_NAME=makeops-system-detect
REPO_NAME=system-detect
SCRIPTS_ONLY=${SCRIPTS_ONLY:-false}

# ==============================================================================

function main() {

  clone || download
  check
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
    /tmp/$PROJECT_NAME*
  if [[ "$SCRIPTS_ONLY" =~ ^(true|yes|y|on|1|TRUE|YES|Y|ON)$ ]]; then
    rm /tmp/$ORG_NAME-$REPO_NAME-*/scripts/makeops/$REPO_NAME/init.mk
    find /tmp/$ORG_NAME-$REPO_NAME-*/scripts/makeops/$REPO_NAME -type f -name '*.test.sh' -exec rm -rf {} \;
    mkdir -p "$INSTALL_DIR"
    cp -Rf /tmp/$ORG_NAME-$REPO_NAME-*/scripts/* "$INSTALL_DIR"
    rm -rf /tmp/$ORG_NAME-$REPO_NAME-*
  else
    mv /tmp/$ORG_NAME-$REPO_NAME-* "$INSTALL_DIR"
  fi
}

function check() {

  present=$(tput setaf 64; printf present;tput sgr0)
  missing=$(tput setaf 196; printf missing;tput sgr0)

  printf "\nPrerequisites:\n\n"

  [ -x /bin/bash ] && value=$present || value=$missing
  printf "/bin/bash [%s]\n" "$value"
  (make --version 2> /dev/null | grep -i "gnu make" | grep -Eq '[4]\.[0-9]+') && value=$present || value=$missing
  printf "GNU make [%s]\n" "$value"
  which docker > /dev/null 2>&1 && value=$present || value=$missing
  printf "Docker [%s]\n" "$value"
}

function finish() {

  printf "\nProject installed in %s\n" "$INSTALL_DIR"
  tput setaf 21
  printf "\nAll done!\n\n"
  tput sgr0
}

# ==============================================================================

#main
