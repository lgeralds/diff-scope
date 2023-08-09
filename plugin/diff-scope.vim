""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: MIT
"     Author: lgeralds
"    Version: 0.1
" CreateTime: 2023-08-08 19:00:00
" LastUpdate: 2023-08-20 19:00:00
"       Desc: Diff directories through Telescope
""""""""""""""""""""""""""""""""""""""""""
echo 'Starting diff-scope vim'

if exists('s:is_load')
	finish
endif
let s:is_load = 1

lua diffscope = require('diff-scope')

hi DiffScopeBack guifg=#61afef
hi DiffScopeChange guifg=#E5C07B
hi DiffScopeAdd guifg=#98C379
hi DiffScopeRemove guifg=#E06C75

"he command-completion-customlist
command -nargs=+ -complete=customlist,v:lua.diffscope.cmdcomplete DSdiff call v:lua.diffscope.diff_dir(v:false, <f-args>)
command -nargs=+ -complete=customlist,v:lua.diffscope.cmdcomplete DSdiffRec call v:lua.diffscope.diff_dir(v:true, <f-args>)

command DSResume call v:lua.dirdiff.show()

command DSClose call v:lua.diffscope.close()

command DSCloseAll call v:lua.diffscope.close_all()

command DSNext call v:lua.diffscope.diff_next()

command DSPre call v:lua.diffscope.diff_pre()
