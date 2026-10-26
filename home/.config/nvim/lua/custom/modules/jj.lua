-- lua/custom/modules/jj.lua
local M = {}

local cmd_win

--- @param cmd string
function cmd(cmd)
  if cmd_win and vim.api.nvim_win_is_valid(cmd_win) then
    vim.api.nvim_set_current_win(cmd_win)
  else
    vim.cmd 'botright new'
    cmd_win = vim.api.nvim_get_current_win()
  end
  vim.cmd(cmd)
  vim.keymap.set('t', 'q', '<C-\\><C-n><cmd>close<CR>', {
    buffer = 0,
    desc = 'Close cmd',
  })
  vim.keymap.set('t', '<Esc>', '<C-\\><C-n><cmd>close<CR>', {
    buffer = 0,
    desc = 'Close cmd',
  })
  vim.keymap.set('n', 'q', '<cmd>close<CR>', {
    buffer = 0,
    desc = 'Close cmd',
  })
  vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', {
    buffer = 0,
    desc = 'Close cmd',
  })
end

local subcommand_tbl = {
  default = {
    impl = function() cmd 'terminal jj log --color=always --no-pager' end,
    opts = { desc = 'Jj logs' },
  },
  commit = {
    impl = function(opts) cmd('terminal jj commit -m "' .. table.concat(opts.fargs, ' ') .. '"') end,
    opts = {
      nargs = '*',
      desc = 'Jj commit with message',
    },
  },
  edit = {
    impl = function(opts) cmd('terminal jj edit "' .. opts.args .. '"') end,
    opts = {
      nargs = 1,
      desc = 'Jj edit',
    },
  },
  new = {
    impl = function(opts) cmd 'terminal jj new' end,
    opts = {
      desc = 'Jj new',
    },
  },
  fetch = {
    impl = function(opts) cmd 'terminal jj git fetch' end,
    opts = {
      desc = 'Jj git fetch',
    },
  },
  new_dev = {
    impl = function(opts)
      vim.cmd '!jj git fetch'
      cmd 'terminal jj new dev@origin'
    end,
    opts = {
      desc = 'Jj new dev',
    },
  },
  book_adv = {
    impl = function(opts) cmd('terminal jj bookmark advance "' .. opts.args .. '"') end,
    opts = {
      nargs = '?',
      desc = 'Jj bookmark advance',
    },
  },
  push_prev = {
    impl = function() cmd 'terminal jj git push --revision @-' end,
    opts = {
      desc = 'Jj push previous revision',
    },
  },
  book_list_remote = {
    impl = function() cmd 'terminal jj bookmark list --remote origin --sort author-date- --no-pager' end,
    opts = {
      desc = 'Jj remote bookmarks',
    },
  },
  book_track = {
    impl = function(opts) cmd('terminal jj bookmark track "' .. opts.args .. '"') end,
    opts = {
      nargs = 1,
      desc = 'Jj remote bookmarks',
    },
  },
}

function M.setup() end
local function jj_cmd(opts)
  local fargs = opts.fargs
  local subcommand_key = fargs[1] or 'default'
  local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}

  local subcommand = subcommand_tbl[subcommand_key]
  if not subcommand then
    vim.notify('Unknown jj subcommand: ' .. subcommand_key, vim.log.levels.ERROR)
    return
  end
  subcommand.impl { fargs = args }
end

return M
