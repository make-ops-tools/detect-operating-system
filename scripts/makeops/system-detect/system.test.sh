#!/bin/bash -ex

# Linux host operating system
uname -s | grep -q "Linux" && /bin/sh -c ' \
  eval "$(./scripts/makeops/system-detect/system.sh)"; \
  env | grep ^SYSTEM_; \
  [ $SYSTEM_NAME = linux ] && \
  [ $SYSTEM_CONTAINER = false ] \
'

# macOS host operating system
uname -s | grep -q "Darwin" && /bin/sh -c ' \
  eval "$(./scripts/makeops/system-detect/system.sh)"; \
  env | grep ^SYSTEM_; \
  [ $SYSTEM_NAME = unix ] && \
  [ $SYSTEM_DIST = macos ] && \
  [ $SYSTEM_CONTAINER = false ] \
'

# Debian image
docker run --interactive --tty --rm \
  --volume "$PWD":/project:ro \
  --workdir /project \
  debian:bullseye-20220316 \
    /bin/sh -c ' \
      eval "$(./scripts/makeops/system-detect/system.sh)"; \
      [ $SYSTEM_DIST = debian ] && \
      [ $SYSTEM_VERSION = 11.2 ] && \
      [ $SYSTEM_CONTAINER = true ] \
    '

# Ubuntu image
docker run --interactive --tty --rm \
  --volume "$PWD":/project:ro \
  --workdir /project \
  ubuntu:jammy-20220315 \
    /bin/sh -c ' \
      eval "$(./scripts/makeops/system-detect/system.sh)"; \
      [ $SYSTEM_DIST = ubuntu ] && \
      [ $SYSTEM_VERSION = 22.04 ] && \
      [ $SYSTEM_CONTAINER = true ] \
    '

# Kali image
docker run --interactive --tty --rm \
  --volume "$PWD":/project:ro \
  --workdir /project \
  kalilinux/kali-last-release \
    /bin/sh -c ' \
      eval "$(./scripts/makeops/system-detect/system.sh)"; \
      [ $SYSTEM_DIST = kali ] && \
      [ $SYSTEM_VERSION = 2022.1 ] && \
      [ $SYSTEM_CONTAINER = true ] \
    '

# ReadHat image
docker run --interactive --tty --rm \
  --volume "$PWD":/project:ro \
  --workdir /project \
  redhat/ubi8-minimal:8.5-240 \
    /bin/sh -c ' \
      eval "$(./scripts/makeops/system-detect/system.sh)"; \
      [ $SYSTEM_DIST = redhat ] && \
      [ $SYSTEM_VERSION = 8.5 ] && \
      [ $SYSTEM_CONTAINER = true ] \
    '

# CentOS image
docker run --interactive --tty --rm \
  --volume "$PWD":/project:ro \
  --workdir /project \
  centos:7.9.2009 \
    /bin/sh -c ' \
      eval "$(./scripts/makeops/system-detect/system.sh)"; \
      [ $SYSTEM_DIST = centos ] && \
      [ $SYSTEM_VERSION = 7.9.2009 ] && \
      [ $SYSTEM_CONTAINER = true ] \
    '

# Alpine image
docker run --interactive --tty --rm \
  --volume "$PWD":/project:ro \
  --workdir /project \
  alpine:20220316 \
    /bin/sh -c ' \
      eval "$(./scripts/makeops/system-detect/system.sh)"; \
      [ $SYSTEM_DIST = alpine ] && \
      [ $SYSTEM_VERSION = 3.16.0 ] && \
      [ $SYSTEM_CONTAINER = true ] \
    '

# Busybox image
docker run --interactive --tty --rm \
  --volume "$PWD":/project:ro \
  --workdir /project \
  busybox:1.34.1 \
    /bin/sh -c ' \
      eval "$(./scripts/makeops/system-detect/system.sh)"; \
      [ $SYSTEM_DIST = busybox ] && \
      [ $SYSTEM_VERSION = 1.34.1 ] && \
      [ $SYSTEM_CONTAINER = true ] \
    '
