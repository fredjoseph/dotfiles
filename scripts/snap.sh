#!/bin/bash
# From https://github.com/rakshans1/dotfiles

packages=(
)

cpackages=(
    code
)

sudo snap install "${packages[@]}"

for package in "${cpackages[@]}"
do
   :
  sudo snap install "${package}" --classic
done
