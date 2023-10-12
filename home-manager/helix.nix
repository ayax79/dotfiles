{pkgs, ...}: {
  home.packages = [
    pkgs.helix
  ];

  home.file."./.config/helix/" = {
    source = ./helix;
    recursive = true;
  };
}
