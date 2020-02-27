if executable('css-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ls-css',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
        \ 'whitelist': ['css', 'less', 'sass'],
    \ })
else
    echohl ErrorMsg
    echom 'Sorry, `vscode-css-languageserver-bin` is not installed. Uses `npm install --global vscode-css-languageserver-bin` to install.'
    echohl NONE
endif

autocmd FileType css,less,sass setlocal omnifunc=lsp#complete
