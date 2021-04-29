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
        \   'allowlist': ['json', 'jsonc'],
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
        \                   'fileMatch': ['package.json'],
        \                   'url': 'https://json.schemastore.org/package',
        \               },
        \               {
        \                   'fileMatch': ['tsconfig.json'],
        \                   'url': 'https://json.schemastore.org/tsconfig',
        \               },
        \           ],
        \       },
        \   },
        \   'semantic_highlight': {},
        \ })

        autocmd FileType json setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType json call s:echo('Sorry, `vscode-json-languageserver` is not installed. Please uses `npm install --global vscode-json-languageserver` to install.')
endif
