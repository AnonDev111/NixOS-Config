{ pkgs, config, ... }:

{
  
  # Network & Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [];


  # Enable opensnitch firewall and opensnitch-ui needed to run it
  services = {
    opensnitch.enable = true;
    opensnitch-ui.enable = true;
  };

  services.opensnitch = {
    rules = {
      systemd-timesyncd = {
        name = "systemd-timesyncd";
        enabled = true;
        action = "allow";
        duration = "always";

        operator = {
          type ="simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
        };
      };

      systemd-resolved = {
        name = "systemd-resolved";
        enabled = true;
        action = "allow";
        duration = "always";

        operator = {
          type ="simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved";
        };
      };


    };
  };

}
