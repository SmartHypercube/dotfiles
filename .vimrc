"""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc default setup file for Terminbal IDE "
"                                             "
" Creator : Spartacus Rex                     "
" Version : 1.0                               "
" Date    : 9 Nov 2011                        "
"""""""""""""""""""""""""""""""""""""""""""""""

"The basic settings
set nocp
set laststatus=1
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>=,trail:-
set expandtab
set ruler
"set number
set colorcolumn=81
set ignorecase
set smartcase
" CVE-2019-12735
set nomodeline
set autoindent
set nobackup
set wrap
set hidden
set backspace=indent,eol,start
set mouse=a
set clipboard=unnamedplus,autoselect,exclude:cons\|linux
" only utf-8 is allowed
set fileencodings=
set encoding=utf-8
" only unix eols are allowed
set fileformats=unix
"set foldmethod=syntax
"set foldmethod=marker

"Syntax highlighting
syntax on

"Yes filetype matter
filetype plugin on

"Set a nice Omnifunc - <CTRL>X <CTRL>O
set ofu=syntaxcomplete#Complete

"This is a nice buffer switcher
:nnoremap <F5> :buffers<CR>:buffer<Space>

"You can change colors easily in vim.
"Just type <ESC>:colorscheme and then TAB complete through the options
colorscheme pablo
set background=dark

"Set the color for the popup menu
:highlight Pmenu ctermbg=blue ctermfg=white
:highlight PmenuSel ctermbg=blue ctermfg=red
:highlight PmenuSbar ctermbg=cyan ctermfg=green
:highlight PmenuThumb ctermbg=white ctermfg=red

" DICTIONARY
" The dictioanry can pop up a lot of words when you have Auto popup enabled.
" You can disable auto popup, by removing the acp.vim from your ~/.vim/plugin/
" directory and enable the dictionary here - then use <CTRL>X <CTRL>K to bring
" up the dictionary options. Or just enable it.. :-)

" set dictionary+=~/system/etc/dict/words

" Make vim popup behave more like an IDE POPUP
" set completeopt=longest,menuone

" Make enter finish the completion popup menu
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"Auto start NERDTree on startup..
"autocmd VimEnter * NERDTree
"autocmd VimEnter * wincmd p

"TAGLIST setup
nnoremap <F3> :TlistToggle<CR>
let Tlist_Use_Right_Window = 1
let Tlist_WinWidth = 50

set guifont=Consolas:h12:cANSI
