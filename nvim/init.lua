-- Disable vi compatibility, which should always be done first.
vim.cmd("set nocompatible")

-- color scheme
vim.cmd("colorscheme default")

-- line numbering
vim.cmd("set relativenumber")

-- Clear <C-T> so it can be used as the tmux prefix.
vim.cmd("nnoremap <C-T> <Nop>")

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
  " Turn off search highlighting with <CR>.
  nnoremap <silent> <CR> :nohlsearch<CR><CR>
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

-- buffer list navigation
vim.cmd([[
  nnoremap <C-N> :bnext<CR>
  nnoremap <C-P> :bprevious<CR>
]])

-- plugins
require("fzf-vim")
require("lightline-vim")
