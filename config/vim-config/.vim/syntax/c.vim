"Syntax Configuration File for C written files

if exists("b:current_syntax")
  finish
endif

" Highlights functions name
syn match    	cCustomParen    	"(" contains=cParen
syn match   	cCustomFunc     	"\w\+\s*(" contains=cCustomParen
hi def	cCustomFunc  		ctermfg=105

" Highlight spaces at the end of line in red
syn match	cBadContinuation 	"\s\+$"

" Highlight some symboles
hi def cYellowSym	ctermfg=226
hi def cOrangeSym	ctermfg=208
hi def cRedSym		ctermfg=1
hi def cCyanSym		ctermfg=6
hi def cGreenSym	ctermfg=37
hi def cGreySym 	ctermfg=245
"Comparaisons
syn match	cRedSym		"!"			contains=cCommentGroup
syn match	cRedSym		"!="		contains=cCommentGroup
syn match	cRedSym		"=="		contains=cCommentGroup
syn match	cRedSym 	">="		contains=cCommentGroup
syn match	cRedSym		"<="		contains=cCommentGroup
syn match	cRedSym		"\s>\s"		contains=cCommentGroup
syn match	cRedSym		"\s<\s"		contains=cCommentGroup
syn match	cYellowSym	"&&"		contains=cCommentGroup
syn match	cYellowSym	"||"		contains=cCommentGroup
"Binary operations
syn match	cOrangeSym	"\s<<\s"	contains=cCommentGroup
syn match	cOrangeSym	"\s>>\s"	contains=cCommentGroup
syn match	cOrangeSym	"\s&\s"		contains=cCommentGroup
syn match	cOrangeSym	"\s&="		contains=cCommentGroup
syn match	cOrangeSym	"\s|\s"		contains=cCommentGroup
syn match	cOrangeSym	"\s|="		contains=cCommentGroup
syn match	cOrangeSym	"\s^\s"		contains=cCommentGroup
syn match	cOrangeSym	"\s^="		contains=cCommentGroup
"Operations
syn match	cGreenSym	"\s+\s" 	contains=cCommentGroup
syn match	cGreenSym	"\s+="		contains=cCommentGroup
syn match	cGreenSym	"\s-\s"		contains=cCommentGroup
syn match	cGreenSym	"\s-="		contains=cCommentGroup
syn match	cGreenSym	"\s\*\s"	contains=cCommentGroup
syn match	cGreenSym	"\s\*="		contains=cCommentGroup
syn match	cGreenSym	"\s/\s"		contains=cCommentGroup
syn match	cGreenSym	"\s/="		contains=cCommentGroup
syn match	cGreenSym	"\s%\s"		contains=cCommentGroup
syn match	cGreenSym	"\s%="		contains=cCommentGroup
syn match	cGreenSym	"++"		contains=cCommentGroup
syn match	cGreenSym	"--"		contains=cCommentGroup
syn match	cGreenSym	"\s=\s"		contains=cCommentGroup
"Structures
syn match	cCyanSym	"->"
syn match	cGreySym	"\w\+->" contains=cCyanSym
syn match	cGreySym	"\w\+\[.\+\]\(\|\[.\+\]\)\->" contains=VisualNOS,cCyanSym
syn match	cGreySym	"\w\+)\->"me=e-3 contains=cCyanSym