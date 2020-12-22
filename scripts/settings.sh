#!/bin/bash

# Install the plugins without waiting for the first launch
vi +PlugInstall +qall >/dev/null 2>&1

# Yakuake
echo "
[Window]
ShowTabBar=false" >> ~/.config/yakuakerc

# Konsole
sed -i -e "/DefaultProfile=/cDefaultProfile=Default.profile" ~/.config/konsolerc

# Change Keyboard Layout
sed -i -e "/LayoutList=/cLayoutList=fr(azerty),gb(extd)" ~/.config/kxkbrc
