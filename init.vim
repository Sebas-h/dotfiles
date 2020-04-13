" The following way, all runtime files and packages in ~/.vim will be loaded by Neovim. Any customisations you make in your ~/.vimrc will now apply to Neovim as well as Vim.
" >> uncomment the following commands
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc

" run ex commands defined in given file (can also use 'source' command,
" instead of runtime)
"runtime test.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PLUGINS  (using vim-plug)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('data') . '/plugged')

" Make sure you use single quotes !

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Adds syntax highlighting for Elm
Plug 'andys8/vim-elm-syntax'

" Nerdtree
Plug 'preservim/nerdtree'

" Vim plugin for fzf fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Commands to comment and uncomment blocks of text
Plug 'tpope/vim-commentary'

" Sets the statusline
Plug 'bling/vim-airline'

" Initialize plugin system
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set Leaders
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = " "
" Set local leader (specific leader mappings for each filetype)
let maplocalleader = "\\" " just single backslash, first blackslash escapes

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Define colorscheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colo delek
set bg=dark
syntax on
" Horizontal split splits below
set splitbelow
" Vertical split splits right
set splitright


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Taken from: https://www.barbarianmeetscoding.com/blog/2019/01/24/wizards-use-vim-getting-started-with-vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Tab Completion
set wildmode=list:longest " Setup Tab completion to work like in a shell

""" Search
set ignorecase   " case-insensitive search
set smartcase    " but case-sensitive if expression contains a capital letter

""" Buffers
set hidden       " Handle multiple buffers better
" You can abandon a buffer with unsaved changes without a warning

""" Terminal
set title        " show terminal title

""" Editor
set scrolloff=3  " show 3 lines of context around cursor
set list         " show invisible characters

""" Global Tabs and Spaces configurations
set expandtab    " use spaces instead of tabs
set tabstop=4    " global tab width
set shiftwidth=4 " spaces to use when indenting

" Tab is 4 spaces:
set softtabstop=4
" Line numbers relative + currently shows global line number
set number relativenumber

" autoindent next line same level as previous one
set autoindent
" When wrapping a line make in visually indent
set breakindent

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mapping Keys
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Remappings Insert Mode
" inoremap jk <Esc>
" inoremap JK <Esc>
" inoremap kj <Esc>
" inoremap KJ <Esc>
nnoremap J 5j
nnoremap K 5k

" nnoremap <C-q> ZQ
" nnoremap <C-x> ZZ

" Play macro 'q' with Q
nnoremap Q @q

" Delete seach highlighting with ESC
nnoremap <esc> :noh<return><esc>

" join lines control-j (by default it is 'J')
nnoremap <C-j> :join<return>

" Write current buffer (i.e. save file) mapping
" It is not possible to map the CMD key <D- on macOS.
"nnoremap <C-s> :w<CR>
nnoremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>

""" Escape In Terminal Mode
tnoremap <Esc> <C-\><C-n>
tnoremap <M-[> <Esc>
"tnoremap <C-v><Esc> <Esc>

""" Switch Windows
" Terminal mode:
tnoremap <M-h> <c-\><c-n><c-w>h
tnoremap <M-j> <c-\><c-n><c-w>j
tnoremap <M-k> <c-\><c-n><c-w>k
tnoremap <M-l> <c-\><c-n><c-w>l
" Insert mode:
inoremap <M-h> <Esc><c-w>h
inoremap <M-j> <Esc><c-w>j
inoremap <M-k> <Esc><c-w>k
inoremap <M-l> <Esc><c-w>l
" Visual mode:
vnoremap <M-h> <Esc><c-w>h
vnoremap <M-j> <Esc><c-w>j
vnoremap <M-k> <Esc><c-w>k
vnoremap <M-l> <Esc><c-w>l
" Normal mode:
nnoremap <M-h> <c-w>h
nnoremap <M-j> <c-w>j
nnoremap <M-k> <c-w>k
nnoremap <M-l> <c-w>l

""" Switching Tabs
" Normal mode
nnoremap <Tab>h gT
nnoremap <Tab>l gt

" NERDTree
nnoremap <Leader>f :NERDTreeToggle<Enter>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove Highlight After Search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps ctrl-L to clearing last search highlighting
"   silent supresses output of function
"http://stackoverflow.com/questions/657447/vim-clear-last-search-highlighting#answer-25569434
" nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
" to do: changes backkground color of the search I am on from all highlighted
" search mathes, i.e. all matches bg=yellow, current match bg=blue  ... or smt

" * to search word underneath the cursor
" augroup vimrc-incsearch-highlight
"     autocmd!
"     autocmd CmdlineEnter /,\? :set hlsearch
"     autocmd CmdlineLeave /,\? :set nohlsearch
" augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AUTORELOAD ON CHANGE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
  \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REMOVE TRAILING WHITESPACE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" One way to make sure to remove all trailing whitespace in a file is to set an autocmd in your .vimrc file. Every time the user issues a :w command, Vim will automatically remove all trailing whitespace before saving.
" autocmd BufWritePre * %s/\s\+$//e
" However, this is a potentially dangerous autocmd to have as it will always strip trailing whitespace from every file a user saves. Sometimes, trailing whitespace is desired, or even essential in a file so be careful when implementing this autocmd.

" A user can also specify a particular filetype in an autocmd so that only that filetype will be changed when saving. The following only changes files with the extension .pl:
" autocmd BufWritePre *.pl %s/\s\+$//e
" Easy align markdown table with "|" char when on table
au FileType markdown map <Bar> vip :EasyAlign*<Bar><Enter>

" Allow netrw to remove non-empty local directories
let g:netrw_localrmdir='rm -r'

" Add vim-commentary symbols for filetypes
autocmd FileType elm setlocal commentstring=\-\-\ %s
