" === key mappings ===
nnoremap j gj
nnoremap k gk

" === tab movements with tab key ===
nnoremap <Tab> gt
nnoremap <S-Tab> gT

" === coc: navigate the completion list with tab key ===
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" === coc: jump to definition ===
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

