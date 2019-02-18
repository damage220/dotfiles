function! finder#tags#index(...)
	if(!executable("ctags"))
		return finder#error("Ctags was not found in your $PATH.")
	endif

	if(!filereadable(expand("%")))
		return finder#error("File cannot be read.")
	endif

	if(&ft == "")
		return finder#error("Please specify filetype.")
	endif

	let options = get(a:, 1, {})
	let options.bufferName = get(options, "bufferName", "tags")
	let options.prompt = get(options, "prompt", "Tags> ")
	let options.header = get(options, "header", [])
	let options.flexibleWindow = get(options, "flexibleWindow", 1)
	let options.moveCommentToRight = get(options, "moveCommentToRight", 1)

	let command = get(options, "command", "ctags -x --sort=no --format=2 --language-force=%s %s")
	let tags = systemlist(printf(command, &ft, shellescape(expand("%"))))

	if(v:shell_error || len(tags) == 0)
		return finder#error("No tags were found.")
	endif

	let items = []

	for tag in tags
		let parts = split(tag, '\s\+')

		let item = {}
		let item.raw = parts[0]
		let item.comment = parts[1][0]
		let item.position = [parts[2], -1]

		call add(items, item)
	endfor

	call finder#splitted(items, options)
endfunction
