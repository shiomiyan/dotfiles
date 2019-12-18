syntax on
language C " set English document

" === vim-plug setting ===
call plug#begin()
Plug 'tomasr/molokai' " theme
Plug 'micha/vim-colors-solarized' "theme
Plug 'kristijanhusak/vim-hybrid-material' " theme
Plug 'morhetz/gruvbox' " theme
Plug 'luochen1990/rainbow' "bracket colorizer
Plug 'airblade/vim-gitgutter' " git status on sidebar
Plug 'sheerun/vim-polyglot' " language support
Plug 'cohama/lexima.vim' " Complete parenthesis
Plug 'rust-lang/rust.vim' " Rust dev pulgin
Plug 'racer-rust/vim-racer' " Rust code completion
Plug 'fatih/vim-go' " Go lang dev plugin
Plug 'ElmCast/elm-vim' " Elm dev plugin
Plug 'mattn/sonictemplate-vim' " Template by file type
Plug 'wakatime/vim-wakatime' " coding time management
Plug 'itchyny/lightline.vim' " insane vim statusline
Plug 'yuttie/comfortable-motion.vim' " smooth scroll
Plug 'justinmk/vim-dirvish' " filer
Plug 'prabirshrestha/async.vim' " for async complete
Plug 'prabirshrestha/vim-lsp' " language server plugin
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'ryanolsonx/vim-lsp-javascript'
Plug 'ryanolsonx/vim-lsp-python'
Plug 'ryanolsonx/vim-lsp-typescript'
call plug#end()

" === Vim appearance setting ===
set showmode
set showcmd
set number
set t_Co=256
set cursorline
set scrolloff=6
set laststatus=2
set noshowmode
set background=dark
colorscheme gruvbox
let g:rainbow_active = 1

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

" ===key mappings===
nnoremap j gj
nnoremap k gk
" ===Tab completion with asyncomplete.vim
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
" practice Vim options
nnoremap <Down> <Nop>
nnoremap <Up> <Nop>
nnoremap <Right> <Nop>
nnoremap <Left> <Nop>
inoremap <Down> <Nop>
inoremap <Up> <Nop>
inoremap <Right> <Nop>
inoremap <Left> <Nop>

" === vim-racer configration ===
" let g:racer_cmd = expand('~/.cargo/bin/racer')

" === vim-lsp configuration ===
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

" Python language server
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

" Rust language server
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif

" Elm language server
if executable('elm-language-server')
  au User lsp_setup call lsp#register_server({
      \ 'name': 'elm-language-server',
      \ 'cmd': {server_info->['elm-language-server']},
      \ 'whitelist': ['elm'],
      \ })
endif

" Java language server
if executable('java') && filereadable(expand('~/lsp/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.5.300.v20190213-1655.jar'))
    au User lsp_setup call lsp#register_server({
        \ 'name': 'eclipse.jdt.ls',
        \ 'cmd': {server_info->[
        \     'java',
        \     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        \     '-Dosgi.bundles.defaultStartLevel=4',
        \     '-Declipse.product=org.eclipse.jdt.ls.core.product',
        \     '-Dlog.level=ALL',
        \     '-noverify',
        \     '-Dfile.encoding=UTF-8',
        \     '-Xmx1G',
        \     '-jar',
        \     expand('~/lsp/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.5.300.v20190213-1655.jar'),
        \     '-configuration',
        \     expand('~/lsp/eclipse.jdt.ls/config_mac'),
        \     '-data',
        \     getcwd()
        \ ]},
        \ 'whitelist': ['java'],
        \ })
endif

" C/C++ language server with Clangd
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

" Typescript language server
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx'],
        \ })
endif

" setting for Elm
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:elm_syntastic_show_warnings = 1

" lightline configuration
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste', 'yank' ],
      \             [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ }

" elm-format config
let g:elm_format_autosave = 1

" rust auto formatting when saved
let g:rustfmt_autosave = 1

" Template for solving atcoder with Rust
autocmd BufNewFile ~/Documents/competitive-programming/**/*.rs :0r ~/.vim/templates/atcoder.rs
