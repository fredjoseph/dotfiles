if ! exists('g:loaded_nerd_tree')
    finish
endif

let g:NERDTreeShowHidden=1
let g:NERDTreeAutoDeleteBuffer=1

" Open nerd tree at the current file or close nerd tree if pressed again.
nnoremap <silent> <expr> <Leader>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

" close vi if only NERDTree is still open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

