let s:jdtls_launcher_path = expand('/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')
let s:jdtls_config_path = expand('~/.local/share/java/jdtls/config_linux')
"let s:jdtls_data_path = expand('~/.cache/java/jdtls')
let s:get_root_path_by = {server_info->lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'pom.xml')}

if executable('java') && filereadable(s:jdtls_launcher_path)
    augroup LspJava
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'ls-java',
        \   'cmd': {server_info->[
        \       'java',
        \       '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        \       '-Dosgi.bundles.defaultStartLevel=4',
        \       '-Declipse.product=org.eclipse.jdt.ls.core.product',
        \       '-Dlog.level=ALL',
        \       '-Dfile.encoding=UTF-8',
        \       '-noverify',
        \       '-Xmx1G',
        \       '-jar',
        \       s:jdtls_launcher_path,
        \       '-configuration',
        \       s:jdtls_config_path,
        \       '-data',
        \       s:get_root_path_by(server_info),
        \       '--add-modules=ALL-SYSTEM',
        \       '--add-opens',
        \       'java.base/java.util=ALL-UNNAMED',
        \       '--add-opens',
        \       'java.base/java.lang=ALL-UNNAMED',
        \   ]},
        \   'allowlist': ['java'],
        \   'blocklist': [],
        \   'root_uri': {
        \       server_info->lsp#utils#path_to_uri(s:get_root_path_by(server_info))
        \   },
        \   'semantic_highlight': {
        \       'entity.name.type.class.java': 'Identifier',
        \       'entity.name.function.java': {
        \           'meta.function-call.java': 'Label',
        \           'meta.method.identifier.java': 'Identifier',
        \       },
        \   },
        \ })

        autocmd FileType java setlocal omnifunc=lsp#complete
    augroup end
else
    function! s:echo(msg)
        echohl WarningMsg
        echom a:msg
        echohl NONE
    endfunction
    autocmd FileType java call s:echo('Sorry, `java` or `eclipse.jdt.ls` is not installed, Please See https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Java to install.')
endif
