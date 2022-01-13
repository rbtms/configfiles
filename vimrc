runtime! debian.vim

" Vim with all enchancements
source $VIMRUNTIME/vimrc_example.vim

" Restore cursor to file position in previous edition session
set viminfo='10,\"100,:20,%,n$VIM/_viminfo

" Compatibility
set nocompatible
set viminfo='20,\"50 "
set ts=4
set sw=4
set expandtab
set wrap
set belloff=all
set bs=2
set ai

" Filetype plugins
filetype indent on

" Syntax
syntax on
colorscheme onedark

" Show line numbers
set number

" Ignore search case
set ignorecase

" Move all temporal files to a different directory
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

" NERDTree
let NERDTreeIgnore=['.swp', '.ini', '.DAT']
let NERDTreeShowHidden=1

" Allow to move splits with the mouse
set ttymouse=sgr

" Remap home and end key behaviours
map <ESC>[8~    <End>
map <ESC>[7~    <Home>
imap <ESC>[8~    <End>  
imap <ESC>[7~    <Home>

" Home key behaviour
noremap  <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "^"
inoremap <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "\<C-O>^"

" Uncomment the following to have Vim jump to the last position when
" reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

