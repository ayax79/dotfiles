{
  pkgs,
  config,
  ...
}: {
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
      language = [
        {
          name = "rust";
          debugger = {
            command = "~/.local/share/nvim/mason/bin/codelldb";
            name = "codelldb";
            port-arg = "--port {}";
            transport = "tcp";
            templates = [
              {
                name = "binary";
                request = "launch";
                completion = [
                  {
                    completion = "filename";
                    name = "binary";
                  }
                ];
                args = {
                  program = "{0}";
                  runInTerminal = true;
                };
              }
            ];
          };
        }
      ];
    };
  };

  home.file."${config.xdg.configHome}/helix" = {
    source = ./helix;
    recursive = true;
  };
}
