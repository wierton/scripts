" binary_preview.vim
" Auto preview .parquet/.pkl/.h5 like gzip.vim (BufReadCmd)

if exists('g:loaded_binary_preview')
  finish
endif
let g:loaded_binary_preview = 1

" 可配置：Python 可执行文件
if !exists('g:binary_preview_python')
  let g:binary_preview_python = 'python3'
endif

augroup binary_preview
  autocmd!
  autocmd BufReadCmd *.parquet call s:BinaryPreviewRead(expand('<amatch>'))
  autocmd BufReadCmd *.pkl     call s:BinaryPreviewRead(expand('<amatch>'))
  autocmd BufReadCmd *.h5      call s:BinaryPreviewRead(expand('<amatch>'))
augroup END

command! -bar BinaryPreviewRefresh call s:BinaryPreviewRefresh()

function! s:BinaryPreviewRefresh() abort
  if exists('b:binary_preview_path')
    call s:BinaryPreviewRead(b:binary_preview_path)
  else
    echoerr 'BinaryPreview: not a preview buffer'
  endif
endfunction

function! s:BinaryPreviewRead(path) abort
  let l:path = fnamemodify(a:path, ':p')

  " 防呆：python3 是否存在
  if executable(g:binary_preview_python) == 0
    call s:PreviewBufferInit(l:path)
    call setline(1, ['BinaryPreview: python not found: ' . g:binary_preview_python])
    return
  endif

  let l:cmd = s:BuildPythonCmd(l:path)
  let l:out = systemlist(l:cmd)

  call s:PreviewBufferInit(l:path)

  if v:shell_error != 0
    call setline(1, ['BinaryPreview: preview failed (exit=' . v:shell_error . ')', 'cmd: ' . l:cmd, ''] + l:out)
  else
    if empty(l:out)
      call setline(1, ['(no output)'])
    else
      call setline(1, l:out)
    endif
  endif
endfunction

function! s:PreviewBufferInit(path) abort
  " 接管 BufReadCmd 时，当前 buffer 就是目标 buffer，直接改成 scratch 预览即可
  let b:binary_preview_path = a:path

  " 标题：显示原文件名
  execute 'file ' . fnameescape(fnamemodify(a:path, ':t') . ' [preview]')

  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nobuflisted
  setlocal undolevels=-1

  " 清空并写入
  silent! %delete _

  " 只读
  setlocal modifiable
  " 写完再锁
  " （下面 setline 后会再设 nomodifiable）
endfunction

function! s:BuildPythonCmd(path) abort
  " 用 sys.argv[1] 传入文件路径，避免你妈的转义地狱
  " 输出尽量短：head + dtypes + shape
  let l:py = join([
        \ 'import sys, os, traceback',
        \ 'p = sys.argv[1]',
        \ 'ext = os.path.splitext(p)[1].lower()',
        \ 'def ptitle(t): print("="*80); print(t); print("="*80)',
        \ 'def preview_df(df, n=60):',
        \ '  import pandas as pd',
        \ '  with pd.option_context("display.max_rows", n, "display.max_columns", 60, "display.width", 0):',
        \ '    print(df.head(n).to_string())',
        \ '  print(""); print("-- dtypes --"); print(df.dtypes)',
        \ '  print(""); print("-- shape --", df.shape)',
        \ '',
        \ 'try:',
        \ '  import pandas as pd',
        \ '  if ext == ".parquet":',
        \ '    ptitle("PARQUET: " + os.path.basename(p))',
        \ '    df = pd.read_parquet(p)',
        \ '    preview_df(df)',
        \ '  elif ext == ".pkl":',
        \ '    ptitle("PKL: " + os.path.basename(p))',
        \ '    obj = pd.read_pickle(p)',
        \ '    if isinstance(obj, pd.DataFrame):',
        \ '      preview_df(obj)',
        \ '    elif isinstance(obj, pd.Series):',
        \ '      with pd.option_context("display.max_rows", 120, "display.width", 0):',
        \ '        print(obj.head(120).to_string())',
        \ '      print(""); print("-- dtype --", obj.dtype); print("-- shape --", obj.shape)',
        \ '    else:',
        \ '      import pprint; pprint.pprint(obj, width=120, compact=True)',
        \ '  elif ext == ".h5":',
        \ '    ptitle("H5: " + os.path.basename(p))',
        \ '    try:',
        \ '      store = pd.HDFStore(p, "r")',
        \ '      keys = list(store.keys())',
        \ '      print("Keys:")',
        \ '      for k in keys: print("  " + k)',
        \ '      if keys:',
        \ '        k = keys[0]',
        \ '        print(""); ptitle("Preview first key: " + k)',
        \ '        obj = store.get(k)',
        \ '        if isinstance(obj, pd.DataFrame):',
        \ '          preview_df(obj)',
        \ '        elif isinstance(obj, pd.Series):',
        \ '          with pd.option_context("display.max_rows", 120, "display.width", 0):',
        \ '            print(obj.head(120).to_string())',
        \ '          print(""); print("-- dtype --", obj.dtype); print("-- shape --", obj.shape)',
        \ '        else:',
        \ '          print(obj)',
        \ '      store.close()',
        \ '    except Exception as e:',
        \ '      print("HDFStore failed, fallback to h5py:", repr(e))',
        \ '      import h5py',
        \ '      with h5py.File(p, "r") as f:',
        \ '        def show(name, obj):',
        \ '          import h5py as _h5py',
        \ '          if isinstance(obj, _h5py.Dataset):',
        \ '            print(f"{name}  dataset shape={obj.shape} dtype={obj.dtype}")',
        \ '          else:',
        \ '            print(f"{name}/")',
        \ '        f.visititems(show)',
        \ '  else:',
        \ '    print("Unsupported extension:", ext)',
        \ 'except Exception:',
        \ '  traceback.print_exc()'
        \ ], "\n")

  " 拼成：python3 -c "<code>" -- "<path>"
  return g:binary_preview_python
        \ . ' -c ' . shellescape(l:py)
        \ . ' -- ' . shellescape(a:path)
endfunction

" 在预览 buffer 写完内容后锁住（避免误改）
autocmd binary_preview BufReadCmd *.parquet,*.pkl,*.h5 setlocal nomodifiable readonly filetype=markdown

