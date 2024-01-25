{...}: {
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "vi-mode"];
    };
    # envExtra = ''
    #   # hack to deal with https://github.com/nix-community/home-manager/issues/3100
    #   unset __HM_SESS_VARS_SOURCED
    #   source "/Users/jack.wright/.nix-profile/etc/profile.d/hm-session-vars.sh"
    # '';
  };
}
