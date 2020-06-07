set nocompatible

" I see your true colours -- use GUI 24 bit colour
if has('termguicolos')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Make it easier to read files by enabling syntax highlighting
if has('syntax') && !exists('g:syntax_on')
  syntax enable
  " This is different to using `syntax on`. See :help syntax-on

  " Do not syntax highlight stupidly long lines (longer than 2048 characters);
  " It slows vim down.
  "
  " (2048 is arbitrary but it's more generous than 1024)
  set synmaxcol=2048
endif

" Make it easier to understand different files. Try to detect the type of file
" and load syntax and identation plugins for that type.
if has('autocmd')
  filetype plugin indent on
endif

" I can edit multiple files without having to save them.
" vim will prompt me to save them if try to quit
" :help buffer-hidden | :help hidden
if has("listcmds")
  set hidden
endif

" If the Vim buffer for a file doesn't have any changes and Vim detects the
" file has been altered, quietly update it
set autoread

" set <Leader> to the Spacebar.
" (`mapleader` isn't special, its more like a convention)
" :help mapleader
let mapleader = "\<Space>"

" {{{ Editing

" Infer indent level from the previous line
set autoindent " :help autoindent says this is local to buffer, so does setting it here help?

" Indent/Shift size
set shiftwidth=2

" softabstop = shiftwidth
" we use let &option = expression here because we use an expression to the get
" the value of shiftwidth
let &softtabstop = &shiftwidth

set smarttab " insert spaces, according to shiftwidth, if <Tab> at the start of the line, rather than tabs
set expandtab " Use spaces, not tabs, but the same size as we expect tabs to appear
" set shiftround

" commands for adjusting indentation rules manually
" source: github.com/romainl reddit.com/u/-romainl-
command! -nargs=1 Spaces
      \ execute "setlocal shiftwidth=" . <args> . " softtabstop=" . <args> . " expandtab" |
      \ setlocal ts? sw? sts? et?
command! -nargs=1 Tabs
      \ execute "setlocal shiftwidth=" . <args> . " softtabstop=" . <args> . " noexpandtab" |
      \ setlocal ts? sw? sts? et?

" Formatting {{{
" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" Hard Re-wrap Paragraphs (Textmate)
nnoremap <Leader>q gqip

" Hard Re-wrap and leave cursor at current word after formatting
nnoremap <Leader>qw gwip

" Remove the redundant comment leader when joining two comment lines
if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j
endif

" Nicer formatting for prose (lists and paragraphs).
set formatoptions+=1ln
"}}}

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" Use ~ for g~
set tildeop

" Edit Adjacent Files
nnoremap <leader>ew :e <C-R>=expand("%:p:h")."/"<CR><C-D>
nnoremap <leader>es :sp <C-R>=expand("%:p:%")."/"<CR><C-D>
nnoremap <leader>ev :vsp <C-R>=expand("%:p:h")."/"<CR><C-D>
nnoremap <leader>et :tabe <C-R>=expand("%:p:h")."/"<CR><C-D>

