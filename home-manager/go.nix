{pkgs, ...}: {
  home.packages = with pkgs; [
    golangci-lint
  ];
  
  programs.go = {
    enable = true;
  };
}
