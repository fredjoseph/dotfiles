" =============================================================================
" Plugin Manager Setup
" =============================================================================
"
filetype off

" Install the plugin manager if it doesn't exist
let s:plugin_manager=expand('~/.vim/autoload/plug.vim')
let s:plugin_url='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if empty(glob(s:plugin_manager))
  echom 'vim-plug not found. Installing...'
  if executable('curl')
    silent exec '!curl -fLo ' . s:plugin_manager . ' --create-dirs ' .
          \ s:plugin_url
  elseif executable('wget')
    call mkdir(fnamemodify(s:plugin_manager, ':h'), 'p')
    silent exec '!wget --force-directories --no-check-certificate -O ' .
          \ expand(s:plugin_manager) . ' ' . s:plugin_url
  else
    echom 'Could not download plugin manager. No plugins were installed.'
    finish
  endif
  augroup vimplug
    autocmd!
    autocmd VimEnter * PlugInstall
  augroup END
endif

" Create a horizontal split at the bottom when installing plugins
let g:plug_window = 'botright new'

let g:plug_dir = expand('~/.vim/bundle')
call plug#begin(g:plug_dir)

" quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" fzf
" Usage:
" :FZF[!] (!: launch in full screen mode)
" Ctrl-x : horizontal split
" Ctrl-v : vertical split
" Ctrl-t : new tab
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'

" Zoom in and out of a specific split pane (similar to tmux).
" Usage: <C-w>m
Plug 'dhruvasagar/vim-zoom'

" Pass focus events from tmux to Vim (useful for autoread and linting tools).
Plug 'tmux-plugins/vim-tmux-focus-events'

" Better display unwanted whitespace.
Plug 'ntpeters/vim-better-whitespace'

" Navigate and manipulate files in a tree view.
" Usage: :NERDTree
" <leader> n : Open/close NERDTree
" ? : display help
" o: open in prev window
" t: open in new tab
" T: open in new tab silently
" i: open split
" s: open vsplit
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Show git file changes in the gutter.
Plug 'mhinz/vim-signify'

" A git wrapper.
Plug 'tpope/vim-fugitive'

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" Alignment plugin
" Usage: gaip in normal mode, vipga in visual mode
" gaip= Around the 1st occurrences
" gaip2= Around the 2nd occurrences
" gaip*= Around all occurrences
" gaip**= Left/Right alternating alignment around all occurrences
"   <Enter> Switching between left/right/center alignment modes
" gaip<Space> Around the 1st occurrences of whitespaces
" gaip2<Space> Around the 2nd occurrences
" gaip-<Space> Around the last occurrences
" gaip<Enter><Enter>2<Space> Center-alignment around the 2nd occurrences
" Works with the following characters: <Space>, =, :, ., |, &, # and ,
Plug 'junegunn/vim-easy-align'

" Auto-close quotes, parens, brackets...
Plug 'Raimondi/delimitMate'

Plug 'kien/rainbow_parentheses.vim'

""" All of your Plugins must be added before the following line
" Add plugins to &runtimepath
call plug#end()   "required

function! OnVimEnter() abort
  " Run PlugUpdate every week automatically when entering Vim.
  if exists('g:plug_home')
    let l:filename = printf('%s/.vim_plug_update', g:plug_home)
    if filereadable(l:filename) == 0
      call writefile([], l:filename)
    endif

    let l:this_week = strftime('%Y_%V')
    let l:contents = readfile(l:filename)
    if index(l:contents, l:this_week) < 0
      call execute('PlugUpdate')
      call writefile([l:this_week], l:filename, 'a')
    endif
  endif
endfunction

autocmd VimEnter * call OnVimEnter()
