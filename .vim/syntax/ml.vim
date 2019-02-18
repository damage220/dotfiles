if exists('b:current_syntax')
	finish
endif

" syntax
syntax region mlSection start=/^=\{80}/ end=/^$/ contains=mlSeparator,mlTitle
syntax match mlTitle /^.\+$/ contained
syntax match mlSeparator /=\{80}/ contained
syntax match mlParagraph /^[#¶] .\+$/
syntax match mlPath /\(\~\|\.\{1,2}\)\?\/\(\.\{1,2}\/\|\(\(\(\\ \|[.\-]\)\?\w\)\+\/\?\)\)\+/
syntax match mlList /^\([*\-+]\|\d\+\.\)\ze /
syntax match mlTag /\[\w\+\]/ contains=mlTagValue
syntax match mlTagValue /\[\zs\w\+\ze\]/ contained
syntax match mlVariable /\${\w\+}\|\$\w\+/
syntax region mlString start="\".\{-}" end="\"" contains=mlVariable

" colors
hi link mlSeparator Comment
hi link mlTitle Statement
hi link mlParagraph mlTitle
hi link mlPath Directory
hi link mlTag Special
hi link mlTagValue mlTag
hi link mlVariable Special
hi link mlString String
hi link mlList LineNr
