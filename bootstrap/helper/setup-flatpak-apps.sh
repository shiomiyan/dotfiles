#!/bin/bash

set -e

flatpak install flathub \
    com.bitwarden.desktop \
    com.discordapp.Discord \
    com.slack.Slack \
    com.spotify.Client \
    org.gnome.Extensions \
    org.localsend.localsend_app
