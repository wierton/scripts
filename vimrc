setlocal noswapfile 
set bufhidden=hide 
set nocompatible 
syntax on 
"colorscheme evening 
set number 
set cursorline 
set ruler 
set shiftwidth=4 
set softtabstop=4 
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
set foldmethod=syntax 
set foldcolumn=0 
setlocal foldlevel=1 
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> 
