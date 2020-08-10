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
    echohl ErrorMsg
    echom 'Sorry, `rls` is not installed. Please Uses `rustup update && rustup component add rls rust-analysis rust-src` to install.'
    echohl NONE
endif
