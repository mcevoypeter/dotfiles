#!/usr/bin/env bash

case $(uname -s) in
  "Darwin")
    brew install pyenv
    ;;
  "Linux")
    sudo apt-get update

    # Install pyenv
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
      libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev \
      libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
      && (curl https://pyenv.run | bash)
    ;;
esac

