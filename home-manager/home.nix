# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = config.currentSystem.username;
  home.homeDirectory = config.currentSystem.homeDirectory;

  home.packages = [
    pkgs.alacritty
    pkgs.zsh
    pkgs.ncurses
    pkgs.atuin # Fancy history
    pkgs._1password # One password cli
    pkgs.ripgrep # grep but better and faster
    #pkgs.eza                                            # supported version of exa the cd replacement
    pkgs.bat # Cat but with syntax highlighting
    pkgs.broot # newer tree view
    pkgs.nodejs
    pkgs.cargo-lambda # AWS rust lambda toolkit

    ## Neovim related
    pkgs.neovim
    pkgs.hadolint
    pkgs.dprint
    pkgs.yq
    #pkgs.markdownlint-cli
    pkgs.tree-sitter
    # pkgs.luarocks
    pkgs.nil # nix language server
    pkgs.jdt-language-server # java language server
    pkgs.nodePackages.vscode-json-languageserver # json language server
    pkgs.nodePackages.vscode-html-languageserver-bin # HTML language server
    pkgs.yaml-language-server # YAML language server
    pkgs.efm-langserver # EFM language server
    pkgs.terraform-lsp # terrform language server
    pkgs.nodePackages.pyright # Pyright language server
    pkgs.alejandra # Alejandra nix formatting

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override {fonts = ["SpaceMono"];})

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    pkgs.aws-sam-cli
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  programs.starship = {
    enable = true;
    settings = {
      shell = {
        nu_indicator = "󱆀";
        zsh_indicator = "󱍢";
      };
    };
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.nord
      tmuxPlugins.better-mouse-mode
    ];

    extraConfig = ''
      set-option -g status-position top
      set-option default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"
      set-option -a terminal-overrides ",alacritty:RGB"

      set -g mouse

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator

      # Set new panes to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # decide whether we're in a Vim process
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'

      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -n 'C-Space' if-shell "$is_vim" 'send-keys C-Space' 'select-pane -t:.+'

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
      bind-key -T copy-mode-vi 'C-Space' select-pane -t:.+
    '';
  };

  programs.git = {
    enable = true;
    userName = "Jack Wright";
    userEmail = "jack.wright@disqo.com";
    aliases = {
      st = "status";
      ci = "commit";
      co = "checkout";
    };
    extraConfig = {
      color = {
        status = "auto";
        diff = "auto";
        branch = "auto";
        interactive = "auto";
        ui = "auto";
        sh = "auto";
      };
      push = {
        default = "tracking";
      };
      "filter \"media\"" = {
        required = true;
        clean = "${pkgs.git}/bin/git media clean %f";
        smudge = "${pkgs.git}/bin/git media smudge %f";
      };

      merge = {
        conflictstyle = "diff3";
        stat = true;
      };

      diff = {
        ignoreSubmodules = "dirty";
        renames = "copies";
        mnemonicprefix = true;
      };

      advice = {
        statusHints = false;
        pushNonFastForward = false;
        objectNameWarning = "false";
      };
    };

    ignores = [
      "#*#"
      "*.a"
      "*.agdai"
      "*.aux"
      "*.dylib"
      "*.elc"
      "*.glob"
      "*.hi"
      "*.la"
      "*.lia.cache"
      "*.lra.cache"
      "*.nia.cache"
      "*.nra.cache"
      "*.o"
      "*.so"
      "*.v.d"
      "*.v.tex"
      "*.vio"
      "*.vo"
      "*.vok"
      "*.vos"
      "*~"
      ".*.aux"
      ".Makefile.d"
      ".clean"
      ".coq-native/"
      ".coqdeps.d"
      ".direnv/"
      ".envrc"
      ".envrc.cache"
      ".envrc.override"
      ".ghc.environment.x86_64-darwin-*"
      ".makefile"
      ".pact-history"
      "TAGS"
      "cabal.project.local*"
      "default.hoo"
      "default.warn"
      "dist-newstyle/"
      "ghc[0-9]*_[0-9]*/"
      "input-haskell-*.tar.gz"
      "input-haskell-*.txt"
      "result"
      "result-*"
      "tags"
      ".idea"
      ".gitlab.vim"
      ".DS_Store"
    ];
  };
}
