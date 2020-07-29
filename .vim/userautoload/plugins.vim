" === vim-plug setting ===
call plug#begin()
Plug 'tomasr/molokai' " theme
Plug 'micha/vim-colors-solarized' "theme
Plug 'morhetz/gruvbox' " theme
Plug 'airblade/vim-gitgutter' " git status on sidebar
Plug 'sheerun/vim-polyglot' " language support
Plug 'cohama/lexima.vim' " Complete parenthesis
Plug 'rust-lang/rust.vim' " Rust dev pulgin
Plug 'racer-rust/vim-racer' " Rust code completion
Plug 'ElmCast/elm-vim' " Elm dev plugin
Plug 'mattn/sonictemplate-vim' " Template by file type
Plug 'wakatime/vim-wakatime' " coding time management
Plug 'anned20/vimsence' " Discord RPC
Plug 'itchyny/lightline.vim' " insane vim statusline
Plug 'yuttie/comfortable-motion.vim' " smooth scroll
" Plug 'justinmk/vim-dirvish' " filer
Plug 'prabirshrestha/async.vim' " for async complete
Plug 'prabirshrestha/vim-lsp' " language server plugin
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'ryanolsonx/vim-lsp-javascript'
Plug 'ryanolsonx/vim-lsp-python'
Plug 'ryanolsonx/vim-lsp-typescript'
Plug 'w0rp/ale'
Plug 'ianding1/leetcode.vim' " Enjoy leetcode !
Plug 'mattn/emmet-vim' " GIVE POWER TO HTML
call plug#end()


" === leetcode customization ===
let g:leetcode_solution_filetype = 'rust'
let g:leetcode_browser = 'firefox'

" lightline configuration
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste', 'yank' ],
      \             [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ }

" Elm format config
let g:elm_format_autosave = 1

" Rust auto formatting when saved
let g:rustfmt_autosave = 1

" Python auto formatting when saved
autocmd BufWritePre *.py execute ':Black'

" ale optional setting
let g:ale_fixers = {
      \ 'ruby': ['rubocop'],
      \ }
let g:ale_statusline_format = ['✘ %d', '⚠ %d', 'NE']
let g:ale_fix_on_save = 1
