":help nvim-from-vim
" set runtimepath+=~/.vim,~/.vim/after
" set packpath+=~/.vim
source ~/.vim/vimrc

" enable <Esc> for terminal buffers
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif
