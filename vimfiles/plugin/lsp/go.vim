if executable('gopls')
    augroup LspGo
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-go',
        \   'cmd': {
        \       server_info->['gopls', '-remote=auto']
        \   },
        \   'allowlist': ['go'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {},
        \   'semantic_highlight': {},
        \ })

		  autocmd BufWritePre *.go LspDocumentFormatSync
        autocmd FileType go setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType go call s:echo('Sorry, `gopls` is not installed. Please uses `go install golang.org/x/tools/gopls@latest` to install.')
endif
