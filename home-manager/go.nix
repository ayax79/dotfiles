{pkgs, ...}: {
  home.packages = with pkgs; [
    gopls
    golangci-lint
  ];
  
  programs.go = {
    enable = true;
  };
}
