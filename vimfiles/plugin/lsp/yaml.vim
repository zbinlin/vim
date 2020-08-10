if executable('yaml-language-server')
    augroup LspYaml
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-yaml',
        \   'cmd': {
        \       server_info->['yaml-language-server', '--stdio']
        \   },
        \   'allowlist': ['yaml', 'yaml.ansible'],
        \   'blocklist': [],
        \   'workspace_config': {
        \       'yaml': {
        \           'validate': v:true,
        \           'hover': v:true,
        \           'completion': v:true,
        \           'customTags': [],
        \           'schemas': {},
        \           'schemaStore': {
        \               'enable': v:true,
        \           },
        \       },
        \   },
        \ })
        autocmd FileType yaml setlocal omnifunc=lsp#complete
    augroup end
else
    echohl ErrorMsg
    echom 'Sorry, `yaml-language-server` is not installed. Please uses `npm install --global yaml-language-server` to install.'
    echohl NONE
endif
