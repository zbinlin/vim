let s:cmd = 'gopls'
if executable(s:cmd)
    augroup LspGo
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-go',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. '-remote=auto']},
        \   'allowlist': ['go'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {},
        \ })
    augroup END
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType go call s:echo('Sorry, `gopls` is not installed. Please uses `go install golang.org/x/tools/gopls@latest` to install.')
endif
