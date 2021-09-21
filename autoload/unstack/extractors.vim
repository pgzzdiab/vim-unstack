"unstack#extractors#Regex(regex, file_replacement, line_replacement) constructs {{{
"an extractor that uses regexes
function! unstack#extractors#Regex(regex, file_replacement, line_replacement, ...)
  let extractor = {"regex": a:regex, "file_replacement": a:file_replacement,
        \ "line_replacement": a:line_replacement, "reverse": (a:0 > 0) ? a:1 : 0}
  function extractor.extract(text) dict
    let stack = []
    " echo a:text
    " echo '----------------------'
    " echo '----------------------'
    " let lst = []
    " let lineno = substitute(a:text, self.regex, self.line_replacement, '\=add(lst, submatch(0))', 'g')
    " echo lst
    " echo lineno
    let fname_bef = ''
    let lineno_bef = ''
    for line in split(a:text, "\n")
      let fname = substitute(line, self.regex, self.file_replacement, '')
      let crt_line = substitute(line, '(?!  File)^\s+(\w+)\n', '\1', '')
      if (fname != line)
        let lineno = substitute(line, self.regex, self.line_replacement, '')
        let fname_bef = fname
        let lineno_bef = lineno
      else
        call add(stack, [fname_bef, lineno_bef, crt_line])
      endif
    endfor
    if self.reverse
      call reverse(stack)
    endif
    return stack
  endfunction

  return extractor
endfunction
"}}}

function! unstack#extractors#GetDefaults()
  let extractors = []
  call add(extractors, unstack#extractors#Regex('\v^ *File "([^"]+)", line ([0-9]+).*', '\1', '\2'))
  return extractors
endfunction

" vim: et sw=2 sts=2 foldmethod=marker foldmarker={{{,}}}
