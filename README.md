# Make Ops Tools - Detect Operating System

[![detect-operating-system](https://circleci.com/gh/makeops-tools/detect-operating-system.svg?style=svg)](https://app.circleci.com/pipelines/github/makeops-tools/detect-operating-system)

## Table of Contents

- [Make Ops Tools - Detect Operating System](#make-ops-tools---detect-operating-system)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Quick Start](#quick-start)
  - [Usage](#usage)

## Overview

A small utility script to detect `*nix` operating system. It works in `shell` and aims to correctly recognise distributions like

- Alpine
- Debian
- Ubuntu

and more.

## Quick Start

This utility can be installed locally in the user's home directory

```bash
$ curl -L https://raw.githubusercontent.com/makeops-tools/detect-operating-system/main/install.sh | bash
```

A quick test can be done using the `make` targets provided

```bash
$ cd ~/.makeops-tools/detect-operating-system
$ make detect-os
$ make test
```

## Usage

Example 1: Print exports only

```bash
$ ./scripts/detect-operating-system.sh
export SYSTEM_NAME=unix
export SYSTEM_DIST=macos
export SYSTEM_DIST_BASED_ON=bsd
export SYSTEM_PSEUDO_NAME=monterey
export SYSTEM_VERSION=12.3
export SYSTEM_ARCH=arm64
export SYSTEM_ARCH_NAME=arm64
export SYSTEM_KERNEL=21.4.0
export SYSTEM_CONTAINER=false
```

Example 2: Export as system variables

```bash
$ eval "$(./scripts/detect-operating-system.sh)"
$ env | grep ^SYSTEM_
SYSTEM_NAME=unix
SYSTEM_DIST=macos
SYSTEM_DIST_BASED_ON=bsd
SYSTEM_PSEUDO_NAME=monterey
SYSTEM_VERSION=12.3
SYSTEM_ARCH=arm64
SYSTEM_ARCH_NAME=arm64
SYSTEM_KERNEL=21.4.0
SYSTEM_CONTAINER=false
```
