" 设定编码部分
if (has("win32") || has("win64"))
    let g:isWindows = 1
    let $LANG = "zh_CN.utf-8"
    set helplang=cn
    if has("gui_running")
        let g:isGUI = 1
        set encoding=utf-8
        "let &termencoding = &encoding
        set guifont=Consolas:h12:cANSI
        set guifontwide=Microsoft\ YaHei:h12,YouYuan:h12:cGB2312
        set winaltkeys=no " 禁用菜单项 Alt 键
    else
        let g:isGUI = 0
        set encoding=cp936
        "let &termencoding = &encoding
        let $LANGUAGE = "zh_CN.cp936"
        ":language messages zh_CN.cp936
        "set t_Co=256 " 设置终端支持的颜色数目
    endif
    if v:lang =~? '^\(zh\|ja\|ko\)'
        set ambiwidth=double
    endif
    "set fileformat=dos
else
    let g:isWindows = 0
    set encoding=utf-8

    if has("gui_running")
        let g:isGUI = 1
        set guifont=Fira\ Mono\ 10
        set guifontwide=Noto\ Sans\ Mono\ CJK\ SC\ 10
    else
        let g:isGUI = 0
        " 针对 Fcitx 在终端下出现延时
        set ttimeoutlen=100
    endif
endif


let $VIM = expand("<sfile>:p:h")
" +===============================+ pathogen +===============================+
set runtimepath=~/vimfiles,$VIM/vimfiles,$VIMRUNTIME,~/vimfiles/after,$VIM/vimfiles/after

syntax off
filetype off

"source $VIM/vimfiles/bundle/00-vim-pathogen/autoload/pathogen.vim
runtime bundle/00-vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
"execute Helptags

" 重绘出现乱码的菜单
"if (g:isWindows && has("gui_running"))
"    source $VIMRUNTIME/delmenu.vim
"    source $VIMRUNTIME/menu.vim
"endif

" 语法高亮
syntax on
filetype plugin indent on
" +===============================+ pathogen +===============================+


if has("linux")
    " Before to do
    " mkdir -p ${XDG_CACHE_HOME}/{vim,nvim}/{view,undo,swap,backup}
    if !exists("$XDG_CACHE_HOME")
        let $XDG_CACHE_HOME = expand("$HOME/.cache")
    endif
    let __DIR_NAME__ = $XDG_CACHE_HOME .. (has("nvim") ? "/nvim" : "/vim")
    let &viewdir = __DIR_NAME__ .. "/view"
    let &undodir = __DIR_NAME__ .. "/undo"
    let &directory = __DIR_NAME__ .. "/swap"
    let &backupdir = __DIR_NAME__ .. "/backup"
    exec "set viminfo+='1000,n" .. __DIR_NAME__ .. "/viminfo"
    unlet __DIR_NAME__
else
    set viewdir=$VIM/logs/view
    set undodir=$VIM/logs/undo
    set directory=$VIM/logs/swap
    set backupdir=$VIM/logs/backup
    set viminfo+='1000,n$VIM/logs/viminfo
endif

set viewoptions-=options
set sessionoptions+=unix,slash


set background=dark
" Xterm 256 Color
if &term == 'xfce4-terminal' || &term == 'xterm' || &term =~? '256color'
    set t_Co=256
endif
if has("gui_running") || has("termguicolors")
    if has("termguicolors")
        if &term =~# '^screen'
            let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
            let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
        endif
        set termguicolors
    endif
    colors fengli
    "for MatchTag plugin
    "highlight TagMatchParen gui=bold guifg=#eeee58 guibg=NONE
else
    colors wombat256
    "highlight TagMatchParen cterm=bold ctermfg=228 ctermbg=101
endif


" Set Mapleader
let mapleader = ";"


" 保存及载入视图
if has("autocmd")
    autocmd BufWinLeave * silent! mkview
    autocmd BufWinEnter * silent! loadview
endif


set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gbk,gb18030,big5,enc-jp,euc-kr,latin1
set fileformat=unix
"set fileformats=unix,dos,mac


