" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

func! CompileRun()
	if expand('%:t') != ''
		exec "w"
	endif
	if &filetype == 'c'
		exec "!gcc % -o %< && ./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %< && ./%<"
	elseif &filetype == 'python'
		exec "!python %"
	elseif &filetype == 'make'
		exec "!make"
	elseif &filetype == 'html'
		exec "!google-chrome-stable %"
	elseif &filetype == 'sh'
		exec "!bash %"
	endif
endfunc

map <F2> :! file=%;if [ "${file\#\#*.}" == "tex" ];then xelatex $file && evince ${file/\%.tex/.pdf} &> /dev/null; fi <CR> <CR>
map <F5> :call CompileRun() <CR>

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
