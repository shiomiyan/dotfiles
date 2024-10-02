local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
require("lazy").setup({
    "machakann/vim-highlightedyank",
})

local vscode = require("vscode-neovim")
vim.opt.clipboard = "unnamedplus"
vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<Tab>", "gt")
vim.keymap.set("n", "<S-Tab>", "gT")
vim.api.nvim_set_keymap("n", "C-h", ":noh<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "p", "_dp", { noremap = false, silent = true })
vim.opt.matchpairs = "(:),{:},[:],（:）,「:」,【:】"

vim.filetype.add({
    extension = {
        mdx = 'mdx'
    }
})