" 打开断行模块对亚洲语言（CJK）支持
set fo+=mB

" 正确地处理中文字符的折行与拼接
set formatoptions+=mB

" vim 7.4.785+
set nofixendofline


if has("gui_running")
    set guioptions=aMt
endif


function! AutoMenu()
    if &guioptions =~#'m'
        set guioptions-=m
        set winaltkeys=no
    else
        set guioptions+=m
        set winaltkeys=menu
    endif
endfunction
nmap <a-m> :call AutoMenu()<CR>


function! AutoHideS()
    if &guioptions =~#'rL'
        set guioptions-=rLb
    else
        set guioptions+=rLb
    endif
endfunction
nmap <a-F11> :call AutoHideS()<CR>


" 总显示标签栏
set showtabline=2
set tabline=%!MyTabLine()
function MyTabLine()
    if tabpagenr() == 1
        let s = '%#TabLineFill#%0T '
    else
        let s = ''
    endif
    "if tabpagenr('$') > 1
    "    let s = '%#TabLine#%0T%999XX'
    "else
    "    let s = '%#TabLineFill#%0T '
    "endif
    for i in range(tabpagenr('$'))
        " 选择高亮
        if i + 1 == tabpagenr()
          let s .= '%#TabLineSel#'
        else
          let s .= '%#TabLine#'
        endif

        " 设置标签页号 (用于鼠标点击)
        let s .= '%' . (i + 1) . 'T'

        " MyTabLabel() 提供标签
        let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor

    " 最后一个标签页之后用 TabLineFill 填充并复位标签页号
    let s .= '%#TabLineFill#%T'

    " 右对齐用于关闭当前标签页的标签
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999XX'
    "else
    "    let s .= '%=%#TabLineFill#%T>'
    endif

    return s
endfunction
function MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let index = buflist[winnr - 1]
    let name = bufname(index)
    let name = substitute(name, "[^\\/]*\\(\\\\\\|/\\)", "", "g")
    return name != "" ? index . '-[' . name . ']' : '[' . index . ']'
    "return bufname(buflist[winnr - 1])
endfunction


" 设置状态行显示信息
set statusline=
    \%<%f%h%m%r%(\ %k%)
    \%=%(%l,%c%V\ \|%)
    \%(\ %02.10b,0x%02.8B\ \|%)
    \%(\ %{&expandtab?'SPACE':'TAB'}*%{&expandtab?shiftwidth():&tabstop}\ \|%)
    \%(\ 
        \%{&bin
            \?'binary'
            \:((empty(&fenc)?&enc:&fenc).(&bomb?',BOM':'').'\ \|\ '.&ff)
        \}
    \\ \|%)
    \%(\ %{&eol?'EOL':'NOEOL'}\ %)
    \%(\|\ %{&filetype}\ \|\ %)
    \%([%P]%)
set laststatus=2


" setting vim 7.3
if v:version >= 703
    nmap <expr> <leader>rn &relativenumber?":set number<CR>":":set relativenumber<CR>"
    "set undodir=$VIM/vimfiles/log/undo
    "set undofile
    set colorcolumn=80
    autocmd VimEnter,Colorscheme * highlight ColorColumn ctermbg=8 guibg=#107070
endif


" 在未保存或只读时，弹出确认对话框
set confirm

" 允许在有未保存的修改时切换缓冲区
set hidden


if has("gui_running")
    " 设置窗口大小及位置
    set lines=31
    set columns=84

    " 设置最小的期望窗口高度
    "set winheight=14
    function AutoSetColumns()
        if (!&number)
            set columns=80
        else
            let fileNum = line("$")
            if (fileNum < 1000)
                set columns=84
            elseif (fileNum < 10000)
                set columns=85
            else
                set columns=86
            endif
        endif
        redraw!
        redrawstatus!
    endfunction
    nmap <F5> :call AutoSetColumns()<CR>
endif

if has("gui_running")
    winpos 600 250
endif


" 长行不能完全显示时显示当前屏幕能显示的部分。
" 默认值为空，长行不能完全显示时显示 @。
set display=lastline

