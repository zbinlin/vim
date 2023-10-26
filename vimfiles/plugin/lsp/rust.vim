let s:cmd = 'rust-analyzer'
if executable(s:cmd)
    augroup LspRust
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-rust',
        \   'cmd': {server_info -> ['rustup', 'run', 'stable', s:cmd]},
        \   'allowlist': ['rust'],
        \   'blocklist': [],
        \   'initialization_options': {
        \       'checkOnSave': v:true,
        \       'cargo': {
        \       },
        \       'procMacro': {
        \       },
        \       'diagnostics': {
        \           'experimental': {
        \               'enable': v:true,
        \           },
        \       },
        \   },
        \ })
    augroup END
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType rust call s:echo('Sorry, `rust-analyzer` is not installed. Please Uses `pacman -Sy rustup && rustup update && rustup component add rust-analyzer rust-src` to install.')
endif
