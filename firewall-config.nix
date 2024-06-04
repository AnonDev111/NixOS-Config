{ pkgs, config, ... }:

{
  
  # Network & Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [];

  # Enable openSnitch
  services.opensnitch.enable = true;
  
}
