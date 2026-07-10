# Neovim, configured declaratively with nixvim (github:nix-community/nixvim).
# This replaces the former lazy.nvim setup (init.lua + lua/config/lazy.lua):
# every plugin, option, keymap and autocmd that used to live there is expressed
# as a nixvim module option below. This file is a *standalone* nixvim module —
# ./default.nix wires it into home-manager via `programs.nixvim`.
{ pkgs, lib, ... }:
{
  enable = true;

  # Match the old `programs.neovim` providers: no Ruby/Python host providers.
  withRuby = false;
  withPython3 = false;

  # Built-in neovim colorscheme (init.lua: `colorscheme quiet`).
  colorscheme = "quiet";

  # ── Options (init.lua `set ...`) → vim.opt.* ──────────────────────────────
  opts = {
    # line numbering
    number = true;
    relativenumber = true;

    # encoding
    encoding = "utf-8";
    fileencoding = "utf-8";

    # turn off all bells
    errorbells = false;
    visualbell = false;

    # tab settings
    autoindent = true;
    expandtab = true;
    shiftwidth = 2;
    smartindent = true;
    tabstop = 2;

    # intuitive backspace in insert mode
    backspace = "indent,eol,start";

    # global statusline
    laststatus = 3;

    # fold based on indentation
    foldmethod = "indent";

    # split window settings
    splitbelow = true;
    splitright = true;

    # search settings
    hlsearch = true;
    incsearch = true;
    # case-insensitive when all lowercase, case-sensitive otherwise
    ignorecase = true;
    smartcase = true;

    # ZSH-like tab-complete in command mode
    wildmenu = true;
    wildmode = "full";

    # auto-reload files changed on disk
    autoread = true;
  };

  # `set shortmess-=S` — make sure the search-count message is displayed.
  extraConfigLua = ''
    vim.opt.shortmess:remove("S")
  '';

  # ── Globals ───────────────────────────────────────────────────────────────
  globals = {
    # space leaders (must be set before keymaps are created — nixvim emits
    # globals in the Pre phase, before the keymaps below).
    mapleader = " ";
    maplocalleader = " ";

    # fzf.vim configuration (formerly vim.g.fzf_* in the lazy plugin config).
    fzf_layout = {
      window = {
        width = 1.0;
        height = 0.8;
        relative = true;
        yoffset = 1.0;
      };
    };

    fzf_colors = {
      fg = [ "fg" "Normal" ];
      bg = [ "bg" "Normal" ];
      hl = [ "fg" "Comment" ];
      "fg+" = [ "fg" "CursorLine" "CursorColumn" "Normal" ];
      "bg+" = [ "bg" "CursorLine" "CursorColumn" ];
      "hl+" = [ "fg" "Statement" ];
      info = [ "fg" "PreProc" ];
      border = [ "fg" "Ignore" ];
      prompt = [ "fg" "Conditional" ];
      pointer = [ "fg" "Exception" ];
      marker = [ "fg" "Keyword" ];
      spinner = [ "fg" "Label" ];
      header = [ "fg" "Comment" ];
    };

    fzf_action = {
      "ctrl-s" = "split";
      "ctrl-v" = "vsplit";
      "ctrl-y" = "tab split";
    };
  };

  # ── Keymaps (init.lua + plugin configs) ────────────────────────────────────
  # nixvim's default mode is "" (n+v+s+o, like `:map`); the originals were all
  # `nnoremap`/`vnoremap`, so mode is set explicitly. noremap defaults to true.
  keymaps = [
    # init.lua
    { mode = "n"; key = "<C-T>"; action = "<Nop>"; }
    { mode = "n"; key = "<CR>"; action = ":nohlsearch<CR><CR>"; options.silent = true; }
    { mode = "n"; key = "<C-N>"; action = ":bnext<CR>"; }
    { mode = "n"; key = "<C-P>"; action = ":bprevious<CR>"; }

    # nvim-lspconfig: K → hover (global map, as in the original).
    { mode = "n"; key = "K"; action.__raw = "vim.lsp.buf.hover"; }

    # fzf.vim
    { mode = "n"; key = "<Leader>/"; action = ":History/<CR>"; }
    { mode = "n"; key = "<Leader>;"; action = ":Commands<CR>"; }
    { mode = "n"; key = "<Leader>b"; action = ":Buffers<CR>"; }
    { mode = "n"; key = "<Leader>f"; action = ":Files<CR>"; }
    { mode = [ "n" "v" ]; key = "<Leader>g"; action = ":BCommits<CR>"; }
    { mode = "n"; key = "<Leader>G"; action = ":Commits<CR>"; }
    { mode = "n"; key = "<Leader>h"; action = ":History<CR>"; }
    { mode = "n"; key = "<Leader>r"; action = ":History:<CR>"; }
    { mode = "n"; key = "<Leader>s"; action = ":Rg<CR>"; }
    { mode = "n"; key = "<Leader>w"; action = ":Windows<CR>"; }

    # diffview.nvim: prompt :DiffviewOpen (non-silent, no <CR>, awaits args).
    { mode = "n"; key = "<Leader>c"; action = ":DiffviewOpen "; }
  ];

  # ── Autocommands (init.lua) ────────────────────────────────────────────────
  autoCmd = [
    {
      event = [ "BufEnter" "CursorHold" "CursorHoldI" "FocusGained" ];
      pattern = [ "*" ];
      command = "if mode() != 'c' | checktime | endif";
    }
    {
      event = [ "FileChangedShellPost" ];
      pattern = [ "*" ];
      command = ''echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None'';
    }
  ];

  # ── Plugins ────────────────────────────────────────────────────────────────
  plugins = {
    # itchyny/lightline.vim — `settings` maps onto vim.g.lightline.
    lightline = {
      enable = true;
      settings = {
        colorscheme = "powerline";
        active = {
          left = [
            [ "mode" "paste" ]
            [ "gitbranch" "readonly" "filename" "modified" ]
          ];
          right = [
            [ "lineinfo" "charvaluehex" "wordcount" ]
            [ "percent" ]
            [ "fileformat" "fileencoding" "filetype" ]
          ];
        };
        component = {
          charvaluehex = "0x%B";
          filename = "%f";
        };
        component_function = {
          gitbranch = "FugitiveHead";
          wordcount = "WordCount";
        };
        # mode_map keys are matched against the raw return of mode(); the
        # visual-block key is the <C-v> byte (0x16). nixvim serialises plain
        # strings via JSON, which would emit an invalid-in-LuaJIT "\u0016", so
        # this table is given as raw Lua using the decimal escape "\22" — the
        # exact form the original lazy config used.
        mode_map.__raw = ''{ n = "N", i = "I", R = "R", v = "V", V = "VL", ["\22"] = "VB", c = "C", s = "S", S = "SL", t = "T" }'';
      };
    };

    # tpope/vim-fugitive
    fugitive.enable = true;

    # stevearc/oil.nvim (opts = {} in the original).
    oil.enable = true;

    # echasnovski/mini.icons — oil's icon provider. mockDevIcons makes it stand
    # in for nvim-web-devicons, which also stops the diffview module pulling in
    # nvim-web-devicons (the original only had mini.icons).
    mini-icons = {
      enable = true;
      mockDevIcons = true;
    };

    # sindrets/diffview.nvim (setup{ use_icons = false }).
    diffview = {
      enable = true;
      settings.use_icons = false;
    };

    # neovim/nvim-lspconfig — installs the default lsp/<name>.lua configs that
    # vim.lsp.enable() (below) consumes. No setup of its own is needed.
    lspconfig.enable = true;
  };

  # ── LSP servers (init.lua's vim.lsp.config/enable) ─────────────────────────
  # nixvim installs each server's binary via Nix and puts it on neovim's PATH
  # (nvim-lspconfig above supplies the default lsp/<name>.lua configs that
  # vim.lsp.enable() consumes). `enable = true` alone uses nixvim's default
  # package for that server.
  #
  # NOTE: the old `vim.lsp.enable` list also contained `leanls`, a leftover
  # from the reverted "Add Lean lang" change (no matching vim.lsp.config, no
  # Lean toolchain) — intentionally not carried over. Re-add with
  #   lsp.servers.leanls.enable = true;
  lsp.servers = {
    bashls.enable = true;        # bash-language-server
    dockerls.enable = true;      # dockerfile-language-server
    gopls.enable = true;
    jsonls.enable = true;        # vscode-langservers-extracted
    pyright.enable = true;
    rust_analyzer.enable = true;
    tailwindcss.enable = true;
    terraformls.enable = true;
    ts_ls.enable = true;

    # Swift / C / C++ / Obj-C. sourcekit-lsp's Nix closure is tiny on macOS
    # (~60 MiB — it uses the system Swift SDK) but drags in the entire Swift
    # toolchain on Linux (~2.1 GiB). The only Linux host here is a headless
    # server that does no Swift, so there the server stays enabled but its
    # binary is left external (resolved from PATH) rather than Nix-managed.
    sourcekit = {
      enable = true;
      package = lib.mkIf (!pkgs.stdenv.isDarwin) null;
    };
  };

  # ── Plugins with no nixvim module ──────────────────────────────────────────
  # junegunn/fzf.vim (pulls in the junegunn/fzf vim wrapper as a dependency;
  # the fzf binary itself comes from the `fzf` home module), plus the two
  # tpope plugins that have no dedicated nixvim option.
  extraPlugins = with pkgs.vimPlugins; [
    fzf-vim
    vim-eunuch
    vim-rsi
  ];
}
