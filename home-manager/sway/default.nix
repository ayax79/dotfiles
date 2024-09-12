{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./swaylock.nix
    ./wofi.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    wayshot
    workstyle
  ];

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "wofi -S drun";
      input = {
        "type:touchpad" = {
          "tap" = "enabled";
          "natural_scroll" = "enabled";
        };
        "type:mouse" = {
          "natural_scroll" = "enabled";
        };
      };
      output = {
        "HDMI-A-2" = {
          mode = "3840x2160@30Hz";
        };
        "eDP-1" = {
          mode = "1600x900@60Hz";
        };
        "*" = {
          bg = "${config.home.homeDirectory}/backgrounds/utterly-nord.png fill";
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
      keybindings = lib.mkOptionDefault {
        # # Brightness
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10'";

        # Volume
        "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
        "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
        "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
      };
    };

    extraConfig = let
      mod = config.wayland.windowManager.sway.config.modifier;
    in ''
      default_border pixel 2
      for_window [title=".*"] border pixel 2

      # Themes
      set $gnome-schema org.gnome.desktop.interface
      exec_always {
          gsettings set $gnome-schema gtk-theme "Nordic-bluish-accent"
          gsettings set $gnome-schema icon-theme "NordArc-Icons"
          gsettings set org.gnome.desktop.wm.preferences theme "Nordic-bluish-accent"
      }

      #workspace renaming
      exec_always --no-startup-id ${pkgs.workstyle}/bin/workstyle &> /tmp/workstyle.log

      # Notification
      exec_always mako

      # Src : https://github.com/lokesh-krishna/dotfiles/blob/master/nord-v3/config/sway/config
      ## Window decoration
      # class                 border  backgr. text    indicator child_border
      client.focused          #88c0d0 #434c5e #eceff4 #8fbcbb   #88c0d0
      client.focused_inactive #88c0d0 #2e3440 #d8dee9 #4c566a   #4c566a
      client.unfocused        #88c0d0 #2e3440 #d8dee9 #4c566a   #4c566a
      client.urgent           #ebcb8b #ebcb8b #2e3440 #8fbcbb   #ebcb8b

      # give sway a little time to startup before starting kanshi.
      exec sleep 5; systemctl --user start kanshi.service

      #
      # Screen capture
      #
      set $screenshot 1 selected, 2 whole, 3 selected clipboard, 4 whole clipboard, 5 hex color
      mode "$screenshot" {
          bindsym 1 exec '${pkgs.wayshot}/bin/wayshot -s "$(slurp -f \"%x %y %w %h\")" -f ~/Downloads/ps_$(date +"%Y%m%d%H%M%S").png', mode "default"
          bindsym 2 exec '${pkgs.wayshot}/bin/wayshot -f ~/Downloads/ps_$(date +"%Y%m%d%H%M%S").png', mode "default"
          bindsym 3 exec '${pkgs.wayshot}/bin/wayshot -s "$(slurp -f \"%x %y %w %h\")" --stdout | wl-copy', mode "default"
          bindsym 4 exec '${pkgs.wayshot}/bin/wayshot --stdout | wl-copy', mode "default"

          # back to normal: Enter or Escape
          bindsym Return mode "default"
          bindsym Escape mode "default"
          bindsym ${mod}+Print mode "default"
      }

      bindsym ${mod}+Print mode "$screenshot"
    '';
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
      {
        timeout = 600;
        command = ''${pkgs.swaylock}/bin/swaymsg  "output * power off"'';
        resumeCommand = ''${pkgs.swaylock}/bin/swaymsg "output * power on"'';
      }
      # {
      #   timeout = 600;
      #   command = ''${pkgs.swaylock}/bin/swaymsg  "output * dpms off"'';
      #   resumeCommand = ''${pkgs.swaylock}/bin/swaymsg "output * dpms on"'';
      # }
      # {
      #   timeout = 1800;
      #   command = "systemctl suspend";
      # }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
    ];
  };

  services.mako = {
    enable = true;
    sort = "-time";
    layer = "overlay";
    backgroundColor = "#4c566a";
    width = 300;
    height = 110;
    borderSize = 2;
    borderColor = "#88c0d0";
    borderRadius = 5;
    icons = true;
    maxIconSize = 64;
    defaultTimeout = 5000;
    ignoreTimeout = true;
    padding = "14";
    font = "SpaceMono 11";
    margin = "20";
    extraConfig = ''
      [urgency=low]
      border-color=#81a1c1

      [urgency=normal]
      border-color=#88c0d0

      [urgency=high]
      border-color=#bf616a
      default-timeout=0
    '';
  };

  home.file.".config/workstyle/config.toml".text = ''
  "alacritty" = ""
  "github" = ""
  "rust" = ""
  "google" = ""
  "private browsing" = ""
  "firefox" = ""
  "chrome" = ""
  "file manager" = ""
  "libreoffice calc" = ""
  "libreoffice writer" = "󰈬"
  "libreoffice" = "󰏆"
  "nvim" = ""
  "gthumb" = ""
  "menu" = ""
  "calculator" = "󰃬"
  "transmission" = ""
  "videostream" = ""
  "music" = ""
  "disk usage" = "󰋊"
  ".pdf" = "󰈦"
  "slack" = ""
  "1password" = "󰎦"
  "spotify" = ""
  "thunderbird" = ""
  "signal" = "󰈎"
  "discord" = ""

  [other]
  fallback_icon = ""
  deduplicate_icons = true 
  separator = ":"
  '';

}
