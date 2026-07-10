{ ... }: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Peter McEvoy";
        email = "git@mcevoypeter.com";
      };
    };
  };
}
