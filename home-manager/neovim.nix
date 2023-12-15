{pkgs, ...}: {
  home.packages = [
    pkgs.hadolint
    pkgs.dprint
    pkgs.yq
    pkgs.tree-sitter
    pkgs.nil # nix language server
    pkgs.jdt-language-server # java language server
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.yaml-language-server # YAML language server
    pkgs.efm-langserver # EFM language server
    pkgs.terraform-lsp # terrform language server
    pkgs.nodePackages.pyright # Pyright language server
    pkgs.alejandra # Alejandra nix formatting
    pkgs.lua-language-server # Lua language server
    pkgs.vscode-extensions.vscjava.vscode-java-test
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ":luafile ~/.config/nvim/init.lua";
    plugins = [
      pkgs.vimPlugins.lazy-nvim
    ];
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
}
