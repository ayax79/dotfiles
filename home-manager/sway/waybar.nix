{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        name = "bar1";
        height = 40;
        margin-top = 7;
        margin-right = 7;
        margin-left = 7;
        modules-left = ["sway/workspaces" "sway/mode" "sway/window"];
        modules-center = [];
        modules-right = ["keyboard-state" "pulseaudio" "backlight" "network" "cpu" "memory" "battery" "clock" "tray"];
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
          "format-charging" = "{capacity}%";
          "format-plugged" = "  {capacity}%";
          # "format-alt" = "{time} {icon}";
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
          "format" = "{icon}  {volume}% {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = "  {icon}  {format_source}";
          # "format-muted" = "   {format_source}";
          "format-muted" = "󰝟";
          # "format-muted" = "󰝟{format_source}";
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
        "keyboard-state" = {
          "capslock" = true;
          "format" = {
            "capslock" = "{icon}";
          };
          "format-icons" = {
            "locked" = "";
            # "unlocked" = "";
            "unlocked" = "";
          };
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

      window.bar1#waybar {
        /* background-color: @nord0; */
        background-color: rgba(46, 52, 64, 0.87);
      }

      * {
          font-family: SpaceMono Nerd Font;
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
          opacity: 1.0;
          margin-left: 10px;
          color: @nord6;
          font-weight: bold;
          padding: 0px 5px;
      }

      /*
      * Right part
      */
      #keyboard-state label.locked,
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
          padding: 0px 12px;
          color: @nord6;
      }

      #keyboard-state label.locked,
      #backlight,
      #language,
      #battery,
      #clock,
      #tray {
          margin-right: 8px;
          border-top-right-radius: 5px;
          border-bottom-right-radius: 5px;
      }

      #keyboard-state label.locked,
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

      #keyboard-state label.locked,
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
}
