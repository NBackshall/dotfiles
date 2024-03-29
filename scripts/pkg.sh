#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

DEBIAN_FRONTEND=noninteractive

do_install() {
    local shared_packages=(
        curl
        htop
        httpie
        jq
        moreutils
        python3
        tree
        unzip
        wget
        xclip
    )

    info "[pkg] Install"

    if [ "$(uname)" == "Darwin" ]; then
        brew install "${shared_packages[@]}"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        local linux_packages=(
            build-essential
            cmake
            dconf-cli
            libreadline-dev
            ncurses-term
            python3-pip
            units
            unrar
            uuid-runtime
        )
        sudo apt update
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${shared_packages[@]}"
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${linux_packages[@]}"
    fi
}

main() {
    command=$1
    case $command in
        "install")
            shift
            do_install "$@"
            ;;
        *)
            error "$(basename "$0"): '$command' is not a valid command"
            ;;
    esac
}

main "$@"
