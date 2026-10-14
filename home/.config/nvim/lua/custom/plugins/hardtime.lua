vim.pack.add { 'https://github.com/m4xshen/hardtime.nvim' }
require('hardtime').setup {
  disabled_filetypes = {
    'orgagenda',
  },
}
