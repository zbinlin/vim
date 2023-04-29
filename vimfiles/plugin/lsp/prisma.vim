let s:cmd = 'prisma-language-server'
if executable(s:cmd)
    augroup LspPrisma
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-prisma',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. ' --stdio']},
        \   'allowlist': ['prisma'],
        \   'blocklist': [],
        \   'workspace_config': {},
        \   'config': {},
        \   'root_uri': {server_info ->
        \       lsp#utils#path_to_uri(
        \           lsp#utils#find_nearest_parent_file_directory(
        \               lsp#utils#get_buffer_path(), 'schema.prisma'
        \           )
        \       )
        \    },
        \   'initialization_options': {
        \       'diagnostics': 'true',
        \   },
        \ })
    augroup END
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType prisma call s:echo('Sorry, `prisma-language-server` is not installed. Please uses `npm install -g prisma-language-server` to install.')
endif
