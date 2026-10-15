--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- ============================================================
-- SECTION 1: OPTIONS
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- [[ Setting options ]]
  -- See `:help vim.o`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- Don't store backup while overwriting the file
  vim.o.backup = false
  vim.o.writebackup = false

  -- Enable all filetype plugins
  vim.cmd 'filetype plugin indent on'

  -- # Appearance
  vim.o.breakindent = true -- Enable break indent
  vim.o.cursorline = true -- Show which line your cursor is on
  vim.o.linebreak = true
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.numberwidth = 5
  vim.o.splitbelow = true -- Horizontal splits will be below
  vim.o.splitright = true -- Vertical splits will be to the right

  vim.o.ruler = false -- Don't show cursor position in command line
  vim.o.showmode = false -- Don't show mode in command line
  vim.o.wrap = true -- Display long lines as multiple lines

  vim.o.signcolumn = 'yes' -- Keep signcolumn on by default
  vim.o.fillchars = 'eob: ' -- Don't show `~` outside of buffer

  vim.opt.colorcolumn = '88'

  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true

  vim.o.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor.

  vim.o.inccommand = 'split' -- Preview substitutions live, as you type!

  vim.o.foldmethod = 'indent' -- folding
  vim.o.foldenable = false -- folding
  vim.o.foldlevelstart = 99 -- folding

  -- # Editing
  vim.o.ignorecase = true -- Ingore case when searching (use `\C` to force not doing that)
  vim.o.incsearch = true -- Show search results while typing
  vim.o.infercase = true -- Infer letter cases for a richer built-in keyword completion
  vim.o.smartcase = true -- Don't ignore case when search if pattern has upper case
  vim.o.smartindent = true -- Make indenting smart

  vim.o.completeopt = 'menuone,noselect' -- Customize completions
  vim.o.virtualedit = 'block' -- Allow going past the end of line in visual block mode
  vim.o.formatoptions = 'qjl1' -- Don't autoformat comments

  vim.o.splitkeep = 'screen'

  -- # Opinioneted
  vim.o.pumblend = 0 -- Make builtin completion menus slightly transparent
  vim.o.pumheight = 10 -- Make popup menu smaller
  vim.o.winblend = 0 -- Make floating windows slightly transparents

  -- NOTE: Having `tab` present is needed because `^I` will be shown if
  -- omitted (documented in `:h listchars`).
  -- Having it equal to a default value should be less intrusive.
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  if vim.fn.exists 'syntax_on' ~= 1 then vim.cmd [[syntax enable]] end

  ----

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = true
end

