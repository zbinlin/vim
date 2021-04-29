if executable('pyls')
    augroup LspPython
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-py',
        \   'cmd': {server_info->['pyls']},
        \   'allowlist': ['python'],
        \   'blocklist': [],
        \ })

        autocmd FileType python setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType python call s:echo('Sorry, `python-language-server` is not installed. Please Uses `pip install --user python-language-server` to install.')
endif
