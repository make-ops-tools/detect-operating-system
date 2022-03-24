# MakeOps Scripts - System Detect Utility

A small utility to detect `*nix` operating system info. It works in `shell` and aims to detect distributions like

- Alpine
- Debian
- Ubuntu

and more.

## Usage

Example 1: Print exports only

```bash
$ ./system.sh
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
$ eval "$(./system.sh)"
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