-- ============================================================
-- SECTION 2: KEYMAPS
-- basic keymaps
-- ============================================================
do
  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic Config & Keymaps
  -- See :help vim.diagnostic.Opts
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = false, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines
    signs = true,

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = { float = true },
  }

  -- Override htmldjango detection for .html files with Jinja
  vim.filetype.add {
    extension = {
      html = 'html',
    },
  }

  -- Smoother incremental selection
  vim.keymap.set('x', 'v', function() require('vim.treesitter._select').select_parent() end)

  vim.keymap.set('x', '<BS>', function() require('vim.treesitter._select').select_child() end)

  -- Oil keymap
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

  -- Vim diagnostics
  vim.keymap.set('n', '<leader>cd', function() vim.diagnostic.setloclist() end, { desc = 'Open diagnostic is loclist' })

  -- Move
  vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
  vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })

  vim.keymap.set('n', 'H', '25zh', { noremap = true, silent = true, desc = 'Scroll left' })
  vim.keymap.set('n', 'L', '25zl', { noremap = true, silent = true, desc = 'Scroll right' })

  vim.keymap.set({ 'n', 'x' }, 'gh', '0', { desc = 'jump to the begining of the line' })
  vim.keymap.set({ 'n', 'x' }, 'gl', '$', { desc = 'jump to the end of the line' })
  vim.keymap.set({ 'n', 'x' }, 'gs', '^', { desc = 'jump to the start of the line' })

  vim.keymap.set('n', '<leader>fn', ':enew<CR>', { desc = 'New file' })

  vim.keymap.set('n', '<leader>W', ':noautocmd w<CR>', { desc = 'Save no formatting' })

  vim.keymap.set('n', '<leader>bd', function()
    local current = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_delete(current, { force = false })
  end, { desc = 'Delete current buffer' })
  vim.keymap.set('n', '<leader>bo', function()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then vim.api.nvim_buf_delete(buf, { force = false }) end
    end
  end, { desc = 'Delete other buffer' })
  vim.keymap.set('n', '<leader>bD', function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then vim.api.nvim_buf_delete(buf, { force = false }) end
    end
  end, { desc = 'Delete all buffers' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  vim.keymap.set('t', '<C-w>w', '<C-\\><C-o><C-w>w<Esc>', { desc = 'Next window in terminal mode' })
  vim.keymap.set('t', '<C-w><C-w>', '<C-\\><C-o><C-w>w<Esc>', { desc = 'Next window in terminal mode' })

  -- Remove some default lsp keymaps
  vim.keymap.del('n', 'gra')
  vim.keymap.del('n', 'grn')
  vim.keymap.del('n', 'grt')
  vim.keymap.del('n', 'gri')
  vim.keymap.del('n', 'grr')
  vim.keymap.del('n', 'grx')

  -- TIP: Disable arrow keys in normal mode
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  -- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  -- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  -- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  -- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
  -- vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
  -- vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
  -- vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
  -- vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

  -- Custom command to open notes file
  vim.api.nvim_create_user_command('Notes', function() vim.cmd.edit(vim.fn.expand '~/notes.md') end, { desc = 'Open shared note file' })

  -- Custom python json parser
  vim.api.nvim_create_user_command('PythonJson', function() require('custom.functions.clean_python_json').python_pretty_json() end, {
    desc = 'Transform selected Python dict into json',
    range = true,
  })

  -- Custom command to get github review comments in quicklist
  vim.api.nvim_create_user_command('PRComments', function() require('custom.functions.github_pr').get_pr_comments() end, {
    desc = 'Open GitHub PR view comments of current branch',
  })

  -- Custom command to edit macros

  vim.api.nvim_create_user_command('EM', function(opts)
    if opts.args == '' then
      vim.notify('Usage: :EM <register>', vim.log.levels.ERROR)
      return
    end
    local reg = opts.args
    local macro = vim.fn.getreg(reg)
    if macro == '' then
      vim.notify(('Register "%s" is empty'):format(reg), vim.log.levels.WARN)
      return
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(vim.fn.keytrans(macro), '\n'))
    vim.bo[buf].buftype = 'acwrite'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].swapfile = false
    vim.api.nvim_set_current_buf(buf)

    vim.notify('q/Esc to quit | Enter to save', vim.log.levels.INFO)

    vim.keymap.set('n', 'q', '<cmd>bd!<cr>', { buffer = buf })
    vim.keymap.set('n', '<Esc>', '<cmd>bd!<cr>', { buffer = buf })

    vim.keymap.set('n', '<CR>', function()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local text = table.concat(lines, '\n')

      vim.fn.setreg(reg, vim.api.nvim_replace_termcodes(text, true, true, true))

      vim.cmd 'bd!'
    end, { buffer = buf })
  end, {
    nargs = 1,
    desc = 'Edit macro register in a temporary buffer',
  })

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  -- textDocument/rename triggers an event
  local orig_rename = vim.lsp.handlers['textDocument/rename']
  vim.lsp.handlers['textDocument/rename'] = function(err, result, ctx, config)
    orig_rename(err, result, ctx, config)
    if not err and result then vim.schedule(function() vim.api.nvim_exec_autocmds('User', { pattern = 'LspRenameDone' }) end) end
  end

  -- Autosave hidden buffers
  local function save_buf(buf)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    if vim.bo[buf].buftype == '' and vim.bo[buf].modified and vim.fn.filereadable(vim.fn.bufname(buf)) == 1 then
      vim.api.nvim_buf_call(buf, function() vim.cmd 'silent! update' end)
    end
  end
  -- save on hide/focus lost
  vim.api.nvim_create_autocmd({ 'BufHidden', 'FocusLost' }, {
    pattern = '*',
    callback = function(args) save_buf(args.buf) end,
    desc = 'Auto-save on hide or focus lost',
  })

  -- save all touched bufs after LSP rename
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspRenameDone',
    callback = function()
      vim.schedule(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          save_buf(buf)
        end
      end)
    end,
    desc = 'Auto-save all bufs after LSP rename',
  })
end

