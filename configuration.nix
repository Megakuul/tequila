{
  modulesPath,
  lib,
  pkgs,
  inputs,
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
  networking.hostName = "tequila";
  networking.useNetworkd = true;

  # HPE Proliant NIC reports invalid MII status
  # therefore bonding results in dropped packets when interfaces are not plugged in.
  # systemd.network.netdevs."10-bond0" = {
  #   netdevConfig = { Kind = "bond"; Name = "bond0"; };
  # };
  # systemd.network.networks."20-bond0-members" = {
  #   matchConfig.Type = "ether";
  #   networkConfig.Bond = "bond0";
  # };
  systemd.network.netdevs."30-br0" = {
    netdevConfig = { Kind = "bridge"; Name = "br0"; };
  };
  systemd.network.networks."40-br0-uplink" = {
    # matchConfig.Name = ["bond0"];
    matchConfig.Type = "ether"; # only works with one active physical interface
    networkConfig = {
      Bridge = "br0";
    };
  };
  systemd.network.networks."40-br0-vm" = {
    matchConfig.Name = ["vm-*"];
    networkConfig = {
      Bridge = "br0";
    };
  };
  systemd.network.networks."50-br0-static" = {
    matchConfig.Name = "br0";
    networkConfig = {
      Address = "10.1.10.100/24";
      Gateway = "10.1.10.1";
      DNS = "1.1.1.1";
    };
  };

  
  services.openssh = {
    enable = true;
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNnt8DaQYFwIMraIopoL9Vkp3Ero2G05QwVhiQocEmm linus@laptop"
  ]
  ++ (args.extraPublicKeys or [ ]); # this is used for unit-testing this module and can be removed if not needed

  microvm.stateDir = "/var/lib/microvms";
  microvm.vms = {
    "water-01" = {
      autostart = true;
      flake = inputs.water;
      restartIfChanged = true;
    };
  };

  # system.autoUpgrade = {
  #   enable = true;
  #   flake = "github:username/repository-name#machine-name";
  #   allowReboot = false;
  #   dates = "04:00";
  #   randomizedDelaySec = "45min";
  # };

  system.stateVersion = "24.05";
}
