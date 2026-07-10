{ pkgs, lib, ... }: lib.mkIf pkgs.stdenv.isLinux {
  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraConfig = builtins.readFile ./config;
  };

  xdg.configFile."sway/status.sh" = {
    source = ./status.sh;
    executable = true;
  };
}
