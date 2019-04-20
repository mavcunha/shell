" automatic runtime management (https://github.com/tpope/vim-pathogen)
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

syntax on
filetype plugin indent on

set incsearch   " show search results as I type.
set ignorecase  " ignore case on searches...
set smartcase   " ...but if I start with uppercase, obey it.
set number      " always display line numbers
set modelines=3 " scan 3 lines for vim opts
set ruler       " show ruler with filename & cursor position
set hlsearch    " search is highlighted, nohlsearch do disable
set cursorline  " set a highlight on the line where the cursor is
set showcmd     " show partial command entered
set visualbell  " no beeps when I make a mistakes
set background=dark " need bright colors since terminal background is black
set hidden      " don't bug me with modified buffers when switching
set switchbuf=useopen " if buffer is opened focus on it
set wrap        " wrap by default

" proper behavior of DEL, BS, CTLR-w; otherwise you can't BS after an ESC
set backspace=eol,start,indent

" from gary bernhardt - store temp files in a central spot
" first dir found is used.
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" ignoring some files in selecta search
set wildignore+=*.class,*.jar " Java artifact
set wildignore+=target/** " Maven artifacts
set wildignore+=_site/** " Jekyll artifact
set wildignore+=tmp/**,log/** " rails working directories
set wildignore+=vendor/** " where gems usually get installed
set wildignore+=node_modules/** " Just too many files on node
set wildignore+=jspm_packages/** " Same as above...

set laststatus=2 " always show statusline even on sigle window
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" no tabs, expand them to 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

set scrolloff=6 " leave some room when jumping

" OmniCompletion settings
set omnifunc=syntaxcomplete#Complete
set completeopt=menu,preview,longest

" Exuberant ctags + git templates
set tags=.git/tags

" save files when suspending with CTRL-Z
map <C-z> :wa\|:suspend<cr>

" Edit vimrc and reload it, from Derek Wyatt
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" quick switch between alternate buffer
nnoremap <leader><leader> <c-^>
" rename current file
nnoremap <leader>n :call RenameFile()<cr>
" remove all trailing whitespace violations
nnoremap <leader>w :%s/\s\+$//<bar>normal <C-o><cr>

" File selection using selecta
nnoremap <leader>t :exec ":e " SelectaCommand(FindWithWildignore())<cr>
nnoremap <leader>b :exec ":e " SelectaCommand(ListActiveBuffers())<cr>

" search google for links and filter results through selecta
inoremap <c-l> <c-r>=SearchGoogleSelecta()<cr>

" from gary bernhardt, tab or completion
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" this is a fix for a bad default in Java syntax file
" which highlights C++ keywords as errors
let java_allow_cpp_keywords=1

" tell sh.vim that every shell file is a bash file
let g:is_bash=1

" Force write when open readonly files
command! SudoWrite :w !sudo tee %

" Set current buffer as a rspec target to be run by CSE
command! RSpecThis call SetRSpecTarget(@%)

" Set CSE to whatever...
command! -nargs=* QuickCSE call QuickCSE(<q-args>)

" Connect to running REPL
command! ClojureLive call ClojureLive()
" Start a REPL, uses tpope/dispatch plugin
command! StartRepl exec "Start! lein repl"

" custom auto commands
augroup customAutocmd
  " clear auto commands in this group
  autocmd!

  " Do not use return to clear search on command
  " and quickfix windows.
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  autocmd CmdwinEnter * nnoremap <cr> <cr>
  autocmd CmdwinLeave * call MapCR()

  " originally .md is for modula2, I use for markdown format
  autocmd BufNewFile,BufRead *.md set filetype=markdown

  " Default to Perl6 instead of Perl5 filetype
  autocmd BufNewFile,BufRead *.t,*.pm,*.pl set filetype=perl6

  " Color ()[]{} on clojure files
  autocmd FileType clojure call LoadRainbowParentheses()

  " Turn spell on for git commits
  autocmd FileType gitcommit set spell

  " keep cursor position,
  " ref: https://github.com/garybernhardt/dotfiles/blob/master/.vimrc line 87
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

" Keybase - saltpack
augroup SALTPACK
  au!
  " Make sure nothing is written to ~/.viminfo
  au BufReadPre,FileReadPre *.saltpack set viminfo=
  " No other files with unencrypted info
  au BufReadPre,FileReadPre *.saltpack set noswapfile noundofile nobackup

  " Reading Files, assumes you can decrypt
  " STDERR redirect to get rid of "message authored by"
  au BufReadPost,FileReadPost *.saltpack :%!keybase decrypt 2> /dev/null

  " Writing requires users
  au BufWritePre,FileReadPre *.saltpack let b:usernames = get(b:, 'usernames', 'mvaltas' )

  au BufWritePre,FileReadPre *.saltpack :exec "%!keybase encrypt " . b:usernames
  au BufWritePost,FileReadPost *.saltpack u
augroup END

" Make (){}[] colorful, from rainbow_parentheses plugin
function! LoadRainbowParentheses()
  RainbowParenthesesLoadRound
  RainbowParenthesesLoadSquare
  RainbowParenthesesLoadBraces
  RainbowParenthesesActivate
endfunction

" Connects to a REPL inspecting .nrepl-port
" uses fireplace.vim
function! ClojureLive()
  let port_file = "./.nrepl-port"
  if !filereadable(port_file)
    echoerr "nREPL not running, use :StartRepl"
  else
    let nrepl_port = join(readfile(port_file),"\n")
    echom "Connecting..."
    exec "Connect nrepl://localhost:" . nrepl_port . " " . getcwd()
  endif
endfunction

" clear search when hit 'return' in normal mode
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()

function! InsertTabWrapper()
    let col = col('.') - 1
    if col && getline('.')[col - 1] == '='
      return "> "
    elseif !col || getline('.')[col - 1] !~ '\k'
      return "\<tab>"
    else
      return "\<c-p>"
    endif
endfunction

" from gary bernhardt, rename file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
      :w!
      exec ':saveas ' . new_name
      exec ':silent !rm ' . old_name
      exec ':silent bwipe ' . old_name
      redraw!
    endif
endfunction

" CSE means Clear Screen and Execute, use it by
" mapping (depending of the project) to a test runner command
" map <leader>r CSE('rspec', '--color')<cr>
function! CSE(runthis, ...)
  :wa
  exec ':!clear && tput cup 1000 0;' . a:runthis . ' ' . join(a:000, ' ')
endfunction

" Sets a file to be run with CSE by rspec on map <leader>r
function! SetRSpecTarget(file)
  exec "map <leader>r :call CSE('bundle exec rspec " . a:file . "')<cr>"
endfunction

" Quick CSE
function! QuickCSE(cmd)
  exec "map <leader>r :call CSE(\"". a:cmd ."\")<cr>"
endfunction

" Run a given vim command on the results of fuzzy selecting from a given shell
" command.
function! SelectaCommand(choice_command)
  try
    let selection = system(a:choice_command . " | selecta ")
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return ""
  endtry
  redraw!
  return selection
endfunction

" Creates an input (list of) of active buffers to be
" filtered by Selecta
function! ListActiveBuffers()
  let bufferlist = []
  for l:bni in range(bufnr("$"), 1, -1)
    if buflisted(l:bni)
      call add(bufferlist, bufname(l:bni))
    endif
  endfor
  return "echo ".join(bufferlist, ' ')." | tr ' ' '\\n' "
endfunction

" Creates a find command ignoring paths and files set in wildignore
function! FindWithWildignore()
  let excluding=""
  for entry in split(&wildignore,",")
    let excluding.= (match(entry,'*/*') ? " ! -ipath \'" : " ! -iname \'") . entry . "\' "
  endfor
  return "find * -type f \\\( " . excluding . " \\\)"
