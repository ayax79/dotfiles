{...}: {
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "vi-mode"];
    };
    envExtra = ''
      # Source local environment variables if file exists
      if [ -f "$HOME/.local.env" ]; then
        source "$HOME/.local.env"
      fi
    '';
  };
}
