let s:commands = [
\   'vscode-json-language-server',
\   'vscode-json-languageserver',
\ ]
let s:cmd = ''
for cmd in s:commands
    if executable(cmd)
        let s:cmd = cmd
        break
    endif
endfor

if !empty(s:cmd)
    augroup LspJson
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-json',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. ' --stdio']},
        \   'initialization_options': {
        \       'provideFormatter': v:false,
        \   },
        \   'allowlist': ['json', 'jsonc'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {
        \       'http': {
        \           'proxy': '',
        \       },
        \       'json': {
        \           'format': v:false,
        \           'schemas': [
        \               {
        \                   'fileMatch': ['package.json'],
        \                   'url': 'https://json.schemastore.org/package',
        \               },
        \               {
        \                   'fileMatch': ['tsconfig.json'],
        \                   'url': 'https://json.schemastore.org/tsconfig',
        \               },
        \           ],
        \       },
        \   },
        \ })

        autocmd FileType json,jsonc setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType json,jsonc call s:echo('Sorry, `vscode-langservers-extracted` or `vscode-json-languageserver` is not installed. Please uses `npm install --global <vscode-langservers-extracted OR vscode-json-languageserver>` to install.')
endif
