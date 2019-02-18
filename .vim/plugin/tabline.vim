let s:superscripts = ["¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]

function! Tabline()
	let line = ""

	for i in range(tabpagenr("$"))
		let tab = i + 1
		let winnr = tabpagewinnr(tab)
		let buflist = tabpagebuflist(tab)
		let bufnr = buflist[winnr - 1]
		let bufname = bufname(bufnr)

		let line .= "%" . tab . "T"
		let line .= tab == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#"

		if tab <= len(s:superscripts)
			let line .= s:superscripts[tab - 1]
		endif

		let line .= bufname != "" ? fnamemodify(bufname, ":t") . " " : "[No Name] "
		let bufmodified = getbufvar(bufnr, "&mod")

		if(bufmodified)
			let line .= "+ "
		endif
	endfor

	let line .= "%#TabLineFill#"
	
	return line
endfunction

set tabline=%!Tabline()
