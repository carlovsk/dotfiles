set nocompatible
set showcmd
set number
set linebreak
set textwidth=100
set showmatch
set visualbell
set hlsearch
set smartcase
set ignorecase
set incsearch
set autoindent
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2
set tabstop=2
set noexpandtab
set ruler
set undolevels=1000
set backspace=indent,eol,start
filetype off                  " required
set encoding=UTF-8


call plug#begin('~/.vim/plugged')

" Plug 'ryanoasis/vim-devicons' " Does not work properly on Ubuntu
Plug 'sheerun/vim-polyglot'
Plug 'w0rp/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'

call plug#end()            " required

"Search for files inside project
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>

" Navigation for vim windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

autocmd vimenter * NERDTree

" Lightline
set laststatus=2
if !has('gui_running')
  set t_Co=256
endif
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }
