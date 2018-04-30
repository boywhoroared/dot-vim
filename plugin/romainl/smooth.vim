" romainl's smooth search and list mappings
" https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86
" https://github.com/romainl/minivimrc/blob/master/vimrc

" smooth grepping
command! -nargs=+ -complete=file_in_path -bar Grep silent! grep! <args> | redraw!

" smooth searching
cnoremap <expr> <Tab>   getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"

" super quick search and replace
" search & replace within the current paragraph
nnoremap <Space><Space> :'{,'}s/\<<C-r>=expand("<cword>")<CR>\>/
" search % replace within the file
nnoremap <Space>% :%s/\<<C-r>=expand("<cword>")<CR>\>/

" smooth listing
" Source <https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86>
"
" This gives you nicer listings and jump prompt for all or most of vims
" navigation jumps.
"
" Run the list command of choice from below and you'll get
" a list of jumps. Enter the number and jump to that point!
"
" :ls
" :files
" :buffers
" :changes
" :marks
" :undolist
" :dlist
" :ilist
" :jumps
" :oldfiles
" :llist (location list)
" :clist
cnoremap <expr> <CR> <SID>CCR()
function! s:CCR()
  command! -bar Z silent set more|delcommand Z
  if getcmdtype() == ":"
    let cmdline = getcmdline()
    if cmdline =~ '\v\C^(dli|il)' | return "\<CR>:" . cmdline[0] . "jump   " . split(cmdline, " ")[1] . "\<S-Left>\<Left>\<Left>"
    elseif cmdline =~ '\v\C^(cli|lli)' | return "\<CR>:silent " . repeat(cmdline[0], 2) . "\<Space>"
    elseif cmdline =~ '\C^changes' | set nomore | return "\<CR>:Z|norm! g;\<S-Left>"
    elseif cmdline =~ '\C^ju' | set nomore | return "\<CR>:Z|norm! \<C-o>\<S-Left>"
    elseif cmdline =~ '\v\C(#|nu|num|numb|numbe|number)$' | return "\<CR>:"
    elseif cmdline =~ '\C^ol' | set nomore | return "\<CR>:Z|e #<"
    elseif cmdline =~ '\v\C^(ls|files|buffers)' | return "\<CR>:b"
    elseif cmdline =~ '\C^marks' | return "\<CR>:norm! `"
    elseif cmdline =~ '\C^undol' | return "\<CR>:u "
    else | return "\<CR>" | endif
  else | return "\<CR>" | endif
endfunction
