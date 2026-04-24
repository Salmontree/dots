{ config, pkgs, ... }:

{
  # For home manager, don't change ts
  home.username = "otter";
  home.homeDirectory = "/home/otter";
  programs.home-manager.enable = true;
  
  home.packages = with pkgs; [

  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
