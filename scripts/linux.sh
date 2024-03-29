#!/bin/bash
# From https://github.com/rakshans1/dotfiles

# Import helper functions
. $(dirname "$0")/_helper.sh

# Installs some of the common dependencies required for software development
sudo apt-get -qq install curl 2>&1

apt_keys=()
apt_source_files=()
apt_source_texts=()
apt_preference_files=()
apt_preference_texts=()
apt_packages=()
apt_unstable_packages=()
deb_installed=()
deb_sources=()
locales=()

installers_path="cache"

#############################
# WHAT DO WE NEED TO INSTALL?
#############################

# COMMON (packages installed on all environments)
locales+=("en_US.UTF-8 UTF-8")

apt_packages+=(
  apt-transport-https
  autocutsel
  highlight
  htop
  powerline
  snapd
  stow
  tmux
  tree
  vim-gtk3
  xclip
  w3m
  bc
)

apt_unstable_packages+=(
  git
  jq
)

# Add unstable/sid repository
apt_source_files+=(unstable)
apt_source_texts+=("\
deb http://http.us.debian.org/debian unstable main non-free contrib
deb-src http://http.us.debian.org/debian unstable main non-free contrib")
apt_preference_files+=(unstable)
apt_preference_texts+=("\
Package: *
Pin: release a=unstable
Pin-Priority: 99")

# https://github.com/sharkdp/bat
deb_installed+=(bat-musl)
deb_sources+=($(__get_github_release_url "sharkdp/bat" "musl_.*_amd64.deb"))

# https://github.com/sharkdp/fd
deb_installed+=(fd-musl)
deb_sources+=($(__get_github_release_url "sharkdp/fd" "musl_.*_amd64.deb"))

# https://github.com/BurntSushi/ripgrep
deb_installed+=(ripgrep)
deb_sources+=($(__get_github_release_url "BurntSushi/ripgrep" "_amd64.deb"))

# CUSTOM (specific to the local environment corresponding to the current git branch)
_include $(dirname "$0")/linux.custom

###############################################################################
# Functions                                                                   #
###############################################################################
# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }

function array_filter() { __array_filter 1 "$@"; }
# Works like array_filter, but outputs array indices instead of array items.
function array_filter_i() { __array_filter 0 "$@"; }
# The core function. Wheeeee.
function __array_filter() {
  local __i__ __val__ __mode__ __arr__
  __mode__=$1; shift; __arr__=$1; shift
  for __i__ in $(eval echo "\${!$__arr__[@]}"); do
    __val__="$(eval echo "\${$__arr__[__i__]}")"
    if [[ "$1" ]]; then
      "$@" "$__val__" $__i__ >/dev/null
    else
      [[ "$__val__" ]]
    fi
    if [[ "$?" == 0 ]]; then
      if [[ $__mode__ == 1 ]]; then
        eval echo "\"\${$__arr__[__i__]}\""
      else
        echo $__i__
      fi
    fi
  done
}
# Given strings containing space-delimited words A and B, "setdiff A B" will
# return all words in A that do not exist in B. Arrays in bash are insane
# (and not in a good way).
# From http://stackoverflow.com/a/1617303/142339
function setdiff() {
  local debug skip a b
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  if [[ "$1" ]]; then
    local setdiff_new setdiff_cur setdiff_out
    setdiff_new=($1); setdiff_cur=($2)
  fi
  setdiff_out=()
  for a in "${setdiff_new[@]}"; do
    skip=
    for b in "${setdiff_cur[@]}"; do
      [[ "$a" == "$b" ]] && skip=1 && break
    done
    [[ "$skip" ]] || setdiff_out=("${setdiff_out[@]}" "$a")
  done
  [[ "$debug" ]] && for a in setdiff_new setdiff_cur setdiff_out; do
    echo "$a ($(eval echo "\${#$a[*]}")) $(eval echo "\${$a[*]}")" 1>&2
  done
  [[ "$1" ]] && echo "${setdiff_out[@]}"
}

function contains() {
  local seeking=$1
  shift
  local array=$@
  for v in ${array[@]}; do
    if [ "$v" == "$seeking" ]; then
      return 0;
    fi
  done
  unset v
  return 1;
}
###############################################################################
#                                                                             #
###############################################################################

####################
# ACTUALLY DO THINGS
####################

# lib6c ignores the DEBIAN_FRONTEND environment variable and fires a prompt anyway => This should fix it
echo 'libc6 libraries/restart-without-asking boolean true' | sudo debconf-set-selections

# Add APT keys.
if (( ${#apt_keys[@]} > 0 )); then
  e_header "Adding APT keys (${#apt_keys[@]})"
  for key in "${apt_keys[@]}"; do
    e_arrow "$key"
    wget -qO - $key | sudo apt-key add - > /dev/null 2>&1
  done
  unset key
fi

# Add locales
function __temp() { if grep "^[[:blank:]]*[^[:blank:]#]*$1" /etc/locale.gen; then return 1; fi }
locale_i=($(array_filter_i locales __temp))

if (( ${#locale_i[@]} > 0 )); then
  e_header "Adding Locales (${#locale_i[@]})"
  for i in "${locale_i[@]}"; do
    locale=${locales[i]}
    e_arrow "$locale"
    sudo sh -c "echo '$locale' >> /etc/locale.gen"
  done
  unset i
fi
sudo locale-gen

# Add APT sources.
function __temp() { [[ ! -e /etc/apt/sources.list.d/$1.list ]]; }
source_i=($(array_filter_i apt_source_files __temp))

if (( ${#source_i[@]} > 0 )); then
  e_header "Adding APT sources (${#source_i[@]})"
  for i in "${source_i[@]}"; do
    source_file=${apt_source_files[i]}
    source_text=${apt_source_texts[i]}
    if [[ "$source_text" =~ ppa: ]]; then
      e_arrow "$source_text"
      sudo add-apt-repository -y $source_text > /dev/null 2>&1
    else
      e_arrow "$source_file"
      sudo sh -c "echo '$source_text' > /etc/apt/sources.list.d/$source_file.list"
    fi
  done
  unset i
fi

# Add APT preferences.
function __temp() { [[ ! -e /etc/apt/preferences.d/$1 ]]; }
preference_i=($(array_filter_i apt_preference_files __temp))

if (( ${#preference_i[@]} > 0 )); then
  e_header "Adding APT preferences (${#preference_i[@]})"
  for i in "${preference_i[@]}"; do
    preference_file=${apt_preference_files[i]}
    preference_text=${apt_preference_texts[i]}
    e_arrow "$preference_file"
    sudo sh -c "echo '$preference_text' > /etc/apt/preferences.d/$preference_file"
  done
  unset i
fi

# Update APT.
e_header "Updating APT"
sudo apt-get -qq update

# Upgrade APT.
e_header "Upgrading APT"
sudo apt-get -qq -y upgrade

# Install APT packages.
installed_apt_packages="$(dpkg --get-selections | grep -v deinstall | awk 'BEGIN{FS="[\t:]"}{print $1}' | uniq)"
apt_packages=($(setdiff "${apt_packages[*]}" "$installed_apt_packages"))

if (( ${#apt_packages[@]} > 0 )); then
  e_header "Installing APT packages (${#apt_packages[@]})"
  for package in "${apt_packages[@]}"; do
    e_arrow "$package"
    [[ "$(type -t preinstall_$package)" == function ]] && preinstall_$package
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install "$package" > /dev/null && \
    [[ "$(type -t postinstall_$package)" == function ]] && postinstall_$package
  done
  unset package
fi

# Install all unstable packages whether they are already installed or not (install the latest versions)
if (( ${#apt_unstable_packages[@]} > 0 )); then
  e_header "Installing unstable APT packages (${#apt_unstable_packages[@]})"
  for package in "${apt_unstable_packages[@]}"; do
    e_arrow "$package"
    [[ "$(type -t preinstall_$package)" == function ]] && preinstall_$package
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq -t unstable install "$package" > /dev/null && \
    [[ "$(type -t postinstall_$package)" == function ]] && postinstall_$package
    if [[ "$?" -gt 0 ]]; then
      sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install "$package" > /dev/null && \
      [[ "$(type -t postinstall_$package)" == function ]] && postinstall_$package
    fi
  done
  unset package
fi

# Install debs via dpkg
function __temp() { [[ ! -e "$1" ]]; }
deb_installed_filter=($(setdiff "${deb_installed[*]}" "$installed_apt_packages"))
deb_installed_i=($(array_filter_i deb_installed __temp))

if (( ${#deb_installed_i[@]} > 0 )); then
  mkdir -p "$installers_path"
  e_header "Installing debs (${#deb_installed_filter[@]})"
  for i in "${deb_installed_i[@]}"; do
    if ! contains ${deb_installed[i]} ${deb_installed_filter[@]}; then
      continue
    fi
    e_arrow "${deb_installed[i]}"
    deb="${deb_sources[i]}"
    [[ "$(type -t "$deb")" == function ]] && deb="$($deb)"
    installer_file="$installers_path/$(echo "$deb" | sed 's#.*/##')"
    wget -q  -O "$installer_file" "$deb"
    sudo dpkg -i "$installer_file" > /dev/null 2>&1
  done
  unset i
fi

rm -rf "$installers_path"

# restore debconf configuration
echo 'libc6 libraries/restart-without-asking boolean false' | sudo debconf-set-selections
