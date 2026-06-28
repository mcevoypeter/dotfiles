# Home-manager entrypoint for Neovim. The actual editor configuration lives in
# ./nixvim.nix and is managed by nixvim (wired in via flake.nix's
# home-manager.sharedModules). nixvim itself writes ~/.config/nvim/init.lua, so
# no xdg.configFile plumbing is needed here.
{ ... }: {
  programs.nixvim = {
    imports = [ ./nixvim.nix ];

    # Reuse home-manager's (global) nixpkgs instance rather than letting nixvim
    # build its own. This keeps a single nixpkgs in the flake — consistent with
    # home-manager.useGlobalPkgs and the repo's "one stable nixpkgs" design —
    # and silences nixvim's `nixpkgs.source` follows warning.
    nixpkgs.useGlobalPackages = true;
  };
}
