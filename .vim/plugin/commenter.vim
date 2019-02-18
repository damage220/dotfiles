function! commenter#toggle() range
	if !exists("&commentstring") || &commentstring == ""
		echo "No &commentstring set."

		return
	endif

	let escapedCommentString = substitute(&commentstring, '\([^%s]\)', '[\1]', "g")
	let lines = range(a:firstline, a:lastline)

	if s:isEmptyLines(lines)
		for i in lines
			call s:commentLine(i, &commentstring)
		endfor
	elseif s:isCommentedLines(lines, escapedCommentString)
		for i in lines
			call s:uncommentLine(i, escapedCommentString)
		endfor
	else
		for i in lines
			if getline(i) != ""
				call s:commentLine(i, &commentstring)
			endif
		endfor
	endif
endfunction

function! s:commentLine(line, commentString)
	let line = getline(a:line)
	let pattern = '\1' . printf(a:commentString, '\2')
	let commentedLine = substitute(line, '^\(\s*\)\(.*\)$', pattern, "")

	call setline(a:line, commentedLine)
endfunction

function! s:uncommentLine(line, commentString)
	let line = getline(a:line)
	let pattern = '^\(\s*\)' . printf(a:commentString, '\(.*\)') . '\(\s*\)$'
	let unCommentedLine = substitute(line, pattern, '\1\2\3', "")

	call setline(a:line, unCommentedLine)
endfunction

function! s:isEmptyLines(lines)
	for i in a:lines
		if getline(i) != ""
			return 0
		endif
	endfor

	return 1
endfunction

function! s:isCommentedLines(lines, commentString)
	for i in a:lines
		let line = getline(i)
		let pattern = '^\s*' . printf(a:commentString, ".*") . '\s*$'

		if line != "" && match(line, pattern) == -1
			return 0
		endif
	endfor

	return 1
endfunction

" defaults
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType php setlocal commentstring=//\ %s
autocmd FileType c,cpp setlocal commentstring=//\ %s
autocmd FileType lua setlocal commentstring=--\ %s
autocmd FileType css setlocal commentstring=/*\ %s\ */
autocmd FileType sh setlocal commentstring=#\ %s
autocmd FileType crontab setlocal commentstring=#\ %s
