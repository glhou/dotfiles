-- custom/functions/fuzzy_filter.lua
local M = {}

function M.filter(items, base)
  if base == '' then return items end
  local labels = vim.tbl_map(function(i) return i.filterText or i.label end, items)
  local _, indices = MiniFuzzy.filtersort(base, labels)
  return vim.tbl_map(function(i) return items[i] end, indices)
end

return M
