{pkgs, ...}: {
  programs.nushell = {
    enable = true;
    package = pkgs.nushell.override {
      additionalFeatures = p: ["dataframe" "extra"];
    };
    configFile.source = ./nushell/config.nu;
    envFile.source = ./nushell/env.nu;
  };
}
