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
        steam
        hyprlock
        kdePackages.dolphin
        yazi
        waybar

        rustup
        gcc
        go

        libsForQt5.qt5ct
        kdePackages.qt6ct
        libsForQt5.qtstyleplugins
        kdePackages.qtstyleplugin-kvantum
        libsForQt5.qtstyleplugin-kvantum
        bibata-cursors
        gnome-themes-extra
        adwaita-qt
        atkinson-hyperlegible-next
        google-fonts
		awww

        kdePackages.kio-admin
        killall
        swaynotificationcenter
    ];

    home.sessionVariables = {
        SHELL = "${pkgs.fish}/bin/fish"; # Make fish the default shell
    };

    programs.fish = {
        enable = true;
        interactiveShellInit = ''
            set fish_greeting # Disable greeting
        '';
        shellAliases = {
            rebuild = "sudo nixos-rebuild switch --flake /home/otter/.config/nixos/#Endurance";
            rebuild-test = "sudo nixos-rebuild test --flake /home/otter/.config/nixos/#Endurance";
            rebuild-boot = "sudo nixos-rebuild boot --flake /home/otter/.config/nixos/#Endurance";
            rb = "rebuild";
            rbt = "rebuildt";
            rbb = "rebuildb";
        };
    };

    programs.git = {
        settings = {
            user.name = "Salmontree";
            user.email = "brexiosaurus@gmail.com";
            init.defaultBranch = "main";
        };
    };

    # Theming
    dconf.settings = {
    	"org/gnome/desktop/interface" = {
    		color-scheme = "prefer-dark";
    	};
    };
    gtk = {
        enable = true;
        gtk4.theme = config.gtk.theme;

        colorScheme = "dark";
        theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
        };
        cursorTheme = {
            name = "Bibata-Modern-Ice";
            size = 32;
            package = pkgs.bibata-cursors;
        };
        font = {
            name = "Atkinson Hyperlegible Next";
            size = 11;
            package = pkgs.atkinson-hyperlegible-next;
        };
    };
    qt = {
        enable = true;
        style = {
            name = "adwaita-dark";
            package = pkgs.adwaita-qt;
        };
        platformTheme.name = "gtk";
    
        qt5ctSettings = {
            Appearance = {
                style = "Fusion";
                color_scheme_path = "$HOME/.config/matugen/generated/qt5ct-colors.conf";
                custom_palette = true;
                icon_theme = "Fluent-teal-dark";
                standard_dialogs = "default";
            };
            Fonts = {
                fixed = "Atkinson Hyperlegible Next,12,-1,5,50,0,0,0,0,0";
                general = "Atkinson Hyperlegible Next,12,-1,5,50,0,0,0,0,0";
            };
        };
        qt6ctSettings = {
            Appearance = {
                style = "Fusion";
                color_scheme_path = "$HOME/.config/matugen/generated/qt6ct-colors.conf";
                custom_palette = true;
                icon_theme = "Fluent-teal-dark";
                standard_dialogs = "xdgdesktopportal";
            };
            Fonts = {
                fixed = "Atkinson Hyperlegible Next,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
                general = "Atkinson Hyperlegible Next,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
            };
        };
    };
}