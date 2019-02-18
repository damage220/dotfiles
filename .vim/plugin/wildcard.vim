function! s:getVisualSelection()
	let [ls, cs] = getpos("'<")[1:2]
	let [le, ce] = getpos("'>")[1:2]
	let lines = getline(ls, le)

	if len(lines) == 0
		return ""
	endif

	let lines[-1] = lines[-1][:ce - (&selection == "inclusive" ? 1 : 2)]
	let lines[0] = lines[0][cs - 1:]

	return join(lines, "\n")
endfunction

function! s:getCurrentWord()
	let column = col(".")
	let line = getline(".")
	let pattern = printf('\k\+\%%%ic', column + 1)
	let isKeyword = search(pattern, "nbc", line(".")) != 0

	return isKeyword ? printf('\<\C%s\>', expand("<cword>")) : line == "" ? "" : s:getEscapedString(line[column - 1])
endfunction

function! s:getEscapedString(string)
	let string = substitute(a:string, '\(\\\|/\)', '\\\1', "g")
	let string = substitute(string, '\n', '\\n', "g")

	return '\V' . string
endfunction

nnoremap <silent>* :let @/ = <SID>getCurrentWord()<CR>:set hlsearch<CR>
vnoremap <silent>* <Esc>:let @/ = <SID>getEscapedString(<SID>getVisualSelection())<CR>:set hlsearch<CR>
