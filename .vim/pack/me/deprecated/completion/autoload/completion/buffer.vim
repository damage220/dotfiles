let s:GREP_TEMPLATE = 'grep -o "\w\{%i,\}" %s | sort -u | grep "^%s"'
" let s:GREP_TEMPLATE = 'grep -o "\w\{%i,\}" | sort -u | grep "^%s"'
let s:WORD_MIN_LENGTH = 2

function! completion#buffer#getEntries(base)
	let file = expand("%:p")

	if file == ""
		return []
	endif

	let command = printf(s:GREP_TEMPLATE, s:WORD_MIN_LENGTH, shellescape(file), a:base)
	" execute "!" . command
	let entries = systemlist(command)
	call map(entries, funcref("s:mapper"))

	" let command = printf(s:GREP_TEMPLATE, s:WORD_MIN_LENGTH, a:base)
	" let command = 'grep -o "\w\{2,\}" | sort -u'
	" let command = 'grep -o a'
	" let entries = systemlist(command, getline(1, "$"))
	" return command

	return entries
endfunction

function! s:mapper(key, value)
	return {"word": value, "kind": "k"}
endfunction

" function! completion#buffer#getEntries(base)
	" let words = []
	" let multi = max([s:WORD_MIN_LENGTH - len(a:base), 0])
	" let command = printf('keeppatterns %%s/\C\(^\|\W\)\zs%s\w\{%i,}/\=add(words, submatch(0))/gn', a:base, multi)
	" " let command = printf('let words = [] | keeppatterns %%s/\C%s\w\{%i,}/\=add(words, submatch(0))/gne | echo words', a:base, multi)
	" " let command = printf('let words = [] | keeppatterns %%s/\C%s\w\{%i,}/\=completion#buffer#echo(submatch(0))/gne', a:base, multi)
	" execute command
	" echo command
	" " echo printf(':keeppatterns %%s/\C\(^\|\W\)\@<=%s\w\{%i,}/\=add(words, submatch(0))/gn', a:base, multi)
	" let basePosition = index(words, a:base)
	" let isNeedDeleteBase = basePosition && index(words, a:base, basePosition + 1) == -1

	" if isNeedDeleteBase
		" call remove(words, basePosition)
	" endif

	" " echo words

	" " for word in words
		" " echo printf("word is: '%s'", word)
	" " endfor

	" " call uniq(words)

	" " return g:words
" endfunction

" function! completion#buffer#echo(message)
	" " echo a:message
" endfunction
