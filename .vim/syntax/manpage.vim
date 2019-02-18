if exists('b:current_syntax')
	finish
endif

" syntax
syntax match manTitle /^\w.*$/
syntax match manOption /\(^\|\s\+\|\[\)\zs-\{1,2}\(\w\|-\)\+/
syntax match manReference /\s\(\w\|-\)\+\ze(\d\+)/
syntax match manVariable /\${\w\+}\|\$\w\+/
execute printf('syntax match manOuter /^\(\%%1l\|\%%%il\).*$/', line("$"))

" colors
hi link manOption PreProc
hi link manTitle Statement
hi link manVariable PreProc
hi manReference cterm=bold
