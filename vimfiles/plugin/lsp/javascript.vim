let s:cmd = 'typescript-language-server'
if executable(s:cmd)
    augroup LspJavascript
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-javascript',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. ' --stdio']},
        \   'allowlist': ['javascript', 'javascript.jsx', 'javascriptreact'],
        \   'blocklist': [],
        \   'workspace_config': {},
        \   'config': {},
        \   'root_uri': {server_info ->
        \       lsp#utils#path_to_uri(
        \           lsp#utils#find_nearest_parent_file_directory(
        \               lsp#utils#get_buffer_path(), 'jsconfig.json'
        \           )
        \       )
        \   },
        \   'initialization_options': {
        \       'diagnostics': 'true',
        \   },
        \   'languageId': {server_info -> 'javascript'},
        \ })

        autocmd FileType javascript,javascript.jsx,javascriptreact setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType javascript,javascript.jsx,javascriptreact call s:echo('Sorry, `typescript-language-server` is not installed. Please uses `npm install -g typescript typescript-language-server` to install.')
endif
