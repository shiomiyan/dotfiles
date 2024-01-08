-- Neovide config also in neovide/config.toml
-- see: https://neovide.dev/config-file.html
vim.o.guifont = "Fira Code,BIZ UDGothic,Symbols Nerd Font Mono:h10"
vim.opt.linespace = 8
if vim.fn.has("osx") then
    vim.o.guifont = "Fira Code,BIZ UDGothic,Symbols Nerd Font Mono:h16"
    vim.opt.linespace = 16
end
vim.g.neovide_transparency = 0.8
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_animation_length = 0.01
vim.g.neovide_remember_window_size = true
