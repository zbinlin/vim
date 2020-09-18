if executable('css-languageserver')
    augroup LspCss
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-css',
        \   'cmd': {
        \       server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']
        \   },
        \   'allowlist': ['css', 'less', 'sass'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {
        \       'css': {
        \           'lint': {
        \               'validProperties': [],
        \           },
        \       },
        \       'less': {
        \           'lint': {
        \               'validProperties': [],
        \           },
        \       },
        \       'sass': {
        \           'lint': {
        \               'validProperties': [],
        \           },
        \       },
        \       'scss': {
        \           'lint': {
        \               'validProperties': [],
        \           },
        \       },
        \   },
        \   'semantic_highlight': {},
        \ })

        autocmd FileType css,less,sass setlocal omnifunc=lsp#complete
    augroup end
else
    echohl ErrorMsg
    echom 'Sorry, `vscode-css-languageserver-bin` is not installed. Please uses `npm install --global vscode-css-languageserver-bin` to install.'
    echohl NONE
endif
