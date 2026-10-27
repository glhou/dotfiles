local M = {}

local GROUP = 'custom_marks'
local SING_PREFIX = 'CustomMarks_'

local function define_sings()
  for i = string.byte 'a', string.byte 'z' do
    local letter = string.char(i)

    vim.fn.sign_define(SING_PREFIX .. letter, {
      text = letter,
      texthl = 'Special',
    })
  end
  for i = string.byte 'A', string.byte 'Z' do
    local letter = string.char(i)

    vim.fn.sign_define(SING_PREFIX .. letter, {
      text = letter,
      texthl = 'Special',
    })
  end
end

local function update(bufnr, enable_switch_marks)
  vim.fn.sign_unplace(GROUP, { buffer = bufnr })

  for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
    local name = mark.mark

    if name:match "^'[a-zA-Z]$" then
      local letter = name:sub(2)
      local line = mark.pos[2]

      print(letter, line, name)

      if enable_switch_marks then local letter = letter:match '%l' and letter:upper() or letter:lower() end

      print(letter, line, name)

      vim.fn.sign_place(0, GROUP, SING_PREFIX .. letter, bufnr, { lnum = line, priority = 10 })
    end
  end
  -- Global marks: A-Z
  for _, mark in ipairs(vim.fn.getmarklist()) do
    local letter = mark.mark:match "^'([A-Z])$"

    if letter == nil then continue end

    if enable_switch_marks then local letter = letter:match '%l' and letter:upper() or letter:lower() end

    if letter and mark.pos[1] == bufnr then vim.fn.sign_place(0, GROUP, SING_PREFIX .. letter, bufnr, { lnum = mark.pos[2], priority = 10 }) end
  end
end

local function switch_mark(char)
  vim.keymap.set('n', char, function()
    local c = vim.fn.getcharstr()
    if c == nil then return end
    if c:match '%l' then
      vim.cmd('normal! ' .. char .. c:upper())
    elseif c:match '%u' then
      vim.cmd('normal! ' .. char .. c:lower())
    end
  end)
end

local function switch_marks()
  switch_mark 'm'
  switch_mark '`'
end

---@class MarkOpts
---@field switch_marks boolean switches upper and lower case marks

--- @param opts MarkOpts?
function M.setup(opts)
  opts = opts or {}
  local enable_switch_marks = opts.switch_marks or true
  if enable_switch_marks then switch_marks() end
  vim.opt.signcolumn = 'yes:1'
  define_sings()
  local group = vim.api.nvim_create_augroup(GROUP, {})
  vim.api.nvim_create_autocmd({
    'BufEnter',
    'BufLeave',
    'MarkSet',
  }, {
    group = group,
    callback = function(args) update(args.buf, enable_switch_marks) end,
  })
end

return M
