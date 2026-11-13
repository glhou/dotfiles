local M = {}

local shell_buf = nil
local prev_win = nil

local function valid_buf(buf) return buf and vim.api.nvim_buf_is_valid(buf) end

local function valid_win(win) return win and vim.api.nvim_win_is_valid(win) end

local function create_shell()
  vim.cmd.terminal()

  shell_buf = vim.api.nvim_get_current_buf()

  vim.bo[shell_buf].scrollback = -1
  vim.api.nvim_buf_set_name(shell_buf, ':shell')
  vim.bo[shell_buf].buflisted = false

  vim.keymap.set('t', '<C-s>', function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true), 'n', false)
    M.toggle(0, false)
  end, { buffer = shell_buf })
end

function M.toggle(count, here)
  -- Implementation
end
