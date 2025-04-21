let s:cmd = 'vim-language-server'
if executable(s:cmd)
    let s:find_path = {fp -> lsp#utils#path_to_uri(
        \    lsp#utils#find_nearest_parent_file_directory(
        \        lsp#utils#get_buffer_path(), fp
        \    )
        \)}
    let s:config_files = []->map({_, ext -> ext})
    augroup LspVim
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-vim',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. ' --stdio']},
        \   'initialization_options': {},
        \   'allowlist': ['vim'],
        \   'blocklist': [],
        \   'config': {},
        \   'root_uri': {server_info -> s:find_path('.git')},
        \   'workspace_config': {},
        \   'semantic_highlight': {},
        \   'languageId': {server_info -> &filetype},
        \ })
    augroup END
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType vim call s:echo('Sorry, ' .. s:cmd .. ' is not installed. Please uses `npm install -g ' .. s:cmd .. ' to install.')
endif
