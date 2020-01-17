set nocompatible

" No visual or beeping bells
set visualbell
set t_vb=

set nu
set relativenumber

filetype plugin on
" Enable syntax highlighting
syntax on

"======================"
" Vundle configuration "
"======================"

set rtp+=~/.vim/bundle/Vundle.vim
if isdirectory(expand('$HOME/.vim/bundle/Vundle.vim'))
  call vundle#begin()
  " Required
  Plugin 'gmarik/vundle'
  Plugin 'ntpeters/vim-better-whitespace'
  call vundle#end()
else
  echomsg 'Vundle is not installed. You can install Vundle from'
      \ 'https://github.com/VundleVim/Vundle.vim'
endif

" File types

" Colorscheme
let g:inkpot_black_background=1
Plugin 'NLKNguyen/papercolor-theme'
set t_Co=256
set bg=dark
let g:PaperColor_Dark_Override = { 'background' : '#000000'}
colorscheme PaperColor

" Settings
set history=1000 " Increase history from 20 default to 1000
set shortmess=atI " Don't show the intro message when starting vim.
set showmode " Show the current mode.
set smartcase " Ignore 'ignorecase' if search patter contains uppercase characters.
set smarttab
"set undofile " Persistent Undo.
set ruler
set showmatch
set matchpairs+=<:>


set nocp
syn on
set nopaste

set noexpandtab                              " use tabs, not spaces
set tabstop=8                                " tab this width of spaces
set shiftwidth=8                             " indent this width of spaces
au Syntax c,cpp syn match Error /^ \+/       " highlight any leading spaces
au Syntax c,cpp syn match Error / \+$/       " highlight any trailing spaces
au Syntax c,cpp syn match Error /\%>80v.\+/  " highlight anything past 80 in red
au Syntax c,cpp syn keyword cType uint ubyte ulong boolean_t
au Syntax c,cpp syn keyword cType int64_t int32_t int16_t int8_t
au Syntax c,cpp syn keyword cType uint64_t uint32_t uint16_t uint8_t
au Syntax c,cpp syn keyword cType u_int64_t u_int32_t u_int16_t u_int8_t
au Syntax c,cpp syn keyword cOperator likely unlikely

" set expandtab
" set sw=2 ts=2
" set vb t_vb=
set colorcolumn=+1 "highligh column after textwidth


"===================="
" Some basic options "
"===================="


