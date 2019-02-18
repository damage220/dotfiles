" let s:MIN_COLUMNS = 25
let s:MIN_DISTANCE_TO_COMMENT = 2

function! slash#splitted#index(items, ...)
	let options = get(a:, 1, {})
	" let options.openBufferCommand = get(options, "openBufferCommand", "new")
	let options.allowedOpenBufferCommands = ["new", "vnew"]
	let options.handler = get(options, "handler", function("s:handler"))

	" let previousWindowView = winsaveview()
	let preview = get(options, "preview", 0)
	let flexibleWindow = get(options, "flexibleWindow", 0)
	let moveCommentToRight = get(options, "moveCommentToRight", 0)

	" if(flexibleWindow)
		" let maxLength = 0

		" for item in a:items
			" let comment = get(item, "comment", "")
			" let length = len(item.raw) + len(comment)

			" if(length > maxLength)
				" let maxLength = length
			" endif
		" endfor

		" let options.windowSize = min([winwidth(0) / 2, max([s:MIN_COLUMNS, maxLength + s:MIN_DISTANCE_TO_COMMENT])])
	" endif

	let options.windowSize = get(options, "windowSize", winwidth(0))

	if(moveCommentToRight)
		for item in a:items
			let comment = get(item, "comment", "")
			let length = len(item.raw) + len(comment)

			let difference = options.windowSize - length
			let item.comment = repeat(" ", difference) . comment
			" echo difference
		endfor
	endif

	" if(has_key(options, "windowSize"))
		" execute "vertical resize " . options.windowSize
	" endif

	" call finder#fill()

	if(preview)
		let options.preventScrolling = 0
	endif

	call slash#openWindow(a:items, options)

	" execute printf("autocmd User SlashCancelled wincmd w | call winrestview(%s) | wincmd w", string(previousWindowView))

	if(preview)
		autocmd User SlashItemSelected call <SID>preview(slash#getSelectedItem())
	endif

	call slash#startTyping()
endfunction

function! s:handler(item)
	let g:position = a:item.position
	call slash#closeWindow()
	" execute printf("%iwincmd w", b:previousWindow)

	call s:moveCursor(a:item.position[0], a:item.position[1])
endfunction

function! s:preview(item)
	" call setline(1, 123)
	" execute printf("%iwindo call cursor(%i, %i) | %iwincmd w", b:previousWindow, a:item.position[0], a:item.position[1], b:currentWindow)
	" redraw
	" execute printf("%iwindo call cursor(%i, %i) | %iwincmd w", b:previousWindow, a:item.position[0], 1, b:currentWindow)
	" return

	" avoiding cursor blink
	" call term_wait("", 1000)
	" let matchId = s:addVirtualCursor()

	execute printf("%iwindo call <SID>moveCursor(%i, %i) | %iwincmd w", b:previousWindow, a:item.position[0], a:item.position[1], b:currentWindow)
	" redraw!
	" return

	" let currentWindow = b:currentWindow
	" execute printf("%iwincmd w", b:previousWindow)

	" call s:moveCursor(a:item.position[0], a:item.position[1])
	" call s:deleteVirtualCursor(matchId)

	" execute printf("%iwincmd w", currentWindow)
	" redraw
endfunction

function! s:moveCursor(line, column)
	if(a:column == -1)
		call cursor(a:line, 0)
		normal ^
	else
		call cursor(a:line, a:column)
	endif

	normal zz

	" force cursorline moving
	set cursorline!
	set cursorline!
endfunction

" function! s:addVirtualCursor()
	" let pattern = printf('\%%%il\%%%ic.', line("."), col("."))
	" call setline(line("."), getline(line(".")) . " ")

	" return matchadd("Cursor", '\%6l\%8c.')
	" " return matchadd("Cursor", pattern)
" endfunction

" function! s:deleteVirtualCursor(id)
	" let currentLine = getline(line("."))
	" let newLine = strpart((currentLine), 0, len(currentLine) - 1)

	" call setline(line("."), newLine)
	" call matchdelete(matchId)
" endfunction
