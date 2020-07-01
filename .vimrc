"  ___  __        ___    ___ ___       _______      
" |\  \|\  \     |\  \  /  /|\  \     |\  ___ \     
" \ \  \/  /|_   \ \  \/  / | \  \    \ \   __/|    
"  \ \   ___  \   \ \    / / \ \  \    \ \  \_|/__  
"   \ \  \\ \  \   \/  /  /   \ \  \____\ \  \_|\ \ 
"    \ \__\\ \__\__/  / /      \ \_______\ \_______\
"     \|__| \|__|\___/ /        \|_______|\|_______|
"               \|___|/                             
"
" Filename:     .vimrc
" Github:       https://github.com/kyletruong/dotfiles
" Maintainer:   Kyle Truong

" Plugins {{{
let need_to_install_plugins = 0
if has('nvim')
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        let need_to_install_plugins = 1
    endif
else
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        let need_to_install_plugins = 1
    endif
endif

call plug#begin()
if !has('nvim')
    Plug 'tpope/vim-sensible'
endif
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'ap/vim-buftabline'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'majutsushi/tagbar'
Plug 'sheerun/vim-polyglot'
Plug 'mhinz/vim-signify'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'vim-scripts/BufOnly.vim'
Plug 'mhinz/vim-startify'
" Plug 'airblade/vim-rooter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

if need_to_install_plugins == 1
    echo "Installing plugins..."
    silent! PlugInstall
    echo "Done!"
    q
endif
" }}}

" Neovim {{{
if has('nvim')
    let g:python3_host_prog = '/usr/local/opt/python@3.8/bin/python3'
    let g:python_host_prog = '/usr/bin/python2'
    let g:ruby_host_prog = '/usr/local/bin/neovim-ruby-host'
    set guicursor=
endif
" }}}

" Miscellaneous {{{

" remaps
map <space> <leader>
nnoremap <C-]> g<C-]>
command! WQ wq
command! Wq wq
command! W w
command! Q q
nnoremap <leader>ve :vsp ~/dotfiles/.vimrc<CR>
nnoremap <leader>vs :so ~/dotfiles/.vimrc<CR> \| :doautocmd BufRead<CR>

" colors
set termguicolors

" searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set showmatch
map <leader><space> :noh<CR>

" turn on line numbering
set nu rnu

" sane text files
set modifiable
set fileformat=unix
set fileencoding=utf-8

" sane editing
set wrap
set textwidth=99
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set viminfo='25,\"50,n~/.viminfo
autocmd FileType python setlocal ts=4 sts=4 sw=4

" mouse
set mouse=a
let g:is_mouse_enabled = 1

" color scheme
colorscheme onedark

" code folding
set foldmethod=indent
set foldlevel=99

" copy, cut and paste
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" buffer stuff
set hidden
nmap <leader>[ :bp<CR>
nmap <leader>] :bn<CR>
nnoremap <leader>q :bp \| bd#<CR>
nnoremap <leader>p :b#<CR>
nnoremap <leader>o :BufOnly<CR>

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" restore place in file from previous session
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" disable autoindent when pasting text
" source: https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" }}}

" Buftabline {{{
let g:buftabline_plug_max = 13
let g:buftabline_indicators = 1
nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)
nmap <leader>- <Plug>BufTabLine.Go(11)
nmap <leader>= <Plug>BufTabLine.Go(12)
nmap <leader>\ <Plug>BufTabLine.Go(13)
" }}}

" Fugitive {{{
nmap <leader>gl :diffget //3<CR>
nmap <leader>gh :diffget //2<CR>
nmap <leader>gs :G<CR>
nmap <leader>gd :Gdiffsplit<CR>
set diffopt+=vertical
" }}}

" FZF {{{
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>gf :GFiles?<cr>
nnoremap <leader>rr :Rg<space><cr>
let g:fzf_buffers_jump = 1
let g:fzf_action = {
    \ 'ctrl-i': 'split',
    \ 'ctrl-s': 'vsplit' }
" }}}

" Lightline {{{
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'fugitive#head'
    \ },
\ }
" }}}

" Nerdtree {{{
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let g:nerdtree_open = 0
let g:NERDTreeWinSize = 45
map <leader>N :call NERDTreeFind()<CR>
map <leader>n :call NERDTreeToggle()<CR>
map <leader>m :call NERDTreeResetAndFind()<CR>
nnoremap <C-w>= :call Equal()<CR> \| :wincmd =<CR> 

function! NERDTreeResetAndFind()
    :call NERDTreeFind()
    :call NERDTreeFind()
endfunction

function! NERDTreeToggle()
    silent NERDTreeToggle
    if g:nerdtree_open == 1
        let g:nerdtree_open = 0
    else
        let g:nerdtree_open = 1
        wincmd p
    endif
endfunction

function! NERDTreeFind()
    let g:NERDTreeWinSize = 45
    if g:nerdtree_open == 1
        let g:nerdtree_open = 0
        NERDTreeClose
    else
        let g:nerdtree_open = 1
        if @% == ""
            silent NERDTree
        else
            NERDTree
            NERDTreeClose
            NERDTreeFind
        endif
        wincmd p
    endif
endfunction

function! Equal()
    call NERDTreeFind()
    call NERDTreeFind()
    TagbarToggle
    TagbarToggle
endfunction
" }}}

" Signify {{{
let g:signify_sign_delete = '_'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change = '~'
let g:signify_sign_show_count = 0
let g:signify_sign_show_text = 1
nnoremap <leader>s :SignifyToggle<CR>
" }}}

" Startify {{{
" let g:startify_change_to_vcs_root = 1
" }}}

" Tagbar {{{
" map <leader>t :TagbarToggle<CR>
" }}}

" CoC {{{
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>i <Plug>(coc-format-selected)
nmap <leader>i <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>af  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" }}}

" vim:foldmethod=marker:foldlevel=0
