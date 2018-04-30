" Juggling
" 
" Use Vim built in file-searching and lists to jump between files, buffers and
" tags.
"
" :help definitions
" :help definiton-search
" :help include
" :help includeexpr
" :help suffixadd
" :help tags-and-searches
"
" Sources:
" https://romainl.github.io/the-patient-vimmer/2.html
" https://www.reddit.com/r/vim/comments/3o7b4h/can_vim_manage_project_folders/cvuosjy
" http://stackoverflow.com/questions/16082991/vim-switching-between-files-rapidly/16084326#16084326
" https://www.reddit.com/user/-romainl-
"
" :help cmdline-completion

" Juggle files
nnoremap <Leader>f :find *
nnoremap <Leader>fs :sfind *
nnoremap <Leader>v :vert sfind *
nnoremap <Leader>t :tabfind *

" Juggle files recursively under the directory of the current file.
nnoremap <Leader>F :find <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap <Leader>S :sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap <Leader>V :vert sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap <Leader>T :tabfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>

" Juggling Buffers
" List all open buffers, then start the buffer selection command which uses
" tab completion
nnoremap <Leader>l :ls<CR>:buffer<Space>
nnoremap <Leader>ls :ls<CR>:sbuffer<Space>
nnoremap <Leader>lp :ls<CR>:pwd<CR>:buffer<Space>
nnoremap gb :ls<CR>:buffer<Space>
nnoremap gB :ls<CR>:sbuffer<Space>

" Depends on wildcharm=<C-z>
nnoremap <Leader>b :buffer <C-z><S-Tab>
nnoremap <leader>B :sbuffer <C-z><S-Tab>
nnoremap ,b :buffer *
nnoremap ,B :sbuffer *

" The mappings above list the available buffers in the "wildmenu" with an empty
" prompt, allowing me to either navigate the menu with <Tab> or type a few
" letters and <Tab> again to narrow down the list. Like with the file mappings
" above, the process is quick and almost friction-less.

nnoremap <PageUp>   :bprevious<CR>
nnoremap <PageDown> :bnext<CR>
" Those mappings speak for themselves.

" Juggling with Tags/Definitions
nnoremap <Leader>j :tjump /
nnoremap <Leader>js :stjump /
nnoremap <Leader>d :dlist /

" See :h ptjump and :tselect
nnoremap <Leader>p :ptjump /

" Juggle Definitions
" :help definition-search 
nnoremap [D [D:djump   <C-r><C-w><S-Left><Left>
nnoremap ]D ]D:djump   <C-r><C-w><S-Left><Left>

" Juggle Keyword matches
nnoremap <Leader>I :ilist /
nnoremap [I [I:ijump   <C-r><C-w><S-Left><Left><Left>
nnoremap ]I ]I:ijump   <C-r><C-w><S-Left><Left><Left>

" Juggling with changes
nnoremap <Leader>; *``cgn
nnoremap <Leader>, #``cgN

" Juggling Completion
inoremap ,, <C-x><C-o><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>" : ""<CR>
inoremap ,; <C-n><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>" : ""<CR>
inoremap ,: <C-x><C-f><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>" : ""<CR>
inoremap ,= <C-x><C-l><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>" : "
