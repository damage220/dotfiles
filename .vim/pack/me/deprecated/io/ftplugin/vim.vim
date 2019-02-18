if exists("s:rules")
	finish
endif

let s:if = {
	\ pattern -> io#pattern(pattern)
	\ && io#filetypes(["vim"])
	\ && !io#syntax(["String", "Comment"])
\ }

let s:rules = [
	\ {
		\ "input": '<CR>',
		\ "output": "\<CR>\<CR>\\ ]\<Up>\<Tab>\\ ",
		\ "if": {-> s:if('\[\%#')},
	\ },
	\ {
		\ "input": '<CR>',
		\ "output": "\<CR>\<CR>\\ }\<Up>\<Tab>\\ ",
		\ "if": {-> s:if('{\%#')},
	\ },
\ ]

call io#extend(s:rules)
