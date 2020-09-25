test "$MY_ZSH_CUSTOM" || MY_ZSH_CUSTOM=~/.zsh-custom

# __get_github_release_url: Get the download URL of the latest release of an application hosted on Github.
# This function requires 2 parameters
# 1. The Github repository <user/repo>
# 2. The pattern to use to select the valid asset
#
# usage:
#
#   __get_github_release_url "BurntSushi/ripgrep" "amd64.deb"
#   https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
#
__get_github_release_url() {
    # For API requests, the rate limit allows for up to 60 requests per hour => workaround: use the standard github url
    # echo "$(curl -s "https://api.github.com/repos/$1/releases/latest" | grep -Po 'download_url": "\K.*'$2'(?=")')"
    echo "https://github.com$(curl -sL https://github.com/$1/releases/latest | grep -Po 'href="\K.*'$2'(?=")')"
}

# __install_tar_gz: Download the archive, extract it and move the binary to /usr/local/bin.
# This function requires 2 parameters + 1 optional
# 1. The archive file URL
# 2. The name of the file to move to /usr/local/bin
# 3. (Optional) The name of the file in the target destination
#
# usage:
#
#   __install_tar_gz https://github.com/samtay/so/releases/download/v0.4.2/so-v0.4.2-x86_64-unknown-linux-gnu.tar.gz so
#
__install_tar_gz() {
    tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
    archive_file="$(echo "$1" | sed 's#.*/##')"
    wget -q --show-progress -O "$tmp_dir/$archive_file" $1
    tar -xf "$tmp_dir/$archive_file"
    sudo mv $2 /usr/local/bin/$3
    rm -rf "$tmp_dir"
}

# __install_zip: Download the archive, extract it and move the binary to /usr/local/bin.
# This function requires 2 parameters + 1 optional
# 1. The archive file URL
# 2. The name of the file to move to /usr/local/bin
# 3. (Optional) The name of the file in the target destination
#
# usage:
#
#   __install_zip https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip exa-linux-x86_64 exa
#
__install_zip() {
    tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
    archive_file="$(echo "$1" | sed 's#.*/##')"
    wget -q --show-progress -O "$tmp_dir/$archive_file" $1
    unzip "$tmp_dir/$archive_file"
    sudo mv $2 /usr/local/bin/$3
    rm -rf "$tmp_dir"
}

# __install_binary: Download the binary and move it to /usr/local/bin.
# This function requires 2 parameters
# 1. The binary file URL
# 2. The target name to use in /usr/local/bin
#
# usage:
#   __install_binary https://github.com/dbrgn/tealdeer/releases/download/v1.4.1/tldr-linux-x86_64-musl tldr
#
__install_binary() {
    sudo curl -s $1 -o /usr/local/bin/$2
    sudo chmod +x /usr/local/bin/$2
}

# __install_global_zsh_completion: Download the completion file and move it to /usr/local/share/zsh/site-functions
# This function requires 2 parameters
# 1. The completion file URL
# 2. The target name to use in /usr/local/share/zsh/site-functions
#
# usage:
#   __install_global_zsh_completion https://github.com/dbrgn/tealdeer/releases/download/v1.4.1/completions_zsh _tldr
#
__install_global_zsh_completion() {
    sudo curl -sL $1 -o /usr/local/share/zsh/site-functions/$2
}

# __install_private_zsh_plugin: Download the plugin file and move it to $MY_ZSH_CUSTOM/private/plugins
# This function requires 2 parameters
# 1. The completion file URL
# 2. The target name to use in $MY_ZSH_CUSTOM/private/plugins
#
# usage:
#   __install_private_zsh_plugin https://github.com/wfxr/forgit/blob/master/forgit.plugin.zsh
#
__install_private_zsh_plugin() {
    mkdir -p "$MY_ZSH_CUSTOM/private/plugins/"
    sudo curl -sOL $1 -o "$MY_ZSH_CUSTOM/private/plugins/"
}