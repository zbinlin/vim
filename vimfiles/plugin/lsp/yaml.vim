let s:cmd = 'yaml-language-server'
if executable(s:cmd)
    augroup LspYaml
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-yaml',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. ' --stdio']},
        \   'allowlist': ['yaml', 'yaml.ansible'],
        \   'blocklist': [],
        \   'workspace_config': {
        \       'yaml': {
        \           'validate': v:true,
        \           'hover': v:true,
        \           'completion': v:true,
        \           'customTags': [],
        \           'schemas': {},
        \           'schemaStore': {
        \               'enable': v:true,
        \           },
        \       },
        \   },
        \   'languageId': {server_info -> 'yaml'},
        \ })

        autocmd FileType yaml setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType yaml call s:echo('Sorry, `yaml-language-server` is not installed. Please uses `npm install --global yaml-language-server` to install.')
endif
