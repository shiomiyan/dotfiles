#!/usr/bin/env bash

set -e

mkdir -p /opt/obsidian/
BROWSER_DOWNLOAD_URL="$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[] | select(.name | match("^(?!.*arm64).*\\.AppImage$")) | .browser_download_url')"
curl -L $BROWSER_DOWNLOAD_URL -o /opt/obsidian/Obsidian.AppImage
chmod +x /opt/obsidian/Obsidian.AppImage

ln -sf ~/dotfiles/local/share/applications/obsidian.desktop ~/.local/share/applications/obsidian.desktop
ln -sf ~/dotfiles/config/obsidian/obsidian.png /opt/obsidian/obsidian.png

chmod 755 ~/.local/share/applications/obsidian.desktop

update-desktop-database ~/.local/share/applications/
