#!/bin/bash
# From https://github.com/rakshans1/dotfiles

# Import helper functions
. $(dirname "$0")/_helper.sh

if ! [ $(command -v "docker") ]; then
    print_header "Installing Docker"
    wget -qO- https://get.docker.com/ | sh
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo service docker restart
fi
if ! [ $(command -v "docker-compose") ]; then
    print_header "Installing Docker Compose"
    sudo curl -sL $(__get_github_release_url "docker/compose" "$(uname -s)-$(uname -m)") -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi