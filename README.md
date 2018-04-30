# Vi-Improved and NeoVim

A second take on my `vim` and `neovim` configurations.

## Install


```shell
# clone repo

# install the minpac plugin manager
git submodule init
```

## Guides

- [Vi-Improved](https://www.vi-improved.org/)
- [Absolute Bare Minimum](http://derekwyatt.org/2009/08/20/the-absolute-bare-minimum/)
- [Better Settings](http://derekwyatt.org/2009/08/23/better-settings/)
- [The Patient Vimmer](https://romainl.github.io/the-patient-vimmer/)
- [Learn Vimscript The Hard Way](http://learnvimscriptthehardway.stevelosh.com)
- [You Do Not Grok Vi](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118)

## References (Places I Have Shamelessly Copied Things From)

## Practice

* Moving better

  * Motions and Text Objects `:help navigation`
  * Jumps (Search, Tags, Changes)
  * Consider disabling backspace changes so we have to use Normal mode
  * Consider lowering or disabling key repeat to force you to use operators motions and objects

* Read up on 'tags-and-searches' 'definitions-search' 'suffixadd',
  'includeexpr', 'cfile' Investigate how we can use these with PHP, JS,
  Composer, Node and ctags/global tags
  * 'includeexpr' can take a function. it's used by `gf` to jump to files.
    Look at how
    [rails.vim](https://github.com/tpope/vim-rails/blob/master/autoload/rails.vim)
    uses this.

## Commands

`Spaces {size}>` &#8202;—&#8202; Use `{size}` spaces for indentation rather
than tabs.

`Tabs {size}>` &#8202;—&#8202; Use `{size}` tabs for indentation rather than
spaces.

`DiffOrig` &#8202;—&#8202; diff the current buffer against the file it was
loaded from. Useful for seeing the changes made so far. spaces.

`CreateSnippet` &#8202;—&#8202; _to be implemented_ will create a new snippet
from the currently selected text (or range?); useful for when I notice I'm
repeating patterns/idioms.

## Mappings

* `<C-L>` &#8202;—&#8202; clear highlighted searches; mapped as an analog to
  `<C-L>` to clear in the shell?
* `g!` &#8202;—&#8202; run/filter the current line or visual selection through
  the shell. Effectively, we can execute commands/scripts from the buffer. See
  `:help filter`. You can use `!` and `!!` normal mode to supply the target
  filter yourself.

## Tips and Tricks (Reminders?)

* <https://www.vi-improved.org/vim-tips/>
* [Positioning the cursor for command line mappings](https://stackoverflow.com/a/13511478)

### Recordings (Macros)

https://gist.github.com/romainl/9721c7dd13c30714f568063e03c106dd
Not only can you record the macros, you can edit and assign them from other sources.
You don't have to record one, you can build it manually.
If so, then we can record and save things like refactorings?

### Edit and Reload vimrc

```
:e $MYVIMRC
:w|so %
```

### Change case of text

Use `~` and `g~` with motions to change the case of text targeted by motion

### Rearranging Lines

<https://www.reddit.com/r/vim/comments/4ouh89/weekly_vim_tips_and_tricks_thread_15/d4fvd0g/>

## To Do

* Check out `cpoptions`
* Look into useing 'define' 'include-search' 'includeexpr' 'suffixesadd'
  '<cfile>'
* Consider having an "extra" mapping for `gf` like `<Space>gf` or
  `<LocalLeader>gf` that can do extra/uncommon things when I want hop files
  such as dealing with NL's non PSR code in PHP etc.
* Create command to run buffer or selection through a language specific
  interpreter. Results should go to a scratch buffer `:help filter` `:help buftype`
