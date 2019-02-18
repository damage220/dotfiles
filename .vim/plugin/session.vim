" directory to save session files
let s:root = get(g:, "session_root", $HOME . "/.vim/sessions")

" do not load when file was passed on the cli
let s:loadable = argc() == 0

function! s:openSession(file)
	" do not source active session twice
	if a:file == v:this_session
		return s:error("This session is already in use.")
	endif

	" check whether session file exists
	if !filereadable(a:file)
		return s:error("Session file is not exist.")
	endif

	" save active session
	if s:isActiveSession()
		call s:saveSession()
	endif

	" remove all buffers
	try
		%bdelete
	catch
		redraw
		return s:error("There are modified buffers.")
	endtry

	execute "source " . a:file
	let g:SESSION = v:this_session
endfunction

function! s:saveSession(...)
	let file = get(a:000, 0, "") == "" ? v:this_session : s:getSessionPath(a:000[0])

	if file == ""
		return s:error("You must have active session or specify one.")
	endif

	if !isdirectory(s:root)
		call mkdir(s:root, "p")
	endif

	" save active session
	if s:isActiveSession() && file != v:this_session
		execute "mksession! " . v:this_session
	endif

	execute "mksession! " . file

	let v:this_session = file
	let g:SESSION = v:this_session
endfunction

function! s:closeSession()
	if !s:isActiveSession()
		return s:error("There is no active session.")
	endif

	" save active session
	call s:saveSession()

	let v:this_session = ""
	let g:SESSION = v:this_session
endfunction

function! s:removeSession(...)
	let file = len(a:000) == 0 ? v:this_session : s:getSessionPath(a:000[0])

	if file == ""
		return s:error("You must have active session or specify one.")
	endif

	" remove active session
	if file == g:SESSION
		let v:this_session = ""
		let g:SESSION = v:this_session
	endif

	" check whether session file exists
	if !filereadable(file)
		return s:error("Session file is not exist.")
	endif

	call delete(file)
endfunction

function! s:getSessionPath(name)
	return s:root . "/" . a:name
endfunction

function! s:isActiveSession()
	return v:this_session != ""
endfunction

function! s:getSuggestions(a, b, c)
	let sessions = substitute(glob(s:root . '/*'), '\\', '/', 'g')

	return substitute(sessions, '\(^\|\n\)' . s:root . '/', '\1', 'g')
endfunction

function! s:error(message)
	echo a:message
endfunction

" autocommands
autocmd VimEnter * nested execute s:loadable && get(g:, "SESSION", "") != "" && s:openSession(g:SESSION)
autocmd VimLeavePre * execute s:isActiveSession() && s:saveSession()
autocmd StdinReadPre * let s:loadable = 0

" commands
command! -nargs=1 -complete=custom,<SID>getSuggestions Session call <SID>openSession(<SID>getSessionPath(<f-args>))
command! -nargs=? -complete=custom,<SID>getSuggestions SessionSave call <SID>saveSession(<f-args>)
command! SessionClose call <SID>closeSession()
command! -nargs=? -complete=custom,<SID>getSuggestions SessionRemove call <SID>removeSession(<f-args>)
