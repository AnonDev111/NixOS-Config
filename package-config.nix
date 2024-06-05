{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    neofetch
    lib
    libnotify
    git
    wget
    alacritty
    waybar
    rofi-wayland
    hyprland
    swww
    dunst
    vim
    firefox
    libreoffice
    clamav
    rkhunter
    mkpasswd
    steam
    protonup
    wine
    lutris
    mangohud
    flatpak
  ];


}
