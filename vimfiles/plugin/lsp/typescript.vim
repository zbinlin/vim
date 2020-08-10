if executable('typescript-language-server')
    augroup LspTypescript
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-typescript',
        \   'cmd': {
        \       server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']
        \   },
        \   'allowlist': ['typescript', 'typescript.jsx', 'typescriptreact'],
        \   'blocklist': [],
        \   'root_uri':{
        \       server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))
        \   },
        \ })

        autocmd FileType typescript,typescript.tsx,typescriptreact setlocal omnifunc=lsp#complete
    augroup end
else
    echohl ErrorMsg
    echom 'Sorry, `typescript-language-server` is not installed. Please uses `npm install -g typescript typescript-language-server` to install.'
    echohl NONE
endif

"augroup lsp_folding
"autocmd!
"autocmd FileType typescript setlocal
"    \ foldmethod=expr
"    \ foldexpr=lsp#ui#vim#folding#foldexpr()
"    \ foldtext=lsp#ui#vim#folding#foldtext()
"augroup end
