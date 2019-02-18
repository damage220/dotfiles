function! is#pattern(pattern)
	return search(a:pattern, "nbc", line(".")) > 0
endfunction

function! is#syntax(groups)
	let groups = map(a:groups, {key, val -> hlID(val)})
	let currentSyntaxGroup = synIDtrans(synID(line("."), col(".") - 1, 1))

	return index(groups, currentSyntaxGroup) != -1
endfunction

function! is#filetype(filetypes)
	return index(a:filetypes, &ft) != -1
endfunction

function! is#std(...)
	return is#pattern(a:000[0]) && !is#syntax(["String", "Comment"]) && (len(a:000) == 1 || is#filetype(a:000[1]))
endfunction
