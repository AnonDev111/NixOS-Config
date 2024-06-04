{ inputs, outputs, lib, config, pkgs, ... }: {

  imports = [

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
