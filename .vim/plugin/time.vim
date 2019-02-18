function! Time(command)
	let reltime = reltime()
	let start = reltime[0] * 1000 + reltime[1] / 1000

	execute a:command

	let reltime = reltime()
	let stop = reltime[0] * 1000 + reltime[1] / 1000
	let time = stop - start

	return time
endfunction
