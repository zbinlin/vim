if executable('rust-analyzer')
    augroup LspRust
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-rust',
        \   'cmd': {
        \       server_info->['rust-analyzer']
        \   },
        \   'allowlist': ['rust'],
        \   'blocklist': [],
        \   'initialization_options': {
        \       'cargo': {
        \           'loadOutDirsFromCheck': v:true,
        \       },
        \       'procMacro': {
        \           'enable': v:true,
        \       },
        \   },
        \ })

        autocmd FileType rust setlocal omnifunc=lsp#complete
    augroup end
elseif executable('rls')
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
    autocmd FileType rust call s:echo('Sorry, `rls` or `rust-analyzer` is not installed. Please Uses `rustup update && rustup component add rls rust-analysis rust-src` or `sudo pacman -Sy rust-analyzer && rustup update && rustup component add rust-src` to install.')
endif
