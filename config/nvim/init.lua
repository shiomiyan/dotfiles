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
    "nvim-lualine/lualine.nvim",
    "arkav/lualine-lsp-progress",
    "rebelot/kanagawa.nvim",
    "machakann/vim-highlightedyank",
    "onsails/lspkind.nvim",
    -- "andymass/vim-matchup",

    -- Semantic language support
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim", -- alternative to nvim-lsp-installer

    -- Completion plugins
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/vim-vsnip", -- required as a nvim-cmp dependency, even if not using snippet

    -- Syntactic language support
    "rust-lang/rust.vim",
    { "cespare/vim-toml", branch = "main" },
    "nvim-treesitter/nvim-treesitter",

    -- Fuzzy finder
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Utilities
    "tpope/vim-surround",
    "folke/which-key.nvim",
    "airblade/vim-gitgutter",
    "mfussenegger/nvim-dap",
    "jose-elias-alvarez/null-ls.nvim",
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
    },
})

---------------------
-- Plugin Settings --
---------------------

-- Status line
require("lualine").setup({
    options = {
        icons_enabled = false,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename", "lsp_progress" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})

-- File Explorer
require("neo-tree").setup({
    window = {
        position = "float",
        popup = {
            -- settings that apply to float position only
            size = {
                height = "80%",
                width = "50%",
            },
            position = "50%",
        },
    },
    filesystem = {
        filtered_items = {
            visible = true,
            hidden_dotfiles = false,
        },
    },
})
vim.api.nvim_set_keymap("n", "<Leader>nt", ":Neotree<CR>", { noremap = true, silent = true })

-- treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = { "gitcommit", "lua", "rust" },
    auto_install = true,
    highlight = {
        enable = true,
    },
})

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
    }, {
        { name = "buffer" },
    }),
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
        },
    },
    formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = "[LSP]",
                buffer = "[Buffer]",
                path = "[Path]",
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
    experimental = {
        ghost_text = true,
    },
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<Space>q", vim.diagnostic.setloclist, opts)

-- Setup lspconfig.
local on_attach = function(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<Space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<Space>r", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<Space>a", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<Space>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
end

-- Easy install and setup LSP
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
    ensure_installed = { "rust_analyzer", "lua_ls" },
})

local lspconfig = require("lspconfig")

-- Automatically setup all language servers
mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = on_attach,
        })
    end,
})

-- Setup Lua language server
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

-- Setup Rust language server
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
            checkOnSave = {
                command = "clippy",
            },
        },
    },
})

-- Rust
vim.g.rustfmt_autosave = 1

-- null-ls (only use as formatter)
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
    },
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end,
})

-- Fuzzy search config in Telescope
local telescope = require("telescope")
local telescope_config = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!.git/*")

telescope.setup({
    defaults = { vimgrep_arguments = vimgrep_arguments },
    pickers = {
        find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
        },
    },
})

vim.api.nvim_set_keymap("n", "<Leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true })

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

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 5
vim.opt.laststatus = 2
vim.opt.showmode = false

require("kanagawa").setup({
    transparent = true,
})
vim.cmd("colorscheme kanagawa")

---------------------
-- Editor Settings --
---------------------

vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.updatetime = 300
vim.opt.encoding = "utf-8"
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

---------------------
-- Search Settings --
---------------------

vim.opt.showmatch = true
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
    local win32yank = "/mnt/c/tools/neovim/nvim-win64/bin/win32yank.exe"
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
