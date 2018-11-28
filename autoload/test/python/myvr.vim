if !exists('g:test#python#myvr#file_pattern')
  let g:test#python#myvr#file_pattern = '\v^tests.*\.py$'
endif

function! test#python#myvr#test_file(file) abort
  return match(expand("%"), "/tests/") != -1
endfunction

function! test#python#myvr#build_position(type, position) abort
  let path = s:get_import_path(a:position['file'])
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ["test_app:" . path . s:separator() . name]
    else
      return ["test_app:" . path]
    endif
  elseif a:type ==# 'file'
    return ["test_app:" . path]
  else
    return []
  endif
endfunction

function! test#python#myvr#build_args(args) abort
  return a:args
endfunction

function! test#python#myvr#executable() abort
  return 'fab'
endfunction

function! s:get_import_path(filepath) abort
  " Get path to file from cwd and without extension.
  let path = fnamemodify(a:filepath, ':.:r')
  let path = substitute(path, 'src.vr.apps.', '', 'g')
  let path = substitute(path, '.tests.*', '', 'g')
  " Replace the /'s in the file path with .'s
  let path = substitute(path, '\/', '.', 'g')
  let path = substitute(path, '\\', '.', 'g')
  return path
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction

function! s:separator() abort
  return '.'
endfunction
