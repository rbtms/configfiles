runtime! debian.vim

"" Vim with all enchancements
source $VIMRUNTIME/vimrc_example.vim

" ------------------------- Behaviour ------------------------------- "

"" Restore cursor to file position in previous edition session
set viminfo='10,\"100,:20,%,n$VIM/_viminfo

"" Compatibility
set nocompatible
set viminfo='20,\"50 "
set ts=4
set sw=4
set expandtab
set wrap
set belloff=all
set bs=2
set ai
set encoding=utf-8

"" Filetype plugins
filetype indent on

"" Ignore search case
set ignorecase

"" Move all temporal files to a different directory
set backup
set noundofile
set backupdir=/tmp
set backupskip=/tmp
set directory=/tmp
set writebackup

" Disable start text
set shortmess+=I

" Open windows on right side
:set splitright
:command Term vert term

"" Show line numbers
set number

"" Highlight current line number
set cursorline

"" Open help on vertical split
cnoreabbrev h vert h

"" Allow to move splits with the mouse
set ttymouse=sgr

"" Folding
set foldmethod=indent
set nofoldenable
set foldnestmax=1
set foldlevel=0
nnoremap <space> za
vnoremap <space> zf

"" Autoclose quotes
"inoremap " ""<left>
"inoremap ' ''<left>
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O

"" Change cursor on insert and normal modes (bug: the cursor remains after exit)
let &t_SI = "\e[5 q"
let &t_EI = "\e[1 q"

augroup foo
au!
autocmd VimEnter * silent !echo -ne "\e[1 q"
augroup END

"" Map Q to q and W to w to prevent typos
:command W w
:command Q q

"" JSON formatting
command JSONFormat %! jq . 

"" vim -b : edit binary
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

"" Remap home and end key behaviours
map  <ESC>[8~ <End>
map  <ESC>[7~ <Home>
imap <ESC>[8~ <End>  
imap <ESC>[7~ <Home>

"" Home key behaviour
noremap  <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "^"
inoremap <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "\<C-O>^"

"" Jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"" Execute the default run command for a file extension
function s:exec_run_cmd_term(filename)
    if a:filename[-3:-1] == '.py'
        call feedkeys("python " . a:filename . "\<CR>")
        "echo "python " . a:filename . "\<CR>"
    elseif a:filename[-3:-1] == '.sh'
        call feedkeys("sh " . a:filename . "\<CR>")
    endif
endfunction

"" Execute last command on right shell AFTER SAVING IT
function! Run_in_terminal(mode)
    let filename = bufname()
    let buf_n = bufnr()

    "" Save the file
    execute ':w'

    "" If there isnt a terminal start one and execute the initial command
    if !bufexists('!/bin/bash')
        execute 'Term'
        sleep 20m " Sleep 20 miliseconds so that the command doesnt appear before the first prompt
        call s:exec_run_cmd_term(filename)
    "" If there is a terminal run the last command
    else
        let terms = win_findbuf(bufnr('!/bin/bash')) " List terminal buffers
        call win_gotoid(terms[0]) " Move to the first buffer with a terminal
        call feedkeys("!!\<CR>") " Execute last command
    endif
   
    "" Return to the original buffer. It doesnt allow to run it after the
    "" function.
    "" <C-W><C-P>: Go back to the previous window
    if a:mode == 'normal'
        call feedkeys("\<C-W>\<C-P>")
    elseif a:mode == 'insert' " Insert
        call feedkeys("\<C-W>\<C-P>a")
    else
        echo 'Mode not valid'
    endif
endfunction

"" Run program on a terminal
"nmap <F2> <ESC>:w<ENTER><C-W>l!!<ENTER><C-W>h
"imap <F2> <ESC>:w<ENTER><C-W>l!!<ENTER><C-W>ha
nmap <F2> :call Run_in_terminal('normal')<ENTER>
imap <F2> <ESC>:call Run_in_terminal('insert')<ENTER>

"" Scroll terminal with PageUp
tmap <PageUp> <C-W>N<PageUp>

"" Map CTRL+PrevPag and CTRL+NextPag to cycle buffers and not tabs
"" bp: Previous buffer, bn: Next buffer, bd: Delete buffer
map <S-a> :bp<CR>
map <S-s> :bn<CR>
map <S-d> :bd<CR>


" -------------------------- Plugins -------------------------------- "

""""""
"
" Plugin list:
"   - NERDTree (File tree)
"   - Undotree (Undo changes tree)
"   - Tagbar (Symbol tagbar)
"   - ALE (Autocomplete)
"   - tcomment_vim (Comment with gc)
"   - surround (Change the surrounding parentheses (or whatever) for exmaple with with cs"' (Changes " to '))
"   - buftabline (Tab line with buffers instead of tabs)
"
""""""

"" NERDTree
let NERDTreeIgnore=['.swp', '.ini', '.DAT']
let NERDTreeShowHidden=1
:smap <C-c> <C-g>y

"" Undotree
nnoremap <F5> :UndotreeToggle<CR>

"" Tagbar
nmap <F8> :TagbarToggle<CR>
"" Sort by code position
let g:tagbar_sort = 0

"" Autocomplete
"" Dont show doc window
"set completeopt=menu

"" ALE
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1
let g:ale_linters = {'python': ['pylint', 'pylsp'], 'rust': ['rustc', 'analyzer']}
let g:ale_fixers = { 'python': ['trim_whitespace'] } 
let g:ale_fix_on_save = 1

let g:ale_python_pylint_executable = 'pylint'
let g:ale_python_pylint_options = '--rcfile ~/.pylint'

""" pylsp
let g:ale_python_pylsp_executable = 'pyls'

" Disable pylsp linting (leave only autocompletion)
let g:ale_python_pylsp_config = { 'pyls': { 'plugins': { 'pycodestyle': { 'enabled': v:false } } } }

" Show popups instead of buffers for autocomplete function information
set completeopt=menu,menuone,popup,noselect,noinsert

" Show indicators like when you modify a file on buftabline
let g:buftabline_indicators = 1

"nnoremap <S-PageUp> :bn<CR>
"nnoremap <S-PageDown> :bp<CR>


" --------------------------- Style --------------------------------- "

"" Syntax
syntax on

set termguicolors
set background=dark
colorscheme onedark

set termguicolors
" Change background color to that of the terminal
hi Normal guibg=#121314
" Change terminal's background too
hi Terminal guibg=#121314
" Change vertical separator character
set fillchars+=vert:│

"" Highlight current line
"autocmd ColorScheme *
"    \ hi CursorLine ctermbg=234

" Change the background color of the current line
hi CursorLine guibg=#202122

augroup CursorLine
    au!
au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

"" Autocomplete window
autocmd ColorScheme *
    \ hi Pmenu ctermbg=240 guibg=black

"" Add self highlighting
augroup python
    autocmd!
    autocmd FileType python
                \   syn keyword pythonSelf self
                \ | highlight def link pythonSelf Special
augroup end
