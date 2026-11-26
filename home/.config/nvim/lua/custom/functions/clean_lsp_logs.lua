local M = {}
function clean()
  local log_path = vim.lsp.log.get_filename()
  local max_size = 10 * 1024 * 1024 -- 10 MB

  local stat = vim.uv.fs_stat(log_path)

  if stat and stat.size > max_size then vim.fn.writefile({}, log_path) end
end

return M
