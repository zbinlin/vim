let s:cmd = 'bash-language-server'
if executable(s:cmd)
    augroup LspBash
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-bash',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. ' start']},
        \   'allowlist': ['sh'],
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
    autocmd FileType sh call s:echo('Sorry, `bash-language-server` is not installed. Please uses `npm install --global bash-language-server` to install.')
endif
