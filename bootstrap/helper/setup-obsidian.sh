#!/usr/bin/env bash

set -e

sudo mkdir -p /opt/obsidian/
BROWSER_DOWNLOAD_URL="$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[] | select(.name | match("^(?!.*arm64).*\\.AppImage$")) | .browser_download_url')"
sudo curl -L $BROWSER_DOWNLOAD_URL -o /opt/obsidian/Obsidian.AppImage
sudo chmod +x /opt/obsidian/Obsidian.AppImage

mkdir -p ~/.local/share/{applications,icons}
ln -s ~/dotfiles/local/share/applications/obsidian.desktop ~/.local/share/applications/obsidian.desktop
ln -s ~/dotfiles/local/share/icons/obsidian.png ~/.local/share/icons/obsidian.png

chmod 755 ~/.local/share/applications/obsidian.desktop

update-desktop-database ~/.local/share/applications/

