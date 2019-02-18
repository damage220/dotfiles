if exists("w:dqflist")
	finish
endif

let w:dqflist = getqflist()

function! qf#unique()
	let qflist = getqflist()
	let uids = {}
	let uqflist = []

	for item in qflist
		if !has_key(uids, item.bufnr)
			let uids[item.bufnr] = 0

			call add(uqflist, item)
		endif
	endfor

	call setqflist(uqflist)
endfunction

function! qf#restore()
	call setqflist(w:dqflist)
endfunction

nnoremap <silent><buffer>u :call qf#unique()<CR>
nnoremap <silent><buffer>r :call qf#restore()<CR>
