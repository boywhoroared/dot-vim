" Move visual lines on wrapped lines, unless a count is given.
" If a count is given, operate on actual lines (normal behaviour).
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" . operator works on visually selected lines
vnoremap . :norm.<CR>

" @ macro operator on visually selected lines
vnoremap @ :norm@

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" Make Y behave like C and D, yank to EOL
nn Y y$

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" Hard Re-wrap Paragraphs (Textmate)
nnoremap <Leader>q gqip

" Hard Re-wrap and leave cursor at current word after formatting
nnoremap <Leader>qw gwip

" Extra Quit mappings; mapped around ZZ, {X:Exit Y:Yes!}Z, you get it?
nnoremap ZX :wqall<CR>
nnoremap ZY :qa!<CR>
nnoremap ZS :suspend<CR>

" Edit Adjacent Files
nnoremap <leader>ew :e <C-R>=expand("%:p:h")."/"<CR><C-D>
nnoremap <leader>es :sp <C-R>=expand("%:p:%")."/"<CR><C-D>
nnoremap <leader>ev :vsp <C-R>=expand("%:p:h")."/"<CR><C-D>
nnoremap <leader>et :tabe <C-R>=expand("%:p:h")."/"<CR><C-D>

" Toggle Line Numbering
if exists('+relativenumber')
  " Show relative numbers for offset lines, while showing the absolute number
  " for the current line
  "
  " help :number_relativenumber

  " Cycle through relativenumber + number, number (only), and no numbers
  nnoremap <leader>n :<c-r>={
      \ '00': 'set rnu   <bar> set nu',
      \ '01': 'set nornu <bar> set nu',
      \ '10': 'set nornu <bar> set nonu',
      \ '11': 'set nornu <bar> set nu' }[&nu . &rnu]<cr><cr>

  " How This Works
  "
  " The expression register, <c-r>=, is passed an array of
  " commands.
  "
  " Each command corresponds to the current enabled/disabled state of number
  " and relativenumber.  For example, if both number and relativenumber are
  " off, we have '00'.  [&nu . &rnu] = 00
  "
  " Thus, the expression will evalute to the command to set both nu and rnu
  " on.
  "
  " The first <cr> causes the expression to be evaluated.  The second finishes
  " the command.
else
  " Toggle line numbers
  nnoremap <leader>n :setlocal number!<cr>
endif

" Backspace jumps to the last buffer
nnoremap <BS> <C-^>

" Quick Save.
nmap <Leader>w :w<CR>
nmap <Leader>W :w!<CR>


" COMMAND LINE {{{
" Insert current line from buffer, into command line.
" Like '<C-R><C-W>' but for the line under the cursor.
" :help c_CTRL-R_CTRL-W
cnoremap <C-R><C-L> <C-R>=getline('.')<CR>

" Run the current line as a shell command using the filter command
noremap g! !!$SHELL<CR>

" Execute the current selection as shell commands using the filter command
vnoremap g! !$SHELL<CR>

" }}}

" SEARCH {{{
" Keep search matches in the middle of the window:
"   n/N - next search down/up
"   zz - scroll the cursor's current line to the center of the window
"   zv - open enough folds to view the cursor's current line
" See :h zz, :h zv :h scrolling
nnoremap n nzzzv
nnoremap N Nzzzv

" Use <C-L> to clear the highlighting of :set hlsearch.
if has('reltime') && has ('extra_search')
  if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
  endif
endif
" }}}

" WhichKey shows my mappings in a popup if I don't follow my leader with
" another key (i.e. complete a mapping sequence)
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

