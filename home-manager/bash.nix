{...}: {
  programs.bash = {
    enable = true;
    profileExtra = ''
      # hack to deal with https://github.com/nix-community/home-manager/issues/3100
      unset __HM_SESS_VARS_SOURCED
      . "/Users/jack.wright/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
  };
}
