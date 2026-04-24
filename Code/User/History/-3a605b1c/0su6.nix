{ config, pkgs, ... }:

{
	# don't change ts
	home.username = "otter";
	home.homeDirectory = "/home/otter";
	programs.home-manager.enable = true;
	home.stateVersion = "25.11";
	nixpkgs.config.allowUnfree = true;
	
	# Packages
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

	# Theming
	dconf.settings = {
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
	gtk.gtk4.theme = config.gtk.theme;
}