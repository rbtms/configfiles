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

"" Execute last command on right shell AFTER SAVING IT
nmap <F2> <ESC>:w<ENTER><C-W>l!!<ENTER><C-W>h
imap <F2> <ESC>:w<ENTER><C-W>l!!<ENTER><C-W>ha



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

" --------------------------- Style --------------------------------- "

"" Syntax
syntax on

set termguicolors
set background=dark
colorscheme onedark

"" Highlight current line
autocmd ColorScheme *
    \ hi CursorLine ctermbg=234

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
