let s:commands = [
\   'vscode-html-language-server',
\   'html-languageserver',
\ ]
let s:cmd = ''
for cmd in s:commands
    if executable(cmd)
        let s:cmd = cmd
        break
    endif
endfor

if !empty(s:cmd)
    augroup LspHtml
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-html',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. ' --stdio']},
        \   'allowlist': ['html'],
        \   'blocklist': [],
        \   'initialization_options': {
        \       'embeddedLanguages': {
        \           'css': v:true,
        \           'javascript': v:true,
        \       },
        \   },
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
    autocmd FileType html call s:echo('Sorry, `vscode-langservers-extracted` or `vscode-html-languageserver-bin` is not installed. Please uses `npm install --global <vscode-langservers-extracted OR vscode-html-languageserver-bin>` to install.')
endif
