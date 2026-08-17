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

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

nmap <C-n> :NERDTreeToggle<CR> 
nmap <C-s> <Esc>:w<CR>
nmap <C-k> :NERDTreeFocus<CR>
nmap <C-x> <Esc>:x<CR>

:set ts=4
:set autoindent
:set cindent
:set number

"nnoremap <F8> <Esc>
inoremap jk <Esc>
nnoremap .. :
"nnoremap 77 /
"nnoremap ++ ~
"nnoremap ßß \
"nnoremap 22 "
"nnoremap 11 !

" Markdown Preview
let g:mkdp_port = '3000'
let g:mkdp_echo_preview_url = 1

nnoremap <silent> <C-p> :MarkdownPreviewToggle<CR>
nnoremap <silent> <M-p> :MarkdownPreviewStop<CR>

let mapleader = " "

let g:vimwiki_list = [{
	\ 'path': '/c/Users/maikt/Desktop/Midnight-Walker/vimwiki',
	\ 'syntax': 'markdown',
	\ 'ext': '.md'
	\ }]
let g:vimwiki_list[0].diary_rel_path = '10\ Journal/Daily/'
nnoremap <leader>ts i<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR><Esc>
vnoremap <C-y> :w !xclip -selection clipboard<CR>
nnoremap <F5> :!python "%"<CR>
nnoremap <F6> :!qml main.qml<CR>
nnoremap <F7> :!node main.js<CR>
:colorscheme desert

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

":belowright 12new | terminal ++curwin
autocmd VimEnter * NERDTreeToggle | wincmd p
nnoremap <leader>t :belowright 12new \| terminal ++curwin<CR>
inoremap <leader>pic <img src="https://picsum.photos/id/" alt=""><Left><Left><Left><Left><Left><Left><Left><Left><Left>

if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->['clangd']},
            \ 'allowlist': ['c', 'cpp'],
            \ })
    augroup END
endif

let g:asyncomplete_auto_popup = 1

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap gd :LspDefinition<CR>
nnoremap K :LspHover<CR>
imap <S-Tab> <Plug>(emmet-expand-abbr)
" Speichern / Beenden
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Suchmarkierung entfernen
nnoremap <leader>n :nohlsearch<CR>
" Fenster wechseln
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

nnoremap <leader>s :split<CR>
nnoremap <leader>v :vsplit<CR>
