if ! exists('g:loaded_fzf')
    finish
endif

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

" Launch fzf with CTRL+P.
nnoremap <silent> <C-p> :GFiles<CR>

" Map a few common things to do with FZF.
nnoremap <silent> <Leader><C-b> :Buffers<CR>
nnoremap <silent> <Leader><C-l> :Lines<CR>
nnoremap <silent> <Leader><C-g> :Rg<Cr>

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Allow passing optional flags into the Rg command.
"   Example: :Rg myterm -g '*.md'
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --hidden --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)
