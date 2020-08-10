if executable('vscode-json-languageserver')
    augroup LspJson
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-json',
        \   'cmd': {
        \       server_info->['vscode-json-languageserver', '--stdio']
        \   },
        \   'initialization_options': {
        \       'provideFormatter': v:false,
        \   },
        \   'allowlist': ['json'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {
        \       'http': {
        \           'proxy': '',
        \       },
        \       'json': {
        \           'format': v:false,
        \           'schemas': [
        \               {
        \                   'fileMatch': ['package.json', 'package-lock.json'],
        \                   'url': 'https://json.schemastore.org/package',
        \               },
        \           ],
        \       },
        \   },
        \   'semantic_highlight': {},
        \ })

        autocmd FileType json setlocal omnifunc=lsp#complete
    augroup end
else
    echohl ErrorMsg
    echom 'Sorry, `vscode-json-languageserver` is not installed. Please uses `npm install --global vscode-json-languageserver` to install.'
    echohl NONE
endif
