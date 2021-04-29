if executable('html-languageserver')
    augroup LspHtml
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-html',
        \   'cmd': {
        \       server_info->[&shell, &shellcmdflag, 'html-languageserver --stdio']
        \   },
        \   'allowlist': ['html'],
        \   'blocklist': [],
        \   'initialization_options': {
        \       'embeddedLanguages': {
        \           'css': v:true,
        \           'javascript': v:true,
        \       },
        \   },
        \   'config': {},
        \   'workspace_config': {},
        \   'semantic_highlight': {},
        \ })

        autocmd FileType html setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType html call s:echo('Sorry, `vscode-html-languageserver-bin` is not installed. Please uses `npm install --global vscode-html-languageserver-bin` to install.')
endif
