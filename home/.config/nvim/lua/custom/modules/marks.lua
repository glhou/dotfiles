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

function M.setup()
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
