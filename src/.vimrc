syntax enable
language C
filetype plugin indent on

source $VIMRUNTIME/defaults.vim

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

" === coding settings ===
set autoindent
set smartindent
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" === serch settings ===
set wrapscan
set showmatch
set ignorecase
set smartcase
set nowrapscan

" === netrw settings ===
let g:netrw_liststyle=3 " `ls -la` like
let g:netrw_banner=0
let g:netrw_sizestyle="H"
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_browse_split=3

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

" === OS dependencies ===
"if stridx(system('uname -r'), 'microsoft') " if is WSL
"  augroup Yank
"    au!
"    autocmd TextYankPost * :call system('/mnt/c/Windows/System32/clip.exe', @")
"  augroup END
"endif
