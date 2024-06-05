{ pkgs, config, lib, ... }:

with lib;

{
  # ------------------------------------------------------ NixOS Kernel Modifications ------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------------------------------------
  
  # Use the hardened linux kernel :)
  boot.kernelPackages = mkDefault pkgs.linuxPackages_hardened;


  # Disable coredump which could be exploited later and slows down the system when something crashes
  systemd.coredump.enable = false;

  # Hide kptrs even for processes with CAP_SYSLOG
  boot.kernel.sysctl."kernel.kptr_restrict" = mkOverride 500 2;

  # Disable bpf() JIT (to eliminate spray attacks)
  boot.kernel.sysctl."net.core.bpf_jit_enable" = mkDefault false;

  # Disable ftrace debugging
  boot.kernel.sysctl."kernel.ftrace_enabled" = mkDefault false;

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

  # Prevent kernel modules from being loaded after system has booted.
  # Modules that fail to load before locking can be added to boot.kernelModules.
  security.lockKernelModules = mkDefault true;
  # boot.kernelModules = [
  # ];

  # Prevents replacing the running kernel image
  security.protectKernelImage = mkDefault true;

  # Enable strict reverse path filtering (that is, do not attempt to route
  # packets that "obviously" do not belong to the iface's network; dropped
  # packets are logged as martians).
  boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = mkDefault true;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = mkDefault "1";
  boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = mkDefault true;
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = mkDefault "1";

  # Ignore broadcast ICMP (mitigate SMURF)
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault true;

  # Ignore incoming ICMP redirects (note: default is needed to ensure that the
  # setting is applied to interfaces added after the sysctls are set)
  boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = mkDefault false;

  # Ignore outgoing ICMP redirects (this is ipv4 only)
  boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = mkDefault false;


  boot.kernelParams = [
    # Don't merge slabs
    "slab_nomerge"

    # Overwrite free'd pages
    "page_poison=1"

    # Enable page allocator randomization
    "page_alloc.shuffle=1"

    # Disable debugfs
    "debugfs=off"
  ];


  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];

  # ----------------------------------------------------------------------------------------------------------------------------------------
  # ----------------------------------------------------------------------------------------------------------------------------------------

  # This is required by podman to run containers in rootless mode (for AppArmor).
  security.unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;

  # Whether the hypervisor should flush the L1 data cache before entering guests. See also .
  # null: uses the kernel default
  # "never": disables L1 data cache flushing entirely. May be appropriate if all guests are trusted.
  # "cond": flushes L1 data cache only for pre-determined code paths. May leak information about the host address space layout.
  # "always": flushes L1 data cache every time the hypervisor enters the guest. May incur significant performance cost.
  security.virtualisation.flushL1DataCache = mkDefault "always";


  # Enable AppArmor to containerize applications and kill existing container-able applications that are not
  security.apparmor.enable = mkDefault true;
  security.apparmor.killUnconfinedConfinables = mkDefault true;

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
