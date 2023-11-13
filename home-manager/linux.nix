{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    dconf
    keepassxc
    shotman
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
    mako # notification system developed by swaywm maintainer
    wdisplays # tool to configure displays
    nordic
  ];

  home.file.backgrounds = {
    source = ./backgrounds;
    recursive = true;
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # Super key
      terminal = "alacritty";
      menu = "wofi -S drun";
      output = {
        "HDMI-A-2" = {
          mode = "3840x2160@30Hz";
        };
        "eDP-1" = {
          mode = "1600x900@60Hz";
        };
        "*" = {
          bg = "~/backgrounds/utterly-nord.png fill";
        };
      };
      bars = [
        {
          command = "waybar";
        }
      ];
      fonts = {
        names = ["SpaceMono"];
        size = 12.0;
      };
      gaps = {
        inner = 8;
      };
    };
    extraConfig = ''
      default_border pixel 2
      for_window [title=".*"] border pixel 2

      # Themes
      set $gnome-schema org.gnome.desktop.interface
      exec_always {
          gsettings set $gnome-schema gtk-theme "Nordic-bluish-accent"
          gsettings set $gnome-schema icon-theme "NordArc-Icons"
          gsettings set org.gnome.desktop.wm.preferences theme "Nordic-bluish-accent"
      }

      # Notification
      exec_always mako

      # Src : https://github.com/lokesh-krishna/dotfiles/blob/master/nord-v3/config/sway/config
      ## Window decoration
      # class                 border  backgr. text    indicator child_border
      client.focused          #88c0d0 #434c5e #eceff4 #8fbcbb   #88c0d0
      client.focused_inactive #88c0d0 #2e3440 #d8dee9 #4c566a   #4c566a
      client.unfocused        #88c0d0 #2e3440 #d8dee9 #4c566a   #4c566a
      client.urgent           #ebcb8b #ebcb8b #2e3440 #8fbcbb   #ebcb8b

      include /etc/sway/config.d/*
    '';
  };

  programs.wofi = {
    enable = true;
    style = ''
      * {
      	font-family: "Hack", monospace;
      }

      window {
      	background-color: #3B4252;
      }

      #input {
      	margin: 5px;
      	border-radius: 0px;
      	border: none;
      	background-color: #3B4252;
      	color: white;
      }

      #inner-box {
      	background-color: #383C4A;
      }

      #outer-box {
      	margin: 2px;
      	padding: 10px;
      	background-color: #383C4A;
      }

      #scroll {
      	margin: 5px;
      }

      #text {
      	padding: 4px;
      	color: white;
      }

      #entry:nth-child(even){
      	background-color: #404552;
      }

      #entry:selected {
      	background-color: #4C566A;
      }

      #text:selected {
      	background: transparent;
      }
    '';
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 35;
        modules-left = ["sway/workspaces" "sway/mode" "sway/window"];
        modules-center = [];
        modules-right = ["pulseaudio" "backlight" "network" "cpu" "memory" "battery" "clock" "tray"];
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "sway/window" = {
          max-length = 50;
        };
        tray = {
          icon-size = 21;
          spacing = 10;
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "  {:%Y-%m-%d   %H:%M}";
        };
        cpu = {
          format = "  {usage}%";
          tooltip = false;
        };
        memory = {
          format = "  {}%";
        };
        backlight = {
          # "device": "acpi_video1",
          format = "{icon}  {percent}%";
          format-icons = ["" ""];
        };
        battery = {
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon}  {capacity}%";
          "format-charging" = "  {capacity}%";
          "format-plugged" = "  {capacity}%";
          "format-alt" = "{time} {icon}";
          # "format-good" = "", // An empty format will hide the module
          # "format-full" = "";
          "format-icons" = ["" "" "" "" ""];
        };
        "network" = {
          # "interface" = "wlp2*", // (Optional) To force the use of this interface
          "format-wifi" = "  ({signalStrength}%)";
          # "format-ethernet" = "{ifname}: {ipaddr}/{cidr} ";
          "format-ethernet" = "  {ipaddr}";
          "format-linked" = "  {ifname} (No IP)";
          "format-disconnected" = "⚠  Disconnected";
        };
        "pulseaudio" = {
          # "scroll-step" = 1; // %, can be a float
          "format" = "{icon}  {volume}%      {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = "  {icon}  {format_source}";
          "format-muted" = "   {format_source}";
          "format-source" = "  {volume}%";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
      };
    };
    style = ''
            /* Polar Night */
            @define-color nord0 #2e3440;
            @define-color nord1 #3b4252;
            @define-color nord2 #434c5e;
            @define-color nord3 #4c566a;
            /* Snow storm */
            @define-color nord4 #d8dee9;
            @define-color nord5 #e5e9f0;
            @define-color nord6 #eceff4;
            /* Frost */
            @define-color nord7 #8fbcbb;
            @define-color nord8 #88c0d0;
            @define-color nord9 #81a1c1;
            @define-color nord10 #5e81ac;
            /* Aurora */
            @define-color nord11 #bf616a;
            @define-color nord12 #d08770;
            @define-color nord13 #ebcb8b;
            @define-color nord14 #a3be8c;
            @define-color nord15 #b48ead;

            window {
          background-color: transparent;
      }

      * {
          font-family: Cantarell;
          font-size: 14px;
          font-weight: 600;
          margin-top: 2px;
          margin-bottom: 2px;
      }

      /*
      * Left part
      */
      #mode {
          color: @nord0;
          background-color: @nord13;
          margin-left: 8px;
          border-radius: 5px;
          padding: 0px 6px;
      }

      #workspaces button {
          margin-left: 8px;
          background-color: @nord3;
          padding: 0px 4px;
          color: @nord6;
          margin-top: 0;
      }

      #workspaces button.focused {
          color: @nord0;
          background-color: @nord8;
      }

      #window {
          margin-left: 10px;
          color: @nord6;
          font-weight: bold;
          padding: 0px 5px;
      }

      /*
      * Right part
      */
      #pulseaudio,
      #network,
      #cpu,
      #memory,
      #backlight,
      #language,
      #battery,
      #clock,
      #tray {
          background-color: @nord2;
          padding: 0px 8px;
          color: @nord6;
      }

      #backlight,
      #language,
      #battery,
      #clock,
      #tray {
          margin-right: 8px;
          border-top-right-radius: 5px;
          border-bottom-right-radius: 5px;
      }

      #pulseaudio,
      #network,
      #clock,
      #tray {
          border-top-left-radius: 5px;
          border-bottom-left-radius: 5px;
      }

      #pulseaudio.muted {
          background-color: @nord13;
          color: @nord3;
      }

      #pulseaudio, #backlight {
          background-color: @nord10;
      }

      #network, #cpu, #memory, #battery {
          background-color: @nord3;
      }

      #tray {
          background-color: @nord1;
      }

      #network.disabled,
      #network.disconnected {
          background-color: @nord13;
          color: @nord0;
      }

      #battery.warning {
          background-color: @nord13;
          color: @nord0;
      }

      #battery.critical {
          background-color: @nord11;
          color: @nord0;
      }

      #tray menu {
          background-color: @nord2;
          color: @nord4;
          padding: 10px 5px;
          border: 2px solid @nord1;
      }
    '';
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
    # gtk2 = {
    #   configLocation = "${config.home.homeDirectory}/.gtkrc-2.0";
    # };
  };
  #
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
