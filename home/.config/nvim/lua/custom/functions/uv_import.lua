local M = {}

function M.transform(_, items)
  local extra = {}

  for _, item in ipairs(items) do
    if item.kind == 9 and item.additionalTextEdits then
      local pkg, mod = item.label:match '^(.*)%.([^.]+)$'

      if pkg and mod then
        local clone = vim.deepcopy(item)

        clone.label = mod
        clone.insertText = mod
        clone.filterText = mod

        clone.labelDetails = {
          detail = (' (from %s import %s)'):format(pkg, mod),
        }

        clone.additionalTextEdits = {
          {
            range = item.additionalTextEdits[1].range,
            newText = ('from %s import %s\n'):format(pkg, mod),
          },
        }

        table.insert(extra, clone)
      end
    end
  end

  vim.list_extend(items, extra)
  return items
end

function M.augment(items)
  local extra = {}

  for _, item in ipairs(items) do
    -- item.kind 9 is Module in the LSP specification
    if item.kind == 9 and item.additionalTextEdits then
      local pkg, mod = item.label:match '^(.*)%.([^.]+)$'

      if pkg and mod then
        local clone = vim.deepcopy(item)

        clone.label = mod
        clone.insertText = mod
        clone.filterText = mod

        clone.labelDetails = {
          detail = (' (from %s import %s)'):format(pkg, mod),
        }

        clone.additionalTextEdits = {
          {
            range = item.additionalTextEdits[1].range,
            newText = ('from %s import %s\n'):format(pkg, mod),
          },
        }

        table.insert(extra, clone)
      end
    end
  end
  vim.list_extend(items, extra)

  return items
end

return M
