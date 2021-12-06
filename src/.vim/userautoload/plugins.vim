" === vim-plug setting ===
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'rust-lang/rust.vim'

Plug 'tpope/vim-surround'

call plug#end()

let g:lightline = { 'colorscheme': 'gruvbox' }

let g:rustfmt_autosave = 1