endfunction

" Request user input and search google filtered by selecta
function! SearchGoogleSelecta()
  call inputsave()
  let search = input("Search Google for: ")
  call inputrestore()
  let search_cmd = "googlesearch " . search ." | jq '.items[].link' | tr -d '\"' "
  return substitute(SelectaCommand(search_cmd), '\n$', '', '')
endfunction

" OSX QuickLook file
function! QuickLookThis(file)
  exec "!qlmanage -p ". a:file . " &> /dev/null "
endfunction

" Run and Preview, this function just helps
" when editing lilypond, LaTex or other which
" creates files visible through QuickLook
function! RunAndPreview(runthis, file)
  call CSE(a:runthis)
  call QuickLookThis(a:file)
  redraw! " executing with :silent
endfunction

" arrows disabled on insert and normal mode
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" highlight trailing whitespaces
highlight link ExtraWhiteSpace Error
match ExtraWhiteSpace /\s\+$/
" some color changes
highlight Pmenu      ctermfg=Black ctermbg=LightGrey
highlight PmenuSel   ctermfg=Black ctermbg=Yellow
highlight PmenuSbar  ctermfg=Black ctermbg=LightGrey
highlight PmenuThumb ctermfg=DarkGrey
highlight Visual     ctermfg=Black ctermbg=White cterm=NONE
highlight Search     ctermfg=White ctermbg=Magenta
highlight IncSearch  ctermfg=Blue ctermbg=White
highlight LineNr     ctermfg=Grey
