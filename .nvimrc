set nocompatible

" FileType shortcuts & identifers
au FileType markdown vnoremap <Space><Bar> :EasyAlign*<Bar><Enter>
" au FileType markdown set spell spelllang=en_us
au FileType markdown set list
au BufNewFile,BufRead * :call DetectLang()
au BufNewFile,BufRead *.sgr set filetype=sugarml.pug.jade.html
au BufNewFile,BufRead *.jade set filetype=sugarml.pug.jade.html
au BufNewFile,BufRead *.pug set filetype=sugarml.pug.jade.html
au BufNewFile,BufRead *.sss set filetype=sugarss.stylus.css
au BufNewFile,BufRead *.styl set filetype=sugarss.stylus.css
au BufNewFile,BufRead /etc/nginx/sites-* set filetype=conf

" Plugins
call plug#begin()
" Global
Plug 'chrisbra/Recover.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug '~/.config/nvim/plugged/vim-firewatch'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Lazy-load
Plug 'koekeishiya/kwm', { 'dir': '~/.config/nvim/plugged/kwm/syntax/vim', 'for': 'kwm' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'digitaltoad/vim-pug', { 'for': 'sugarml.pug.jade.html' }
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'hhsnopek/vim-sugarss', { 'for': 'sugarss.stylus.css' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'junegunn/vim-easy-align', { 'for': 'markdown' }
call plug#end()

" Editor settings
filetype plugin on
filetype indent off
set number
set textwidth=80
set wrap
set nosmartindent
set tabstop=2
set shiftwidth=2
set clipboard=unnamed
set listchars=tab:▸-
set ruler
syntax enable

" firewatch
set termguicolors
set background=dark
colorscheme firewatch

" Statusline
set statusline=[%M%n]\ %y\ %t\ %=\ %l:%c

" Neovim/Python
let g:python_host_prog='/usr/local/bin/python2'
let g:python3_host_prog='/usr/local/bin/python3'

" Editorconfig
let g:EditorConfig_core_mode = 'external_command'

" Map leader
let mapleader = "\<Space>"

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
nnoremap <leader>sc :source ~/.config/nvim/plugged/vim-firewatch/colors/firewatch.vim<cr>
nnoremap <leader>ec :vsp ~/.config/nvim/plugged/vim-firewatch/colors/firewatch.vim<cr>

" Tab Controls
nnoremap tne :tabnew<cr>:Explore<cr>
nnoremap <Tab>l :tabn<cr>
nnoremap <Tab>h :tabp<cr>

" for insert mode
inoremap <S-Tab> <C-d>

" format code
nnoremap fj :%!python -m json.tool<cr>
nnoremap fjs :!standard --fix %<cr>
nnoremap fjsp :%!prettier --stdin --no-semi --single-quote<cr>
nnoremap fx :%!xmllint --format %<cr>

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
nnoremap <leader>b :call Battery()<cr>

" Search adjustments
nnoremap <leader>n :set hls!<cr>
nnoremap / :set hlsearch<cr>/

" todo
nnoremap etd :vsp ~/TODO<cr>

" project notes
nnoremap en :vsp $PWD/notes<cr>

" 80th col
if empty($NVIM_LISTEN_ADDRESS)
  highlight link OverLength Error
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

" Format Markdown files
function! MarkdownFormat()
  let save_pos = getpos(".")
  let query = getreg('/')
  execute ":0,$!tidy-markdown"
  call setpos(".", save_pos)
  call setreg('/', query)
endfunction

" Detect Shebang language
function! DetectLang()
  let shebang = getline(1)

  " check if shebag
  if shebang =~ '#!'
    if shebang =~ 'node'
      set ft=javascript
    elseif shebang =~ 'bash'
      set ft=sh
    else
      set ft=text
    endif
  endif
endfun

" Battery Status
" DISCHARING: 47% TTL: 3:20
function! Battery()
  let life = system("pmset -g batt | tail -n -1 | sed -n 's/.*\\([0-9]\\{2,2\\}" . fnameescape('%') . "\\);\\s\\(.*\\);\\s\\([0-9]\\{0,1\\}[0-9]:[0-9][0-9]\\).*/\\U\\" . fnameescape('2') . ": \\" . fnameescape('1') . "  TTL: \\" . fnameescape('3') . "/p'")
  echo strpart(life, 0, strlen(life) - 1)
endfun

" Tabline
function! Tabline()
  let s = ''
  for tabnum in range(tabpagenr('$'))
    let tabnr = tabnum + 1
    let winnr = tabpagewinnr(tabnr)
		let tabcwd = getcwd(winnr, tabnr)
    let tabname = (tabcwd != '' ? fnamemodify(tabcwd, ':t') . ' ' : '[No Name] ')

    " check if it's a term instance (neovim only)
    let buflist = tabpagebuflist(tabnr)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    if len(buflist) == 1
      if bufname =~ 'term://'
        let tabname = 'term '
      endif
    endif

		" format
    let s .= (tabnr == tabpagenr() ? ' %#Title#' : '%#TabLine#')
    let s .= ' ' . tabnr .' '
    let s .= (tabnr == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= tabname
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction
set tabline=%!Tabline()
