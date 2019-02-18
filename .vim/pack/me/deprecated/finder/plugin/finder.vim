if(v:version < 800)
	echo "Finder requires Vim 8 or above."
endif

command! -nargs=* -complete=file Files call s:files(<f-args>)
command! Lines call finder#lines()
command! Tags call finder#tags()
command! -nargs=1 Matches call finder#matches(<f-args>)

function! s:files(...)
	if(a:0 == 0)
		call finder#files()
	elseif(a:0 == 1)
		call finder#files({"directory": a:1})
	elseif(a:0 == 2)
		call finder#files({"directory": a:1, "openBufferCommand": a:2})
	endif
endfunction

" Define syntax highlighting
hi link finderHeader Comment
hi finderHeaderLabel ctermfg=109 ctermbg=NONE cterm=NONE
hi finderHeaderValue ctermfg=215 ctermbg=NONE cterm=NONE
hi finderHeaderShortcut ctermfg=222 ctermbg=NONE cterm=NONE
hi link finderHeaderShortcutSeparator finderHeader
hi finderHeaderShortcutNote ctermfg=255 ctermbg=NONE cterm=NONE
hi finderPrompt ctermfg=81 ctermbg=NONE cterm=NONE
hi finderQuery ctermfg=255 ctermbg=NONE cterm=NONE
hi finderBody ctermfg=109 ctermbg=NONE cterm=NONE
hi finderSelected ctermfg=109 ctermbg=0 cterm=bold
hi finderComment ctermfg=109 ctermbg=NONE cterm=NONE
hi finderSelectedComment ctermfg=109 ctermbg=0 cterm=bold
hi finderMatch ctermfg=215 ctermbg=NONE cterm=bold,underline
hi finderSelectedMatch ctermfg=215 ctermbg=0 cterm=bold,underline
