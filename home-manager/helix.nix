{pkgs, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
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
}
