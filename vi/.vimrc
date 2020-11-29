" -----------------------------------------------------------------------------
" Load Plugins
" -----------------------------------------------------------------------------
source ~/.vim/.plug.vim

" -----------------------------------------------------------------------------
" Settings
"   Research any of these by running :help <setting>
" -----------------------------------------------------------------------------

" list of available color schemes : /usr/share/vim/vim80/colors
colo desert

syntax on   " syntax highlighting
filetype indent on " Enable indenting for files

let mapleader=" "
let maplocalleader=" "

set autoindent  " New lines inherit the indentation of previous lines
set autoread
set backspace=indent,eol,start  "Allow backspacing over indention, line breaks and insertion start
set backupdir=/tmp//,.
set cindent     " programmers autoindent, and don't remove indent on '#'
set confirm     " Instead of failing a command because of unsaved changes, raise a dialogue asking if you wish to save.
set encoding=utf8
set expandtab
" set exrc    " enable project specific vimrc
set foldcolumn=1    "Enable fold column
set foldenable      "Enable folding
set foldlevelstart=0    "Open most of the folds by default. If set to 0, all folds will be closed.
set foldnestmax=10      "Folds can be nested. Setting a max value protects you from too many folds.
set foldmethod=manual   "Defines the type of folding.
set hidden
set history=200
set hlsearch    " highlight search matches
set ignorecase  " ignore case during search
set incsearch   " match pattern while typing search
set laststatus=2    " always display the status bar
set lazyredraw      " fix slow scrolling on some files (on macro execution)
set linebreak       " Wrap lines at convenient points, avoid wrapping a line in the middle of a word
set matchpairs+=<:> " Use % to jump between pairs
set modelines=2
set mouse=a     " enable for all modes
set nobackup    " disable backup files
set nocompatible    " use Vim settings rather then Vi settings
set nocursorline  " doesn't mark the line the cursor is currently in
set noerrorbells visualbell t_vb=
set noshiftround
set noshowmode    " does't show mode at the bottom
set nospell
set nostartofline
set number
set pastetoggle=<F2>
set regexpengine=1
if version >= 704
    set relativenumber
endif
set ruler   " show cursor position
set scrolloff=3 " The number of screen lines to keep above and below the cursor
set shiftwidth=4
set showcmd    " show partial command in the last line of the screen
set showmatch
set showmode    " display the current mode and partially-typed commands in the status line
set smartcase   " Override the 'ignorecase' option if the search pattern contains upper case characters
set softtabstop=4
set spelllang=en_us
set splitbelow
set splitright
set t_Co=256
set tabstop=4
set term=xterm-256color
set textwidth=0
set timeout
set timeoutlen=500
set ttimeout
set ttimeoutlen=100
set ttyfast     " smooth redrawing on fast terminals
set ttymouse=sgr
set undodir=/tmp//,.
set undofile " Maintain undo history between sessions
set virtualedit=block
set visualbell t_vb=  " no visual bell
set whichwrap=b,s,<,>
set wildignore=*.o,*~,*.pyc,.git\*,.hg\*,.svn\*,*/.idea/**,*/build/**,*/target/**,*.obj,*.class,*.swp   " ignore compiled files
set wildignorecase  " case insensitive on filename completion
set wildmenu    " Display command line’s tab complete options as a menu
set wildmode=list:longest,full    " have command-line completion <Tab>
set wrap    " wrap long lines

" Store all swap files in this directory
if !isdirectory($HOME . "/.vim/swp")
    call mkdir($HOME . "/.vim/swp", "p")
endif
set directory=$HOME/.vim/swp//

" set powerline
set rtp+=/usr/share/vim/addons/

" Add '-' to defaults keywords
set iskeyword=@,-,48-57,_,192-255

" -----------------------------------------------------------------------------
" Mappings
" -----------------------------------------------------------------------------

" Highlight word and copy to clipboard on double click
nnoremap <silent> <2-LeftMouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<cr>:set hls<cr>:let @+=expand('<cword>')<cr>

" Paste buffer on right click
noremap <silent> <RightMouse> "*]p:set nopaste<CR>
inoremap <silent> <RightMouse> <C-\><C-O>"*]p
" Quit visual mode on right click
xmap <RightMouse> <Esc>

" Copy to clipboard shortcut in visual mode
xmap <C-c> "+y

" Show next/previous matched string at the center of the screen
nnoremap n nzz
nnoremap N Nzz

" make . to work with visually selected lines
vnoremap . :normal.<CR>

" Move visual selection
vnoremap J :m '>+1<CR>gv=gv " move selection 1 line down
vnoremap K :m '<-2<CR>gv=gv " move selection 1 line up

" Navigate around splits with a single key combo.
nnoremap <S-l> <C-w><C-l>
nnoremap <S-h> <C-w><C-h>
nnoremap <S-k> <C-w><C-k>
nnoremap <S-j> <C-w><C-j>

" Cycle through splits.
nnoremap <S-Tab> <C-w>w

" Switch between buffer
map <C-K> :bprev<CR>
map <C-J> :bnext<CR>

"Jump back to last edited buffer
nnoremap <C-b> <C-^>
inoremap <C-b> <esc><C-^>

nnoremap <leader>tt :tabnew<CR>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprev<CR>
nnoremap <leader>to :tabo<CR>
nnoremap <leader>/ :noh<CR>
nnoremap <leader>s :set spell! "toggle spell

" Fix indentation of the entire file then return where you were
map <F7> gg=G<C-o><C-o>

" -----------------------------------------------------------------------------
" Autocommands
" -----------------------------------------------------------------------------

" highlight trailing whitespace
match ErrorMsg '\s\+$'
" remove trailing whitespaces automatically
autocmd BufWritePre * :%s/\s\+$//e

" Reduce delay when switching between modes.
augroup NoInsertKeycodes
  autocmd!
  autocmd InsertEnter * set ttimeoutlen=0
  autocmd InsertLeave * set ttimeoutlen=50
augroup END

" Auto-resize splits when Vim gets resized.
autocmd VimResized * wincmd =

" Update a buffer's contents on focus if it changed outside of Vim.
au FocusGained,BufEnter * :checktime

" Unset paste on InsertLeave.
autocmd InsertLeave * silent! set nopaste

" Make sure all types of requirements.txt files get syntax highlighting.
autocmd BufNewFile,BufRead requirements*.txt set syntax=python

" Ensure tabs don't get converted to spaces in Makefiles.
autocmd FileType make setlocal noexpandtab

" redraw is necessary because of startup bug with 'set lazyredraw'
autocmd VimEnter * redraw!

" Line number in Insert mode and relative number in Normal mode.
augroup toggle_relative_number
  autocmd!
  autocmd InsertEnter * :setlocal norelativenumber
  autocmd InsertLeave * :setlocal relativenumber
augroup END