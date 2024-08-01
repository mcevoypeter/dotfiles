-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

local lspconfig = require("lspconfig")
vim.keymap.set('n', 'K', vim.lsp.buf.hover)

-- npm install -g pyright
lspconfig.pyright.setup{}

-- npm install -g @tailwindcss/language-server
lspconfig.tailwindcss.setup{}

-- brew install hashicorp/tap/terraform-ls
lspconfig.terraformls.setup{}

-- npm i -g typescript typescript-language-server
lspconfig.tsserver.setup{}
