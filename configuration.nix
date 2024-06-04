{ inputs, outputs, lib, config, pkgs, ... }: {

  imports = [
    ./package-configuration.nix
    ./system-configuration.nix
    ./security-configuration.nix
    ./firewall-configuration.nix
  ];

  
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };


  nixpkgs. config = {
    allowUnfree = true;
  };


}
