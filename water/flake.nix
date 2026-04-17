{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    {
      nixosConfigurations.water-01 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.microvm.nixosModules.microvm
          ./configuration.nix
        ];
        specialArgs = {
          name = "water-01";
        };
      };
    };
}
