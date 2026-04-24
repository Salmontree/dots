{ config, pkgs, ... }:

{
	# For home manager, don't change ts
	home.username = "otter";
	home.homeDirectory = "/home/otter";
	programs.home-manager.enable = true;
	home.stateVersion = "25.11";
	nixpkgs.config.allowUnfree = true;
	
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

	dconf.settings = {
		"org/gnome/desktop/background" = {
		picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
		};
		"org/gnome/desktop/interface" = {
		color-scheme = "prefer-dark";
		};
	};

	gtk = {
		enable = true;
		theme = {
		name = "Adwaita-dark";
		package = pkgs.gnome-themes-extra;
		};
	};

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}