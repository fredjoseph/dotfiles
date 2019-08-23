" -----------------------------------------------------------------------------
" Shortcuts:
"   Ctrl-w + w : switch to the next pane
"   Ctrl-w + q : quit pane
"   Ctrl-w Arrow : switch the active pane
"   Ctrl-w + v : split vertically
"   Ctrl-w + s : split horizontally
"   Ctrl-w + c : close the current pane
"   Ctrl-w +  : move the current pane into its own tab
"   :e <file> : edit a file in a new buffer
"   :bn : go to next buffer
"   :bp : go to previous buffer
"   :bd : delete buffer (close a file)
"   :ls : list all buffers
"   :sp <file>: open a file in a new buffer and split window
"   :vsp wfile> : open a file in a new buffer and vertically split window
"   Ctrl-n : autocomplete
"   gt (or :tabn) : go to next tab
"   gT (or :tabp or :tabN) : go to previous tab
"   #gt (or :tabn #) : go to #th tab
"   :tabn : go to next tab
"   :tabp : got to previous tab
"   :tabc : close the current tab
"   :tabo : colse all tabs except the current one
"   :tabr : go to first tab
"   :tabl : go to last tab
"   :tabm : move the current tab to the last position
"   :tabm # : move the current tab to the #th position
"   i : enter insert mode
"   Esc : enter command mode
"   x or Del : delete the character at the current cursor position
"   X : delete the character before the current cursor position
"   u : undo changes
"   Ctrl + r : redo changes
"   yw : copy word
"   yy : copy a line
"   #yy : copy # lines
"   y$ : copy from current cursor position till the end of the line
"   yG : copy from current cursor position till the end of the file
"   dd : delete current line
"   #dd : delete # lines
"   dw : delete (cut) word
"   d$ : delete (cut) from current cursor position till the end of the line
"   dG : delete from current cursos position till the end of the file
"   p : paste the content of the buffer before the cursor position
"   P : paste the content of the buffer after the cursor position
"   /<search_term> : Search and then cycle through matches with n and N
"   H : move to the top of the screen
"   L : move to the bottom of the screen
"   M : move to the middle of the screen
"   [[ or gg : move to the beginning of a file
"   ]] or G : move to the end of a file
"   nG : move to line number n
"   %s/foo/bar/gci : search and replace all occurrences with confirmation
"   :noh : remove highlighting of search matches
"   Esc + :w : save changes
"   Esc + :wq or Esc + ZZ : save and quit vim
"   Esc + :q! : force quit vim discarding all changes
"   Esc + :! : run a shell commands like :!dir, :!ls
"   gg=G : fix indentation of the entire file
"   w (or W) : jump forwards to the start of a word (W : words can contain
"   punctuation)
"   e (or E) : jump forwards to the end of a word (E: can contain punctuation)
"   b (or B) : jump backwards to the start of a word (B: can contain
"   punctuation)
"   % : move to matching character (supported pairs: '()','{}','[]'
"   ^ : jump to the first non blank character of the line
"   g_ : jump to the last non blank character of the line
"   gg : go to the first line of the document
"   G : go to the last line of the document
"   #G : go to line #
"   f# : jump to next occurrence of character #
"   F# : jump to previous occurrence of character #
"   ; : repeat previous f,F movement
"   , : repeat previous f,F movement, backwards
"   { : jump to previous paragraph (or function/block)
"   } : jump to next paragraph (or function/block)
"   zz : center cursor on screen
"   Ctrl + e : move screen down one line
"   Ctrl + y : move screen up one line
"   Ctrl + b : move back one full screen
"   Ctrl + f : move forward one full screen
"   Ctrl + u : move back 1/2 screen
"   Ctrl + d : move forward 1/2 screen
"   r# : replace a single character by #
"   gJ : join line below to the current one with no separator
"   cc (or S) : change/replace entire line
"   . : repeat last command
"
" Insert mode:
"   i : new text will appear before the cursor
"   a : new text will appear after the cursor
"   I : new text will appear at the beginning of the current line
"   A : new text will appear at the end of the current line
"   o : a new line is created after the current line
"   O : a new line is created before the current line
"   ea : insert (append) at the end of the word
"   cc (or S) : change/replace entire line
"   C : change to the end of the line
"   ciw : change entire word
"   cw : change to the end of the word
"
" Visual mode:
"		v : start visual mode
"		V : start linewise visual mode
"   y : copy selection to buffer
"   = : fix indentation of the current selectioni
"   aw : mark a word
"   ab : a block with ()
"   aB : a block with {}
"   ib : inner block with ()
"   iB : inner block with {}
"   d : delete marked text
"   ~ : switch case
" -----------------------------------------------------------------------------

