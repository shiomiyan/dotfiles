syntax enable

" ==============================
" # Plugins
" ==============================
call plug#begin()

" Load plugins
" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'luisiacc/gruvbox-baby', {'branch': 'main'}
Plug 'lukas-reineke/indent-blankline.nvim'

" Language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-surround'

" Fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Other utilities
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-denops/denops.vim'
Plug 'kat0h/bufpreview.vim' " Markdown preview

if has('unix')
    Plug 'rlue/vim-barbaric' " Switch IME between editor modes
endif

call plug#end()

runtime! plugins.vim

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
colorscheme gruvbox-baby
let g:gruvbox_baby_transparent_mode = 1

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
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_sizestyle="H"
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_browse_split=3
let g:netrw_winsize = 25
let g:netrw_alto = 1
let g:netrw_altv=1

let g:NetrwIsOpen=0
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction
" Toggle netrw with Ctrl-e
noremap <silent> <C-e> :call ToggleNetrw()<CR>

" ==============================
" # Other settings
" ==============================
" Remove ws at the eol
autocmd BufWritePre * :%s/\s\+$//ge

" Terminal settings
if has('win32')
    let &shell = has('win32') ? 'pwsh' : '/usr/bin/zsh'
    let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
endif

" ==============================
" # Plugin settings
" ==============================
" Lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction'
      \ },
      \ }

" Coc status integration for lightline
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

" Rust
let g:rustfmt_autosave = 1

" Disable IME in insert mode with vim-barbaric
if has('unix')
    let g:barbaric_ime = 'ibus'
    let g:barbaric_scope = 'buffer'
endif

" ==============================
" # Keymaps
" ==============================
nnoremap j gj
nnoremap k gk
" Ctrl-h to stop searching
nnoremap <C-h> :nohlsearch<cr>

" Tab movements
nnoremap <Tab> gt
nnoremap <S-Tab> gT

" Switch buffers
nnoremap <silent> [j :bprev<CR>
nnoremap <silent> [k :bnext<CR>

" Open terminal
nnoremap <leader>t :terminal<CR>

" Paste without yank https://stackoverflow.com/a/11993928
vnoremap p "_dp

" Exit terminal mode with Ctrl-[
tnoremap <C-[> <C-\><C-n>

" Navigate the coc completion list with Tab key
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Complete brackets with coc-pairs
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Jump to definition with coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Fuzzy finder with telescope.nvim
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
