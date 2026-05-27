{ ... }: {
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
  };

  xdg.configFile."nvim/init.lua".source                = ./init.lua;
  xdg.configFile."nvim/lua/config/lazy.lua".source     = ./lua/config/lazy.lua;
}
