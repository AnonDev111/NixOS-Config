{ inputs, outputs, lib, config, pkgs, ... }: {

  imports = [
    # this hardware config file should be generated for you, not a good idea to edit its contents or filename
    ./hardware-configuration.nix

    ./system-configuration.nix
    ./security-configuration.nix
    ./firewall-configuration.nix
    ./processor-config.nix
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
