-- Neovide config also in neovide/config.toml
-- see: https://neovide.dev/config-file.html
vim.o.guifont = "Moralerspace Argon HW,Symbols Nerd Font Mono:h18"
if vim.fn.has("mac") then
    vim.o.guifont = "Moralerspace Argon HW,Symbols Nerd Font Mono:h18"
end
vim.g.neovide_transparency = 0.8
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_animation_length = 0.01
vim.g.neovide_remember_window_size = true
