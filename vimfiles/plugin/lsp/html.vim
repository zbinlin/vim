if executable('html-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ls-html',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'html-languageserver --stdio']},
        \ 'whitelist': ['html'],
    \ })
else
    echohl ErrorMsg
    echom 'Sorry, `vscode-html-languageserver-bin` is not installed. Uses `npm install --global vscode-html-languageserver-bin` to install.'
    echohl NONE
endif

autocmd FileType html setlocal omnifunc=lsp#complete