" 在屏幕最后一行显示（部分）命令
set showcmd


" 搜索逐字符高亮
set hlsearch
set incsearch


" 粘贴时保留原来的格式
"set paste
"if has("autocmd")
    "autocmd GUIEnter * set paste
    "autocmd InsertEnter * set paste
    "autocmd InsertLeave * set paste&
    "autocmd VimEnter * let g:paste = &paste
    "function SetPaste()
    "    let &paste = !g:paste
    "    let g:paste = &paste
    "endfunction
"endif


" 取消自动换行
set nowrap


" tab 设置
" 默认使用 tab，tab 宽度为 3 个空格（^_^）
" 如果打开的文件检测到使用空格而不是 tab, 将会设置 expandtab，tabstop 为 4
"set expandtab
set tabstop=3
set softtabstop=-1 " 使用 shiftwidth 的值

set smarttab
set shiftwidth=0 " 使用 tabstop 的值


" Backspace 设定
set backspace=indent,eol,start


set number
set signcolumn=number
set cursorline


" 禁止生成临时文件
set nobackup
set noswapfile


" 自动切换到当前缓冲区文件的工作目录
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file#Automatically_change_the_current_directory
" NOTE:
"  1. 该功能会引起保存及加载 session 不正常工作
"  2. 会导致无法切换到 newrw 的窗口（以下代码在 netrw 的窗口中禁止 autochdir）（该问题已在 netrw v156f 中修复）
if exists("+autochdir")
    set autochdir
endif


" 显示补全列表
set wildmenu
" 补全行为设置
set wildmode=longest,full


" 在我的 NB，由于 F1 与 Esc 靠得太近，容易选择误操作，因此把 F1 映射为 Esc
"map <F1> <Esc>
"map! <F1> <Esc>


" 十六进制编辑模式
" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction
nnoremap <A-C-H> :Hexmode<CR>
inoremap <A-C-H> <Esc>:Hexmode<CR>
vnoremap <A-C-H> :<C-U>Hexmode<CR>
function RestoreHexmode()
  if exists("b:editHex") && b:editHex
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
  endif
endfunction
if has("autocmd")
    autocmd BufWinLeave * call RestoreHexmode()
endif


" 复制高亮行到新建文件
nnoremap <silent><leader>gp :let @p=@_<CR>:g/<C-R>//y P<CR>:new<CR>pdk yG


" DESCRIPTION:
" A function and set of commands to save or cut a visual block selection
" to an external file, with support for appending and overwrite protection.
function! s:HandleBlockToFile(action, bang, filename)
  let l:write_mode = 'w'
  let l:real_filename = a:filename
  let l:action_string_present = 'saved to'
  let l:action_string_past = 'Saved'

  " Handle 'cut' action
  if a:action == 'cut'
    let l:action_string_present = 'cut to'
  endif

  " Handle '>>' append mode
  if l:real_filename =~# '^>>\s*'
    let l:write_mode = 'a'
    let l:real_filename = substitute(l:real_filename, '^>>\s*', '', '')
    let l:action_string_present = 'appended to'

    if l:real_filename == ''
      echohl ErrorMsg | echo "Error: Filename missing after '>>'" | echohl None
      return 0 " Return failure
    endif
  endif

  " Check for overwrite, but only if NOT in append mode
  if l:write_mode == 'w' && filereadable(l:real_filename) && a:bang != '!'
    let l:choice = confirm("'" . l:real_filename . "' already exists. Overwrite?", "&Yes\n&No", 2)
    if l:choice != 1
      echohl WarningMsg | echo "Action cancelled." | echohl None
      return 0 " Return failure
    endif
  endif

  try
    " Preserve the user's current yank register
    let l:reg_contents = getreg('"')
    let l:reg_type = getregtype('"')

    " Yank the visually selected text
    normal! gvy

    " Write the contents of the yank register to the specified file
    call writefile(split(getreg('"'), '\n'), l:real_filename, l:write_mode)

    " Restore the user's yank register
    call setreg('"', l:reg_contents, l:reg_type)

    " Provide feedback to the user
    echo "Visual block " . l:action_string_present . " " . l:real_filename
    return 1 " Return success
  catch
    " Handle potential errors
    echohl ErrorMsg
    echo "Error: Could not perform action on " . l:real_filename
    echohl None
    return 0 " Return failure
  endtry
