vim.pack.add { 'https://github.com/avante-corp/avante.nvim' }

require('avante').setup {
  input = {
    provider = 'native',
    provider_opts = {
      title = 'Avante Input',
      icon = ' ',
      placeholder = 'Enter your API key...',
    },
  },
}
