local M = {}

function M.python_pretty_json()
  local start = vim.fn.getpos "'<"
  local finish = vim.fn.getpos "'>"

  local lines = vim.api.nvim_buf_get_lines(0, start[2] - 1, finish[2], false)

  local input = table.concat(lines, '\n')

  local cmd = {
    'python3',
    '-c',
    [[
    import ast, json, sys
    obj = ast.literal_eval(sys.stdin.read())
    print(json.dumps(obj, indent=2, ensure_ascii=False))
    ]],
  }
  local output = vim.fn.system(cmd, input)

  if vim.v.shell_error ~= 0 then
    vim.notify(output, vim.log.levels.ERROR)
    return
  end

  local new_lines = vim.split(vim.trim(output), '\n', { plain = true })

  vim.api.nvim_buf_set_lines(0, start[2] - 1, finish[2], false, new_lines)
end

return M
