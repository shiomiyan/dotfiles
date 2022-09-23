-- ==============================
-- # Plugins
-- ==============================
local plug = vim.fn["plug#"]
vim.call("plug#begin")
-- Load plugins
-- GUI enhancements
plug("itchyny/lightline.vim")
plug("sainnhe/gruvbox-material")
plug("folke/tokyonight.nvim", { branch = "main" })
plug("machakann/vim-highlightedyank")
-- plug('andymass/vim-matchup')

-- Semantic language support
plug("neovim/nvim-lspconfig")
plug("williamboman/mason.nvim")
plug("williamboman/mason-lspconfig.nvim") -- alternative to nvim-lsp-installer

-- Completion plugins
plug("hrsh7th/nvim-cmp")
plug("hrsh7th/cmp-nvim-lsp")
plug("hrsh7th/cmp-buffer")
plug("hrsh7th/vim-vsnip") -- required as a nvim-cmp dependency, even if not using snippet

-- Syntactic language support
plug("rust-lang/rust.vim")
plug("cespare/vim-toml")

-- Fuzzy finder
plug("nvim-lua/plenary.nvim")
plug("nvim-telescope/telescope.nvim", { branch = "0.1.x" })

-- Utilities
plug("vim-denops/denops.vim")
plug("kat0h/bufpreview.vim") -- Markdown preview
plug("tpope/vim-surround")
plug("folke/which-key.nvim")
plug("airblade/vim-gitgutter")

vim.call("plug#end")

-- ==============================
-- # GUI settings
-- ==============================
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.updatetime = 300

-- Load and set colorscheme
--vim.cmd[[
--let g:gruvbox_material_background = 'hard'
--let g:gruvbox_material_better_performance = 1
--let g:gruvbox_material_diagnostic_text_highlight = 1
--let g:gruvbox_material_transparent_background = 1
--let g:gruvbox_material_disable_italic_comment = 1
--colorscheme gruvbox-material
--]]

require("tokyonight").setup({
    style = "night",
    transparent = true,
    styles = {
        comments = { italic = false },
        keywords = { italic = false },
    },
})
vim.cmd([[colorscheme tokyonight]])

-- ==============================
-- # Plugin settings
-- ==============================
-- Lightline
vim.g.lightline = {
    active = {
        left = { { "mode", "paste" }, { "readonly", "filename", "modified" } },
        right = { { "lineinfo" }, { "percent" }, { "fileformat", "fileencoding", "filetype" } },
    },
}

-- ==============================
-- # LSP Settings
-- ==============================
-- Function for tab completion with nvim-cmp
--local has_words_before = function()
--    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
--end

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
        -- { name = "buffer", keyword_length = 5 },
    }, {
        { name = "buffer" },
    }),

    formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = "[L]",
                path = "[p]",
                buffer = "[b]",
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },

    experimental = {
        ghost_text = true,
    },
})

-- Setup lspconfig.
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>tab split | lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<space>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<space>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Easy install and setup LSP
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
    ensure_installed = { "rust_analyzer", "powershell-editor-services", "sumneko_lua" },
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
lspconfig.sumneko_lua.setup({
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

-- Fuzzy search config in Telescope
-- Find files using Telescope command-line sugar.
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

-- Key bindings cheat sheet via which-key
vim.api.nvim_set_keymap("n", "<F9>", ":WhichKey", { noremap = true, silent = true })

-- ==============================
-- # Editor settings
-- ==============================
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.backup = false
vim.opt.swapfile = false
-- vim.opt.viminfo=
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "sjis", "euc-jp", "iso-2022-jp" }
vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.list = true
vim.opt.listchars = { tab = "▸-" }
vim.opt.clipboard = "unnamedplus"
-- vim.opt.wildmode=longest:full,full
vim.opt.relativenumber = true
vim.opt.helplang = { "ja", "en" }
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo")
vim.opt.mouse = "a"
vim.opt.cmdheight = 2
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.wrap = false

-- ==============================
-- # Search settings
-- ==============================
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = false

-- ==============================
-- # Netrw settings
-- ==============================
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_sizestyle = "H"
vim.g.netrw_timefmt = "%Y/%m/%d(%a) %H:%M:%S"
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 20
vim.g.netrw_alto = 1
vim.g.netrw_altv = 1

-- ==============================
-- # Other settings
-- ==============================
-- Remove ws at the eol
vim.cmd([[
function! s:remove_trailing_space_on_save()
    let cursor = getpos(".")
    %s/\s\+$//ge
    call setpos(".", cursor)
    unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_trailing_space_on_save()
]])

-- To use system clipboard in WSL
local is_wsl = (function()
    local output = vim.fn.systemlist("uname -r")
    return not not string.find(output[1] or "", "WSL")
end)()
if is_wsl then
    local win32yank_executable_path = "/mnt/c/tools/neovim/nvim-win64/bin/win32yank.exe"
    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = win32yank_executable_path .. " -i --crlf",
            ["*"] = win32yank_executable_path .. " -i --crlf",
        },
        paste = {
            ["+"] = win32yank_executable_path .. " -o --lf",
            ["*"] = win32yank_executable_path .. " -o --lf",
        },
        cache_enabled = 0,
    }
end

-- ==============================
-- # Keymaps
-- ==============================
-- Unmap arrow keys
vim.api.nvim_set_keymap("n", "<Up>", "<Nop>", {})
vim.api.nvim_set_keymap("n", "<Down>", "<Nop>", {})
vim.api.nvim_set_keymap("n", "<Left>", "<Nop>", {})
vim.api.nvim_set_keymap("n", "<Right>", "<Nop>", {})
vim.api.nvim_set_keymap("i", "<Up>", "<Nop>", {})
vim.api.nvim_set_keymap("i", "<Down>", "<Nop>", {})
vim.api.nvim_set_keymap("i", "<Left>", "<Nop>", {})
vim.api.nvim_set_keymap("i", "<Right>", "<Nop>", {})

-- Vertical movement depends on displayed lines
vim.api.nvim_set_keymap("n", "j", "gj", {})
vim.api.nvim_set_keymap("n", "k", "gk", {})

-- Clear search result highlight
vim.api.nvim_set_keymap("n", "<C-h>", ":nohlsearch<CR>", {})

-- Tab page movements
vim.api.nvim_set_keymap("n", "<Tab>", "gt", {})
vim.api.nvim_set_keymap("n", "<S-Tab>", "gT", {})

-- Switch buffers
vim.api.nvim_set_keymap("n", "<Left>", ":bprev<CR>", {})
vim.api.nvim_set_keymap("n", "<Right>", ":bnext<CR>", {})

-- Open terminal
vim.api.nvim_set_keymap("n", "<Leader>t", ":terminal<CR>", {})

-- Paste without yank https://stackoverflow.com/a/11993928
vim.api.nvim_set_keymap("v", "p", "_dp", {})

-- Exit terminal mode with Ctrl-[
vim.api.nvim_set_keymap("t", "<C-[>", "<C-\\><C-n>", {})
