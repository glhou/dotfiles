local M = {}

local SHELL_NAME = ':shell'

local shell_buf = nil
local previous_win = nil

local function get_shell_buf()
  if shell_buf and vim.api.nvim_buf_is_valid(shell_buf) then return shell_buf end

  local buf = vim.fn.bufnr(SHELL_NAME)
  shell_buf = buf > 0 and buf or nil

  return shell_buf
end

local function valid_buf(buf) return buf and vim.api.nvim_buf_is_valid(buf) end

local function valid_win(win) return win and vim.api.nvim_win_is_valid(win) end

local function is_stale(buf)
  return valid_buf(buf)
    and vim.bo[buf].buftype ~= 'terminal'
    and vim.api.nvim_buf_line_count(buf) == 1
    and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ''
end

local function switch_to_previous()
  if valid_win(previous_win) then
    vim.api.nvim_set_current_win(previous_win)
    return
  end

  vim.cmd.wincmd 'p'
end

local function create_shell()
  local original_buf = vim.api.nvim_get_current_buf()

  vim.cmd.terminal()

  shell_buf = vim.api.nvim_get_current_buf()

  vim.bo[shell_buf].scrollback = -1
  vim.bo[shell_buf].buflisted = false

  vim.api.nvim_buf_set_name(shell_buf, SHELL_NAME)

  -- Remove the temporary alternate terminal buffer if it exists.
  local alternate = vim.fn.bufnr '#'
  if alternate > 0 and alternate ~= shell_buf then pcall(vim.api.nvim_buf_delete, alternate, { force = true }) end

  -- Restore the original buffer as the alternate buffer.
  if valid_buf(original_buf) then vim.fn.setreg('#', original_buf) end

  vim.keymap.set('t', '<C-s>', function()
    local keys = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true)

    vim.api.nvim_feedkeys(keys, 'n', false)

    vim.schedule(function() M.toggle(0, false) end)
  end, {
    buffer = shell_buf,
    desc = 'Toggle shell',
  })
end

local function close_shell_tab_if_needed()
  local tab = vim.api.nvim_get_current_tabpage()
  local shell_win = vim.api.nvim_get_current_win()
  local shell_tab = vim.api.nvim_get_current_tabpage()

  local current_tab_number = vim.api.nvim_tabpage_get_number(shell_tab)

  switch_to_previous()

  if
    vim.api.nvim_tabpage_is_valid(tab)
    and vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage()) ~= current_tab_number
    and #vim.api.nvim_tabpage_list_wins(tab) == 1
  then
    pcall(vim.api.nvim_tabpage_close, tab, false)
  end

  if valid_win(shell_win) then
    -- The shell might still be displayed in another window.
    if vim.api.nvim_get_current_buf() == shell_buf then
      local windows = vim.fn.win_findbuf(shell_buf)

      for _, win in ipairs(windows) do
        if valid_win(win) and win ~= shell_win then
          vim.api.nvim_set_current_win(win)
          if vim.api.nvim_get_current_buf() ~= shell_buf then break end
        end
      end
    end
  end
end

function M.toggle(count, here)
  count = count or 0
  here = here or false

  local buf = get_shell_buf()

  -- Open the existing shell in the current window.
  if valid_buf(buf) and here then
    vim.api.nvim_win_set_buf(0, buf)
    vim.bo[buf].buflisted = false
    previous_win = vim.api.nvim_get_current_win()
    return
  end

  -- Currently inside the shell: return to the previous window.
  if buf and vim.api.nvim_get_current_buf() == buf then
    local shell_win = vim.api.nvim_get_current_win()
    local shell_tab = vim.api.nvim_get_current_tabpage()

    close_shell_tab_if_needed()

    if vim.api.nvim_get_current_buf() == buf then
      -- Find another non-shell window in the current tab.
      local windows = vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())

      for _, win in ipairs(windows) do
        if vim.api.nvim_win_get_buf(win) ~= buf then
          vim.api.nvim_set_current_win(win)
          break
        end
      end
    end

    if vim.api.nvim_get_current_buf() == buf then
      if is_stale(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
        shell_buf = nil
        return M.toggle(count, here)
      end

      return
    end

    previous_win = shell_win
    return
  end

  local current_win = vim.api.nvim_get_current_win()

  if not valid_buf(buf) then
    -- Create a new shell.
    if not here then
      if count == 0 then
        vim.cmd 'tab split'
      else
        vim.cmd(count .. 'split')
      end
    end

    create_shell()
  else
    -- Prefer the previous window when it still displays the shell.
    if count == 0 and valid_win(previous_win) and vim.api.nvim_win_get_buf(previous_win) == buf then
      vim.api.nvim_set_current_win(previous_win)
    else
      local win = vim.fn.bufwinid(buf)

      if count == 0 and win > 0 then
        -- Shell exists in the current tab.
        vim.api.nvim_set_current_win(win)
      else
        local windows = vim.fn.win_findbuf(buf)

        if count == 0 and #windows > 0 then
          -- Shell exists in another tab.
          vim.api.nvim_set_current_win(windows[1])
        else
          -- Shell is hidden; open it in a new tab or split.
          if count == 0 then
            vim.cmd 'tab split'
          else
            vim.cmd(count .. 'split')
          end

          vim.api.nvim_win_set_buf(0, buf)
        end
      end
    end

    vim.bo[buf].buflisted = false

    -- Clean up stale buffers restored by sessions.
    if is_stale(buf) then
      switch_to_previous()
      vim.api.nvim_buf_delete(buf, { force = true })
      shell_buf = nil
      return M.toggle(count, here)
    end
  end

  previous_win = current_win
end

-- Clean up the shell buffer when Neovim exits.
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    local buf = get_shell_buf()

    if valid_buf(buf) then pcall(vim.api.nvim_buf_delete, buf, { force = true }) end
  end,
})

vim.keymap.set('n', '<C-s>', function() M.toggle(vim.v.count, false) end, {
  desc = 'Toggle shell',
})

vim.keymap.set('n', '`<C-s>', function() M.toggle(vim.v.count, true) end, {
  desc = 'Open shell in current window',
})

return M
