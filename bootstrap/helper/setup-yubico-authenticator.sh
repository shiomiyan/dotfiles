#!/usr/bin/env bash

URL='https://developers.yubico.com/yubioath-flutter/Releases/yubico-authenticator-latest-linux.tar.gz'

wget -O $HOME/Downloads/yubico-authenticator-latest-linux.tar.gz $URL

mkdir -p $HOME/Documents/yubico-authenticator
tar -zxvf $HOME/Downloads/yubico-authenticator-latest-linux.tar.gz \
    -C $HOME/Documents/yubico-authenticator \
    --strip-components=1 --wildcards 'yubico-authenticator*/*'

$HOME/Documents/yubico-authenticator/desktop_integration.sh --install

