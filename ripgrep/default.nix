{ ... }: {
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--type-add=dt:*.{dt}"
      "--type-add=edk:*.{dec,dsc,fdf,inf}"
      "--type-add=plist:*.{plist}"
    ];
  };
}
