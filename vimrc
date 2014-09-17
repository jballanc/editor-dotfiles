set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting
filetype off          " Disable filetype detection to keep Vundle happy
set shiftwidth=2      " That's a good tab width
set expandtab         " ...and we don't like tab chars
set ts=8              " The only tabs we encounter should be in C code
set softtabstop=2
set tw=90             " 90 chars fits two columns on my screen
set wrap
set fdm=syntax        " Use syntax to define folding
set fdls=99           " ...but start off unfolded
set autoread          " Reread files when they change (i.e. git update)
set incsearch         " Jump to search results
set laststatus=2      " Always display the status line
set dir=~/.vim/swap   " Put all the swap files in .vim/swap
set mouse+=a          " Enable mouse selection and scrolling in Vim in iTerm
set ttymouse=xterm2   " Extended mouse support for window resizing in tmux
set tags=tags,ctags   " Sometimes we need an alternate tag file name
set cedit=<C-t>       " The Vim default of C-F doesn't seem to work

" Start up Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" Github Repos
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'guns/vim-clojure-static'
Plugin 'guns/vim-slamhound'
Plugin 'JuliaLang/julia-vim'
Plugin 'jpalardy/vim-slime'
Plugin 'kchmck/vim-coffee-script'
Plugin 'nvie/vim-flake8'
Plugin 'Raimondi/delimitMate'
Plugin 'rking/ag.vim'
Plugin 'Rykka/riv.vim'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-leiningen'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'typedclojure/vim-typedclojure'
Plugin 'vim-ruby/vim-ruby'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-lua-inspect'

" vim-scripts repos
Plugin 'bufexplorer.zip'
Plugin 'camelcasemotion'
Plugin 'cocoa.vim'
Plugin 'lua.vim'
Plugin 'matchit.zip'
Plugin 'The-NERD-tree'
Plugin 'omlet.vim'
Plugin 'paredit.vim'
Plugin 'speeddating.vim'
Plugin 'YankRing.vim'

call vundle#end()

" Cursor shape for iTerm (with TMUX fix)
if !has('gui_running')
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
end

" Font and colorscheme
set gfn=Menlo:h11
let g:solarized_style="dark"
let g:solarized_termcolors=16
set t_Co=16
colorscheme solarized
hi cursor guifg=lightgoldenrod

" Quick light/dark color scheme switching
function! ToggleView()
  if (g:solarized_style=="dark")
    let g:solarized_style="light"
    set gfn=Menlo:h22
    colorscheme solarized
  else
    let g:solarized_style="dark"
    set gfn=Menlo:h11
    colorscheme solarized
    hi cursor guifg=lightgoldenrod,reverse
  endif
endfunction
nnoremap <F6> :call ToggleView()<CR>
inoremap <F6> <ESC>:call ToggleView()<CR>a
vnoremap <F6> <ESC>:call ToggleView()<CR>

" Reveal tabs and trailing whitespace
set listchars=tab:»·,trail:·
set list

" Disable scrollbars and toolbar in MacVim
set go-=T
set go-=r
set go-=L

" Ctrl-s for easier escaping
nnoremap <C-s> <Esc>
vnoremap <C-s> <Esc>gV
onoremap <C-s> <Esc>
inoremap <C-s> <Esc>`^
cnoremap <C-s> <C-c>

" Remap leader
let mapleader = ","

" Useful function for displaying highlight group
nmap <leader>h :call SynStack()<CR>
function! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Readline cursor movement in insert mode
noremap! <C-a> <home>
noremap! <C-e> <end>
noremap! <C-f> <right>
noremap! <C-b> <left>
noremap! <C-h> <backspace>
noremap! <C-d> <delete>

" Prevent mistyped :W and :Q
command! W w
command! Q q

" Quick way through the fix list
nnoremap <silent> <Leader>n :cn<CR>
nnoremap <silent> <Leader>p :cp<CR>

" MacVim independent tab controls
nnoremap <silent> <Leader>to :tabnew<CR>
nnoremap <silent> <Leader>tn :tabnext<CR>
nnoremap <silent> <Leader>tp :tabprev<CR>
nnoremap <silent> <Leader>tx :tabclose<CR>

"Open tags in new tabs
nnoremap <silent> <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" Remap navigation keys with C-w prefix
let g:tmux_navigator_no_mappings = 1

nmap <silent> <C-w>h :TmuxNavigateLeft<CR>
nmap <silent> <C-w>j :TmuxNavigateDown<CR>
nmap <silent> <C-w>k :TmuxNavigateUp<CR>
nmap <silent> <C-w>l :TmuxNavigateRight<CR>
nmap <silent> <C-w>w :TmuxNavigatePrevious<CR>

" Use JSHint for Javascript syntax checking
let g:syntastic_javascript_checkers = ['jshint']

" Vim-Slime should use tmux
let g:slime_target = 'tmux'

" Customize delimitMate
set backspace=indent,eol,start
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_balance_matchpairs = 1
au FileType clojure let b:delimitMate_quotes = "\""

" Customize YankRing
let g:yankring_history_file = '.yankring_history'

" Customize luainspect
map <silent> <leader>rn :call xolox#luainspect#make_request('rename')<CR>
let g:lua_inspect_warnings = 0

" Customize CamelCaseMotion
map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

" Customize fold line
function! FoldText()
  let indent_level = strlen(v:folddashes) - 1
  let indent_width = (indent_level * shiftwidth()) - 1
  let indent = "+" . repeat(" ", indent_width)
  let start_line = substitute(getline(v:foldstart), "^\\s*", "", "")
  let elipsis = "..."
  let end_line = substitute(getline(v:foldend), "^\\s*", "", "")
  return indent . start_line . elipsis . end_line
endfunction

set foldtext=FoldText()

" Customize paredit
let g:paredit_smartjump = 1
let g:paredit_electric_return = 1

" Customize for Clojure
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let']
let g:clojure_align_multiline_strings = 1
let g:clojure_fold = 1

" SLIME-like controls for Clojure
nnoremap <silent> <leader>f :Require<CR>
nnoremap <silent> <leader>F :Require!<CR>
function! GotoNamespace()
  execute "SlimeSend1 (clojure.core/in-ns '".fireplace#ns().")"
endfunction
nnoremap <silent> <leader>g :call GotoNamespace()<CR>

" Remove / from keyword char list for better tag jumping in Clojure
autocmd FileType clojure setlocal iskeyword-=/

" Ruby indentation should be 2
autocmd FileType ruby setlocal tabstop=2

" Python, JS, and Java use a different indentation standard
autocmd Filetype python,javascript,java setlocal shiftwidth=4 softtabstop=4

" Python standard is 79 columns
autocmd Filetype python setlocal textwidth=79

" Spelling for Markdown files
autocmd Filetype markdown setlocal spell

" Git commit formatting
autocmd Filetype gitcommit setlocal spell textwidth=72

" For NeoVim only:
if has('neovim')
  " Start python support
  runtime! plugin/python_setup.vim
  set unnamedclip
endif

" Now that setup is done...
filetype indent plugin on    " Enable filetype specific indenting and plugins
