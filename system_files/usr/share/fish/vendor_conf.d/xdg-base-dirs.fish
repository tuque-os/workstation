# XDG Base Directory
# https://specifications.freedesktop.org/basedir-spec/latest

set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_STATE_HOME "$HOME/.local/state"

fish_add_path ~/.local/bin

# Dotfiles

set -x ANSIBLE_HOME "$XDG_CACHE_HOME/ansible"
set -x ICEAUTHORITY "$XDG_CACHE_HOME/ICEauthority"
set -x WGETRC "$XDG_CONFIG_HOME/wgetrc"
set -x LESSHISTFILE "-"
set -x ANDROID_HOME "$XDG_DATA_HOME"/android
set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
set -x HISTFILE "$XDG_DATA_HOME/bash/history"
set -x PYLINTHOME "$XDG_CACHE_HOME/pylint"
set -x SQLITE_HISTORY "$XDG_DATA_HOME/sqlite_history"
set -x GOPATH "$XDG_DATA_HOME/go"
set -x GNUPGHOME "$XDG_DATA_HOME/gnupg"
