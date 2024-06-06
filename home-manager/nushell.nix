{config, pkgs, ...}: {
  programs.nushell = {
    enable = true;
    configFile.source = ./nushell/config.nu;
    envFile.source = ./nushell/env.nu;
  };

  home.file."${config.xdg.configHome}/nushell/ext" = {
    source = ./nushell/ext;
  };
}
