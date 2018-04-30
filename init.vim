":help nvim-from-vim
" set runtimepath+=~/.vim,~/.vim/after
" set packpath+=~/.vim
source ~/.vim/vimrc

" terminals use truecolour
set termguicolors

" enable <Esc> for terminal buffers
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif
