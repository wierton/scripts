""""""""""""""""""""""""""""""""
" wierton's vim configure file "
""""""""""""""""""""""""""""""""

func! CompileRun()
  if expand('%:t') != ''
	exec "w"
  endif
  if &filetype == 'c'
	exec "!gcc -w % -o %< && ./%<"
  elseif &filetype == 'cpp'
	exec "!g++ % -o %< && ./%<"
  elseif &filetype == 'python'
	exec "!python %"
  elseif &filetype == 'tex'
	let pdfname = expand("%:r").".pdf"
	exec "!xelatex % ".pdfname."&& evince ".pdfname." &> /dev/null"
  elseif &filetype == 'make'
	exec "!make"
  elseif &filetype == 'html'
	exec "!google-chrome-stable %"
  elseif &filetype == 'sh'
	exec "!bash %"
  elseif &filetype == 'php'
	exec "!php %"
  endif
endfunc

inoremap <F5> <Esc>:call CompileRun() <CR>
nnoremap <F5> <Esc>:call CompileRun() <CR>
" nnoremap <C-l> :exec "!yd ".substitute(expand("<cword>"), "\n", " ", "g") <CR>
" vnoremap <C-l> y:exec "!yd ".substitute(getreg("0"), "\n", " ", "g") <CR>
nnoremap <C-k> <Esc>:%!clang-format<CR><C-o>

noremap + <C-w>+
noremap - <C-w>-

"adjust python indent to 2 space"
autocmd Filetype py setl shiftwidth=2

"==================="
set tags=./tags;,tags
setlocal noswapfile 
set bufhidden=hide 
set nocompatible 
syntax on 
"colorscheme evening 
set number 
set cursorline 
set ruler 
set expandtab " disable tab when auto-indent
set shiftwidth=2
set softtabstop=2
set tabstop=4
set nobackup 
set autochdir 
filetype plugin indent on 
set backupcopy=yes 
set ignorecase smartcase 
set incsearch 
set hlsearch 
set noerrorbells 
set novisualbell 
set t_vb= 
set showmatch 
set matchtime=2 
set magic 
set hidden 
set smartindent 
set backspace=indent,eol,start 
set cmdheight=1 
set laststatus=2 
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%) 
set foldenable 
"set foldmethod=syntax 
set foldcolumn=0 
setlocal foldlevel=1 
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> 
