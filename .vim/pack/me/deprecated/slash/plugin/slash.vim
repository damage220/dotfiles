if(v:version < 800)
	echo "Slash requires Vim 8 or above."
endif

command! -nargs=* -complete=file Files call s:files(<f-args>)
command! Lines call slash#lines()
command! Tags call slash#tags()
command! -nargs=1 Matches call slash#matches(<f-args>)

function! s:files(...)
	if(a:0 == 0)
		call slash#files()
	elseif(a:0 == 1)
		call slash#files({"directory": a:1})
	elseif(a:0 == 2)
		call slash#files({"directory": a:1, "openBufferCommand": a:2})
	endif
endfunction
