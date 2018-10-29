if ( exists('g:loaded_bettercomments') && g:loaded_bettercomments ) || v:version < 700 || &cp
  finish
endif
let g:loaded_bettercomments = 1

" Functions {{{

function! s:AddMatchesGroup(name, rules)
  let containedin=join(map(['MultilineComment', 'LineComment', 'DocComment', 'Comment'], 'b:bettercomments_syntax_prefix."".v:val'), ",").',Comment'
  exe 'syn match '.a:name.'BetterComments "\(^\s*\)\@<=\([^0-9A-Za-z_ ]\+ *\)\? \?\('.join(a:rules, '\|').'\)...\+" containedin='.containedin
  exe 'syn match '.a:name.'LineBetterComments "\(\/\{2\}\|#\{1\}\|\"\{1\}\) *\('.join(a:rules, '\|').'\)...\+" containedin='.b:bettercomments_syntax_prefix.'LineComment'
endfunction

function! s:BetterComments()
  let language = substitute(&filetype, '\..*', '', '')
  if exists("g:bettercomments_skipped") |
    if index(g:bettercomments_skipped, language) > -1 | return | endif
  endif
  if exists("g:bettercomments_included") |
    if index(g:bettercomments_included, language) == -1 | return | endif
  endif

  let b:bettercomments_syntax_prefix = exists('g:bettercomments_language_aliases[language]') ? g:bettercomments_language_aliases[language] : language

  call s:AddMatchesGroup("Highlight", [ '+', 'WARN:' ])
  call s:AddMatchesGroup("Error", [ '!', 'ERROR:' ])
  call s:AddMatchesGroup("Question", [ '?', 'QUESTION' ])
  call s:AddMatchesGroup("Todo", [ 'TODO:', 'Todo:'])
  call s:AddMatchesGroup("Paragraph", [ '*', 'Paragraph:', 'PARAGRAPH:' ])
  call s:AddMatchesGroup("Head", [ ':', 'HEAD:', 'Head:' ])
  call s:AddMatchesGroup("Note", [ ';', 'NOTE:', 'Note:' ])
  let containedin=join(map(['LineComment', 'MultilineComment', 'DocComment', 'Comment'], 'b:bettercomments_syntax_prefix."".v:val'), ",").',Comment'
  exe 'syn match StrikeoutBetterComments "\(\/\{4\}\|#\{2\}\|\"\{2\}\).\+" containedin='.containedin
endfunction

"}}}

" Autocommands {{{

augroup betterCommentsPluginAuto
  autocmd!
  au FileType * call s:BetterComments()
augroup END

" }}}

" Syntax {{{

hi def link ErrorBetterComments CommentError
hi def link ErrorLineBetterComments ErrorBetterComments
hi def link HighlightBetterComments Underlined
hi def link HighlightLineBetterComments HighlightBetterComments
hi def link QuestionBetterComments Identifier
hi def link QuestionLineBetterComments QuestionBetterComments
hi def link StrikeoutBetterComments WarningMsg

hi def link TodoBetterComments Todo
hi def link TodoLineBetterComments TodoBetterComments

hi def link ParagraphBetterComments Paragraph
hi def link ParagraphLineBetterComments ParagraphBetterComments
hi def link HeadBetterComments Headline
hi def link HeadLineBetterComments HeadBetterComments
hi def link NoteBetterComments Note
hi def link NoteLineBetterComments NoteBetterComments
"}}}
