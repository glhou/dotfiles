vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'pymple' then vim.cmd 'PympleBuild' end
  end,
})

vim.pack.add {
  'https://github.com/alexpasmantier/pymple.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}
require('pymple').setup()
