------------------
-- Load Plugins --
------------------
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
    -- GUI enhancements
    {
        "catppuccin/nvim", name = "catppuccin", priority = 1000,
        config = function ()
            require("catppuccin").setup({
                flavour = "mocha",
                integrations = { treesitter = true }
            })
        end
    },
    "machakann/vim-highlightedyank",
    {
        "beauwilliams/statusline.lua",
        dependencies = { "nvim-lua/lsp-status.nvim" },
        config = function()
            require('statusline').setup({
                match_colorscheme = false,
                tabline = false,
            })
        end,
    },

    -- Semantic language support
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        }
    },

    -- Completion plugins
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/vim-vsnip",
            "onsails/lspkind.nvim", -- GUI enhancement for completion
        },
    },

    -- Syntactic language support
    { "rust-lang/rust.vim", ft = "rust" },
    { "cespare/vim-toml", branch = "main", ft = { "toml" } },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function ()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "gitcommit", "lua", "rust", "javascript", "typescript", "php" },
                auto_install = false,
                highlight = { enable = true },
            })
            vim.treesitter.language.register("markdown", "mdx")
        end,
    },
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        tag = 'stable',
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require('crates').setup()
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function ()
            -- Fuzzy search config in Telescope
            local telescope = require("telescope")
            local telescope_config = require("telescope.config")
            local actions = require("telescope.actions")

            local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
            table.insert(vimgrep_arguments, "--hidden")
            table.insert(vimgrep_arguments, "--glob")
            table.insert(vimgrep_arguments, "!.git/*")

            telescope.setup({
                defaults = {
                    vimgrep_arguments = vimgrep_arguments,
                    mappings = {
                        i = {
                            -- Mapping <Esc> to quit in insert mode
                            ["<esc>"] = actions.close
                        },
                    },
                },
                pickers = {
                    find_files = {
                        find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
                    },
                },
            })

            -- Keymaps for Telescope
            local telescope_builtin = require('telescope.builtin')
            vim.keymap.set("n", "<C-p>", telescope_builtin.find_files, {})
            vim.keymap.set("n", "<C-g>", telescope_builtin.live_grep, {})
            vim.keymap.set("n", "<Leader>fb", telescope_builtin.buffers, {})
            vim.keymap.set("n", "<Leader>fh", telescope_builtin.help_tags, {})
        end
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },

    -- Utilities
    "tpope/vim-surround",
    "airblade/vim-gitgutter",
    "mfussenegger/nvim-dap",
    {
        "folke/which-key.nvim",
        cmd = { "WhichKey" },
    },
})

---------------------
-- Plugin Settings --
---------------------
-- LSP settings
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "crates" },
    }, {
        { name = "buffer" },
    }, {
    }),
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
        },
    },
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"
            return kind
        end,
    },
    experimental = {
        ghost_text = true,
    },
})

-- Global LSP mappings
vim.keymap.set("n", "<Space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<Space>q", vim.diagnostic.setloclist)

-- Additional LSP mappings after the language server attaches to the current buffer.
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        --Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Mappings. ref: https://github.com/neovim/nvim-lspconfig#suggested-configuration
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<Leader>F", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!" },
            },
        },
    }),
})

------------------
-- GUI Settings --
------------------
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 5
vim.opt.laststatus = 2
vim.opt.showmode = false
vim.cmd("colorscheme catppuccin-mocha")

---------------------
-- Editor Settings --
---------------------
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.updatetime = 300
vim.opt.fileencodings = { "utf-8", "sjis", "euc-jp", "iso-2022-jp" }
vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.list = true
vim.opt.listchars = { tab = "▸-" }
vim.opt.clipboard = vim.opt.clipboard + "unnamedplus"
vim.opt.wildmode = "longest:full,full"
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand(vim.fn.stdpath("data") .. "/undo")
vim.opt.mouse = ""
vim.opt.cmdheight = 2
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.wrap = false
vim.opt.mouse = "a"

---------------------
-- Search Settings --
---------------------
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = false

-- Trim white-space at the EOL
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*" },
    callback = function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_command("%s/\\s\\+$//ge")
        vim.api.nvim_win_set_cursor(0, cursor)
    end,
})

-- Windows: use system clipboard in WSL
local is_wsl = (function()
    local output = vim.fn.systemlist("uname -r")
    return not not string.find(output[1] or "", "WSL")
end)()

if is_wsl then
    local win32yank = "win32yank.exe"
    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = win32yank .. " -i --crlf",
            ["*"] = win32yank .. " -i --crlf",
        },
        paste = {
            ["+"] = win32yank .. " -o --lf",
            ["*"] = win32yank .. " -o --lf",
        },
        cache_enabled = 0,
    }
end

-- Linux: disable IME when switch to INSERT mode
if vim.fn.has("unix") and not is_wsl then
    vim.api.nvim_create_autocmd("InsertLeave", {
        command = "call system('fcitx5-remote -c')",
    })
end

-------------
-- Keymaps --
-------------

-- Unmap arrow keys
vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")
vim.keymap.set("i", "<Up>", "<Nop>")
vim.keymap.set("i", "<Down>", "<Nop>")
vim.keymap.set("i", "<Left>", "<Nop>")
vim.keymap.set("i", "<Right>", "<Nop>")

-- Movement
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Clear search result highlight
vim.api.nvim_set_keymap("n", "<C-h>", ":nohlsearch<CR>", { noremap = true, silent = true })

-- Tab page movements
vim.keymap.set("n", "<Tab>", "gt")
vim.keymap.set("n", "<S-Tab>", "gT")

-- Switch buffers
vim.keymap.set("n", "<Left>", ":bprev<CR>")
vim.keymap.set("n", "<Right>", ":bnext<CR>")

-- Open terminal
vim.keymap.set("n", "<Leader>t", ":terminal<CR>")

-- Paste without yank https://stackoverflow.com/a/11993928
vim.keymap.set("v", "p", "_dp")

-- Exit terminal mode with Ctrl-[
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>")

