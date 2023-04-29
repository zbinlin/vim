let s:cmd = 'pyls'
if executable(s:cmd)
    augroup LspPython
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-py',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd]},
        \   'allowlist': ['python'],
        \   'blocklist': [],
        \ })
    augroup END
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType python call s:echo('Sorry, `python-language-server` is not installed. Please Uses `pip install --user python-language-server` to install.')
endif