-- ============================================================
-- SECTION 3: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
  -- [[ Intro to 'vim.pack']]
  --  In this section we set up some autocommands to run build
  --  steps for certain plugins after they are installed or updated.
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local strout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local king = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end
      if name == 'telescope-fzf-native.nvia' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
  -- vim.pack.add{gh 'NMAC427/guess-indent.nvim'}
  -- require('guess-indent').setup{}

  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
  }

  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    -- delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },

    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]est' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>b', group = '[B]uffer' },
      { '<leader>g', group = '[G]it' },
      { '<leader>u', group = '[U]i' },
      { '<leader>f', group = '[F]ile' },
    },
  }

  -- [[ mini.nvim ]]
  -- A collection of various small independent plugins/modules
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  if vim.g.have_nerd_font then
    require('mini.icons').setup()
    MiniIcons.mock_nvim_web_devicons()
  end

  -- require('mini.notify').setup {
  --   lsp_progress = {
  --     enable = false,
  --   },
  -- }
  require('vim._core.ui2').enable {
    enable = true,
    msg = {
      targets = {
        default = 'cmd',
        progress = 'msg',
      },
    },
  }

  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yinq - [Y]ank [I]nside [N]ext [Q]uot
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup {
    n_lines = 500,
  }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup()

  local hipatterns = require 'mini.hipatterns'
  hipatterns.setup {
    highlighters = {
      todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
      wip = { pattern = '%f[%w]()WIP()%f[%W]', group = 'MiniHipatternsWip' },
      fix = { pattern = '%f[%w]()FIX()%f[%W]', group = 'MiniHipatternsFix' },
      warn = { pattern = '%f[%w]()WARN()%f[%W]', group = 'MiniHipatternsWarn' },

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  }

  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }

  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end
  require('mini.pairs').setup()
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
do
  -- [[ Fuzzy Finder (files, lsp ,etc) ]]
  --
  -- Telescope is a fuzzy finder that comes with a lot of different things that
  -- it can fuzzy find! It's more than just a "file finder", it can search
  -- many different aspects of Neovim, your workspace, LSP, and more!
  --
  -- There are lots of other alternative pickers (like snacks.picker, or fzf-lua)
  -- so feel free to experiment and see what you like!
  --
  -- The easiest way to use Telescope, is to start by doing something like:
  --  :Telescope help_tags
  --
  -- After running this command, a window will open up and you're able to
  -- type in the prompt window. You'll see a list of `help_tags` options and
  -- a corresponding preview of the help.
  --
  -- Two important keymaps to use while in Telescope are:
  --  - Insert mode: <c-/>
  --  - Normal mode: ?
  --
  -- This opens a window that shows you all of the keymaps for the current
  -- Telescope picker. This is really useful to discover what Telescope can
  -- do as well as how to actually do it!
  ---@type (string|vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
  }
  if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

  vim.pack.add(telescope_plugins)

  require('telescope').setup {
    -- You can put your default mappings / updates / etc. in here
    --  All the info you're looking for is in `:help telescope.setup()`
    --
    -- defaults = {
    --   mappings = {
    --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
    --   },
    -- },
    -- pickers = {}
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }

  -- Enable Telescope extensions if they are installed
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[F]ind [F]iles' })
  --vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader>,', builtin.buffers, { desc = '[ ] Find existing buffers' })

  -- Add Telescope-base LSP pickers when and LSP attaches to a buffer.
  -- If you later switch picker plugins, this is where to update these mappings.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      -- Find references for the word under your cursor.
      vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

      -- Jump to the implementation of the word under your cursor.
      -- Useful when your language has ways of declaring types without an actual implementation.
      vim.keymap.set('n', 'gI', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

      -- Jump to the definition of the word under your cursor.
      -- This is where a variable was first declared, or where a function is defined, etc.
      -- To jump back, press <C-t>.
      vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

      -- Fuzzy find all the symbols in your current document.
      -- Symbols are things like variables, functions, types, etc.
      vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

      -- Fuzzy find all the symbols in your current workspace.
      -- Similar to document symbols, except searches over your entire project.
      vim.keymap.set('n', '<leader>sS', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

      -- Jump to the type of the word under your cursor.
      -- Useful when you're not sure what type a variable is and you want to see
      -- the definition of its *type*, not where it was *defined*.
      vim.keymap.set('n', 'gy', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto t[Y]pe Definition' })

      -- Rename var under cursor.
      vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, {
        buffer = buf,
        desc = '[C]ode [R]ename',
      })

      -- Execute code action
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {
        buffer = buf,
        desc = '[C]ode [A]ction',
      })
    end,
  })

  -- Override default behaviour and theme when searching
  vim.keymap.set(
    'n',
    '<leader>b/',
    function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end,
    { desc = '[/] Fuzzily search in current buffer' }
  )
  -- It's also possible to pass additional configuration options.
  -- See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set(
    'n',
    '<leader>s/',
    function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end,
    { desc = '[S]each [/] in Open Files' }
  )
  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })
