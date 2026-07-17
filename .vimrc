call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'
Plug 'pangloss/vim-javascript'
Plug 'vimwiki/vimwiki'
" Markdown Preview (funktioniert in Vim & NeoVim)
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-commentary'

" (optional) besseres Markdown-Syntax
Plug 'plasticboy/vim-markdown'

Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'

call plug#end()

nmap <C-n> :NERDTreeToggle<CR> 
nmap <C-s> <Esc>:w<CR>
nmap <C-k> :NERDTreeFocus<CR>
nmap <C-x> <Esc>:x<CR>

:set ts=4
:set autoindent
:set cindent
:set number

"nnoremap <C-s> <Esc>:w<CR>
"nnoremap <F8> <Esc>
inoremap jk <Esc>
inoremap jk <Esc>
inoremap <C-s> <Esc>:w<CR>
nnoremap .. :
nnoremap 77 /
nnoremap ++ ~
nnoremap ßß \
nnoremap 22 "
nnoremap 11 !
inoremap .. :
inoremap 77 /
inoremap ++ ~
inoremap ßß \
inoremap 22 "
inoremap 11 !
nnoremap .. :

cnoremap .. :
cnoremap 77 /
cnoremap ++ ~
cnoremap ßß \
cnoremap 22 "
cnoremap 11 !

nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle

let mapleader = " "

let g:vimwiki_list = [{
	\ 'path': '~/.vimwiki',
	\ 'syntax': 'markdown',
	\ 'ext': '.md'
	\ }]
let g:vimwiki_list[0].diary_rel_path = '10\ Journal/Daily/'
nnoremap <leader>ts i<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR><Esc>
vnoremap <C-y> :w !xclip -selection clipboard<CR>
nnoremap <F5> :!python main.py<CR>
nnoremap <F6> :!qml main.qml<CR>
nnoremap <F7> :!node main.js<CR>
:colorscheme desert


