{
  config,
  pkgs,
  ...
}: let
  theme = "nord";
in {
  imports = [
    ./nushell.nix
    ./git.nix
    # ./tmux.nix
    ./starship.nix
    ./alacritty.nix
    ./zsh.nix
    ./bash.nix
    ./helix
    ./neovim.nix
    ./go.nix
    ./zellij
    ({pkgs, ...}:
      import ./vivid.nix {
        inherit pkgs;
        theme = theme;
      })
    ({lib, ...}:
      import ./bat.nix {
        inherit lib;
        theme = theme;
      })
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = config.mySystem.username;
  home.homeDirectory = config.mySystem.homeDirectory;
  home.sessionPath = ["${config.mySystem.homeDirectory}/.local/bin"];

  programs.java.enable = true;

  home.sessionVariables = {
    DEFAULT_JAVA_HOME = "${pkgs.jdk.home}";
    THEME = theme;
  };

  home.packages = with pkgs; [
    ncurses
    _1password # One password cli
    nodejs
    cargo-lambda # AWS rust lambda toolkit
    lazygit # lazygit git tool
    jq # json utility
    discord
    wget

    (nerdfonts.override {fonts = ["SpaceMono" "OpenDyslexic"];})

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # seems to be broken right now
    # aws-sam-cli

    cmake
    gnumake
    rustup
    # 2024-08-19 - compilaion error on grcov
    # grcov # code coverage tool for rust
    pueue # background tasks
    slack
    dua # disk usage analyzer
    sad # search and replace/bulk edit tool
    dust # du replacement
    viu # terminal image view

    imagemagick
    poppler
    ffmpegthumbnailer
    p7zip

    nethack

    gh # github cli
    glab # gitlab cli

    virtualenv
    unzip
    python3
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";

  programs.readline = {
    enable = true;
    variables = {
      "editing-mode" = "vi";
    };
  };

  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    # attempting to keep atuin from blocking in nushell
    settings = {
      auto_sync = false;
      update_check = false;
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-gray-blue-256";
    config = {
      color = "on";
    };
  };

  programs.tealdeer.enable = true;
  programs.bottom.enable = true;
  programs.htop.enable = true;
  programs.yazi.enable = true;
  programs.carapace.enable = true;
  programs.fish.enable = true;
  programs.ripgrep.enable = true;
  programs.broot.enable = true;
  programs.fd.enable = true;
  programs.fzf.enable = true;
}
