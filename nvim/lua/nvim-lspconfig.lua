-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

local lspconfig = require("lspconfig")
vim.keymap.set('n', 'K', vim.lsp.buf.hover)

lspconfig.tsserver.setup{}
