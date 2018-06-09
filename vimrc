""""""""""""""""""""""""""""""""
" wierton's vim configure file "
""""""""""""""""""""""""""""""""

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
nnoremap <C-l> :exec "!yd ".substitute(expand("<cword>"), "\n", " ", "g") <CR>
vnoremap <C-l> y:exec "!yd ".substitute(getreg("0"), "\n", " ", "g") <CR>
nnoremap <C-k> <Esc>gg!Gclang-format<CR>gg=G:%s/\(if\\|while\\|for\) (/\1(/g<CR>

noremap + <C-w>+
noremap - <C-w>-


" autoreload:
" https://github.com/djoshea/vim-autoread/blob/master/plugin/autoread.vim
command! -bang WatchForChanges                  :call WatchForChanges(@%,  {'toggle': 1, 'autoread': <bang>0})
command! -bang WatchForChangesWhileInThisBuffer :call WatchForChanges(@%,  {'toggle': 1, 'autoread': <bang>0, 'while_in_this_buffer_only': 1})
command! -bang WatchForChangesAllFile           :call WatchForChanges('*', {'toggle': 1, 'autoread': <bang>0})

function! WatchForChanges(bufname, ...)
  if a:bufname == '*'
    let id = 'WatchForChanges'.'AnyBuffer'
    let bufspec = ''
  else
    if bufnr(a:bufname) == -1
      echoerr "Buffer " . a:bufname . " doesn't exist"
      return
    end
    let id = 'WatchForChanges'.bufnr(a:bufname)
    let bufspec = a:bufname
  end

  if len(a:000) == 0
    let options = {}
  else
    if type(a:1) == type({})
      let options = a:1
    else
      echoerr "Argument must be a Dict"
    end
  end
  let autoread    = has_key(options, 'autoread')    ? options['autoread']    : 0
  let toggle      = has_key(options, 'toggle')      ? options['toggle']      : 0
  let disable     = has_key(options, 'disable')     ? options['disable']     : 0
  let more_events = has_key(options, 'more_events') ? options['more_events'] : 1
  let while_in_this_buffer_only = has_key(options, 'while_in_this_buffer_only') ? options['while_in_this_buffer_only'] : 0

  if while_in_this_buffer_only
    let event_bufspec = a:bufname
  else
    let event_bufspec = '*'
  end

  let reg_saved = @"
  "let autoread_saved = &autoread
  let msg = "\n"

  " Check to see if the autocommand already exists
  redir @"
    silent! exec 'au '.id
  redir END
  let l:defined = (@" !~ 'E216: No such group or event:')

  " If not yet defined...
  if !l:defined
    if l:autoread
      let msg = msg . 'Autoread enabled - '
      if a:bufname == '*'
        set autoread
      else
        setlocal autoread
      end
    end
    silent! exec 'augroup '.id
      if a:bufname != '*'
        "exec "au BufDelete    ".a:bufname . " :silent! au! ".id . " | silent! augroup! ".id
        "exec "au BufDelete    ".a:bufname . " :echomsg 'Removing autocommands for ".id."' | au! ".id . " | augroup! ".id
        exec "au BufDelete    ".a:bufname . " execute 'au! ".id."' | execute 'augroup! ".id."'"
      end
        exec "au BufEnter     ".event_bufspec . " :silent! checktime ".bufspec
        exec "au CursorHold   ".event_bufspec . " :silent! checktime ".bufspec
        exec "au CursorHoldI  ".event_bufspec . " :silent! checktime ".bufspec

      " The following events might slow things down so we provide a way to disable them...
      " vim docs warn:
      "   Careful: Don't do anything that the user does
      "   not expect or that is slow.
      if more_events
        exec "au CursorMoved  ".event_bufspec . " :silent! checktime ".bufspec
        exec "au CursorMovedI ".event_bufspec . " :silent! checktime ".bufspec
      end
    augroup END
    let msg = msg . 'Now watching ' . bufspec . ' for external updates...'
  end

  " If they want to disable it, or it is defined and they want to toggle it,
  if l:disable || (l:toggle && l:defined)
    if l:autoread
      let msg = msg . 'Autoread disabled - '
      if a:bufname == '*'
        set noautoread
      else
        setlocal noautoread
      end
    end
    " Using an autogroup allows us to remove it easily with the following
    " command. If we do not use an autogroup, we cannot remove this
    " single :checktime command
    " augroup! checkforupdates
    silent! exec 'au! '.id
    silent! exec 'augroup! '.id
    let msg = msg . 'No longer watching ' . bufspec . ' for external updates.'
  elseif l:defined
    let msg = msg . 'Already watching ' . bufspec . ' for external updates'
  end

  "echo msg
  let @"=reg_saved
endfunction

autocmd VimEnter * WatchForChangesAllFile! 


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
"set foldmethod=syntax 
set foldcolumn=0 
setlocal foldlevel=1 
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> 
