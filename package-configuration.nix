{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    neofetch
    git
    zsh
    eww
    dunst
    lib
    libnotify
    swww
    kitty
    rofi-wayland
    vim
    wget
    firefox
    libreoffice
    hyprland
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
