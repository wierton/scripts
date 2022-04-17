""""""""""""""""""""""""""""""""
" wierton's vim configure file "
""""""""""""""""""""""""""""""""

" nnoremap <C-l> :exec "!yd ".substitute(expand("<cword>"), "\n", " ", "g") <CR>
" vnoremap <C-l> y:exec "!yd ".substitute(getreg("0"), "\n", " ", "g") <CR>
nnoremap <C-k> <Esc>:%!clang-format<CR><C-o>

noremap + <C-w>+
noremap - <C-w>-

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
set tabstop=2
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
