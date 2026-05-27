{ pkgs, lib, ... }: lib.mkIf pkgs.stdenv.isLinux {
  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraConfig = builtins.readFile ./sway/config;
  };

  xdg.configFile."sway/status.sh" = {
    source = ./sway/status.sh;
    executable = true;
  };
}
