"
" ~/.config/nvim/init.vim
"

"==============================================================================
" Edit settings
"==============================================================================
syntax on
set number			" display line number on the left
set wrap			" visually wrap lines
set linebreak			" line wrap at `breakat` instead of last character
set background=dark		" use dark background
set mouse=a			" always enables mouse
set smartindent                 " smart autoindenting
set fileencoding=utf-8		" utf-8 encoding
set encoding=utf-8		" utf-8 encoding
set wildmenu			" better command line completion
set wildmode=longest,list	" better unix-like tab completion
set clipboard=unnamedplus	" clipboard support
set termguicolors		" true colors
set laststatus=1		" no status when only 1 window
set backspace=indent,eol,start	" allow backspacing over autoindent, line breaks and start of insert action
set nostartofline		" vertical goto preserves horizontal position
set ignorecase			" use case insensitive search
set smartcase			" except using capital letters
set guicursor+=o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175

"==============================================================================
" Backup and undo
"==============================================================================
if empty($XDG_DATA_HOME)
	let $XDG_DATA_HOME = $HOME . '/.local/share'
endif
set backupdir=$XDG_DATA_HOME/nvim/backup
set backup			" keep a backup file (restore to previous version)
if has('persistent_undo')
	set undofile		" keep an undo file (undo changes after closing)
endif


"==============================================================================
" FileType
"==============================================================================
if exists('g:vscode')
	" skip
