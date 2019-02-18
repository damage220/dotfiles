let s:if = {
	\ pattern -> io#pattern(pattern)
	\ && !io#syntax(["String", "Comment"])
\ }

let s:rules = [
	\ {
		\ "input": '<CR>',
		\ "output": "\<CR>\<CR>]\<Up>\<Tab>",
		\ "priority": 0,
		\ "if": {-> s:if('\[\%#')},
	\ },
	\ {
		\ "input": '<CR>',
		\ "output": "\<CR>\<CR>}\<Up>\<Tab>",
		\ "priority": 0,
		\ "if": {-> s:if('{\%#')},
	\ },
	\ {
		\ "input": '<BS>',
		\ "output": "\<BS>\<Del>",
		\ "priority": 0,
		\ "if": {-> s:if('(\%#)\|{\%#}\|\[\%#\]\|"\%#"\|''\%#''\|<\%#>')},
	\ },
\]

call io#extend(s:rules)
