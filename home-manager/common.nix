{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nushell.nix
    ./git.nix
    ./tmux.nix
    ./starship.nix
    ./alacritty.nix
    ./zsh.nix
    ./bash.nix
    ./helix.nix
    ./neovim.nix
    ./go.nix
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
};

  home.packages = with pkgs; [
    ncurses
    _1password # One password cli
    ripgrep # grep but better and faster
    eza # supported version of exa the cd replacement
    bat # Cat but with syntax highlighting
    fd
    broot # newer tree view
    nodejs
    cargo-lambda # AWS rust lambda toolkit
    lazygit # lazygit git tool
    jq # json utility
    taskwarrior
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

    rustup
    # 2024-08-19 - compilaion error on grcov
    # grcov # code coverage tool for rust
    pueue # background tasks
    vivid #LS_COLORS theming
    htop # activity
    bottom # another activity app written in rust
    fzf
    slack
    dua # disk usage analyzer
    sad # search and replace/bulk edit tool 

    nethack

    gh # github cli
    glab # gitlab cli

    carapace # shell completion
    fish
    virtualenv
    unzip
    python3

  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";

  programs.atuin = {
    enable = true;
    enableNushellIntegration = false;
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
}
