if executable(expand('~/kotlin-language-server/bin/kotlin-language-server'))
    augroup LspKotlin
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-kotlin',
        \   'cmd': {
        \       server_info->[&shell, &shellcmdflag, expand('~/kotlin-language-server/bin/kotlin-language-server')]
        \   },
        \   'allowlist': ['kotlin'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {},
        \   'semantic_highlight': {},
        \ })

        autocmd FileType kotlin setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType kotlin call s:echo('Sorry, `kotlin-language-server` is not installed. Please see `https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Kotlin`.')
endif
