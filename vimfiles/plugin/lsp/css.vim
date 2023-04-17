let s:commands = [
\   'vscode-css-language-server',
\   'css-languageserver',
\ ]
let s:cmd = ''
for cmd in s:commands
    if executable(cmd)
        let s:cmd = cmd
        break
    endif
endfor

if !empty(s:cmd)
    augroup LspCss
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-css',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. ' --stdio']},
        \   'allowlist': ['css', 'less', 'sass'],
        \   'blocklist': [],
        \   'config': {},
        \   'workspace_config': {
        \       'css': {
        \           'lint': {
        \               'validProperties': [],
        \           },
        \       },
        \       'less': {
        \           'lint': {
        \               'validProperties': [],
        \           },
        \       },
        \       'sass': {
        \           'lint': {
        \               'validProperties': [],
        \           },
        \       },
        \       'scss': {
        \           'lint': {
        \               'validProperties': [],
        \           },
        \       },
        \   },
        \ })

        autocmd FileType css,less,sass setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType css,less,sass call s:echo('Sorry, `vscode-langservers-extracted` or `vscode-css-languageserver-bin` is not installed. Please uses `npm install --global <vscode-langservers-extracted OR vscode-css-languageserver-bin>` to install.')
endif
