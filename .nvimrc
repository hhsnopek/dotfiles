" FileType shortcuts & identifers
au FileType markdown vnoremap <Space><Bar> :EasyAlign*<Bar><Enter>
au BufNewFile,BufRead *.sgr set filetype=sugarml.pug.jade.html
au BufNewFile,BufRead *.jade set filetype=sugarml.pug.jade.html
au BufNewFile,BufRead *.sss set filetype=sugarss.stylus.css
au BufNewFile,BufRead *.styl set filetype=sugarss.stylus.css

" Plugins
call plug#begin()
" Global
Plug 'mhinz/vim-startify'
Plug 'chrisbra/Recover.vim'
Plug 'wakatime/vim-wakatime'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'hhsnopek/vim-firewatch'

" Lazy-load
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'digitaltoad/vim-pug', { 'for': 'sugarml.pug.jade.html' }
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffeescript' }
Plug 'hhsnopek/vim-sugarss', { 'for': 'sugarss.stylus.css' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'junegunn/vim-easy-align', { 'for': 'markdown' }
call plug#end()

" Editor settings
filetype plugin indent on
set number
set textwidth=80
set wrap
set nosmarttab
set tabstop=2
set shiftwidth=2
set clipboard=unnamed
set list
set listchars=tab:▸-
set t_Co=256
set ruler
syntax on
colorscheme firewatch
hi Search guifg=#ffffff guibg=#D193E2

" Statusline
set statusline=[%M%n]\ %y\ %t\ %=\ %l:%c

" Startify
let g:startify_list_order = [['   Sessions'], 'sessions', ['   Bookmarks'], 'bookmarks', ['   Cmds'], 'commands']

" Neovim/Python
let g:python_host_prog='/usr/local/bin/python2'
let g:python3_host_prog='/usr/local/bin/python3'

" Editorconfig
let g:EditorConfig_core_mode = 'external_command'

" Map leader
let mapleader = "\<Space>"
nnoremap , <Leader> " Alias mapleader

" Plug-in settings
let g:vim_markdown_folding_disabled=1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_term_enabled = 1
let g:go_term_mode = "split"
let g:EditorConfig_core_mode = 'external_command'
let g:netrw_banner = 0
let g:netrw_list_hide= '.*\.swp$,.DS_Store,*/tmp/*,*.so,*.swp,*.zip,*.git,^\.\=/\=$'

" Edit and source vimrc on the fly
nnoremap <leader>ev :vsp $MYVIMRC<cr>
nnoremap <leader>eb :vsp ~/.bashrc<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>sc :source ~/projects/dotfiles/.nvim/bundle/vim-firewatch/colors/firewatch.vim<cr>
nnoremap <leader>eh :vsp ~/projects/dotfiles/.hyper.js<cr>

" Tab Controls
nnoremap tne :tabnew<cr>:Explore<cr>

" for insert mode
inoremap <S-Tab> <C-d>

" Operation pinkie
" nnoremap ; :
" nnoremap : ;
" vnoremap ; :
" vnoremap : ;

" Ctrl-Direction to switch panels when in term emulator
tnoremap ,j <c-\><c-n><c-w>j
tnoremap ,k <c-\><c-n><c-w>k
tnoremap ,l <c-\><c-n><c-w>l
tnoremap ,h <c-\><c-n><c-w>h
tnoremap <esc> <c-\><c-n>
tnoremap <c-\> <esc>
tnoremap ,tq <c-\>:tabclose<cr>

" Ctrl-Direction to switch panels
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k
nnoremap <leader>l <c-w>l
nnoremap <leader>h <c-w>h

" Dirty habits
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <del> <nop>
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" Morning shortcuts
nnoremap <leader>E :Explore<cr>
nnoremap <leader>V :vsp<cr>
nnoremap <leader>S :sp<cr>
nnoremap <leader>st :sp<cr>:term<cr>
nnoremap <leader>vt :vsp<cr>:term<cr>
nnoremap <leader>t :term<cr>
nnoremap <leader>w :call ToggleWrap()<cr>
nnoremap <leader>c :set list!<cr>

" Search adjustments
nnoremap <leader>n :set hls!<cr>
nnoremap / :set hlsearch<cr>/

" 80th col
if empty($NVIM_LISTEN_ADDRESS)
  highlight OverLength ctermbg=174 ctermfg=255
  match OverLength /\%81v.\+/
endif

" Syntax Identifier
nmap <leader>sf :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Toggle Line Wrap
function! ToggleWrap()
  if &wrap
    set nowrap
  else
    set wrap
  endif
endfunc
