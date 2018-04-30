let $MYVIMDIR = fnamemodify($MYVIMRC, ':h')

set undofile
set nobackup
set noswapfile

" Use backup features if on a UNIX-like system and not using sudo
if &backup && !strlen($SUDO_USER) && has('unix')
  " Keep backups and undo in a central location.
  if !isdirectory($MYVIMDIR."/tmp/backup") && exists('*mkdir')
    call mkdir($MYVIMDIR."/tmp/backup", "p", 0700)
  endif

  " Set the directories where vim keeps backups
  set backupdir-=.
  set backupdir-=~/
  " The double slash is used to make Vim use the full path to the file in the
  " backup filename. Using this to avoid collisions.
  set backupdir^=$MYVIMDIR/tmp/backup//

  " Keep a version of the file made when the file was opened for editing.
  "set patchmode=.orig
endif

if (&swapfile) && !strlen($SUDO_USER) && has('unix')
  if !isdirectory($MYVIMDIR."/tmp/swap") && exists('*mkdir')
    call mkdir($MYVIMDIR."/tmp/swap", "p", 0700)
  endif

  set directory-=.
  set directory-=~/
  set directory^=$MYVIMDIR/tmp/swap//
endif

" Keep screeds of undo history if I am on my mac or running the GUI
if has('macunix') || has('macvim') || has('gui_running') 
  set undolevels=2000
endif

" Keep undo history in a separate file if the feature is available, we're on
" Unix, and not using sudo; this goes really well with undo visualization
" plugins like Gundo or Undotree.
if has('persistent_undo') && &undofile && !strlen($SUDO_USER) && has('unix')
  if !isdirectory($MYVIMDIR."/tmp/undo") && exists('*mkdir')
    call mkdir($MYVIMDIR."/tmp/undo", "p", 0700)
  endif

  " Keep per-file undo history in ~/.vim/undo; the double-slash at the end
  " of the directory prods Vim into keeping the full path to the file in its
  " undo filename to avoid collisions; the same thing works for swap files
  set undodir-=.
  set undodir^=$MYVIMDIR/tmp/undo//

  " Don't track changes to sensitive files (tmp directories or shared memory)
  if has('autocmd')
    augroup undoskip
      autocmd!
      silent! autocmd BufWritePre
          \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
          \ setlocal noundofile
    augroup END
  endif
endif
