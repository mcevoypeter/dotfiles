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
  home.file.".config/alacritty/alacritty.toml".source =
    (pkgs.formats.toml {}).generate "alacritty.toml" settings;
}
