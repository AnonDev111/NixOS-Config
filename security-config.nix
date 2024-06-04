{ pkgs, config, ... }:

{

  # enable antivirus clamav and
  # keep the signatures' database updated
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
  
  # Disable coredump which could be exploited later and slows down the system when something crashes
  systemd.coredump.enable = false;

  # required to run chromium
  security.chromiumSuidSandbox.enable = true;

  # Wrap firefox and chromium binaries
  programs.firejail.enable = true;
  programs.firejail.wrappedBinaries = {
    firefox = {
      executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
      profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    };
    chromium = {
      executable = "${pkgs.lib.getBin pkgs.chromium}/bin/chromium";
      profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
    };
  };

}