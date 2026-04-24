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
		git
		fish
		
		libsForQt5.qt5ct
		kdePackages.qt6ct
		bibata-cursors
		gnome-themes-extra

		kdePackages.kio-admin
	];

	home.sessionVariables = {
		# EDITOR = "emacs";
	};

	# Let bash be the default system shell, but make bash always run fish immediately (to avoid issues if system fails or shi like that since we don't want fish as the default shell)
	programs.bash = {
		interactiveShellInit = ''
			if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
			then
			shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
			exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
			fi
		'';
	};
	programs.fish = {
		enable = true;

	};

	# Theming
	# dconf.settings = {
	# 	"org/gnome/desktop/interface" = {
	# 		color-scheme = "prefer-dark";
	# 	};
	# };
	# gtk = {
	# 	enable = true;
	# 	theme = {
	# 		name = "Adwaita-dark";
	# 		package = pkgs.gnome-themes-extra;
	# 	};
	# 	gtk4.theme = config.gtk.theme;
	# };
}