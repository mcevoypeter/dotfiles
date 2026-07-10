# Paneru — a sliding, tiling window manager for macOS (in the spirit of Niri and
# PaperWM). This is the darwin counterpart to ./sway on Linux: both are
# graphical-only modules pulled in by home/default.nix's `graphical` list. The
# `services.paneru` option set — and the launchd agent that runs it — comes from
# the paneru flake's homeModules.paneru, wired in via flake.nix's
# home-manager.sharedModules.
#
# Guarded to darwin so a future graphical Linux host in the `graphical` list
# never tries to enable a macOS-only window manager, mirroring sway's isLinux
# guard. See paneru's CONFIGURATION.md for the full option/binding reference.
{ pkgs, lib, ... }: lib.mkIf pkgs.stdenv.isDarwin {
  services.paneru = {
    enable = true;
    settings = {
      options = {
        # Focus the window under the cursor; warp the cursor to the newly
        # focused window when focus moves via the keyboard.
        focus_follows_mouse = true;
        mouse_follows_focus = true;
        # Widths cycled through by window_resize / window_shrink.
        preset_column_widths = [ 0.25 0.33 0.5 0.66 0.75 ];
      };

      # Bindings mirror the home-row (vim) directional scheme from ./sway.
      bindings = {
        # Move focus along the strip (h/j/k/l).
        window_focus_west = "alt - h";
        window_focus_south = "alt - j";
        window_focus_north = "alt - k";
        window_focus_east = "alt - l";

        # Swap the focused window with its neighbor (+ shift).
        window_swap_west = "alt + shift - h";
        window_swap_south = "alt + shift - j";
        window_swap_north = "alt + shift - k";
        window_swap_east = "alt + shift - l";

        # Jump to the start / end of the strip.
        window_focus_first = "alt - a";
        window_focus_last = "alt - e";

        # Sizing and placement.
        window_resize = "alt - r";         # grow: cycle preset widths
        window_shrink = "alt + shift - r"; # shrink: cycle preset widths
        window_fullwidth = "alt - f";
        window_center = "alt - c";
        window_balance = "alt - b";

        # Toggle focused window between floating and tiled states.
        window_manage = "alt - t";

        # Service lifecycle.
        restart = "ctrl + alt - r";
        quit = "ctrl + alt - q";
      };
    };
  };
}
