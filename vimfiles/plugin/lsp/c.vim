if executable('ccls')
    augroup LspC
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-c',
        \   'cmd': {server_info -> ['ccls']},
        \   'root_uri': {server_info ->
        \       lsp#utils#path_to_uri(
        \           lsp#utils#find_nearest_parent_file_directory(
        \               lsp#utils#get_buffer_path(), ['.ccls', 'compile_commands.json']
        \           )
        \       )
        \   },
		\   'initialization_options': {'cache': {'directory': expand('~/.cache/ccls') }},
        \   'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {},
        \ })
    augroup END
elseif executable('clangd')
    augroup LspC
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-c',
        \   'cmd': {server_info -> ['clangd', '-background-index']},
        \   'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {},
        \ })
    augroup END
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType c,cpp,objc,objcpp call s:echo('Sorry, `clang` or `ccls` is not installed. Please uses `pacman -S clang` or `pacman -S ccls` to install.')
endif
