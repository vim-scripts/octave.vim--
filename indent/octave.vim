" Matlab indent file
" Language:     Matlab
" Maintainer:   Christophe Poucet <christophe.poucet@pandora.be>
" Last Change:  14 May, 2014
"
" add some Octave stuff:        19 April 2009 <alain.baeckeroot@laposte.net>

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" Some preliminary setting
setlocal indentkeys=!,o,O=end,=case,=else,=elseif,=otherwise,=catch,=endfor,=endwhile,=until,=endfunction,=endswitch


setlocal indentexpr=GetOctaveIndent(v:lnum)

" Only define the function once.
if exists("*GetOctaveIndent")
  finish
endif

function GetOctaveIndent(lnum)
  " Give up if this line is explicitly joined.
  if getline(a:lnum - 1) =~ '\\$'
    return -1
  endif

  " Search backwards for the first non-empty line.
  let plnum = a:lnum - 1
  while plnum > 0 && getline(plnum) =~ '^\s*$'
    let plnum = plnum - 1
  endwhile

  if plnum == 0
    " This is the first non-empty line, use zero indent.
    return 0
  endif

  let curind = indent(plnum)

  " If the current line is a stop-block statement...
  if getline(v:lnum) =~ '^\s*\(end\|endfor\|endwhile\|endswitch\|endif\|until\|endfunction\|else\|elseif\|case\|otherwise\|catch\)\>'
    " See if this line does not follow the line right after an openblock
    if getline(plnum) =~ '^\s*\(function\|for\|do\|while\|if\|else\|elseif\|case\|switch\|try\|otherwise\|catch\)\>'
      " See if the user has already dedented
    elseif indent(v:lnum) > curind - &sw
      " If not, recommend one dedent
      let curind = curind - &sw
    else
      " Otherwise, trust the user
      return -1
    endif
    "  endif

    " If the previous line opened a block
  elseif getline(plnum) =~ '^\s*\(function\|for\|do\|if\|else\|elseif\|case\|while\|switch\|try\|otherwise\|catch\)\>'
    " See if the user has already indented
    if indent(v:lnum) < curind + &sw
      "If not, recommend indent
      let curind = curind + &sw
    else
      " Otherwise, trust the user
      return -1
    endif
  endif



  " If we got to here, it means that the user takes the standardversion, so we return it
  return curind
endfunction
