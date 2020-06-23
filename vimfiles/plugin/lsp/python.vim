if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ls-py',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
else
    echohl ErrorMsg
    echom 'Sorry, `python-language-server` is not installed. Uses `pip install python-language-server` to  install.'
    echohl NONE
endif

autocmd FileType python setlocal omnifunc=lsp#complete
