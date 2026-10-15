vim.pack.add {
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-neotest/neotest-python',
  'https://github.com/nvim-neotest/neotest-go',
}
local neotest = require 'neotest'

neotest.setup {
  adapters = {
    require 'neotest-python' {
      dap = { justMyCode = false },
      args = { '-vv' },
      runner = 'pytest',
      pytest_discover_instances = false,
      python = function() return vim.fn.trim(vim.fn.system 'uv python find') end,
    },
    require 'neotest-go',
  },
  output = { open_on_run = true },
}

vim.keymap.set('n', '<leader>ta', function() neotest.run.attach() end, { desc = 'Attach to Test (Neotest)' })

vim.keymap.set('n', '<leader>tt', function() neotest.run.run(vim.fn.expand '%') end, { desc = 'Run File (Neotest)' })

vim.keymap.set('n', '<leader>tT', function() neotest.run.run(vim.uv.cwd()) end, { desc = 'Run All Test Files (Neotest)' })

vim.keymap.set('n', '<leader>tr', function() neotest.run.run() end, { desc = 'Run Nearest (Neotest)' })

vim.keymap.set('n', '<leader>tl', function() neotest.run.run_last() end, { desc = 'Run Last (Neotest)' })

vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end, { desc = 'Toggle Summary (Neotest)' })

vim.keymap.set('n', '<leader>to', function()
  neotest.output.open {
    enter = true,
    auto_close = true,
  }
end, { desc = 'Show Output (Neotest)' })

vim.keymap.set('n', '<leader>tO', function() neotest.output_panel.toggle() end, { desc = 'Toggle Output Panel (Neotest)' })

vim.keymap.set('n', '<leader>tS', function() neotest.run.stop() end, { desc = 'Stop (Neotest)' })

vim.keymap.set('n', '<leader>tw', function() neotest.watch.toggle(vim.fn.expand '%') end, { desc = 'Toggle Watch (Neotest)' })
