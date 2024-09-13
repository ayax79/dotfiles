{pkgs, config, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "jack-nord";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
    };
    languages = {
      language-server.rust-analyzer = {
        command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      };
    };
  };

  home.file."${config.xdg.configHome}/helix" = {
    source = ./helix;
    recursive = true;
  };
}
