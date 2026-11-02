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
    impl = function() cmd 'terminal jj commit' end,
  },
  edit = {
    impl = function(opts) cmd('terminal jj edit "' .. opts.args .. '"') end,
  },
  new = {
    default = {
      impl = function(opts) cmd 'terminal jj new' end,
    },
    dev = {

      impl = function(opts) cmd 'terminal jj new dev@origin' end,
    },
  },
  fetch = {
    impl = function(opts) cmd 'terminal jj git fetch' end,
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
-- aliases
subcommand_tbl.b = {
  a = subcommand_tbl.book.advance,
  l = subcommand_tbl.book.list_remote,
  t = subcommand_tbl.book.track,
}
subcommand_tbl.f = subcommand_tbl.fetch
subcommand_tbl.n = {
  default = subcommand_tbl.new.default,
  d = subcommand_tbl.new.dev,
}
subcommand_tbl.e = subcommand_tbl.edit
subcommand_tbl.c = subcommand_tbl.commit

local function resolve(fargs)
  local current = subcommand_tbl
  local args = {}
  for i, key in ipairs(fargs) do
    if current[key] and current[key].impl then
      args = vim.list_slice(fargs, i + 1)
      return current[key], args
    elseif current[key] then
      current = current[key]
    else
      return nil, nil
    end
  end
  if current.default and current.default.impl then return current.default, {} end
  return nil, nil
end

function M.setup()
  local function jj_cmd(opts)
    local fargs = opts.fargs
    local subcommand, args = resolve(opts.fargs)
    if not subcommand then
      vim.notify('Unknown jj subcommand: ' .. table.concat(opts.fargs, ' '), vim.log.levels.ERROR)
      return
    end
    subcommand.impl { fargs = args }
  end

  vim.api.nvim_create_user_command('JJ', jj_cmd, {
    nargs = '*',
    desc = 'Jujutsu commands',
    complete = function(arg_lead, cmdline, _)
      local rest = cmdline:match 'JJ[!]*%s*(.*)$'
      if not rest then return {} end
      local words = {}
      for w in rest:gmatch '%S+' do
        table.insert(words, w)
      end
      local current = subcommand_tbl
      for _, w in ipairs(words) do
        if current[w] then current = current[w] end
      end
      return vim.iter(vim.tbl_keys(current)):filter(function(k) return k:find(arg_lead) ~= nil and k ~= 'default' end):totable()
    end,
  })
end

return M
