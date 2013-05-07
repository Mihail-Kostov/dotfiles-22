""""" My (demuredemeanor) .vimrc
"" Uses shiftwidth=4 tabs; foldmarker={{{,}}};
"" http://github.com/demure/dotfiles

""" Commands at Start """ {{{
	"" This one needs to be first
	set nocompatible				" Choose no comp with legacy vi

	if has("syntax")
		syntax on					" Adds vim color based on file
	endif

	"" Enable filetype settings
	if has("eval")
		filetype on
		filetype plugin on
		"filetype indent on
	endif

	""" Folds Settings """ {{{
	if has("folding")
		set foldenable				" Enable folds
		"" These next two would save which folds are open/close, as well
		"" as view location, but seems to force set foldmethod=indent...
		"au BufWinLeave ?* mkview
		"au BufWinEnter ?* silent loadview
		set foldmethod=marker
		"set foldmarker={,}			" Use '{}'s for folds
		"set foldlevelstart=99		" Effectively disable auto folding
	endif
	""" End Folds Settings """ }}}

	"" Stop auto comment on new line
	autocmd FileType * setlocal formatoptions-=cro
	set shortmess+=T
""" End Commands at Start """ }}}

""" Options """ {{{
	""" Assorted """ {{{
	set autoread					" Reload files changed outside vim
	set encoding=utf8				" Sets encoding View
	set scrolloff=3					" Show next three lines scrolling
	set sidescrolloff=2				" Show next two columns scrolling
	set ttyfast						" Indicates a fast terminal connection
	set splitbelow					" New horizontal splits are below
	set splitright					" New vertical splits are to the right
	""" End Assorted """ }}}

	""" HUD """ {{{
	set number						" Adds line numbers
	set showcmd						" Show incomplete cmds down the bottom
	set showmode					" Shows input or replace mode at bottom
	set ruler						" Show position in bottom right
	""" End HUD """ }}}

	""" Input """ {{{
	set virtualedit=block,onemore	" Cursor can move one past EOL, and free in Visual mode
"	set virtualedit=all				" Allow virtual editing, all modes.
	set mouse=a						" Enable mouse, all modes
	set backspace=indent,eol,start	" Allow backspace in insert mode
	""" End Input """ }}}

	""" Mac kill damn bold """ {{{
	if has('mac')
		set t_Co=256				" FORCE 256 colors in vim
	endif
	""" End Mac """ }}}

	""" Wild Stuffs... """ {{{
	set wildmenu					" Show list instead of just completing
	set wildmode=list:longest,full	" Command <Tab> completion, list matches, then longest common part, then all.
	"" From http://blog.sanctum.geek.nz/lazier-tab-completion/
	if exists("&wildignorecase")
		set wildignorecase			" Ignore case in file name completion
	endif
	"" From http://bitbucket.org/sjl/dotfiles/overview
	set wildignore+=.hg,.git,.svn						" Version control
	set wildignore+=*.aux,*.out,*.toc					" LaTeX intermediate files
	set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg		" binary images
	set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest	" compiled object files
	set wildignore+=*.spl								" compiled spelling word lists
	set wildignore+=*.sw?								" Vim swap files
	set wildignore+=*.DS_Store							" OSX bullshit
	set wildignore+=*.luac								" Lua byte code
	set wildignore+=migrations							" Django migrations
	set wildignore+=*.pyc								" Python byte code
	set wildignore+=*.orig								" Merge resolution files

	"" Clojure/Leiningen
	set wildignore+=classes
	set wildignore+=lib
	""" End Wild """ }}}

	""" Show Hidden Chars """ {{{
	set list						" Shows certain hidden chars
	set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
	""Disabled for Solarized test
	hi NonText ctermfg=darkgray		" Makes trailing darkgray
	hi SpecialKey ctermfg=darkgray	" Makes Leading darkgray
	""" End Hidden Chars """ }}}

	""" Spelling """ {{{
	set spell						" Spelling hilight on
"	highlight SpellBad cterm=underline ctermfg=red
	hi SpellBad cterm=underline ctermbg=NONE
	hi SpellCap cterm=underline ctermbg=NONE
	""" End Spelling """ }}}

	""" Tab Windows """ {{{
	set hidden						" Hides buffers, instead of closing, or forcing save
	set showtabline=2				" shows the tab bar at all times
	set tabpagemax=10				" max num of tabs to open on startup
	hi TabLineSel ctermbg=Yellow	" Current Tab
	hi TabLine ctermfg=Grey ctermbg=DarkGrey	" Other Tabs
	"hi TabLineFill ctermfg=DarkCyan
	hi TabLineFill ctermfg=Black	" Rest of line
	hi Title ctermfg=DarkBlue ctermbg=None	" Windows in Tab
	""" End Tab Windows """ }}}

	""" Tab Key Settings """ {{{
	"" prefer tabs now...
"	set expandtab   "" use spaces, not tabs
	set tabstop=4					" Set Tab length
	set shiftwidth=4				" Affects when you press >>, << or ==. And auto indent.
	set smarttab					" Insert Tabs at ^ per shiftwidth, not tabstop
	set autoindent					" Always set auto indenting on
	set copyindent					" Copy the previous indentation on autoindenting
	""" End Tab Key """ }}}

	""" Searching """ {{{
	" Use real regex search
	nnoremap / /\v
	vnoremap / /\vi
	set hlsearch					" Highlight matches
	set incsearch					" Incremental searching
	set ignorecase					" Searches are case insensitive...
	set smartcase					" ...unless contains oneplus Cap letter
	set showmatch					" Show matching brackets/parenthesis
	set gdefault					" Applies substitutions globally on lines. Append 'g' to invert back. 
	set synmaxcol=800				" Don't highlight lines longer than 800 chars
	""" End Searching """ }}}

	""" Backup Settings """ {{{
		""" Dir Validation """ {{{
		if !isdirectory(expand("~/.vim/back/"))
			call mkdir(expand("~/.vim/back/"), "p")
		endif
		if !isdirectory(expand("~/.vim/swap/"))
			call mkdir(expand("~/.vim/swap/"), "p")
		endif
		if !isdirectory(expand("~/.vim/undo/"))
			call mkdir(expand("~/.vim/undo/"), "p")
		endif
		""" End Dir """ }}}
	set backup						" Enable backups
	set undofile
	set undoreload=10000
	set backupdir=~/.vim/back/
	set directory=~/.vim/swap/		" swap files
	set undodir=~/.vim/undo/		" undo files
	""" End Backup Settings """ }}}
""" End Options """ }}}

""" Key Bindings """ {{{
	let mapleader=","				" Change the mapleader from '\\' to ','
	map <leader>/ :noh<return>		" <leader>/ will clear search hilights!

	""" Quickly edit/reload the vimrc file """ {{{
	""  maps the ,ev and ,sv keys to edit/reload .vimrc.
	nmap <silent> <leader>ev :e $MYVIMRC<CR>
	nmap <silent> <leader>sv :so $MYVIMRC<CR>
	""" End reload """ }}}

	""" Paste Toggle, for stopping formating of pastes """ {{{
	nnoremap <F2> :set invpaste paste?<CR>
	set pastetoggle=<F2>
	nmap <leader>p :set invpaste paste?<CR>
	""" End Paste Toggle """ }}}
 
	""" Vim Tab Window Keysbindings """ {{{
"	nnoremap <C-Left> :tabprevious<CR>
"	nnoremap <C-Right> :tabnext<CR>
"	nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
"	nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>
	""" End Tab Window Keys """ }}}

	""" Navigate Splits """ {{{
	"" uses ',' key first
	map <leader>h :wincmd h<CR>
	map <leader>j :wincmd j<CR>
	map <leader>k :wincmd k<CR>
	map <leader>l :wincmd l<CR>

	map <leader> <Left> :wincmd h<CR>
	map <leader> <Down> :wincmd j<CR>
	map <leader> <Up> :wincmd k<CR>
	map <leader> <Right> :wincmd l<CR>
	""" End Navigate Splits """ }}}

	""" Toggle RelativeNumber """ {{{
	"" Using number.vim now
	"function! g:NumberToggle()
		"if(&relativenumber == 1)
			"setlocal number
		  "else
			"setlocal relativenumber
		"endif
	"endfunc

	"nnoremap <leader>n :call g:NumberToggle()<CR>

	"" Switch to f num key...
	nnoremap <keader>n :NumbersToggle<CR>
	""" End Toggle RelativeNumber """ }}}

	""" Toggle colorcolumn """ {{{
	highlight ColorColumn ctermbg=Brown
	function! g:ToggleColorColumn()
		if &colorcolumn != ''
			setlocal colorcolumn&
		  else
			setlocal colorcolumn=77
		endif
	endfunction
 
	nnoremap <silent> <leader>l :call g:ToggleColorColumn()<CR>
	""" End Toggle colorcolumn """ }}}

	""" Cross Hairs """ {{{
	hi CursorLine   cterm=NONE ctermbg=darkgrey ctermfg=white guibg=darkred guifg=white
	hi CursorColumn cterm=NONE ctermbg=darkgrey ctermfg=white guibg=darkred guifg=white
	nnoremap <Leader>+ :set cursorline! cursorcolumn!<CR>
    """ End Cross Hair """ }}}
""" End Key Bindings """ }}}

""" Plugins """ {{{
	""" Setting up Vundle """ {{{
	"" From http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
	let iCanHazVundle=1
	let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
	if !filereadable(vundle_readme)
		echo "Installing Vundle.."
		echo ""
		silent !mkdir -p ~/.vim/bundle
		silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
		let iCanHazVundle=0
	endif
	set rtp+=~/.vim/bundle/vundle/
	call vundle#rc()
	"" Use git instead of http 
	let g:vundle_default_git_proto = 'git'
	Bundle 'gmarik/vundle'
	""Add your bundles here
	Bundle 'scrooloose/nerdtree'
	Bundle 'tpope/vim-repeat'
	Bundle 'Rainbow-Parenthsis-Bundle'
	Bundle 'scrooloose/nerdcommenter'
	Bundle 'YankRing.vim'
	"Bundle 'altercation/vim-colors-solarized'
	Bundle 'tpope/vim-fugitive'
	"Bundle 'SearchComplete'		"" Disabled due to killing UP arrow in search
	Bundle 'bufexplorer.zip'
	Bundle 'Gundo'
	Bundle 'scrooloose/syntastic'
	Bundle 'uguu-org/vim-matrix-screensaver'
	"" vim-indent-guides default binding: <Leader>ig
	Bundle 'mutewinter/vim-indent-guides'
	Bundle 'myusuf3/numbers.vim'
	"" <prefix><prefix>motion
	Bundle 'Lokaltog/vim-easymotion'
	""...All your other bundles...
	if iCanHazVundle == 0
		echo "Installing Bundles, please ignore key map error messages"
		echo ""
		:BundleInstall
	endif
	""" End Setting Up Vundle """ }}}

	""" NERDtree config """ {{{
	"" Starts NERDtree if no file is give to vim at start 
	autocmd vimenter * if !argc() | NERDTree | endif
	""" End NERDtree """ }}}

	""" Vim Repeat Conf """ {{{
	"" This is to make repeat work for plugins too
	silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
	""" End Vim Repeat """ }}}

	""" Rainbow Parenthesis Conf """ {{{
	nmap <prefix>[ :ToggleRaibowParenthesis <CR>
	""" End Rainbow Parenthesis """ }}}

	""" YankRing Conf """ {{{
	nnoremap <silent> <F3> :YRShow<CR>
	inoremap <silent> <F3> <ESC>:YRShow<CR>
	map <silent> <prefix>y :YRShow<CR>
	let g:yankring_history_dir = '~/.vim'
	""" End YankRing """ }}}

	""" Solarized Theme """ {{{
	"call togglebg#map("<F6>")
	"if has('gui_running')
		"set background=light
	  "else
		"set background=dark
	"endif
	"colorscheme solarized
	""" End Solarized """ }}}

	""" Gundo Conf """ {{{
	nnoremap <F5> :GundoToggle<CR>
	""" End Gundo """ }}}
""" End Plugins """ }}}

""" Notes To Self """ {{{
"" Consider:
	"" Time out on key codes but not mappings.
	"" Basically this makes terminal Vim work sanely.
	"set notimeout
	"set ttimeout
	"set ttimeoutlen=10
""" End Notes """ }}}
