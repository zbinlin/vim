if executable('bash-language-server')
    augroup LspBash
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-bash',
        \   'cmd': {
        \       server_info->[&shell, &shellcmdflag, 'bash-language-server start']
        \   },
        \   'allowlist': ['sh'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {},
        \   'semantic_highlight': {},
        \ })

        autocmd FileType sh setlocal omnifunc=lsp#complete
    augroup end
else
    echohl ErrorMsg
    echom 'Sorry, `bash-language-server` is not installed. Please uses `npm install --global bash-language-server` to install.'
    echohl NONE
endif
