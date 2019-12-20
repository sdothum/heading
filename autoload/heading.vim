" sdothum - 2016 (c) wtfpl

" Heading
" ══════════════════════════════════════════════════════════════════════════════

function! s:nonBlankLine()
  return !empty(matchstr(getline(line('.')), '\S'))
endfunction

" Heading styles _______________________________________________________________

" .................................................................... Underline
" example: draw underline
" ───────────────────────
function! heading#Underline(delimiter)
  if s:nonBlankLine() | execute 'normal! yypwv$r' . a:delimiter | endif
  normal! $
endfunction

" ........................................................................ Ruler
" example: draw ruler
" ──────────────────────────────────────────────────────────────────────────────
function! heading#Drawline(delimiter)
  call heading#Underline(a:delimiter)
  if virtcol('.') < &textwidth  " for mirrored left/right margin spacing
    let l:col = &textwidth - virtcol('.')
    execute 'normal! ' . l:col . 'a' . a:delimiter
  endif
  normal! $
endfunction

" Sub-heading styles ___________________________________________________________

" ...................................................................... Trailer
" example: append trailer ______________________________________________________
function! heading#AppendTrailer(delimiter)
  if !s:nonBlankLine() | return | endif
  if !empty(matchstr(getline(line('.')), '\s[' . a:delimiter . ']\+$'))  " remove existing trailer
    normal! $bhD
  endif
  normal! $
  let l:col = &textwidth - virtcol('.') - 1
  if l:col > 0
    set formatoptions-=c  " suppress potential comment line wrapping
    execute 'normal! a '
    execute 'normal! ' . l:col . 'a' . a:delimiter
    set formatoptions+=c
  endif
  normal! $
endfunction

" prompted trailer
function! heading#InputTrailer()
  let l:delimiter = input('Line character: ')
  if !empty(l:delimiter) | call heading#AppendTrailer(l:delimiter[0]) | endif
endfunction

" ....................................................................... Leader
" ....................................................... example: insert leader
function! heading#InsertLeader(delimiter)
  if !s:nonBlankLine() | return | endif
  if !empty(matchstr(getline(line('.')), '\S\s\+[' . a:delimiter . ']\+\s')) | execute 'normal! ^wdf ' | endif  " remove existing leader
  call heading#AppendTrailer(a:delimiter)
  " cut trailer and insert as leader!
  normal! $bhD^whP
  normal! $
endfunction

" prompted leader
function! heading#InputLeader()
  let l:delimiter = input('Line character: ')
  if !empty(l:delimiter)
    if l:delimiter == ' ' | call heading#Justify()
    else                  | call heading#InsertLeader(l:delimiter[0])
    endif
  endif
endfunction

" ...................................................................... Justify
"                                                               example: justify
function! heading#Justify()
  execute 's/\v^([ \t]*[^ \t]*)[ \t]*/\1 /'
  call heading#InsertLeader('▔')
  execute ':s/▔/ /'
  normal! $
endfunction

" heading.vim
