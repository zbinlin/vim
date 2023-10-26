let s:commands = [
\   'pylsp',
\   'pyls',
\ ]
let s:cmd = ''
for cmd in s:commands
    if executable(cmd)
        let s:cmd = cmd
        break
    endif
endfor

if executable(s:cmd)
    augroup LspPython
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-py',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd]},
        \   'allowlist': ['python'],
        \   'blocklist': [],
        \ })
    augroup END
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType python call s:echo('Sorry, `python-lsp-server` or `python-language-server` is not installed. Please Uses `pacman -S python-lsp-server` or `pip install --user python-language-server` to install.')
endif
