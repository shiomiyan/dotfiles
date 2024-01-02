#!/usr/bin/env bash

set -e

mkdir -p /opt/obsidian/
BROWSER_DOWNLOAD_URL="$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[] | select(.name | match("^(?!.*arm64).*\\.AppImage$")) | .browser_download_url')"
curl -L $BROWSER_DOWNLOAD_URL -o /opt/obsidian/Obsidian.AppImage
chmod +x /opt/obsidian/Obsidian.AppImage
