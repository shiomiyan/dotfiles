#!/usr/bin/env bash

set -e

sudo dnf group install -y development-tools
sudo dnf install -y libevdev-devel

TMP=$(mktemp -d)
git clone --depth=1 https://github.com/wez/evremap.git "$TMP"

pushd $TMP
cargo build --release
sudo cp target/release/evremap /usr/bin/evremap

# config
sudo ln -s ~/dotfiles/system/evremap/evremap.toml /etc/evremap.toml
sudo ln -s ~/dotfiles/system/evremap/evremap-keychron-k2.toml /etc/evremap-keychron-k2.toml
sudo cp ~/dotfiles/system/systemd/*.service /usr/lib/systemd/system/

# init services
sudo systemctl daemon-reload
sudo systemctl enable /usr/lib/systemd/system/evremap.service
sudo systemctl enable /usr/lib/systemd/system/evremap-keychron-k2.service
sudo systemctl start /usr/lib/systemd/system/evremap.service
sudo systemctl start /usr/lib/systemd/system/evremap-keychron-k2.service
