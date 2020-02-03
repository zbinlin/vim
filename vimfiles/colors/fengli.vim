" Vim color file
"  Maintainer: Colin Zheng
"       Email: zbinlin@gmail.com
" Last Change: 2016-01-07T17:25:13+0800
"     Version: 1.0.1
"    Required: colors/neon.vim
" This color scheme uses a dark background.

hi clear
if exists("syntax_on")
    syntax reset
endif

" Load the "base" colorscheme: colors/neon.vim
runtime colors/neon.vim

" Override the name of the base colorscheme with the name of this custom one
let colors_name = "fengli"

" Clear the colors for any items that you don't like
hi clear Normal
hi clear NonText
hi clear MoreMsg
hi clear Title
hi clear Error
hi clear Cursor
hi clear lCursor
hi clear CursorIM
hi clear LineNr
hi clear CursorLine

" Set up your new & improved colors
hi Normal        gui=NONE        guifg=#f0f0f0       guibg=#2f4f4f
hi NonText       gui=NONE        guifg=#383838       guibg=#383838

hi MoreMsg       gui=BOLD        guifg=#70ffc0       guibg=#393939
hi Title         gui=BOLD        guifg=#ff80d0       guibg=NONE
hi Error         gui=BOLD        guifg=#ff00ff       guibg=NONE

hi Cursor        gui=NONE        guifg=bg            guibg=#FFA500
hi lCursor       gui=NONE        guifg=bg            guibg=#FFA500
hi CursorIM      gui=NONE        guifg=bg            guibg=#FFA500

hi LineNr        gui=NONE        guifg=#707070       guibg=#2f4848
hi CursorLineNr  gui=NONE        guifg=#999999       guibg=#2f4848

" Popup Menu
hi Pmenu         gui=NONE        guifg=#c0c0c0       guibg=#107070
hi PmenuSbar     gui=NONE        guifg=#000000       guibg=#c06800
hi PmenuThumb    gui=NONE        guifg=#000000       guibg=#107070
hi PmenuSel      gui=NONE        guifg=#ffffff       guibg=#c06800

hi MatchParen    gui=NONE        guifg=#000000       guibg=#96D9EA
hi SignColumn    gui=NONE        guifg=#00FFFF       guibg=#C0C0C0

hi SpellBad      gui=UNDERCURL   guifg=NONE          guibg=NONE
hi SpellCap      gui=UNDERCURL   guifg=NONE          guibg=NONE
hi SpellLocal    gui=UNDERCURL   guifg=NONE          guibg=NONE
hi SpellRare     gui=UNDERCURL   guifg=NONE          guibg=NONE

" Tab
hi TabLine      gui=NONE         guifg=#707070       guibg=#c4c4c4
hi TabLineFill  gui=NONE         guifg=#707070       guibg=#c4c4c4
hi TabLineSel   gui=NONE         guifg=#999944       guibg=NONE
