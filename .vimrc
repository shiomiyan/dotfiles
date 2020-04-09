syntax on
language C " set English document

" load plugins
runtime! userautoload/plugins.vim

" === Vim appearance setting ===
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

" ===Vim coding setting===
set autoindent
set smartindent
set smarttab
set tabstop=2
set shiftwidth=2
set expandtab
set virtualedit=onemore

" ===serch setting===
set wrapscan
set showmatch
set ignorecase
set smartcase
set nowrapscan

" ===Vim other setting===
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
" set mouse=n
set relativenumber

" filetype conversion
autocmd BufNewFile,BufRead Schemafile set filetype=ruby

" ===additional indent detection by file type===
augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.c setlocal tabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.cpp setlocal tabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.rs setlocal tabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.java setlocal tabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.elm setlocal tabstop=4 shiftwidth=4
augroup END
" delete unnecessary spaces
autocmd BufWritePre * :%s/\s\+$//ge

" ===load setting files===
runtime! userautoload/lspconf.vim
runtime! userautoload/keymaps.vim


" Template for solving atcoder with Rust
autocmd BufNewFile ~/dev/competitive-programming/**/*.rs :0r ~/.vim/templates/atcoder.rs
