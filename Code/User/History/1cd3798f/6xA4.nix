# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
	];

	# Internet
	networking.networkmanager.enable = true;
	networking.networkmanager.wifi.backend = "iwd";
	networking.hostName = "Endurance";

	# System packages
	nixpkgs.config.allowUnfree = true;
	environment.systemPackages = with pkgs; [
		neovim
		wget
		kitty
		kdePackages.dolphin
		killall
		awww
		swaynotificationcenter
		waybar
	];

	# Fonts
	fonts.packages = with pkgs; [
		noto-fonts
		atkinson-hyperlegible-next
		google-fonts
	] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
	fonts.enableDefaultPackages = true;

	# Users
	users.users.otter = {
		isNormalUser = true;
		description = "Otter";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [];
	};

	 # Home Manager
	home-manager = {
		extraSpecialArgs = { inherit inputs; };
		users = {
			"otter" = import ./home.nix;
		};
	};

	# Flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# DE, DM, greeter, drivers, blah blah all that boring stuff that never changes after the first week
	services.displayManager.ly.enable = true;
	boot.loader.limine.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	services.printing.enable = true;
	hardware.bluetooth.enable = true;
	programs.hyprland = {
		enable = true;
		withUWSM = true;    
		package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
		xwayland.enable = true;
	};
	environment.sessionVariables.NIXOS_OZONE_WL = "1";
	security.polkit.enable = true;  
	boot.initrd.kernelModules = [ "amdgpu" ];
	boot.kernelModules = [ "kvm-amd" ];
	services.xserver.videoDrivers = [ "amdgpu" ];
	hardware.graphics.enable = true;

	# Select internationalisation properties.
	time.timeZone = "America/New_York";
	i18n.defaultLocale = "en_US.UTF-8";
	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
	};

	# Configure keymap·
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

	# Don't change
	system.stateVersion = "25.11";
}
