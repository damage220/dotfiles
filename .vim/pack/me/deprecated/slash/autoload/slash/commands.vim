function! slash#commands#index(items, ...)
	let options = get(a:, 1, {})
	let options.bufferName = get(options, "bufferName", "commands")
	" let options.prompt = get(options, "prompt", "Commands> ")
	let options.preview = 0
	let options.header = get(options, "header", [])
	let options.handler = get(options, "handler", function("s:handler"))
	let options.moveCommentToRight = get(options, "moveCommentToRight", 1)
	" let options.flexibleWindow = get(options, "flexibleWindow", 1)

	if(len(a:items) == 0)
		return slash#error("No commands to search.")
	endif

	call slash#splitted(deepcopy(a:items), options)
endfunction

function! s:handler(item)
	" call slash#insertLeave()
	" execute printf("%iwincmd w", b:previousWindow)
	call slash#closeWindow()
	execute a:item.command
endfunction
