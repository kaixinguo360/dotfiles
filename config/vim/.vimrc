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
let g:ycm_show_diagnostics_ui = 1
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_goto_buffer_command = 'horizontal-split'
let g:ycm_key_invoke_completion = '<c-z>'
let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']
set completeopt=menu,menuone

nnoremap <c-g> :YcmCompleter GoTo<CR>
noremap <c-z> <NOP>

let g:ycm_semantic_triggers = {
            \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{1}'],
            \ 'cs,lua,javascript': ['re!\w{1}'],
            \ }

" - Plugins End- "
    endif
" - Plugins End- "

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
"     Cabbrev
""""""""""""""""""""""""""""""""""""""""

fu! Cabbrev(key, value)
  exe printf('cabbrev <expr> %s (getcmdtype() == ":" && getcmdpos() <= %d) ? %s : %s',
    \ a:key, 1+len(a:key), string(a:value), string(a:key))
endfu

call Cabbrev('mmake', '!bash -ic mmake')


""""""""""""""""""""""""""""""""""""""""
"      Persistent Undo
""""""""""""""""""""""""""""""""""""""""

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)

    let &undodir = myUndoDir
    set undofile
    set undolevels=5000
    set undoreload=10000
endif


""""""""""""""""""""""""""""""""""""""""
"      Save Last Position
""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

""""""""""""""""""""""""""""""""""""""""
"      Indent
""""""""""""""""""""""""""""""""""""""""
autocmd FileType php,python,c,java,perl,shell,bash,vim,ruby,cpp set ai
autocmd FileType php,python,c,java,perl,shell,bash,vim,ruby,cpp set sw=4
autocmd FileType php,python,c,java,perl,shell,bash,vim,ruby,cpp set ts=4
autocmd FileType php,python,c,java,perl,shell,bash,vim,ruby,cpp set sts=4
autocmd FileType javascript,html,css,xml,yaml set ai
autocmd FileType javascript,html,css,xml,yaml set sw=2
autocmd FileType javascript,html,css,xml,yaml set ts=2
autocmd FileType javascript,html,css,xml,yaml set sts=2


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

set incsearch
set hlsearch

