" === key mappings ===
nnoremap j gj
nnoremap k gk

" === tab movements with tab key ===
nnoremap <Tab> gt
nnoremap <S-Tab> gT

" nnoremap <leader>t :terminal<CR>
" nnoremap <leader>t <Cmd>exe v:count1 . "ToggleTerm"<CR>

" paste without yank
" https://stackoverflow.com/a/11993928
vnoremap p "_dp

" Ctrl [ でターミナルモードを抜ける
tnoremap <C-[> <C-\><C-n>

" バッファ切り替え用
nnoremap <silent> [j :bprev<CR>
nnoremap <silent> [k :bnext<CR>

" === coc: navigate the completion list with tab key ===
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" === coc: coc-pairs ===
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" === coc: jump to definition ===
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" telescope.nvim
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
