#!/bin/bash
set -xe

git clone --bare https://github.com/SmartHypercube/dotfiles.git
cd dotfiles.git
git config --local --unset core.bare
git config --local core.worktree "$HOME"
git reset HEAD --
git checkout master "$HOME"
