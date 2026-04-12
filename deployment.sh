nix run github:nix-community/nixos-anywhere -- --flake path:.#generic-nixos-facter --generate-hardware-config nixos-facter ./facter.json -i ~/.ssh/tequila --target-host root@10.1.10.100
