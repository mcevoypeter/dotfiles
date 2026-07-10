{ ... }: {
  services.syncthing = {
    enable = true;
    # We pair the VM + accept the vault folder from the GUI, so don't let
    # home-manager wipe GUI-managed devices/folders on every rebuild.
    overrideDevices = false;
    overrideFolders = false;
  };
}
