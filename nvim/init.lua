-- color scheme
vim.cmd("colorscheme default")

-- line numbering
vim.cmd("set relativenumber")

-- Use UTF-8 encoding.
vim.cmd([[
  set encoding=utf-8
  set fileencoding=utf-8
]])

-- Turn off all bells.
vim.cmd([[
  set noerrorbells
  set novisualbell
]])

-- tab settings
vim.cmd([[
  set autoindent
  set expandtab
  set shiftwidth=2
  set smartindent
  set tabstop=2
]])

-- Enable intuitive backspace behavior in insert mode.
vim.cmd("set backspace=indent,eol,start")

-- Always show status line.
vim.cmd("set laststatus=2")

-- split window settings
vim.cmd([[
  set splitbelow
  set splitright
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>
  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-H> <C-W><C-H>
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

-- Enable ZSH-like tab-complete in command mode.
vim.cmd([[
  set wildmenu
  set wildmode=full
]])

-- global and local leaders
vim.cmd([[
  let mapleader=" "
  let maplocalleader =" "
]])
