{pkgs, ...}: {
  home.packages = with pkgs; [
    hadolint
    dprint
    yq
    tree-sitter
    nil # nix language server
    jdt-language-server # java language server
    nodePackages.vscode-langservers-extracted
    yaml-language-server # YAML language server
    efm-langserver # EFM language server
    terraform-lsp # terrform language server
    nodePackages.pyright # Pyright language server
    alejandra # Alejandra nix formatting
    # Lua language server
    (lua-language-server.overrideAttrs (finalAttrs: previousAttrs: {
      version = "3.9.1";
      src = fetchFromGitHub {
        owner = "luals";
        repo = "lua-language-server";
        rev = finalAttrs.version;
        hash = "sha256-M4eTrs5Ue2+b40TPdW4LZEACGYCE/J9dQodEk9d+gpY=";
        fetchSubmodules = true;
      };
    }))
    vscode-extensions.vscjava.vscode-java-test
    # Currently broken on the mac
    # vscode-extensions.vadimcn.vscode-lldb.adapter
    coursier
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ":luafile ~/.config/nvim/init.lua";
    plugins = with pkgs; [
      vimPlugins.lazy-nvim
    ];
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
}
