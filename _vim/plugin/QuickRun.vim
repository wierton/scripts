"""""""""""""""""""""""""""
" Quickly run source code "
"""""""""""""""""""""""""""

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
