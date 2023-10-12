{...}: {
  programs.zsh = {
    enable = true;
    initExtra = ''
        source <(atuin init zsh)
     '';

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "vi-mode"];
    };
  };
}
