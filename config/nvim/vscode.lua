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
vim.opt.matchpairs = "(:),{:},[:],（:）,「:」,【:】"

vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<Tab>", "gt")
vim.keymap.set("n", "<S-Tab>", "gT")
vim.api.nvim_set_keymap("n", "C-h", ":noh<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "p", "_dp", { noremap = false, silent = true })

-- gj gk for vscode: START
-- https://zenn.dev/januswel/articles/bf117ede3f5091
local mappings = {
    up = 'k',
    down = 'j',
    wrappedLineStart = '0',
    wrappedLineFirstNonWhitespaceCharacter = '^',
    wrappedLineEnd = '$',
}

local function moveCursor(to, select)
    return function()
        local mode = vim.api.nvim_get_mode()
        if mode.mode == 'V' or mode.mode == '' then
            return mappings[to]
        end

        vscode.action('cursorMove', {
            args = {
                {
                    to = to,
                    by = 'wrappedLine',
                    value = vim.v.count1,
                    select = select
                },
            },
        })
        return '<Ignore>'
    end
end

vim.keymap.set('n', 'k', moveCursor('up'), { expr = true })
vim.keymap.set('n', 'j', moveCursor('down'), { expr = true })
vim.keymap.set('n', '0', moveCursor('wrappedLineStart'), { expr = true })
vim.keymap.set('n', '^', moveCursor('wrappedLineFirstNonWhitespaceCharacter'), { expr = true })
vim.keymap.set('n', '$', moveCursor('wrappedLineEnd'), { expr = true })

vim.keymap.set('v', 'k', moveCursor('up', true), { expr = true })
vim.keymap.set('v', 'j', moveCursor('down', true), { expr = true })
vim.keymap.set('v', '0', moveCursor('wrappedLineStart', true), { expr = true })
vim.keymap.set('v', '^', moveCursor('wrappedLineFirstNonWhitespaceCharacter', true), { expr = true })
vim.keymap.set('v', '$', moveCursor('wrappedLineEnd', true), { expr = true })
-- gj gk for vscode: END

vim.filetype.add({
    extension = {
        mdx = 'mdx'
    }
})

