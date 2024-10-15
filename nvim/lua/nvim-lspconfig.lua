-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

local lspconfig = require("lspconfig")
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('i', '<C-N>', vim.lsp.omnifunc)
vim.keymap.set('i', '<C-P>', vim.lsp.omnifunc)

-- npm i -g bash-language-server
lspconfig.bashls.setup{}

-- npm install -g dockerfile-language-server-nodejs
lspconfig.dockerls.setup{}

-- npm i -g vscode-langservers-extracted
lspconfig.jsonls.setup{}

-- npm install -g pyright
lspconfig.pyright.setup{}

-- rustup component add rust-analyzer
lspconfig.rust_analyzer.setup{}

-- Swift and C/C++/Objective-C
lspconfig.sourcekit.setup{}

-- npm install -g @tailwindcss/language-server
lspconfig.tailwindcss.setup{}

-- brew install hashicorp/tap/terraform-ls
lspconfig.terraformls.setup{}

-- npm i -g typescript typescript-language-server
lspconfig.tsserver.setup{}