" Load plugins
source ~/.vim/.plug.vim

" -----------------------------------------------------------------------------
" Basic Settings
"   Research any of these by running :help <setting>
" -----------------------------------------------------------------------------

" list of available color schemes : /usr/share/vim/vim80/colors
colo desert

syntax on   " syntax highlighting

let mapleader=" "
let maplocalleader=" "

set autoindent
set autoread
set backspace=indent,eol,start
set backupdir=/tmp//,.
set cindent     " programmers autoindent, and don't remove indent on '#'
set confirm     " Instead of failing a command because of unsaved changes, raise a dialogue asking if you wish to save.
set encoding=utf8
set expandtab
set hidden
set hlsearch    " highlight search matches
set ignorecase  " ignore case during search
set incsearch   " match pattern while typing search
set laststatus=2
set lazyredraw      " fix slow scrolling on some files
set matchpairs+=<:> " Use % to jump between pairs
set modelines=2
set mouse=a     " enable for all modes
set nocompatible
set noerrorbells visualbell t_vb=
set noshiftround
set noshowcmd   " Show (partial) command in the last line of the screen
set nospell
set nostartofline
"set number
set regexpengine=1
set ruler
set scrolloff=3
set shiftwidth=4
"set showcmd    " show partial command in the last line of the screen
set showmatch
set showmode    " display the current mode and partially-typed commands in the status line
set smartcase   " Override the 'ignorecase' option if the search pattern contains upper case characters
set softtabstop=4
set spelllang=en_us
set splitbelow
set splitright
set t_Co=256
set tabstop=2
set term=xterm-256color
set textwidth=0
set timeout
set timeoutlen=500
set ttimeout
set ttimeoutlen=100
set ttyfast     " smooth redrawing on fast terminals
set ttymouse=sgr
set undodir=/tmp//,.
set virtualedit=block
set visualbell t_vb=  " no visual bell
set whichwrap=b,s,<,>
set wildignore=*.o,*~,*.pyc,.git\*,.hg\*,.svn\*   " ignore compiled files
set wildignorecase  " case insensitive on filename completion
set wildmenu
set wildmode=list:longest,full    " have command-line completion <Tab>
set wrap

" set powershell
set rtp+=/usr/share/vim/addons/

" -----------------------------------------------------------------------------
" Basic mappings
" -----------------------------------------------------------------------------

" Navigate around splits with a single key combo.
nnoremap <S-l> <C-w><C-l>
nnoremap <S-h> <C-w><C-h>
nnoremap <S-k> <C-w><C-k>
nnoremap <S-j> <C-w><C-j>

" Cycle through splits.
nnoremap <S-Tab> <C-w>w

nnoremap <leader>t :tabnew<Enter>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Fix indentation of the entire file then return where you were
map <F7> gg=G<C-o><C-o>

" -----------------------------------------------------------------------------
" Basic autocommands
" -----------------------------------------------------------------------------

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

" TO DELETE
"" -----------------------------------------------------------------------------
"" Plugins settings, mappings and autocommands
"" -----------------------------------------------------------------------------
"" .............................................................................
"" junegunn/fzf.vim
"" .............................................................................
"
"let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
"
"" Launch fzf with CTRL+P.
"nnoremap <silent> <C-p> :FZF -m<CR>
"
"" Map a few common things to do with FZF.
"nnoremap <silent> <Leader><Enter> :Buffers<CR>
"nnoremap <silent> <Leader>l :Lines<CR>
"
"" Allow passing optional flags into the Rg command.
""   Example: :Rg myterm -g '*.md'
"command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " . <q-args>, 1, <bang>0)
"
"" .............................................................................
"" scrooloose/nerdtree
"" .............................................................................
"
"let g:NERDTreeShowHidden=1
"let g:NERDTreeAutoDeleteBuffer=1
"
"" Open nerd tree at the current file or close nerd tree if pressed again.
"nnoremap <silent> <expr> <Leader>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
"
"" close vi if only NERDTree is still open
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"
"" .............................................................................
"" mhinz/vim-signify
"" .............................................................................
"
"let g:signify_realtime=1
"let g:signify_vcs_list=["git"]
"let g:signify_cursorhold_normal=0
"let g:signify_cursorhold_insert=0
"
"" .............................................................................
"" kien/rainbow_parentheses.vim
"" .............................................................................
"
"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces
