function! s:lsp_ui_workspace_execute_command(server_name, command_name, command_args, callback, ...) abort
    let l:params = { 'command': a:command_name }
    if a:command_args isnot v:null
        let l:params['arguments'] = a:command_args
    endif

    let l:ctx = {
    \    'server_name': a:server_name,
    \    'command_name': a:command_name,
    \    'command_args': a:command_args,
    \    }
    if a:0
        call extend(l:ctx, a:1)
    endif

    call lsp#send_request(a:server_name, {
    \    'method': 'workspace/executeCommand',
    \    'params': l:params,
    \    'on_notification': function(a:callback, [l:ctx]),
    \    })
endfunction

function! s:has_commands_func(server_name, command_name) abort
    let l:provider = 'executeCommandProvider'
    let l:value = lsp#get_server_capabilities(a:server_name)
    if !has_key(l:value, l:provider)
        return v:false
    endif
    let l:value = l:value[l:provider]
    if !has_key(l:value, 'commands')
        return v:false
    endif
    let l:commands = l:value['commands']
    return type(l:commands) == type([]) && index(l:commands, a:command_name) >= 0
endfunction

function! s:not_supported(what) abort
    call lsp#log(a:what . ' not supported for ' . &filetype)
endfunction

function! s:lsp_go_to_source_definition() abort
    let l:method = 'executeCommand'
    let l:operation = substitute(l:method, '\u', ' \l\0', 'g')

    let l:command_name = '_typescript.goToSourceDefinition'

    "let l:capabilities_func = printf('lsp#capabilities#has_%s_provider(v:val)', substitute(l:operation, ' ', '_', 'g'))
    "let l:servers = filter(lsp#get_allowed_servers(), l:capabilities_func)
    let l:servers = filter(lsp#get_allowed_servers(), 's:has_commands_func(v:val, l:command_name)')
    let l:command_id = lsp#_new_command()

    let l:operation_name = printf('%s (%s)', l:operation, l:command_name)

    let l:ctx = { 'counter': len(l:servers), 'list':[], 'last_command_id': l:command_id, 'jump_if_one': 1, 'mods': '', 'in_preview': 0 }
    if len(l:servers) == 0
        call s:not_supported('Retrieving ' . l:operation_name)
        return
    endif

    let l:command_args = [
    \        lsp#get_text_document_identifier()['uri'],
    \        lsp#get_position(),
    \    ]

    for l:server in l:servers
        call s:lsp_ui_workspace_execute_command(l:server, l:command_name, l:command_args, function('s:handle_callback'), l:ctx)
    endfor

    echo printf('Retrieving %s ...', l:operation_name)
endfunction

function! s:handle_callback(ctx, data) abort
    if a:ctx['last_command_id'] != lsp#_last_command()
        return
    endif

    let l:server = a:ctx['server_name']
    let l:type = 'workspace/executeCommand(' . a:ctx['command_name'] . ')'

    let a:ctx['counter'] = a:ctx['counter'] - 1

    if lsp#client#is_error(a:data['response']) || !has_key(a:data['response'], 'result')
        call lsp#utils#error('Failed to retrieve '. l:type . ' for ' . l:server . ': ' . lsp#client#error_message(a:data['response']))
    else
        let a:ctx['list'] = a:ctx['list'] + lsp#utils#location#_lsp_to_vim_list(a:data['response']['result'])
    endif

    if a:ctx['counter'] == 0
        if empty(a:ctx['list'])
            call lsp#utils#error('No ' . l:type . ' found')
        else
            call lsp#utils#tagstack#_update()

            let l:loc = a:ctx['list'][0]

            if len(a:ctx['list']) == 1 && a:ctx['jump_if_one'] && !a:ctx['in_preview']
                call lsp#utils#location#_open_vim_list_item(l:loc, a:ctx['mods'])
                echo 'Retrieved ' . l:type
                redraw
            elseif !a:ctx['in_preview']
                call setqflist([])
                call setqflist(a:ctx['list'])
                echo 'Retrieved ' . l:type
                botright copen
            else
                let l:lines = readfile(l:loc['filename'])
                if has_key(l:loc,'viewstart') " showing a locationLink
                    let l:view = l:lines[l:loc['viewstart'] : l:loc['viewend']]
                    call lsp#ui#vim#output#preview(l:server, l:view, {
                        \   'statusline': ' LSP Peek ' . l:type,
                        \   'filetype': &filetype
                        \ })
                else " showing a location
                    call lsp#ui#vim#output#preview(l:server, l:lines, {
                        \   'statusline': ' LSP Peek ' . l:type,
                        \   'cursor': { 'line': l:loc['lnum'], 'col': l:loc['col'], 'align': g:lsp_peek_alignment },
                        \   'filetype': &filetype
                        \ })
                endif
            endif
        endif
    endif
endfunction

let s:cmd = 'typescript-language-server'
if executable(s:cmd)
    augroup LspTypescript
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-typescript',
        \   'cmd': {server_info -> [&shell, &shellcmdflag, s:cmd .. ' --stdio']},
        \   'allowlist': ['typescript', 'typescript.tsx', 'typescriptreact'],
        \   'blocklist': [],
        \   'workspace_config': {},
        \   'config': {},
        \   'root_uri': {server_info ->
        \       lsp#utils#path_to_uri(
        \           lsp#utils#find_nearest_parent_file_directory(
        \               lsp#utils#get_buffer_path(), 'tsconfig.json'
        \           )
        \       )
        \   },
        \   'initialization_options': {
        \       'diagnostics': 'true',
        \   },
        \   'languageId': {server_info -> 'typescript'},
        \ })

        autocmd FileType typescript,typescript.tsx,typescriptreact setlocal omnifunc=lsp#complete
        autocmd FileType typescript,typescript.tsx,typescriptreact nmap <A-]> :call <SID>lsp_go_to_source_definition()<CR>
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType typescript,typescript.tsx,typescriptreact call s:echo('Sorry, `typescript-language-server` is not installed. Please uses `npm install -g typescript typescript-language-server` to install.')
endif