end

-- ============================================================
-- SECTION 6: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
  -- [[ LSP Configuration ]]

  -- Useful status updates for LSP.
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- inlay hints
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        vim.lsp.inlay_hint.enable(true)
        map('<leader>uh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[U]i Toggle Inlay [H]ints')
      end
    end,
  })

  vim.pack.add { gh 'neovim/nvim-lspconfig' }
  -- Enable language servers
  vim.lsp.config('jinja_lsp', {
    filetypes = { 'html', 'jinja' },
  })
  vim.lsp.config('gopls', {
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        codeActionImports = true,
      },
    },
  })
  vim.lsp.config('rust_analyzer', {
    settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = 'clippy' },
      },
    },
  })

  vim.lsp.config('lua_ls', {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
          --  See https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    filetype = { 'lua' },
    settings = {
      Lua = {
        format = { enable = false },
      },
    },
  })

  vim.lsp.enable { 'ruff', 'pyrefly', 'vtsls', 'eslint', 'jinja_lsp', 'gopls', 'rust_analyzer', 'lua_ls' }

  local function lsp_check()
    if vim.fn.executable 'uv' ~= 1 then
      vim.notify "uv isn't installed"
    else
      vim.notify 'uv is installed'
      vim.cmd '!uv tool install ruff'
      vim.cmd '!uv tool install pyrefly'
      vim.cmd '!uv tool install djlint'
      vim.cmd '!uv tool install jinja-lsp'
    end
    if vim.fn.executable 'go' == 1 then
      vim.notify 'go is installed'
    else
      vim.notify "go isn't installed"
    end
    if vim.fn.executable 'rust-analyzer' == 1 then
      vim.notify 'rust-analyzer is installed'
    else
      vim.notify "rust-analyzer isn't installed"
    end
    if vim.fn.executable 'npm' == 1 then
      vim.notify 'npm is installed'
      vim.cmd '!npm install -g @vtsls/language-server typescript'
      vim.cmd '!npm -g eslint vscode-langservers-extracted'
    else
      vim.notify "npm isn't installed"
    end
    if vim.fn.executable 'pgformatter' == 1 then
      vim.notify 'pgformatter is installed'
    else
      vim.notify "pgformatter isn't installed"
    end
    if vim.fn.executable 'stylua' == 1 then
      vim.notify 'stylua is installed'
    else
      vim.notify "stylua isn't installed"
    end
    if vim.fn.executable 'lua-language-server' == 1 then
      vim.notify 'lua_ls is installed'
    else
      vim.notify "lua_ls isn't installed"
    end
  end

  vim.api.nvim_create_user_command('LspCheck', lsp_check, { desc = 'Check that LSP server and tools are installed' })
end

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
  -- [[ Formatting ]]
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
      html = { 'djlint' },
      jinja = { 'djlint' },
      css = { 'prettier' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      json = { 'prettier' },
      sh = { 'shfmt' },
      markdown = { 'prettier', 'markdown-toc', 'markdownlint-cli2' },
      sql = { 'pg_format' },
      go = { 'goimports' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  }
  vim.keymap.set({ 'n', 'v' }, '<leader>cf', function() require('conform').format { async = true } end, { desc = '[C]ode [F]ormat' })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- mini.completion and luasnip setup
-- ============================================================
do
  -- [[ Snippet Engine ]]
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  -- `friendly-snippets` contains a variety of premade snippets.
  --    See the README about individual language/framework/plugin snippets:
  --    https://github.com/rafamadriz/friendly-snippets
  --
  -- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  -- require('luasnip.loaders.from_vscode').lazy_load()
  require('mini.fuzzy').setup {} -- required in fuzzy_filter
  require('mini.completion').setup {}
end

-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
  -- [[ Configure Treesitter ]]
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }
  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'jinja' }
  require('nvim-treesitter').install(parsers)

  vim.treesitter.language.register('html', 'jinja')

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- check if parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- enables syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- enables treesitter based folds
    -- for more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- enables treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- enable the parser if it is installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

-- ============================================================
-- SECTION 10: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug'
  require 'kickstart.plugins.indent_line'
  -- require 'kickstart.plugins.lint'
  -- require 'kickstart.plugins.autopairs'
  -- require 'kickstart.plugins.neo-tree'
  -- require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

  -- NOTE: You can add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  require('custom.modules.jj').setup()
  require('custom.modules.marks').setup()
  require('custom.modules.py_refactory').setup()
  require 'custom.plugins'
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
