if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ls-rust',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
else
    echohl ErrorMsg
    echom 'Sorry, `rls` is not installed. Uses `rustup update && rustup component add rls rust-analysis rust-src` to install.'
    echohl NONE
endif

autocmd FileType rust setlocal omnifunc=lsp#complete
