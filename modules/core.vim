scriptencoding utf-8
syntax enable " enable sytnax
set hidden " enable hidden buffers
filetype plugin indent on " use ftplugin and indents based on detected file type
set smartindent
set title " more meta info for window manager
set lazyredraw " speed up vim drawing
set autoread  " Automatically read a file changed outside of vim
set splitright " when splitting vertically, focus goes right
set undolevels=1000
set ttimeout " Allows for setting custom ttimeoutlen intervals
set wildignorecase " no case sensitivity on wild menu
set wildcharm=<C-z> " wildchar in macros
set magic " Use extended regular expressions
set mouse=nv " Mouse can be used in normal and visual mode
set wildmode=list:longest,full " gives tab completion lists in ex command area
set shiftwidth=2 " indent code with two spaces
set softtabstop=2 " tabs take two spaces
set tabstop=2 " tabs take two spaces
set expandtab " replace tabs with spaces
set shiftround " round indent to multiples of shiftwidth
set linebreak " do not break words.
set ignorecase " ignore cases
set smartcase " except if string contains a capital letter
set noswapfile " This is a bit annoying
set inccommand=split " preview replacement changes
set synmaxcol=200 " Large columns with syntax highlights slow things down
set formatoptions-=o " Don't insert comment lines when pressing o in normal mode
set grepprg=rg\ --vimgrep
set completeopt+=longest,noinsert,menuone,noselect
set completeopt-=preview
set complete-=t " let mucomplete handle searching for tags. Don't scan by default
set omnifunc=syntaxcomplete#Complete
set path-=/usr/include

set formatlistpat=^\\s*                     " Optional leading whitespace
set formatlistpat+=[                        " Start character class
set formatlistpat+=\\[({]\\?                " |  Optionally match opening punctuation
set formatlistpat+=\\(                      " |  Start group
set formatlistpat+=[0-9]\\+                 " |  |  Numbers
set formatlistpat+=\\\|                     " |  |  or
set formatlistpat+=[a-zA-Z]\\+              " |  |  Letters
set formatlistpat+=\\)                      " |  End group
set formatlistpat+=[\\]:.)}                 " |  Closing punctuation
set formatlistpat+=]                        " End character class
set formatlistpat+=\\s\\+                   " One or more spaces
set formatlistpat+=\\\|                     " or
set formatlistpat+=^\\s*[-–+o*•]\\s\\+      " Bullet points

if !has('nvim')
set autoindent
set complete-=i " let mucomplete handle searching for included files. Don't scan by default
set belloff=all " No annoying bells
set wildmenu " tab through things at vim command line
set backspace=indent,eol,start "see :h backspace
endif

" Common mistakes
iab    retrun  return
iab     pritn  print

augroup omnifuncs
  autocmd!
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

" Quit netrw when selecting a file
function! QuitNetrw()
  for i in range(1, bufnr($))
    if buflisted(i)
      if getbufvar(i, '&filetype') == "netrw"
        silent exe 'bwipeout ' . i
      endif
    endif
  endfor
endfunction

augroup core
  au FileType netrw au BufLeave QuitNetrw()
  autocmd BufWritePre * %s/\s\+$//e " removes whitespace
"  autocmd WinNew * call tools#saveSession(tools#manageSession())
  autocmd BufAdd * call tools#loadDeps()
  autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
    \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif
  " Sundry file type associations
  au! BufNewFile,BufRead *.bat,*.sys setf dosbatch
  au! BufNewFile,BufRead *.eslintrc,*.babelrc,*.prettierrc,*.huskyrc setf json
  au! BufNewFile,BufRead *.pcss setf css
augroup END

augroup AutoSwap
  autocmd!
  autocmd SwapExists *  call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)
augroup END

function! AS_HandleSwapfile (filename, swapname)
 " if swapfile is older than file itself, just get rid of it
  if getftime(v:swapname) < getftime(a:filename)
    call delete(v:swapname)
    let v:swapchoice = 'e'
  endif
  " Echo current git branch
  echom 'On branch: '.statusline#GitBranch()
endfunction

augroup MarkMargin
  autocmd!
  autocmd  BufEnter  * :call MarkMargin()
augroup END

function! MarkMargin ()
  if exists('b:MarkMargin')
    call matchadd('ErrorMsg', '\%>'.b:MarkMargin.'v\s*\zs\S', 0)
  endif
endfunction

augroup checktime
  au!
  if !has('gui_running')
      "silent! necessary otherwise throws errors when using command line window.
    autocmd BufEnter,CursorHold,CursorHoldI,CursorMoved,CursorMovedI,FocusGained,BufEnter,FocusLost,WinLeave * checktime
  endif
augroup END

let g:loaded_python_provider = 1
  let g:python3_host_prog = '/usr/local/bin/python3'

let g:data_dir = $HOME . '/.cache/Vim/'
let g:backup_dir = g:data_dir . 'backup'
let g:swap_dir = g:data_dir . 'swap'
let g:undo_dir = g:data_dir . 'undofile'
let g:conf_dir = g:data_dir . 'conf'
if finddir(g:data_dir) ==# ''
  silent call mkdir(g:data_dir, 'p', 0700)
endif
if finddir(g:backup_dir) ==# ''
  silent call mkdir(g:backup_dir, 'p', 0700)
endif
if finddir(g:swap_dir) ==# ''
  silent call mkdir(g:swap_dir, 'p', 0700)
endif
if finddir(g:undo_dir) ==# ''
  silent call mkdir(g:undo_dir, 'p', 0700)
endif
if finddir(g:conf_dir) ==# ''
  silent call mkdir(g:conf_dir, 'p', 0700)
endif
unlet g:data_dir
unlet g:backup_dir
unlet g:swap_dir
unlet g:undo_dir
unlet g:conf_dir
set undodir=$HOME/.cache/Vim/undofile
set backupdir=$HOME/.cache/Vim/backup
set directory=$HOME/.cache/Vim/swap
"" Ignore dist and build folders
set wildignore+=*/dist*/**,*/target/**,*/build*/**
" Ignore libs
set wildignore+=*/lib/**,*/node_modules/**,*/bower_components/**,*/locale/**
" Ignore images, pdfs, and font files
set wildignore+=*.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG,*.pdf
set wildignore+=*.ttf,*.otf,*.woff,*.woff2,*.eot
