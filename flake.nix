{

  description = "Flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, }:
  let 
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      your-hostname = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];

      };
    };

  };

}