" Move visual lines on wrapped lines, unless a count is given.
" If a count is given, operate on actual lines (normal behaviour).
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" }}}

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Numbering {{{
" Show line numbers
set number
if exists('+relativenumber')
  " show relative numbers for offset lines, while showing the absolute number
  " for the current line
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
"}}}

" Show whitespace
" if listchars is using the vim default, use our default
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

":help sidescrolloff
set sidescroll=1
set sidescrolloff=1

set laststatus=2 " always show the status line; not sure how I feel about this
set ruler " show the position of the cursor all the time
set showmode " show current vim mode
set wildmenu " display completion matches, for the commandline, in a status line
set wildcharm=<C-Z> " use <C-Z> to trigger completion mode in mappings

"{{{ Searching (For Files and In Files)
if has('path_extra')
  set path=.,,** " gf and :find search deep in the cwd; :help file-searching, :help path
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

" Do incremental searching when it's possible to timeout.
if has('reltime') && has ('extra_search')
  set incsearch

  " Use <C-L> to clear the highlighting of :set hlsearch.
  if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
  endif

  if has('nvim')
    " show matches for search patterns as I type!
    set inccommand=split
    " Also for nvim, you have the :s as well as :smagic commands
  endif
endif

" Keep search matches in the middle of the window:
"   n/N - next search down/up
"   zz - scroll the cursor's current line to the center of the window
"   zv - open enough folds to view the cursor's current line
" See :h zz, :h zv :h scrolling
nnoremap n nzzzv
nnoremap N Nzzzv

" Case-insensitive search unless the search uses mixed cases
set smartcase
set ignorecase

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

"}}}

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout " time out for key codes
  set ttimeoutlen=100 " wait up to 100ms after Esc for special key
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
" Source: default.vim
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif


" Maps {{{

" Backspace jumps to the last buffer
nnoremap <BS> <C-^>

" Make Y behave like C and D, yank to EOL
nn Y y$

" Quick Save.
nmap <Leader>w :w<CR>
nmap <Leader>W :w!<CR>

" Extra Quit mappings; mapped around ZZ, {X:Exit Y:Yes!}Z, you get it?
nnoremap ZX :wqall<CR>
nnoremap ZY :qa!<CR>
nnoremap ZS :suspend<CR>

" Insert current line from buffer, into command line.
" Like '<C-R><C-W>' but for the line under the cursor.
" :help c_CTRL-R_CTRL-W
cnoremap <C-R><C-L> <C-R>=getline('.')<CR>

" Run the current line as a shell command using the filter command
noremap g! !!$SHELL<CR>

" Execute the current selection as shell commands using the filter command
vnoremap g! !$SHELL<CR>

" . operator works on visually selected lines
vnoremap . :norm.<CR>
" @ macro operator on visually selected lines
vnoremap @ :norm@

"}}}

" Packages/Plugins {{{

if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  packadd! matchit
  " See :help matchit and :help matchit-newlang
endif

" Not sure that I like minpac -- I want to use different 'packages' to group
" plugins.
"
" Also, you still have to use :helptags
"
" Maybe just manage plugins with shellscripts.

silent! packadd minpac

if exists('*minpac#init')
  " minpac is loaded.
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Additional plugins here.
  " call minpac#add('tpope/vim-vinegar')
  call minpac#add('justinmk/vim-dirvish')

  call minpac#add('tpope/vim-repeat')
  call minpac#add('tpope/vim-abolish')
  call minpac#add('tpope/vim-unimpaired')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-sleuth')
  " vim-sandwich replaces 'tpope/vim-surround
  call minpac#add('machakann/vim-sandwich')

  " if !has('nvim')
  "   call minpac#add('markonm/traces.vim', {'type': 'opt'})
  " endif

  call minpac#add('tpope/vim-ragtag')
  call minpac#add('tpope/vim-dadbod')

  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-dispatch')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-git')
  call minpac#add('rhysd/conflict-marker.vim')
  call minpac#add('tommcdo/vim-lion')

  call minpac#add('janko/vim-test')
  call minpac#add('w0rp/ale')

  call minpac#add('liuchengxu/vim-which-key')

  " Snippets / Autocomplete
  call minpac#add('mattn/emmet-vim')
  call minpac#add('SirVer/ultisnips')
  call minpac#add('honza/vim-snippets')
  call minpac#add('epilande/vim-react-snippets')
  call minpac#add('epilande/vim-es2015-snippets')

  " TODO: It would be nice to conditionally load these via filetype plugins
  call minpac#add('StanAngeloff/php.vim')

  " JavaScript/TypeScript
  call minpac#add('othree/yajs.vim')
  " You WANT to read more about how this works:
  " https://github.com/othree/javascript-libraries-syntax.vim
  call minpac#add('othree/javascript-libraries-syntax.vim')
  call minpac#add('othree/es.next.syntax.vim')
  call minpac#add('othree/jsdoc-syntax.vim')
  call minpac#add('leafgarland/typescript-vim')

  call minpac#add('othree/html5.vim')

  " Python
  call minpac#add('hdima/python-syntax')
  call minpac#add('tweekmonster/braceless.vim')

  " CI/CD, syadmin/ops
  call minpac#add('martinda/Jenkinsfile-vim-syntax')
  call minpac#add('chr4/nginx.vim')

  " Writing
  call minpac#add('tpope/vim-markdown')
  call minpac#add('junegunn/goyo.vim')
  call minpac#add('junegunn/limelight.vim')
  call minpac#add('junegunn/vim-emoji')
  call minpac#add('dkarter/bullets.vim')

  " Wiki, Notes and ToDos
  call minpac#add('vimwiki/vimwiki')
  call minpac#add('mattn/calendar-vim')
  call minpac#add('dbeniamine/todo.txt-vim')
  call minpac#add('vim-voom/VOoM')
  call minpac#add('joanrivera/vim-zimwiki-syntax')

  " Colorschemes
  call minpac#add('lifepillar/vim-solarized8')
  call minpac#add('AlessandroYorba/Alduin')
  call minpac#add('AlessandroYorba/Despacio')
  call minpac#add('AlessandroYorba/Sierra')
  call minpac#add('AlessandroYorba/Breve')
  call minpac#add('archSeer/colibri.vim')
  call minpac#add('fcpg/vim-fahrenheit')
  call minpac#add('fcpg/vim-orbital')
  call minpac#add('fenetikm/falcon')
  call minpac#add('jnurmine/Zenburn')
  call minpac#add('nanotech/jellybeans.vim')
  call minpac#add('owickstrom/vim-colors-paramount')
  call minpac#add('rakr/vim-two-firewatch')
  call minpac#add('romainl/Apprentice')
  call minpac#add('romainl/Disciple')
  call minpac#add('sjl/badwolf')
  call minpac#add('whatyouhide/vim-gotham')
  call minpac#add('nightsense/snow')
  call minpac#add('liuchengxu/space-vim-theme')
  call minpac#add('NLKNguyen/papercolor-theme')
  call minpac#add('chmllr/elrodeo-vim-colorscheme')
  call minpac#add('cormacrelf/vim-colors-github')
  call minpac#add('romainl/vim-dichromatic')
  call minpac#add('tpope/vim-vividchalk')
  call minpac#add('arzg/vim-oldbook8')
  call minpac#add('lifepillar/seoul256.vim')
  call minpac#add('lifepillar/vim-gruvbox8')
  call minpac#add('srcery-colors/srcery-vim')
  call minpac#add('stillwwater/vim-nebula')
  call minpac#add('jdsimcoe/panic.vim')
  call minpac#add('jaredgorski/SpaceCamp')
  call minpac#add('wadackel/vim-dogrun')
  call minpac#add('sonjapeterson/1989.vim')
  call minpac#add('haishanh/night-owl.vim')
  call minpac#add('raphamorim/lucario')
  call minpac#add('kamwitsta/flatwhite-vim')

endif

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
" }}}

" Plugin Settings {{{

" Language Servers {{{
" See https://github.com/prabirshrestha/vim-lsp/wiki/Servers
" for server configuration
function! s:register_language_servers()
  call lsp#register_server({
        \ 'name': 'php-language-server',
        \ 'cmd': {server_info->['php', expand('~/.composer/vendor/bin/php-language-server.php')]},
        \ 'whitelist': ['php'],
        \ })

  if executable('typescript-language-server')
    call lsp#register_server({
          \ 'name': 'typescript-language-server',
          \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
          \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
          \ 'whitelist': ['typescript', 'javascript', 'javascript.jsx']
          \ })
  endif
