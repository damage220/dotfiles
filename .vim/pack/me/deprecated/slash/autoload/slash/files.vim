let s:BASENAME_SYNTAX_MATCH_REGION = '\(^\|\%(\/\)\@<=\)[^\/]\+'
" let s:HEADER_PLACEHOLDER_MODE = "{mode}"
" let s:HEADER_IGNORED_LABEL = "Ignored"
" let s:HEADER_IGNORED_PATH_SEPARATOR = ", "

function! slash#files#index(...)
	let options = get(a:, 1, {})
	let options.bufferName = get(options, "bufferName", "files")
	" let options.prompt = get(options, "prompt", "Files> ")
	let options.handler = get(options, "handler", function("s:handler"))
	let options.pattern = get(options, "pattern", "^")
	let options.comparator = get(options, "comparator", function("slash#comparator"))
	let options.useGrep = get(options, "useGrep", 1)
	" let options.headerContainedGroups = get(options, "headerContainedGroups", ["finderFilesHeaderIgnoredPaths"])

	let directory = get(options, "directory", ".")
	let command = get(options, "command", "find %s -type f")
	let ignoredPaths = get(options, "ignoredPaths", ["*/.git/*", "*/.svn/*"])
	let baseName = get(options, "baseName", 1)
	" let options.header = get(options, "header", s:getHeader(directory, ignoredPaths))

	if(!isdirectory(fnamemodify(directory, ":p")))
		return slash#error("Directory is not exist.")
	endif

	" assign directory
	let command = printf(command, directory)

	for path in ignoredPaths
		let command .= printf(" ! -path '%s'", path)
	endfor

	" remove ./ at the beginning of the line
	let command .= ' | sed "s|^\./||"'

	let paths = systemlist(command)
	let baseNames = []
	let options.raw = baseName ? baseNames : paths

	if(len(paths) == 0)
		return slash#error("There are no files in this directory.")
	endif

	let items = []

	for path in paths
		let item = {}
		let item.raw = path

		call add(items, item)
		call add(baseNames, fnamemodify(path, ":t"))
	endfor

	call slash#openWindow(items, options)
	" call s:defineSyntax()
	" call s:defineHighlighting()

	let b:baseName = baseName
	let b:paths = paths
	let b:baseNames = baseNames

	" inoremap <silent><buffer><C-b> <C-r>=finder#call("<SID>toggleBaseName")<CR>
	cnoremap <buffer><expr><C-b> slash#queue("call <SID>toggleBaseName()")

	if(b:baseName)
		call s:enableBaseName()
	else
		call s:disableBaseName()
	endif

	call slash#startTyping()
endfunction

function! s:handler(item)
	call slash#closeWindow()
	execute printf("tabe %s", fnameescape(a:item.raw))
endfunction

function! s:toggleBaseName()
	if(b:baseName)
		call s:disableBaseName()
	else
		call s:enableBaseName()
	endif

	" call timer_start(0, "finder#redraw")
	" call slash#update(getcmdline())
endfunction

function! s:enableBaseName()
	" let b:raw = b:baseNames
	" let b:mode = "basename"
	let b:baseName = 1
	let b:patternHandler = function("<SID>getBasenamePattern")

	call slash#setSyntaxMatchRegion(s:BASENAME_SYNTAX_MATCH_REGION)
endfunction

function! s:disableBaseName()
	" let b:raw = b:paths
	" let b:mode = "default"
	let b:baseName = 0
	let b:patternHandler = function("slash#patternHandler")

	call slash#setSyntaxMatchRegion(slash#get("SYNTAX_MATCH_REGION"))
endfunction

" function! s:getFullPathPattern()
	" return getcmdline()
" endfunction

function! s:getBasenamePattern(pattern)
	let pattern = a:pattern
	let length = len(pattern)
	let regex = "((^)|(/))%s$"
	let hasCaretSign = pattern[0] == "^"
	let hasDollarSign = pattern[length - 1] == "$" && pattern[length - 2] != '\'

	if(hasCaretSign)
		let pattern = substitute(pattern, '^\^', "", "")
	else
		let pattern = "[^/]*" . pattern
	endif

	if(hasDollarSign)
		let pattern = substitute(pattern, '\$$', "", "")
	else
		let pattern .= "[^/]*"
	endif

	return printf(regex, pattern)
	" return leftSide . pattern . rightSide
	" return printf("%s$", getcmdline())
	" " let rightSide = "$"
	" " let pattern = strpart(pattern, 0, length - 1)
	" " let leftSide = "[^/]"
	" " let pattern = strpart(pattern, 1)
	" let pattern = substitute(pattern, '^\^', "[^/]", "")
	" let pattern[0] = ""
	" let pattern[length - 1] = ""

	" let pattern = "((^)|(/))" . pattern
	" let pattern = substitute(pattern, '\$$', "[^/]*$", "")
endfunction

" function! s:getHeader(directory, ignoredPaths)
	" let header = finder#getHeader()
	" let directory = fnamemodify(a:directory, ":~")

	" call insert(header, '  Directory: ' . directory, 2)
	" call insert(header, printf("  %s: %s", s:HEADER_IGNORED_LABEL, join(a:ignoredPaths, s:HEADER_IGNORED_PATH_SEPARATOR)), 3)
	" call insert(header, '  Mode: ' . s:HEADER_PLACEHOLDER_MODE, 4)

	" return header
" endfunction

" function! s:defineSyntax()
	" execute printf('syntax match finderFilesHeaderIgnoredPaths /\%%(%s:\)\@<=.*/ contained contains=finderFilesHeaderIgnoredPath,finderFilesHeaderIgnoredPathSeparator', s:HEADER_IGNORED_LABEL)
	" execute printf('syntax match finderFilesHeaderIgnoredPath /.\{-}\ze\(%s\|$\)/ contained', s:HEADER_IGNORED_PATH_SEPARATOR)
	" execute printf('syntax match finderFilesHeaderIgnoredPathSeparator /%s\ze/ contained', s:HEADER_IGNORED_PATH_SEPARATOR)
" endfunction

" function! s:defineHighlighting()
	" hi link finderFilesHeaderIgnoredPath finderHeaderValue
	" hi link finderFilesHeaderIgnoredPathSeparator finderHeaderValue
" endfunction
