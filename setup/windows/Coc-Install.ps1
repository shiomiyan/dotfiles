# Create directory for install Lang Server for coc.nvim
New-item -ItemType Directory $env:LOCALAPPDATA\coc\extensions

# Install extensions
cd $env:LOCALAPPDATA\coc\extensions
if ((Test-Path .\package.json) -eq "True") {
    echo '{"dependencies":{}}' > package.json
}

npm install           `
    coc-pairs         `
    coc-git           `
    coc-json          `
    coc-sh            `
    coc-rust-analyzer `
    coc-pyright       `
    --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

cd -