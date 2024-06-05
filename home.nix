{config, pkgs, ...}

{
  home.username = "insert-username-here";
  home.homeDirectory = "/home/insert-username-here";
  home.stateVersion = "23.11";

  home.packages = [
  ];

  home.sessionVariables = {

  };


  programs.home-manager.enable = true;
}
