{ pkgs, name, ... }:
{
  networking.hostName = name;
  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig = {
      Address = "10.1.10.111/24";
      Gateway = "10.1.10.1";
      DNS = "1.1.1.1";
      DHCP = "no";
    };
  };

  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 22 ];
  microvm.interfaces = [
    {
      type = "tap";
      id = "vm-${name}";
      mac = "02:00:00:00:00:11";
    }
  ];
  microvm.hypervisor = "firecracker";
  microvm.mem = 4096;
  microvm.vcpu = 4;
  microvm.volumes = [
    {
      autoCreate = true;
      fsType = "ext4";
      image = "/var/lib/microvms/image-${name}";
      label = name;
      mountPoint = "/";
      size = 40000; # 40GB
    }
  ];
  
  services.openssh = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNnt8DaQYFwIMraIopoL9Vkp3Ero2G05QwVhiQocEmm linus@laptop"
  ];

  system.stateVersion = "25.11";
}
