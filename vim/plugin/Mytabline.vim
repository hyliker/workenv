"===============================================================================
" Custom tab line
"===============================================================================
function! MyTabLabel(n)

  let label   =  ''

  let label  .=  '['                             

  let label  .=  a:n                             " set tab page number

  let buflist = tabpagebuflist(a:n)
  
  for bufnr in buflist
    if getbufvar(bufnr, '&modified')             " unsaved modified buffer?
      let label .= '*'
      break
    endif
  endfor
  
  let wincount = tabpagewinnr(a:n, '$')          " number of windows in tab
  if wincount > '1'
    let label .= ', ' . wincount                  " report how many windows
  endif

  let label  .=  '] '                            " close bracket

  let winnr    = tabpagewinnr(a:n)               " focused window number
  let fullname = bufname(buflist[winnr - 1])     " absolute file name
  let filename = fnamemodify(fullname, ':t')     " basename

  if filename == ''                              " empty buffers have No Name
    let filename = '[No Name]'
  endif

  let label   .= filename                        " add filename to label

  return label

endfunction

function! MyTabLine()

  let s = ''

  for i in range(tabpagenr('$'))                 " for each open tab..

    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'                   " make active tab stand out 
    else
      let s .= '%#TabLine#'                      
    endif

    let s .= '%{MyTabLabel(' . (i + 1) . ')}'    " add tab label 

    let s .= '%#TabLine#'                        " reset highlight

    if i + 1 != tabpagenr('$')
      let s .= ' ◆ '                             " fancy tab separator
    else
      let s .= '   '                             " except for the last tab
    endif

  endfor

  let s .= '%#TabLineFill#%T'                    " :help statusline

  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'                " right align the final 'X'
  endif

  return s

endfunction

:set tabline=%!MyTabLine()
