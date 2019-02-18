if exists("syntax_on")
	syntax reset
endif

let g:colors_name = "solarized"

" misc
hi Normal ctermfg=12 ctermbg=NONE cterm=NONE
hi Search ctermfg=NONE ctermbg=237 cterm=NONE
hi Visual ctermfg=NONE ctermbg=237 cterm=NONE
hi VertSplit ctermfg=0 ctermbg=0 cterm=NONE
hi LineNr ctermfg=11 ctermbg=NONE cterm=NONE
hi Title ctermfg=2 ctermbg=NONE cterm=NONE
hi Folded ctermfg=NONE ctermbg=0 cterm=NONE
hi SignColumn ctermfg=NONE ctermbg=NONE cterm=NONE
hi ColorColumn ctermfg=NONE ctermbg=0 cterm=NONE
hi Question ctermfg=2 ctermbg=NONE cterm=NONE
hi NonText ctermfg=NONE ctermbg=NONE cterm=NONE
hi SpecialKey ctermfg=NONE ctermbg=NONE cterm=NONE
hi Conceal ctermfg=NONE ctermbg=NONE cterm=NONE
hi Directory ctermfg=4 ctermbg=NONE cterm=NONE
hi EndOfBuffer ctermfg=NONE ctermbg=NONE cterm=NONE
hi WildMenu ctermfg=4 ctermbg=NONE cterm=NONE

" message
hi MoreMsg ctermfg=NONE ctermbg=NONE cterm=NONE
hi ModeMsg ctermfg=NONE ctermbg=NONE cterm=bold

" cursor
hi Cursor ctermfg=NONE ctermbg=NONE cterm=NONE
hi CursorColumn ctermfg=NONE ctermbg=0 cterm=NONE
hi CursorLine ctermfg=NONE ctermbg=0 cterm=NONE
hi CursorLineNr ctermfg=NONE ctermbg=NONE cterm=NONE

" tabline
hi TabLineFill ctermfg=NONE ctermbg=NONE cterm=NONE
hi TabLine ctermfg=NONE ctermbg=NONE cterm=NONE
hi TabLineSel ctermfg=4 ctermbg=NONE cterm=NONE

" pmenu
hi Pmenu ctermfg=NONE ctermbg=0 cterm=NONE
hi PmenuSel ctermfg=8 ctermbg=12 cterm=bold
hi PmenuSbar ctermfg=NONE ctermbg=0 cterm=NONE
hi PmenuThumb ctermfg=NONE ctermbg=12 cterm=NONE

" statusline
hi StatusLine ctermfg=NONE ctermbg=NONE cterm=NONE
hi StatusLineNC ctermfg=NONE ctermbg=NONE cterm=NONE

" error
hi ErrorMsg ctermfg=NONE ctermbg=NONE cterm=NONE
hi WarningMsg ctermfg=NONE ctermbg=NONE cterm=NONE

" quickfix
hi QuickFixLine ctermfg=NONE ctermbg=0 cterm=NONE
hi qfSeparator ctermfg=NONE ctermbg=NONE cterm=NONE

" programming
hi Identifier ctermfg=NONE ctermbg=NONE cterm=NONE
hi Function ctermfg=2 ctermbg=NONE cterm=NONE
hi Keyword ctermfg=3 ctermbg=NONE cterm=NONE
hi Type ctermfg=2 ctermbg=NONE cterm=NONE
hi String ctermfg=64 ctermbg=NONE cterm=NONE
hi Comment ctermfg=11 ctermbg=NONE cterm=NONE
hi Statement ctermfg=2 ctermbg=NONE cterm=NONE
hi Todo ctermfg=10 ctermbg=NONE cterm=bold,underline
hi Constant ctermfg=4 ctermbg=NONE cterm=NONE
hi Operator ctermfg=NONE ctermbg=NONE cterm=NONE
hi Special ctermfg=4 ctermbg=NONE cterm=NONE
hi PreProc ctermfg=4 ctermbg=NONE cterm=NONE
hi Bracket ctermfg=NONE ctermbg=NONE cterm=NONE
hi MatchParen ctermfg=4 ctermbg=0 cterm=bold
hi Key ctermfg=NONE ctermbg=NONE cterm=NONE
hi Noise ctermfg=NONE ctermbg=NONE cterm=NONE
hi Ignore ctermfg=8 ctermbg=NONE cterm=NONE
hi Error ctermfg=NONE ctermbg=NONE cterm=NONE
hi link Braces Bracket

