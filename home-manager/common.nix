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
    pkgs.lazygit # lazygit git tool

    (pkgs.nerdfonts.override {fonts = ["SpaceMono"];})

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    pkgs.aws-sam-cli
  ];


  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

}
