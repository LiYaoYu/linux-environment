" settings for tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" show tab indent and trail space with symbol
set list lcs=tab:\|\ ,trail:·
hi SpecialKey ctermfg=239

" show current function name
nmap f :call ShowFuncName()<CR>

" cscope settings
set cscopetag
set csto=0
if filereadable("cscope.out")
  set nocscopeverbose
  cs add cscope.out
endif

" show msg when any other cscope db added
set cscopeverbose

"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls

" jump to target directly
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

" jump to target with a new vertical split window
nmap <C-\><C-\>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\><C-\>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\><C-\>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\><C-\>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\><C-\>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\><C-\>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\><C-\>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\><C-\>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

" update cscope automatically
nmap <silent> <C-\>u :call AutoUpdateCscopeAndCtags()<CR>
