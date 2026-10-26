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
  },
  commit = {
    impl = function(opts) cmd('terminal jj commit -m "' .. table.concat(opts.fargs, ' ') .. '"') end,
  },
  edit = {
    impl = function(opts) cmd('terminal jj edit "' .. opts.args .. '"') end,
  },
  new = {
    impl = function(opts) cmd 'terminal jj new' end,
  },
  fetch = {
    impl = function(opts) cmd 'terminal jj git fetch' end,
  },
  new_dev = {
    impl = function(opts)
      vim.cmd '!jj git fetch'
      cmd 'terminal jj new dev@origin'
    end,
  },
  push_prev = {
    impl = function() cmd 'terminal jj git push --revision @-' end,
  },
  book = {
    advance = {
      impl = function(opts) cmd('terminal jj bookmark advance "' .. opts.args .. '"') end,
    },
    list_remote = {
      impl = function() cmd 'terminal jj bookmark list --remote origin --sort author-date- --no-pager' end,
    },
    track = {
      impl = function(opts) cmd('terminal jj bookmark track "' .. opts.args .. '"') end,
    },
  },
}

function M.setup()
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

  vim.api.nvim_create_user_command('jj', jj_cmd, {
    nargs = '*',
    desc = 'Jujutsu commands',
    complete = function(arg_lead, cmdline, _)
      local subcmd_key = cmdline:match "^['<,'>]*JJ[!]*%s+(%S*)$"
      if subcmd_key then
        return vim.iter(vim.tbl_keys(subcommand_tbl)):filter(function(k) return k:find(arg_lead) ~= nil end):totable()
      end
      return {}
    end,
  })
end

return M
