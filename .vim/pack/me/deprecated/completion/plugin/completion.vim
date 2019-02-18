let s:MAX_WORD_LENGTH = 20

function! completion#getEntries(findstart, base)
	if(a:findstart)
		return s:getKeywordPosition() - 1
	endif

	" return ["123"]

	" let entries = []
	" let entry = {}
	" let entry.word = a:base
	" let entry.menu = "1"

	" let entry.kind = "word"
	" let entry.info = "Description goes here."
	" call add(entries, entry)
	" let entries = completion#filter(completion#getKeywords(a:base), a:base)
	let entries = completion#buffer#getEntries()

	call sort(entries, funcref("s:comparator"))

	" return entries
	return {"words": entries, "refresh": "always"}
endfunction

function! s:getKeywordPosition()
	let position = searchpos('\k\+\%#\|\%#', 'nbc')
	" let position = searchpos('\k\+\%#', 'nbc')

	return position[1]
endfunction

function! s:comparator(a, b)
	return len(a:a.word) - len(a:b.word)
endfunction

function! s:getFixedWidthEntry(entry, width)
	let difference = a:width - len(a:entry.word)

	if(difference < 0)
		let a:entry.abbr = strpart(a:entry.word, 0, s:MAX_WORD_LENGTH - 1) . "…"
	else
		let a:entry.abbr = a:entry.word . repeat(" ", difference)
	endif

	" let a:entry.abbr .= " " . a:entry.kind
	" unlet a:entry.kind
	" if len(entry.word) > s:MAX_WORD_LENGTH
		" let entry.abbr = strpart(entry.word, s:MAX_WORD_LENGTH) . "…"
	" endif

	return a:entry
endfunction

" function! completion#filter(entries, base)
	" let filteredEntries = []
	" let baseLength = len(a:base)

	" " echo a:entries
	" " return

	" for entry in a:entries
		" let entryTail = strpart(entry.word, 0, baseLength)

		" if entryTail ==# a:base
			" call add(filteredEntries, s:getFixedWidthEntry(entry, s:MAX_WORD_LENGTH))
		" endif
	" endfor

	" return filteredEntries
" endfunction

" TODO Replace non-word with non-keyword
" function! completion#getKeywords(base)
	" let keywords = []
	" let currentLine = line(".")

	" for line in range(1, line("$"))
		" " let matches = split(getline(line), '\W\+')
		" let matches = s:getStringMatches(getline(line), '\k\{2,}', 2)

		" if line == currentLine
			" let i = index(matches, a:base)

			" if i != -1
				" call remove(matches, i)
			" endif
		" endif

		" call extend(keywords, matches)
	" endfor

	" let keywords = uniq(keywords)
	" let entries = []

	" for keyword in keywords
		" let entry = {}
		" let entry.word = keyword
		" " let entry.kind = "[k]"
		" let entry.kind = "k"

		" call add(entries, entry)
	" endfor

	" return entries
" endfunction

function! completion#filter(base, lastIndex, i, word)
	" echo printf("base: %s, index: %i, word: %s, result: %i", a:base, a:i, a:word, stridx(a:word, a:base) != -1)
	" sleep 1
	return a:word[0:a:lastIndex] ==# a:base
	" return a:word[1] != "" && stridx(a:word, a:base) == 0
	" return a:word =~# a:base
	" return strridx(a:word, a:base, 0) == 0
endfunction

function! completion#getKeywords(base)
	let words = split(join(getline(1, "$"), "\n"), '\W\+')
	let basePosition = index(words, a:base)
	let isNeedDeleteBase = basePosition && index(words, a:base, basePosition + 1) == -1

	if isNeedDeleteBase
		call remove(words, basePosition)
	endif

	" let words = []
	" silent execute printf(':keeppatterns %%s/\C%s\w\+/\=add(words, submatch(0))/gn', a:base)
	" let basePosition = index(words, a:base)
	" let isNeedDeleteBase = basePosition && index(words, a:base, basePosition + 1) == -1

	" call uniq(words)
	call filter(words, funcref("completion#filter", [a:base, len(a:base) - 1]))

	" call filter(words, 'len(v:val) > 1')
	" call filter(words, 'v:val[1] != ""')
	" let g:basePosition = basePosition
	" let g:isNeedDeleteBase = isNeedDeleteBase

	" for word in words
	" endfor

	return words
	" let entries = []

	" for word in words
		" let entry = {}
		" let entry.word = word
		" " let entry.kind = "[k]"
		" let entry.kind = "k"

		" call add(entries, entry)
	" endfor

	" return entries
endfunction

function! completion#getEntries(base)
	" let words = []
	" let multi = max([2 - len(a:base), 0])
	" silent execute printf(':keeppatterns %%s/\C\(^\|\W\)\zs%s\w\{%i,}/\=add(words, submatch(0))/gn', a:base, multi)
	" silent execute printf('keeppatterns %%s/\C%s\w\{%i,}/\=add(words, submatch(0))/gn', a:base, multi)
	execute "let words = [] | execute 'keeppatterns %s/l\\w\\{1,}/\=add(words, submatch(0))/gn'"
endfunction

" autocmd CompleteDone * echo v:completed_item

" ¶ automate trigger completion

" function! s:getStringMatches(line, pattern, offsetType)
	" let matches = []
	" let offset = 0

	" while(1)
		" let match = matchstrpos(a:line, a:pattern, offset)

		" if(match[1] == -1)
			" return matches
		" endif

		" call add(matches, match[0])

		" let offset = match[a:offsetType] + 1
	" endwhile
" endfunction

function! OpenCompletion()
	" if(!pumvisible() && mode() == 'i' && &filetype != "slash" && ((v:char >= 'a' && v:char <= 'z') || (v:char >= 'A' && v:char <= 'Z')))
	" echo printf("1: %i, 2: %i", s:getKeywordPosition(), col("."))
	
	" if !pumvisible() && s:getKeywordPosition() != col(".")
	if !pumvisible() && ((v:char >= 'a' && v:char <= 'z') || (v:char >= 'A' && v:char <= 'Z'))
		call feedkeys("\<C-x>\<C-O>", "n")
		" call feedkeys("\<C-x>\<C-u>", "n")
		" call feedkeys("\<Tab>")
		" call feedkeys("\<C-n>", "n")
		let g:counter += 1
	endif
endfunction

set completefunc=completion#getEntries
" set noshowmode

" autocmd InsertCharPre * call OpenCompletion()
autocmd CompleteDone * pclose
