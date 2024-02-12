{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./tmux.nix
    ./starship.nix
    ./alacritty.nix
    ./zsh.nix
    ./bash.nix
    ./helix.nix
    ./nushell.nix
    ./neovim.nix
  ];

  # home.sessionVariables = {
  #   DIDTHISWORK = "yes";
  # };

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

  home.packages = with pkgs; [
    ncurses
    _1password # One password cli
    _1password-gui
    ripgrep # grep but better and faster
    eza # supported version of exa the cd replacement
    bat # Cat but with syntax highlighting
    # broot # newer tree view
    nodejs
    cargo-lambda # AWS rust lambda toolkit
    lazygit # lazygit git tool
    jq # json utility
    taskwarrior
    openjdk21
    spotify
    discord
    wget

    (nerdfonts.override {fonts = ["SpaceMono"];})

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    aws-sam-cli
    gimme-aws-creds
    rustup
    grcov # code coverage tool for rust
    pueue # background tasks
    vivid #LS_COLORS theming
    htop # activity
    bottom # another activity app written in rust
    fzf
    slack
    dua # disk usage analyzer

    nethack

    gh # github cli
    glab # gitlab cli
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";

  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
  };
}
