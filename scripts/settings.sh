#!/bin/bash

# Install the plugins without waiting for the first launch
vi -E +PlugInstall +qall >/dev/null 2>&1
