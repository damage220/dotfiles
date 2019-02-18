let s:rules = {}

function! io#extend(rules)
	for rule in a:rules
		let key = tr(rule.input, "<", " ")
		let rule.priority = get(rule, "priority", 1)

		if !has_key(s:rules, key)
			let s:rules[key] = []

			execute printf("inoremap <silent><expr>%s <SID>getExpression(%s, %s)", rule.input, string(key), string(rule.input))
		endif

		call add(s:rules[key], rule)
	endfor
endfunction

function! io#pattern(pattern)
	return search(a:pattern, "nbc", line(".")) > 0
endfunction

function! io#filetypes(filetypes)
	return index(a:filetypes, &ft) != -1
endfunction

function! io#syntax(groups)
	let groups = map(a:groups, {key, val -> hlID(val)})
	let currentSyntaxGroup = synIDtrans(synID(line("."), col(".") - 1, 1))

	return index(groups, currentSyntaxGroup) != -1
endfunction

function! s:getExpression(key, input)
	let matchedRule = v:null

	for rule in s:rules[a:key]
		if !has_key(rule, "if") || (call(rule.if, []) && (type(matchedRule) != v:t_dict || rule.priority > matchedRule.priority))
			let matchedRule = rule
		endif
	endfor

	return type(matchedRule) == v:t_dict ? matchedRule.output : a:input
endfunction
