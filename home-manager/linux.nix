{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./sway
  ];

  home.packages = with pkgs; [
    nomacs
    gimp
    signal-desktop
    pavucontrol
    jetbrains.rust-rover
    jetbrains.idea-ultimate
  ];

  home.file.backgrounds = {
    source = ./backgrounds;
    recursive = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Nordzy";
      package = pkgs.nordzy-icon-theme;
    };
    cursorTheme = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = 32;
    };
  };

  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "${config.gtk.theme.name}";
        cursor-theme = "${config.gtk.cursorTheme.name}";
      };
      "org/gnome/desktop/wm/preferences" = {
        theme = "${config.gtk.theme.name}";
      };
      "org/gnome/shell" = {
        favorite-apps = [
          "Alacritty.desktop"
          "firefox.desktop"
          "spotify.desktop"
          "nautilus.desktop"
        ];
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  
    style = {
      name = "Nordic";
      #package = pkgs.nordic;
    };
  };
}
