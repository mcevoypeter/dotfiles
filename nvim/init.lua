-- tab settings
vim.cmd([[
  set autoindent
  set expandtab
  set shiftwidth=2
  set smartindent
  set tabstop=2
]])

-- split window settings
vim.cmd([[
  set splitbelow
  set splitright
]])

-- search settings
vim.cmd([[
  set hlsearch
  set incsearch
  " Enable case-insensitive search when all letters are lowercase and
  " case-sensitive search when some letters are uppercase.
  set ignorecase smartcase
  " Display search count message.
  set shortmess-=S
]])
