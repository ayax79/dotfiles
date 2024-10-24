{
  pkgs,
  lib,
  ...
}: {
  programs.alacritty = lib.mkMerge [
    {
      enable = true;
      # Start tmux by default
      settings = {
        terminal.shell = {
          program = "zsh";
          args = ["-l" "-c" "zellij"];
        };
        # # # shell = {
        #   program = "${zsh}";
        #   args = [
        #     "-l"
        #     "-c"
        #     "${tmux}"
        #   ];
        # };

        keyboard = {
          bindings = [
            {
              key = "Q";
              mods = "Command";
              action = "None";
            }
            {
              key = "W";
              mods = "Command";
              action = "None";
            }
          ];
        };

        font = {
          normal = {
            family = "SpaceMono Nerd Font Mono";
          };
          size = 12.0;
        };

        window = {
          opacity = 1;
          startup_mode = "Maximized";
        };

        # one nord
        colors = {
          primary = {
            background = "#2E3440";
            foreground = "#C8D0E0";
          };
          normal = {
            black = "#3B4252";
            red = "#BF616A";
            green = "#A3BE8C";
            yellow = "#EBCB8B";
            blue = "#81A1C1";
            magenta = "#B988B0";
            cyan = "#88C0D0";
            white = "#E5E9F0";
          };
          bright = {
            black = "#4C566A";
            red = "#BF616A";
            green = "#A3BE8C";
            yellow = "#EBCB8B";
            blue = "#81A1C1";
            magenta = "#B988B0";
            cyan = "#8FBCBB";
            white = "#ECEFF4";
          };
          search = {
            matches = {
              foreground = "#81A1C1";
              background = "#4C566A";
            };
            focused_match = {
              foreground = "#EBCB8B";
              background = "#4C566A";
            };
            # footer_bar = {
            #   background = "#434C5E";
            #   foreground = "#88C0D0";
            # };
          };
          hints = {
            start = {
              foreground = "#B988B0";
              background = "#4C566A";
            };
            end = {
              foreground = "#81A1C1";
              background = "#4C566A";
            };
          };
          selection = {
            text = "CellForeground";
            background = "#3F4758";
          };
        };

        # Nord theme colors
        # colors = {
        #   primary = {
        #     # background = "#2e3440";
        #     background = "#000000";
        #     foreground = "#d8dee9";
        #     dim_foreground = "#a5abb6";
        #   };
        #
        #   cursor = {
        #     text = "#2e3440";
        #     cursor = "#d8dee9";
        #   };
        #
        #   vi_mode_cursor = {
        #     text = "#2e3440";
        #     cursor = "#d8dee9";
        #   };
        #
        #   selection = {
        #     text = "CellForeground";
        #     background = "#4c566a";
        #   };
        #
        #   search = {
        #     matches = {
        #       foreground = "CellBackground";
        #       background = "#88c0d0";
        #     };
        #   };
        #
        #   normal = {
        #     black = "#3b4252";
        #     red = "#bf616a";
        #     green = "#a3be8c";
        #     yellow = "#ebcb8b";
        #     blue = "#81a1c1";
        #     magenta = "#b48ead";
        #     cyan = "#88c0d0";
        #     white = "#e5e9f0";
        #   };
        #
        #   bright = {
        #     black = "#4c566a";
        #     red = "#bf616a";
        #     green = "#a3be8c";
        #     yellow = "#ebcb8b";
        #     blue = "#81a1c1";
        #     magenta = "#b48ead";
        #     cyan = "#8fbcbb";
        #     white = "#eceff4";
        #   };
        #
        #   dim = {
        #     black = "#373e4d";
        #     red = "#94545d";
        #     green = "#809575";
        #     yellow = "#b29e75";
        #     blue = "#68809a";
        #     magenta = "#8c738c";
        #     cyan = "#6d96a5";
        #     white = "#aeb3bb";
        #   };
        # };
      };
    }
    (lib.optionalAttrs (lib.strings.hasInfix "darwin" pkgs.system) {
      settings.window.option_as_alt = "Both";
    })
  ];
}
