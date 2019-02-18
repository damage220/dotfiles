function! finder#commands#index(items, ...)
	let options = get(a:, 1, {})
	let options.bufferName = get(options, "bufferName", "commands")
	let options.prompt = get(options, "prompt", "Commands> ")
	let options.showPreview = 0
	let options.header = get(options, "header", [])
	let options.handler = get(options, "handler", function("s:handler"))
	let options.moveCommentToRight = get(options, "moveCommentToRight", 1)
	" let options.flexibleWindow = get(options, "flexibleWindow", 1)

	if(len(a:items) == 0)
		return finder#error("No commands to search.")
	endif

	call finder#splitted(deepcopy(a:items), options)
endfunction

function! s:handler(item)
	execute printf("%iwincmd w", b:previousWindow)
	" call finder#insertLeave()
	execute a:item.command
endfunction
