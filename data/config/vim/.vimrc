" - Plugins Begin - "
    if isdirectory($HOME . "/.vim/bundle/Vundle.vim")
" - Plugins Begin - "

""""""""""""""""""""""""""""""""""""""""
"      Vundle
""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('$HOME/some/path/here')

"===== Plugins ====="
Plugin 'VundleVim/Vundle.vim' "required
Plugin 'Valloric/YouCompleteMe'
"==================="

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

""""""""""""""""""""""""""""""""""""""""
"      YouCompleteMe
""""""""""""""""""""""""""""""""""""""""
let g:ycm_show_diagnostics_ui = 0
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_max_num_candidates = 10
let g:ycm_max_num_identifier_candidates = 10
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_goto_buffer_command = 'horizontal-split'
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt=menu,menuone

"inoremap <expr> <CR> pumvisible() ? "\<C-y><CR>" : "\<CR>"
nnoremap <Leader>g :YcmCompleter GoTo<CR>
noremap <c-z> <NOP>

let g:ycm_semantic_triggers = {
            \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{1}'],
            \ 'cs,lua,javascript': ['re!\w{1}'],
            \ }

" - Plugins End- "
    endif
" - Plugins End- "

""""""""""""""""""""""""""""""""""""""""
"      HighLight
""""""""""""""""""""""""""""""""""""""""
"highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
"highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black

""""""""""""""""""""""""""""""""""""""""
"      AutoPair
""""""""""""""""""""""""""""""""""""""""
function! AutoPair(open, close)
        let line = getline('.')
        if col('.') > strlen(line) || line[col('.') - 1] == ' '
                return a:open.a:close."\<ESC>i"
        else
                return a:open
        endif
endf

function! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
                return "\<Right>"
        else
                return a:char
        endif
endf

function! SamePair(char)
        let line = getline('.')
        if line[col('.') - 1] == ' '
                return a:char
        elseif col('.') > strlen(line) || line[col('.') - 1] == ' '
                return a:char.a:char."\<ESC>i"
        elseif line[col('.') - 1] == a:char
                return "\<Right>"
        else
                return a:char
        endif
endf

inoremap ( <c-r>=AutoPair('(', ')')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { <c-r>=AutoPair('{', '}')<CR>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ <c-r>=AutoPair('[', ']')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
"inoremap " <c-r>=SamePair('"')<CR>
"inoremap ' <c-r>=SamePair("'")<CR>
"inoremap ` <c-r>=SamePair('`')<CR>

""""""""""""""""""""""""""""""""""""""""
"      MySettings
""""""""""""""""""""""""""""""""""""""""
set number

set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set pastetoggle=<F2>
