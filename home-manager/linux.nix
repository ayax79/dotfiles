{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    keepassxc
    wl-clipboard
    shotman
    waybar
    i3status
    dmenu
    #dbus-sway-environment
    #configure-gtk
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    swaylock
    swayidle
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer
    wdisplays # tool to configure displays
    nordic
    hyprpaper
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    $mod = SUPER

    $w1 = hyprctl hyprpaper wallpaper "DP-1,~/backgrounds/utterly-nord.png"
    bind = $mod, F, exec, firefox
    bind = $mod, A, exec, alacritty
    bind = , Print, exec, grimblast copy area

    # workspaces
    # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in ''
          bind = $mod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
        ''
      )
      10)}

    exec-once=hyprpaper

    # ...
  '';

  home.file.backgrounds = {
    source = ./backgrounds;
    recursive = true;
  };

  home.file."./.config/hypr/hyprpaper.conf" = {
    text = ''
        wallpaper = ~/backgrounds/utterly-nord.png
    '';
  };

  # wayland.windowManager.sway = {
  #   enable = true;
  #   config = rec {
  #     modifier = "Mod4"; # Super key
  #     terminal = "alacritty";
  #     output = {
  #       "Virtual-1" = {
  #         mode = "1920x1080@60Hz";
  #       };
  #     };
  #   };
  # };
  #
  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Nordic";
  #     package = pkgs.nordic;
  #   };
  #   iconTheme = {
  #     name = "Nordzy";
  #     package = pkgs.nordzy-icon-theme;
  #   };
  #   cursorTheme = {
  #     name = "Nordzy-cursors";
  #     package = pkgs.nordzy-cursor-theme;
  #     size = 32;
  #   };
  #   # gtk2 = {
  #   #   configLocation = "${config.home.homeDirectory}/.gtkrc-2.0";
  #   # };
  # };
  #
  # dconf = {
  #   settings = {
  #     "org/gnome/desktop/interface" = {
  #       gtk-theme = "${config.gtk.theme.name}";
  #       cursor-theme = "${config.gtk.cursorTheme.name}";
  #     };
  #     "org/gnome/desktop/wm/preferences" = {
  #       theme = "${config.gtk.theme.name}";
  #     };
  #     "org/gnome/shell" = {
  #       favorite-apps = [
  #         "Alacritty.desktop"
  #         "firefox.desktop"
  #         "spotify.desktop"
  #         "nautilus.desktop"
  #       ];
  #     };
  #   };
  # };
  #
  # qt = {
  #   enable = true;
  #   platformTheme = "gtk";
  #   style = {
  #     name = "Nordic";
  #     package = pkgs.nordic;
  #   };
  # };

  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/

  # dconf.settings = {
  #   # ...
  #   "org/gnome/shell" = {
  #     favorite-apps = [
  #       "firefox.desktop"
  #       "code.desktop"
  #       "org.gnome.Terminal.desktop"
  #       "spotify.desktop"
  #       "virt-manager.desktop"
  #       "org.gnome.Nautilus.desktop"
  #     ];
  #   };
  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #     enable-hot-corners = false;
  #   };
  #   "org/gnome/desktop/wm/preferences" = {
  #     workspace-names = ["Main"];
  #   };
  #   "org/gnome/desktop/background" = {
  #     picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-l.png";
  #     picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
  #   };
  #   "org/gnome/desktop/screensaver" = {
  #     picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
  #     primary-color = "#3465a4";
  #     secondary-color = "#000000";
  #   };
  # };
}
