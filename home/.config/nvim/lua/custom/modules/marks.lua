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

local function update(bufnr)
  vim.fn.sign_unplace(GROUP, { buffer = bufnr })

  for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
    local name = mark.mark

    if name:match "^'[a-zA-Z]$" then
      local letter = name:sub(2)
      local line = mark.pos[2]

      vim.fn.sign_place(0, GROUP, SING_PREFIX .. letter, bufnr, { lnum = line, priority = 10 })
    end
  end
  -- Global marks: A-Z
  for _, mark in ipairs(vim.fn.getmarklist()) do
    local letter = mark.mark:match "^'([A-Z])$"

    if letter and mark.pos[1] == bufnr then vim.fn.sign_place(0, GROUP, SING_PREFIX .. letter, bufnr, { lnum = mark.pos[2], priority = 10 }) end
  end
end

local function switchMarks()
  local low = function(i) return string.char(97 + i) end
  local upp = function(i) return string.char(65 + i) end

  for i = 0, 25 do
    vim.keymap.set('n', 'm' .. low(i), 'm' .. upp(i))
    vim.keymap.set('n', 'm' .. upp(i), 'm' .. low(i))
    vim.keymap.set('n', '`' .. low(i), '`' .. upp(i))
    vim.keymap.set('n', '`' .. upp(i), '`' .. low(i))
  end
end

--- @param opts struct{}
function M.setup(opts)
  opts = opts or {}
  local switch_marks = opts.switch_marks or ""
  switchMarks()
  vim.opt.signcolumn = 'yes:1'
  define_sings()
  local group = vim.api.nvim_create_augroup(GROUP, {})
  vim.api.nvim_create_autocmd({
    'BufEnter',
    'BufLeave',
    'MarkSet',
  }, {
    group = group,
    callback = function(args) update(args.buf) end,
  })
end

return M
