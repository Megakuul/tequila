{
  modulesPath,
  lib,
  pkgs,
  ...
}@args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNnt8DaQYFwIMraIopoL9Vkp3Ero2G05QwVhiQocEmm linus@laptop"
  ]
  ++ (args.extraPublicKeys or [ ]); # this is used for unit-testing this module and can be removed if not needed

  system.stateVersion = "24.05";
}
