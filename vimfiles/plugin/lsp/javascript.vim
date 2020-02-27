if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ls-typescript',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact'],
        \ })
else
    echohl ErrorMsg
    echom 'Sorry, `typescript-language-server` is not installed. Uses `npm install -g typescript typescript-language-server` to install.'
    echohl NONE
endif

autocmd FileType javascript,javascript.jsx,javascriptreact setlocal omnifunc=lsp#complete
