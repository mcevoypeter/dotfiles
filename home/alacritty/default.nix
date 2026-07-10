{ pkgs, ... }:
let
  settings = {
    font = {
      normal      = { family = "Hack Nerd Font Mono"; style = "Regular"; };
      bold        = { family = "Hack Nerd Font Mono"; style = "Bold"; };
      italic      = { family = "Hack Nerd Font Mono"; style = "Italic"; };
      bold_italic  = { family = "Hack Nerd Font Mono"; style = "Bold Italic"; };
    };
    window.option_as_alt = "Both";
  };
in {
  # Install the font referenced above. On Darwin home-manager rsyncs any font
  # package in home.packages into ~/Library/Fonts/HomeManager, where macOS (and
  # thus Alacritty) can find it. Without this, Alacritty warns and falls back to
  # Menlo. nixpkgs-unstable exposes nerd fonts individually under `nerd-fonts.*`.
  home.packages = [ pkgs.nerd-fonts.hack ];

  home.file.".config/alacritty/alacritty.toml".source =
    (pkgs.formats.toml {}).generate "alacritty.toml" settings;
}