" vim
hi link vimCommand keyword
hi link vimIsCommand Identifier
hi link vimOption Identifier
hi link vimHiGroup Identifier
hi link vimGroup Identifier
hi link vimHiAttrib Constant
hi link vimFunction Function
hi link vimUserFunc Function
hi link vimParenSep Braces
hi link vimFuncSID Function
hi link vimSep Bracket
hi link vimSet Normal
hi link vimSetEqual Normal
hi link vimMapModKey Special
hi link vimCommentString Comment

" help
hi link helpNote Comment
hi link helpHyperTextJump Special
hi link helpHeader Statement

" php
hi phpDocTags ctermfg=10 ctermbg=NONE cterm=bold,underline
hi link phpClasses Normal
hi link phpFunction Function
hi link phpSuperglobals Identifier
hi link phpMethod Function
hi link phpType Type
hi link phpStringSingle String
hi link phpRegion Normal
hi link phpKeyword Keyword
hi link phpInclude phpKeyword
hi link phpUseClass phpRegion
hi link phpMethodsVar Identifier
hi link phpParent Bracket
hi link phpVarSelector Identifier
hi link phpMemberSelector Identifier

" javascript
hi link jsFuncCall Function
hi link jsBraces Bracket
hi link jsBrackets Bracket
hi link jsParens Bracket
hi link jsFuncBraces Bracket
hi link jsFuncParens Bracket
hi link jsObjectKey Key
hi link jsFunctionKey Key
hi link jsFuncBlock Identifier
hi link jsParen Identifier
hi link jsBlock Identifier
hi link jsGlobalObjects Identifier
hi link jsFuncArgs Identifier
hi link jsThis Identifier
hi link jsVariableDef Identifier
hi link jsReturn Keyword
hi link jsStatement Keyword
hi link jsConditional Keyword
hi link jsRepeat Keyword
hi link jsLabel Keyword
hi link jsKeyword Keyword
hi link jsException Keyword
hi link jsAsyncKeyword Keyword
hi link jsClassBraces Braces
hi link jsIfElseBraces Braces
hi link jsObjectBraces Braces
hi link jsSuper Function
hi link jsClassDefinition Normal

" html
hi HtmlTag ctermfg=4 ctermbg=NONE cterm=NONE
hi link HtmlTagName HtmlTag
hi link HtmlEndTag HtmlTag
hi link HtmlSpecialTagName HtmlTag

" css
hi link cssFunctionComma Noise
hi link cssUnitDecorators cssConstant
hi link cssConstant Constant
hi link cssColor cssConstant
hi link cssValueLength cssConstant
hi link cssValueNumber cssConstant
hi link cssAttrRegion cssConstant
hi link cssTagName cssIdentifier
hi link cssFunctionName cssAttr
hi link cssClassName cssIdentifier
hi link cssClassNameDot cssIdentifier
hi link cssIdentifier Keyword
hi link cssProp Statement
hi link cssAttr Normal
hi link cssAttrComma Noise
hi link cssBraces Braces

" md
hi link markdownLinkText Normal

" json
hi link jsonQuote String
hi link jsonKeyword String

" twig
hi link twigStatement Keyword
hi link twigOperator Operator
hi link twigString String
hi link twigBlockName Normal
hi link twigTagDelim Bracket

" xml
hi link xmlEndTag xmlTag

" netrw
hi link netrwClassify Directory

" archive
hi link tarDirectory Directory
