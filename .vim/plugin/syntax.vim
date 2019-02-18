function! syntax#showGroup()
	let id = synID(line("."), col("."), 1)
	let linkedTo = ""

	if !id
		echo "There is no group."

		return
	endif

	let highlightedGroup = synIDtrans(id)

	if highlightedGroup != id
		let linkedTo = "->" . synIDattr(highlightedGroup, "name", "cterm")
	endif

	echo printf("%s (fg: %i)",
		\ synIDattr(id, "name") . linkedTo,
		\ synIDattr(highlightedGroup, "fg", "cterm"))
endfunction
