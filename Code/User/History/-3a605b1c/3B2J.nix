{ config, pkgs, ... }:

{
  # For home manager, don't change ts
  home.username = "otter";
  home.homeDirectory = "/home/otter";
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
  home.config.allowUnfree = true;
  
  home.packages = with pkgs; [
    vivaldi
    rofi
    matugen
    vscode
    
    libsForQt5.qt5ct
    kdePackages.qt6ct
    
    bibata-cursors
    gnome-themes-extra
    kdePackages.kio-admin
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
