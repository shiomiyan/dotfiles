syntax on
language C " set English document
filetype plugin on

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

" ===netrw setting===
let g:netrw_liststyle=3 " `ls -la` like
let g:netrw_banner=0
let g:netrw_sizestyle="H"
let g:netrw_browse_split=3
let g:netrw_latv=1

" ===Vim terminal setting===
set splitbelow
set termwinsize=7x0
function! TermOpen()
    if empty(term_list())
        execute "terminal"
    endif
endfunction

" ===Vim other setting===
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
" set mouse=n
set relativenumber
let g:python3_host_prog = '/usr/bin/python3'

" filetype conversion
autocmd BufNewFile,BufRead Schemafile set filetype=ruby

" ===additional indent detection by file type===
augroup fileTypeIndent
  autocmd!
  "autocmd BufNewFile,BufRead *.c setlocal tabstop=4 shiftwidth=4
  "autocmd BufNewFile,BufRead *.cpp setlocal tabstop=4 shiftwidth=4
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
