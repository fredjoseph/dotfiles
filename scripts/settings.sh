#!/bin/bash

# Install the plugins without waiting for the first launch
vi -E -s +PlugInstall +visual +qall >/dev/null 2>&1
