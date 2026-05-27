{ ... }: {
  programs.direnv = {
    enable = true;
    config.global.warn_timeout = "1m";
  };
}
