vim.g.vimwiki_list = {
  {
    path = '~/notes/',
    syntax = 'markdown',
    ext = '.md',
  },
}

-- optional: don't hijack .md files outside your wiki path as vimwiki syntax
vim.g.vimwiki_global_ext = 0

vim.pack.add { 'https://github.com/vimwiki/vimwiki' }
