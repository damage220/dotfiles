function! GetStatusLine()
	let statusline = ""
	let statusline .= printf("%%#StatusLineSession#%%([%s]%%)", s:getSession())
	let statusline .= printf("%%#StatusLineFile#%%( %s%%)", "%f")
	let statusline .= printf("%%#StatusLineFlags#%%(%s %%)", s:getFlags())
	let statusline .= printf("%%=%%#StatusLineFileType#%%([%s]%%)", getbufvar("%", "&filetype"))
	let statusline .= s:getPosition()

	return statusline
endfunction

function! s:getSession()
	return v:this_session == "" ? "No Session" : substitute(v:this_session, '^\(.*/\)\?\(.*\)$', '\2', "")
endfunction

function! s:getPosition()
	let template = "%%#%s#%%( %s %%)"
	let syntaxGroup = "StatusLinePosition"

	return printf(template, syntaxGroup, "%l,%c  %P")
endfunction

function! s:getFlags()
	let flags = ""

	if(&readonly)
		let flags .= " [RO]"
	endif

	return flags
endfunction

function! s:getFileName()
	return substitute(expand("%"), '^' . getcwd(), "", "")
endfunction

set statusline=%!GetStatusLine()
autocmd VimResized * set statusline=%!GetStatusLine()
