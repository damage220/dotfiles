" TODO
" Replace matchedItems with entries
" Replace raw with line
" Reduce amount of b: variables
" Reduce amount of slash# prefixes. Use s: instead.
" Increase speed of slash#files bootstrap
" ! Limit resizing window to half of screen size
" - Prevent cursor flashing when running slash in splitted window
" - type "s" or "f" in slash#tags for slash.vim
" - scroll bug (type foo in slash#files)
let s:NAME = "Precise Finder"
let s:BUFFER_NAME = "slash"
let s:ALLOWED_OPEN_BUFFER_COMMANDS = ["enew", "new", "vnew", "tabe"]
let s:LIMIT = 10
let s:TAG_LINE_END = "#slashendline"
let s:SYNTAX_MATCH_REGION = '^.\+'
let s:DEFAULT_GLOBAL_OPTIONS = {}
let s:NO_MATCHED_ITEMS_MESSAGE = "No matches were found."
let s:GLOBAL_OPTIONS = {
	\ "showmode": 0,
	\ "rulerformat": "%0(%)",
	\ "laststatus": 0,
	\ "updatetime": 999999999,
	\ "number": 0,
	\ "relativenumber": 0,
	\ "hlsearch": 0,
\ }

function! slash#files(...)
	call call("slash#files#index", a:000)
endfunction

function! slash#tags(...)
	call call("slash#tags#index", a:000)
endfunction

function! slash#lines(...)
	call call("slash#lines#index", a:000)
endfunction

function! slash#matches(...)
	call call("slash#matches#index", a:000)
endfunction

function! slash#commands(...)
	call call("slash#commands#index", a:000)
endfunction

function! slash#splitted(...)
	call call("slash#splitted#index", a:000)
endfunction

