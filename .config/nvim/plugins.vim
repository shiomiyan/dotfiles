" === vim-plug setting ===
call plug#begin()

Plug 'vim-jp/vimdoc-ja'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-surround'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lukas-reineke/indent-blankline.nvim' " indent visualization
Plug 'petertriho/nvim-scrollbar'

Plug 'vim-denops/denops.vim'
Plug 'kat0h/bufpreview.vim' " markdown preview
Plug 'vim-skk/skkeleton'

Plug 'rlue/vim-barbaric' " IME をよしなにしてくれるやつ

" === extra settings for each environment ===
runtime! userautoload/extras.vim

call plug#end()

" coc status integration for lightline
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction'
      \ },
      \ }

let g:rustfmt_autosave = 1

" skkeleton
call skkeleton#config({ 'globalJisyo': '~/.skk/SKK-JISYO.L' })
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)

" disable IME in INSERT MODE
let g:barbaric_ime = 'ibus'
let g:barbaric_scope = 'buffer'
