" Python 3 host provider
let g:python3_host_prog = '/home/mj/.pyenv/versions/nvim/bin/python3'

" Config Section
if (has("termguicolors"))
  set termguicolors
endif

set autoindent
set expandtab
syntax enable
set tabstop=4
set softtabstop=4

" ALE fixers configuration
let g:ale_fixers = {
\ '*': ['trim_whitespace', 'remove_trailing_lines'],
\ 'python': ['isort', 'autoflake', 'black'],
\ 'javascript': ['eslint', 'prettier'],
\ 'html': ['prettier'],
\ 'css': ['prettier'],
\ 'rust': ['rustfmt'],
\ 'sh': ['shfmt'],
\}

let g:ale_linters = {
\ 'python': ['flake8', 'mypy', 'jedils'],
\ 'javascript': ['eslint'],
\ 'html': ['htmlhint'],
\ 'css': ['stylelint'],
\ 'rust': ['rustc'],
\ 'sh': ['shellcheck'],
\}

let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_python_flake8_options = '--max-line-length=88'

" Plugin Section
call plug#begin("~/.vim/plugged")
  Plug 'Shougo/deoplete.nvim',
  Plug 'mattn/emmet-vim'
  Plug 'deoplete-plugins/deoplete-jedi'
  Plug 'dense-analysis/ale'
  Plug 'lambdalisue/suda.vim'
call plug#end()

" Enable Deoplete
let g:deoplete#enable_at_startup = 1

" Emmet settings
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" Keymap Section
set mouse=a
let mapleader = ","

" Fast saving and quitting
nmap <leader>w :w!<cr>                  " Save the current buffer
nmap <leader>q :qa<cr>                  " Quit all buffers
nmap <C-s> :w!<cr>                      " Ctrl+s to save
nmap <C-d> :qa<cr>                      " Ctrl+d to quit all

" ALE keymaps
nmap <C-b> :ALEGoToDefinition<cr>       " Ctrl+b for go to definition
nmap <C-p> :ALEFindReferences<cr>       " Ctrl+p for find references

" Copy and paste to system clipboard
noremap <C-c> "+y
noremap <C-y> "+p

" Select all
nmap <C-q> ggvGg_

" Command for elevated save (sudo save)
command! W execute 'SudaWrite'

" Auto-read when a file changes externally
set autoread
au FocusGained,BufEnter * checktime

" Auto SudaRead when read/write not allowed
let g:suda_smart_edit = 1

" Set cursor color
augroup CursorColor
  autocmd!
  autocmd VimEnter,Colorscheme * highlight Cursor guifg=NONE guibg=#FF00FF
  autocmd VimEnter,Colorscheme * highlight iCursor guifg=NONE guibg=#00ff00
augroup END
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver25-iCursor

set background=dark
:highlight Normal guibg=NONE ctermbg=NONE

" End of configuration
