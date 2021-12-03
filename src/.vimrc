syntax on
language C " set English document
filetype plugin on

" === load plugins ===
runtime! userautoload/plugins.vim

" === appearance settings ===
colorscheme gruvbox
set showmode
set showcmd
set number
set t_Co=256
set cursorline
set scrolloff=10
set laststatus=2
set noshowmode
set background=dark
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight SpecialKey ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

" === coding settings ===
set autoindent
set smartindent
set smarttab
set tabstop=2
set shiftwidth=2
set expandtab

" === serch settings ===
set wrapscan
set showmatch
set ignorecase
set smartcase
set nowrapscan

" === netrw settings ===
let g:netrw_liststyle=1 " `ls -la` like
let g:netrw_banner=0
let g:netrw_sizestyle="H"
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_browse_split=3
let g:netrw_latv=1

" === other settings ===
set autoread
set nobackup
set noswapfile
set encoding=utf-8
set fileencodings=utf-8,sjis,euc-jp,iso-2022-jp
set fileencoding=utf-8
set fileformat=unix
set list listchars=tab:\▸\-
set clipboard+=unnamed
set backspace=indent,start,eol
set wildmode=longest:full,full
set relativenumber

" delete unnecessary spaces on save
autocmd BufWritePre * :%s/\s\+$//ge

" === load setting files ===
runtime! userautoload/keymaps.vim

" Template for solving atcoder with Rust
autocmd BufNewFile ~/dev/competitive-programming/**/*.rs :0r ~/.vim/templates/atcoder.rs
