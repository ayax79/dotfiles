{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zellij
  ];

  home.file."${config.xdg.configHome}/zellij" = {
    source = ./zellij;
  };

  # home.file."${config.xdg.cacheHome}/zellij/zellij-autolock.wasm" = {
  #   source = builtins.fetchurl {
  #     url = "https://github.com/fresh2dev/zellij-autolock/releases/download/0.1.0/zellij-autolock.wasm";
  #     sha256 = "19dsm3f0smvjicncm0zczzvv99853p27a3c4c9xrk6j8hhvmvaxb";
  #   };
  # };
}