endfunction

" To SAVE a block (Copy selection to file)
command! -bang -range -nargs=1 -complete=file SaveVisualBlock
      \ :call s:HandleBlockToFile('save', <q-bang>, <q-args>)

" To CUT a block (Move selection to file)
command! -bang -range -nargs=1 -complete=file CutVisualBlock
      \ :if s:HandleBlockToFile('cut', <q-bang>, <q-args>) | execute "normal! gvd" | endif



" set Indent Guides
if has("autocmd")
    let g:indent_guides_auto_colors = 1
    autocmd VimEnter,Colorscheme * highlight IndentGuidesOdd guibg=#315252 ctermbg=3
    autocmd VimEnter,Colorscheme * highlight IndentGuidesEven guibg=#345757 ctermbg=4
endif
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1


" 在当前光标下插入日期（格式：1997-01-01 00:00:00，插入模式）
" <C-r>=strftime("%Y-%m-%d %T")
" <C-r>=strftime("%Y-%m-%dT%T+08:00")
" ISO8601/W3C Format
" <C-r>=strftime("%FT%T%z")


" load closetag.vim
if has("autocmd")
    autocmd FileType html,javascript,typescript.tsx,javascriptreact,typescriptreact let b:unaryTagsStack = "area base br col command embed hr img input keygen link meta param source track wbr"
    autocmd FileType html,javascript,typescript.tsx,javascriptreact,typescriptreact,xml,xsl so $VIM/vimfiles/scripts/closetag.vim
endif


" +===============================+ FileType +===============================+
if has("autocmd")
    autocmd BufWritePost,BufNewFile,BufRead *.rdf set filetype=xml
    autocmd BufWritePost,BufNewFile,BufRead *.jsm set filetype=javascript
    autocmd BufWritePost,BufNewFile,BufRead *.hbs set filetype=html
endif
" ============================================================================


" auto save when focus is lost
if has("autocmd")
    autocmd BufLeave,FocusLost * silent! call AutoSave()
    function AutoSave()
        if expand("%") == "" || !&mod || &readonly
            return
        endif
        update
    endfunction
endif


" indent/html.vim （Vim 7.3.1180 更新后的设置）
" 来源：http://www.vim.org/scripts/script.php?script_id=2075
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head,tbody"
"let g:html_indent_autotags = "th,td,tr,tfoot,thead"


" 绑定 vim（xfce）的 <S-Insert> 用于粘贴
if (!g:isWindows)
    nmap <S-Insert> <Esc>"+gP
    vmap <S-Insert> "-d"+gP
    imap <S-Insert> <C-R><C-O>+
    cmap <S-Insert> <C-R><C-O>+
endif


" Emmet
"let g:user_emmet_leader_key = '<C-y>'


" 设置新建窗口时置右（及置下）
set splitright
set splitbelow


"
set iskeyword+=-


"
set completeopt-=preview


" tern_for_vim plugin
let g:tern_show_signature_in_pum = 1


