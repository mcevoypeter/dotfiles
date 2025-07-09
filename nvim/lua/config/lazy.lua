-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "itchyny/lightline.vim",
      config = function()
        vim.g.lightline = {
          colorscheme = "powerline",
          active = {
            left = {
              { "mode", "paste" },
              { "gitbranch", "readonly", "filename", "modified" }
            },
            right = {
              { "lineinfo", "charvaluehex", "wordcount" },
              { "percent" },
              { "fileformat", "fileencoding", "filetype" }
            }
          },
          component = {
            charvaluehex = "0x%B",
            filename = "%f"
          },
          component_function = {
            gitbranch = "FugitiveHead",
            wordcount = "WordCount"
          },
          mode_map = {
            n = "N",
            i = "I",
            R = "R",
            v = "V",
            V = "VL",
            -- "\<C-v>"
            ["\22"] = "VB",
            c = "C",
            s = "S",
            S = "SL",
            -- "\<C-s>" = "SB"
            t= "T"
          }
        }
      end,
    },
    {
      "junegunn/fzf.vim",
      dependencies = { "junegunn/fzf" }, -- Install fzf as a dependency
      build = function()
        vim.fn["fzf#install"]()
      end,
      config = function()
        vim.cmd("set runtimepath+=~/.local/share/nvim/lazy/fzf.vim")
        if vim.fn.has("macunix") then
          vim.cmd([[
            set runtimepath+=/opt/homebrew/opt/fzf
          ]])
        end

        vim.cmd([[
          nnoremap <Leader>/ :History/<CR>
          nnoremap <Leader>; :Commands<CR>
          nnoremap <Leader>b :Buffers<CR>
          nnoremap <Leader>f :Files<CR>
          nnoremap <Leader>g :BCommits<CR>
          vnoremap <Leader>g :BCommits<CR>
          nnoremap <Leader>G :Commits<CR>
          nnoremap <Leader>h :History<CR>
          nnoremap <Leader>r :History:<CR>
          nnoremap <Leader>s :Rg<CR>
          nnoremap <Leader>w :Windows<CR>
        ]])

        vim.g.fzf_layout = {
          window = {
            width = 1.0,
            height = 0.8,
            relative = true,
            yoffset = 1.0
          }
        }

        vim.g.fzf_colors = {
          fg = { "fg", "Normal" },
          bg = { "bg", "Normal" },
          hl = { "fg", "Comment" },
          ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
          ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
          ["hl+"] = { "fg", "Statement" },
          info = { "fg", "PreProc" },
          border = { "fg", "Ignore" },
          prompt = { "fg", "Conditional" },
          pointer = { "fg", "Exception" },
          marker = { "fg", "Keyword" },
          spinner = { "fg", "Label" },
          header = { "fg", "Comment" }
        }

        vim.g.fzf_action = {
          ["ctrl-s"] = "split",
          ["ctrl-v"] = "vsplit",
          ["ctrl-y"] = "tab split"
        }
      end,
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

        local lspconfig = require("lspconfig")
        vim.keymap.set('n', 'K', vim.lsp.buf.hover)

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
        lspconfig.ts_ls.setup{}
      end
    },
    {
      "OXY2DEV/markview.nvim",
      lazy = false,
      config = function()
        vim.cmd("nnoremap <Leader>m :Markview Toggle<CR>")
      end
    },
    {
      "pimalaya/himalaya-vim",
    },
    {
      "sindrets/diffview.nvim",
      config = function()
        local diffview = require("diffview")
        diffview.setup{
          use_icons = false,
        }
        vim.keymap.set("n", "<Leader>c", ":DiffviewOpen ")
      end,
    },
    {
      'stevearc/oil.nvim',
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {},
      dependencies = { { "echasnovski/mini.icons", opts = {} } },
    },
    {
      "tpope/vim-eunuch",
    },
    {
      "tpope/vim-fugitive",
    },
    {
      "tpope/vim-rsi",
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = {
    enabled = true,
    notify = false,
  },
})
