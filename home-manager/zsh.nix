{...}: {
  programs.zsh = {
    enable = true;
    initExtra = ''
      export LS_COLORS="$(vivid generate nord)"
      source <(atuin init zsh --disable-up-arrow)
    '';

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "vi-mode"];
    };
  };
}
