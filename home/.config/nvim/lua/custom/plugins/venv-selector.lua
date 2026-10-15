vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  once = true,
  callback = function()
    vim.pack.add {
      { src = 'https://github.com/neovim/nvim-lspconfig' },
      { src = 'https://github.com/linux-cultist/venv-selector.nvim' },
    }

    require('venv-selector').setup {
      search = {},
      options = {},
    }
    vim.keymap.set('n', '<leader>v', function() vim.cmd 'VenvSelect' end, { desc = 'Select Python virtual environment' })
  end,
})
