-- functions that are not behavior added to the editor
local u = require('utils')

-- shotcuts to common functions
local api = vim.api  -- nvim api access
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn  = vim.fn   -- to call Vim functions e.g. fn.bufnr()
local g   = vim.g    -- a table to access global variables

-- colors
cmd 'colorscheme torte'

-- plugin management
cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself

paq 'tpope/vim-surround'             -- handle surroundings ()[]"'{} as text objects
paq 'wellle/targets.vim'             -- lots of text objects (https://mvaltas.com/targets)
paq 'nvim-telescope/telescope.nvim'  -- File finder w/ popup window and preview support
paq 'nvim-lua/popup.nvim'            -- provides popup window functionality
paq 'nvim-lua/plenary.nvim'          -- collection of Lua functions used by plugins
paq 'nvim-treesitter/nvim-treesitter'-- Configuration and abstraction layer

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
u.opt('w', 'wrap', false)
-- end of general editor options

-- line numbers
u.opt('w', 'number', true)                              -- Print line number
u.opt('w', 'relativenumber', true)                      -- Relative line numbers
-- end line numbers

-- simple maps (no binding with function)
u.map('n', '<leader><leader>', '<c-^>') -- '\\' alternate between buffers
u.map('n', '<cr>', ':nohlsearch<cr>')   -- clear search when hit CR
u.map('', '<C-z>', ':wa|:suspend<cr>')  -- save files when suspending with CTRL-Z
u.map('', 'Q', '<nop>')                 -- disable Ex Mode

-- telescope config
u.map('n','<leader>f',':Telescope find_files<cr>') -- f find files
u.map('n','<leader>b',':Telescope buffers<cr>')    -- b for buffers
u.map('n','<leader>g',':Telescope git_files<cr>')  -- g for git
u.map('n','<leader>d',':Telescope treesitter<cr>') -- d for defs
u.map('n','<leader>l',':Telescope live_grep<cr>')  -- l for live_grep
u.map('n','<leader>a',':Telescope<cr>')            -- a for all

local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
    selection_strategy = "reset",
    layout_strategy = "horizontal",
    shorten_path = true,
    file_sorter = require'telescope.sorters'.get_fzy_sorter,
    file_ignore_patterns = { 
      "build/*", "target/*", "_site/*", "log/*", "tmp/*",
      "vendor/*", "node_modules/*", "jspm_packages/*",
      "%.jar", "%.class", "%.bin",
    },    
  }
}
-- end telescope config

-- treesitter configuration
require('nvim-treesitter.configs').setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers)
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
-- end treesitter configuration

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
-- end of smart_tab

-- shortcut to reload init.lua
cmd 'command! -nargs=0 Init :luafile ~/.config/nvim/init.lua'
cmd 'command! -nargs=0 EInit :e ~/.config/nvim/init.lua'

-- Old implementation of QuickCSE
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
-- end of QuickCSE

-- changes in colors
api.nvim_exec([[
  highlight LineNr guifg=Grey
  highlight TelescopeMatching guifg=Red
]], true) 
-- end changes in colors
