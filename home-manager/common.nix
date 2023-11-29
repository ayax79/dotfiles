{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./neovim.nix
    ./tmux.nix
    ./starship.nix
    ./alacritty.nix
    ./zsh.nix
    ./bash.nix
    ./helix.nix
    ./nushell.nix
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
  home.username = config.mySystem.username;
  home.homeDirectory = config.mySystem.homeDirectory;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    ncurses
    atuin # Fancy history
    _1password # One password cli
    _1password-gui
    ripgrep # grep but better and faster
    eza # supported version of exa the cd replacement
    bat # Cat but with syntax highlighting
    broot # newer tree view
    nodejs
    cargo-lambda # AWS rust lambda toolkit
    lazygit # lazygit git tool
    jq # json utility
    taskwarrior
    openjdk21
    spotify
    discord
    bash
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
    pueue # background tasks
    vivid #LS_COLORS theming
    htop # activity
    bottom # another activity app written in rust
    fzf
    slack
  ];

  # programs._1password-gui = {
  #   enable = true;
  #   # Certain features, including CLI integration and system authentication support,
  #   # require enabling PolKit integration on some desktop environments (e.g. Plasma).
  #   polkitPolicyOwners = ["jack"];
  # };
  #
  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
