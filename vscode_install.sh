ln -sf ~/dotfiles/.vscode/settings.json
ln -sf ~/dotfiles/.vscode/keybindings.json

# install vscode extensions from extensions list file
cat .vscode/extensions | xargs -L1 code --install-extension
