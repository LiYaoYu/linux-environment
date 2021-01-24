" tab settings for Makefile
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

" show trail space with symbol
set list lcs=tab:\ \ ,trail:·
hi SpecialKey ctermfg=239

" show current function name
nmap f :call ShowFuncName()<CR>