" highlight trailing whitespace
" from: http://vim.wikia.com/wiki/Highlight_unwanted_spaces#INCONTENT_PLAYER
if has("autocmd")
    highlight ExtraWhitespace ctermbg=9 guibg=#ff5f5f
    let g:EXTRA_WHITESPACE_PATTERN_NORMAL = '\s\+$'
    let g:EXTRA_WHITESPACE_PATTERN_INSERT = '\s\+\%#\@<!$'
    augroup WhitespaceMatch
        " Remove ALL autocommands for the WhitespaceMatch group.
        autocmd!
        autocmd BufWinEnter * silent! call s:WhitespaceMatch()
        autocmd InsertEnter * silent! call s:ToggleWhitespaceMatch('i')
        autocmd InsertLeave * silent! call s:ToggleWhitespaceMatch('n')
    augroup END
    function! s:WhitespaceMatch()
        if (!exists('w:whitespace_match_number'))
            let w:whitespace_match_number = matchadd('ExtraWhitespace', g:EXTRA_WHITESPACE_PATTERN_NORMAL)
        endif
    endfunction
    function! s:ToggleWhitespaceMatch(mode)
        let pattern = (a:mode == 'i') ? g:EXTRA_WHITESPACE_PATTERN_INSERT : g:EXTRA_WHITESPACE_PATTERN_NORMAL
        if exists('w:whitespace_match_number')
            call matchdelete(w:whitespace_match_number)
            call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
        else
            " Something went wrong, try to be graceful.
            let w:whitespace_match_number = matchadd('ExtraWhitespace', pattern)
        endif
    endfunction
endif



" set suffixesadd
"if has("autocmd")
"    autocmd FileType javascript setlocal suffixesadd+=.js,.jsx
"endif


" vim-markdown plugin
" Disable folding
let g:vim_markdown_folding_disabled = 1
" Disable Default Key Mappings
let g:vim_markdown_no_default_key_mappings = 1


" bexec plugin
let g:bexec_splitdir = "ver"
let g:bexec_outputscroll = 0
let g:bexec_filter_types = {
    \ "javascript": "node",
    \ "rust": "cargo run",
    \ "sh": "bash",
    \ }
nmap <silent> <unique> <F1> <leader>bx
vmap <silent> <unique> <F1> <leader>bx


" set netrw
let g:netrw_home      = expand(has("linux") ? "$XDG_CACHE_HOME/vim" : "$VIM/vimfiles/logs")
let g:netrw_keepdir   = 0
"let g:netrw_retmap    = 1
let g:netrw_silent    = 1

let g:netrw_browse_split = 0
let g:netrw_preview   = 1
let g:netrw_alto      = 0
let g:netrw_altv      = &spr
"let g:netrw_liststyle = 3
let g:netrw_winsize   = 30


" 移动当前行
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv


inoremap <expr> j pumvisible() ? '<C-N>' : 'j'
inoremap <expr> <C-j> pumvisible() ? '<C-N>' : '<C-j>'
inoremap <expr> k pumvisible() ? '<C-P>' : 'k'
inoremap <expr> <C-k> pumvisible() ? '<C-P>' : '<C-k>'

"inoremap <expr> <Esc> pumvisible() ? '<C-E>' : '<Esc>'
inoremap <expr> <CR> pumvisible() ? '<C-Y>' : '<CR>'

" set popup menu size
set pumwidth=15
set pumheight=20


" 移到前面的 { 后面，用在 js/ts 里 import 或 destructuring assignment
"inoremap <C-b>{ <C-o>T{<Space>
"inoremap <C-b>[ <C-o>T[<Space>
"inoremap <C-b>( <C-o>T(<Space>
inoremap <C-b> <C-r>=search('[{[(]', 'bes', line('.')) > 0 ? "\<lt>Right> " : ''<CR>

augroup lsp_install
    au!

    let g:lsp_async_completion = v:true
    let g:lsp_use_native_client = 1
    let g:lsp_signs_enabled = 1
    let g:lsp_diagnostics_echo_cursor = 1
    let g:lsp_diagnostics_echo_delay = 200
    let g:lsp_diagnostics_float_cursor = 1
    let g:lsp_diagnostics_float_delay = 500
    let g:lsp_diagnostics_float_insert_mode_enabled = 0
    "let g:lsp_preview_doubletap = 0
    let g:lsp_fold_enabled = 0
    let g:lsp_preview_autoclose = 0
    let g:lsp_highlight_references_enabled = 1
    let g:lsp_document_code_action_signs_enabled = 0
    let g:lsp_diagnostics_virtual_text_enabled = 0
    "let g:lsp_preview_autoclose = 0
    "let g:lsp_semantic_enabled = 1

    " Close preview window with <esc>
    autocmd User lsp_float_opened nmap <buffer> <silent> <esc> <Plug>(lsp-preview-close)
    autocmd User lsp_float_closed silent! nunmap <buffer> <esc>

    function! s:on_lsp_buffer_enabled() abort
        setlocal omnifunc=lsp#complete
        autocmd BufWritePre *.go LspDocumentFormatSync
        nmap <buffer><silent> K      :LspHover<CR>
        nmap <buffer><silent> <C-]>  <plug>(lsp-definition)
        nmap <buffer><silent> <C-}>  <plug>(lsp-declaration)
        nmap <buffer><silent> <F3>   <plug>(lsp-next-reference)
        nmap <buffer><silent> <S-F3> <plug>(lsp-previous-reference)
        nmap <buffer><silent> <F2>   <plug>(lsp-rename)
    endfunction

    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