else
	" FileType detection
	autocmd BufNewFile,BufRead *.S setlocal filetype=asm
	autocmd BufNewFile,BufRead *.lds setlocal filetype=ld
	autocmd BufNewFile,BufRead *.sig,*.cm setlocal filetype=sml
	autocmd BufNewFile,BufRead *.cls setlocal filetype=tex

	" Strip whitespace from end of lines when writing file
	autocmd FileType python,c,cpp,java,sml,tex,systemverilog,markdown,markdown,arm,asm,vim autocmd BufWritePre * :%s/\s\+$//e
	" Strip empty line from end of files when writing file
	autocmd FileType python,c,cpp,java,sml,tex,systemverilog,markdown,markdown,arm,asm,vim autocmd BufWritePre * :%s/\($\n\s*\)\+\%$//e

	" FileType specific format
	autocmd FileType python,c,cpp,java,sml,tex,systemverilog,markdown setlocal expandtab
	autocmd FileType python,c,cpp,java,sml,tex setlocal shiftwidth=4 softtabstop=4 tabstop=4
	autocmd FileType sml    setlocal shiftwidth=2 softtabstop=2 tabstop=2 textwidth=0
	autocmd FileType systemverilog    setlocal shiftwidth=2 softtabstop=2 tabstop=2
	autocmd FileType arm,asm    setlocal shiftwidth=8 softtabstop=8 tabstop=8 noexpandtab
	autocmd FileType c,cpp setlocal syntax+=.doxygen cindent cinoptions=g2,h2,N-s,E-s,i2s,+2s,(0,u0,U1,w1,W2s,ks

	" FileType specific comments (both ends)
	autocmd FileType sml   map <buffer> ,c :s/^\(.*\)$/\(\* \1 \*\)/<CR> <Esc>:nohlsearch<CR>
	autocmd FileType html  map <buffer> ,c :s/^\(.*\)$/\/\* \1 \*\//<CR> <Esc>:nohlsearch<CR>
	autocmd FileType sml,html map <buffer> ,C :s/^\([/(]\*\\|<!--\) \(.*\) \(\*[/)]\\|-->\)$/\2/<CR> <Esc>:nohlsearch<CR>

	" FileType specific comments (one end)
	autocmd FileType c,cpp,java,arm,asm	  map <buffer> ,c :s/^/\/\//<CR> <Esc>:nohlsearch <CR>
	autocmd FileType python,sh,make,conf map <buffer> ,c :s/^/#/<CR> <Esc>:nohlsearch <CR>
	autocmd FileType vim map <buffer> ,c :s/^/\"/<CR> <Esc>:nohlsearch <CR>
	autocmd FileType sql map <buffer> ,c :s/^/--/<CR> <Esc>:nohlsearch <CR>
	autocmd FileType tex map <buffer> ,c :s/^/%/<CR> <Esc>:nohlsearch <CR>
	autocmd FileType c,cpp,java,python,sh,make,conf,vim,sql,tex,arm,asm map <buffer> ,C :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR> <Esc>:nohlsearch<CR>

	" FileType specific format
	autocmd FileType c,cpp map <buffer> <F3> m1 :%!clang-format<CR> `1

	" FileType specific folding mathods
	autocmd FileType c,cpp,java,tex,vim,xml,html setlocal foldmethod=syntax
	autocmd FileType python setlocal foldmethod=indent
	autocmd Filetype c,cpp,java,tex,vim,xml,html,python normal zi

	" FileType specific settings
	autocmd FileType text,markdown setlocal spell
endif

"==============================================================================
" Utilities
"==============================================================================
if exists('g:vscode')
	" skip
else
	" last-position-jump
	autocmd BufReadPost *
				\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
				\ |   exe "normal! g`\""
				\ | endif

	" Create directory when save
	autocmd BufWritePre *
				\ if !isdirectory(expand("<afile>:h")) |
				\ call mkdir(expand("<afile>:h"), "p") |
				\ endif

	" Key mapping
	:inoremap <S-Tab> <C-V><Tab>
endif

"==============================================================================
" Plugins
"==============================================================================
if exists('g:vscode')
	" skip
else
	call plug#begin($XDG_DATA_HOME.'/plugged')
	Plug 'embear/vim-localvimrc'
	Plug 'autozimu/LanguageClient-neovim', {
				\ 'branch': 'next',
				\ 'do': 'bash install.sh',
				\ }
	Plug 'neomake/neomake'
	Plug 'tveskag/nvim-blame-line'
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	call plug#end()

	" localvimrc settings
	let g:localvimrc_persistent = 1
	let g:localvimrc_event = [ "BufWinEnter", "BufReadPre" ]

	" deoplete
	let g:deoplete#enable_at_startup = 1

	" language servers
	" required for operations modifying multiple buffers like rename.
	set hidden
	let g:LanguageClient_serverCommands = {
				\ 'c': ['clangd', '--background-index',],
				\ 'cpp': ['clangd', '--background-index',],
				\ 'python': ['pyls'],
				\ 'tex': ['texlab'],
				\ 'sh': ['bash-language-server', 'start'],
				\ }
	let g:LanguageClient_rootMakers = ['.project', '.root']
	" language client key bindings
	nnoremap <F5> :call LanguageClient_contextMenu()<CR>
	nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
	nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
	nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
	" language client settings
	set completeopt-=preview
	autocmd QuitPre * if &filetype !=# 'qf' | lclose | endif

	" neomake
	call neomake#configure#automake({
				\ 'BufWritePost':          {},
				\ 'BufWinEnter':           {},
				\ 'FileType':              {},
				\ 'FileChangedShellPost':  {},
				\ 'TextChanged':           {'delay': 10000},
				\ 'InsertLeave':           {'delay': 10000},
				\ }, 0)
	let g:neomake_open_list = 2
	let g:neomake_echo_current_error = 1
	let g:neomake_virtualtext_current_error = 1
	let g:neomake_serialize = 1
	let g:neomake_cpp_enabled_makers = ['clang', 'clangtidy', 'clangcheck', 'cpplint']
	let g:neomake_cpp_clang_args = ['-fsyntax-only', '--language=c++', '-Wall', '-Wextra', '-pedantic', '-std=c++2a']
	let g:neomake_cpp_cpplint_args = '--filter=-build/header_guard,-build/include,-build/c++11,-legal/copyright,-runtime/references,-whitespace/tab,-whitespace/indent'
	let g:neomake_python_enabled_makers = ['python', 'mypy', 'pylint']
	let g:neomake_markdown_enabled_makers = ['markdownlint']
	let g:neomake_tex_enabled_makers = ['lacheck']

	" blame-line
	let g:blameLineUseVirtualText = 1
	let g:blameLineVirtualTextHighlight = 'Question'
	let g:blameLineVirtualTextPrefix = '  ❯ '
	let g:blameLineGitFormat = '%an - %s'

endif
