set nocompatible

" Prevent Neovim Terminal Nesting
if has('nvim')
  let $VISUAL = 'nvr -cc split --remote-wait-silent'
endif

" FileType shortcuts & identifers
au FileType markdown vnoremap <Space><Bar> :EasyAlign*<Bar><Enter>
au FileType markdown set spell spelllang=en_us
au FileType markdown set list
au BufNewFile,BufRead * :call DetectLang()
au BufNewFile,BufRead *.sgr set filetype=sugarml.pug.jade.html
au BufNewFile,BufRead *.jade set filetype=sugarml.pug.jade.html
au BufNewFile,BufRead *.pug set filetype=sugarml.pug.jade.html
au BufNewFile,BufRead *.sss set filetype=sugarss.stylus.css
au BufNewFile,BufRead *.styl set filetype=sugarss.stylus.css
au BufNewFile,BufRead /etc/nginx/sites-* set filetype=conf
au TermOpen * setlocal nonumber

" Plugins
call plug#begin()

" Global
Plug 'chrisbra/Recover.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'dir': '/home/hhsnopek/.fzf', 'do': './install --all' }
Plug 'w0rp/ale'
Plug 'mxw/vim-jsx'
Plug 'rbong/vim-flog'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'tpope/vim-fugitive'

" Lazy-load
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'othree/es.next.syntax.vim', { 'for': 'javascript' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'digitaltoad/vim-pug', { 'for': 'sugarml.pug.jade.html' }
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
set expandtab
set clipboard+=unnamed
set listchars=tab:\\t,extends:›,precedes:‹,nbsp:•,trail:•
set ruler
syntax enable

" Visual settings
set termguicolors
set background=dark
color challenger_deep

" Statusline
set statusline=[%M%n]\ %y\ %t\ %=\ %l:%c

" ale
let g:ale_fix_on_save = 1
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'
let g:ale_lint_on_enter = 0
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint', 'prettier'],
\   'python': ['yapf'],
\}

" Neovim/Python
let g:python_host_prog='/usr/bin/python'
let g:python3_host_prog='/usr/bin/python3'

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

" vim-go
set autowrite
set updatetime=200
let g:go_auto_type_info = 1
let g:go_fmt_command = "goimports"
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>i <Plug>(go-info)
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" Edit and source vimrc on the fly
nnoremap <leader>ev :vsp $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>eb :vsp /home/hhsnopek/.bashrc<cr>
nnoremap <leader>ea :vsp /home/hhsnopek/.config/alacritty/alacritty.yml<cr>

nnoremap <leader>ec :vsp /home/hhsnopek/.config/nvim/plugged/vim-firewatch/colors/firewatch.vim<cr>
nnoremap <leader>sc :source /home/hhsnopek/.config/nvim/plugged/vim-firewatch/colors/firewatch.vim<cr>

" Tab Controls
nnoremap <Tab>l :tabn<cr>
nnoremap <Tab>h :tabp<cr>

" for insert mode
inoremap <S-Tab> <C-d>

" Format code
nnoremap fj :%!python -m json.tool<cr>
nnoremap fjs :!standard --fix %<cr>
nnoremap fjsp :%!prettier --stdin --parser babel<cr>
nnoremap fx :%!xmllint --format %<cr>
nnoremap rt :%s/\t/  /g<cr>

" Ctrl-Direction to switch panels when in term emulator
tnoremap ,j <c-\><c-n><c-w>j tnoremap ,k <c-\><c-n><c-w>k
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
nnoremap <leader>w :call ToggleWrap()<cr>
nnoremap <leader>c :set list!<cr>

" Search adjustments
nnoremap <leader>n :set hls!<cr>
nnoremap / :set hlsearch<cr>/

" Notes
nnoremap en :vsp $PWD/notes<cr>

" Save and Delete Buffer
nnoremap Q :w\|bd<cr>

" TODO 80th col
" if has('nvim')
"   highlight link OverLength Error
"   match OverLength /\%81v.\+/
" endif

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
    let s .= (tabnr == tabpagenr() ? ' %#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tabnr .' '
    let s .= (tabnr == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= tabname
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction
set tabline=%!Tabline()

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

function! SwapWords(dict, ...)
    let words = keys(a:dict) + values(a:dict)
    let words = map(words, 'escape(v:val, "|")')
    if(a:0 == 1)
        let delimiter = a:1
    else
        let delimiter = '/'
    endif
    let pattern = '\v(' . join(words, '|') . ')'
    exe '%s' . delimiter . pattern . delimiter
        \ . '\=' . string(Mirror(a:dict)) . '[S(0)]'
        \ . delimiter . 'g'
endfunction
