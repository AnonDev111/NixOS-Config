
{ pkgs, config, ...}:

{

  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware = {
    opengl.enable = true;
    driSupport = true;
    driSupport32Bit = true;
    pulseaudio.enable = true;
    bluetooth.enable = true;

    nvidia.modesetting.enable = true;
    # Sync mode = hardware is on at all times
    # Offload mode = hardware is on when needed
    # To enable offload on games, run "nvidia-offload some-game / %command%"

    nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    # Integrated
    amdgpuBusId = "PCI:0:0:0"

    # Dedicated
    nvidiaBusId = "PCI:0:0:0"
    };

  };

  specialisation = {
    gaming-time.configuration = {

      hardware.nvidia = {
        prime.sync.enable = lib.mkForce true;
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };

    };
  };

}
