{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jack.wright";
  home.homeDirectory = "/Users/jack.wright";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.ncurses

    ## fancy history 
    pkgs.atuin

    ## Neovim related
    pkgs.neovim
    pkgs.hadolint
    pkgs.yq
    pkgs.markdownlint-cli
    pkgs.tree-sitter
    pkgs.luarocks
    pkgs.nil                    # nix language server

    pkgs._1password


    pkgs.ripgrep
    pkgs.eza
    pkgs.bat
    pkgs.zsh

    # newer tree view
    pkgs.broot 
    # newer process viewer

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "SpaceMono" ]; })


    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
 
  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jack.wright/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  # home.sessionVariables = {
  #   # EDITOR = "emacs";
  # };
  #

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
}
