" === vim-plug setting ===
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-surround'

Plug 'vim-jp/vimdoc-ja'

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
