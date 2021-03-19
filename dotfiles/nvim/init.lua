-- functions that are not behavior added to the editor
local u = require('utils')

-- shotcuts to common functions
local api = vim.api  -- nvim api access
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn  = vim.fn   -- to call Vim functions e.g. fn.bufnr()
local g   = vim.g    -- a table to access global variables

-- plugin management
cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself
paq 'sheerun/vim-polyglot'           -- syntax highlighting
paq 'guns/vim-sexp'                  -- precision edit of S-expressions
paq 'tpope/vim-surround'             -- handle surroundings ()[]"'{} as text objects
paq 'wellle/targets.vim'             -- lots of text objects (https://mvaltas.com/targets)

-- colors
cmd 'colorscheme torte'

-- general editor options
local indent = 2
u.opt('b', 'expandtab', true)                           -- Use spaces instead of tabs
u.opt('b', 'shiftwidth', indent)                        -- Size of an indent
u.opt('b', 'smartindent', true)                         -- Insert indents automatically
u.opt('b', 'tabstop', indent)                           -- Number of spaces tabs count for
u.opt('o', 'hidden', true)                              -- Enable modified buffers in background
u.opt('o', 'joinspaces', false)                         -- No double spaces with join after a dot
u.opt('o', 'scrolloff', 4 )                             -- Lines of context
u.opt('o', 'shiftround', true)                          -- Round indent
u.opt('o', 'sidescrolloff', 8 )                         -- Columns of context
u.opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
u.opt('o', 'splitbelow', true)                          -- Put new windows below current
u.opt('o', 'splitright', true)                          -- Put new windows right of current
u.opt('o', 'termguicolors', true)                       -- True color support
u.opt('o', 'wildmode', 'list:longest')                  -- Command-line completion mode
u.opt('w', 'number', true)                              -- Print line number
u.opt('w', 'relativenumber', true)                      -- Relative line numbers
u.opt('w', 'wrap', false)

-- simple maps (no binding with function)
u.map('n', '<leader><leader>', '<c-^>') -- '\\' alternate between buffers
u.map('n', '<cr>', ':nohlsearch<cr>')   -- clear search when hit CR
u.map('', '<C-z>', ':wa|:suspend<cr>')  -- save files when suspending with CTRL-Z
u.map('', 'Q', '<nop>')                 -- disable Ex Mode

-- smart_tab: triggers CTRL-P completion when the
-- character before the cursor is not empty otherwise 
-- just return TAB
function smart_tab()
  local cur_col  = fn.col(".")
  local cur_char = api.nvim_get_current_line():sub(cur_col - 2, cur_col - 1)
  -- %g matches printable character in Lua
  return cur_char:match('%g') and u.t'<c-p>' or u.t'<tab>'
end
-- bind <tab> to smar_tab() function
api.nvim_set_keymap('i', '<tab>', 'v:lua.smart_tab()', {expr = true, noremap = true })

-- shortcut to reload init.lua
cmd 'command! -nargs=0 Init :luafile ~/.config/nvim/init.lua'

--u.map('', '<leader>t', ' v:lua.selecta_open()', {expr = true, noremap = true })
--function selecta_open(args)
--  fn.system('ls -1 | selecta')
--end

api.nvim_exec([[
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
]], true)

cmd 'command! -nargs=* Selecta call SelectaCommand(<q-args>)'

api.nvim_exec([[
" CSE means Clear Screen and Execute, use it by
" mapping (depending of the project) to a test runner command
" map <leader>r CSE('rspec', '--color')<cr>
function! CSE(runthis, ...)
  :wa
  exec ':!' . a:runthis . ' ' . join(a:000, ' ')
endfunction

function! QuickCSE(cmd)
  exec "map <leader>r :call CSE(\"" . a:cmd . "\")<cr>"
endfunction


  ]], true)

cmd 'command! -nargs=* QuickCSE call QuickCSE(<q-args>)'
