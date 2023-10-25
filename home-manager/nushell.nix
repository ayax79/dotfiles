{
  config,
  pkgs,
  ...
}: {
  programs.nushell = {
    enable = true;
    package = pkgs.nushell.override {
      additionalFeatures = p: ["extra" "dataframe"];
    };
    configFile.source = ./nushell/config.nu;
    envFile.source = ./nushell/env.nu;
    extraConfig = ''
      source ${config.home.homeDirectory}/.cache/atuin/init.nu
    '';
    extraEnv = ''
      let atuin_cache = "${config.home.homeDirectory}/.cache/atuin"
      if not ($atuin_cache | path exists) {
         mkdir $atuin_cache
      }
      ${config.home.homeDirectory}/.nix-profile/bin/atuin init nu --disable-up-arrow | save --force ${config.home.homeDirectory}/.cache/atuin/init.nu
    '';
  };
}
