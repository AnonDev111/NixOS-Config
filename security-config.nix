{ pkgs, config, ... }:

{
  # ------------------------------------------------------ NixOS Kernel Modifications ------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------------------------------------
  # Use the hardened linux kernel :)
  boot.kernelPackages = mkDefault pkgs.linuxPackages_hardened;

  # Disable SMT to mitigate the risk of leaking data between threads running on the same CPU core (due to e.g., shared caches).
  # This attack vector is unproven. Disabling comes at a performance cost. Default is true.
  security.allowSimultaneousMultithreading = mkDefault true;

  # Force-enables Page Table Isolation (PTI) Linux kernel feature even on CPU models that claim to be safe from the Meltdown exploit.
  # This hardening feature is most beneficial to systems that run untrusted workloads that rely on address space isolation for security.
  security.forcePageTableIsolation = mkDefault true;

  # Scudo is a dynamic user-mode memory allocator, or heap allocator,
  # designed to be resilient against heap-related vulnerabilities
  # (such as heap-based buffer overflow, use after free, and double free) while maintaining performance.
  environment.memoryAllocator.provider = mkDefault "scudo";
  environment.variables.SCUDO_OPTIONS = mkDefault "ZeroContents=1";

  # Disable coredump which could be exploited later and slows down the system when something crashes
  systemd.coredump.enable = false;

  # Prevent kernel modules from being loaded after system has booted.
  # Modules that fail to load before locking can be added to boot.kernelModules.
  security.lockKernelModules = mkDefault true;
  # boot.kernelModules = [
  # ];

  # Prevents replacing the running kernel image
  security.protectKernelImage = mkDefault true;

  # ----------------------------------------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------------------------------------
  

  # enable antivirus clamav and
  # keep the signatures' database updated
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

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
