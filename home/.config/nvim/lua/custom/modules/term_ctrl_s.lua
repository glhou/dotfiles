local M = {}

local shell_buf = nil
local prev_win = nil

local function valid_buf(buf) return buf and vim.api.nvim_buf_is_valid(buf) end

local function valid_win(win) return win and vim.api.nvim_win_is_valid(win) end
