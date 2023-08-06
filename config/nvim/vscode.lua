vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.api.nvim_set_keymap("n", "C-h", ":noh<CR>", { noremap = true, silent = true })