endfunction

augroup UserLanguageServer
  autocmd!
  autocmd User lsp_setup call s:register_language_servers()
augroup END
"}}}

" NOTE - How These Autocommands Work
" `User` is an autocommand event that is fired for `:doautocmd {Group} {Event}`
" So, the asyncomplete and vim-lsp plugins have defined their own events for
" their setup -- asyncomplete_setup, lsp_setup --  that you can hook into to
" register servers and completions!

" Autocomplete {{{
" For autocomplete, have a look at
" https://github.com/prabirshrestha/asyncomplete.vim

" Emoji completion because reasons
augroup UserAsyncomplete
  autocmd!
  " TODO it is probably better to have this register from a Markdown filetype
  " plugin
  autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#emoji#get_source_options({
        \ 'name': 'emoji',
        \ 'whitelist': ['*'],
        \ 'completor': function('asyncomplete#sources#emoji#completor'),
        \ }))
augroup END

if has('python3')
  autocmd UserAsyncomplete User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'whitelist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ }))
endif

" Ultisnips snippets trigger uses Ctrl+e, not Tab; prevents class with
" asyncomplete
let g:UltiSnipsExpandTrigger="<c-e>"

" asyncomplete triggers the completion pop up menu automagically in insert
" mode. these mappings let us use tab and shift+tab to navigate the pop up
" menu (pum)
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
" }}}


" }}}

" WhichKey shows my mappings in a popup if I don't follow my leader with
" another key (i.e. complete a mapping sequence)
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

colorscheme slate

" Project/External vimrc {{{
"
" Some projects (work) or experiments, have some idiosyncrasies (work) that
" I can handle with project specific configuration.
set exrc
set secure " this *should* always go last
"}}}

" vim: fdm=marker:sw=2:sts=2:et
