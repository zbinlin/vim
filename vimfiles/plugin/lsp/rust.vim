if executable('rls')
    augroup LspRust
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-rust',
        \   'cmd': {
        \       server_info->['rustup', 'run', 'stable', 'rls']
        \   },
        \   'allowlist': ['rust'],
        \   'blocklist': [],
        \   'workspace_config': {
        \       'rust': {
        \           'clippy_preference': 'on',
        \       },
        \   },
        \ })

        autocmd FileType rust setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType rust call s:echo('Sorry, `rls` is not installed. Please Uses `rustup update && rustup component add rls rust-analysis rust-src` to install.')
endif
