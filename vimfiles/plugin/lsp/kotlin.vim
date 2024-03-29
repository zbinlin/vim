let s:cmd = expand('~/kotlin-language-server/bin/kotlin-language-server')
if executable(s:cmd)
    augroup LspKotlin
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-kotlin',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd]},
        \   'allowlist': ['kotlin'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {},
        \   'root_uri': {server_info ->
        \       lsp#utils#path_to_uri(
        \           lsp#utils#find_nearest_parent_file_directory(
        \               lsp#utils#get_buffer_path(), ['gradlew']
        \           )
        \       )
        \   },
        \ })
    augroup END
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType kotlin call s:echo('Sorry, `kotlin-language-server` is not installed. Please see `https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Kotlin`.')
endif