let g:typescript_indent_disable = 1


set nostartofline


function! s:has_close_parenthesis(ch)
    return getline('.')[col('.') - 1] == a:ch
endfunction
inoremap <expr> ) <SID>has_close_parenthesis(')') ? '<Right>' : ')'
inoremap <expr> ] <SID>has_close_parenthesis(']') ? '<Right>' : ']'
inoremap <expr> } <SID>has_close_parenthesis('}') ? '<Right>' : '}'
inoremap <expr> > <SID>has_close_parenthesis('>') ? '<Right>' : '>'
inoremap <expr> ' <SID>has_close_parenthesis("'") ? '<Right>' : "'"
inoremap <expr> " <SID>has_close_parenthesis('"') ? '<Right>' : '"'
inoremap <expr> ` <SID>has_close_parenthesis('`') ? '<Right>' : '`'
inoremap <expr> ; <SID>has_close_parenthesis(';') ? '<Right>' : ';'
inoremap <expr> , <SID>has_close_parenthesis(',') ? '<Right>' : ','

" Fix the key remap by after loaded script
function! s:patch_map()
    " vim-vsnip + vim-vsnip-integ plugins
    "" Expand
    "imap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
    "smap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
    "
    "" Expand or jump
    imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
    smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

    " Jump forward or backward

    if has("gui_running")
        exec 'imap <expr> <C-Tab> vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "' .. (maparg('<C-Tab>', 'i') ?? '<Tab>') .. '"'
        exec 'smap <expr> <C-Tab> vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "' .. (maparg('<C-Tab>', 's') ?? '<Tab>') .. '"'
        exec 'imap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "' .. (maparg('<S-Tab>', 'i') ?? '<S-Tab>') .. '"'
        exec 'smap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "' .. (maparg('<S-Tab>', 's') ?? '<S-Tab>') .. '"'
    else
        exec 'imap <expr> <Tab> vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "' .. (maparg('<Tab>', 'i') ?? '<Tab>') .. '"'
        exec 'smap <expr> <Tab> vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "' .. (maparg('<Tab>', 's') ?? '<Tab>') .. '"'
        exec 'imap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "' .. (maparg('<S-Tab>', 'i') ?? '<S-Tab>') .. '"'
        exec 'smap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "' .. (maparg('<S-Tab>', 's') ?? '<S-Tab>') .. '"'
    endif
endfunction
autocmd VimEnter * call s:patch_map()


" If you want to use snippet for multiple filetypes, you can `g:vsip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

" Patch to abolish
function! s:patch_abolish()
    if exists("g:Abolish")
        function! s:hyphenatedpascalcase(word)
            return substitute(g:Abolish.titlecase(a:word), ' ', '-', 'g')
        endfunction

        call extend(g:Abolish, {
            \ 'hyphenatedpascalcase': function('s:hyphenatedpascalcase')
        \ }, 'keep')
        call extend(g:Abolish.Coercions, {
            \ 'h': g:Abolish.hyphenatedpascalcase
        \ }, 'keep')
    endif
endfunction
autocmd VimEnter * call s:patch_abolish()


" vimwiki
let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{
    \ 'path': '~/Documents/vimwiki/',
    \ 'syntax': 'markdown',
    \ 'ext': '.md',
\}]
