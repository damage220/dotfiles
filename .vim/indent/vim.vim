function! GetVimIndent()
	let nextNonBlankLineNumber = nextnonblank(v:lnum + 1)

	" use zero indent at the end of the buffer
	if nextNonBlankLineNumber == 0
		return 0
	endif

	let nextNonBlankLine = getline(nextNonBlankLineNumber)
	let indent = indent(nextNonBlankLineNumber)

	if nextNonBlankLine =~ '^\s*\(endf\%[unction]\|el\%[seif]\|en\%[dif]\|endw\%[hile]\|endfo\%[r]\|cat\%[ch]\|fina\%[lly]\|endt\%[ry]\)'
		let indent += &shiftwidth
	endif

	return indent
endfunction

setlocal indentexpr=GetVimIndent()
