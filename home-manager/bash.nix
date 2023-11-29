{...}: {
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export LS_COLORS="$(vivid generate nord)"
      source <(atuin init zsh --disable-up-arrow)
    '';
  };
}
