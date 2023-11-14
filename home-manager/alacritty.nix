{pkgs, ...}: let
  tmux = "${pkgs.tmux}/bin/tmux";
  zsh = "${pkgs.zsh}/bin/zsh";
in {
  programs.alacritty = {
    enable = true;

    # Start tmux by default
    settings = {
      shell = {
        program = "${zsh}";
        args = [
          "-l"
          "-c"
          # "(${tmux} attach || ${tmux})"
          "${tmux}"
        ];
      };

      font = {
        normal = {
          family = "SpaceMono Nerd Font Mono";
        };
        size = 12.0;
      };

      # mac option behavior
      window = {
        option_as_alt = "Both";
        opacity = 0.95;
      };

      # Nord theme colors
      colors = {
        primary = {
          background = "#2e3440";
          foreground = "#d8dee9";
          dim_foreground = "#a5abb6";
        };

        cursor = {
          text = "#2e3440";
          cursor = "#d8dee9";
        };

        vi_mode_cursor = {
          text = "#2e3440";
          cursor = "#d8dee9";
        };

        selection = {
          text = "CellForeground";
          background = "#4c566a";
        };

        search = {
          matches = {
            foreground = "CellBackground";
            background = "#88c0d0";
          };
          footer_bar = {
            background = "#434c5e";
            foreground = "#d8dee9";
          };
        };

        normal = {
          black = "#3b4252";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#88c0d0";
          white = "#e5e9f0";
        };

        bright = {
          black = "#4c566a";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#8fbcbb";
          white = "#eceff4";
        };

        dim = {
          black = "#373e4d";
          red = "#94545d";
          green = "#809575";
          yellow = "#b29e75";
          blue = "#68809a";
          magenta = "#8c738c";
          cyan = "#6d96a5";
          white = "#aeb3bb";
        };
      };
    };
  };
}
