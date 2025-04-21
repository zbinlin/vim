let s:cmd = 'tailwindcss-language-server'
if executable(s:cmd)
    let s:find_path = {fp -> lsp#utils#path_to_uri(
        \    lsp#utils#find_nearest_parent_file_directory(
        \        lsp#utils#get_buffer_path(), fp
        \    )
        \)}
    let s:config_files = ['js', 'cjs', 'mjs', 'ts', 'cts', 'mts']->map({_, ext -> 'tailwind.config.' .. ext})
    augroup LspTailwindcss
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-tailwindcss',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. ' --stdio']},
        \   'initialization_options': {},
        \   'allowlist': empty(s:find_path(s:config_files)) ? [] : ['html', 'css', 'javascriptreact', 'typescriptreact'],
        \   'blocklist': [],
        \   'config': {},
        \   'root_uri': {server_info -> s:find_path(s:config_files)},
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
    autocmd FileType html,css,javascriptreact,typescriptreact call s:echo('Sorry, ' .. s:cmd .. ' is not installed. Please uses `npm install -g ' .. s:cmd .. ' to install.')
endif
