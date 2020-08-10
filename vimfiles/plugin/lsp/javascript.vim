if executable('typescript-language-server')
    augroup LspJavascript
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-javascript',
        \   'cmd': {
        \       server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']
        \   },
        \   'allowlist': ['javascript', 'javascript.tsx', 'javascriptreact'],
        \   'blocklist': [],
        \   'root_uri':{
        \       server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'jsconfig.json'))
        \   },
        \ })

        autocmd FileType javascript,javascript.jsx,javascriptreact setlocal omnifunc=lsp#complete
    augroup end
else
    echohl ErrorMsg
    echom 'Sorry, `typescript-language-server` is not installed. Please uses `npm install -g typescript typescript-language-server` to install.'
    echohl NONE
endif
