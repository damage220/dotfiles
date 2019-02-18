function! s:getSession()
	return v:this_session == "" ? '[No\ Session]' : substitute(v:this_session, '^\(.*/\)\?\(.*\)$', '[\2]', "")
endfunction

function! s:getFlags()
	let flags = ""

	if(&readonly)
		let flags .= " [RO]"
	endif

	return flags
endfunction

" execute printf('set rulerformat=%%30(%%=%s%s%%10(%%l,%%c%%)%%5(%%P%%)%%)', s:getSession(), s:getFlags())
