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

function M.setup()
  vim.api.nvim_create_user_command('Jj', function() cmd 'terminal jj log --color=always --no-pager' end, {
    desc = 'Jj logs',
  })
  vim.api.nvim_create_user_command('JjCommit', function(opts) cmd('terminal jj commit -m "' .. table.concat(opts.fargs, ' ') .. '"') end, {
    nargs = '*',
    desc = 'Jj commit with message',
  })
  vim.api.nvim_create_user_command('JjEdit', function(opts) cmd('terminal jj edit "' .. opts.args .. '"') end, {
    nargs = 1,
    desc = 'Jj edit',
  })
  vim.api.nvim_create_user_command('JjNew', function(opts) cmd 'terminal jj new' end, {
    desc = 'Jj new',
  })
  vim.api.nvim_create_user_command('JjFetch', function(opts) cmd 'terminal jj git fetch' end, {
    desc = 'Jj git fetch',
  })
  vim.api.nvim_create_user_command('JjNewDev', function(opts)
    vim.cmd '!jj git fetch'
    cmd 'terminal jj new dev@origin'
  end, {
    desc = 'Jj new dev',
  })
  vim.api.nvim_create_user_command('JjBookAdv', function(opts) cmd('terminal jj bookmark advance "' .. opts.args .. '"') end, {
    nargs = '?',
    desc = 'Jj bookmark advance',
  })
  vim.api.nvim_create_user_command('JjPushPrev', function() cmd 'terminal jj git push --revision @-' end, {
    desc = 'Jj push previous revision',
  })
  vim.api.nvim_create_user_command('JjBookRemote', function() cmd 'terminal jj bookmark list --remote origin --sort author-date- --no-pager' end, {
    desc = 'Jj remote bookmarks',
  })
  vim.api.nvim_create_user_command('JjBookTrack', function(opts) cmd('terminal jj bookmark track "' .. opts.args .. '"') end, {
    nargs = 1,
    desc = 'Jj remote bookmarks',
  })
end

return M
