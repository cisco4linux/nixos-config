{
  description = "Cisco NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    comin.url = "github:narsil/comin";
    comin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, comin, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        comin.nixosModules.comin
      ];
    };
  };
}