function! slash#openWindow(items, options)
	if(len(a:items) == 0)
		return slash#error("Nothing to match.")
	endif

	let openBufferCommand = get(a:options, "openBufferCommand", "new")
	let bufferName = get(a:options, "bufferName", s:BUFFER_NAME)
	let allowedOpenBufferCommands = get(a:options, "allowedOpenBufferCommands", s:ALLOWED_OPEN_BUFFER_COMMANDS)
	" let newWindowCommand = get(a:options, "newWindowCommand", 10)
	let previousWindow = winnr()
	let initialView = winsaveview()
	let updateView = winsaveview()
	let limit = get(a:options, "limit", min([s:LIMIT, len(a:items)]))
	let preventScrolling = get(a:options, "preventScrolling", 1)

	" check whether open window command is allowed
	if(index(allowedOpenBufferCommands, openBufferCommand) == -1)
		return slash#error(printf("Not allowed command. Allowed: %s", allowedOpenBufferCommands))
	endif

	" set global options
	for [option, value] in items(s:GLOBAL_OPTIONS)
		let s:DEFAULT_GLOBAL_OPTIONS[option] = getbufvar("%", "&" . option)

		call setbufvar("%", "&" . option, value)
	endfor

	" increase avaiable space if needed to prevent main window from scrolling
	let availableSpace = winheight(0) - winline()
	" echo availableSpace
	" echo limit
	" return

	if(openBufferCommand == "new" && preventScrolling && &splitbelow && availableSpace < limit)
		call winrestview({"topline": initialView.topline + limit - availableSpace})

		let updateView = winsaveview()
	endif

	" slash note: cause blink when open window
	" need redraw to clear ruler
	" redraw

	" open new window
	execute openBufferCommand

	" resize 10
	" return

	" post buffer commands
	execute printf("silent file %s", bufferName)
	mapclear <buffer>

	" set local options
	setlocal filetype=slash
	setlocal buftype=nofile
	" setlocal nocursorline
	setlocal conceallevel=3
	setlocal concealcursor=nvic
	setlocal nowrap
	" setlocal statusline=\ 

	" set buffer variables
	let b:initialView = initialView
	let b:updateView = updateView
	let b:previousWindow = previousWindow
	let b:currentWindow = winnr()
	let b:currentBuffer = bufnr("%")
	let b:openBufferCommand = openBufferCommand
	let b:updateRate = get(a:options, "updateRate", 10)
	let b:queue = []
	let b:items = slash#getCompleteItems(a:items)
	let b:itemsAmount = len(b:items)
	" let b:raw = exists("options.raw") ? options.raw : slash#getRaw(b:items)
	let b:prompt = get(a:options, "prompt", "/")
	let b:pattern = get(a:options, "pattern", "")
	let b:previousPattern = b:pattern
	let b:handler = get(a:options, "handler", function("slash#handler"))
	let b:limit = limit
	let b:finder = get(a:options, "finder", function("slash#getMatchesNatively"))
	let b:comparator = get(a:options, "comparator", v:null)
	let b:noMatchedItemsMessage = get(a:options, "noMatchedItemsMessage", s:NO_MATCHED_ITEMS_MESSAGE)
	let b:enterIsPressed = 0
	let b:useGrep = get(a:options, "useGrep", 0)
	let b:patternHandler = get(a:options, "patternHandler", function("slash#patternHandler"))

	if(b:useGrep)
		let b:rawFile = tempname()
		let b:finder = function("slash#getMatchesUsingGrep")
		let b:grepCommand = printf("grep -nEi -m %i %%s %%s", b:limit)

		call writefile(slash#getRaw(b:items), b:rawFile)
		" let b:grepCommand .= " " . b:rawFile
	endif

	call slash#setSyntaxMatchRegion(get(a:options, "syntaxMatchRegion", s:SYNTAX_MATCH_REGION))
	call slash#defineMappings()
	call slash#defineSyntax()

	" insert items
	call slash#update(b:pattern)
endfunction

function! slash#startTyping()
	" return
	" prepare timer for buffer updates & nagivation
	let FN = funcref("slash#checkForUpdates", [bufnr("%")])
	let timer = timer_start(b:updateRate, FN, {"repeat": -1})

	" start typing
	echohl slashPrompt
	silent! let pattern = input(b:prompt, b:pattern)
	echohl None

	" clear input value
	" echo 123
	redraw
	echo

	" restore global variables
	for [option, value] in items(s:DEFAULT_GLOBAL_OPTIONS)
		call setbufvar("%", "&" . option, value)
	endfor

	if(b:enterIsPressed)
		" call user handler
		call call(b:handler, [slash#getSelectedItem()])
	else
		" slash was terminated with <Esc> key
		call slash#exciteUserEvent("SlashCancelled")
		call slash#closeWindow()
	endif

	" remove all event listeners
	autocmd! User

	" remove temp file used for grepping if exist
	if(exists("b:rawFile") && filereadable(b:rawFile))
		call delete(b:rawFile)
	endif

	" call slash#restoreDefaults()

	call timer_stop(timer)
endfunction

function! slash#closeWindow()
	let initialView = b:initialView

	execute "bdelete " . b:currentBuffer

	" restore initial window view
	call winrestview(initialView)
endfunction

" function! slash#restoreDefaults()
" endfunction

function! slash#setSyntaxMatchRegion(region)
	let b:syntaxMatchRegion = printf('\c%s%s.*$\&.\{-}%%s%s', a:region, s:TAG_LINE_END, s:TAG_LINE_END)
endfunction

function! slash#checkForUpdates(bufferId, timer)
	" call setline(1, "foo")
	" exit when cursor is not in the slash buffer
	if(bufnr("%") != a:bufferId)
		return
	endif
	" call setline(1, a:bufferId)
	" call setline(2, type(a:timer))
	" redraw
	" execute all commands in queue
	if(len(b:queue) != 0)
		for command in b:queue
			execute command
			" call setline(1, command)
			" if(type(item) == v:t_func)
				" call call(item)
			" endif

			" if(type(item) == v:t_string)
				" execute item
			" endif
		endfor

		let b:queue = []

		redraw
	endif

	" update matches if needed
	let pattern = slash#getPattern()

	if(b:previousPattern == pattern)
		return
	endif

	let b:previousPattern = pattern
	" redraw!

	call slash#update(pattern)
endfunction

function! slash#getPattern()
	return getcmdline()
endfunction

function! slash#patternHandler(pattern)
	return a:pattern
endfunction

function! slash#update(pattern)
	" return
	let patternHandled = call(b:patternHandler, [a:pattern])
	let b:matches = call(b:finder, [b:items, patternHandled])
	let b:matchesAmount = len(b:matches)

	if(type(b:comparator) == v:t_func)
		call sort(b:matches, b:comparator)
	endif

	if(b:openBufferCommand == "new")
		execute "resize " . b:matchesAmount
		execute printf("%iwindo call winrestview(%s) | %iwincmd w", b:previousWindow, b:updateView, b:currentWindow)
	endif

	" clean the whole buffer and place deleted lines into non-default register
	%delete _

	" wincmd w
	" call winrestview(b:initialView)
	" wincmd w
	" return

	" let i = b:matchesAmount
	" echo b:matches

	if(b:matchesAmount == 0)
		call setline(1, b:noMatchedItemsMessage)
	else
		let b:matches = reverse(b:matches)
		let i = 1

		for item in b:matches
			call setline(i, item.bufferLine)

			let i += 1
		endfor

		normal G
		call slash#exciteUserEvent("SlashItemSelected")
	endif

	" call setline(1, patternHandled)

	" call cursor(line("$"), 0)
	call slash#updateSyntax(a:pattern)

	redraw
endfunction

" function! s:getLine(item)
	" return a:item.visibleLine . s:TAG_LINE_END . a:item.comment
" endfunction

function! slash#defineSyntax()
	" syntax region slashItem start=/\%^/ end=/\%$/ contains=slashSelectedItem,slashItemMatchedPattern,slashItemComment,slashHidden
	syntax match slashItem /^\(\%#\)\@!.*$/ contains=slashItemMatchedPattern,slashItemComment,slashHidden
	execute printf('syntax match slashItemComment /\(%s\)\@<=.*$/ contained', s:TAG_LINE_END)
	syntax match slashSelectedItem /^\%#.*$/ contains=slashSelectedItemMatchedPattern,slashSelectedItemComment,slashHidden
	execute printf('syntax match slashSelectedItemComment /\(%s\)\@<=.*$/ contained', s:TAG_LINE_END)
	execute printf('syntax match slashHidden /%s/ conceal contained', s:TAG_LINE_END)
	execute printf('syntax match slashNoMatchedItems /^%s$/', b:noMatchedItemsMessage)
endfunction

function! slash#defineMappings()
	cnoremap <buffer><expr><Down> slash#queue("call slash#moveCursorDown()")
	cnoremap <buffer><expr><Up> slash#queue("call slash#moveCursorUp()")
	cnoremap <buffer><expr><Tab> slash#queue("call slash#moveCursorDown()")
	cnoremap <buffer><expr><S-Tab> slash#queue("call slash#moveCursorUp()")
	cnoremap <buffer><expr><C-j> slash#queue("call slash#moveCursorDown()")
	cnoremap <buffer><expr><C-k> slash#queue("call slash#moveCursorUp()")
	cnoremap <buffer><expr><CR> slash#getEnterKey()
	cnoremap <buffer><C-a> <Home>
	cnoremap <buffer><C-e> <End>
endfunction

function! slash#queue(command)
	call add(b:queue, a:command)
	" call setline(1, "ok")

	return ""
endfunction

function! slash#getEnterKey()
	" do nothing when there is no matched items
	if(b:matchesAmount == 0)
		return ""
	endif

	let b:enterIsPressed = 1

	return "\<Esc>"
endfunction

function! slash#moveCursorUp()
	call slash#moveCursor(line(".") - 1)
	" call cursor(line(".") - 1, 0)
endfunction

function! slash#moveCursorDown()
	call slash#moveCursor(line(".") + 1)
	" call cursor(line(".") + 1, 0)
endfunction

function! slash#moveCursor(line)
	call cursor(a:line, 0)
	call slash#exciteUserEvent("SlashItemSelected")
endfunction

" TODO
" function! slash#getMatchedItems(items, pattern)
	" let hasCaretSign = a:pattern[0] == '^'
	" let hasDollarSign = match(a:pattern, '\$$')
	" let matchedItems = []

	" for item in items
		" if(hasCaretSign && hasDollarSign && item.raw == a:pattern)
		" endif
		" elseif(hasCaretSign && )
	" endfor
" endfunction

" function! slash#getMatchesNatively(items, pattern)
	" let matchedItems = []
	" let pattern = a:pattern == "" ? '.*' : a:pattern

	" for item in a:items
		" if(match(item.raw, pattern) != -1)
			" call add(matchedItems, item)

			" if(len(matchedItems) == b:limit)
				" break
			" endif
		" endif
	" endfor

	" return matchedItems
" endfunction

function! slash#getMatchesUsingGrep(items, pattern)
	let command = printf(b:grepCommand, shellescape(a:pattern), b:rawFile)
	let matchedLines = systemlist(command)
	let matches = []

	for line in matchedLines
		let separatorIndex = stridx(line, ":")
		let key = strpart(line, 0, separatorIndex) - 1

		call add(matches, a:items[key])
	endfor

	return matches
endfunction

function! slash#getMatchesNatively(items, pattern)
	let matched = []

	" case insensitive search
	let pattern = a:pattern . '\c'

	for item in a:items
		if(match(item.raw, pattern) != -1)
			call add(matched, item)

			if(len(matched) == b:limit)
				break
			endif
		endif
	endfor

	return matched
endfunction

function! slash#comparator(a, b)
	return len(a:a.raw) - len(a:b.raw)
endfunction

function! slash#getSelectedItem()
	return b:matchesAmount == 0 ? v:none : b:matches[line(".") - 1]
endfunction

function! slash#getCompleteItems(items)
	let key = 0

	" return a:item.visibleLine . s:TAG_LINE_END . a:item.comment
	for item in a:items
		let item.key = key
		let key += 1
		let visibleLine = has_key(item, "visibleLine") ? item.visibleLine : item.raw
		let comment = has_key(item, "comment") ? item.comment : ""
		let item.bufferLine = visibleLine . s:TAG_LINE_END . comment
		" fill visibleLine keys
		" if(!has_key(item, "visibleLine"))
			" let item.visibleLine = item.raw
		" endif

		" fill comment keys
		" if(!has_key(item, "comment"))
			" let item.comment = ""
		" endif
	endfor

	return a:items
endfunction

function! slash#updateSyntax(pattern)
	if(hlexists("slashItemMatchedPattern"))
		syntax clear slashItemMatchedPattern
	endif

	" syntax clear slashMatchedPattern
	" syntax clear slashSelectedItemMatchedPattern

	if(hlexists("slashSelectedItemMatchedPattern"))
		syntax clear slashSelectedItemMatchedPattern
	endif

	let pattern = a:pattern
	let patternLength = len(pattern)

	let hasCaret = pattern[0] == '^'
	let hasDollar = pattern[patternLength - 1] == '$' && (patternLength < 2 || pattern[patternLength - 2] != '\')

	if(hasDollar)
		let pattern = strpart(pattern, 0, patternLength - 1)
	endif

	if(hasCaret)
		let pattern = strpart(pattern, 1)
	endif

	let patternLength = len(pattern)

	if(patternLength == 0)
		return
	endif

	let pattern = escape(pattern, '/')

	if(hasCaret && hasDollar)
		let pattern = printf('\zs%s\ze', pattern)
	elseif(hasDollar)
		let pattern = printf('.*\zs%s\ze', pattern)
	elseif(hasCaret)
		let pattern = printf('\zs%s\ze.*', pattern)
	else
		let pattern = printf('\zs%s\ze.*', pattern)
	endif

	let matchPattern = printf(b:syntaxMatchRegion, pattern)
	let selectedMatchPattern = printf(b:syntaxMatchRegion, pattern)

	" silent! execute printf('syntax match slashMatchedPattern /%s/ contained', matchPattern)
	" silent! execute printf('syntax match slashSelectedItemMatchedPattern /%s/ contained', selectedMatchPattern)
	execute printf('syntax match slashItemMatchedPattern /%s/ contained', matchPattern)
	execute printf('syntax match slashSelectedItemMatchedPattern /%s/ contained', selectedMatchPattern)
	" sleep 5
endfunction

function! slash#getStringMatches(line, pattern, offsetType)
	let matches = []
	let offset = 0

	while(1)
		let match = matchstrpos(a:line, a:pattern, offset)

		if(match[1] == -1)
			return matches
		endif

		call add(matches, match)

		let offset = match[a:offsetType] + 1
	endwhile
endfunction

function! slash#exciteUserEvent(event)
	if(exists("#User#" . a:event))
		execute "doautocmd User " . a:event
	endif
endfunction

function! slash#error(message)
	echo a:message
endfunction

function! slash#get(variable)
	return get(s:, a:variable, v:none)
endfunction

function! slash#getRaw(items)
	let b:raw = []

	for item in a:items
		call add(b:raw, item.raw)
	endfor

	return b:raw
endfunction
