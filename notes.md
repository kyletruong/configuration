# iTerm
### Fonts
Select font in iTerm -> Profiles -> Text -> Font and select `SF Mono Powerline Semibold`.

### Colors
Import `one-dark.itermcolors` into iTerm -> Profiles -> Colors -> Color Presets.

**Change the following**:  
Foreground: `b2b2b2`  
Background: `282c34`  
Bold: `d29a61`  
Cursor: `b2b2b2`  
Bright Black: `40% Gray`

# Neovim
https://neovim.io/doc/user/nvim.html#nvim-from-vim

```
(?) rm ~/.viminfo
mkdir -p ~/.config/nvim/ && touch ~/.config/nvim/init.vim

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
```

run `:checkhealth`  
to use python2 pip run `python2.7 -m ensurepip --default-pip`

# CoC Extensions
`coc-pairs coc-json coc-snippets coc-emmet coc-tsserver`

# Misc
- Todoist
- Magnet
