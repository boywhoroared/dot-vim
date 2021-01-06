unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

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

" Use ~ for g~
set tildeop

" }}}

" Scrolling
"
" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Similarly... :help sidescrolloff
set sidescroll=1
set sidescrolloff=1

" Show line numbers
set number

" Show whitespace
" if listchars is using the vim default, use our default
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

"{{{ Searching (For Files and In Files)
if has('path_extra')
  set path=.,,** " gf and :find search deep in the cwd; :help file-searching, :help path
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

" Do incremental searching when it's possible to timeout.
if has('reltime') && has ('extra_search')
  set hlsearch
  set incsearch

  if has('nvim')
    " show matches for search patterns as I type!
    set inccommand=split
    " Also for nvim, you have the :s as well as :smagic commands
  endif
endif

" Case-insensitive search unless the search uses mixed cases
set smartcase
set ignorecase

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

"}}}

" UI
set laststatus=2 " Always show the status line
set showmode " Show current vim mode

set wildmenu " Display completion matches, for the commandline, in a status line
set wildcharm=<C-Z> " Use <C-Z> to trigger completion mode in mappings

" I see your true colours -- use GUI 24 bit colour
if has('termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

colorscheme jellybeans

" Packages/Plugins {{{

" Jump between matching pairs/groups
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  packadd! matchit
  " See :help matchit and :help matchit-newlang
endif

" Not sure that I like minpac -- I want to use different 'packages' to group
" plugins.

silent! packadd minpac

if exists('g:loaded_minpac')
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
  call minpac#add('machakann/vim-sandwich')
  call minpac#add('tommcdo/vim-lion')

  " if !has('nvim')
  "   call minpac#add('markonm/traces.vim', {'type': 'opt'})
  " endif

  call minpac#add('tpope/vim-ragtag')

  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-dispatch')

  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-git')
  call minpac#add('rhysd/conflict-marker.vim')

  call minpac#add('janko/vim-test')

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
  call minpac#add('prettier/vim-prettier')

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

  " We should make these 'opt'-ional and put the server registration to
  " filetype plugins
  call minpac#add('prabirshrestha/vim-lsp')
  call minpac#add('mattn/vim-lsp-settings')

  call minpac#add('prabirshrestha/asyncomplete.vim')
  call minpac#add('prabirshrestha/async.vim')
  call minpac#add('prabirshrestha/asyncomplete-emoji.vim')
  call minpac#add('prabirshrestha/asyncomplete-ultisnips.vim')
  call minpac#add('prabirshrestha/asyncomplete-emmet.vim')
  call minpac#add('prabirshrestha/asyncomplete-lsp.vim')

  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('liuchengxu/vista.vim')

  " Colorschemes
  " OG Themes
  call minpac#add('sjl/badwolf')
  call minpac#add('tpope/vim-vividchalk')
  call minpac#add('nanotech/jellybeans.vim')
  call minpac#add('jnurmine/Zenburn')

  call minpac#add('AlessandroYorba/Alduin')
  call minpac#add('AlessandroYorba/Despacio')
  call minpac#add('AlessandroYorba/Sierra')

  call minpac#add('romainl/Apprentice')
  call minpac#add('romainl/Disciple')

  call minpac#add('cocopon/iceberg.vim')
  call minpac#add('whatyouhide/vim-gotham')
  call minpac#add('wadackel/vim-dogrun')

  call minpac#add('junegunn/seoul256.vim')

  call minpac#add('lifepillar/vim-solarized8')
  call minpac#add('lifepillar/vim-gruvbox8')

  call minpac#add('fenetikm/falcon')

  " Minimalist
  call minpac#add('axvr/photon.vim')
  call minpac#add('hardselius/warlock')

  " Space Themes
  call minpac#add('jaredgorski/SpaceCamp')
  call minpac#add('pineapplegiant/spaceduck')

  call minpac#add('kamwitsta/flatwhite-vim')
endif

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

" Plugin Settings {{{
" Autocomplete {{{
" For autocomplete, have a look at
" https://github.com/prabirshrestha/asyncomplete.vim

" How These Autocommands Work
" ---------------------------
"
" The asyncomplete and vim-lsp plugins have defined their own events for
" their setup -- asyncomplete_setup, lsp_setup --  that you can hook into to
" register servers and completions!
"
" `User` is an autocommand event that is fired for `:doautocmd {Group} {Event}`
"

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

" UltiSnips
if has('python3')
  autocmd UserAsyncomplete User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'whitelist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ }))
endif

" Emmet 
autocmd UserAsyncomplete User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#emmet#get_source_options({
    \ 'name': 'emmet',
    \ 'whitelist': ['html'],
    \ 'completor': function('asyncomplete#sources#emmet#completor'),
    \ }))


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
" }}}


" Mappings
runtime maps.vim

" Project/External vimrc {{{
"
" Some projects (work) or experiments, have some idiosyncrasies (work) that
" I can handle with project specific configuration.
set exrc
set secure " this *should* always go last
"}}}

" vim: fdm=marker:sw=2:sts=2:et
