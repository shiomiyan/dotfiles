syntax enable

" ==============================
" # Plugins
" ==============================
call plug#begin()

" Load plugins
" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'sainnhe/gruvbox-material'
Plug 'machakann/vim-highlightedyank'
" Plug 'andymass/vim-matchup'

" Semantic language support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim' " alternative to nvim-lsp-installer

" Completion plugins
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/vim-vsnip' " required as a nvim-cmp dependency, even if not using snippet

" Syntactic language support
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

" Fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

" Utilities
Plug 'vim-denops/denops.vim'
Plug 'kat0h/bufpreview.vim' " Markdown preview
Plug 'tpope/vim-surround'
Plug 'folke/which-key.nvim'

" Plugins only works on Linux
if has('unix')
    Plug 'rlue/vim-barbaric' " Switch IME between editor modes
endif

call plug#end()

" ==============================
" # GUI settings
" ==============================
set termguicolors
set t_Co=256
set background=dark
set showmode
set showcmd
set number
set cursorline
set scrolloff=10
set laststatus=2
set noshowmode
set vb t_vb= " No more beeps
set updatetime=300

" Load and set colorscheme
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_diagnostic_text_highlight = 1
let g:gruvbox_material_transparent_background = 1
" let g:gruvbox_material_disable_italic_comment = 1
colorscheme gruvbox-material

" ==============================
" # Plugin settings
" ==============================
" Lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ],
      \ },
      \ }

lua << END
-- ==============================
-- # LSP Settings
-- ==============================
-- Function for tab completion with nvim-cmp
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },

    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
        ['<Tab>'] = function(fallback)
            if not cmp.select_next_item() then
                if vim.bo.buftype ~= 'prompt' and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if not cmp.select_prev_item() then
                if vim.bo.buftype ~= 'prompt' and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer", keyword_length = 5 },
    },

    formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = "[L]",
                path     = "[p]",
                buffer   = "[b]",
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },

    experimental = {
        ghost_text = true
    }
}

-- Setup lspconfig.
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD'      , '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd'      , '<Cmd>tab split | lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K'       , '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi'      , '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>'   , '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr'      , '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d'      , '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d'      , '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Easy install and setup LSP
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
    ensure_installed = { "rust_analyzer", "powershell-editor-services", "sumneko_lua", "jdtls" }
})

local lspconfig = require'lspconfig'

-- Automatically setup all language servers
mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = on_attach
        })
    end
})

-- Setup Rust language server
lspconfig.rust_analyzer.setup {
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
            checkOnSave ={
                command = "clippy",
            }
        },
    },
}
END

" Rust
let g:rustfmt_autosave = 1

" Disable IME in insert mode with vim-barbaric
if has('unix')
    let g:barbaric_ime   = 'ibus'
    let g:barbaric_scope = 'buffer'
endif

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--hidden,--files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Key bindings cheat sheet via which-key
lua require("which-key").setup()
nnoremap <F9> <cmd>WhichKey<cr>

" ==============================
" # Editor settings
" ==============================
filetype plugin indent on
set autoindent
set smartindent
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoread
set nobackup
set noswapfile
set viminfo=
set encoding=utf-8
set fileencodings=utf-8,sjis,euc-jp,iso-2022-jp
set fileencoding=utf-8
set fileformat=unix
set fileformats=unix,dos,mac
set list listchars=tab:\▸\-
set clipboard+=unnamedplus
set backspace=indent,start,eol
set wildmode=longest:full,full
set relativenumber
set helplang=ja,en
set undofile
set undodir=~/.config/nvim/undo
set mouse=a
set cmdheight=2
set completeopt=menuone,noinsert,noselect
set nowrap

" ==============================
" # Search settings
" ==============================
set wrapscan
set showmatch
set ignorecase
set smartcase
set nowrapscan

" ==============================
" # Netrw settings
" ==============================
let g:netrw_liststyle    = 3
let g:netrw_banner       = 0
let g:netrw_sizestyle    = "H"
let g:netrw_timefmt      = "%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_browse_split = 0
let g:netrw_winsize      = 20
let g:netrw_alto         = 1
let g:netrw_altv         = 1

" ==============================
" # Other settings
" ==============================
" Remove ws at the eol
autocmd BufWritePre * :%s/\s\+$//ge

" To use system clipboard in WSL
if stridx(system('uname -r'), 'microsoft')
    let win32yank_executable_path = "/mnt/c/tools/neovim/nvim-win64/bin/win32yank.exe"
    let g:clipboard = {
          \   'name': 'win32yank',
          \   'copy': {
          \      '+': win32yank_executable_path . ' -i --crlf',
          \      '*': win32yank_executable_path . ' -i --crlf',
          \    },
          \   'paste': {
          \      '+': win32yank_executable_path . ' -o --lf',
          \      '*': win32yank_executable_path . ' -o --lf',
          \   },
          \   'cache_enabled': 0,
          \ }
endif

" ==============================
" # Keymaps
" ==============================
" Unmap arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nnoremap j gj
nnoremap k gk

" Ctrl-h to stop searching
nnoremap <C-h> :nohlsearch<cr>

" Tab movements
nnoremap <Tab> gt
nnoremap <S-Tab> gT

" Switch buffers
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>

" Open terminal
nnoremap <leader>t :terminal<CR>

" Paste without yank https://stackoverflow.com/a/11993928
vnoremap p "_dp

" Exit terminal mode with Ctrl-[
tnoremap <C-[> <C-\><C-n>
