#!/bin/bash

# Purpose: Updates the devenv from MANTIS-DevEnv upstream repo.
# How:
# 1. Updates the devenv submodule in this repo,
# 2. Copies / moves the nix-shell files to the root of this repo.
#
# *. The devenv scripts are left alone in the devenv folder.

# 1. Updates the devenv submodule in this repo,
git submodule update --init devenv

# 2. Copies / moves the nix-shell file to the root of this repo.
cp -v devenv/shell.nix .
