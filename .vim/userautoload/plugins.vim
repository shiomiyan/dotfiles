" === vim-plug setting ===
call plug#begin()
Plug 'morhetz/gruvbox' " theme
Plug 'arcticicestudio/nord-vim' " theme
Plug 'airblade/vim-gitgutter' " git status on sidebar
Plug 'sheerun/vim-polyglot' " language support
Plug 'cohama/lexima.vim' " Complete parenthesis
Plug 'rust-lang/rust.vim' " Rust dev pulgin
Plug 'racer-rust/vim-racer' " Rust code completion
Plug 'wakatime/vim-wakatime' " coding time management
Plug 'hugolgst/vimsence' " Discord RPC
Plug 'itchyny/lightline.vim' " insane vim statusline
Plug 'prabirshrestha/vim-lsp' " language server plugin
Plug 'mattn/vim-lsp-settings' " easy LSP setting plugin
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'w0rp/ale' " linter
Plug 'ianding1/leetcode.vim'
call plug#end()


" === leetcode customization ===
let g:leetcode_solution_filetype = 'rust'
let g:leetcode_browser = 'firefox'

" lightline configuration
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste', 'yank' ],
      \             [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ }

" Rust auto formatting when saved
let g:rustfmt_autosave = 1

" ale optional setting
let g:ale_fixers = {
      \ 'ruby': ['rubocop'],
      \ }
let g:ale_statusline_format = ['✘ %d', '⚠ %d', 'NE']
let g:ale_fix_on_save = 1

" vimsence customization
let g:vimsence_editing_state = ''
